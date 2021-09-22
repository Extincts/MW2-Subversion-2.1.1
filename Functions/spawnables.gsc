spawn_Fx(fx, delete)
{
    if(isDefined( fx ))
    {
        if(!IsDefined( level.SpawnedFx )) 
            level.SpawnedFx = [];
        if(!isDefined( self.FxDistance ))
            self fx_distance( 100 );

        if(isDefined( fx ))
        {
            level.SpawnedFx[level.SpawnedFx.size] = spawnFx(level._effect[Fx], self getEye() + anglesToForward( self getPlayerAngles() ) * self.FxDistance);
            triggerFx(level.SpawnedFx[level.SpawnedFx.size-1]);
        }
        if(level.SpawnedFx.size >= 100)
        {
            array_delete( level.SpawnedFx );
            self iprintln("Notice: all fx's deleted due to too many spawned.");
            level.SpawnedFx = [];
        }
    }
    else
    {
        array_delete( level.SpawnedFx );
        self iprintln("All spawned FXs deleted!");
        level.SpawnedFx = [];
    }
}

fx_distance( value )
{
    self.fxDistance = int( value );
    self iprintln( "Distance set to: " + self.FxDistance );
}

/* Carepackage Dimensions
        Length = 57
        Width = 31
        Height = 27
*/

spawnBasicBunker()
{
    if(IsDefined( level.smallBunkerSpawned ))
        return self IPrintLn( "^1Error^7: Bunker Already Spawned, Please Delete The Previous Spawned Bunker!" );
    level.bunker = [];

    fixedOrg = self.origin - (80,80,30);
    for(w=0;w<2;w++) for(e=0;e<7;e++) for(a=0;a<12;a++) //MAIN FLOORS
    {
        level.bunker[ level.bunker.size ] = modelSpawner(fixedOrg + ((a * 31), (e * 57), (w * 139)), "com_plasticcase_enemy", (0, 90, 0), undefined, level.airDropCrateCollision);
        if( w >= 1 && e == 1 && a > 4 && a < 10 )
            level.bunker[ level.bunker.size -1 ] delete();
    }
    
    for(w=0;w<2;w++) for(e=0;e<6;e++) for(a=0;a<12;a++) //WIDTH WALLS
        level.bunker[ level.bunker.size ] = modelSpawner(fixedOrg + ((a * 31), (w * 342), 31 + (e * 27)), "com_plasticcase_enemy", (0, 90, 0), .05, level.airDropCrateCollision);
 
    for(w=0;w<2;w++) for(e=0;e<6;e++) for(a=0;a<5;a++) //LENGTH WALLS
    {
        level.bunker[ level.bunker.size ] = modelSpawner(fixedOrg + ((w * 341), 57 + (a * 57), 31 + (e * 27)), "com_plasticcase_enemy", (0, 90, 0), .05, level.airDropCrateCollision);
        if( e >= 1 && e <= 2 && a >= 1 && a <= 3 ) //WINDOWS
            level.bunker[ level.bunker.size -1 ] delete();
    }
        
    for(e=0;e<4;e++) //STAIRS
        level.bunker[ level.bunker.size ] = modelSpawner(fixedOrg + (186 + (e * 31), 57, 31 + (e * 27)), "com_plasticcase_enemy", (0, 90, 0), .05, level.airDropCrateCollision);
        
    level.smallBunkerSpawned = true;    
    level thread arrySetColour(true, "basicBunker", 0);     
}
    
deleteBasicBunker()
{
    if(IsDefined( level.smallBunkerSpawned ))
    {
        array_delete( level.bunker );
        level thread arrySetColour(undefined, "basicBunker", 0);
        level.smallBunkerSpawned = undefined;
    }
}

nukeBasicBunker()
{
    if(IsDefined( level.smallBunkerSpawned ))
    {
        foreach( obj in level.bunker )
            obj thread delayedFall( 10 );
            
        level thread arrySetColour(undefined, "basicBunker", 0);    
        level.smallBunkerSpawned = undefined;
    }
}

/*
    Rides 
            */

do_merryGoRound( error )
{
    if(!isDefined(level.merry_Spawned))
    {
        level.merry_Spawned = true;
        self thread arrySetColour(level.merry_Spawned, self getCurrentMenu(), self getCursor());
        self thread spawn_merryGoRound(); 
    }
    else self iprintln("^1Error^7: The Merry Go Round has already been spawned.");
}

delete_merryGoRound()
{
    if(!IsDefined( level.merry_Spawned ))
        return self iprintln("^1Error^7: Ride has not been spawned to destroy.");

    level thread detach_from_seat();    
    level notify("destroy_merry");
    level.merryGoRoundMove delete();
    level thread deleteMultipleArrays( level.merryGoRound, level.merryGoRoundSeats, level.merryGoRoundSeatTags, level.merryGoRoundLights );
    
    level.merry_Spawned = undefined;
    self thread arrySetColour(level.merry_Spawned, self getCurrentMenu(), 0);
}

