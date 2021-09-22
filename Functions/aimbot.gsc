toggleAimbot( azza )
{
    if(IsDefined( self.smoothaim ))
        return self IPrintLn( "Please turn off smooth aim before using this feature." );
    if(!isDefined(self.aimbotT) || isDefined( azza ))
    {
        if(!isDefined( self.aimbot ))
            self.aimbot = [];
        if(!IsDefined( self.realisticSize ))
            self.realisticSize = 10;
        self.aimbotT       = true;
        self thread aimbotSystem();
    }
    else
    {
        self.aimbotT = undefined;
        self notify("stop_aimbot");
    }
} 

aimbotSystem()
{
    self endon("disconnect");
    level endon("game_ended");
    self endon("stop_aimbot");

    for(;;)
    {
        if( !isDefined( self.aimbot["autoShootCheck"] ) )
            self waittill("weapon_fired");
        if(self canUseAimbot())
        {
            target = undefined;
            foreach(person in level.players)
            {
                if(person == self || !isAlive(person) || level.teamBased && self.team == person.team)
                    continue;
                get_target = self getAimbotTarget(person, target);
                if( IsDefined( get_target ) )
                    target = get_target;
            }   
                
            if( isDefined( target ) )
            {   
                if( isDefined( self.aimbot["lockOnCheck"] ) )
                    self setplayerangles(VectorToAngles((target getTagOrigin("pelvis")) - (self getTagOrigin("pelvis"))));
                
                //if( IsDefined( self.aimbot["autoShootCheck"] ) )    
                    self fakeShoot( target ); 
                
                if( isDefined( self.aimbot["unfairCheck"] ) )
                {
                    target thread [[level.callbackPlayerDamage]](self, self, 500, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "j_spinelower", 0, 0 );
                    playfx( level._effect[ "blood"], target gettagorigin( "j_spinelower" ) );
                }
            } 
        }
        wait 0.5;
    }
} 

canUseAimbot()
{
    if(isDefined(self.aimbot["sniperCheck"]) && weaponClass(self getCurrentWeapon()) != "sniper") 
        return false;
    if(isDefined(self.aimbot["groundCheck"]) && self isOnGround()) 
        return false;   
    if(isDefined(self.aimbot["adsCheck"]) && !self adsButtonPressed())  
        return false;   
    return true;
}

getAimbotTarget( current, mostRecent ) 
{ 
    if(isDefined(self.aimbot["visibleCheck"]) && !self can_hit_enemy( current ) )
        return undefined;
    if(isDefined(self.aimbot["realisticCheck"]) && !self can_hit_enemy(current, self.realisticSize))
        return undefined;
    if(!isDefined(mostRecent))
        return current;
    if(closer(self getTagOrigin("j_head"), current getTagOrigin("j_head"), mostRecent getTagOrigin("j_head"))) 
        return current;
    return mostRecent;
} 

can_hit_enemy( enemy, size )
{
    ang = 40; //10 - LEGIT | 45 - MAX VIEW | 30 - DECENT
    if( IsDefined( size ) )
        ang = size;
    weaporig = self getMuzzlePos();
    dir      = anglestoforward( self getMuzzleAngle() );
    if( isalive( enemy ) )
    {
        enemydir = vectornormalize( enemy geteye() - weaporig );
        if( vectordot( dir, enemydir ) > cos( ang ) && bulletTracePassed( self GetEye(), enemy GetEye(), false, self ) )
            return true;
    }
    return false; 
}

getMuzzlePos()
{
    return self getTagOrigin( "tag_weapon_right" );
}

getMuzzleAngle()
{
    return self GetTagAngles( "tag_weapon_right" );
}

aimbotChecks( check, opt )
{
    if(!isDefined(self.aimbot[check]))
        self.aimbot[check] = true;
    else
        self.aimbot[check] = undefined;
    
    if( isDefined(self.aimbotT) )   
    {
        self endon("stop_aimbot");
        self thread aimbotSystem();
    }
}

realisticRange( range )
{
    self.realisticSize = int(range);
} 

fakeShoot( target ) 
{
    name = self getCurrentWeapon();
    ammo = self getWeaponAmmoClip( name );  
    
    if(self getCurrentWeapon() == "none" || self isReloading() || self isOnLadder() || self isMantling() || self isSwitchingWeapon() || ammo <= 0 )
        return;
        
    if( !isDefined(self.aimbot["trail"]) && weaponClass( self getcurrentweapon() ) == "sniper")
        target thread [[level.callbackPlayerDamage]](self, self, RandomIntRange( 90, 120 ), 0, "MOD_RIFLE_BULLET", self getcurrentweapon(), (0,0,0), (0,0,0), "spinelower", 0, 0 );
    else 
        magicbullet( self getcurrentweapon(), self gettagorigin( "tag_flash" ), target gettagorigin( "j_spinelower" ), self );  
        
    if(!isAlive(target))
        playfx( level._effect[ "money" ], target gettagorigin( "j_spinelower" ) );
    
    self setWeaponAmmoClip(name, ammo-1);   
    wait weaponfiretime( name );        
}
    
