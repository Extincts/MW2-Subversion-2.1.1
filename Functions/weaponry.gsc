giveWeap( result, camo, dual, ignore )
{
    if( isDefined( camo ) ) 
        self.savedCamo = camo;
    
    camos = randomInt(13);    
    if( isDefined( self.savedCamo ) )
        camos = self.savedCamo;
     
    if( !isDefined( result ) )
        result = self GetCurrentWeapon();
        
    if( self hasWeapon( result ) && !isdefined( ignore ) )
        return self switchToWeapon( result );
        
    if( self getWeaponsListPrimaries().size >= 2 && !isDefined( self.dropWeap ) )
        self takeWeapon( self getCurrentWeapon() );
       
    self giveWeapon( result, camos, isInArray( getWeaponAttachments( result ), "akimbo" ) );
    result = findWeaponArray( result );
    
    if( isDefined( self.dropWeap ) ) 
        return self dropItem( result );    
        
    if( isDefined( self.instantWeap ) || IsDefined( camo ) )
        return self setSpawnWeapon( result );
    self switchToWeapon( result );
}

/*
 
 ***    START OF WEAPON ATTACHMENTS    ***   
    
*/

giveAttachment( attachment )
{
    weap = self getCurrentWeapon();
    base = getWeapBaseName( weap );
    
    attachments = getWeaponAttachments( weap );
    
    if( attachments.size >= 2 )
        return self iprintln("^1Error^7: You have exceeded the maximum number of attachments.");
    else if( attachments.size == 1 )
        weapon = self buildWeaponName( base, attachments[0], attachment );
    else 
        weapon = self buildWeaponName( base, attachment, "none" );
    
    if( weapon == base + "_mp" )
        return self iprintln("^1Error^7: Weapon attachment is not supported.");
        
    camo = 0; 
    if( isDefined( self.savedCamo ) )
        camo = self.savedCamo;
        
    stock = self getWeaponAmmoStock( weap );
    clip  = self getWeaponAmmoClip( weap );
    self takeWeapon( weap );
    
    self giveWeap( weapon, camo, isInArray( getWeaponAttachments( weapon ), "akimbo" ) );
    self setWeaponAmmoStock( weapon, stock );
    self setWeaponAmmoClip( weapon, clip );
    
    if( isDefined( self.instantWeap ) )
        return self setSpawnWeapon( weapon );
    self switchToWeapon( weapon );    
}

weaponHasAttachment( weap, attachment )
{
    if( IsSubStr( weap, attachment ) )
        return true;
    return false;    
}

getWeapBaseName( weap )
{
    for(e=0;e<level.weapons.size;e++)
    {
        foreach( weapon in level.weapons[e] )
        {
            if( IsSubStr( weap, weapon ) )
                return weapon;
        }
    }
}
    
/*

 ***    END OF WEAPON ATTACHMENTS    ***   
    
*/

findWeaponArray( weapon )
{
    for(e=0;e<self getWeaponsListPrimaries().size;e++)
    {
        if( IsSubStr( self getWeaponsListPrimaries()[e], getWeapBaseName( weapon ) ))
            return self getWeaponsListPrimaries()[e];
    }
    return self getWeaponsListPrimaries()[ self getWeaponsListPrimaries().size -1 ];
} 

weapMax()
{
    self giveMaxAmmo( self getCurrentWeapon() );
}

instantGiveWeapon()
{
    if(!isDefined(self.instantWeap))
        self.instantWeap = true;
    else 
        self.instantWeap = undefined;
}

dropWeapons()
{
    if(!isDefined(self.dropWeap))
        self.dropWeap = true;
    else 
        self.dropWeap = undefined;
}
    
dropCur()
{
    if(self getWeaponsListPrimaries().size != 0)
        self dropItem(self getCurrentWeapon());
    self setSpawnWeapon( self getWeaponsListPrimaries()[ self getWeaponsListPrimaries().size-1 ] );       
}

allWeap( action )
{
    while(self getWeaponsListPrimaries().size != 0)
    {
        if(self getCurrentWeapon() != "none")
        {
            if(action == "take")
                self takeWeapon(self getCurrentWeapon());
            if(action == "drop")
                self dropItem(self getCurrentWeapon());
            self setSpawnWeapon( self getWeaponsListPrimaries()[ self getWeaponsListPrimaries().size-1 ] );    
        }
        wait .05;
    }
}

do_modded_bullets( bullet )
{
    self endon( "disconnect" );
    self notify( "stop_bullets" );
    self endon( "stop_bullets" );
    
    if(!isDefined( self.current_bullet ))
        self.current_bullet = "none";
     
    if( !isDefined( self.modded_bullets ) || self.current_bullet != bullet )
    {
        self.modded_bullets = true;
        self.current_bullet = bullet;   
    
        while(isDefined(self.modded_bullets))
        {
            self waittill("weapon_fired");
            MagicBullet(self.current_bullet, self getEye(), self traceBullet(), self); 
        }
    }
    else 
    {
        self.modded_bullets = undefined;
        self.current_bullet = "none";
        self notify( "stop_bullets" );
    }
}