spawn_merryGoRound()
{
    level endon("game_ended");
    self endon("disconnect");
    level endon("destroy_merry");

    level.speedMerry           = 6;
    level.merryGoRound         = [];
    level.merryGoRoundSeats    = [];
    level.merryGoRoundSeatTags = [];
    level.merryGoRoundLights   = [];
    level.merryGoRoundMove     = modelSpawner(self.origin + (0,0,35) + anglesToForward(self getPlayerAngles())*20, "tag_origin");
    
    sizes       = [0,43,75,107,138,170];
    sizesSeats  = [93,139];
    sizesLights = [104,138];

    num = 0;
    time = .05;

    wait .5;
    for(e = 0; e < 3; e++) for(i = 0; i < 6; i++)
        level.merryGoRound[level.merryGoRound.size] = modelSpawner(level.merryGoRoundMove.origin + (cos(i*60) * 13, sin(i*60) * 13, 15 + e*55), "com_plasticcase_friendly", (90, (i*60) + 90, 0), time, level.airDropCrateCollision );
    
    for(z = 0; z < 2; z++) for(e = 0; e < 6; e++) for(i = 0; i < 6*e; i++)
    {
        level.merryGoRound[level.merryGoRound.size] = modelSpawner(level.merryGoRoundMove.origin + (cos(i*360 / (6*e)) * sizes[e], sin(i*360 / (6*e)) * sizes[e], -20 + 180*z), "com_plasticcase_friendly", (0, (i* 360 / (6*e)) + 90, 0), time, level.airDropCrateCollision );
        level.merryGoRound[level.merryGoRound.size -1] linkTo(level.merryGoRoundMove);
    }
    
    for(e = 0; e < 10; e++) 
    {
        level.merryGoRoundLights[e] = modelSpawner(level.merryGoRoundMove.origin + (cos(e*36) * sizesLights[e%2], sin(e*36) * sizesLights[e%2], 148), "tag_origin", (0, (e*36), 0), time );
        level.merryGoRoundLights[e+10] = modelSpawner(level.merryGoRoundMove.origin + (cos(e*36) * 168, sin(e*36) * 168, 148), "tag_origin", (0, (e*36), 0), time);
        wait .05;
        playFxOnTag(level._effect["ac130_light_red"], level.merryGoRoundLights[e], "tag_origin");
        playFxOnTag(level._effect["ac130_light_red"], level.merryGoRoundLights[e+10], "tag_origin");
        
        level.merryGoRoundSeats[level.merryGoRoundSeats.size] = modelSpawner(level.merryGoRoundMove.origin + (cos(e*36) * sizesSeats[e%2], sin(e*36) * sizesSeats[e%2], 12), "com_plasticcase_friendly", (0, (e*36), 0), time );
        level.merryGoRoundSeatTags[level.merryGoRoundSeatTags.size] = modelSpawner(level.merryGoRoundMove.origin + (0, 0, 12), "tag_origin", (0, (e*36), 0), time);
        
        level.merryGoRoundSeats[level.merryGoRoundSeats.size -1] linkTo(level.merryGoRoundSeatTags[level.merryGoRoundSeatTags.size -1]);
    } 
    
    level.merryGoRoundMove thread rotate_merry_yaw();
    foreach(tags in level.merryGoRoundSeatTags)
    {
        tags thread rotate_merry_yaw();
        tags thread move_merry_seats();
        //tags thread monitorSeats( "Merry Go Round", level.merryGoRoundSeats );
        
        level.merryGoRoundSeats[ num ] linkTo( tags );
        level.merryGoRoundLights[ num ] linkTo( level.merryGoRoundMove );
        level.merryGoRoundLights[ num + 10 ] linkTo( level.merryGoRoundMove );
        num++;
    }
    thread array_thread(level.merryGoRoundSeats, ::monitorSeats, "Merry Go Round", level.merryGoRoundSeats );
}

move_merry_seats( seat )
{
    level endon("game_ended");
    level endon("destroy_merry");

    while(isDefined(self))
    {
        RandNum = randomfloatrange(1,3);
        self moveZ(65,RandNum,.4,.4);
        wait RandNum;
        RandNum = randomfloatrange(1,3);
        self moveZ(-65,RandNum,.4,.4);
        wait RandNum;
    }
}

change_merry_yaw_speed(speed)
{
    if( !IsDefined( speed ) )
        level.speedMerry = 6;
    
    level.speedMerry = speed;
    level notify("change_Speed_Merry");
    level.merryGoRoundMove thread rotate_merry_yaw();
    foreach(tags in level.merryGoRoundSeatTags)
        tags thread rotate_merry_yaw();
}

rotate_merry_yaw()
{
    level endon("game_ended");
    level endon("destroy_merry");
    level endon("change_Speed_Merry");
    
    while(isDefined(self))
    {
        self rotateYaw(360, level.speedMerry);
        wait level.speedMerry;
    }
}

do_ferris_wheel()
{
    if(!isDefined( level.ferris_Spawned ))
    {
        level.ferris_Spawned = true;
        self thread arrySetColour(level.ferris_Spawned, self getCurrentMenu(), self getCursor());
        self thread do_ferrisWheel(); 
    }
    else self iprintln("^1Error^7: The Ferris Wheel has already been spawned.");
}

delete_ferris_wheel()
{
    if(!IsDefined( level.ferris_Spawned ))
        return self iprintln("^1Error^7: Ride has not been spawned to destroy.");
    
    level thread detach_from_seat();  
    level notify("destroy_ferris");
    level.FerrisLink delete(); level.FerrisAttach delete();
    self thread deleteMultipleArrays( level.Ferris, level.FerrisSeats, level.FerrisLegs );
    
    level.ferris_Spawned = undefined;
    self thread arrySetColour(level.ferris_Spawned, self getCurrentMenu(), 0);
}

do_ferrisWheel()
{
    level endon("destroy_ferris");
    level endon("game_ended");
    self endon("disconnect");
    
    level.ferrisOrg    = self.origin - (0,0,40);
    level.ferris_speed = 1;
    
    level.FerrisLegs = [];
    level.FerrisSeats = [];
    level.Ferris = [];
    
    level.FerrisAttach = modelSpawner(level.ferrisOrg + (0,0,420), "tag_origin");
    level.FerrisLink = modelSpawner(level.ferrisOrg + (0,0,40), "tag_origin");
    
    time = .05;
    
    for(a=0;a<2;a++) for(e=0;e<30;e++)
        level.Ferris[level.Ferris.size] = modelSpawner(level.ferrisOrg + (-45 + (a*90),0,420) + (0,sin(e*12)*280, cos(e*12)*280), "com_plasticcase_friendly",(e*12,90,0),time);
    for(a=0;a<2;a++) for(b=0;b<5;b++) for(e=0;e<15;e++)
        level.Ferris[level.Ferris.size] = modelSpawner(level.ferrisOrg + (-45 + (a*90), 0, 420) + (0, sin(e*24)*(40 + b*50), cos(e*24)*(40 + b*50) ), "com_plasticcase_friendly",(90+(e*24),90,0),time); 
    for(e=0;e<15;e++)
        level.FerrisSeats[level.FerrisSeats.size] = modelSpawner(level.ferrisOrg + (0,0,420) + (0,sin(e*24)*280, cos(e*24)*280), "com_plasticcase_friendly",(0,0,e*-24),time);
    for(e=0;e<3;e++)
        level.FerrisLegs[level.FerrisLegs.size] = modelSpawner(level.ferrisOrg + (82-e*82,0,420),"com_plasticcase_friendly",(0,0,0),time);
    for(e=0;e<2;e++) for(a=0;a<8;a++) 
        level.FerrisLegs[level.FerrisLegs.size] = modelSpawner(level.ferrisOrg + (-95+e*190,-190,55) + (0,a*25,a*50),"com_plasticcase_friendly",(-65,90,0),time);
    for(e=0;e<2;e++) for(a=0;a<8;a++)
        level.FerrisLegs[level.FerrisLegs.size] = modelSpawner(level.ferrisOrg + (-95+e*190,190,55) + (0,a*-25,a*50),"com_plasticcase_friendly",(65,90,0),time);

    foreach(model in level.Ferris)
        model linkTo(level.FerrisAttach);
    foreach(model in level.FerrisSeats)
        model linkTo(level.FerrisAttach);
        
    level.FerrisAttach thread ferris_Rotate();
        
    thread array_thread(level.FerrisSeats, ::monitorSeats, "Ferris Wheel", level.FerrisSeats );
}

