#include common_scripts\utility; 
#include maps\_utility;
// http://prntscr.com/5p6sln
main()
{	
	// standMoveF\0\standMoveR\0\standMoveU\0\standRotP\2\standRotY\0\standRotR\-2

	SetDvar("walking_holster",0);
	players = GetPlayers();
	array_thread(players,::walk_main);
	array_thread(players,::rot_main);
	array_thread(players,::prone_checks);
}

walk_main()
{
	self.is_sliding = false;			// blst

	self SetClientDvars("bg_bobAmplitudeStanding", "0.012 0.005");
	self SetClientDvars("cg_bobWeaponMax", "3");

	while(1)
	{
		if( self ADSButtonPressed())
			self setClientDvar("cg_bobweaponamplitude", "0.16");	
		else
			self setClientDvar("cg_bobweaponamplitude", "0.9");
	wait .05;
	}
}

rot_main()
{
	for(;;)
	{
		roll = self GetVelocity() * anglestoright(self GetPlayerAngles());
		roll = roll/28;
		if(!self.is_sliding)
		{
			if(GetDvarInt("walking_holster") == 1)
				self SetClientDvar("cg_gun_rot_r",roll[0]+roll[1]+roll[2]);
			else
				self SetClientDvar("cg_gun_rot_r",roll[0]+roll[1]+roll[2]);
		}
		wait(0.05);
	}
}

prone_checks()
{
	while(1)
	{
		if( self GetStance() == "prone" || self GetStance() == "crouch" )
		{
			self SetClientDvar("cg_gun_move_minspeed", 0);
			self SetClientDvar("bg_bobAmplitudeProne","10");
		}
		else
		{
			self SetClientDvar("cg_gun_move_minspeed", 100000);
			self SetClientDvar("bg_bobAmplitudeProne","0");
		}
	wait .1;
	}
}