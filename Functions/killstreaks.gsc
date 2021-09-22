give_Killstreak( ks )
{
    self thread maps\mp\killstreaks\_killstreaks::giveKillstreak( ks, false, false, self, true );
    self iPrintln( constructString( replaceChar( ks, "_", " " ) ), " Granted!" );
}

//GAS STRIKE ~ Extinct 
do_gas_strike()
{
    if( IsDefined( level.gasStrikeActive ) )
        return self IPrintLn( &"MP_AIR_SPACE_TOO_CROWDED" );
        
    self thread refreshMenu();
    wait .8;
        
    self beginLocationSelection( "map_artillery_selector", false, 500 );  
    self waittill( "confirm_location", location ); 
    pos = BulletTrace( location + (0,0,1000), location - (0,0,1000), false )[ "position" ];
    self endLocationSelection();
    self.selectingLocation = undefined;
    self notify( "stop_location_selection" );
    self thread doStrike( location, randomint(360) );
    
    wait .2;
    self notify( "reopen_menu" );
}

doStrike( location, directionYaw )
{
    level.gasStrikeActive = true;
    
    wait ( 1 );
    
    planeFlyHeight = getEnt( "airstrikeheight", "targetname" ).origin[2];
    dirVector      = AnglesToForward( (0, directionYaw, 0) );
    self thread doOneFlyby( location, dirVector, planeFlyHeight );
}

doOneFlyby( targetPos, dir, flyHeight )
{
    flightPath = getFlightPath( targetPos, dir, 15000, true, flyHeight, 5000, 0 );
    level thread doFlyby( self, flightPath["startPoint"] + (0, 0, randomInt(500) ), flightPath["endPoint"] + (0, 0, randomInt(500) ), flightPath["attackTime"], flightPath["flyTime"], dir );
}
 
dropBombs( pathEnd, flyTime, beginAttackTime, owner )   // self == plane
{
    self endon( "death" );
    
    wait (beginAttackTime);
    
    numBombsLeft     = 9;
    timeBetweenBombs = 350 / 5000;
    
    while (numBombsLeft > 0)
    {
        self thread dropOneBomb( owner );
        
        numBombsLeft--;
        wait ( timeBetweenBombs );
    }
}

dropOneBomb( owner )    // self == plane
{
    plane = self;
    planeDir = AnglesToForward( plane.angles );
        
    bomb = modelSpawner( plane.origin + (planeDir * 400), "projectile_cbu97_clusterbomb", plane.angles );
    bomb MoveGravity( ( planeDir  * ( 5000 / 1.5 ) ), 3.0 );
    
    newBomb = modelSpawner( bomb.origin, "tag_origin", bomb.angles );
    wait .1;  // wait two server frames before playing fx
    
    playfxontag( level.airstrikefx, newBomb, "tag_origin" );
    wait .5;
    
    trace          = BulletTrace(plane.origin, plane.origin - (0,0,1000000), false, undefined);
    impactPosition = trace["position"];
    wait .5;
    
    bomb onBombImpact( owner, impactPosition );
    
    newBomb delete();
    bomb delete();
}

onBombImpact( owner, position ) // self == bomb?
{
    effectArea = Spawn( "trigger_radius", position, 0, 200, 120 );
    effectArea.owner = owner;
    
    effectRadius = 200;
    wait ( RandomFloatRange( 0.25, 0.5) );
    
    timeRemaining = 13;
    
    killCamEnt = Spawn( "script_model", position + (0, 0, 60) );
    killCamEnt LinkTo( effectArea );
    self.killCamEnt = killCamEnt;

    PlaySoundAtPos( position, "exp_airstrike_bomb" );
        
    while ( timeRemaining > 0.0 )
    {
        vfx = SpawnFx( level._effect["smoke"], position ); 
        TriggerFX( vfx );
        foreach ( character in level.players )
            character applyGasEffect( owner, position, effectArea, self, 20 );
        
        wait ( 1.0 );
        timeRemaining -= 1.0;
    }
    
    level.gasStrikeActive = undefined;
    self.killCamEnt Delete();
    
    effectArea Delete();
    vfx Delete();
}

applyGasEffect( attacker, position, trigger, inflictor, damage )    // self == target
{
    if( (attacker isEnemy( self )) && IsAlive( self ) && self IsTouching( trigger ) )
    {
        inflictor RadiusDamage( self.origin, 1, damage, damage, attacker, "MOD_RIFLE_BULLET", "gas_strike_mp");
        if ( !self isUsingRemote() )
            self ShellShock( "default", 2 );
    }
}