ferris_Rotate()
{
    level endon("destroy_ferris");
    
    while( true )
    {
        for(a=0;a<360;a+=level.ferris_speed) 
        {
            self rotateTo((0,self.angles[1],a),.2);
            wait .05;
        }
        for(a=360;a<0;a-=level.ferris_speed)
        {
            self rotateTo((0,self.angles[1],a),.2);
            wait .05;
        }
        wait .05;
    }
}

seatAngleFix( seat )
{
    while(isDefined(self) && isDefined(level.ferris_Spawned))
    {
        for(e=0;e<360;e+=level.ferris_speed)
        {
            self.angles = (0,90,0);
            self MoveTo(seat.origin + (0,0,10),.1);
            wait .05;
        }
        wait .05;
    }
    self delete();
}

change_ferris_speed( int )
{
    level.ferris_speed = int;
}

spawn_centrox()
{
    if(!isDefined( level.cextrox_spawned ))
    {
        level.cextrox_spawned = true;
        self thread arrySetColour(level.cextrox_spawned, self getCurrentMenu(), self getCursor());
        self thread do_centrox(); 
    }
    else self iprintln("^1Error^7: The Centrox has already been spawned.");
}

delete_centrox()
{
    if(!IsDefined( level.cextrox_spawned ))
        return self iprintln("^1Error^7: Ride has not been spawned to destroy.");
        
    level thread detach_from_seat();    
    level notify("destroy_centrox");
    level.move_centrox delete();
    self thread deleteMultipleArrays( level.centrox, level.centrox_seats, level.centrox_center, level.centrox_lights ); 
    
    level.cextrox_spawned = undefined;
    self thread arrySetColour(level.cextrox_spawned, self getCurrentMenu(), 0);
}

do_centrox()
{
    level endon("destroy_centrox");
    
    level.centrox        = [];
    level.centrox_seats  = [];
    level.centrox_center = [];
    level.centrox_lights = [];
    
    origin             = self.origin + (40,0,20);
    level.move_centrox = modelSpawner( origin, "tag_origin" );
    
    wait 1;
    
    time = .1;
    for(e = 0; e < 2; e++) for(i = 0; i < 6; i++)
        level.centrox_center[level.centrox_center.size] = modelSpawner(origin + (cos(i*60)*20,sin(i*60)*20, e*57), "com_plasticcase_friendly", (90,(i*60)+90,90), time, level.airDropCrateCollision);//Center
    for(i = 0; i < 15; i++)
        level.centrox[level.centrox.size] = modelSpawner(origin + (cos(i*24)*60,sin(i*24)*60, -20), "com_plasticcase_friendly", (0,(i*24),0), time, level.airDropCrateCollision);//floor inner 
    for(i = 0; i < 25; i++)
        level.centrox[level.centrox.size] = modelSpawner(origin + (cos(i*14.4)*120,sin(i*14.4)*120, -20), "com_plasticcase_friendly", (0,(i*14.4),0), time, level.airDropCrateCollision);//floor outer 
    for(i = 0; i < 30; i++)
    {
        level.centrox[level.centrox.size] = modelSpawner(origin + (cos(i*12)*160,sin(i*12)*160, 20), "com_plasticcase_friendly", (90,(i*12)+90,90), time, level.airDropCrateCollision);//Wall
        
        if( level.centrox.size != 68 && level.centrox.size != 69 && level.centrox.size != 70 )
        {
            level.centrox_lights[level.centrox_lights.size] = modelSpawner(origin + (cos(i*12)*150,sin(i*12)*150, RandomIntRange( 10, 30 )), "tag_origin", (90,(i*12)+90,90), time);//Lights
            wait .05;
            playFxOnTag(level._effect["ac130_light_red"], level.centrox_lights[level.centrox_lights.size-1], "tag_origin");
        }
    }
    for(i = 0; i < 10; i++)
        level.centrox[level.centrox.size] = modelSpawner(origin + (cos(i*36)*155,sin(i*36)*155, 20), "com_plasticcase_enemy", (90,(i*36)+90,90), time);//Seats Visual  
    for(i = 0; i < 10; i++)
        level.centrox_seats[level.centrox_seats.size] = modelSpawner(origin + (cos(i*36)*145,sin(i*36)*145, 0), "tag_origin", (0,(i*36)+180,0));//Seats   
        
    level.centrox[68] MoveTo(level.centrox[67].origin, .3);//Doors Open
    level.centrox[69] MoveTo(level.centrox[40].origin, .3);//Doors Open 
    
    foreach( model in level.centrox_lights )
        model linkto( level.move_centrox );
    foreach( model in level.centrox_seats )
        model LinkTo( level.move_centrox ); 
    thread array_thread(level.centrox_seats, ::monitorSeats, "Centrox", level.centrox_seats );
        
    level.move_centrox thread monitor_centrox();
    
}

