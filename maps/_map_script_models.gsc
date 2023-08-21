#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

// Proof of concept, this will be turned into the button easter egg from bo3 nacht

main()
{
	// Make these returns instead of level vars at some point
	level.teddy_one_knifed = 0;
	level.teddy_two_knifed = 0;
	level.teddy_three_knifed = 0;
	ee_done = 0;

    teddy_one = spawn("script_model", (-55, -460, 15));
	teddy_one.angles = (0, 45, 0);
	teddy_one setmodel("zombie_teddybear");

    teddy_two = spawn("script_model", (-35, -260, 15));
	teddy_two.angles = (0, 45, 0);
	teddy_two setmodel("zombie_teddybear");

    teddy_three = spawn("script_model", (-15, -60, 15));
	teddy_three.angles = (0, 45, 0);
	teddy_three setmodel("zombie_teddybear");

	teddy_one setCanDamage(true);
	teddy_one PlayLoopSound("meteor_loop");
	thread handle_teddy_one_damage(teddy_one); // Start a new thread to handle the waittill for teddy_one

	teddy_two setCanDamage(true);
	teddy_two PlayLoopSound("meteor_loop");
	thread handle_teddy_two_damage(teddy_two); // Start a new thread to handle the waittill for teddy_two

	teddy_three setCanDamage(true);
	teddy_three PlayLoopSound("meteor_loop");
	thread handle_teddy_three_damage(teddy_three); // Start a new thread to handle the waittill for teddy_three
	
	players = GetPlayers();

	while (1) // Infinite loop to keep the script running
	{
		if ( ee_done == 0 && level.teddy_one_knifed == 1 && level.teddy_two_knifed == 1 && level.teddy_three_knifed == 1)
		{
			for (i = 0; i < players.size; i++)
			{
				players[i] thread maps\_sounds::samantha_says_ee_track_sound();
			}

			ee_done = 1; // Prevent the track being played more than once
		}

		wait 1; // Delay to prevent excessive looping
	}
}

handle_teddy_one_damage(teddy_one)
{
	teddy_one waittill("damage", damage, attacker, direction_vec, point, type);
	if(type == "MOD_MELEE")
	{
		teddy_one StopLoopSound();
		teddy_one PlaySound("meteor_affirm");
		level.teddy_one_knifed = 1;
		iprintln("you knifed teddy one");
	}
}


handle_teddy_two_damage(teddy_two)
{
	teddy_two waittill("damage", damage, attacker, direction_vec, point, type);
	if(type == "MOD_MELEE")
	{
		teddy_two StopLoopSound();
		teddy_two PlaySound("meteor_affirm");
		level.teddy_two_knifed = 1;
		iprintln("you knifed teddy two");
	}
}

handle_teddy_three_damage(teddy_three)
{
	teddy_three waittill("damage", damage, attacker, direction_vec, point, type);
	if(type == "MOD_MELEE")
	{
		teddy_three StopLoopSound();
		teddy_three PlaySound("meteor_affirm");
		level.teddy_three_knifed = 1;
		iprintln("you knifed teddy three");
	}
}


// Ignore below, can use elements of the code for the button ee

/*
#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;

main()
{
	level.explosive_barrels = 0;
	level.barrel_count = 0;
	level.shot_explosive_barrels = 0;
	level.keep_explosive_barrels = [];
    thread explosive_barrels();
}

explosive_barrels()
{

	flag_wait("all_players_connected");

		all_explosive_barrels = GetEntArray("script_model","classname");

		for(i = 0; i < all_explosive_barrels.size; i++)
		{
			if(all_explosive_barrels[i].model == "global_explosive_barrel_japanese")
			{
				level.barrel_count++;
				level.keep_explosive_barrels = array_insert(level.keep_explosive_barrels,all_explosive_barrels[i],level.keep_explosive_barrels.size);
			}
			wait 0.05;
		}
		
		iPrintLn("There are " + level.barrel_count + " explosive barrels in this map.");
		
		array_thread(level.keep_explosive_barrels, ::explosive_barrels_think);
}

explosive_barrels_think()
{

	players = GetPlayers();

    while (1)
    {
        
		self waittill ("damage");
		
		for (i = 0; i < level.keep_explosive_barrels.size; i++)
		{
			self endon ("death");

			if (level.keep_explosive_barrels[i] == self)
			{
				level.shot_explosive_barrels++; // Increment the shot explosive_barrels counter
				break;
			}
		}

		iPrintLn("Explosive barrels shot: " + level.shot_explosive_barrels); // Print the updated shot explosive_barrels count

		if (level.shot_explosive_barrels == level.barrel_count) // Check if all explosive_barrels are shot
		{
			iPrintLn("DONE"); // Print "DONE" when all explosive_barrels are shot

        	for (k = 0; k < players.size; k++) {
			    iPrintLn("Playing ee track...");
                players[k] thread maps\_sounds::explosive_barrels_ee_track_sound();
			}
		}

		wait 1;
	}
}
*/