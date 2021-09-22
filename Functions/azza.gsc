trickPlatform()
{
    position = (self.origin + (0,0,-60));
    
    level.platform = []; 
    for(e=0;e<7;e++) for(a=0;a<12;a++)
        level.platform[level.platform.size] = modelSpawner(position + (-70+a*31,22-e*57,0),"com_plasticcase_enemy", (0,90,0));                   //MAIN PLAT
    for(e=0;e<6;e++)    
        level.platform[level.platform.size] = modelSpawner(position + (330, -40 + e*-60, 185 + e*-34),"com_plasticcase_enemy", (-30,90,0));         //RAMP
    for(e=0;e<3;e++) for(a=0;a<5;a++)
        level.platform[level.platform.size] = modelSpawner(position + (-70+a*31,22-e*57,200) + (400,130,0),"com_plasticcase_enemy", (0,90,0));   //SMALL PLAT
    for(e=0;e<3;e++) for(a=0;a<5;a++)
        level.platform[level.platform.size] = modelSpawner(position + (-70+a*31,22-e*57,200) + (-100,-330,0),"com_plasticcase_enemy", (0,90,0)); //SMALL WALLRUN PLAT
    for(e=0;e<7;e++) for(a=0;a<4;a++)                                                               
        level.platform[level.platform.size] = modelSpawner(position + (-70,22-e*57,200+a*27) + (-240,-60,0),"com_plasticcase_enemy", (0,90,0));  //WALLRUN
    
    level.platform[level.platform.size] = modelSpawner(position + (-280,160,0),"com_plasticcase_enemy", (0,0,0));                             //WALL BOUNCE
    level.platform[level.platform.size-1] thread createBounce(70, (0,0,300), 10);   
    level.platform[level.platform.size] = modelSpawner(position + (150,-160,175),"com_plasticcase_enemy", (0,130,0));                             //MID BOUNCE
    level.platform[level.platform.size-1] thread createBounce(70, (0,0,300), 3);    
        
    //FRONT 
    level.platform[level.platform.size] = modelSpawner(position + (50,50,35),"com_plasticcase_friendly", (-60,90,0));      //SLIDE (SMALL)
    level.platform[level.platform.size-1] thread createBounce(80, undefined, 18, true); 
    level.platform[level.platform.size] = modelSpawner(position + (210,50,35),"com_plasticcase_friendly", (-60,90,0));     //SLIDE (MED)
    level.platform[level.platform.size-1] thread createBounce(80, undefined, 36, true); 
    level.platform[level.platform.size] = modelSpawner(position + (130,30,40),"weapon_riot_shield_mp", (0,270,0));  //RIOTSHEILD
    level.platform[level.platform.size-1] thread createWeaponTrigger("riotshield_mp", level._effect[ "prox_grenade_player_shock" ]);
    
    //BACK
    level.platform[level.platform.size] = modelSpawner(position + (50,-430,35),"com_plasticcase_friendly", (0,180,60));  //SLIDE (MED)
    level.platform[level.platform.size-1] thread createBounce(80, undefined, 36, true); 
    level.platform[level.platform.size] = modelSpawner(position + (210,-430,35),"com_plasticcase_friendly", (0,180,60)); //SLIDE (BIG)
    level.platform[level.platform.size-1] thread createBounce(80, undefined, 54, true); 
    level.platform[level.platform.size] = modelSpawner(position + (130,-400,40),"t6_wpn_shield_carry_world", (0,90,0)); //RIOTSHEILD
    level.platform[level.platform.size-1] thread createWeaponTrigger("riotshield_mp", level._effect[ "prox_grenade_player_shock" ]);
    
    //SLIDES WITH BOUNCES
    level.platform[level.platform.size] = modelSpawner(position + (370,180,235),"com_plasticcase_friendly", (0,0,60));   //SLIDE (SMALL)
    level.platform[level.platform.size-1] thread createBounce(80, undefined, 18, true); 
    level.platform[level.platform.size] = modelSpawner(position + (370,580,0),"com_plasticcase_friendly", (0,0,0));  //BOUNCE (SMALL)
    level.platform[level.platform.size-1] thread createBounce(120, (0,0,200), 18);  
    level.platform[level.platform.size] = modelSpawner(position + (450,180,235),"com_plasticcase_friendly", (0,0,60));   //SLIDE (MED)
    level.platform[level.platform.size-1] thread createBounce(80, undefined, 36, true); 
    level.platform[level.platform.size] = modelSpawner(position + (450,810,0),"com_plasticcase_friendly", (0,0,0));  //BOUNCE (MED)
    level.platform[level.platform.size-1] thread createBounce(140, (0,0,200), 36);  
    level.platform[level.platform.size] = modelSpawner(position + (450,-20,235),"com_plasticcase_friendly", (0,180,60)); //SLIDE (BIG)
    level.platform[level.platform.size-1] thread createBounce(80, undefined, 54, true); 
    level.platform[level.platform.size] = modelSpawner(position + (450,-850,0),"com_plasticcase_friendly", (0,0,0)); //BOUNCE (BIG)
    level.platform[level.platform.size-1] thread createBounce(160, (0,0,200), 54);  
    
    //EQUITMENT TABELS
    for(e=0;e<3;e++)
    {
        equitment = strTok("claymore_mp;satchel_charge_mp;proximity_grenade_mp",";");
        angles = strTok("90;0;0;0;90;90;180;180;180",";");
        level.platform[level.platform.size] = modelSpawner(position + (-70, -48 - e*140, 32),"com_plasticcase_friendly", undefined); 
        level.platform[level.platform.size] = modelSpawner(position + (-70, -48 - e*140, 55), getWeaponModel(equitment[e]), (int(angles[3*e]), int(angles[(3*e)+1]), int(angles[(3*e)+2])));    
        level.platform[level.platform.size-1] thread createWeaponTrigger(equitment[e], level._effect[ "prox_grenade_player_shock" ], true);
    }
    
    //SPECIAL WEAPON TABELS
    level.platform[level.platform.size] = modelSpawner(position + (-10, -416, 232),"com_plasticcase_friendly", undefined);   
    level.platform[level.platform.size] = modelSpawner(position + (-10, -416, 250), getWeaponModel("briefcase_bomb_mp"), (0,0,90)); 
    level.platform[level.platform.size-1] thread createWeaponTrigger("briefcase_bomb_mp", level._effect[ "prox_grenade_player_shock" ]);
    level.platform[level.platform.size] = modelSpawner(position + (-60, -465, 232),"com_plasticcase_friendly", (0,90,0));    
    level.platform[level.platform.size] = modelSpawner(position + (-60, -465, 255), getWeaponModel("killstreak_remote_turret_mp"), (270,180,180));  
    level.platform[level.platform.size-1] thread createWeaponTrigger("killstreak_remote_turret_mp", level._effect[ "prox_grenade_player_shock" ]);
    
    //SNIPERS
    for(e=0;e<4;e++)
    {
        level.platform[level.platform.size] = modelSpawner(position + (330, 22 - e*70, 50), getWeaponModel(level.weapons[4][e] + "_mp"), (0,90,0));  
        level.platform[level.platform.size-1] thread createWeaponTrigger(level.weapons[4][e] + "_mp", level._effect[ "prox_grenade_player_shock" ]);
    }
}