monitor_centrox()
{   
    level endon("Stop_Centrox");
    while(isDefined(self))
    {
        level waittill("player_is_riding");
        
        level.Centrox[68] MoveTo(level.Centrox[67].origin+(10,31,0), .3);
        level.Centrox[69] MoveTo(level.Centrox[40].origin+(-10,-31,0), .3);
        wait .5; 
        
        foreach(model in level.centrox)
            model LinkTo( level.move_centrox ); 
            
        wait .1;
        self MoveTo( (self.origin[0], self.origin[1], self.origin[2] + 90), 5 );
        
        wait 5;
        earthquake(.4, 1, self.origin, 300);  
        
        sign  = 1;
        speed = 4;
        for(e=0;e<4;e++)
        {
            if( e > 1 )
                sign = -1;
            for(i=0;i<40;i++)
            {
                self RotateTo( self.angles + ( .6 * sign, speed, 0 ), .5 );
                if( e > 1 )
                    speed--;
                else if( speed < 180 )
                    speed++;
                wait .3;
            }
        }
        wait 1;

        self vibrate(self.origin+(1,1,0), .2, .3, 6);  
        earthquake(.4, 1, self.origin, 300);    
        self MoveTo( (self.origin[0], self.origin[1], self.origin[2] - 90), 5 );
        
        wait 5;
        foreach(model in level.centrox)
            model Unlink( level.move_centrox );    
            
        wait .3;
        level.Centrox[68] MoveTo(level.Centrox[67].origin, .3);
        level.Centrox[69] MoveTo(level.Centrox[40].origin, .3);
        
        foreach( player in level.players )
            player.kicked_from_ride = true; 
        wait .3;
    }
}

monitorSeats( ride, array )
{
    ent endon("death");
    trig = self;
    trig MakeUsable();
    trig SetCursorHint( "HINT_ACTIVATE" );
    trig setHintString( "Press ^3[{+activate}]^7 to ride the " + ride + "." );
    
    while( true )
    {
        trig waittill( "trigger", player );
        
        if(IsDefined( player.in_seat ))
            break;
            
        save_origin    = player.origin;
        player.in_seat = true;
        trig.in_use    = true;
        
        trig arySetUnUsable( array, player );
        trig setHintString( "Press ^3[{+melee}]^7 to exit the " + ride + "." );
        
        if( ride == "Ferris Wheel" )
        {
            seat = modelSpawner( trig.origin - anglesToRight(self.angles) * 22, "script_origin", (0,90,0) );
            seat thread seatAngleFix( trig );
            player PlayerLinkToDelta( seat );
        }
        else if( ride == "Centrox" || ride == "Fireball" )
            player PlayerLinkToAbsolute( trig, "tag_origin" ); 
        else if( ride == "The Claw" )    
            player PlayerLinkToDelta( trig );
        else
            player playerLinkTo( trig );
            
        player setStance( "crouch" );  
        player editMovements( 0 );
        
        if( !isDefined( player.godmode ) )
            player EnableInvulnerability();  
        
        while(!player MeleeButtonPressed() && !isDefined( player.kicked_from_ride ) && isDefined( player.in_seat ) && IsAlive( player ))
            wait .05;
            
        trig setHintString( "Press ^3[{+activate}]^7 to ride the " + ride + "." );
        if( !isDefined( player.godmode ) )
            player DisableInvulnerability();
            
        player unlink();    
        player setOrigin( save_origin );
        player editMovements( 1 );
        
        if( ride == "Ferris Wheel" )
            seat delete();
            
        trig.in_use             = undefined;
        player.kicked_from_ride = undefined;
        player.in_seat          = undefined;
        trig arySetUsable( array );
    }
}

detach_from_seat()
{
    foreach(player in level.players)
    {
        if(IsDefined( player.in_seat ))
        {
            player unlink();
            if(!isDefined(player.godmode))
                player DisableInvulnerability();
                
            player editMovements( 1 );      
            player.in_seat = undefined;
        }   
    }   
}

trade_weap_table()
{
    if(!IsDefined( self.trade_table ))
    {
        self.trade_table = true;
        weapon_table     = modelSpawner( self.origin + (0,0,12) + AnglesToForward( self.angles ) * 70, "com_plasticcase_enemy", self.angles + (0,270,0), undefined, level.airDropCrateCollision); 
        wait 1;
        weapon_table thread trade_weap_monitor();
    }
    else 
        self.trade_table = undefined;
}

trade_weap_monitor()
{
    table_status = "place";
    
    self MakeUsable();
    self SetCursorHint( "HINT_ACTIVATE" );
    self setHintString( "Press ^3[{+activate}]^7 to " + table_status + " weapon." );
    
    while(IsDefined(self))
    {
        self waittill("trigger", player);
        
        if(table_status == "place")
        {
            weapon_placed = player getCurrentWeapon();
                        
            amount = -8;
            if( weaponClass(weapon_placed) != "sniper" )
                amount = 6;
            
            placed_weapon = modelSpawner( self.origin + (0,0,29) - AnglesToForward( self.angles ) * amount, getWeaponModel(weapon_placed), self.angles + (0,180,90));
            
            player PlaySoundToPlayer( "player_refill_all_ammo", player );    
            player takeWeapon( player getCurrentWeapon() );
            player SwitchToWeapon( player GetWeaponsListPrimaries()[0] );
            
            placed_weapon RotateRoll(720, 1, .3, .3);
            wait 1.2;
            placed_weapon moveTo( placed_weapon.origin + (0,0,-13), .2, .1, .1);
            wait .2;
            fx = SpawnFx( level._effect["ac130_flare"], placed_weapon.origin ); 
            TriggerFX( fx );
            player PlaySound( "ac130_flare_burst" );
            wait .2;
            table_status = "pick up";
        }
        else 
        {
            player PlaySoundToPlayer( "weap_pickup", player );
            player giveWeap( weapon_placed );
            placed_weapon delete();
            wait .3;
            table_status = "place";
        }
        self setHintString( "Press ^3[{+activate}]^7 to " + table_status + " weapon." );
    }
    if(IsDefined( placed_weapon ))
        placed_weapon delete();
    self delete();
}

