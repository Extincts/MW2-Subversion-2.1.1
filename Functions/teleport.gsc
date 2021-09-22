advancedTele( end, angle )
{
    if(isDefined( self.teleporting ))
        return self iprintln("^1Error^7: Please wait until you have finished teleporting.");
    if(!isDefined( angle )) angle = self.angles;
    
    if(isDefined(self.cinematicTele))
    {
        self.teleporting = true;
        start            = self.origin;
        angles           = vectorToAngles( end - self geteye() );
        camera           = modelSpawner( start + (0,0,40), "tag_origin", angles );
        
        if(!isDefined( self.godmode ))
            self EnableInvulnerability();
        self freezeControls( true );
        self PlayerLinkToAbsolute( camera, "tag_origin" );
        self DisableWeapons();
        
        camera moveTo(start + (0,0,5000), 4, 2, 2);
        camera rotateto(angles + (90,0,0), 3, 1, 1);
        wait 3;
        camera moveTo(end, 4, 2, 2);
        wait 1;
        camera rotateto(angle, 3, 1, 1);
        wait 3;
        
        if(!isDefined( self.godmode ))
            self DisableInvulnerability();
        self freezeControls( false );   
        self EnableWeapons();
        self.teleporting = undefined;   
        camera delete();
    }
    else 
    {
        self setOrigin( end );
        self setPlayerAngles( angle );
    }
}

cinematicTele()
{
    if(!isDefined(self.cinematicTele))
        self.cinematicTele = true;
    else self.cinematicTele = undefined;
}

savePos()
{
    if(!isDefined(self.posSaved))
    {
        self.posSaved = self.origin;
        self.posAngles = self.angles;
    }
    else
    {
        self.posSaved = undefined;
        self.posAngles = undefined;
    }
}

loadPos()
{
    if(isDefined(self.posSaved))
    {
        if(!isDefined(self.cinematicTele))
        {
            self setOrigin( self.posSaved );
            self setPlayerAngles( self.posAngles );
        }
        else self thread advancedTele( self.posSaved, self.posAngles );
    }
    else self iprintln("^1Error^7: Save Your Position First");
}

teleRandomPers( team )
{
    if(team == "Closest") 
        return self setOrigin(self returnClosest().origin);
    rand = randomIntRange(0, level.players.size+1);
    for(e=0;e<level.players.size;e++)
    {
        if(self != level.players[rand])
        {
            if(level.players[e] == level.players[rand])
            {
                if(isDefined(team) && level.players[e].team != self.team && team == "Enemy")
                    self setOrigin(level.players[e].origin);
                else if(isDefined(team) && level.players[e].team == self.team && team == "Teammate")
                    self setOrigin(level.players[e].origin);
                else if(team == "Random")
                    self setOrigin(level.players[e].origin);
                else if(level.players[e].team == self.team && team == "Enemy" || level.players[e].team != self.team && team == "Teammate")    
                    return self thread teleRandomPers( team );
            }
        }
        else return self thread teleRandomPers( team );
    }
}

teleCrosshair( range )
{
    if(range == "Max") range = 999999;
        self setOrigin(bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * int(range), false, self)["position"]);
}

advancedSaveLoad()
{
    self endon("disconnect");
    level endon("game_ended");
    
    if( !isDefined( self.adSaveLoad ) && !isDefined( self.saveLoad ))
    {
        self.adSaveLoad = true;
        self iprintln("Press ^2[{+actionslot 3}] ^7&^2 Prone^7 To Save Location");
        
        while( isDefined(self.adSaveLoad) )
        {
            if( isDefined(self.savePos) && self.origin[2] < self.savePos[2] && !self isOnGround() )
            {
                while( !self isOnGround() )
                    wait .05;
                self setOrigin((self.savePos));
            }
            else if( self.actionSlotsPressed[ "dpad_left" ] && self getStance() == "prone" )
            {
                self.savePos = self.origin;
                self iprintln("Position Saved: ^2"+self.savePos);
                wait .2;
            }
            wait .05;
        }
    }
    else if(isDefined( self.adSaveLoad ))
        self.adSaveLoad = undefined;
    else self iprintln("^1Error^7: Please Turn Off The Other Save & Load.");
}

