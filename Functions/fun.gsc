superJump( height )
{
    if(!IsDefined( self.superJump ))
    {
        self.superJump = true;
        self thread doSuperJump( int(height) );
        self thread setAllPerks();
    }
    else 
    {
        self.superJump = undefined;
        self notify("stop_superjump");
    }
}

doSuperJump( height )
{
    self endon("disconnect");
    self endon("stop_superjump");
    
    self notifyOnPlayerCommand( "jump", "+gostand" );
    wait .2;
    while( IsDefined( self.superJump ) )
    {
        self waittill("jump");
        if(!self IsOnGround() && !self IsMantling())
        {
            for(e=0;e<height;e++)
            {
                self setVelocity(self getVelocity() + (0, 0, 333));
                wait .05;
            }
            while(!self IsOnGround())
                wait .05;
        }
        wait .05;
    }
}

carepackageGun()
{
    if( !IsDefined( self.carepackageGun ) )
    {
        self.carepackageGun = true;
        self thread DoCarepackageGun();
    }
    else 
    {
        self.carepackageGun = undefined;
        self notify("end_carepackageGun");
    }
}

doCarepackageGun()
{
    self endon("disconnect");
    self endon("end_carepackageGun");
    
    for(;;)
    {
        self waittill( "weapon_fired" );
        self thread launchCarepackage();
    } 
}

launchCarepackage()
{
    trace        = BulletTrace( self getTagOrigin("tag_eye"), anglestoforward(self getPlayerAngles())*100000, 0, self)["position"];
    crate        = modelSpawner( self gettagorigin( "tag_weapon_right" ), "com_plasticcase_friendly", self GetPlayerAngles(), undefined, level.airDropCrateCollision );
    crate PhysicsLaunchServer( (0,0,0), anglestoforward(self getplayerangles())*1100 );
    crate waittill( "physics_finished" );
    
    location = crate.origin;
    forward = ( location + ( 0, 0, 1 ) ) - location;   
    
    crate SetModel( "com_plasticcase_enemy" );
    thread play_sound_in_space( "javelin_clu_lock", location );
    wait 1;
    playfx ( level.c4Death, location, forward ); //level.mine_explode
    thread play_sound_in_space( "detpack_explo_default", location );
    crate RadiusDamage( location, 400, 200, 50, self.owner, "MOD_EXPLOSIVE", "airdrop_trap_explosive_mp" ); 
    crate delete();
}

skyTrip()
{
    if(!isDefined(self.skytrip))
    {
        self.skytrip = true;
        if( self hasMenu() ) self thread refreshMenu();
        
        firstOrigin = self.origin;
        tripShip = modelSpawner(self.origin, "tag_origin");
        self playerLinkTo(tripShip);
        
        tripShip MoveTo(firstOrigin+(0,0,2500),4);
        wait 6;
        tripShip MoveTo(firstOrigin+(0,4800,2500),4);
        wait 6;
        tripShip MoveTo(firstOrigin+(4800,2800,2500),4);
        wait 6;
        tripShip MoveTo(firstOrigin+(-4800,-2800,7500),4);
        wait 6;
        tripShip MoveTo(firstOrigin+(0,0,2500),4);
        wait 6;
        tripShip MoveTo(firstOrigin+(25,25,60),4);
        wait 4;
        tripShip MoveTo(firstOrigin+(0,0,30),1);
        wait 1;
        tripShip delete();
        
        self notify( "reopen_menu" );
        
        self.skytrip = undefined;
    }
    else
        self iPrintln("Wait For The Current Sky Trip To Finish");
}
  
toggleKillText()
{
    if( !isDefined( self.killtxt ) )
    {
        self.killtxt = true;
        self thread loopKillText();
    }
    else
    {
        self.killtxt = undefined;
        self notify("stop_kill_text");
    }
}  
    
loopKillText()
{
    self endon("disconnect");
    self endon("stop_kill_text");
    
    messages = strTok( "You Okay Pal?;Alright Alright Alright;Die Mofo;Lets Go!;Wasted;Much Skill;Much H4X;420 Cod Noscope;Shhht;Nice Shot;Owned;Pow Pow Pow;xD;LOL;Take This;I'm The Best;Hell Yeah!", ";" );
    kills = self.kills;
    for(;;)
    {
        if(kills < self.kills)
        {
            self iPrintlnBold("^", randomInt( 7 ) + Messages[ randomInt( Messages.size ) ]);
            kills = self.kills;
        }
        wait .1;
    }
}