//v0 = SPACES TO RIGHT
//v1 = 360 / AMOUNT; 
//v2 = ANGLES 
//v3 = AMOUNT;
    
customizeSphere( type )
{   
    if(!IsDefined( level.sphere_spawned ))
    {
        self endon("stop_sphere");
        level.sphere_spawned = true;
        thread arrySetColour( true, self getCurrentMenu(), self getCursor() );
        
        level._sphere = [];
        if( type == "large" )
        { v0 = 9; v1 = 18; v2 = 10; v3 = 20; } 
        if( type == "medium" )
        { v0 = 12.2; v1 = 24; v2 = 12.8; v3 = 15; }

        org = self.origin;
        level._sphere[level._sphere.size] = modelSpawner( org, "com_plasticcase_friendly", (0,0,0), .05, level.airDropCrateCollision);
        for(x=0;x<v3;x++)
        {
            for(e=0;e<(v3 - 1);e++)
                level._sphere[level._sphere.size] = modelSpawner( level._sphere[level._sphere.size-1].origin + (anglesToForward(level._sphere[level._sphere.size-1].angles) * 57) + (anglesToUp(level._sphere[level._sphere.size-1].angles) * v0), "com_plasticcase_friendly", level._sphere[level._sphere.size-1].angles - (v1, 0, 0), .05, level.airDropCrateCollision);
            level._sphere[level._sphere.size] = modelSpawner( org, "com_plasticcase_friendly", (0,0 + (x * v2),0), .05, level.airDropCrateCollision);
        }
    }
    else if(IsDefined( level.sphere_spawned ))
    {
        self notify("stop_sphere");
        level.sphere_spawned = undefined;
        thread arrySetColour( undefined, self getCurrentMenu(), self getCursor() );
        array_delete( level._sphere );
    }
}

//Spawn Black Hole 
spawn_blackhole()
{
    if(!isDefined(level.blackhole))
    {
        level.blackhole = true;
        self thread do_blackhole();
    }
    else 
    {   
        level.blackhole = undefined;
        level notify("stop_blackhole");
    }
    self arrySetColour( level.blackhole, "otherSpawnables", self getCursor() );
}

do_blackhole()
{
    level endon("stop_blackhole");
        
    blackhole = modelSpawner( self.origin + (0,0,40), "tag_origin" );
    blackhole thread blackhole_Effects();
    
    while( isDefined( level.blackHole ) )
    {
        array = [];
        array = getEntArray();
    
        for(e=0;e<array.size;e++)
        {
            if(distance( array[e].origin, blackhole.origin ) < 1500 && !isDefined( array[e].inBlackHole ) && array[e] != blackHole)
            {
                array[e] thread blackhole_suck( blackhole.origin, calcDistance(1000, array[e].origin, blackhole.origin), blackhole );
                wait .05;
            }
        }
        wait .1;
    }
    blackhole delete();
}

blackhole_Effects()
{
    while( isDefined(level.blackHole) )
    {
        playFxOnTag( level._effect[ "black_smoke"], self, "tag_origin" );
        wait .05;
    }
}

blackhole_suck( end, time, ent )
{
    if(isDefined(self.inBlackHole))
        return;
    self.inBlackHole = true;
    self moveTo( end, time );
    self waittill("movedone");
    
    playSoundAtPos( end, "semtex_warning" );
    playSoundAtPos( end, "grenade_explode_default" );
    
    if(getEntArray().size < 600 )
        playFx(loadfx("explosions/grenadeexp_mud"), self.origin);
    
    self.inBlackHole = undefined;
    self delete();
}

spawn_3D_model( modelID )
{
    if( IsDefined( level.dmc_model_spawned ) && level.dmc_model_spawned.size > 0 )
    {
        arrySetColour( undefined, self getCurrentMenu(), self getCursor() );
        array_delete( level.dmc_model_spawned );
        level.dmc_model_spawned = [];
    }
    
    arrySetColour( true, self getCurrentMenu(), self getCursor() );
    self thread refreshMenu();
    wait .2;
    
    level.dmc_model_spawned = [];
    str                     = do_keyboard( "3D Model Drawing" );
    position                = dmc2_get_positions( str, .8, 45 );  //.8, 45
    angles                  = self.angles;
    
    foreach( pos in position )
    {
        model = modelSpawner( AnglesToForward( angles ) * 240 + pos, modelID, angles );
        level.dmc_model_spawned[level.dmc_model_spawned.size] = model;
    }
    
    wait .2;
    self notify( "reopen_menu" );
}

spawn_3D_fx( fxID )
{
    if( IsDefined( level.dmc_fx_spawned ) && level.dmc_fx_spawned.size > 0 )
    {
        arrySetColour( undefined, self getCurrentMenu(), self getCursor() );
        array_delete( level.dmc_fx_spawned );
        level.dmc_fx_spawned = [];
        return;
    }
    
    arrySetColour( true, self getCurrentMenu(), self getCursor() );
    self thread refreshMenu();
    wait .2;
    
    level.dmc_fx_spawned = [];
    str                  = do_keyboard( "3D FX Drawing" );
    position             = dmc2_get_positions( str, .8, 4.5 );  //.8, 4.5
    angles               = self.angles;
    
    foreach( pos in position )
    {
        fx = SpawnFX( level._effect[ fxID ], AnglesToForward( angles ) * 190 + pos );
        TriggerFX( fx );
        level.dmc_fx_spawned[level.dmc_fx_spawned.size] = fx;
    }
    
    wait .2;
    self notify( "reopen_menu" );
}