azzaPreset()
{
    if(isDefined(self.triggerBot) || isDefined(self.unfairPreset) || isDefined(self.sniperPreset))
        return self iprintln("^1Error^7: Please turn off Triggerbot before using azza presets.");

    if(!isDefined(self.azzaPreset))
    {
        self.azzaPreset = true;
        self resetAllPresets();     
        self notify("stop_aimbot");
        self toggleAimbot( true );
    }
    else
        self resetAllPresets( true );
    
    self aimbotChecks("sniperCheck", 1);
    self aimbotChecks("groundCheck", 2);
    self aimbotChecks("realisticCheck", 4);
    self aimbotChecks("trail", 10);
}

unfairPreset()
{
    if(isDefined(self.triggerBot) || isDefined(self.azzaPreset) || isDefined(self.sniperPreset))
        return self iprintln("^1Error^7: Please turn off other presets before using unfair presets.");
        
    if(!isDefined(self.unfairPreset))
    {
        self.unfairPreset = true;
        self resetAllPresets();     
        self notify("stop_aimbot");
        self toggleAimbot( true );
    }
    else
        self resetAllPresets( true );
    
    self aimbotChecks("unfairCheck", 7);
    self aimbotChecks("lockOnCheck", 5);
}

sniperPreset()
{
    if(isDefined(self.triggerBot) || isDefined(self.azzaPreset) || isDefined(self.unfairPreset))
        return self iprintln("^1Error^7: Please turn off other presets before using sniper presets.");
    
    if(!isDefined(self.sniperPreset))
    {
        self.sniperPreset = true;
        self resetAllPresets();     
        self notify("stop_aimbot");
        self toggleAimbot( true );
    }
    else
        self resetAllPresets( true );       
    
    self aimbotChecks("sniperCheck", 1);
    self aimbotChecks("visibleCheck", 2);
    self aimbotChecks("realisticCheck", 4);
}

resetAllPresets( all )
{
    if(isDefined(all))
    {
        self.triggerBot = undefined;
        self.azzaPreset = undefined;
        self.unfairPreset = undefined;
        self.sniperPreset = undefined;
        self toggleAimbot();
    }
    
    self setMenuText();
    foreach(check in self.aimbot)
        check = undefined;
    self realisticRange( 25 );
} 

toggle_smooth_aim()
{
    if(IsDefined( self.aimbotT )) 
        return self IPrintLn( "Please turn off aimbot to use this feature." );
        
    if(!IsDefined( self.smoothaim ))
    {
        self.smoothaim = true;
        self thread do_smooth_aim();
    }
    else 
        self.smoothaim = undefined;
}

do_smooth_aim()
{
    self endon("disconnect");
    while(IsDefined( self.smoothaim ))
    {
        if(self AdsButtonPressed())
        {
            target = undefined;
            foreach(player in level.players)
            {                    
                if(player == self || !isAlive(player) || level.teamBased && self.team == player.team)
                    continue;
                get_target = self getTarget(player, target);
                if( IsDefined( get_target ) )
                    target = get_target;
                    
            }
            self thread smoothAim(target);
        }
        wait .05;
    }
}

smoothAim(player)
{
    //Reset for new targets
    if( !IsDefined( self.smooth_target ) || IsDefined( self.smooth_target ) && self.smooth_target != player GetEntityNumber() || self.curAimTime < 1.2 || !IsAlive( player ) )
    {
        self.smooth_target = player GetEntityNumber();
        self.curAimTime    = 10;
        return;
    }
    
    m_AimTime       = 1.1;
    self.curAimTime -= 1;
    
    //Don't want to scale below 1
    if(self.curAimTime < m_AimTime)
        self.curAimTime = m_AimTime;
    
    viewAngles = self getPlayerAngles();
    toAngles   = VectorToAngles(player getTagOrigin("pelvis") - self GetEye());
    
    smoothingfactor = self.curAimTime; 
    smoothangles    = (angleNormalize180( toAngles[0] - viewAngles[0]), angleNormalize180( toAngles[1] - viewAngles[1]), 0 );
    smoothangles   /= smoothingfactor; 
    self setplayerangles( (angleNormalize180( viewAngles[0] + smoothangles[0] ), angleNormalize180( viewAngles[1] + smoothangles[1] ), 0) );
}   
