loadarrays()
{
    level dmc2_load_font();
    //level load_zone_edits();
    
    //overrides 
    level.callbackPlayerDamage = ::DamageOverride;
    level.callbackPlayerKilled = ::PlayerKilledOverride;
    
    level.weapons  = [];
    level.weapons[0] = strTok( "fal;m4;m16;famas;scar;ak47;aug;masada;fn2000", ";"); //Assault Rifles
    level.weapons[1] = StrTok( "uzi;ump45;mp5k;p90;tavor;kriss", ";" ); //Submachine Guns
    level.weapons[2] = StrTok( "model1887;aa12;ranger;spas12;m1014", ";" ); //Shotguns
    level.weapons[3] = StrTok( "m240;rpd;sa80;mg4", ";" ); //Light Machine Guns
    level.weapons[4] = StrTok( "m21;cheytac;wa2000;barrett", ";" ); //Sniper Rifles
    level.weapons[5] = StrTok( "at4;rpg;javelin;stinger;m79", ";" ); //Launchers
    level.weapons[6] = StrTok( "beretta;coltanaconda;usp;deserteagle;deserteaglegold", ";" ); //Pistols
    level.weapons[7] = StrTok( "pp2000;glock;tmp", ";" ); //Auto Pistols
    
    level.all_items = [];
    for( weaponId = 0; weaponId <= 66; weaponId++ )
    {
        baseName = tablelookup( "mp/statstable.csv", 0, weaponId, 4 );
        if( baseName == "" || baseName == "airdrop_marker" )
            continue;

        level.all_items[ level.all_items.size ] = baseName;
    }
    
    level.attachments     = strtok( "acog;grip;gl;tactical;reflex;silencer;akimbo;thermal;shotgun;heartbeat;fmj;rof;dtap;xmags;mags;eotech",";" );
    level.attachmentNames = StrTok( "Acog;Grip;Grenade Launcher;Tactical;Reflex;Silencer;Akimbo;Thermal;Shotgun;Heartbeat;Fmj;Rapid Fire;Dtap;Extended Mags;Fast Mags;Eotech", ";" );
    
    level.maps = [];
    level.maps["IDS"]   = strTok("mp_afghan;mp_derail;mp_estate;mp_favela;mp_highrise;mp_invasion;mp_checkpoint;mp_quarry;mp_rundown;mp_rust;mp_boneyard;mp_nightshift;mp_subbase;mp_terminal;mp_underpass;mp_brecourt", ";");
    level.maps["NAMES"] = strTok("Afghan;Derail;Estate;Fevela;Highrise;Invasion;Karachi;Quarry;Rundown;Rust;Rust;Scrapyard;Skidrow;Sub Base;Terminal;Underpass;Wasteland", ";");

    level.custPerks = [];
    level.custPerks[0] = StrTok( "specialty_marathon;specialty_fastreload;specialty_scavenger;specialty_bling;specialty_onemanarmy", ";" ); //PERK 1 SLOT
    level.custPerks[1] = StrTok( "specialty_bulletdamage;specialty_lightweight;specialty_hardline;specialty_coldblooded;specialty_explosivedamage", ";" ); //PERK 2 SLOT
    level.custPerks[2] = StrTok( "specialty_extendedmelee;specialty_bulletaccuracy;specialty_heartbreaker;specialty_detectexplosive;specialty_pistoldeath", ";" ); //PERK 3 SLOT

    //PERK REAL NAMES
    level.custPerks[3] = StrTok( "Marathon;Sleight Of Hand;Scavenger;Bling;One Man Army", ";" ); //PERK 1 SLOT
    level.custPerks[4] = StrTok( "Stopping Power;Lightweight;Hardline;Cold Blooded;Danger Close", ";" ); //PERK 2 SLOT
    level.custPerks[5] = StrTok( "Commando;Steady Aim;Ninja;Sitrep;Last Stand", ";" ); //PERK 3 SLOT
    
    level.bonetags = strtok( "j_helmet;tag_eye;j_neck;j_shoulder_ri;j_shoulder_le;j_spine4;j_spinelower;j_hip_ri;j_hip_le;j_elbow_ri;j_elbow_le;j_wrist_ri;j_wrist_le;pelvis;j_knee_ri;j_knee_le;j_ankle_ri;j_ankle_le;j_ball_ri;j_ball_le", ";" );
   
    level.g_models = [];
    level.g_models = removeDuplicatedModels( GetEntArray( "script_model", "classname" ) );
    if(level.g_models.size < 1)
        level.g_models[0] = "No Game Models Found."; 
    
    level.barrelEXP = loadfx("props/barrelExp");
    level._effect[ "snowhit" ] = LoadFX( "impacts/small_snowhit" );
    level._effect[ "heliwater" ] = LoadFX( "treadfx/heli_water" );
    level._effect[ "barrel_fire"] = LoadFX( "fire/firelp_barrel_pm" );
    level._effect[ "black_smoke"] = LoadFX( "smoke/smoke_trail_black_heli" );
    
    level.impacts_fx = "props/barrelexp;explosions/grenadeexp_mud;explosions/default_explosion;impacts/large_plastic;code/glass_shatter_64x64;impacts/expround_spark_medium;impacts/expround_spark_medium_crackle"; 
    level.trails_fx  = "smoke/smoke_geotrail_rpg;props/barrel_fire;props/crateexp_dust;smoke/smoke_geotrail_m203;misc/105mm_tracer;misc/light_motion_tracker;misc/light_semtex_geotrail;smoke/smoke_geotrail_hellfire;smoke/smoke_geotrail_javelin;smoke/smoke_geotrail_fraggrenade";

    level.models = "com_plasticcase_enemy;projectile_at4;projectile_cbu97_clusterbomb;projectile_m203grenade;projectile_rpg7;projectile_stealth_bomb_mk84;projectile_hellfire_missile;projectile_bm21_missile";
    
    foreach( fx in convert_strtok( level.impacts_fx, ";" ) )
        LoadFX( fx );
    foreach( fx in convert_strtok( level.trails_fx, ";" ) )
        LoadFX( fx );   
    foreach( model in convert_strtok( level.models, ";" ) )
        PreCacheModel( model );      
}

