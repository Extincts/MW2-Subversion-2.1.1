menuOptions()
{
    menu = self getCurrentMenu();
    switch( menu )
    {
        case "main":
        {
            self addMenu( "main", "M.T.M.B" );
                self addOpt( "suicide_bomber", ::suicide_bomber );
                
                self addOpt( "Basic Options", ::newMenu, "basicOpts" );
                self addOpt( "Fun Options", ::newMenu, "funOpts" );
                self addOpt( "Entity Options", ::newMenu, "entityOpts" );
                self addOpt( "Spawnable Options", ::newMenu, "spawnables" );
                self addopt( "Teleport Options", ::newmenu, "teleportOpts" );
                self addOpt( "Weaponry Options", ::newMenu, "weaponryOpts" );
                self addOpt( "Bullet Options", ::newMenu, "bulletOpts" );
                self addOpt( "C.Bullet Options", ::newMenu, "cBulletOpts");
                self addOpt( "Aimbot Options", ::newMenu, "aimbotOpts" );
                self addOpt( "Killstreak Options", ::newMenu, "KillstreakOpts" );
                self addOpt( "Server Options", ::newMenu, "serverOpts");
                self addOpt( "Server Tweakables", ::newMenu, "serverTweaks" );
                self addOpt( "Say Options", ::newMenu, "sayOpts");
                self addOpt( "Account Options", ::newMenu, "accOpts");
                self addOpt( "Menu Customization", ::newMenu, "customization" );     
                self addOpt( "Clients Menu", ::newMenu, "clients" );   
        }
        /* BASIC OPTIONS */
        case "basicOpts":
        {
            self addMenu( "basicOpts", "Basic Options" );
                self addToggle( "Godmode", self.godmode, ::godmode ); 
                self addToggle( "Noclip Bind [{+frag}]", self.noclipBind, ::noClipExt );
                self addToggle( "UFO Mode", self.ufo_mode, ::ufomode );
                self addToggle( "Third Person", self.thirdPerson, ::thirdperson );
                self addToggle( "Invisibility", self.invisibility, ::invisibility );
                self addSliderString( "Infinite Ammo", "Continuous;Reload", undefined, ::infiniteAmmo );
                self addToggle( "Infinite Equipment", self.infEquip, ::infiniteEquip );
                self addSliderValue("Field Of View", 70, 65, 80, 1, ::fovEdit ); 
                self addSliderValue("F.O.V Scale", 0.85, 0.75, 2, 0.05, ::fovScaleEdit ); 
                self addOpt( "Add Perks", ::newmenu, "addPerks" );
                self addOpt( "Remove Perks", ::newmenu, "removePerks" );
                self addSliderString( "Set Vision", "default;icbm;aftermath;ac130_inverted;ac130_thermal_mp;af_caves_indoors_steamroom;enhanced;cheat_contrast;cobra_sunset1;cobra_sunset2;cobra_sunset3;grayscale;end_game;airport_green;sepia", "Default;Night;Nuke Aftermath;Inverted;Thermal;Steam Room;Enhanced;Cheat Contrast;Sunset 1;Sunset 2;Sunset 3;Grayscale;Red;Green;Sepia", ::setPlayerVision );
                list = "SMG;ASSAULT;GHILLIE;SNIPER;LMG;RIOT;SHOTGUN;ASSAULT;JUGGERNAUT";
                self addSliderString( "Axis Appearances", list, undefined, ::changeAppearance, self.team );
                self addSliderString( "Allies Appearances", list, undefined, ::changeAppearance, self getOtherTeam( self.team ) );
                self addToggle( "Cycle Appearances", self.cycleAppearance, ::cycleAppearance );
                self addSliderString( "Clone", "clone;dead;statue", "Clone;Dead;Statue", ::clone );
                self addSliderValue( "Player Speed", 1, .5, 5, .5, ::set_movement_speed );
                
                //self addOpt("trickPlatform", ::trickPlatform);
        }
        /* PERK OPTIONS */
        case "perkOpts":
        {
            self addMenu("perkOpts", "Perk Options");
                self addopt( "Add Perks", ::newmenu, "addPerks" );
                self addopt( "Remove Perks", ::newmenu, "removePerks" );
        }   
        case "addPerks":
        {
            self addmenu( "addPerks", "Add Perks" );
                self addToggle( "Set All Perks", self.addAllPerks, ::setAllPerks );
                for( e = 1; e < 4; e++ )
                    self addOpt( "Add Perk " + e, ::newMenu, "Add Perk" + e);   
        }
        case "removePerks":
        {   
            self addmenu( "removePerks", "Remove Perks" );    
                self addToggle( "Remove All Perks", self.clearPerks, ::setAllPerks, true );
                for( e = 1; e < 4; e++ )
                     self addOpt( "Remove Perk " + e, ::newMenu, "Remove Perk" + e);   
        }            
        /* FUN OPTIONS */
        case "funOpts":
        {
            self addMenu( "funOpts", "Fun Options" );
                self addToggle( "Riot Smash", self.riotSmash, ::riotsmash );
                self addToggle( "Sheild Protector", self.sheildProtector, ::sheildprotector );
                //self addopt( "Wallrun", ::wallrunmonitor );
                self addToggle( "Light Protector", self.lightProtect, ::lightProtector );
                //self addopt( "Cluster Grenades", ::clustergrenade );
                self addToggle( "Gravity Gun", self.gravityGun, ::gravitygun );
                self addopt( "Spawn Fx's In Sky", ::newmenu, "fxSky" );
                self addopt( "Spawn Models In Sky", ::newmenu, "modelSky" );
                self addToggle( "Geyser", self.geyser, ::spawnGeyser );
                self addopt( "FX Man Options", ::newmenu, "fxMan" );
                self addToggle( "Shoot Exloding CPs", self.carepackageGun, ::carepackageGun );
                //self addSlider( "Custom Sentry", level.moddedbullets, ::customSentry );
                self addOpt( "Sky Trip", ::skyTrip );
                self addToggle( "Kill Text", self.killtxt, ::toggleKillText ); 
                self addSliderValue( "Super Jump", 0, 0, 9, 1, ::superJump );
                self addToggle( "Unpatch Bounces", self.doCod4Bounce, ::cod4Bounce );
                self addOpt( "Solo Pong", ::pong_huds );
                self addSliderValue( "Modded Spread", 0, 0, 9, 1, ::moddedSpread ); 
                self addToggle( "Advanced Forge", self.forge_mode, ::adv_forge_mode );
                self addOpt( "Flyable UFO", ::flyableUfo );
                self addOpt( "Flyable Jet", ::initial_plane, 100, 5 ); 
                
                players = "";
                foreach( player in level.players )
                    players += player.name + ";";
                
                self addSliderString( "Spectate Player", players, players, ::spectate_player );
                self addSliderString( "Play Tic Tac Toe", players, players, ::players_tic_tac_toe );
                self addToggle( "Explosive Melee", self.explosive_melee, ::explosive_melee );
                
                self addToggle( "Gavity Missiles", self.gravity_missile, ::gravity_missile );
        }
        case "fxSky":
        {    
            effects = getarraykeys( level._effect );
            self addmenu( "fxSky", "Spawn Fx's In Sky" );
            for(e=0;e<effects.size;e++)
                self addToggle( cutName( effects[e] ), ((IsDefined( level.spawnRandomFx ) && level.spawnRandomFx == effects[e] ) ? true : false), ::randomfxspawn, effects[e] );
        }
        case "modelSky":
        {
            self addmenu( "modelSky", "Spawn Models In Sky" );
            for(e=0;e<level.g_models.size;e++)
                self addToggle( cutName( level.g_models[e] ), ((IsDefined( level.randomModelSpawnActive ) && level.randomModelSpawnActive == level.g_models[e] ) ? true : false), ::randommodelspawn, level.g_models[e] );
        }
        case "fxMan":
        {
            effects = getarraykeys( level._effect );
            self addmenu( "fxMan", "FX Man Options" );
            for(e=0;e<effects.size;e++) 
                if(effects[e] != "spotlight_fx")
                    self addToggle( cutName( effects[e] ), ((IsDefined( self.fxMan ) && self.fxMan == effects[e] ) ? true : false), ::fxman, effects[e] );
        }   
        /* ENTITY OPTIONS */
        case "entityOpts":
        {
            self addmenu( "entityOpts", "Entity Options" );
                self addOpt( "Teleport Toy Model", ::newMenu, "TOY_MODELS" );
                self addOpt( "Spawn Script Model", ::newMenu, "SCRIPT_MODELS" );
                self addOpt( "Place Script Model", ::placeModel );
                self addOpt( "Copy Script Model", ::copyModel );
                self addOpt( "Rotate Script Model", ::newMenu, "ROTATE_MODELS" );
                self addOpt( "Delete Script Model", ::deleteModel );
                self addOpt( "Undo Last Spawn", ::modelUndo );
                self addOpt( "Entity Distance", ::newMenu, "MODEL_DISTANCE" );
                self addToggle( "Ignore Collisions", self.ignoreCollisions, ::ignoreCollisions );
                //self addopt( "Model Snapping", ::modelsnapping );
                self addopt( "Delete All Spawned", ::deleteAllSpawned );
                self addToggle( "Increase Entity Space", level.incEntSpace, ::increaseEntitySpace );
        }
        case "TOY_MODELS":
        {
            self addmenu( "TOY_MODELS", "Teleport Toy Model" );
            destructible_toys = GetEntArray( "destructible_toy", "targetname" );
                self addOpt( "Teleport All Toys", ::teleportAllToys );
                foreach( toy in destructible_toys )
                    self addOpt( cutName( toy.model ), ::teleportModel, toy );  
        }    
        case "ROTATE_MODELS":       
        {
            self addmenu( "ROTATE_MODELS", "Rotate Script Model" );
                self addOpt( "Reset Angles", ::resetmodelangles, 0, 0, 0 );
                self addOpt( "Rotate Pitch +", ::rotatemodel, 0, 1 );
                self addOpt( "Rotate Pitch -", ::rotatemodel, 0, -1 );
                self addOpt( "Rotate Yaw +", ::rotatemodel, 1, 1 );
                self addOpt( "Rotate Yaw -", ::rotatemodel, 1, -1 );
                self addOpt( "Rotate Roll +", ::rotatemodel, 2, 1 );
                self addOpt( "Rotate Roll -", ::rotatemodel, 2, -1 );
        }   
        case "SCRIPT_MODELS": 
        {    
            self addmenu( "SCRIPT_MODELS", "Spawn Script Model" );
                //self addopt( "Snappable Models", ::newmenu, "SNAP_MODELS" );
                models = removeDuplicatedModels( GetEntArray( "script_model", "classname" ) );
                for(e=0;e<models.size;e++)
                    self addOpt( cutName( models[e] ), ::spawnModel, models[e] );    
        }       
        case "MODEL_DISTANCE":
        {
            self addmenu( "MODEL_DISTANCE", "Entity Distance" );
                self addOpt( "Reset Distance", ::modelDistance );        
                self addSliderValue( "Inc Distance", 10, 0, 100, 10, ::modelDistance );
                self addSliderValue( "Dec Distance", 10, 0, 100, 10, ::modelDistance, true );
        }   
        /* SPAWNABLE OPTIONS */
        case "spawnables":
        {
            self addMenu( "spawnables", "Spawnables" );
                self addOpt("Spawnable Rides", ::newMenu, "rides");
                self addOpt("Spawnable Effects", ::newMenu, "effects");
                //self addOpt("Arcade Spawnables", ::newMenu, "arcade");
                self addOpt("Other Spawnables", ::newMenu, "otherSpawnables");
        }   
        case "rides":
        {
            self addMenu("rides", "Spawnable Rides");   
                self addOpt( "Merry Go Round", ::newMenu, "merryGoRound" );
                self addOpt( "Ferris Wheel", ::newMenu, "ferrisWheel" );
                self addOpt( "The Centrox", ::newMenu, "centrox" );
                self addOpt( "Fireball", ::newMenu, "fireball" );
                self addOpt( "Vertigo", ::newMenu, "vertigo" );
        } 
        case "merryGoRound":
        {  
            self addMenu("merryGoRound", "Merry Go Round");      
                self addToggle( "Merry Go Round", level.merry_Spawned, ::do_merryGoRound );
                self addSliderValue("Change M.G.R Speed", 6, 1, 15, 1, ::change_merry_yaw_speed );
                self addToggle( "Delete M.G.R", (IsDefined( level.merry_Spawned ) ? undefined : true ), ::delete_merryGoRound);    
        }   
        case "ferrisWheel":
        {
            self addMenu("ferrisWheel", "Ferris Wheel");     
                self addToggle( "Ferris Wheel", level.ferris_Spawned, ::do_ferris_wheel );
                self addSliderValue("Change F.W Speed", 1, 1, 15, 1, ::change_ferris_speed );
                self addToggle( "Delete Ferris Wheel", (IsDefined( level.ferris_Spawned ) ? undefined : true ), ::delete_ferris_wheel);   
        }
        case "centrox":
        {
            self addMenu("centrox", "The Centrox");     
                self addToggle( "Spawn Centrox", level.cextrox_spawned, ::spawn_centrox );
                self addToggle( "Delete Centrox", (IsDefined( level.cextrox_spawned ) ? undefined : true ), ::delete_centrox); 
        }  
        case "fireball":
        {
            self addMenu("fireball", "Fireball");     
                self addToggle( "Spawn Fireball", level.fireball_spawned, ::do_fireball ); 
                self addToggle( "Delete Fireball", (IsDefined( level.fireball_spawned ) ? undefined : true ), ::delete_fireball ); 
        }  
            case "vertigo": 
        {
            self addMenu("vertigo", "Vertigo"); 
                self addToggle( "Spawn Vertigo", level.vertigo_spawned, ::do_vertigo );
                self addToggle( "Delete Vertigo", (IsDefined( level.vertigo_spawned ) ? undefined : true ), ::delete_vertigo ); 
        }
        case "effects":
        {
            self addMenu( "effects", "Spawnable Effects" );
                self addOpt( "Effects List", ::newMenu, "effectList" );
                self addSliderValue( "Effects Distance", 100, 50, 1000, 50, ::fx_distance );
                self addOpt( "Reset Effect Distance", ((self.fxDistance == 100) ? undefined : 1 ), ::fx_distance, 100 );   
                self addOpt( "Delete All Effects", ::Spawn_Fx, undefined, true );  
        }
        case "effectList":
        {    
            effects = getArrayKeys(level._effect);    
            self addMenu("effectList", "Effects List");
            for(e=0;e<effects.size;e++)
                self addOpt(cutName(effects[e]), ::Spawn_Fx, effects[e]);    
        } 
        case "otherSpawnables":
        {   
            self addMenu( "otherSpawnables", "Other Spawnables" );
                self addOpt( "Basic Bunker", ::newMenu, "basicBunker" );
                self addToggle( "Trade Weapon Table", self.trade_table, ::trade_weap_table );
                self addSliderValue( "Mexican Wave", 3, 3, 15, 1, ::spawn_mexican_wave ); 
                self addSliderString( "Spawn Sphere", "medium;large", "Medium;Large", ::customizeSphere );
                self addToggle( "Spawn Blackhole", level.blackhole, ::spawn_blackhole );
                self addSliderString( "3D Model Text", "test_sphere_silver", "Sphere", ::spawn_3D_model ); 
                self addSliderString( "3D FX Text", "red;green", "Red Light;Green Light", ::spawn_3D_fx ); 
                self addSliderValue( "Spiral Staircase", 3, 3, 30, 1, ::spiralStaircase );
        } 
        case "basicBunker":
        {
            self addMenu( "basicBunker", "Basic Bunker" ); 
            self addToggle( "Spawn Basic Bunker", level.smallBunkerSpawned, ::spawnBasicBunker );
                self addToggle( "Delete Basic Bunker", (IsDefined( level.smallBunkerSpawned ) ? undefined : true ), ::deleteBasicBunker );
                self addToggle( "Nuke Basic Bunker", (IsDefined( level.smallBunkerSpawned ) ? undefined : true ), ::nukeBasicBunker );    
        }   
        /* TELEPORT OPTIONS */
        case "teleportOpts":
        {
            self addmenu( "teleportOpts", "Teleport Options" ); 
                self addopt( "Teleport Options", ::newmenu, "teleOpts" );
                self addopt( "Offical Spawnpoints", ::newmenu, "spawnpoints" );
        }   
        case "teleOpts":
        {
            self addmenu( "teleOpts", "Teleport Options" );
                self addOpt( "Self Tele Options", ::newMenu, "selfTeleOpts" );
                self addOpt( "Team Tele Options", ::newMenu, "teamTeleOpts" );
                self addOpt( "Spawntrap Options", ::newMenu, "spawntrapOpts" );
        } 
        case "selfTeleOpts":  
        { 
            self addMenu( "selfTeleOpts", "Self Tele Opts" );
                self addToggle( "Cinematic Teleport", self.cinematicTele, ::cinematictele );
                self addopt( "Selector Teleport", ::ipadteleport );
                self addToggle( "Save Position", (isDefined(self.posSaved) ? true : undefined ), ::savepos );
                self addOpt( "Load Position", ::loadpos );
                self addToggle( "Save And Load Bind", self.saveLoad, ::saveloadbind );
                self addToggle( "Advanced Save Load", self.adSaveLoad, ::advancedsaveload );
                self addSliderString( "Tele To Crosshair", returnlist( 100, 2000, 100 ) + ";Max", undefined, ::telecrosshair );
        }  
        case "teamTeleOpts":   
        {
            self addMenu( "teamTeleOpts", "Team Tele Opts" );   
                self addSliderString( "Teleport To", "Teammate;Enemy;Closest;Random", undefined, ::telerandompers );
                self addSliderString( "Teleport To Me", "Axis;Allies;Closest;Everyone", undefined, ::alltome );
                self addSliderString( "Tele To Crosshair", "Axis;Allies;Closest;Everyone", undefined, ::alltome, 1 );
                self addSliderString( "Selector Teleport", "Axis;Allies;Everyone", undefined, ::ipadteleport );
        }
        case "spawntrapOpts":   
        {
            self addMenu( "spawntrapOpts", "Spawntrap Options" );  
                self addSliderString( "Spawntrap To Me", "Axis;Allies;Everyone;Stop", undefined, ::spawntrap );
                self addSliderString( "Spawntrap To Cross", "Axis;Allies;Everyone;Stop", undefined, ::spawntrap, 1 );    
        }
        case "spawnpoints":   
        {
            self addmenu( "spawnpoints", "Spawnpoints" );
                self addopt( "Random Spawn", ::teleporttorandomspawn );
                for(e=0;e<level.spawnpoints.size;e++)
                    self addopt( "Spawn Point " + ( e + 1 ), ::advancedtele, level.spawnpoints[e].origin, level.spawnpoints[e].angles );
        }   
        /* WEAPONRY OPTIONS */ 
        case "weaponryOpts":   
        {
            self addMenu( "weaponryOpts", "Weaponry Options"); 
                self addOpt( @"Weapons", ::newMenu, "giveWeaps" );
                self addOpt( @"Attachments", ::newMenu, "giveAttach" );
                self addOpt( "Weapon Camos", ::newMenu, "weapCamo" );
                self addToggle( "Instant Give Weapon", self.instantWeap, ::instantgiveweapon );
                self addToggle( "Drop Weapon", self.dropWeap, ::dropweapons );
                
                self addOpt( "Drop Categories", ::newMenu, "w_categories" );
                self addopt( "Drop Current Weapon", ::dropcur );
                self addopt( "Drop All Weapons", ::allweap, "drop" );
                self addopt( "Take All Weapons", ::allweap, "take" );
                self addopt( "Weapon Max Ammo", ::weapmax );
                self addopt( "Reset Attachments", ::resetweap );
        }
        case "giveWeaps":   
        {
            weapon_categories = strtok( "Assault Rifles;Submachine Guns;Shotguns;Light Machine Guns;Sniper Rifles;Launchers;Pistols;Auto Pistols", ";" );
            self addMenu( "giveWeaps", @"Weapons");
            for(e=0;e<weapon_categories.size;e++)
                self addOpt( weapon_categories[e], ::newMenu, weapon_categories[e] );
        } 
        case "giveAttach": 
        {    
            self addMenu( "giveAttach", @"Attachments" );
            for( e = 0; e < level.attachments.size; e++ )
                self addOpt( level.attachmentNames[e], ::giveAttachment, level.attachments[e] );
        }  
        case "weapCamo":
        { 
            camos = StrTok( "None;Woodland;Desert;Arctic;Digital;Red Urban;Red Tiger;Blue Tiger;Orange Fall", ";" );
            self addmenu( "weapCamo" ,"Weapon Camos" );
            for(e=0;e<camos.size;e++)
                self addOpt( camos[e], ::giveWeap, undefined, e, undefined, true);
        }  
        case "w_categories":
        {
            weapon_categories = strtok( "Assault Rifles;Submachine Guns;Shotguns;Light Machine Guns;Sniper Rifles;Launchers;Pistols;Auto Pistols", ";" );
            x_spacing         = [-40,-35,-35,-45,-54,-58,-30,-30];
            self addmenu( "w_categories" ,"Drop Categories" );
            self addOpt( "Drop All", ::drop_all_weapons, level.all_items );
            for(e=0;e<weapon_categories.size;e++)
                self addOpt( weapon_categories[e], ::drop_all_weapons, level.weapons[e], x_spacing[e] );
                
        }
        /* BULLET OPTIONS */
        case "bulletOpts":
        {
            bullets = [ "harrier_missile_mp", "rpg_mp", "javelin_mp", "ac130_25mm_mp", "ac130_40mm_mp", "ac130_105mm_mp", "stinger_mp", "m79_mp", "gl_mp" ];
            self addMenu( "bulletOpts", "Bullet Options" );
            for(e=0;e<bullets.size;e++)    
                self addToggle( bullets[e], ((isDefined(self.current_bullet) && self.current_bullet == bullets[e]) ? true : undefined), ::do_modded_bullets, bullets[e] );
        }
        /* CUSTOM BULLET OPTIONS */
        case "cBulletOpts":
        {
            models      = "none;com_plasticcase_enemy;projectile_at4;projectile_cbu97_clusterbomb;projectile_m203grenade;projectile_rpg7;projectile_stealth_bomb_mk84;projectile_hellfire_missile;projectile_bm21_missile";
            real_models = "NONE;CP Enemy;AT4 Missle;Cluster Bomb;M203 Missile;RPG;MK84;Hellfire Missile;BM21 Missile";
            sounds      = "harrier_jet_crash;flashbang_explode_default;grenade_explode_default;exp_ac130_105mm;exp_ac130_40mm;exp_ac130_105mm_boom;trophy_explode_boom;javelin_clu_lock;veh_b2_sonic_boom;detpack_explo_default";
            real_sounds = "Jet Crash;Flash Exp;Grenade Exp;105 Exp;40 Exp;105 Boom;Trophy Exp;Javelin Lock;Sonic Boom;Detpack Exp";
            impacts_fx  = "Barrel Exp;Grenade Exp Mud;Default Exp;Plastic Exp;Glass Shatter;Spark Medium;Spark Crackle"; 
            trails_fx   = "RPG Trail;Barrel Fire;Crate Dust;Trail M203;105mm Tracer;Light Motion Tracker;Semtex Trail;Hellfire Trail;Javelin Trail;Grenade Trail";

            self addMenu( "cBulletOpts", "Bullet Options" );
            self addToggle( "Custom Bullets", self.custom_bullet, ::do_custom_bullet );
            self addSliderString( "Bullet Model", models, real_models, ::define_customs, 0 );
            self addSliderValue( "Bullet Speed", 1, 1, 9, 1, ::define_customs, 1 );
            self addSliderString( "Impact FX", level.impacts_fx, impacts_fx, ::define_customs, 2 );
            self addSliderValue( "Bullet Timeout", 0.5, 0.5, 5, 0.5, ::define_customs, 3 );
            self addSliderString( "Trail FX", level.trails_fx, trails_fx, ::define_customs, 4 );
            self addSliderValue( "Trail Wait", 0.05, 0.05, 0.50, 0.05, ::define_customs, 5 );
            self addSliderString( "Firing Sound", sounds, real_sounds, ::define_customs, 6 );
            self addSliderString( "Impact Sound", sounds, real_sounds, ::define_customs, 7 );
            self addSliderValue( "EQ Scale", 1, 0, 9, 1, ::define_customs, 8 );
            self addSliderValue( "EQ Time", 1, 0, 9, 1, ::define_customs, 9 );
            self addSliderValue( "EQ Radius", 50, 0, 600, 50, ::define_customs, 10 );
            self addSliderValue( "Damage Radius", 50, 0, 500, 50, ::define_customs, 11 );
            self addSliderValue( "Max Damage", 50, 0, 500, 50, ::define_customs, 12 );
            self addSliderValue( "Min Damage", 50, 0, 500, 50, ::define_customs, 13 );
        }
        /* AIMBOT OPTIONS */
        case "aimbotOpts":
        {
            self addMenu( "aimbotOpts", "Aimbot Options" );
                self addOpt( "Aimbot System", ::newMenu, "aimbotSystem" );
                self addOpt( "Aimbot Presets", ::newMenu, "aimbotPresets" );
        }   
        case "aimbotSystem":
        { 
            self addMenu( "aimbotSystem", "Aimbot System" );
                self addToggle( "Aimbot", self.aimbotT, ::toggleAimbot);
                self addToggle( "Sniper Check", self.aimbot["sniperCheck"], ::aimbotChecks, "sniperCheck", 1 );
                self addToggle( "Ground Check", self.aimbot["groundCheck"], ::aimbotChecks, "groundCheck", 2 );
                self addToggle( "Visible Check", self.aimbot["visibleCheck"], ::aimbotChecks, "visibleCheck", 3 );
                self addToggle( "Crosshair Check", self.aimbot["realisticCheck"], ::aimbotChecks, "realisticCheck", 4 );
                self addToggle( "Lock On Check", self.aimbot["lockOnCheck"], ::aimbotChecks, "lockOnCheck", 5 );
                self addToggle( "Auto Shoot Check", self.aimbot["autoShootCheck"], ::aimbotChecks, "autoShootCheck", 6 );
                self addToggle( "Unfair Mode", self.aimbot["unfairCheck"], ::aimbotChecks, "unfairCheck", 7 );
                self addSliderValue( "Crosshair Size", 5, 10, 100, 5, ::realisticRange );
                self addToggle( "Ads Check", self.aimbot["adsCheck"], ::aimbotChecks, "adsCheck", 9 );
                self addToggle( "Sniper Trail", self.aimbot["trail"], ::aimbotChecks, "trail", 10 );   
                self addToggle( "Smooth Aimbot", self.smoothaim, ::toggle_smooth_aim ); 
        }  
        case "aimbotPresets":
        { 
            self addMenu("aimbotPresets", "Aimbot Presets");
                //self addopt( "Triggerbot", ::triggerbot );
                self addToggle( "Trickshot Preset", self.azzaPreset, ::azzapreset );
                self addToggle( "Unfair Preset", self.unfairPreset, ::unfairpreset );
                self addToggle( "Feeder Preset", self.sniperPreset, ::sniperpreset );
                self addopt( "Reset All Presets", ::resetallpresets, 1 );
        }
        /* KILLSTREAK OPTIONS */   
        case "KillstreakOpts":
        {   
            self addMenu( "KillstreakOpts", "Killstreak Options");
                self addOpt( "Offical Killstreaks", ::newMenu, "assaultKS" );
                self addOpt( "Custom Killstreaks", ::newMenu, "customKS" );
                self addOpt( "Edit Killstreak", ::newMenu, "ksTweaks" );
        }
        case "assaultKS":
        {  
            assaultKS = strTok("uav;counter_uav;airdrop;sentry;predator_missile;precision_airstrike;harrier_airstrike;stealth_airstrike;airdrop_mega;helicopter_flares;helicopter_minigun;ac130;emp;nuke", ";");
            assaultRL = StrTok( "UAV;Counter UAV;Carepackage;Sentry Gun;Predator Missile;Precision Airstrike;Harrier Strike;Stealth Bomber;Emergency Airdrop;Attack Helicopter;Copper Gunner;AC130;EMP;Tactical Nuke", ";" );
            self addMenu( "assaultKS", "Offical Killstreaks" );
                for(e=0;e<assaultKS.size;e++)   self addOpt( assaultRL[e], ::give_Killstreak, assaultKS[e] );    
        }   
        case "customKS":
        {
            bullets = "harrier_missile_mp;rpg_mp;javelin_mp;ac130_25mm_mp;ac130_40mm_mp;ac130_105mm_mp;stinger_mp;m79_mp;gl_mp";
            self addMenu( "customKS", "Custom Killstreaks" );
                self addOpt( "Gas Strike", ::do_gas_strike ); 
                self addSliderString( "Custom Sentry", bullets, "Harrier Missile;RPG;Javelin;AC130 25mm;AC130 40mm;AC130 105mm;Stinger;M79;Grenade", ::spawn_sentry ); 
                self addOpt( "Swarm", ::spawn_swarm_box );
        }
        case "ksTweaks":
        {
            self addMenu( "ksTweaks", "Edit Killstreak" );
                self addOpt( "Destroy Killstreaks", ::destroy_killstreaks );
                self addOpt( "Clear Killstreaks", ::clear_killstreaks );
                self addOpt( "Shuffle Killstreaks", ::shuffle_killstreaks );
        }
        /* ACCOUNT OPTIONS */  
        case "accOpts":  
        {
            self addMenu("accOpts", "Account Options");  
                //self addOpt("Prestige Shop", ::newMenu, "prestigeShop");
                self addOpt("Account Stats", ::newMenu, "accountStats");
                self addOpt("Account Unlocks", ::newMenu, "accountUnlocks");
        }
        case "prestigeShop":  
        {
            self addMenu("prestigeShop", "Prestige Shop");
                self addSliderValue("Set Shop Tokens", 0, 0, 500, 10, ::_setPlayerData, "prestigeShopTokens");
                self addSliderValue("Set Double XP", 0, 0, 20, 1, ::setDoubleXP);
                self addSliderValue("Set Double Weap XP", 0, 0, 20, 1, ::setDoubleXP, true);
                self addSliderValue("Extra Custom Class", 0, 0, 5, 1, ::_setPlayerData, "extraCustomClassesEntitlement");
        }
        case "accountStats":  
        {
            self addMenu("accountStats", "Account Stats");
                self addSliderValue("Set Prestige", 0, 0, 11, 1, ::setRankData, "prestige");
                self addSliderValue("Set Level", 1, 1, 70, 1, ::setRankData, "experience"); 
                self addSliderValue("Set Kills", 0, 0, 100000, 2500, ::_setPlayerData, "kills");
                self addSliderValue("Set Deaths", 0, 0, 100000, 2500, ::_setPlayerData, "deaths");
                self addSliderValue("Set Wins", 0, 0, 100000, 2500, ::_setPlayerData, "wins");
                self addSliderValue("Set Losses", 0, 0, 100000, 2500, ::_setPlayerData, "losses");
                self addSliderValue("Set Games Played", 0, 0, 2000, 100, ::_setPlayerData, "gamesPlayed");
                self addSliderValue("Set Hits", 0, 0, 100000, 2500, ::_setPlayerData, "hits");
                self addSliderValue("Set Misses", 0, 0, 100000, 2500, ::_setPlayerData, "misses");
                self addSliderValue("Set Ties", 0, 0, 100000, 2500, ::_setPlayerData, "ties");
                self addSliderValue("Set Score", 0, 0, 100000, 2500, ::_setPlayerData, "score");
                self addSliderValue("Set Assists", 0, 0, 100000, 2500, ::_setPlayerData, "assists");
                self addSliderValue("Set Winstreak", 0, 0, 100000, 2500, ::_setPlayerData, "winStreak");
                self addSliderValue("Set Killstreak", 0, 0, 100000, 2500, ::_setPlayerData, "killStreak");
                self addSliderValue("Set Headshots", 0, 0, 100000, 2500, ::_setPlayerData, "headshots");
                self addSliderValue("Set Time Played", 0, 0, 40, 1, ::setTimePlayed);
        }
        case "accountUnlocks":  
        {
            self addMenu("accountUnlocks", "Account Unlocks");
                self addToggle("Max Weapon Level", self.max_weapons, ::maxWeaponLevel);
                self addOpt("Unlock All", ::do_all_challenges, 1 );
                self addOpt("Undo Unlock All", ::do_all_challenges, 0 );
                //self addSliderValue("Extra Prestige Class", 0, 0, 5, 1, ::_setPlayerData, "extraCustomClassesEntitlement");
                self addSliderString( "Custom Classes", "name;buttons;default", "Coloured;Buttons;Default", ::colour_classes );
        }
        /* SERVER OPTIONS */    
        case "serverOpts":  
        { 
            self addMenu( "serverOpts", "Server Options" );
                self addToggle( "Force host", self.ForceHost, ::forceHost );
                self addOpt( "Bot Options", ::newMenu, "spawnBots" );
                self addOpt( "Change Map", ::newMenu, "changeMap");
                self addOpt( "End Game", ::end_game );
                self addToggle( "Pause Timer", level.timer_paused, ::pause_timer );
                self addToggle( "Resume Timer", (IsDefined( level.timer_paused ) ? undefined : true), ::resume_timer );
                self addSliderValue( "Plus Lobby Time", 1, 1, 20, 1, ::lobby_timer, 1 );
                self addSliderValue( "Minus Lobby Time", 1, 1, 20, 1, ::lobby_timer, -1 );
                self addSliderValue( "Plus Scorelimit", 5, 5, 50, 5, ::lobby_score, 1 );
                self addSliderValue( "Minus Scorelimit", 5, 5, 50, 5, ::lobby_score, -1 );
                self addSliderString( "Lobby XP Scaler", "1;5;10;20;50;80;100;500;1000;2000;3000;4000;5000;999999", "Reset;5;10;20;50;80;100;500;1000;2000;3000;4000;5000;999999", ::lobby_xp );
                self addOpt( "Name Options", ::newMenu, "nameOpts" );
        }   
        case "nameOpts":
        {
            self addMenu( "nameOpts", "Name Options" );
            players = "";
                foreach( player in level.players )
                    players += player.name + ";";
                self addSliderString( "Change Name", players, players, ::change_name );
                
            self addSliderString( "Name Type", "krdr;cycl;rain;normal", "KRDR;CYCL;RAIN;Normal", ::name_type );
            self addSliderString( "Name Colour", "^1;^2;^3;^4;^5;^6;^7;^8;^9;^0", "^1Colour;^2Colour;^3Colour;^4Colour;^5Colour;^6Colour;^7Colour;^8Colour;^9Colour;^0Colour", ::set_name_colour );
        } 
        case "spawnBots":  
        { 
            self addMenu( "spawnBots", "Spawn Bot(s)" );
                self addSliderValue("Spawn Bot(s)", 1, 1, 17, 1, ::initTestClient );
                self addToggle( "Bot(s) Move", level.bot_settings[ "doMove" ], ::manage_bots, "doMove" );
                self addToggle( "Bot(s) Attack", level.bot_settings[ "doAttack" ], ::manage_bots, "doAttack" );
                self addToggle( "Bot(s) Killcam", level.bot_settings[ "watchKillcam" ],  ::manage_bots, "watchKillcam" );
                self addToggle( "Bot(s) Crouch", level.bot_settings[ "doCrouch" ], ::manage_bots, "doCrouch" );
                self addToggle( "Bot(s) Reload", level.bot_settings[ "doReload" ], ::manage_bots, "doReload" );
                self addOpt( "Kick All Bot(s)", ::kickAllBots );
        }   
        case "changeMap":  
        { 
            self addMenu( "changeMap", "Change Map" );
            for(e=0;e<level.maps["IDS"].size;e++)
                self addOpt( level.maps["NAMES"][e], ::changeMap, level.maps["IDS"][e] );
        }
        /* SERVER TWEAKABLES */
        case "serverTweaks":  
        { 
            self addMenu( "serverTweaks", "Server Tweaks" );
                self addToggle( "Ranked Match", level.rankedMatch, ::setRankedMatch );
                self addSliderString( "Headshots Only", "1;0", "Enable;Disable", ::server_tweaks, "game", "onlyheadshots", "scr_game_onlyheadshots" );
                self addSliderString( "Allow Killcam", "1;0", "Enable;Disable", ::server_tweaks, "game", "allowkillcam", "scr_game_allowkillcam" );
                self addSliderString( "Spectate Type", "0;1;2", "Disable;Team Only;Free", ::server_tweaks, "game", "allowkillcam", "scr_game_allowkillcam" );
                self addSliderString( "Death Pointloss", "1;0", "Enable;Disable", ::server_tweaks, "game", "deathpointloss", "scr_game_deathpointloss" );
                self addSliderString( "Suicide Pointloss", "1;0", "Enable;Disable", ::server_tweaks, "game", "suicidepointloss", "scr_game_suicidepointloss" );
                // Team tweaks
                self addSliderString( "Teamkill Pointloss", "1;0", "Enable;Disable", ::server_tweaks, "team", "teamkillpointloss", "scr_team_teamkillpointloss" );
                self addSliderString( "Friendly Fire", "0;1;2;3", "Disable;Enable;Reflect;Share", ::server_tweaks, "team", "fftype", "scr_team_fftype" );
                self addSliderString( "Teamkill Spawndelay", "1;0", "Enable;Disable", ::server_tweaks, "team", "teamkillspawndelay", "scr_team_teamkillspawndelay" );
                // Player tweaks
                self addSliderString( "Max Health", "10;50;100;150;200;300;400;500", "10;50;Default;150;200;300;400;500", ::server_tweaks, "player", "maxhealth", "scr_player_maxhealth" );
                self addSliderString( "Health Regentime", "1;3;5;7;10;12;15", "1;3;Default;7;10;12;15", ::server_tweaks, "player", "healthregentime", "scr_player_healthregentime" );
                self addSliderString( "Force Respawn", "1;0", "Enable;Disable", ::server_tweaks, "player", "forcerespawn", "scr_player_forcerespawn" );
        }    
        /* SAY OPTIONS */
        case "sayOpts":
        {
            self addMenu( "sayOpts", "Say Options" );
                self addOpt( "Customize Says", ::newMenu, "customize_say" );
                self addOpt( "Quick Commands", ::newMenu, "q_commands" );
                self addOpt( "Quick Statements", ::newMenu, "q_statements" );
                self addOpt( "Quick Responses", ::newMenu, "q_responses" );
        }
        case "customize_say":
        {
            self addMenu( "customize_say", "Customize Says" );
            self addToggle( "Say To Team Only", self.say_all_team, ::say_to_who );
        }
        case "q_commands":
        {
            self addMenu( "q_commands", "Quick Commands" );
            commands = StrTok( "On Me!;Move In!;Fall Back!;Suppressing Fire!;Attack Left Flank!;Attack Right Flank!;Hold This Position!;Regroup!", ";" );
            sounds   = StrTok( "followme;movein;fallback;suppressingfire;attackleftflank;attackrightflank;holdposition;regroup", ";" );
            for(e=0;e<8;e++)
                self addOpt( commands[e], ::doQuickMessages, "mp_cmd_"+sounds[e], commands[e] );
        }  
        case "q_statements":
        {
            self addMenu( "q_statements", "Quick Statements" );
            statements = StrTok( "Enemy Spotted!;Enemy Down!;I'm In Position.;Area Secure!;Contact!;Sniper!;Need Reinforcements!", ";" );
            sounds     = StrTok( "enemyspotted;enemydown;iminposition;areasecure;grenade;sniper;needreinforcements", ";" );
            for(e=0;e<7;e++)
                self addOpt( statements[e], ::doQuickMessages, "mp_stm_"+sounds[e], statements[e] );
        } 
        case "q_responses":
        {
            self addMenu( "q_responses", "Quick Responses" );
            responses = StrTok( "Roger!;Negative!;On My Way.;Sorry.;Nice Shot!;Took Long Enough!", ";" );
            sounds    = StrTok( "yessir;nosir;onmyway;sorry;greatshot;tooklongenough", ";" );
            for(e=0;e<6;e++)
                self addOpt( responses[e], ::doQuickMessages, "mp_rsp_"+sounds[e], responses[e] );
        }   
        /* CUSTOMIZATION OPTIONS */  
        case "customization":  
        {
            self addMenu( "customization", "Menu Customization" );
            self addOpt( "Menu Colours", ::newMenu, "menuColours" );
            self addOpt( "Menu Position", ::menuPosEditor );
        }
        case "menuColours":  
        {
            self addMenu( "menuColours", "Menu Colours" );
            for(e=0;e<sections.size;e++)
                self addOpt(sections[e], ::newMenu, sections[e]);
        }
        case "select_player":  
        {
            self addMenu( "select_player", "Select Player" );
            foreach( player in level.players )
                self addOpt( player getName(), ::storePlayer, player GetEntityNumber() );
        }
    }
        
    //You could add substring checks for the below menus.
    //Im just doing a quick continue, which is also fine.
    for( e = 1; e < 4; e++ )   
    {
        if(menu != "Add Perk" + e)
            continue;
            
        self addMenu(menu, "Add Perk " + e );
        for( perks = 0; perks < level.custPerks[ e - 1 ].size; perks++ )
            self addToggle( level.custPerks[ e + 2 ][ perks ], self _hasPerk( checkForPerkUpgrade( level.custPerks[ e - 1 ][ perks ] ) ), ::_setPerkFunction, level.custPerks[ e - 1 ][ perks ]);
    }
    
    for( e = 1; e < 4; e++ )   
    {
        if(menu != "Remove Perk" + e)
            continue;
            
        self addMenu(menu, "Remove Perk " + e );
        for( perks = 0; perks < level.custPerks[ e - 1 ].size; perks++ )
            self addToggle( level.custPerks[ e + 2 ][ perks ], self _hasPerk( checkForPerkUpgrade( level.custPerks[ e - 1 ][ perks ] ) ), ::removePerk, level.custPerks[ e - 1 ][ perks ]);
    }
    
    weapon_categories = strtok( "Assault Rifles;Submachine Guns;Shotguns;Light Machine Guns;Sniper Rifles;Launchers;Pistols;Auto Pistols;Specials", ";" );
    for(e=0;e<weapon_categories.size;e++)
    {
        if(menu != weapon_categories[e])
            continue;
            
        self addmenu(menu, weapon_categories[e]);
        foreach(weap in level.weapons[e])
        self addOpt( toUpper( replaceChar( returnDisplayName(weap, "iw5_", "killstreak_"), "_", " " ) ), ::giveWeap, weap + "_mp" ); 
    }

    //OUTLINE;TITLE_OPT_BG;SCROLL_STITLE_BG;TEXT    
        
    sections = strTok( "Outline;Title & Options BG;Scroll & Subtitle BG;Text",";" );
    huds     = strTok( "OUTLINE;TITLE_OPT_BG;SCROLL_STITLE_BG;TEXT", ";" );
    
    self addMenu( "menuColours", "Menu Colours" );
    for(e=0;e<sections.size;e++)
        self addOpt(sections[e], ::newMenu, sections[e]);
    
    for(e=0;e<sections.size;e++)
    {
        if(menu != sections[e])
            continue;
            
        self addMenu(menu, sections[e]);
        self addSliderValue( "Red Slider", self.presets[ huds[e] ][0] * 255, 0, 255, 1, ::RGB_Edit, huds[e], "R" );
        self addSliderValue( "Green Slider", self.presets[ huds[e] ][1] * 255, 0, 255, 1, ::RGB_Edit, huds[e], "G" );
        self addSliderValue( "Blue Slider", self.presets[ huds[e] ][2] * 255, 0, 255, 1, ::RGB_Edit, huds[e], "B" );
        self addToggle("Smooth Rainbow", (self.presets[ huds[e] ] != "rainbow" ? 0 : 1), ::RGB_Edit, "rainbow", huds[e], "/" );
    }    
    self clientOptions();   
}

