/*returnWeaponName( weaponId )
{
    realName = "";
    realName = tableLookupIString("mp/statstable.csv", 0, int( tableLookup("mp/statstable.csv", 4, weaponId, 0) ), 3);
    return realName;
}*/

returnDisplayName( name, contains, altContains )
{
    if( isDefined(altContains) && !IsSubStr( name, contains ) )
        contains = altContains;
    if( IsSubStr( name, contains ))
    {
        for(e = name.size - 1; e >= 0; e--)
            if(name[e] == contains[contains.size-1])
                break;
        return(getSubStr(name, e + 1));        
    }
    return name;
}

replaceChar( string, substring, replace )
{
    final = "";
    for(e=0;e<string.size;e++)
    {
        if(string[e] == substring)
            final += replace;
        else 
            final += string[e];
    }
    return final;
}

constructString( string ) 
{
    final = "";
    for(e=0;e<string.size;e++)
    {
        if(e == 0)
            final += toUpper(string[e]);
        else if(string[e-1] == " ")
            final += toUpper(string[e]);
        else 
            final += string[e];
    }
    return final;
}

array_delete( ID )
{   
    foreach( item in ID )
        item delete();
}

freezeControlsAllowLook( bool )
{
    self setMoveSpeedScale( 0 );
    if( !bool )
        self setMoveSpeedScale( 1 );
}
    
returnboolean( var )
{
    if(isDefined(var))
        return true;
    return false;
}

vectorScale(vec, scale)
{
    return (vec[0] * scale, vec[1] * scale, vec[2] * scale);
}

removeDuplicatedModels( array )
{
    newArray = [];
    foreach( item in array )
    {
        if( !isInArray(newArray, item.model) && item.model != "" )
            newArray[ newArray.size ] = item.model;
    }
    return newArray;
}

delayedFall( val )
{
    if(isDefined(self)) 
        self PhysicsLaunchServer( self.origin, self.origin );
    wait val;
    if(isDefined(self)) 
        self delete();
}
    
deleteSpawn( time )
{
    wait time;
    if(isDefined(self)) 
        self delete();
}
    
calcDistance(speed,origin,moveTo)
{return (distance(origin, moveTo) / speed);}

getRandomThrowSpeed() 
{
    yaw = randomFloat( 360 );
    pitch = randomFloatRange( 65, 85 );
    amntz = sin( pitch );
    cospitch = cos( pitch );
    amntx = cos( yaw ) * cospitch;
    amnty = sin( yaw ) * cospitch;
    speed = randomFloatRange( 400, 600);
    velocity = (amntx, amnty, amntz) * speed;
    return velocity;
}

moveToOriginOverTime(origin,time,who,vec)
{
    self endon("killanimscript");
    offset = self.origin - origin;
    frames = int(time * 20);
    offsetreduction = vectorScale(offset,1.0 / frames);
    for(i = 0;i < frames;i++)
    {
        offset -= offsetreduction;
        if( isDefined( who ) )
            self.origin = ((who.origin + offset) + vec);
        else
            self.origin = ((origin + offset));
        wait .05;
    }
}

cutName( fxName )
{
    result = "";
    for(e=0;e<fxName.size;e++)
    {
        if( e > 17 )
            return result;
        result += fxName[e];
    }
    return result;
} 

editMovements(num)
{
    self allowsprint( num );
    self allowjump( num );
}

deleteMultipleArrays(a1, a2, a3, a4, a5, a6)
{
    if(isDefined(a1))
        array_delete(a1);
    if(isDefined(a2))
        array_delete(a2);
    if(isDefined(a3))
        array_delete(a3);
    if(isDefined(a4))
        array_delete(a4);
    if(isDefined(a5))
        array_delete(a5);
    if(isDefined(a6))
        array_delete(a6);
}

doHintString( message, dist, range )
{
    if(isDefined(self.hintString)) 
        self.hintString destroy();
    self.hintString = createText("objective", 1, "BOTTOM", "BOTTOM", 0, 0, 3, 1, message, (1, 1, 1));   
    
    if( !IsDefined( dist ) )
        dist = self.origin;
    while( IsDefined( self.hintString ) )
    {
        if( distance( dist, self.origin ) > range )
            self.hintString destroy();
        wait .05;
    }
}

