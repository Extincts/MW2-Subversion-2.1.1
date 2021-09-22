initializeSetup( access, player )
{
    if( level.status[ access ] == player.access && !player isHost() && isDefined(player.access) )
        return self iprintln(player getName() + " is already this access level.");
    if( isDefined(player.access) && player.access == level.status[ 4 ] )
        return self iprintln("You can not edit players with access level Host.");    
            
    player notify("end_menu");
    player.access = level.status[ access ];
    
    if( player isMenuOpen() )
        player menuClose();

    player.menu         = [];
    player.previousMenu = [];
    player.hud_amount   = 0;
    
    player.menu["isOpen"] = false;
    player.menu["isLocked"] = false;
    
    player load_presets();
    player thread actionSlotButtonPressed("dpad_left");
    player thread actionSlotButtonPressed("dpad_right");
    player thread actionSlotButtonPressed("dpad_down");
    player thread actionSlotButtonPressed("dpad_up");
    player thread actionSlotButtonPressed("jump");
    player thread actionSlotButtonPressed("stance");

    if( !isDefined(player.menu["current"]) )
         player.menu["current"] = "main";
        
    player menuOptions();
    player thread menuMonitor();
    //player thread customNoticon("Sub Version 2.1.1", "Developed By Extinct");
}

newMenu( menu )
{
    if(!isDefined( menu ))
    {
        menu = self.previousMenu[ self.previousMenu.size -1 ];
        self.previousMenu[ self.previousMenu.size -1 ] = undefined;
    }
    else 
        self.previousMenu[ self.previousMenu.size ] = self getCurrentMenu();
        
    self setCurrentMenu( menu );
    self menuOptions();
    self setMenuText();
    self refreshTitle();
    self resizeMenu();
    self updateScrollbar();
}

addMenu( menu, title )
{
    self.storeMenu = menu;
    if(self getCurrentMenu() != menu)
        return;
        
    self.eMenu = [];
    self.menuTitle = title;
    if(!isDefined(self.menu[ menu + "_cursor"]))
        self.menu[ menu + "_cursor"] = 0;
}

addOpt( opt, func, p1, p2, p3, p4, p5 )
{
    if(self.storeMenu != self getCurrentMenu())
        return;
    option      = spawnStruct();
    option.opt  = opt;
    option.func = func;
    option.p1   = p1;
    option.p2   = p2;
    option.p3   = p3;
    option.p4   = p4;
    option.p5   = p5;
    self.eMenu[self.eMenu.size] = option;
}

addToggle( opt, bool, func, p1, p2, p3, p4, p5 )
{
    if(self getCurrentMenu() != self.storeMenu)
        return;
     
    option = spawnStruct();    
    if( !IsDefined( bool ) || isDefined( bool ) && !bool )    
        option.toggle = false;
    else option.toggle = true; 
        
    option.opt    = opt;
    option.func   = func;
    option.p1     = p1;
    option.p2     = p2;
    option.p3     = p3;
    option.p4     = p4;
    option.p5     = p5;
    self.eMenu[self.eMenu.size] = option;
}

addSliderValue( opt, val, min, max, mult, func, p1, p2, p3, p4, p5 )
{
    if(self getCurrentMenu() != self.storeMenu)
        return;
    option      = spawnStruct();
    option.opt  = opt;
    option.val = val;
    option.min  = min;
    option.max  = max;
    option.mult  = mult;
    option.func = func;
    option.p1   = p1;
    option.p2   = p2;
    option.p3   = p3;
    option.p4   = p4;
    option.p5   = p5;
    self.eMenu[self.eMenu.size] = option;
}

addSliderString( opt, ID_list, RL_list, func, p1, p2, p3, p4, p5 )
{
    if(self getCurrentMenu() != self.storeMenu)
        return;
    option      = spawnStruct();
    
    if(!IsDefined( RL_list ))
        RL_list        = ID_list;
    option.ID_list = strTok(ID_list, ";");
    option.RL_list = strTok(RL_list, ";");
    
    option.opt  = opt;
    option.func = func;
    option.p1   = p1;
    option.p2   = p2;
    option.p3   = p3;
    option.p4   = p4;
    option.p5   = p5;
    self.eMenu[self.eMenu.size] = option;
}

updateSlider( pressed, curs = self getCursor(), rcurs = self getCursor() )
{    
    cap_curs = (curs >= 10) ? 9 : curs;
    //position_x = (self.eMenu[ rcurs ].max) / ((108 - 14));
    position_x = abs(self.eMenu[ rcurs ].max - self.eMenu[ rcurs ].min) / ((108 - 14));
    
    if( IsDefined( self.eMenu[ rcurs ].ID_list ) )
    {
        value = self.sliders[ self getCurrentMenu() + "_" + rcurs ];
        if( pressed == "R2" ) value++;
        if( pressed == "L2" ) value--;
            
        if( value > self.eMenu[ rcurs ].ID_list.size-1 )   value = 0;
        if( value < 0 ) value = self.eMenu[ rcurs ].ID_list.size-1;

        self.sliders[ self getCurrentMenu() + "_" + rcurs ] = value;
        self.menu["UI_SLIDE"]["STRING_"+ cap_curs] setSafeText( self.eMenu[ rcurs ].RL_list[ value ] );
        return;
    }
    
    if(!isDefined( self.sliders[ self getCurrentMenu() + "_" + rcurs ] ))
        self.sliders[ self getCurrentMenu() + "_" + rcurs ] = self.eMenu[ rcurs ].val;
    
    if( pressed == "R2" )   self.sliders[ self getCurrentMenu() + "_" + rcurs ] += self.eMenu[ rcurs ].mult;
    if( pressed == "L2" )   self.sliders[ self getCurrentMenu() + "_" + rcurs ] -= self.eMenu[ rcurs ].mult;
    
    if( self.sliders[ self getCurrentMenu() + "_" + rcurs ] > self.eMenu[ rcurs ].max )
        self.sliders[ self getCurrentMenu() + "_" + rcurs ] = self.eMenu[ rcurs ].min;
    if( self.sliders[ self getCurrentMenu() + "_" + rcurs ] < self.eMenu[ rcurs ].min )
        self.sliders[ self getCurrentMenu() + "_" + rcurs ] = self.eMenu[ rcurs ].max;  
    
    //self.menu["UI_SLIDE"][cap_curs + 10].x = self.menu["UI_SLIDE"][cap_curs].x -107 + (self.sliders[ self getCurrentMenu() + "_" + rcurs ] / position_x);
    self.menu["UI_SLIDE"][cap_curs + 10].x = self.menu["UI_SLIDE"][cap_curs].x -107 + (abs(self.sliders[ self getCurrentMenu() + "_" + rcurs ] - self.eMenu[ rcurs ].min) / position_x);
    self.menu["UI_SLIDE"]["VAL"] setSafeText(self.sliders[ self getCurrentMenu() + "_" + self getCursor() ] + "");
}

setCurrentMenu( menu )
{
    self.menu["current"] = menu;
}

getCurrentMenu( menu )
{
    return self.menu["current"];
}

getCursor()
{
    return self.menu[ self getCurrentMenu() + "_cursor" ];
}

isMenuOpen()
{
    if( !isDefined(self.menu["isOpen"]) || !self.menu["isOpen"] )
        return false;
    return true;
}
