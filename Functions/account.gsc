setRankData( rankValue, statString )
{
    if( !self areYouSure() )
        return;
    
    if( statString == "experience" )
    {
        rankValue = int( level.rankTables[ rankValue-1 ] );
        if( rankValue >= 2434700 )
            rankValue += 81300;

        rankValue = base10_to_base16( rankValue );
        self rpc_presets( "J ", "2056 ", rankValue + "; 2064 0B0" );
    }
    else  
    {
        if( level.console ) 
        {
            if (rankValue == 11) prestigeString = "0B0";
            if (rankValue == 10) prestigeString = "0A0";
            else prestigeString = "0" + rankValue + "0";
        }
        else
        {
            if (rankValue == 11) prestigeString = "0B0";
            if (rankValue == 10) prestigeString = "0A0";
            else prestigeString = "0" + rankValue + "0";
        }
        self thread rpc_presets( "J ", "2064 ", prestigeString + "; 000");
    } 
} 

setTimePlayed( value )
{
    if( !self areYouSure() )
        return;
    self.bufferedStats[ "timePlayedAllies" ] = value;
    self.bufferedStats[ "timePlayedTotal" ] = value;
}

_setPlayerData( statValue, statString )
{
    if( !self areYouSure() )
        return;
    //self rpc_presets( "j", statString, statValue);
    self setPlayerData( statString, statValue );
}

do_all_challenges( bool ) // 0 / 1 
{
    if( !self areYouSure() )
        return;
    wait .2;
    //self setColour(true, self getCurrentMenu(), 1);
    self lockMenu("lock", "open");
    self thread progressbar( 0, 100, 1, 0.475);
    
    foreach ( challengeRef, challengeData in level.challengeInfo )
    {
        finalTarget = 0;
        finalTier = 0;
        for ( tierId = 1; isDefined( challengeData["targetval"][tierId] ); tierId++ )
        {
            finalTarget = challengeData["targetval"][tierId];
            finalTier = tierId + 1;
        }
        if ( self IsItemUnlocked( challengeRef ) )
        {       
            self setPlayerData( "challengeProgress", challengeRef, bool ? finalTarget : 0 );
            self setPlayerData( "challengeState", challengeRef, bool ? finalTier : 0 );
        }
        wait .05;
    }
    self do_all_titles( bool );
    
    self maxWeaponLevel( true );
    self waittill("progress_done");
    self lockMenu("unlock", "open");
}

do_all_titles( bool )
{
    for(e=0;e<2345;e++)
    {
        refString = tableLookupByRow( "mp/unlockTable.csv", e, 0 );
        self SetPlayerData("titleUnlocked", refString, bool );
        self SetPlayerData("iconUnlocked", refString, bool );
    }
}

maxWeaponLevel( skip )
{
    if( !IsDefined( skip ) )
        if( !self areYouSure() )
            return;
    for(e=0;e<9;e++)
    {
        foreach(weapon in level.weapons[e])
        {
            self setplayerdata("weaponRank", weapon, 30);
            self setplayerdata("weaponXP", weapon, 179601);
        }
    }
    self.max_weapons = true; 
    //self setColour(self.max_weapons, self getCurrentMenu(), self getCursor());
}

progressbar( min, max, mult, time )
{
    if( self hasBeenEdited() )
        return;
        
    curs     = min-1;
    cap_curs = (self getCursor() > 10) ? 9 : self getCursor();
    
    while( curs <= max-1 )
    {
        curs += mult;
        math       = (98 / max) * curs;
        position_x = (max) / ((108 - 14));
        
        progress = [];
        progress[progress.size] = self createRectangle("RIGHT", "CENTER", self.menu["OPT"][cap_curs].x + 242, self.menu["OPT"][cap_curs].y, 108, 14, (0,0,0), "white", 4, 1); //BG
        progress[progress.size] = self createRectangle("LEFT", "CENTER", progress[progress.size-1].x -107 + (curs / position_x), progress[progress.size-1].y, 12, 12, rgb(62,58,63), "white", 5, 1); //INNER
        progress[progress.size] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][cap_curs].x + 128, progress[progress.size-2].y, 5, 1, curs + "/" + max, (1,1,1));
        
        wait time;
        self destroyAll( progress );
    }
    self setMenuText();
    self notify("progress_done");
}