doFlyby( owner, startPoint, endPoint, attackTime, flyTime, directionVector )
{
    plane = planeSpawn( owner, startPoint, directionVector );
    
    plane endon( "death" );
    
    endPathRandomness = 150;
    pathEnd  = endPoint + ( (RandomFloat(2) - 1) * endPathRandomness, (RandomFloat(2) - 1) * endPathRandomness, 0 );
    
    plane planeMove( pathEnd, flyTime, attackTime );
    
    plane notify( "delete" );
    plane delete();
}

planeSpawn( owner, startPoint, directionVector )
{
    pathStart   = startPoint + ( (RandomFloat(2) - 1) * 100,  (RandomFloat(2) - 1) * 100, 0 );
    plane       = modelSpawner( pathStart, "vehicle_mig29_desert", VectorToAngles( directionVector ) );
    plane.owner = owner;
    plane maps\mp\killstreaks\_airstrike::playPlaneFx();
    
    plane PlayLoopSound( "veh_mig29_dist_loop" );
    return plane;
}

planeMove( destination, flyTime, attackTime )   // self == plane
{
    self MoveTo( destination, flyTime, 0, 0 ); 
    
    self thread dropBombs( destination, flyTime, attackTime, self.owner );
    self thread playSonicBoom( "veh_mig29_sonic_boom", 0.5 * flyTime );
    
    // fly away
    wait( 0.65 * flyTime );
    
    self StopLoopSound();
    self PlayLoopSound( "veh_aastrike_flyover_outgoing_loop" );
    
    wait ( 0.35 * flyTime );
} 

getFlightPath( coord, directionVector, planeHalfDistance, absoluteHeight, planeFlyHeight, planeFlySpeed, attackDistance )
{
    // stealth_airstrike moves this a lot more
    startPoint = coord + ( directionVector * ( -1 * planeHalfDistance ) );
    endPoint = coord + ( directionVector * planeHalfDistance );
    
    if ( absoluteHeight ) // used in the new height system
    {
        startPoint *= (1, 1, 0);
        endPoint *= (1, 1, 0);
    }
    
    startPoint += ( 0, 0, planeFlyHeight );
    endPoint += ( 0, 0, planeFlyHeight );
    
    // Make the plane fly by
    d = length( startPoint - endPoint );
    flyTime = ( d / planeFlySpeed );
    
    // bomb explodes planeBombExplodeDistance after the plane passes the center
    d          = abs( 0.5 * d + attackDistance  );
    attackTime = ( d / planeFlySpeed ) - .7;

    flightPath = [];
    flightPath["startPoint"] = startPoint;
    flightPath["endPoint"] = endPoint;
    flightPath["attackTime"] = attackTime;
    flightPath["flyTime"] = flyTime;
    
    return flightPath;
}

//custom sentry gun 
spawn_sentry( weapon )
{
    if(!IsDefined( self.custom_sentry ))
    {
        wait .1; //STOPS FROM INSTANTLY PICKING UP THE TURRET
        self.custom_sentry        = spawnTurret( "misc_turret", self.origin, "sentry_minigun_mp" );
        self.custom_sentry.angles = self.angles;
        self.custom_sentry.weapon = weapon;
        
        self.custom_sentry sentry_do( "sentry_minigun", self );
        self.custom_sentry sentry_setplaced();
    }
    else
    { 
        self.custom_sentry notify ( "death" );
        self.custom_sentry = undefined;
    }
}

sentry_do( sentryType, owner, weapon )
{
    self.sentryType = sentryType;

    self setModel( level.sentrySettings[ self.sentryType ].modelBase );
    self.health = 1000;
    
    self setCanDamage( true );
    self makeTurretInoperable();
    
    self setTurretModeChangeWait( true );
    self sentry_setInactive();
    self setDefaultDropPitch( -89.0 );  // setting this mainly prevents Turret_RestoreDefaultDropPitch() from running
    
    self sentry_setOwner( owner );
    self thread sentry_handleDeath();
    self thread sentry_handleUse();
    self thread sentry_attackTargets_new();
    self thread sentry_beepSounds();
}

sentry_attackTargets_new()
{
    self endon( "death" );
    level endon( "game_ended" );

    self.momentum = 0;
    self.heatLevel = 0;
    self.overheated = false;
    
    self thread sentry_heatMonitor();
    
    for(;;)
    {
        self waittill( "turretstatechange" );

        if ( self isFiringTurret() )
            self thread sentry_burstFireStart_new();
        else
        {
            self sentry_spinDown();
            self thread sentry_burstFireStop();
        }
    }
}

sentry_burstFireStart_new()
{
    self endon( "death" );
    self endon( "stop_shooting" );
    level endon( "game_ended" );

    self sentry_spinUp();

    fireTime = .2;
    minShots = 20;
    maxShots = 120;
    minPause = 0.15;
    maxPause = 0.35;

    for(;;)
    {       
        numShots = randomIntRange( minShots, maxShots + 1 );
        
        for ( i = 0; i < numShots && !self.overheated; i++ )
        {
            MagicBullet( self.weapon, self getTagOrigin("tag_flash"), self getTagOrigin("tag_flash") + AnglesToForward( self GetTagAngles("tag_flash") ) * 999, self.owner);
            self.heatLevel += fireTime;
            wait ( fireTime );
        }
        
        wait ( randomFloatRange( minPause, maxPause ) );
    }
}