saveLoadBind()
{
    self endon("disconnect");
    level endon("game_ended");
    
    if(!isDefined( self.saveLoad ) && !isDefined( self.adSaveLoad ) )
    {   
        self.saveLoad = true;
        self.savePos = undefined;
        
        self iprintln("Press ^2[{+actionslot 3}]^7 To Load Location");
        self iprintln("Press ^2[{+actionslot 3}] ^7&^2 Prone^7 To Save Location");
        self iprintln("Press ^2[{+melee}] ^7&^2 Prone^7 To Reset Location");
        
        while( isDefined(self.saveLoad) )
        {
            if(self.actionSlotsPressed[ "dpad_left" ] && isDefined(self.savePos))
            {
                self setOrigin((self.savePos));
                self SetPlayerAngles((self.saveAngle));
                self iprintln("Position Loded: ^2"+self.savePos);
                wait .2;
            }
            else if(self.actionSlotsPressed[ "dpad_left" ] && self getStance() == "prone")
            {
                self.savePos   = self.origin;
                self.saveAngle = self.angles;
                self iprintln("Position Saved: ^2"+self.savePos);
                wait .2;
            }
            else if(self.actionSlotsPressed[ "dpad_left" ] && self getStance() == "prone")
            {
                self.savePos = undefined;
                self iprintln("Position Successfully Reset!");
                wait .2;
            }
            else if(self.actionSlotsPressed[ "dpad_left" ] && !isDefined(self.savePos))
            {
                self iprintln("^1Error^7: Please save a origin you would like to load.");
                wait .2;
            }
            wait .05;
        }
    }
    else if(isDefined( self.saveLoad ))
        self.saveLoad = undefined;
    else self iprintln("^1Error^7: Please Turn Off The Other Save & Load.");
}

allToMe( team, crosshair )
{
    foreach(player in level.players)
    {
        if( team == "Closest" )
            player = self returnClosest();
        if( player.team == toLower( team ) && player != self || team == "Everyone" && player != self || team == "Closest" )
        {   
            if( isDefined(crosshair) )
                player setOrigin(bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 999999, false, self)["position"]);
            else 
                player setOrigin( self.origin );
            if( team == "Closest" )
                return;
        }
    }
}

spawnTrap( team, crosshair )
{
    self endon("disconnect");
    level endon("game_ended");
    level endon("stopTrap");

    if( team == "Stop" )
    {
        foreach(player in level.players)
            player freezeControlsAllowLook( false );
        level notify("stopTrap");
        //return;
    }
    
    if(!isDefined(crosshair)) 
        sOrigin = self.origin;
    else
        sOrigin = bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 999999, false, self)["position"];
    
    foreach(player in level.players)
        if( player.team == toLower( team ) && player != self || team == "Everyone" && player != self )
            player thread monitorSpawntrap( sOrigin, true );
}

monitorSpawntrap( sOrigin, first )
{
    level endon("stopTrap");
    
    if(!isDefined(first))
        self waittill("death");
    self maps\mp\gametypes\_playerlogic::spawnPlayer();
    wait .05;
    self setOrigin( sOrigin );
    self freezeControlsAllowLook( true );
    self thread monitorSpawntrap(sOrigin);
}

returnClosest()
{
    foreach(player in level.players)
    { 
        if(Closer( self getTagOrigin("j_head"), player getTagOrigin("j_head"), final getTagOrigin("j_head") ) && player != self)
            final = player;
    }
    return final;
}

ipadTeleport( team ) //CanSpawn
{
    self thread refreshMenu();
    wait .2;
    
    height = getEnt( "airstrikeheight", "targetname" ).origin[2];
    self beginLocationSelection( "map_artillery_selector", false, 500 );  
    self waittill( "confirm_location", location ); 
    pos = BulletTrace( location + (0,0,height), location - (0,0,height), false )[ "position" ];
    self endLocationSelection();
    self.selectingLocation = undefined;
    self notify( "stop_location_selection" );

    if( !CanSpawn( pos + (0,0,30) ) )
        pos = BulletTrace( pos - (0,0,20), pos - (0,0,1000), false )[ "position" ]; 
    
    wait .2;
    self notify( "reopen_menu" );
    
    if(!isDefined(team)) 
        return self thread advancedTele( pos, self.angles );
    foreach(player in level.players)
    {
        if( player.team == toLower( team ) && player != self || team == "Everyone" && player != self)
            player setOrigin( pos );
    }
}

teleportToRandomSpawn()
{
    array = level.spawnPoints;
    if(!isDefined(array) || array.size == 0)
        return;
    random = array[randomInt(array.size)];
    self advancedTele( random.origin, random.angles );
}