load_presets()
{
    self.presets = [];
    
    self.presets["X"] = 160;
    self.presets["Y"] = -114;
    
    self.presets["OUTLINE"] = get_preset("OUTLINE");
    self.presets["TITLE_OPT_BG"] = get_preset("TITLE_OPT_BG");
    self.presets["SCROLL_STITLE_BG"] = get_preset("SCROLL_STITLE_BG");
    self.presets["TEXT"] = get_preset("TEXT");
    
    self.default_name = self.name;
}

get_preset( preset )
{
    if( preset == "OUTLINE" )
        return (0,0,0);
    if( preset == "TITLE_OPT_BG" )
        return rgb(19,18,20);
    if( preset == "SCROLL_STITLE_BG" )
        return "rainbow";//rgb(62,58,63);
    if( preset == "TEXT" )
        return (1,1,1);
    if( preset == "X" )
        return 0;
    if( preset == "Y" )
        return 0;    
}

load_zone_edits()
{
    /* BLACK */
    addresses = [ 0x33A800A3, 0x33A8130B, 0x33A815A7, 0x33A7F6B3, 0x33A7F8A3, 0x33A7FB1B, 0x33A7FD83, 0x33A80EF7, 0x33D014DB, 0x33C07BA3, 0x33C08A5F, 0x33C08663, 0x33C08663, 0x33C0649F, 0x33C06197, 0x33C06D4F, 0x33C08207, 0x33C05E8F, 0x33C0631B, 0x33C06197, 0x33C07047, 0x33C0399B, 0x33BE2CF3, 0x33BE3CEB, 0x33BE3E67, 0x33BD784F, 0x33BD76CB, 0x33BD7547, 0x33BD9AA7, 0x33BDA567, 0x33BDAEAB, 0x33C06013 ]; 
    bytes     = [ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00 ];
    
    foreach( address in addresses )
        SetBytes( address, bytes );
    
    /* RED */
    addresses = [ 0x33A7ED4F, 0x33A7F017, 0x33A80D67, 0x33A8118F, 0x33A7FF1B, 0x33A80737, 0x33A805AB, 0x33D0104F, 0x33D023EB, 0x33C0661B, 0x33C067B3, 0x33C06A37, 0x33C07473, 0x33C07863, 0x33C07D1F, 0x33C08BDB, 0x33C090C3, 0x33C06013, 0x33C03C8B, 0x33BE27EF, 0x33BE27F2, 0x33BE3E57, 0x33BD87EB, 0x33BDAD2F, 0x33BD79CB, 0x33BD7B5F, 0x33BDB1B7, 0x33BD7F97, 0x33BD83DF, 0x33BD8967, 0x33BD902B, 0x33BD9EAB, 0x33BDA83F, 0x33BE24FF, 0x33BD73C3, 0x33C05E8F, 0x25893643]; 
    bytes     = [ 0x3F, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3F, 0x00, 0x00, 0x00 ];
    
    foreach( address in addresses )
        SetBytes( address, bytes );
        
    /* MENU TEXT */
    strings   = [ "  M.T.M.B By Extinct!", "    Don't Download Shit, K Thx ", "        Go Ahead, Ruin MW2", "Change Pointless Stuff", " Main Menu, Dont GO!", " Quit, No Balls", "Start The Game Already", "Setup The Game Homie ", "     Find Nolife Scrubs", "Play Alone, Im Depressed", "      Create A Dank Class", " Show Off Your Unlock All", "Super Legit Stat Showcase", "Invite Your 0 Friends" ];
    addresses = [ 0x33BD7AF4, 0x33A8020A, 0x33A80870, 0x33A8102F, 0x33A81448, 0x33A816DC, 0x33C0759C, 0x33C079A5, 0x33BD80C1, 0x33BD8519, 0x33BD8A99, 0x33BD9BE0, 0x33BDA69E, 0x33BDAFE1 ];
    for(e=0;e<addresses.size;e++)
        writeString( addresses[e], strings[e] );
}   