randomSign()
{
    if(randomIntRange(-1000,1000) < 0)
        return -1;
    return 1;
}

lookpos() 
{ 
    v = anglesToForward(self getplayerangles());
    e = (v[0] * 99999, v[1] * 99999, v[2] * 99999);
    return bullettrace(self geteye(), e, false, self)["position"]; 
} 

base10_to_base16( value ) 
{
    base = [];
    base[0] = do_base10( value );
    while( true )
    {
        value = int( StrTok( base[base.size-1], "|" )[0] );
        if( value > 0 )
            base[base.size] = do_base10( value );
        else break;
    }
    
    while( base.size < 6 )
    {
        base[base.size] = "0|0";
        wait .05;
    }
    
    hexadecimal = [ "A", "B", "C", "D", "E", "F" ];
    
    final = "";
    for(e=base.size-1;e>-1;e--)
    {
        hex = StrTok( base[e], "|" );
        if( int( hex[1] ) > 9 )
            final += hexadecimal[ (int( hex[1] ) - 10) ]; 
        else 
            final += hex[1];
    }
        
    flipped = "";
    size    = final.size-1;
    for(e=0;e<size;e+=2)
        flipped += final[size - (e + 1)] + final[ size - e ];
    return toUpper( flipped ); 
}

do_base10( value ) 
{
    divide        = value / 16;
    divide_string = divide + "";
    
    r = "";
    for(e=0;e<divide_string.size;e++)
    {
        if( divide_string[e] == "." )
            break; 
        r += divide_string[e];
    }
    if( r == "" )
        r = 0;
        
    remainder = (divide - int( r )) * 16; 
    if( remainder < 0 )
        remainder *= -1; 
        
    return divide + "|" + remainder;
}

stringToFloat( stringVal )
{
    floatElements = strtok( stringVal, "." );
    
    floatVal = int( floatElements[0] );
    if ( isDefined( floatElements[1] ) )
    {
        modifier = 1;
        for ( i = 0; i < floatElements[1].size; i++ )
            modifier *= 0.1;
        
        floatVal += int ( floatElements[1] ) * modifier;
    }
    return floatVal;    
}

playSonicBoom( soundName, delay )
{
    self endon ("death");
    
    wait ( delay );
    
    PlaySoundAtPos( soundName, self.origin );
}

isEnemy( other )    // self == player
{
    if ( level.teamBased )
        return self isPlayerOnEnemyTeam( other );
    return self isPlayerFFAEnemy( other );
}

isPlayerOnEnemyTeam( other )    // self == player
{
    return ( other.team != self.team );
}

isPlayerFFAEnemy( other )   // self == player
{
    if ( IsDefined( other.owner ) ) 
        return ( other.owner != self );
    return ( other != self );
}

returnBestTarget( team ) 
{
    array = [];
    pos   = self.origin;
    foreach( player in level.players )
        if( isAlive(player) && team != player.team && bulletTracePassed(pos, player getTagOrigin("j_spine4"), false, self) )
            array[array.size] = player;
    return getClosest( pos, array );
}

getClosest(origin,array)
{
    if( !isDefined( array ) )
        return undefined;
        
    closestEnt = array[0];
    smallestDistance = distance(array[0].origin,origin);

    for(e=1;e<array.size;e++)
    {
        if(distance(array[e].origin,origin) < smallestDistance)
        {
            smallestDistance = distance(array[e].origin, origin);
            closestEnt       = array[e];
        }
    }
    return closestEnt;
}

modelSpawner(origin, model, angles, time, collision)
{
    if(isDefined(time))
        wait time;
    obj = spawn( "script_model", origin );
    obj setModel( model );
    if(isDefined( angles ))
        obj.angles = angles;
    if(isDefined( collision ))
        obj cloneBrushmodelToScriptmodel( collision );
    return obj;
}

