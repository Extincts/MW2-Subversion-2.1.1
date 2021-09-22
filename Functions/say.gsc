doQuickMessages( soundalias, saytext )
{
    if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay))
        return;
        
    self.spamdelay = true;
    self saveHeadIcon();
    
    //prefix = maps\mp\gametypes\_teams::getTeamVoicePrefix( self.team );
    prefix = "UK_";
    if(!IsDefined( self.say_all_team ))
    {
        self.headiconteam = "none";
        self.headicon = "talkingicon";

        self playSound( prefix+soundalias );
        self sayAll( saytext );
    }
    else 
    {
        if(self.sessionteam == "allies")
            self.headiconteam = "allies";
        else if(self.sessionteam == "axis")
            self.headiconteam = "axis";
        
        self.headicon = "talkingicon";

        self playSound( prefix+soundalias );
        self sayTeam( saytext );
        self pingPlayer();
    }
    wait 1.2;
    self.spamdelay = undefined;
    self restoreHeadIcon();
}

say_to_who()
{
    if(!IsDefined( self.say_all_team ))
        self.say_all_team = true;
    else 
        self.say_all_team = undefined;
}