randomFxSpawn(Fx)
{
    if(!isDefined(level.spawnRandomFx))
    {
        level.spawnRandomFx = Fx;
        level.randomFxSpawn = [];
        menu = self getCurrentMenu(); curs = self getCursor();
        self arrySetColour(level.randomFxSpawn, menu, curs);
        while(isDefined(level.spawnRandomFx))
        {
           x = randomIntRange(-2000,2000); y = randomIntRange(-2000,2000); z = randomIntRange(500,1500);
           level.randomFxSpawn[level.randomFxSpawn.size] = spawnFx(level._effect[Fx], self.origin + (x, y, z));
           triggerFx(level.randomFxSpawn[level.randomFxSpawn.size-1]);
           level.randomFxSpawn[level.randomFxSpawn.size-1] thread deleteSpawn( .2 );
           wait 0.05;
        }
        self arrySetColour(level.spawnRandomFx, menu, curs);
    }
    else level.spawnRandomFx = undefined;
}

randomModelSpawn( model )
{
    if(!isDefined(level.randomModelSpawnActive))
    {
        level.randomModelSpawnActive = model;
        level.randomModelSpawn       = [];
        menu                         = self getCurrentMenu(); curs = self getCursor();
        self arrySetColour(level.randomModelSpawnActive, menu, curs);
        while(isDefined(level.randomModelSpawnActive))
        {
           x = randomIntRange(-2000,2000); y = randomIntRange(-2000,2000); z = randomIntRange(500,1500);
           level.randomModelSpawn[level.randomModelSpawn.size] = modelspawner(self.origin + (x, y, z), model);
           level.randomModelSpawn[level.randomModelSpawn.size-1] thread delayedFall( 8 );
           wait 0.08;
        }
        self arrySetColour(level.randomModelSpawnActive, menu, curs);
    }
    else level.randomModelSpawnActive = undefined;
}

fxMan( fx )
{
    if(!isDefined(self.fxMan))
    {
        self.fxMan = fx;
        menu       = self getCurrentMenu(); curs = self getCursor();
        while(isDefined(self.fxMan))
        {
            for(Ext = 0; Ext < level.boneTags.size; Ext++)
            {
                effect = spawnFx(level._effect[ fx ], self getTagOrigin(level.boneTags[Ext]));
                triggerFx( effect );
                effect thread deleteSpawn( .2 );
            }
            wait .2;
        }
    }
    else 
        self.fxMan = undefined;
}
    
spawnGeyser()
{
    if(!isDefined(self.geyser))
    {
        self.geyser = true;
        geyser = modelSpawner(self.origin, "tag_origin");
        geyser thread monitorGeyser( self );
    }
    else 
        self.geyser = undefined;
} 

monitorGeyser( who )
{
    level endon("game_ended");

    while(isDefined(who.geyser))
    {
        PlayFX(level._effect[ "heliwater" ], self.origin);
        
        foreach(player in level.players)
        {
            if(distance(self.origin, player.origin) < 50) 
            {
                for(i = 0; i < 20; i++)
                    playFx(level._effect["snowhit"], self.origin + (0,0, 0 + (i*25)));
                player setOrigin(player.origin);
                player setVelocity(player getVelocity() + (0, 0, 350));
            }
        }
        wait .05;
    }
    self delete();
}

//weapon_riot_shield_mp
riotSmash()
{
    if(!isDefined(self.riotSmash))
    {
        self.riotSmash = true;
        self giveWeap( "riotshield_mp" );
        while(isDefined( self.riotSmash ))
        {
            if(self getCurrentWeapon() == "riotshield_mp" && self meleeButtonPressed())        
            {   
                self thread sheildLaunched();
                wait .8;
            }
            wait .05;
        }
    }
    else 
        self.riotSmash = undefined;
}

sheildLaunched()
{
    if( self getCurrentWeapon() == "riotshield_mp" && self meleeButtonPressed() )        
    {   
        sheild = modelSpawner(self getEye() + anglesToForward( self getPlayerAngles() )*20, "weapon_riot_shield_mp", self getPlayerAngles());
        vector    = anglesToForward( sheild.angles );
        forward   = sheild.origin + ( vector[0]*45,vector[1]*45,vector[2]*45 )*30;
        collision = bulletTrace(sheild.origin, forward, false, sheild)["position"];
        
        time = calcDistance( 600, sheild.origin, collision );
        sheild moveTo(collision, time);
        wait time;
        
        sheild radiusDamage(sheild.origin, 250, 250, 150, self);
        playFx(level.c4Death, sheild.origin); 
        thread play_sound_in_space( "detpack_explo_default", sheild.origin );
        earthquake( 0.15, 0.5, sheild.origin, 250 );
        
        wait .05;
        sheild delete();
    }
}