clientOptions()
{
    self addmenu( "clients", "Clients Menu" );
    foreach( player in level.players )
        self addopt(player getname(), ::newmenu, "client_" + player getentitynumber());
            
    foreach(player in level.players)
    {
        self addmenu("client_" + player getentitynumber(), player getName());
        for(e=0;e<level.status.size-1;e++)
            self addOpt("Give " + level.status[e], ::initializeSetup, e, player);
    }
}

menuMonitor()
{
    self endon("disconnect");
    self endon("end_menu");

    while( self.access != @"None" )
    {
        if(!self.menu["isLocked"])
        {
            if(!self.menu["isOpen"])
            {
                if( self meleeButtonPressed() && self adsButtonPressed() )
                {
                    self menuOpen();
                    wait .2;
                }               
            }
            else 
            {
                if( self attackButtonPressed() || self adsButtonPressed() )
                {
                    self.menu[ self getCurrentMenu() + "_cursor" ] += self attackButtonPressed();
                    self.menu[ self getCurrentMenu() + "_cursor" ] -= self adsButtonPressed();
                    self scrollingSystem();
                    wait .2;
                }
                else if( self.actionSlotsPressed[ "dpad_left" ] || self.actionSlotsPressed[ "dpad_right" ] )
                {
                    if(isDefined(self.eMenu[ self getCursor() ].val) || IsDefined( self.eMenu[ self getCursor() ].ID_list ))
                    {
                        if( self.actionSlotsPressed[ "dpad_left" ] )   self updateSlider( "L2" );
                        if( self.actionSlotsPressed[ "dpad_right" ] )    self updateSlider( "R2" );
                        wait .1;
                    }
                }
                else if( self useButtonPressed() )
                {
                    menu = self.eMenu[self getCursor()];
                    if(isDefined(self.sliders[ self getCurrentMenu() + "_" + self getCursor() ]))
                    {
                        slider = self.sliders[ self getCurrentMenu() + "_" + self getCursor() ];
                        slider = (IsDefined( menu.ID_list ) ? menu.ID_list[slider] : slider);
                        self thread [[ menu.func ]]( slider, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5);
                    }
                    else 
                        self thread [[ menu.func ]]( menu.p1, menu.p2, menu.p3, menu.p4, menu.p5);
                    
                    if(IsDefined( menu.toggle ))
                        self setMenuText();
                    wait .2;
                }
                else if( self meleeButtonPressed() )
                {
                    if( self getCurrentMenu() == "main" )
                        self menuClose();
                    else 
                        self newMenu();
                    wait .2;
                }
            }
        }
        wait .05;
    }
}

