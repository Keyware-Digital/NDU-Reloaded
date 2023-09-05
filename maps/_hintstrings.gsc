//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||| Name     : trem_hintstrings.gsc
//|||| Info     : Fixes hintstrings that don't update.
//|||| Site     : www.ugx-mods.com
//|||| Author       : [UGX] treminaor
//|||| Notes        : v1.3
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  
#include maps\_utility;

// This is a workaround for the hintstring limit in theory but it doesn't accept &"PROTOTYPE_ZOMBIE_TEXT_HERE" localised strings or dynamic stuff like &&1, &&2 and &&3 so the game wouldn't know if your use key is F or E and you can only set text like "Press F to get weapon"
  
_setHintString(string) //#bestengine2014
{
    self thread setHintString_fixed_thread(string); //so that i don't have to write "thread" before all of my trig calls.
}
setHintString_fixed_thread(string)
{
    self notify("new_thread");
    self endon("new_thread");
    if(!isDefined(string)) return;
    tokens = strTok(string, " ");
    end = false;
    leftstring = "";
    rightstring = "";
    for(i=0;i<tokens.size;i++)
    {
        if(tokens[i] == "&&1" || tokens[i] == "F" || tokens[i] == "[{+activate}]" || tokens[i] == "[Use]") //use key will be added by the menufile
        {
            tokens[i] = "";
            end = true;
        }
        if(end) rightstring = rightstring + tokens[i] + " ";
        else leftstring = leftstring + tokens[i] + " ";
    }
    players = getPlayers();
    while(isDefined(self))
    {
        for(k=0;k<players.size;k++)
            if(players[k] islookingatent(self) && (distance(players[k].origin, self.origin) < 75) || players[k] isTouching(self))
            {
                players[k].leftstring = leftstring;
                players[k].rightstring = rightstring;
                players[k] thread setHintString_show(self, leftstring, rightstring);
            }
        wait 0.1;
    }
}
setHintString_show(trig, leftstring, rightstring)
{
    if(isDefined(self.lookingattrig) && self.lookingattrig == trig) return; //no need to keep calling the thread if we're still standing at the same trig
    while(isDefined(trig) && isDefined(self.leftstring) && self.leftstring == leftstring && isDefined(self.rightstring) && self.rightstring == rightstring && (self islookingatent(trig) && (distance(self.origin, trig.origin) < 75) || self isTouching(trig)))
    {
        self.lookingattrig = trig;
        self setClientDvar("trem_hintstring_left", string(leftstring));
        self setClientDvar("trem_hintstring_right", string(rightstring));
        self setClientDvar("trem_hintstring_vis", 1);
        wait 0.001;
    }
    self.lookingattrig = undefined;
    self setClientDvar("trem_hintstring_left", " ");
    self setClientDvar("trem_hintstring_right", " ");
    self setClientDvar("trem_hintstring_vis", 0);
}
isLookingAtEnt(ent)
{
    normalvec = vectorNormalize(ent.origin-self geteye());
    veccomp = vectorNormalize((ent.origin-(0,0,256))-self geteye());
    insidedot = vectordot(normalvec,veccomp);
  
    anglevec = anglestoforward(self getplayerangles());
    vectordot = vectordot(anglevec,normalvec);
    if(vectordot > insidedot)
        return true;
    return false;
}