sheildProtector()
{
    if( !isDefined( self.sheildProtector ) )
    {
        self.sheildProtector = true;
        self AllowSprint( false );
        rotateSheilds = modelSpawner(self.origin, "tag_origin");    
        sheilds = [];
        for(e=0;e<4;e++)
        {
            sheilds[e] = modelSpawner(self.origin + (cos(e*90)*35, sin(e*90)*35, 30), "weapon_riot_shield_mp", (0,0 + e*90,0));
            sheilds[e] linkTo(rotateSheilds);
        }
        while( isDefined( self.sheildProtector ) )
        {
            rotateSheilds.origin = self.origin + (0,0,2) + AnglesToForward( self.angles )*10;
            rotateSheilds rotateyaw( 360, .3 );
            wait .01;
        }
        rotateSheilds delete();
        for(e=0;e<4;e++)
            sheilds[e] thread DelayedFall(3);
        self AllowSprint( true ); 
    }
    else self.sheildProtector = undefined;
}

clusterGrenade()
{
    self endon("disconnect");
    level endon("ended_game");
    if(!isDefined(self.cluster))
    {
        self.cluster = true;
        while(isDefined(self.cluster))
        {
            self waittill( "grenade_fire", grenade, weapon_name );
            if(!isDefined(self.cluster))   return;
            while(isDefined( grenade ))
            {
                origin = grenade.origin;
                wait .1;
            }
            //for(e=0;e<10;e++) self MagicGrenadeType(weapon_name, origin, getRandomThrowSpeed(), (1.5 + e / 10));
        }
    }
    else
        self.cluster = undefined;
}

lightProtector()
{
    self endon( "disconnect" );

    if(!isDefined(self.lightProtect))
    {
        self.lightProtect = true;
        
        entity = modelSpawner(self.origin + (0,0,80), "tag_origin", (0,36,0) );
        wait .1;
        PlayFXOnTag( level._effect["ac130_light_red"], entity, "tag_origin" ); 
        
        while(isDefined(self.lightProtect))
        {
            foreach(players in level.players)
            {
                if(players == self || !isAlive(players) || level.teamBased && self.team == players.team)
                    continue;
            
                if(distance(players.origin, self.origin) < 700)
                {
                    time = calcDistance(540, entity.origin, players.origin);
                    entity thread moveToOriginOverTime(players.origin, time, players, (0,0,70));
                    wait time;
                    players thread [[level.callbackPlayerDamage]](self, self, 100, 0, "MOD_RIFLE_BULLET", self getcurrentweapon(), (0,0,0), (0,0,0), "spinelower", 0, 0 );
                    wait .1;
                    time = calcDistance(540, entity.origin, self.origin);
                    entity thread moveToOriginOverTime(self.origin, time, self, (0,0,80));
                    wait time;
                }
            }
            entity moveToOriginOverTime(self.origin + (0,0,80), .05);
            wait .05;
        }
        IPrintLn( "deleted" );
        entity delete();
    }
    else
        self.lightProtect = undefined; 
}

gravityGun()
{
    if(!isDefined(self.gravityGun))
    {
        self.gravityGun = true;
        self thread do_gravity_gun();
    }
    else self.gravityGun = undefined;
}

do_gravity_gun()
{
    while(isDefined(self.gravityGun))
    {
        trace = bulletTrace(self GetTagOrigin("j_head"),self GetTagOrigin("j_head")+ anglesToForward(self GetPlayerAngles())* 1000000,1,self);
        while(self adsButtonPressed())
        {
            if(isplayer(trace["entity"])) 
                trace["entity"] EnableInvulnerability(); 
                
            trace["entity"] setOrigin(self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles())* 200);
            trace["entity"].origin = (self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles())* 200);
            
            if(self attackButtonPressed())
            {
                ang  = self getPlayerAngles();
                fwd  = anglesToforward(ang);
                fake = modelSpawner( trace["entity"].origin, "com_plasticcase_friendly", ang );
                fake hide();
                
                if(isplayer(trace["entity"]))
                    trace["entity"] playerLinkTo( fake, "tag_origin" );
                else    
                    trace["entity"] LinkTo( fake, "tag_origin" );
                wait .05;
                fake PhysicsLaunchServer( (0,0,0), anglestoforward(self getplayerangles())*1100 );
                fake thread gravity_gun_end( trace["entity"] );
                wait 1;
            }
            wait .05;
        }
        wait .05;
    }
}