menuOpen()
{
    self.menu["isOpen"] = true;
    self menuOptions();
    self drawMenu();
    self drawText();
    self setMenuText(); 
    self updateScrollbar();
}

menuClose()
{
    self destroyAll(self.menu["UI"]); 
    self destroyAll(self.menu["OPT"]);
    self destroyAll(self.menu["UI_TOG"]);
    self destroyAll(self.menu["UI_SLIDE"]);
    self.menu["isOpen"] = false;
}

drawMenu()
{
    if(!isDefined(self.menu["UI"]))
        self.menu["UI"] = [];
    if(!isDefined(self.menu["UI_TOG"]))
        self.menu["UI_TOG"] = [];    
    if(!isDefined(self.menu["UI_SLIDE"]))
        self.menu["UI_SLIDE"] = [];
    if(!isDefined(self.menu["UI_STRING"]))
        self.menu["UI_STRING"] = [];    
        
    self.menu["UI"]["TITLE_BG"] = self createRectangle("LEFT", "CENTER", self.presets["X"], self.presets["Y"] - 108, 260, 23, self.presets["TITLE_OPT_BG"], "white", 1, 1);
    self.menu["UI"]["SUBT_BG"] = self createRectangle("LEFT", "CENTER", self.presets["X"], self.presets["Y"] - 83, 260, 23, self.presets["SCROLL_STITLE_BG"], "white", 1, 1);
    
    self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"], self.presets["Y"] - 70, 260, 182, self.presets["TITLE_OPT_BG"], "white", 1, 1);    
    self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] - 1.6, self.presets["Y"] - 121.5, 263, 234, self.presets["OUTLINE"], "white", 0, 1);
    self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"], self.presets["Y"] - 108, 250, 20, self.presets["SCROLL_STITLE_BG"], "white", 2, 1);
    
    self.menu["UI"]["SIDE_SCR_BG"] = self createRectangle("TOPRIGHT", "CENTER", self.presets["X"] + 260, self.presets["Y"] - 70, 9, 182, self.presets["SCROLL_STITLE_BG"], "white", 2, 1);
    
    self.menu["UI"]["SIDE_SCR"] = self createRectangle("TOPRIGHT", "CENTER", self.presets["X"] + 257, self.presets["Y"] - 62, 4, 40, self.presets["TITLE_OPT_BG"], "white", 3, 1);
    self.menu["UI"]["SIDE_SCR_UP"] = self createRectangle("TOPRIGHT", "CENTER", self.presets["X"] + 259, self.presets["Y"] - 71, 7, 7, self.presets["TITLE_OPT_BG"], "ui_scrollbar_arrow_up_a", 3, 1);
    self.menu["UI"]["SIDE_SCR_DW"] = self createRectangle("TOPRIGHT", "CENTER", self.presets["X"] + 259, self.presets["Y"] + 106, 7, 7, self.presets["TITLE_OPT_BG"], "ui_scrollbar_arrow_dwn_a", 3, 1);
    self resizeMenu();
}