dmc2_get_positions( str = "undefined", spacing, height )
{
    positions = [];
    angles    = self.angles;
    origin    = self.origin - (0,0,height);
    
    vecx = AnglesToRight(angles);
    vecy = AnglesToUp(angles);
    vecz = AnglesToForward(angles);
    str = toUpper( str );
    
    len = 0;
    for(i=0;i<str.size;i++)
    {
        letter = GetSubStr(str,i,i+1);
        len += level.aFontSize[letter] + spacing;
    }
    
    m = height; 
    x = (len / 2) * -1 * m;
    for(i=0;i<str.size;i++)
    {
        letter = GetSubStr(str,i,i+1);
        arr = level.aFont[letter];
        foreach(pos in arr)
        {
            ox = vectorScale(vecx, pos[0] * m + x);
            oy = vectorScale(vecy, (16 - pos[1]) * m);
            oz = vectorScale(vecz, 1);
            positions[ positions.size ] = origin + ox + oy + oz;
        }
        x += (level.aFontSize[letter] + spacing) * m;
    }
    return positions;
} 

dmc2_load_font()
{
    level.aFont = [];
    level.aFontSize = [];
    font_letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!#^&*()-=+[]{}\\/,.'\"?$:;_";
    
    font = [];
    font[font.size] = "....x....x....x....x...x...x....x....x...x...x....x...x.....x....x.....x....x.....x....x...x...x....x...x.....x...x...x...x..x...x...x....x...x...x...x...x...x...x.x.....x...x.....x...x..x..x...x...x...x..x..x...x...x...x...x..x.x#x#.#x...x...x.x..x...x";
    font[font.size] = ".... .... .... .... ... ... .... .... ... ... .... ... ..... .... ..... .... ..... .... ... ... .... ... ..... ... ... ... .. ... ... .... ... ... ... ... ... ... . ..... ... ..... ... .# #. ... ... ... ## ## ..# #.. #.. ..# .. . # #.# ... .#. . .. ... ";
    font[font.size] = ".##. ###. .##. ###. ### ### .##. #..# ### ### #..# #.. .#.#. #..# .###. ###. .###. ###. ### ### #..# #.# #.#.# #.# #.# ### .# ##. ### ..#. ### ### ### ### ### ### # .#.#. .#. .##.. .#. #. .# ... ... ... #. .# .#. .#. #.. ..# .. . . ... ### ### . .. ... ";
    font[font.size] = "#..# #..# #..# #..# #.. #.. #... #..# .#. .#. #.#. #.. #.#.# ##.# #...# #..# #...# #..# #.. .#. #..# #.# #.#.# #.# #.# ..# ## ..# ..# .##. #.. #.. ..# #.# #.# #.# # ##### #.# #..#. ### #. .# ... ### .#. #. .# .#. .#. .#. .#. .. . . ... ..# #.. # .# ... ";
    font[font.size] = "#### ###. #... #..# ##. ##. #.## #### .#. .#. ###. #.. #.#.# #.## #...# #..# #.#.# #..# ### .#. #..# #.# #.#.# .#. .#. .#. .# .#. ### #.#. ##. ### ..# ### ### #.# # .#.#. ... .##.. .#. #. .# ### ... ### #. .# #.. ..# .#. .#. .. . . ... .## ### . .. ... ";
    font[font.size] = "#..# #..# #..# #..# #.. #.. #..# #..# .#. .#. #.#. #.. #.#.# #..# #...# ###. #..#. ###. ..# .#. #..# #.# #.#.# #.# .#. #.. .# #.. ..# #### ..# #.# .#. #.# ..# #.# . ##### ... #..#. #.# #. .# ... ### .#. #. .# .#. .#. .#. .#. .. . . ... ... ..# # .# ... ";
    font[font.size] = "#..# ###. .##. ###. ### #.. .##. #..# ### #.. #..# ### #.#.# #..# .###. #... .##.# #..# ### .#. .### .#. .#.#. #.# .#. ### .# ### ### ..#. ##. ### .#. ### ### ### # .#.#. ... .##.# ... #. .# ... ... ... #. .# .#. .#. ..# #.. .# # . ... .#. ### . #. ### ";
    font[font.size] = ".... .... .... .... ... ... .... .... ... ... .... ... ..... .... ..... .... ..... .... ... ... .... ... ..... ... ... ... .. ... ... .... ... ... ... ... ... ... . ..... ... ..... ... .# #. ... ... ... ## ## ..# #.. ..# #.. #. . . ... ... .#. . .. ... ";

    pos1 = 0;
    index = 0;
    for(i=0;i<font[0].size;i++) 
    {
        if(GetSubStr(font[0], i, i + 1) == "x")
        {
            pos2 = i;
            letter = GetSubStr(font_letters, index, index+1);
            level.aFont[letter] = [];
            level.aFontSize[letter] = pos2 - pos1;
            for(x=pos1;x<pos2;x++) 
            {
                for(y=0;y<font.size;y++)
                {
                    if(GetSubStr(font[y], x, x+1) == "#") 
                        level.aFont[letter][level.aFont[letter].size] = (x - pos1, y, 0);
                }
            }
            index++;
            pos1 = pos2 + 1;
        }
    }
}

//Fireball 
do_fireball()
{
    if(!isDefined(level.fireball_spawned))
    {
        level.fireball_spawned = true;
        self thread arrySetColour(level.fireball_spawned, self getCurrentMenu(), self getCursor());
        self thread spawn_fireball(); 
    }
    else self iprintln("^1Error^7: The Fireball has already been spawned.");
}

delete_fireball()
{
    level notify("stop_fireball");
    level thread detach_from_seat();
    level.fireball_spawned = undefined;
    self thread arrySetColour( level.fireball_spawned, self getCurrentMenu(), 0 );
    deleteMultipleArrays( level.fireball, level.fireball.track, level.fireball.cart, level.fireball.cart_tags, level.fireball.cart_seats );
}