gravity_gun_end( player )
{
    oldOrigin = player.origin;
    wait .05;
    while(oldOrigin != player.origin)
    {
        oldOrigin = player.origin;
        wait .05;
    }
    if(!isDefined(player.godmode))
        player DisableInvulnerability();
    self delete();    
}

//Cod 4 Bounces - 06/10/2017 ~ Extinct
cod4Bounce()
{
    if(!isDefined(self.doCod4Bounce))
    {
        self.doCod4Bounce = true;
        self thread doCod4Bounce();
    }
    else self.doCod4Bounce = undefined;
}

doCod4Bounce()
{
    self endon("disconnect");
    level endon("game_ended");
    
    self notifyOnPlayerCommand( "jump", "+gostand" );
    wait .2;
    
    while(isDefined(self.doCod4Bounce))
    {
        self waittill("jump");
        while(!self isOnGround())
        {
            vel = self GetVelocity()[2];
            wait .05;
        }
        
        bounceTrace = [];
        bounceTrace[0] = bulletTrace(self.origin, self.origin + (anglesToRight( self getPlayerAngles() ) * 20) + (anglesToUp( self getPlayerAngles() ) *-9999), false, self); //RIGHT DOWN
        bounceTrace[1] = bulletTrace(self.origin, self.origin + (anglesToRight( self getPlayerAngles() ) * -20) + (anglesToUp( self getPlayerAngles() ) * -9999), false, self); //LEFT DOWN
        bounceTrace[2] = bulletTrace(self.origin, self.origin + (anglesToForward( self getPlayerAngles() ) * 20) + (anglesToUp( self getPlayerAngles() ) * -9999), false, self); //FORWARD DOWN
        bounceTrace[3] = bulletTrace(self.origin, self.origin + (anglesToForward( self getPlayerAngles() ) * -20) + (anglesToUp( self getPlayerAngles() ) * -9999), false, self); //BAKCWARD DOWN
        
        for(e=0;e<bounceTrace.size;e++)
        {
            if(distance(bounceTrace[e]["position"], self.origin) > 30 && vel < -250)
            {
                self setOrigin((self.origin));
                for(z=int((vel / 180) * -1);z>0;z--)
                {
                    self setVelocity(self getVelocity() + (0, 0, 350));
                    wait .05;
                }
                break 1;
            }
        }
        wait .05;
    }
}

//Solo Pong - 25/11/2019 ~ Extinct
pong_huds()
{
    self thread refreshMenu();
    wait .28;
    
    pong = [];
    pong[0] = self createRectangle("CENTER", "CENTER", 0, 0, 320, 200, (0,0,0), "white", 0, .8); //MAIN BG
    pong[1] = self createRectangle("CENTER", "CENTER", 0, 0, 25, 25, (1,1,1), "compassping_enemyfiring", 2, 1); //BALL
    
    pong[2] = self createRectangle("CENTER", "CENTER", 150, 0, 5, 50, (1,1,1), "white", 1, 1); //PADDLE 
    
    pong[3] = self createRectangle("CENTER", "CENTER", 0, 0, 3, 200, (1,1,1), "white", 1, .4); //CENTER LINE 
    pong[4] = self createRectangle("CENTER", "CENTER", 0, -101, 320, 3, (1,1,1), "white", 1, .4); //TOP LINE 
    pong[5] = self createRectangle("CENTER", "CENTER", 0, 101, 320, 3, (1,1,1), "white", 1, .4); //BORROM LINE 
    
    pong[6] = self createText("small", 1.3, "CENTER", "CENTER", 0, -110, 5, 1, "SCORE: 0", (1,1,1)); //SCORES
    pong[7] = self createText("small", 1.3, "CENTER", "CENTER", 0, 108, 5, 1, "PRESS [{+melee}] TO EXIT!", (1,1,1)); //SCORES
    
    self thread pong_monitor_ball( pong );
    self thread pong_player_monitor( pong );
    self thread pong_exit( pong );
    self FreezeControls( true );
}