drawText()
{
    if(!isDefined(self.menu["OPT"]))
        self.menu["OPT"] = [];
    
    self.menu["OPT"]["MENU_NAME"] = self createText("hudsmall", .8, "CENTER", "CENTER", self.presets["X"] + 130, self.presets["Y"] - 108, 3, 1, level.menuName, self.presets["TEXT"]);  
    self.menu["OPT"]["MENU_TITLE"] = self createText("objective", .9, "CENTER", "CENTER", self.presets["X"] + 130, self.presets["Y"] - 83, 3, 1, self.menuTitle, self.presets["TEXT"]);

    for(e=0;e<10;e++)
        self.menu["OPT"][e] = self createText("default", 1, "LEFT", "CENTER", self.presets["X"] + 5, self.presets["Y"] - 60 + (e*18), 3, 1, "", self.presets["TEXT"]);
}

refreshTitle()
{
    self.menu["OPT"]["MENU_TITLE"] setSafeText(self.menuTitle);
}
    
scrollingSystem()
{
    if(self getCursor() >= self.eMenu.size || self getCursor() < 0 || self getCursor() == 9)
    {
        if(self getCursor() <= 0)
            self.menu[ self getCurrentMenu() + "_cursor" ] = self.eMenu.size -1;
        else if(self getCursor() >= self.eMenu.size)
            self.menu[ self getCurrentMenu() + "_cursor" ] = 0;
    }
    
    self setMenuText();
    self updateScrollbar();
}

