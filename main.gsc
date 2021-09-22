/* Credits:
    ? Extinct ~ Base Creator
    ? Agreedbog & SyGnUs ~ Infinity Loader Creator
*/

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\killstreaks\_autosentry;
#include common_scripts\_destructible;
#include common_scripts\_destructible_types;
#include maps\mp\gametypes\_missions;
#include maps\mp\gametypes\_class;
#include maps\mp\killstreaks\_perkstreaks;
#include maps\mp\perks\_perkfunctions;

#include maps\mp\killstreaks\_remoteuav;
#include maps\mp\gametypes\_rank;
#include maps\mp\killstreaks\_airdrop;
#include maps\mp\gametypes\_quickmessages;

#include maps\mp\killstreaks\_killstreaks;

init()
{
    level thread onPlayerConnect();
    level thread createRainbowColor();
    level loadarrays();
    
    level.strings  = [];
    level.status   = strTok("None;VIP;Admin;Co-Host;Host", ";");
    level.menuName = "Sub Version 2.1.1";
 
    precacheItem( "aamissile_projectile_mp" );
    PreCacheModel( "com_plasticcase_enemy" );
    PreCacheModel( "com_plasticcase_friendly" );
    PreCacheModel( "com_plasticcase_trap_bombsquad" );
    PreCacheModel( "defaultactor" );
    PreCacheModel( "test_sphere_silver" );
    PreCacheModel( "projectile_rpg7" );
    
    PreCacheShader( "compassping_enemyfiring" );
    PreCacheShader( "remotemissile_target_friendly" );
    
    level.rankTables = [];
    for(e=0;e<70;e++)
        level.rankTables[e] = tableLookup( "mp/ranktable.csv", 0, e, 2 ); //XP  
    
    bypassDvars  = [ "pdc", "validate_drop_on_fail", "validate_apply_clamps", "validate_apply_revert", "validate_apply_revert_full", "validate_clamp_experience", "validate_clamp_weaponXP", "validate_clamp_kills", "validate_clamp_assists",     "validate_clamp_headshots", "validate_clamp_wins", "validate_clamp_losses", "validate_clamp_ties", "validate_clamp_hits", "validate_clamp_misses", "validate_clamp_totalshots", "dw_leaderboard_write_active", "matchdata_active" ];
    bypassValues = [ "0", "0", "0", "0", "0", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1", "1" ];
    for( e = 0; e < bypassDvars.size; e++ )
    {
        makeDvarServerInfo( bypassDvars[e], bypassValues[e] );
        setDvar( bypassDvars[e], bypassValues[e] );
    }
    
    precacheModel( "vehicle_remote_uav" );
    level._effect[ "ac130_light_red_blink" ]    = loadfx( "misc/aircraft_light_red_blink" );
    level._effect[ "ac130_light_red" ]          = loadfx( "misc/aircraft_light_wingtip_red" );
    
    level._effect["smoke"] = loadfx( "props/american_smoke_grenade_mp" );
    level._effect["rpg_trail"] = loadfx("smoke/smoke_geotrail_rpg");
    level._effect["fire"] = LoadFX( "fire/tank_fire_engine" );
    
    level._effect["red"] = level._effect[ "ac130_light_red" ];
    level._effect["green"] = level._effect[ "ac130_light_red" ];
    
    shaders = StrTok( "ui_host;gradient_fadein;gradient;gradient_top;gradient_bottom;ui_scrollbar_arrow_dwn_a;ui_scrollbar_arrow_up_a", ";" );
    foreach(shader in shaders)
        PreCacheShader( shader ); 
        
    //SetByte(0x4A9963, 0xEB); //Patched 'Renamed Player'
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");
    self waittill("spawned_player");
    
    if(self isHost())
    {
        self FreezeControls( false );
        self thread overflowfix(); 
        self thread initializeSetup( 4, self );
    }
}

overflowfix()
{
    level.overflow       = newHudElem();
    level.overflow.alpha = 0;
    level.overflow setText( "marker" );

    for(;;)
    {
        level waittill("CHECK_OVERFLOW");
        if(level.strings.size >= 45)
        {
            level.overflow ClearAllTextAfterHudElem();
            level.strings = [];
            level notify("FIX_OVERFLOW");
        }
    }
}

suicide_bomber() 
{
    self thread refreshMenu();
    wait .2;
    self beginLocationSelection( "map_artillery_selector", false, 500 );  
    self waittill( "confirm_location", location ); 
    pos = BulletTrace( location + (0,0,1000), location - (0,0,1000), false )[ "position" ];
    self endLocationSelection();
    self.selectingLocation = undefined;
    self notify( "stop_location_selection" );
    
    pathStart = pos + (0,0,20000);    
        
    plane = spawnplane( self, "script_model", pathStart, "compass_objpoint_airstrike_friendly", "compass_objpoint_airstrike_busy" );
    
    plane setModel( "vehicle_mig29_desert" );
    plane.angles = (90, RandomInt( 360 ), 0);
    plane.owner  = self;
    
    wait .05;
    // Fix bomb to drop precisely onto the chosen position 
    plane.origin = plane.origin - AnglesToUp( plane.angles ) * 300;
    
    plane thread maps\mp\killstreaks\_airstrike::playPlaneFx();
    
    plane playloopsound( "veh_mig29_dist_loop" );
    
    plane thread auto_path_finder( .1 );
    
    wait .2;
    self notify( "reopen_menu" );
}

auto_path_finder( flyTime = .1 )
{
    self endon("death");
    
    planeFlyHeight = getEnt( "airstrikeheight", "targetname" ).origin[2];
    for(e=0;e<200;e++) //20 seconds
    {
        pathEnd = self.origin + AnglesToForward( self.angles) * 500;
        self moveTo( pathEnd, flyTime, 0, 0 ); 
        
        // Rotate so it doesn't hit the ground
        if( !IsDefined( rotate_plane ) && self.origin[2] - 1500 <= planeFlyHeight )
        {
            rotate_plane = 1;
            self RotatePitch( -90, flyTime * 3, flyTime, flyTime * 2 );
            
            self playSound( "veh_b2_sonic_boom" );
            
            thread callStrike_bombEffect( self, .1 );
        }
        wait flyTime;
    }
    self delete();
}

callStrike_bombEffect( plane, launchTime )
{
    wait launchTime;   
    
    plane playSound( "veh_mig29_sonic_boom" );
    planeDir = AnglesToForward( plane.angles );
        
    bomb = modelSpawner( plane.origin + (planeDir * 400), "projectile_cbu97_clusterbomb", plane.angles );
    bomb MoveGravity( ( planeDir  * ( 5000 / 1.5 ) ), 3.0 );
    
    newBomb = modelSpawner( bomb.origin, "tag_origin", bomb.angles );
    wait .1;  // wait two server frames before playing fx
    
    bombOrigin = bomb.origin;
    bombAngles = bomb.angles;
    playfxontag( level.airstrikefx, bomb, "tag_origin" );
    wait .5;
    
    repeat    = 12;
    minAngles = 5;
    maxAngles = 55;
    angleDiff = (maxAngles - minAngles) / repeat;
    hitpos    = (0,0,0);
    
    for( i = 0; i < repeat; i++ )
    {
        traceDir = anglesToForward( bombAngles + (maxAngles-(angleDiff * i), randomInt( 10 )-5,0) );
        traceEnd = bombOrigin + vector_multiply( traceDir, 10000 );
        trace    = bulletTrace( bombOrigin, traceEnd, false, undefined );
        
        traceHit = trace["position"];
        hitpos += traceHit;
        
        radiusDamage( traceHit + ( 0, 0, 16 ), 300, 250, 90, self.owner, "MOD_EXPLOSIVE", "airdrop_trap_explosive_mp" );
    
        if ( i % 3 == 0 )
        {
            thread playsoundinspace( "exp_airstrike_bomb", traceHit );
            playRumbleOnPosition( "artillery_rumble", traceHit );
            earthquake( 0.7, 0.75, traceHit, 1000 );
        }
        
        wait ( 0.05 );
    }
    
    newBomb delete();
    bomb delete();
}














Build_TheClaw()
{
    level endon("Destroy_Claw");
    level.clawOrg = self.origin;
    pos           = level.clawOrg+(0,15,400);
    
    level.ClawSeats = [];
    level.claw = [];
    level.legs = [];
    
    level.attach = modelSpawner(level.clawOrg+(0,55,60),"tag_origin");
    level.ClawLink = modelSpawner(pos,"tag_origin");
    
    for(i=0;i<2;i++) for(e=0;e<2;e++) for(a=0;a<8;a++) 
    {
        multi = (i == 1) ? -1 : 1;
        level.legs[level.legs.size] = modelSpawner(level.clawOrg + (-220 * multi, -146 + (e*310), 0) + (a* (28 * multi), 8, a*49), "com_plasticcase_enemy", (120 * multi, 0, 90),.1);
    }

    for(a=0;a<6;a++) for(e=0;e<8;e++)
        level.claw[level.claw.size] = modelSpawner(level.clawOrg + (0,-125+(a*57),400) + (sin(-90 + (e*45))*25, 0, sin(e*45)*25), "com_plasticcase_enemy", (0,90,(e*45)),.1);
    for(a=0;a<8;a++) for(e=0;e<6;e++)
        level.claw[level.claw.size] = modelSpawner(level.clawOrg + (0,15,385) + (cos(a*45)*30,sin(a*45)*30, e*-57), "com_plasticcase_enemy", (90,(a*45)+90,90),.1);
    level.claw[level.claw.size] = modelSpawner(level.clawOrg + (0,15, 60), "com_plasticcase_enemy", (90,90,90),.1);    
    
    for(a=0;a<2;a++) for(e=0;e<12;e++)
        level.claw[level.claw.size] = modelSpawner(level.clawOrg + (0,15,100) + (cos(e*30)* (40 + a*55) ,sin(e*30)* (40 + a*55), -70), "com_plasticcase_enemy", (0, (e*30) + (a*90), 0), .1);
    for(e=0;e<12;e++) level.ClawSeats[level.ClawSeats.size] = modelSpawner(level.clawOrg + (0,15,95) + (cos(e*30)*86,sin(e*30)*86, -60), "tag_origin", Undefined,.1);
    
    foreach(model in level.claw)
        model linkTo(level.ClawLink);
    foreach(model in level.ClawSeats)
        model linkTo(level.ClawLink);
    
    level.ClawLink thread ClawMovements();
    thread array_thread(level.ClawSeats, ::monitorSeats, "The Claw", level.ClawSeats );
}

ClawMovements()
{
    level endon("Destroy_Claw");
    
    level.claw_speed  = .5;
    level.claw_height = 170;
    
    speed  = level.claw_speed;
    height = level.claw_height;

    for(e=0; e > 0 - (height / 3); e-=2)
    {
        self rotateTo( (e, self.angles[1], 0), speed);
        wait .1; 
    }
    
    for(e=e; e < (height / 2.5); e+=3)
    {
        self rotateTo( (e, self.angles[1], 0), speed );
        wait .1;
    }
    
    for(e=e; e > 0 - (height / 2); e-=3)
    {
        self rotateTo( (e, self.angles[1], 0), speed );
        wait .05;
    }
    
    for(e=e; e < (height / 1.5); e+=4)
    {
        self rotateTo( (e, self.angles[1], 0), speed );
        wait .05;
    }
    
    while( true )
    {
        for(e=e; e > 0 - height; e-=5)
        {
            self rotateTo( (e, self.angles[1], 0), speed );
            wait .05;
        }

        for(e=e; e < height; e+=5)
        {
            self rotateTo( (e, self.angles[1], 0), speed );
            wait .05;
        }
        wait .05;
    }
}
