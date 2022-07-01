#include common_scripts\utility; 
#include maps\_utility;

main()
{	
	// standMoveF\0\standMoveR\0\standMoveU\0\standRotP\2\standRotY\0\standRotR\-2

	SetDvar("walking_holster",0);
	players = GetPlayers();
	array_thread(players,::walk);
	array_thread(players,::gun_rotation);
	array_thread(players,::prone_check);
}

walk()	
{
	self.is_sliding = false;			// blst

	self setClientDvars("bg_bobAmplitudeStanding", "0.012 0.005");
	self setClientDvars("cg_bobWeaponMax", "3");

	//Fine-tuned for NDU: Reloaded
	while(1)
	{
		if( self ADSButtonPressed())
			self setClientDvar("cg_bobweaponamplitude", "0.9");		//was 0.16
		else
			self setClientDvar("cg_bobweaponamplitude", "0.45");	//was 0.9
	wait .05;
	}
}

gun_rotation()
{
	for(;;)
	{
		roll = self GetVelocity() * anglestoright(self GetPlayerAngles());
		roll = roll/28;
		if(!self.is_sliding)
		{
			if(GetDvarInt("walking_holster") == 1)
				self setClientDvar("cg_gun_rot_r",roll[0]+roll[1]+roll[2]);
			else
				self setClientDvar("cg_gun_rot_r",roll[0]+roll[1]+roll[2]);
		}
		wait(0.05);
	}
}

prone_check()
{
	while(1)
	{
		if( self GetStance() == "prone" || self GetStance() == "crouch" )
		{
			self setClientDvar("cg_gun_move_minspeed", 0);
			self setClientDvar("bg_bobAmplitudeProne","1");
		}
		else
		{
			self setClientDvar("cg_gun_move_minspeed", 100000);
			self setClientDvar("bg_bobAmplitudeProne","0");
		}
	wait .1;
	}
}