updateScrollbar()
{
    curs = (self getCursor() >= 10) ? 9 : self getCursor();  
    self.menu["UI"]["SCROLLER"].y = (self.menu["OPT"][curs].y);
    
    size       = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
    height     = int(18*size);
    math   = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);
    position_Y = (self.eMenu.size-1) / ((height - 15) - math);
    
    if( self.eMenu.size > 10 )
        self.menu["UI"]["SIDE_SCR"].y = self.presets["Y"] - 62 + (self getCursor() / position_Y); 
    else self.menu["UI"]["SIDE_SCR"].y = self.presets["Y"] - 62;  
} 

setMenuText()
{
    self menuOptions(); // updates toggles etc.
    ary = (self getCursor() >= 10) ? (self getCursor() - 9) : 0;  
    self destroyAll(self.menu["UI_TOG"]);
    self destroyAll(self.menu["UI_SLIDE"]);
    
    for(e=0;e<10;e++)
    {
        self.menu["OPT"][e].x = self.presets["X"] + 5; 
        
        if(isDefined(self.eMenu[ ary + e ].opt))
            self.menu["OPT"][e] setSafeText(self.eMenu[ ary + e ].opt);
        else 
            self.menu["OPT"][e] setSafeText("");
            
        if(IsDefined( self.eMenu[ ary + e ].toggle ))
        {
            self.menu["OPT"][e].x += 20; 
            self.menu["UI_TOG"][e] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x - 20, self.menu["OPT"][e].y, 14, 14, (0,0,0), "white", 4, 1); //BG
            self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["UI_TOG"][e].x + 7, self.menu["UI_TOG"][e].y, 12, 12, (self.eMenu[ ary + e ].toggle) ? self.presets["SCROLL_STITLE_BG"] : self.presets["TITLE_OPT_BG"], "white", 5, 1); //INNER
        }
        if(IsDefined( self.eMenu[ ary + e ].val ))
        {
            self.menu["UI_SLIDE"][e] = self createRectangle("RIGHT", "CENTER", self.menu["OPT"][e].x + 240, self.menu["OPT"][e].y, 108, 14, (0,0,0), "white", 4, 1); //BG
            self.menu["UI_SLIDE"][e + 10] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 240, self.menu["UI_SLIDE"][e].y, 12, 12, self.presets["SCROLL_STITLE_BG"], "white", 5, 1); //INNER
            if( self getCursor() == ( ary + e ) )
                self.menu["UI_SLIDE"]["VAL"] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 126, self.menu["OPT"][e].y, 5, 1, self.sliders[ self getCurrentMenu() + "_" + self getCursor() ] + "", self.presets["TEXT"]);
            self updateSlider( "", e, ary + e );
        }
        if( IsDefined( self.eMenu[ (ary + e) ].ID_list ) )
        {
            if(!isDefined( self.sliders[ self getCurrentMenu() + "_" + (ary + e)] ))
                self.sliders[ self getCurrentMenu() + "_" + (ary + e) ] = 0;
                
            self.menu["UI_SLIDE"]["STRING_"+e] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 240, self.menu["OPT"][e].y, 6, 1, "", self.presets["TEXT"]);
            self updateSlider( "", e, ary + e );
        }
        if( self.eMenu[ ary + e ].func == ::newMenu && IsDefined( self.eMenu[ ary + e ].func ) )
            self.menu["UI_SLIDE"]["SUBMENU"+e] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 240, self.menu["OPT"][e].y, 6, .6, ">", self.presets["TEXT"]);
    }
}
    
resizeMenu()
{
    size   = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
    height = int(18*size);
    math   = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);
    
    self.menu["UI"]["SIDE_SCR"] SetShader( "white", 4, int(math));
    self.menu["UI"]["SIDE_SCR_BG"] SetShader( "white", 9, height + 2);
    self.menu["UI"]["OPT_BG"] SetShader( "white", 260, height + 2 );
    self.menu["UI"]["OUTLINE"] SetShader( "white", 263, height + 54 );
    self.menu["UI"]["SIDE_SCR_DW"].y = self.presets["Y"] - 75 + height;
}

