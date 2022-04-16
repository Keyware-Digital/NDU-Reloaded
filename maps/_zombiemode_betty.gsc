#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;


/*---------------------------------------------------------------------------------

Paragalor's Custom Prototype Random Weapon Box Bouncing Betties :3
(Pretty darn epic if you ask me)

---------------------------------------------------------------------------------*/

bouncing_betty_watch()
{
	self endon("death");

	while(1)
	{
		self waittill("grenade_fire",betty,weapname);
		if(weapname == "mine_bouncing_betty")
		{
			betty.owner = self;
			betty thread betty_think();
			self thread betty_death_think();
		}
	}
}

betty_death_think()
{
	self waittill("death");

	if(isDefined(self.trigger))
	{
		self.trigger delete();
	}

	self delete();

}

bouncing_betty_setup( player )
{	
	self thread bouncing_betty_watch();
	
	player.has_betties = 1;
	
	current = self getCurrentWeapon();
	
	self TakeWeapon( current );

	self giveweapon("mine_bouncing_betty");
	self setactionslot(4,"weapon","mine_bouncing_betty");
	self setweaponammostock("mine_bouncing_betty",5);
	
	self GiveWeapon( current );
}

betty_think()
{
	wait(2);
	trigger = spawn("trigger_radius",self.origin,9,80,64);
	trigger waittill( "trigger" );
	trigger = trigger;
	self playsound("betty_activated");
	wait(.1);	
	fake_model = spawn("script_model",self.origin);
	fake_model setmodel(self.model);
	self hide();
	tag_origin = spawn("script_model",self.origin);
	tag_origin setmodel("tag_origin");
	tag_origin linkto(fake_model);
	playfxontag(level._effect["betty_trail"], tag_origin,"tag_origin");
	fake_model moveto (fake_model.origin + (0,0,32),.2);
	fake_model waittill("movedone");
	playfx(level._effect["betty_explode"], fake_model.origin);
	earthquake(1, .4, fake_model.origin, 512);

	//CHris_P - betties do no damage to the players
	zombs = getaispeciesarray("axis");
	for(i=0;i<zombs.size;i++)
	{
		//PI ESM: added a z check so that it doesn't kill zombies up or down one floor
		if(zombs[i].origin[2] < fake_model.origin[2] + 80 && zombs[i].origin[2] > fake_model.origin[2] - 80 && DistanceSquared(zombs[i].origin, fake_model.origin) < 200 * 200)
		{
			zombs[i] thread maps\_zombiemode_spawner::zombie_damage( "MOD_ZOMBIE_BETTY", "none", zombs[i].origin, self.owner );
		}
	}
	//radiusdamage(self.origin,128,1000,75,self.owner);

	trigger delete();
	fake_model delete();
	tag_origin delete();
	if( isdefined( self ) )
	{
		self delete();
	}
}

betty_smoke_trail()
{
	self.tag_origin = spawn("script_model",self.origin);
	self.tag_origin setmodel("tag_origin");
	playfxontag(level._effect["betty_trail"],self.tag_origin,"tag_origin");
	self.tag_origin moveto(self.tag_origin.origin + (0,0,100),.15);
}

give_betties_after_rounds()
{
	while(1)
	{
		level waittill( "between_round_over" );
		{
			players = get_players();
			for(i=0;i<players.size;i++)
			{
				if(isDefined(players[i].has_betties))
				{
					players[i]  giveweapon("mine_bouncing_betty");
					players[i]  setactionslot(4,"weapon","mine_bouncing_betty");
					players[i]  setweaponammoclip("mine_bouncing_betty",2);
				}
			}
		}
	}
}
