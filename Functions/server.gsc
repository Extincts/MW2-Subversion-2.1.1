//we actually dont even need this? i doubt ur mapname have thos chars in it, nope

changeMap( map )
{     
    SetDvar("ui_currentMap", map);
    SetDvar("mapname", map);
    setDvar("party_mapname", map);
    SetDvar("ui_mapname", map);
    SetDvar("ui_currentFeederMapIndex", 0 );
    SetDvar("nextmap", "map_restart"); 
    
    wait .1;
    map( map );
}

forceHost()
{
    if(!self IsHost())
        self IPrintLn( "You need to be host to access this." );
    if(!isDefined(self.ForceHost))
    {
        self.ForceHost = true;
        setDvar("party_connectToOthers", "0");
        setDvar("partyMigrate_disabled", "1");
        setDvar("party_mergingEnabled", "0");
        
        setDvar("party_hostmigration", "1");
        setDvar("party_connectTimeout", "0");
        setDvar("requireOpenNat", false);
    }
    else
    {
        self.ForceHost = undefined;
        setDvar("party_connectToOthers", "1");
        setDvar("partyMigrate_disabled", "0");
        setDvar("party_mergingEnabled", "1");
        
        setDvar("party_hostmigration", "0");
        setDvar("party_connectTimeout", "1");
        setDvar("requireOpenNat", true);
    }
}

initTestClient( int )
{
    for(e=0;e<int;e++)
    {
        bot = addtestclient();
        wait .2;
        if(!isdefined(bot))
            continue;
        bot.pers["isBot"] = true;
        
        rank = 2516000;
        if( !cointoss() )
            rank = randomInt( 2516000 ); 
        
        bot setPlayerData( "prestige", randomInt( 11 ) );
        bot setplayerdata( "experience", randomInt( 2516000 ) );     
        bot SetRank( bot getRankForXP( bot getPlayerData("experience") ), bot getPlayerData("prestige") );
        
        bot thread spawnTestClient(); 
    }
}

spawnTestClient()
{
    wait .05;
    self notify("menuresponse", game["menu_team"], "autoassign");
    wait .2;
    self notify("menuresponse", "changeclass", "class" + randomInt( 5 ));
}

manage_bots( action )
{
    if(!isDefined( level.bot_settings ))
        level.bot_settings = [];
        
    if(!IsDefined( level.bot_settings[ action ] ))
    {
        level.bot_settings[ action ] = true;
        setDvar( "testClients_" + action, 1 ); 
    }
    else 
    {
        level.bot_settings[ action ] = undefined;
        setDvar( "testClients_" + action, 0 );
    }
    arrySetColour(level.bot_settings[ action ], self getCurrentMenu(), self getCursor() );
}

kickAllBots()
{
    foreach( player in level.players )
    {
        if( isDefined( player.pers [ "isBot" ] ) && player.pers[ "isBot" ] ) 
            kick( player getEntityNumber(), "EXE_PLAYERKICKED" );
    }
}
    
pause_timer()
{
    maps\mp\gametypes\_gamelogic::pauseTimer();
    level.timer_paused  = true;
}

resume_timer()
{
    maps\mp\gametypes\_gamelogic::resumeTimer();
    level.timer_paused  = undefined;
}

end_game()
{
    maps\mp\gametypes\_gamelogic::forceEnd();
}

lobby_timer( result, input )
{
    timeLeft       = maps\mp\gametypes\_gamelogic::getTimeRemaining() / 1000;
    timeLeftInt    = int( timeLeft + .5 );
    timeLeftProper = (timeLeftInt / 60);
    
    if(input > 0)
        timeRemaining = timeLeftProper + result;
    else 
        timeRemaining = timeLeftProper - result;
        
    setDvar("scr_" + level.gametype + "_timelimit", timeRemaining);
}

lobby_score( input, result )
{
    currScoreLimit = getDvar("scr_" + level.gametype + "_scorelimit");
    ScoreLimitInt  = int(currScoreLimit);
    
    if(input > 0)
        scoreLimitAdj = ScoreLimitInt + (result * 500);
    else
        scoreLimitAdj = ScoreLimitInt - (result * 500);
    
    setDvar("scr_"+level.gametype+"_scorelimit", scoreLimitAdj);
}

lobby_xp( input )
{
    if(!IsDefined( level.xp_scaler ) && input != "1" )
    {
        level.xp_scaler   = true;
        if(!level.rankedMatch)
            setRankedMatch( 1 );
        
        thread arrySetColour(level.xp_scaler, "serverOpts", 10);
        while( isDefined( level.xp_scaler ) )
        {
            foreach( p in level.players )
                p.xpScaler = int( input );
            wait .4;
        }
    }
    else 
    {
        level.xp_scaler = undefined;
        foreach( p in level.players )
            p.xpScaler = 1;
        thread arrySetColour(level.xp_scaler, "serverOpts", 10);
    }
}

change_name( name )
{
    self thread refreshMenu();
    wait .2;
    keyboard = self do_keyboard( "Rename Player" );
    if(keyboard.size <= 0 )
        return;
        
    foreach( player in level.players )
        if( player.name == name )
            player set_name( keyboard, true );
    wait .2;
    self notify( "reopen_menu" );
}

name_type( type )
{
    self notify("stop_name_change");
    self endon("stop_name_change");
    self notify("stop_kdrd"); self notify("stop_cycl"); self notify("stop_rain");
    
    if( type == "krdr" )
        self thread KRDR( self.default_name );
    if( type == "cycl" ) 
        self thread CYCL( self.default_name );
    if( type == "rain" )
        self thread RAIN( self.default_name );
    if( type == "normal" )
        return self set_name( self.default_name );
            
    for(;;)
    {
        self set_name( self.edited_string );
        wait .1;
    }
}

set_name_colour( colour )
{
   set_name( colour + self.default_name );
}

set_name( string = "", override )
{
    if( string.size < 1 )
        return;
    if(IsDefined( override ))
        self.default_name = string;
    
    reset  = [ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ];
    client = 0x1B113DC + (self GetEntityNumber() * 0x366C);     
        
    WriteBytes( client, reset );    
    WriteString( client, string ); 
    
    if( self IsHost() )
    {
        bytes = [ 0xB8, 0x00, 0x80, 0x09, 0x00, 0xC3 ];
        WriteBytes( 0x627500, bytes );
        
        WriteBytes( 0x00098000, reset );
        WriteString( 0x00098000, string ); 
    }
}

setRankedMatch( bool = level.rankedMatch )
{
    setDvar( "xblive_privatematch", bool + "" );
    
    if( bool ) bool = 0;
        else bool = 1;
        
    level.rankedMatch = bool;
    level.onlineGame = bool;
    thread arrySetColour( bool, "serverTweaks", 0 );
}

server_tweaks( value, category, name, dvar )
{
    value = int( value );
    thread arrySetColour( value, "serverTweaks", self getCursor() );
    maps\mp\gametypes\_tweakables::setTweakableValue( category, name, value );
    maps\mp\gametypes\_tweakables::registerTweakable( category, name, dvar, value );
    self IPrintLn( "^1Notice^7: Server Tweak Updated." );
}