spawn_fireball()
{
    level endon("stop_fireball");
    
    level.fireball = SpawnStruct();
    level.fireball.track = [];
    
    level.fireball.cart       = [];
    level.fireball.cart_tags  = [];
    level.fireball.cart_seats = [];
    
    origin = self lookpos();
    angles = self.angles;
    
    level.fireball.link = modelSpawner( origin + (0,0,356), "tag_origin", angles );
    level.fireball.track[0] = modelSpawner( origin, "com_plasticcase_friendly", angles, .05 );
    
    for(e=0;e<38;e++)
    {
        previous_track = level.fireball.track[level.fireball.track.size-1];
        level.fireball.track[level.fireball.track.size] = modelSpawner( previous_track.origin + (anglesToForward(previous_track.angles) * 57) + (anglesToUp(previous_track.angles) * 4.615), "com_plasticcase_friendly", previous_track.angles - (9.23, 0, 0), .05 );
    }
    
    model = "weapon_riot_shield_mp";
    for(e=0;e<4;e++)
    {
        level.fireball.cart_tags[e] = modelSpawner(level.fireball.track[e].origin + (0,0,6), "tag_origin", level.fireball.track[e].angles);
        
        level.fireball.cart[level.fireball.cart.size] = modelSpawner(level.fireball.track[e].origin + (0,0,28) + (anglesToForward(level.fireball.track[e].angles)*(-20)), model, (level.fireball.track[e].angles[0]+180, level.fireball.track[e].angles[1], level.fireball.track[e].angles[2]+90));
        
        if(e < 3)
            level.fireball.cart[level.fireball.cart.size] = modelSpawner(level.fireball.track[e].origin + (0,0,28) + (anglesToForward(level.fireball.track[e].angles)*(20)), model, (level.fireball.track[e].angles[0], level.fireball.track[e].angles[1], level.fireball.track[e].angles[2]+90));
        else
            level.fireball.cart[level.fireball.cart.size] = modelSpawner(level.fireball.track[e].origin + (0,0,28) + (anglesToForward(level.fireball.track[e].angles)*(20)), model, level.fireball.track[e].angles);
         
        level.fireball.cart[level.fireball.cart.size] = modelSpawner(level.fireball.track[e].origin + (0,0,10), "com_plasticcase_enemy", level.fireball.track[e].angles); 
            
        for(b=(e*2);b<level.fireball.cart.size;b++)
            level.fireball.cart[b] linkTo(level.fireball.cart_tags[e]);
        
        level.fireball.cart_tags[e] linkto( level.fireball.link );    
    }
    
    thread array_thread(level.fireball.cart_tags, ::monitorSeats, "Fireball", level.fireball.cart_tags );
    level thread fireball_cart( level.fireball );
}

fireball_cart( fireball )
{
    level endon("stop_fireball");
    while( isDefined(level.fireball_spawned) )
    {
        fireball.link RotatePitch( -40, 2.1, 1, 1 ); //-30
        wait 2.4;
        fireball.link RotatePitch( 90, 2.1, 1, 1 ); //30
        wait 2.4;
        
        for(e=0;e<5;e++)
        {
            fireball.link RotatePitch( -100 - (e*30), 2.1, 1, 1 ); 
            wait 2.3;
            fireball.link RotatePitch( 120 + (e*30), 2.1, 1, 1 ); 
            wait 2.3; 
        }
        fireball.link RotatePitch( -1220, 6, 1, 1 ); 
        
        for(e=0;e<120;e++)
        {
            effect = SpawnFx( level._effect["fire"], fireball.cart_tags[0].origin + AnglesToUp( fireball.cart_tags[0].angles ) * 20 );
            TriggerFX( effect );
            wait .05;
        }
        wait 6;
    }
}

spiralStaircase( height )
{
    if(IsDefined( level.spiral ))
        array_delete( level.spiral );
    org = self.origin;
    level.spiral = [];
    for(e=0;e<int(height);e++)
        level.spiral[level.spiral.size] = modelSpawner(org + (cos(e*45)*75, sin(e*45)*75, e*20), "com_plasticcase_enemy", (-20, 90+(e*45), 0), .05, level.airDropCrateCollision);
}
   
//Space vertigo
do_vertigo()
{
    if(!isDefined(level.vertigo_spawned))
    {
        level.vertigo_spawned = true;
        self thread arrySetColour(level.vertigo_spawned, self getCurrentMenu(), self getCursor());
        self thread spawn_vertigo(); 
    }
    else self iprintln("^1Error^7: Vertigo has already been spawned.");
}

delete_vertigo()
{
    level notify("stop_vertigo");
    level thread detach_from_seat();
    level.vertigo_spawned = undefined;
    self thread arrySetColour( level.vertigo_spawned, self getCurrentMenu(), 0 );
    deleteMultipleArrays( level.vertigo.pole, level.vertigo.seat, level.vertigo.circle, level.linkVert );
}

spawn_vertigo()
{
    level endon("stop_vertigo");
    origin = self lookpos() + (0,0,15);
    
    level.vertigo  = SpawnStruct();
    level.linkVert = modelSpawner(origin, "tag_origin");
    
    level.vertigo.pole = []; level.vertigo.seat = []; level.vertigo.circle = [];
    for(i = 0; i < 25; i++) for(x = 0; x < 8; x++)
        level.vertigo.pole[level.vertigo.pole.size] = modelSpawner(origin+(cos(x*45)*25,sin(x*45)*25, i*57), "com_plasticcase_enemy", (90,(x*45)+90,0), .05);
    for(i = 0; i < 8; i++)
        level.vertigo.seat[level.vertigo.seat.size] = modelSpawner(origin+(cos(i*45)*75,sin(i*45)*75, 10), "com_plasticcase_friendly", (0,(i*45)+90,0), .05);
        
    for(w = 0; w < 2; w++)
    {
        if(w == 1)
            level.linkVert rotateTo(level.linkVert.angles+(0,22.5,0), .05);
        for(i = 0; i < 3; i++) for(x = 0; x < 8; x++)
            level.vertigo.circle[level.vertigo.circle.size] = modelSpawner(origin+(cos(x*45)*((i*30)+60),sin(x*45)*((i*30)+60), 120), "com_plasticcase_enemy", (0,(x*45)+90,0), .05);
        
        foreach(package in level.vertigo.circle)
            package linkTo(level.linkVert);    
    }    
        
    foreach(seat in level.vertigo.seat)  
        seat linkTo(level.linkVert);
    thread array_thread(level.vertigo.seat, ::monitorSeats, "Vertigo", level.vertigo.seat );
    
    level.linkVert thread move_vertigo( origin, origin + (0,0,1260) );
}