//Swarm 
spawn_swarm_box()
{
    if( IsDefined( level.swarm_active ) )
        return self IPrintLn( "Swarm is already active." );
        
    thread arrySetColour( level.swarm_active, "customKS", 2 );    
    
    origin = self.origin + AnglesToForward( self.angles ) * 60;
    model  = "test_sphere_silver";
    
    swarm_box       = modelSpawner( self.origin, model );
    swarm_center    = modelSpawner( level.mapCenter, "tag_origin" );
    
    swarm_center.owner = self;
    
    swarm_center thread rotate_swarm();
    swarm_center thread do_swarm( swarm_box );
}

do_swarm( swarm_box )
{
    fireTime = .2;
    minShots = 5;
    maxShots = 15;
    
    numShots           = randomIntRange( minShots, maxShots + 1 );
    level.swarm_active = numShots;
    
    rockets  = [];
    for(e=0;e<numShots;e++)
    {       
        rockets[e] = modelSpawner( swarm_box.origin, "projectile_rpg7", undefined, .2 );
        rockets[e] thread monitor_swarm( self, swarm_box );
        rockets[e] thread rocket_vfx();
    }
    swarm_box MoveTo( swarm_box.origin - (0,0,100), 1 );
    wait 1;
    swarm_box Delete();
}

rotate_swarm()
{
    while( IsDefined( self ) )
    {
        self RotateTo( self.angles + (0,90,0), .9 );
        wait .9;
    } 
}

monitor_swarm( swarm_center, swarm_box )
{
    center = level.mapCenter;
    height = getEnt( "airstrikeheight", "targetname" ).origin[2] - 600; 
    radius = 1600;
    
    location = (center[0], center[1], height) + AnglesToForward( swarm_center.angles ) * radius;
    angles   = vectortoangles( location - self.origin );
    time     = calcDistance( 700, self.origin, location );
    
    self.angles = angles;
    self MoveTo( location, time, .4, .2 );
    self waittill( "movedone" );
    self.angles = vectortoangles( location - self.origin ) + (90,90,0);
    self LinkTo( swarm_center, "tag_origin" );
    self thread swarm_think( swarm_center );
}

swarm_think( swarm_center )
{
    while( IsDefined( self ) )
    {
        player = self returnBestTarget( swarm_center.owner.team );
        if( player isEnemy( swarm_center.owner ) && IsAlive( player ) && !isDefined( level.swarm_target ) && randomSign() == 1 )
        {
            level.swarm_target = true;
            self Unlink();
            
            self rocket_vfx();
            
            self.killCamEnt = self;
            swarm_center.owner LinkTo( self, "tag_origin" );
            target      = player;
            time        = calcDistance( 750, self.origin, target.origin );
            self.angles = vectortoangles( target.origin - self.origin );
            self moveToOriginOverTime( target.origin, time, target, (0,0,55));
            
            fx = Playfx( level.c4Death, self.origin );
            TriggerFX( fx );
            
            origin = self.origin;
            self Delete();
            
            wait .05;
            RadiusDamage( origin, 1, 200, 50, swarm_center.owner, "MOD_RIFLE_BULLET", "gas_strike_mp" );
            PlaySoundAtPos( origin, "rocket_explode_default" ); 
            PlayRumbleOnPosition( "grenade_rumble", origin );
            earthquake( 0.75, 2.0, origin, 200 );
            level.swarm_target = undefined;
        }
        wait .05;
    }
    level.swarm_active--;
    if(level.swarm_active <= 0 )
    {
        level.swarm_active = undefined;
        thread arrySetColour( level.swarm_active, "customKS", 2 ); 
    }
}

rocket_vfx()
{
    wait .05; //Need to wait a half a frame so the rocket is defined fully.
    PlayFXOnTag( level._effect["rpg_trail"], self, "TAG_FX" );
    PlaySoundAtPos( self.origin, "weap_cobra_missile_fire" );
    self playLoopSound( "emt_road_flare_burn" );
}

destroy_killstreaks()
{
    level thread maps\mp\killstreaks\_emp::destroyActiveVehicles( self );
}

clear_killstreaks()
{
    foreach( index, streakStruct in self.pers["killstreaks"] )
        self.pers["killstreaks"][index] = undefined;
     self shuffleKillStreaksFILO();  
}

shuffle_killstreaks()
{
    self.pers["killstreaks"] = array_randomize(self.pers["killstreaks"]);
    self giveOwnedKillstreakItem(); 
}
    