pong_monitor_ball( huds )
{
    score = 0;
    best  = 0;
    x     = 13;
    y     = 0;
    
    while( IsDefined( huds[1] ) )
    {
        huds[1] thread hudMoveXY(.1, huds[1].x + x, huds[1].y + y );
        
        if(huds[1].x >= huds[2].x - 13 && huds[1].x <= huds[2].x && huds[1].y >= huds[2].y - 30 && huds[1].y <= huds[2].y + 30 )
        {
            score++;    
            x *= -1;
            y = RandomIntRange( -10, 10 );
            huds[6] setSafeText( "SCORE: " + score );
            self PlaySoundToPlayer( "ui_mp_timer_countdown", self );
        }
        else if(huds[1].x > 160 ) //ENDING POINT (FAILED TO SAVE BALL)
        {
            if( score > best )    
                best = score;    
                
            huds[6] setSafeText( "GAME OVER - BEST SCORE " + best + " - PRESS [{+usebutton}] TO TRY AGAIN!" );  
            huds[1] thread hudMoveXY( 0, 0, 0 ); 
            while(!self UseButtonPressed())
                wait .05; 
             
            score = 0;    
            huds[6] setSafeText( "SCORE: " + score );    
            
            x = 13;
            y = RandomIntRange( -8, 8 );
        }    
        
        if(huds[1].x < -148)
            x *= -1;
        if(huds[1].y < -90 || huds[1].y > 90 ) 
            y *= -1;
        self.predict = (huds[1].y + (y * 4));    
        wait .05;
    }
}

pong_player_monitor( huds )
{
    while( IsDefined( huds[2] ) )
    {
        //self ai_control_paddle( huds, 2 );
        //wait .05;
        
        //ACTUAL PLAYERS
        if( self AttackButtonPressed() )
        {
            if( huds[2].y < 75 )
                huds[2] thread hudMoveXY( .1, huds[2].x, huds[2].y + 25 );
            wait .1;  
        }
        else if( self AdsButtonPressed() )
        {
            if( huds[2].y > -75 )
                huds[2] thread hudMoveXY( .1, huds[2].x, huds[2].y - 25 );
            wait .1;    
        }
        wait .05;
    }
}

ai_control_paddle( huds, index )
{
    ball = self.predict;
    if( ball <= 0 )
        ball *= -1; 
    
    amount = 0;
    for(e=0;e<4;e++)
    {
        if( 25 * amount < ball )
            amount = e;
    }    
            
    if( huds[1].x > 60 && huds[index].y == 0 )
    {  
        for(e=0;e<amount;e++)
        {
            if( huds[index].y < 75 && self.predict > 25)
                huds[index] thread hudMoveXY(.1, huds[index].x, huds[index].y + 25 );
             if( huds[index].y > -75 && self.predict < -25)
                huds[index] thread hudMoveXY( .1, huds[index].x, huds[index].y - 25 );    
            wait .1; 
        }
    }
    if( huds[1].x < 60 && huds[index].y != 0 )
    {
        huds[index] thread hudMoveXY(.1 * amount, huds[index].x, 0);
        wait .1 * amount;
    }
}

pong_exit( huds )
{
    while( IsDefined( huds[2] ) )
    {
        if(self MeleeButtonPressed())
        {
            destroyAll( huds );
            break;
        }
        wait .05;
    }
    self FreezeControls( false );
    self notify( "reopen_menu" );
}

moddedSpread( amount )
{
    if(!IsDefined( self.moddedSpread ))
    {
        self.moddedSpread = true;
        self thread doModdedSpread( amount );
    }
    else 
    {
        self.moddedSpread = undefined;
        self notify("end_moddedspread");
    }
}

doModdedSpread( amount )
{
    self endon("disconnect");
    self endon("end_moddedspread");
    
    while( IsDefined( self.moddedSpread ) )
    {
        self waittill("weapon_fired");
        weap = self GetCurrentWeapon();
        pos  = self lookPos();
        for(e = 0; e < int(amount); e++)
        {
            if(distance(self.origin, pos) < 2000)
                magicBullet(weap, self getTagOrigin("tag_weapon_right"), pos + fakeSpread(50), self);
            else
                magicBullet(weap, self getTagOrigin("tag_weapon_right"), (self gettagorigin( "tag_weapon_right" ) + anglestoforward( self getplayerangles() ) * 2000) + fakeSpread(50), self);
        }
    }
}
    
fakeSpread( amount ) 
{
    return (randomIntRange(amount * -1, amount), randomIntRange(amount * -1, amount), randomIntRange(amount * -1, amount));
}

adv_forge_mode()
{
    if(!IsDefined( self.forge_mode ))
    {
        self.forge_mode = true;
        self thread do_adv_forge_mode();
    }
    else
    {
        self.forge_mode = undefined;
        self notify("stop_adv_forge");
    }
}