fill_string( string, substring )
{
    if( string.size >= substring.size )
        return string;
    for(e=string.size-1;e<substring.size;e++)
        string += " ";
    return string;    
}

convert_strtok( string, delim )
{
    array  = [];
    final  = "";
    
    amount = 0;
    for(e=0;e<string.size;e++)
    {
        letter = string[e];
        if( letter == delim )
        {
            array[amount] = final;
            amount++;
            final = "";
        }
        else final += letter;
    }
    array[amount] = final;
    return array;
}

do_keyboard( title = "Keyboard" )
{ 
    keys = [];
    keys[0] = ["0", "A", "N", ":"];
    keys[1] = ["1", "B", "O", ";"];
    keys[2] = ["2", "C", "P", ">"];
    keys[3] = ["3", "D", "Q", "$"];
    keys[4] = ["4", "E", "R", "#"];
    keys[5] = ["5", "F", "S", "-"];
    keys[6] = ["6", "G", "T", "*"];
    keys[7] = ["7", "H", "U", "+"];
    keys[8] = ["8", "I", "V", "@"];
    keys[9] = ["9", "J", "W", "/"];
    keys[10] = ["^", "K", "X", "_"];
    keys[11] = ["!", "L", "Y", "["];
    keys[12] = ["?", "M", "Z", "]"];
    
    UI = [];
    for(i=0;i<13;i++)
    {
        row = "";
        for(e=0;e<4;e++)
            row += keys[i][e] + "\n";
        UI["keys_"+i] = createText( "objective", 1.2, "LEFT", "CENTER", -125 + (i*20), -30, 4, 1, row, (1,1,1) );
    }
    
    UI["TITLE"] = createText( "objective", 1.4, "TOP", "CENTER", 0, -82, 4, 1, toUpper( title ), (1,1,1) );
    UI["PREVIEW"] = createText( "objective", 1.2, "TOP", "CENTER", 0, -55, 4, 1, "", (1,1,1) );
    UI["INSRUCT_0"] = createText( "objective", .8, "TOP", "CENTER", 0, 30, 4, 1, "Capitals - [{+frag}] : Backspace - [{+melee}] : Confirm - [{+gostand}] : Cancel - [{+stance}]", (1,1,1) );
    UI["INSRUCT_1"] = createText( "objective", .8, "TOP", "CENTER", 0, 40, 4, 1, "Up - [{+actionslot 1}] : Down - [{+actionslot 2}] : Left - [{+actionslot 3}] : Right [{+actionslot 4}]", (1,1,1) );
    
    UI["BG"] = createRectangle( "TOP", "CENTER", 0, -90, 300, 120, (0,0,0), "white", 0, .7 );
    UI["RESULT"] = createRectangle( "TOP", "CENTER", 0, -59, 300, 20, (0,0,0), "white", 1, .7 );
    UI["CURSOR"] = createRectangle( "LEFT", "CENTER", UI["keys_0"].x - 1, UI["keys_0"].y, 12, 12, (1,0,0), "white", 2, .7 );
    
    result   = "";
    curs_x   = 0;
    curs_y   = 0;
    capitals = 0;
    
    while( true ) 
    {
        if( self.actionSlotsPressed[ "dpad_left" ] )
            curs_x = minus_keyboard_curs( curs_x, 0, 12 ); 
        else if( self.actionSlotsPressed[ "dpad_right" ] )
            curs_x = plus_keyboard_curs( curs_x, 0, 12 );
        else if( self.actionSlotsPressed[ "dpad_up" ] )
            curs_y = minus_keyboard_curs( curs_y, 0, 3 );
        else if( self.actionSlotsPressed[ "dpad_down" ] )
            curs_y = plus_keyboard_curs( curs_y, 0, 3 );
        else if( self.actionSlotsPressed[ "jump" ] )
            break; 
        else if( self.actionSlotsPressed[ "stance" ] )
            return self destroyAll( UI );
            
        if( self UseButtonPressed() )
        {
            result += (capitals ? toUpper( keys[curs_x][curs_y] ) : keys[curs_x][curs_y] );
            wait .2;
        }
        else if( self MeleeButtonPressed() && result.size > 0 )
        {
            temp = "";
            for(e=0;e<result.size-1;e++)
                temp += result[e];
            result = temp;
            wait .2;
        }
        else if( self FragButtonPressed() ) 
        {
            capitals = capitals ? 0 : 1;
            for(i=0;i<13;i++)
            {
                row = "";
                for(e=0;e<4;e++)
                    row += (capitals ? toUpper( keys[i][e] ) : keys[i][e] ) + "\n";
                UI["keys_"+i] setSafeText( row );
            }
            wait .2;
        }
        
        UI["CURSOR"].x = UI["keys_0"].x + (curs_x * 20) - 1;
        UI["CURSOR"].y = UI["keys_0"].y + (curs_y * 15);
        UI["PREVIEW"] setSafeText( result );
        wait .05;
    }
    self destroyAll( UI );
    return result;
}  