move_vertigo( start_z, end_z )
{
    level endon("stop_vertigo");

    direction = -1;
    while( IsDefined( self ) )
    {
        if( direction == -1 )
        {
            direction = 1;
            self moveTo(end_z, 10, 5, 5);
            wait 10;
            random = randomIntRange(2, 5);
            self vibrate(self.origin+(1,1,0), .2, .3, random);
            earthquake(.4, .6, self.origin, 300);
            wait random;
        }
        else
        {
            direction = -1;
            self moveTo(start_z, 1, .05, .05);
            wait 1;
            self vibrate(self.origin+(1,1,0), .4, .6, 4);
            earthquake(.6, .8, self.origin, 300);
            wait 4;
        }
        wait .05;
    }
}

players_tic_tac_toe( name = self.name )
{
    if(IsDefined( level.tic_tac_toe_active ))
        return self IPrintLn( "Please wait until the previous game has been played." );
    foreach( players in level.players )
        if( name == players.name )
            player = players;
    
    level.confirmed_selection = [];
    level.tic_tac_toe_active  = true;
    level.players_turn        = RandomIntRange( 0, 1 ) ? "X" : "O";
    
    origin = self.origin;
    self build_tic_tac_toe( origin );
    
    self thread monitor_tic_tac_toe( "X", "O" );
    self thread tic_tac_toe_camera( origin, 1, 180 );
    
    player thread monitor_tic_tac_toe( "O", "X" );
    player thread tic_tac_toe_camera( origin, -1, 0 );
}

build_tic_tac_toe( origin )
{
    level.tic_tac_toe        = SpawnStruct();
    level.tic_tac_toe.blocks = [];
    level.tic_tac_toe.lights = [];
    
    for(x=0;x<3;x++) for(e=0;e<3;e++)
    {
        level.tic_tac_toe.blocks[level.tic_tac_toe.blocks.size] = modelSpawner(origin + (-49 + x*49, -49 + e*49, 0), "tag_origin", undefined, .1);
        level.confirmed_selection[level.confirmed_selection.size] = "";
    }
    for(x=0;x<4;x++) for(e=0;e<36;e++)
    {
        if(x < 2) level.tic_tac_toe.lights[level.tic_tac_toe.lights.size] = spawnFx(level._effect["red"], origin + (-27.5 + x*49, -70 + e*4,22.5), (180,0,0));
        else level.tic_tac_toe.lights[level.tic_tac_toe.lights.size] = spawnFx(level._effect["red"], origin + (-73.5 + e*4, -24.5 + (x - 2)*49, 22.5), (180,0,0));
        triggerFx(level.tic_tac_toe.lights[level.tic_tac_toe.lights.size-1]);
        wait .01;
    }
}

monitor_tic_tac_toe( symbol, e_symbol )
{
    l_lights = [];
    p_lights = [];
    while( IsDefined( level.tic_tac_toe_active ) )
    {
        if( level.players_turn == symbol )
        { 
            count = 0;
            foreach( index, block in level.tic_tac_toe.blocks )
            {
                true_angle = vectornormalize( block.origin - self getTagOrigin( "tag_weapon_right" ) );
                my_angle   = anglestoforward( self getTagAngles( "tag_weapon_right" ) );
                
                if( level.confirmed_selection[ index ] == "" )
                {
                    count++;
                    if( vectordot( my_angle, true_angle ) > cos( 5 ) )
                    {
                        if( self UseButtonPressed() )
                        {
                            level.confirmed_selection[ index ] = symbol;
                            level.players_turn = e_symbol;
                            l_lights           = tic_tac_toe_symbols( symbol, block.origin, l_lights );
                            if( check_for_win( symbol, level.confirmed_selection ) )
                                level.tic_tac_toe_active = undefined;
                            wait .1;
                        }
                        else 
                        {
                            p_lights = tic_tac_toe_symbols( symbol, block.origin, p_lights );
                            wait .1;
                            array_delete( p_lights );
                        }
                    }
                }
            }
            if( count == 0 ) //checks for draw
                level.tic_tac_toe_active = undefined;
        }
        wait .05;
    }
    
    deleteMultipleArrays( l_lights, p_lights, level.tic_tac_toe.blocks, level.tic_tac_toe.lights );
}

tic_tac_toe_symbols( symbol, origin, lights )
{
    if( symbol == "X" )
    {
        for(i=0;i<12;i++)
        {
            lights[lights.size] = spawnFx(level._effect["green"], (origin + (-5,1,23.5) + (18 - i*3, -18 + i*3, 0)), (180,0,0));
            triggerFx(lights[lights.size-1]);
            lights[lights.size] = spawnFx(level._effect["green"], (origin + (-5,1,23.5) + (-15 + i*3, -18 + i*3, 0)), (180,0,0));
            triggerFx(lights[lights.size-1]);
        }   
    }
    else // symbol == "O"
    {
        for(i=0;i<24;i++)
        {
            lights[lights.size] = spawnFx(level._effect["green"], (origin + (-4,-.5,23.5) + (cos(i*15)*17, sin(i*15)*17, 0)), (180,0,0));
            triggerFx(lights[lights.size-1]);
        }
    }
    return lights;
}

tic_tac_toe_camera( origin, flip, angle )
{
    camera_player = modelSpawner( origin + (120 * flip, 0, 200), "tag_origin", (0, angle, 0), .05);
    
    self PlayerLinkToDelta( camera_player, "tag_origin", 1, 35, 35, -180, 70 ); 
    
    self EnableInvulnerability();
    self hide();
    
    while(IsDefined( level.tic_tac_toe_active ))
        wait .1;
    
    if(!isDefined(self.godmode))
        self DisableInvulnerability();
    self show();
    camera_player delete();
}

check_for_win( symbol, block )
{
    for(e=0;e<3;e++) if(block[e] == symbol && block[e+3] == symbol && block[e+6] == symbol) return true;
    for(e=0;e<7;e+=3) if(block[e] == symbol && block[e+1] == symbol && block[e+2] == symbol) return true;
    for(e=0;e<2;e++) if(block[(0+(2*e))] == symbol && block[4] == symbol && block[(8-(2*e))] == symbol) return true;
    return false;
}