do_adv_forge_mode()
{
    self endon("disconnect");
    self endon("stop_adv_forge");
    
    while( true )  
    {
        trace = bulletTrace(self GetTagOrigin("j_head"),self GetTagOrigin("j_head")+ anglesToForward(self GetPlayerAngles())* 1000000,1,self);
        if(IsDefined( trace["entity"] ))
        {
            if(self adsbuttonpressed())
            {
                while(self adsButtonPressed())
                {   
                    trace["entity"] setOrigin(self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles())* 200);
                    trace["entity"].origin = self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles())* 200;
                    wait .01;
                }
            }
            if(self attackButtonPressed())
            {
                while(self attackButtonPressed())
                {
                    trace["entity"] rotatePitch(1, .01);
                    wait .01;
                }
            }
            if(self fragbuttonpressed())
            {
                while(self fragbuttonpressed())
                {   
                    trace["entity"] rotateyaw(1,.01);
                    wait .01;
                }
            }
            if(self secondaryoffhandbuttonpressed())
            {
                while(self secondaryoffhandbuttonpressed())
                {   
                    trace["entity"] rotateroll(1,.01);
                    wait .01;
                }
            }
        }
        wait .05;
    }
}

spawn_mexican_wave( amount )
{
    if(!IsDefined( self.mexican_wave ))
        self.mexican_wave = [];
    else
    { 
        array_delete( self.mexican_wave );
        self.mexican_wave = undefined;
        return;
    }
    
    angle  = self.angles;
    origin = self.origin;    
    for(e=0;e<int(amount);e++)
    {
        self.mexican_wave[e] = modelSpawner( origin + AnglesToRight( angle ) * ((e*36) - ( amount / 2 * 36 )), "defaultactor", angle, .1 );
        self.mexican_wave[e] thread move_mexican_wave(); 
    }
}

move_mexican_wave()
{
    while(IsDefined( self ))
    {
        self moveZ(80, 1, .2, .4);
        wait 1;
        self moveZ(-80, 1, .2, .4);
        wait 1;
    }
}

flyableUfo()
{
    self endon("disconnect");
    self endon("death");

    if(isDefined(self.noclipBind)) 
        return self iprintln("^1Error^7: Please turn off noclip before using Flyable UFO.");
    
    self thread drawInstructions( "Flyable UFO Instructions;Move Forward - [{+speed_throw}] | Shoot - [{+attack}] | Drop Nuke - [{+frag}];Exit Flyable UFO - [{+melee}]", "139;275;122" ); // num chars * 6.125
        
    saveOrigin = self.origin;
    ufo = [];

    flyheight = 1500;
    if( isDefined(level.airStrikeHeightScale ) )
        flyheight = flyheight * level.airStrikeHeightScale;
        
    ufoLink = modelSpawner(saveOrigin + (0, 0, flyheight), "tag_origin", (0,0,0));
    for(e=0;e<6;e++) ufo[ ufo.size ] = modelSpawner(saveOrigin + (cos(e*60),sin(e*60), flyheight), "com_plasticcase_enemy", (0,(e*60)+90,0));
    for(e=0;e<6;e++) ufo[ ufo.size ] = modelSpawner(saveOrigin + (cos(e*60)*40,sin(e*60)*40, flyheight), "com_plasticcase_enemy", (0,(e*60)+90,0));
    foreach( obj in ufo) obj linkTo( ufoLink );
        
    self enableInvulnerability();
    self playerLinkTo( ufoLink );
    
    self setClientDvar( "cg_thirdPersonRange", 500 );
    self setclientthirdperson( true );
    ufoLink thread ufoAngles( self );
    self thread ufoHuds();                          
    
    self SetModel( "" );
    self disableWeapons();
    self disableOffHandWeapons();
    wait .3;
    
    while(1)
    {
        if(self adsButtonPressed())
        {
            vec = anglesToForward(self getPlayerAngles());
            ufoLink moveTo(ufoLink.origin+(vec[0]*45, vec[1]*45, 0), .1);
        }
        if(self attackButtonPressed() && !IsDefined( self.ufo_just_shot ))
            self thread ufoShoot( ufoLink );
        if(self FragButtonPressed() && !IsDefined( self.ufo_just_shot ))
            self thread ufoBomb( ufoLink );
        if(self meleeButtonPressed()) 
            break;
        wait .05;
    }
    
    foreach( obj in ufo ) 
        obj delete();
    ufoLink delete();
    
    if(!isDefined( self.thirdPerson ))   
        self setclientthirdperson( false );
    if(!IsDefined( self.invisibility ))
        self changeAppearance( "ASSAULT", self.team );
    if(!IsDefined( self.godmode ))
        self DisableInvulnerability();
        
    self setClientDvar( "cg_thirdPersonRange", 120 );
    self setOrigin( saveOrigin );
    self enableWeapons();
    self enableOffHandWeapons();
    self notify( "reopen_menu" );
}