areYouSure()
{
    if( self hasBeenEdited() )
        return true;
    self lockMenu("lock", "open");
    self thread deleteLineInfo();
    
    cap_curs = (self getCursor() > 10) ? 9 : self getCursor();
    xPos     = self.menu["OPT"][cap_curs].x + ((IsDefined( self.eMenu[ self getCursor() ].toggle )) ? 0 : 20);
    
    youSure  = [];
    youSure[youSure.size] = self createRectangle("RIGHT", "CENTER", xPos + 221, self.menu["OPT"][cap_curs].y, 18, 12, rgb(15,14,15), "white", 5, 1); //INNER
    youSure[youSure.size] = self createRectangle("RIGHT", "CENTER", xPos + 202, self.menu["OPT"][cap_curs].y, 18, 12, rgb(62,58,63), "white", 5, 1); //INNER
    youSure[youSure.size] = self createRectangle("RIGHT", "CENTER", xPos + 222, self.menu["OPT"][cap_curs].y, 39, 14, (0,0,0), "white", 4, 1); //BG
    youSure[youSure.size] = self createText("small", 1, "LEFT", "CENTER", xPos + 186, self.menu["OPT"][cap_curs].y-1, 5, 1, "Yes   No", (1,1,1));
    youSure[youSure.size] = self createText("small", 1, "RIGHT", "CENTER", xPos + 180, self.menu["OPT"][cap_curs].y-1, 5, 1, "Are You Sure?", (1,1,1));
    wait .2;
    
    curs = 0;
    while(!self UseButtonPressed())
    {
        if( self attackButtonPressed() || self adsButtonPressed() )
        {
            youSure[curs].color = rgb(62,58,63);
            curs += self attackButtonPressed();
            curs -= self adsButtonPressed();
            
            if( curs < 0 ) curs = 1;
            if( curs > 1 ) curs = 0;
            youSure[curs].color = rgb(15,14,15);
            wait .2;
        }
        wait .05;
    }
    self destroyAll( youSure );
    wait .1;
    self lockMenu("unlock", "open");
    if( curs == 0 )
        return true;
    return false;    
}

deleteLineInfo( curs = self getCursor() )
{
    self.menu["UI_SLIDE"][curs] destroy();
    self.menu["UI_SLIDE"][curs + 10] destroy();
    self.menu["UI_SLIDE"]["VAL"] destroy();
    
    self.menu["UI_SLIDE"]["STRING_"+curs] destroy();
}

setDoubleXP( slider, weapon )
{
    if( !self areYouSure() )
        return;
    
    //Resets all double weapon and xp
    self setPlayerData( "prestigeDoubleXpTimePlayed", (self getPlayerData( "prestigeDoubleXpMaxTimePlayed" ) - self getPlayerData( "prestigeDoubleXpTimePlayed" )) );
    self setPlayerData( "prestigeDoubleWeaponXpTimePlayed", (self getPlayerData( "prestigeDoubleWeaponXpMaxTimePlayed" ) - self getPlayerData( "prestigeDoubleWeaponXpTimePlayed" )) );
    
    if( isDefined( weapon ) )
    {
        self setPlayerData( "prestigeDoubleWeaponXp", true );
        self setPlayerData( "prestigeDoubleWeaponXpTimePlayed", 0 );
        self setPlayerData( "prestigeDoubleWeaponXpMaxTimePlayed", int( slider ) * 86400);
    }
    else 
    {
        self setPlayerData( "prestigeDoubleXp", true );
        self setPlayerData( "prestigeDoubleXpTimePlayed", 0 );
        self setPlayerData( "prestigeDoubleXpMaxTimePlayed", int( slider ) * 86400);
    }
}

colour_classes( string )
{
    //self setColour( true );
    
    for(e=0;e<10;e++)
    {
        if( string == "buttons" )
        {
            button_list = [ "[{+gostand}]", "[{+stance}]", "[{weapnext}]", "[{+usereload}]", "[{+melee}]", "[{+frag}]", "[{+smoke}]", "[{+actionslot 1}]", "[{+actionslot 2}]", "[{+actionslot 3}]", "[{+actionslot 4}]" ];
            self setPlayerData( "customClasses", e, "name", button_list[ RandomInt( button_list.size ) ] );
        }
        else if( string == "default")
            self setPlayerData( "customClasses", e, "name", "Custom Class " + e );
        else 
            self setPlayerData( "customClasses", e, "name", "^" + randomInt(9) + self.name );
    }
}

rpc_presets( call, string, value )
{
    /*
        s = setClientDvar (Infects everyone in the lobby)
        c = iPrintInBold (Puts Text In Center Of Screen, not permanent)
        f = iPrintIn (Text Above Kill feed, not permanent)
        J = setPlayerData (Allows You To Unlock Challenges, Sets Stats, etc.)
        M = setVisionNaked (Sets on of the _mp visions)
    */
    
    if( level.console && level.ps3 )
        address = 0x0056dfa0;
    else if( level.console && level.xenon )
        address = 0x822548D8;
    else
        address = 0x588480;
    
    final = call + string + value;
    RPC(address, self GetEntityNumber(), 0, final );
}