traceBullet( distance )
{
    if(!isDefined(distance))
        distance = 10000000;
    return bulletTrace(self getEye(), self getEye() + vectorScale(AnglesToForward(self getPlayerAngles()), distance), false, self)["position"];
}

resetweap()
{
    IPrintLn( getWeapBaseName( self GetCurrentWeapon() ) );
    self giveWeap( getWeapBaseName( self GetCurrentWeapon() ) + "_mp" );
}

/*
    0  - Model
    1  - Speed 
    2  - FX 
    3  - Timeout
    4  - Trail FX
    5  - Trail Time
    6  - Fire Sound 
    7  - Impact Sound 
    8  - EQ Scale 
    9  - EQ Time
    10 - EQ Radius 
    11 - RD Range 
    12 - RD Max 
    13 - RD Min 
    14 - RD Mod 
    15 - RD Weap 
    16 - Rumble
*/

do_custom_bullet()
{
    if(!IsDefined( self.custom_bullet ))
    {
        self endon( "stop_cbullets" );
        self.custom_bullet = true;
        while(isDefined( self.custom_bullet ))
        {
            self waittill( "weapon_fired" );
            
            if( self.define_customs.size < 14 )
            {
                self IPrintLn( "Error: Define All Aspects Of The Custom Bullets." );
                continue;
            }
            
            custom = self.define_customs;
            self thread spawnBullet( 
            undefined, 
            self getMuzzlePos() + AnglesToForward(self getPlayerAngles())*75,
            custom[0],
            int( custom[1] * 1000 ),
            custom[2],
            stringToFloat( custom[3] + "" ),
            custom[4],
            custom[5],
            custom[6],
            custom[7],
            int( custom[8] ),
            int( custom[9] ),
            int( custom[10] ),
            int( custom[11] ),
            int( custom[12] ),
            int( custom[13] ),
            custom[14],
            custom[15],
            "sniper_fire" );
        }
    }
    else 
    {
        self notify( "stop_cbullets" );
        self.custom_bullet = undefined;
    }
}

spawnBullet( location, spawnPos, model, speed, FX, timeout, trailFX, trailTime, fireSound, impactSound, eqScale, eqTime, eqRadius, rdRange, rdMax, rdMin, rdMod, rdWeap, rumble )
{
    if(isDefined(location))
        endPos = location;
    else
        endPos = bulletTrace(spawnPos, spawnPos + vectorScale(anglesToForward(self getPlayerAngles()), 1000000), true, self)["position"];
        
    bullet = modelSpawner(spawnPos, model);
    bullet.killcament = bullet;    
    bullet.angles = vectorToAngles(endPos - spawnPos);
    if(isDefined(fireSound))
        bullet playSound(fireSound);
    duration = calcDistance(speed, bullet.origin, endPos);
    bullet moveTo(endPos, duration);
    if(isDefined(trailFX) && isDefined(trailTime))  
        bullet thread trailBullet(trailFX, trailTime);
    if(duration < timeout)
        wait duration;
    else
        wait timeout;
    if(isDefined(impactSound))
        bullet playSound(impactSound);
    if(isDefined(eqScale) && isDefined(eqTime) && isDefined(eqRadius))
        earthquake(eqScale, eqTime, bullet.origin, eqRadius);
    if(isDefined(FX))
    {
        fx = playFx( loadFX( FX ), bullet.origin + (0,0,1));
        TriggerFX( fx );
    }
    bullet radiusDamage(bullet.origin, rdRange, rdMax, rdMin, self);
    if(isDefined(rumble) && isDefined(rdRange))
        foreach(player in level.players)
            if(distance(player.origin, bullet.origin) < rdRange)
                player playRumbleOnEntity(rumble);
    bullet delete();
    wait .05;   
}

trailBullet( trailFX, trailTime )
{
    while(isDefined(self))
    {
        fx = playFxOnTag(LoadFX( trailFX ), self, "tag_origin");
        TriggerFX( fx );
        wait trailTime;
    }
}

define_customs( type, int )
{
    if(!IsDefined( self.define_customs ))
        self.define_customs = [];
    self.define_customs[ int ] = type;    
}

drop_all_weapons( keys, space_x = -40, space_y = 20 )
{ 
    o = self lookpos() - (space_x*2,0,0); x = 0; y = 0;
    wait .2;
    for(i = 0; i < keys.size; i++)
    {
        if(x>3)
        { y++; x = 0; }
        x++;
        item = spawn( "weapon_"+keys[i]+"_mp", o + (x * space_x, y * space_y, 150), 4 );
        item ItemWeaponSetAmmo( 999, 999, 999 );
        
        item thread delete_weapons_later( 30 );
        wait .5;
    }
} 

delete_weapons_later( time )
{
    wait time;
    wait(randomInt(5));
    self delete();
}