ufoAngles( player )
{
    while(isDefined(self))
    {
        self rotateTo(player getPlayerAngles(),.1);
        wait .05;
    }
}

ufoHuds()
{
    ent = modelSpawner( self lookPos() - (0, 0, 50), "tag_origin" );
    box = spawnObjPointer( ent.origin, "remotemissile_target_friendly", 4, 4, 1, (1,1,1) );
    box setTargetEnt( ent );
    
    while(!self meleeButtonPressed())
    {
        ent moveTo( self lookPos() - (0, 0, 50), .15 );
        wait .05;
    }
    box clearTargetEnt();
    box destroy();
    ent delete();
}

ufoShoot( ufo )
{
    self thread ufo_just_shot();
    ent = modelSpawner( ufo.origin, "tag_origin" );
    ent moveTo( self lookPos(), 1.5 );
    playSoundAtPos( ent.origin, "veh_b2_sonic_boom" );
    
    ent thread UFOimpact( self, "detpack_explo_default" );
    
    while(isDefined( ent ))
    {
        fx = spawnFx(loadFX("misc/flare_ambient_green"), ent.origin );
        triggerFx( fx );
        wait .03;
        fx delete();
    }
}

ufoBomb( ufo )
{
    self thread ufo_just_shot();
    ent    = modelSpawner( ufo.origin, "tag_origin" );
    target = bulletTrace( ent.origin - (0,0,50), ent.origin - (0,0,5000), 0, self)["position"];
    ent moveTo(target, 1.5);
    playSoundAtPos( ent.origin, "veh_ac130_sonic_boom" );
    
    ent thread UFOimpact( self, "detpack_explo_default" );
    
    while(isDefined( ent ))
    {
        fx = spawnFx(loadFX("misc/flare_ambient"), ent.origin );
        triggerFx( fx );
        wait .03;
        fx delete();
    }
}

UFOimpact( player, sound )
{
    self waittill("movedone");
    playFx( loadfx("explosions/oxygen_tank_explosion"), self.origin );
    playSoundAtPos( self.origin, sound );
    earthQuake( .4, 1, self.origin, 150 );
    self radiusDamage( self.origin, 150, 200, 50, player );
    self delete();
}

ufo_just_shot()
{
    if(IsDefined( self.ufo_just_shot ))
        return;
    self.ufo_just_shot = true;
    wait .4;
    self.ufo_just_shot = undefined;
}

spectate_player( name )
{
    foreach( player in level.players )
        if( name == player.name )
            spec = player;
    
    if( self hasMenu() ) self thread refreshMenu();        
    self.sessionstate         = "spectator";   
    self.forcespectatorclient = spec GetEntityNumber(); 

    // ignore spectate permissions
    self allowSpectateTeam("allies", true);
    self allowSpectateTeam("axis", true);
    self allowSpectateTeam("freelook", true);
    self allowSpectateTeam("none", true);  
    
    while( !self MeleeButtonPressed() ) 
        wait .05;
    
    self.sessionstate         = "playing";
    self.forcespectatorclient = -1;
    wait .05;
    self maps\mp\gametypes\_class::giveLoadout( self.team, self.class );
    self notify( "reopen_menu" );
}

initial_plane( max, min )
{
    cannons = [];
    
    plane = modelSpawner( self.origin + (0,0,20), "vehicle_mig29_desert", (0,180,0));//Actual Model
    for(e=0;e<2;e++)
        cannons[e] = modelSpawner( self.origin + (60,-125+e*250,-10), "tag_origin");//Cannon tags
    for(e=0;e<2;e++)
        cannons[e] linkTo( plane );
        
    self thread refreshMenu();    
    self thread plane_engine( plane, max, min, cannons );
    self thread plane_cannons( cannons );  
    
    self setPlayerAngles( (0,180,0) );
    self PlayerLinkToDelta( plane );
    
    self disableWeapons();
    self setClientThirdPerson( true );
    self EnableInvulnerability();
    if(!IsDefined( self.invisibility ))
        self invisibility();
}   