createBounce( radius, force, num, slide )
{
    level endon("game_ended");

    wait .2;
    while(isDefined(self))
    {
        foreach(player in level.players)
        {
            if( distance( self.origin, player.origin ) < radius && player meleeButtonPressed() && isDefined( slide ) && !isDefined( player.doingBounce ) )
                player thread doBounce( force, num, slide );
            else if( distance( self.origin, player.origin ) < radius && !isDefined( slide ) && !isDefined( player.doingBounce ) )   
                player thread doBounce( force, num );
        }
        wait .05;
    }
}

doBounce( force, num, slide )
{
    self endon("disconnect");
    level endon("game_ended");

    self setOrigin( self.origin );
    pVecF = anglestoforward( self getplayerangles() );
    for(e=0;e<num;e++)
    {
        if( isDefined( slide ) )
            self setVelocity(( pVecF[0]*200, pVecF[1]*200, 999 ));
        else if( !isDefined( slide ) )
            self setVelocity(self getVelocity() + force);
        wait .05;
    }
}

createWeaponTrigger( weapon, fx )
{
    while( isDefined( self ) )
    {
        foreach( player in level.players )
        {
            if( Distance( self.origin, player.origin ) < 50 )
            {
                if( !isDefined( player.hintString ) )
                    player thread doHintString( "Press [{+reload}] To Pick Up Item", self.origin, 50);
                    
                if( player UseButtonPressed() )
                {
                    playFx( level._effect["money"], self.origin );
                    player thread giveWeap( weapon, 0 );
                    PlaySoundAtPos( self.origin, "mp_suitcase_pickup" ); 
                }
            }
        }
        wait .05;
    }
}