plus_keyboard_curs( curs, min, max ) //12 - 3
{
    curs++;
    if( curs > max )
        curs = min;
    wait .2; 
    return curs;
}

minus_keyboard_curs( curs, max, min ) //12 - 0
{
    curs--;
    if( curs < max )
        curs = min;
    wait .2; 
    return curs;    
}

CYCL( text, colour = "^7" )
{
    self endon("stop_cycl");
    
    while( IsDefined( self ) )
    {
        old = colour;
        while(colour == old)
            colour = "^" + randomIntRange(1,7);
        for(e=0;e<text.size;e++)
        {    
            string = colour + "";
            for(x=0;x<text.size;x++)
            {
                if( e == x )    
                    string += text[x] + old;
                else 
                    string += text[x];    
            }
            self.edited_string = string;
            wait .1;
        }
    }
}

KRDR( text, colour = "^" + randomIntRange(0,7) )
{
    self endon("stop_kdrd");
    
    dir = 1;
    while( IsDefined( self ) )
    {
        dir    = dir ? 0 : 1;
        for(e=0;e<text.size;e++)
        {
            string = "";
            for(x=0;x<text.size;x++)
            {
                if( dir == 1 && e == x || dir == 0 && ((text.size - 1) - e) == x )
                    string += colour + text[x] + "^7";
                else 
                    string += text[x];
            }
            self.edited_string = string;
            wait .1;
        }
    }    
}

RAIN( text )
{
    self endon("stop_rain");
    
    while( IsDefined( self ) )
    {
        string = "";
        for(e=0;e<text.size;e++)
            string += "^" + randomIntRange(0,7) + text[e];    
        self.edited_string = string;   
        wait .1;
    }
}

getTarget( current, mostRecent ) 
{ 
    if(!self can_hit_enemy( current ) )
        return undefined;
    if(!isDefined(mostRecent))
        return current;
    if(closer(self getTagOrigin("j_head"), current getTagOrigin("j_head"), mostRecent getTagOrigin("j_head"))) 
        return current;
    return mostRecent;
} 

angleNormalize360(angle)
{
    v3     = floor((angle * 0.0027777778));
    result = ((angle * 0.0027777778) - v3) * 360.0;
    if ( (result - 360.0) < 0.0 )
        v2 = ((angle * 0.0027777778) - v3) * 360.0;
    else
        v2 = result - 360.0;
    return v2;
}

angleNormalize180(angle)
{
    angle = angleNormalize360(angle);
    if(angle > 180)
        angle -= 360; 
    return angle;
}

/*returnWeaponName( weapon )
{
    result = "";
    for(e=0;e<weapon.size;e++)
    {
        if( weapon[e] == "_" )
            return toUpper( result );
        result += weapon[e];
    }
}*/

isMeleeing()
{
    size = readInt( 0x01B087C4 + (self GetEntityNumber() * 0x52C) );
    if( size > 0 && IsSubStr( readString( size ), "melee" ))
        return true;
    return false;
}

array_randomize( array )
{
    for ( i = 0; i < array.size; i++ )
    {
        j = RandomInt( array.size );
        temp = array[ i ];
        array[ i ] = array[ j ];
        array[ j ] = temp;
    }
    return array;
}