plane_engine( plane, max, min, cannons )
{
    self endon("disconnect");
    self endon("game_ended");
    
    self setClientDvar("cg_thirdPersonRange", 960); //120
    
    plane thread maps\mp\killstreaks\_airstrike::playPlaneFx();
    
    planeSpeed = 0;
    while(isDefined(plane))
    {
        roll = self getPlayerAngles()[1];
        if(self adsButtonPressed())
        {
            planeSpeed -= 5;
            if(planeSpeed < min) 
                planeSpeed = min;
        }
        if(self attackButtonPressed())
        {
            planeSpeed++;
            if(planeSpeed > max) 
                planeSpeed = max;
        }
        else
        {
            planeSpeed--;
            if(planeSpeed < min)
                planeSpeed = min;
            wait .05;
        }
        if(self meleeButtonPressed())
            break;
        plane moveto(plane.origin+anglestoforward(self getplayerangles())*planeSpeed,.06); 
        wait .05;
        plane rotateTo(self.angles + (self getPlayerAngles()[0], 0, (( roll - self GetPlayerAngles()[1]) * 6) / .6),.2,.1,.1);
    }
    
    self unlink(plane);
    plane delete(); 
    for(e=0;e<2;e++)
        cannons[e] delete();
        
    self setclientthirdperson(0);
    if(!isDefined(self.godmode))
        self DisableInvulnerability();
        
    self setClientDvar("cg_thirdPersonRange", 120);    
    self enableWeapons();
    self invisibility();
    self.drivingPlane = undefined;
    self notify( "reopen_menu" );
}

plane_cannons( cannons )
{
    while(isDefined(cannons[0]))
    {
        if(self secondaryoffhandbuttonpressed())
        {
            self thread spawnBullet(undefined, cannons[0].origin + AnglesToForward(cannons[0].angles)*-60, "projectile_hellfire_missile", 5000, "props/barrelexp", 2.5, "smoke/smoke_geotrail_hellfire", .05, "veh_b2_sonic_boom", "exp_ac130_105mm", 2, 1, 450, 250, 500, 200, "kill", self getCurrentWeapon(), "sniper_fire");
            wait .08;
        }
        if(self fragbuttonpressed())
        {
            self thread spawnBullet(undefined, cannons[1].origin + AnglesToForward(cannons[1].angles)*-60, "projectile_hellfire_missile", 5000, "props/barrelexp", 2.5, "smoke/smoke_geotrail_hellfire", .05, "veh_b2_sonic_boom", "exp_ac130_105mm", 2, 1, 450, 200, 500, 200, "kill", self getCurrentWeapon(), "sniper_fire");
            wait .08;
        }
        wait .05;
    }
}

explosive_melee()
{
    if(!IsDefined( self.explosive_melee ))
    {
        self.explosive_melee = true;
        self thread do_explosive_melee();
    }
    else 
        self.explosive_melee = undefined;
}

do_explosive_melee()
{
    while(IsDefined( self.explosive_melee ))
    {
        if( self isMeleeing() )
        {
            position        = self GetTagOrigin( "tag_weapon_right" );
            phyExpMagnitude = 7;
            minDamage       = 1;
            maxDamage       = 250;
            blastRadius     = 250;
            
            self radiusDamage( position, blastRadius, maxDamage, minDamage, undefined, "MOD_EXPLOSIVE", "barrel_mp" );
            self playsound( "explo_metal_rand" );
            PlayFX( level.barrelEXP, position ); 
            
            PlayRumbleOnPosition( "grenade_rumble", position );
            earthquake( 0.5, 0.75, position, 800 );
            wait .1;
            physicsExplosionSphere( position, blastRadius, blastRadius / 2, phyExpMagnitude );
            
            while(self isMeleeing())
                wait .05;
        }
        wait .05;
    }
}

gravity_missile()
{
    if( !IsDefined( self.gravity_missile ) )
    {
        self.gravity_missile = true;
        self thread monitor_missiles();
    }
    else 
    {
        self.gravity_missile = undefined;
        self notify("stop_missile_monitor");
    }
}

monitor_missiles()
{
    self endon("disconnect");
    self endon("stop_missile_monitor");
    
    while( IsDefined( self.gravityMissile ) ) 
    {
        self waittill( "missile_fire", bullet, weaponName );
        if(!IsDefined( bullet ))
            continue;
        bullet thread force_gravity( 20, 9999, 0.1 );   
    }
}

force_gravity( force, duration, timescale ) 
{
    self endon("death");
    while(IsDefined(self)) 
    {
        self.angles = VectorToAngles( ( (self.origin + AnglesToForward( self.angles ) * 1000) - (0,0,force) ) - self.origin );
        wait timescale;
    }
}
