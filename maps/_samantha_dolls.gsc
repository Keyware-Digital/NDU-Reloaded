#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

// Proof of concept, this will be turned into the samantha dolls button easter egg from bo3 nacht
//Testing new way of spawning stuff in to improve cabinet share feature too

init_samantha_dolls()
{
	// Make these returns instead of level vars at some point
	level.teddy_one_interacted = 0;
	level.teddy_two_interacted = 0;
	level.teddy_three_interacted = 0;
	ee_done = 0;

    teddy_one = spawn("script_model", (-55, -460, 15));
	trigger_one = spawn("trigger_radius", (teddy_one.origin), 0, 64, 64);
	teddy_one.angles = (0, 45, 0);
	teddy_one Solid();
	teddy_one setmodel("zombie_teddybear");

    teddy_two = spawn("script_model", (-35, -260, 15));
	trigger_two = spawn("trigger_radius", (teddy_two.origin), 0, 64, 64);
	teddy_two.angles = (0, 45, 0);
	teddy_two Solid();
	teddy_two setmodel("zombie_teddybear");

    teddy_three = spawn("script_model", (-15, -60, 15));
	trigger_three = spawn("trigger_radius", (teddy_three.origin), 0, 64, 64);
	teddy_three.angles = (0, 45, 0);
	teddy_three Solid();
	teddy_three setmodel("zombie_teddybear");

	teddy_one PlayLoopSound("meteor_loop");
	thread handle_teddy_one_interaction(teddy_one, trigger_one); // Start a new thread to handle the waittill for teddy_one

	teddy_two PlayLoopSound("meteor_loop");
	thread handle_teddy_two_interaction(teddy_two, trigger_two); // Start a new thread to handle the waittill for teddy_two

	teddy_three PlayLoopSound("meteor_loop");
	thread handle_teddy_three_interaction(teddy_three, trigger_three); // Start a new thread to handle the waittill for teddy_three
	
	players = GetPlayers();

	while (1) // Infinite loop to keep the script running
	{
		if ( ee_done == 0 && level.teddy_one_interacted == 1 && level.teddy_two_interacted == 1 && level.teddy_three_interacted == 1)
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

handle_teddy_one_interaction(teddy_one, trigger_one)
{
	while(1)
	{
		players = GetPlayers();

		if(IsDefined(trigger_one))
		{
			for (i = 0; i < players.size; i++)
			{
				if(players[i] IsTouching(trigger_one))  ///////////////////////////////////////
				{																			   //
					level.teddy_one_text = NewHudElem();											   //	
					level.teddy_one_text.alignX = "center";										   //
					level.teddy_one_text.alignY = "middle";										   //
					level.teddy_one_text.horzAlign = "center";									   //
					level.teddy_one_text.vertAlign = "middle";									   //
					level.teddy_one_text.y = 70;
					level.teddy_one_text.font = "default";												   //
					level.teddy_one_text.fontScale = 1;
					level.teddy_one_text.alpha = 1;										       //
					level.teddy_one_text SetText("Press ^3F ^7to activate this Teddy"); //Temporary block of code to experiment with using hudelem text instead of hintstrings to prevent the hintstring limit bug
					level.teddy_one_text fadeOverTime(1.5);
					level.teddy_one_text.alpha = 0;
				}																			   		   //

				if(players[i] IsTouching (trigger_one) && players[i] UseButtonPressed())
				{	
					teddy_one StopLoopSound();
					teddy_one PlaySound("meteor_affirm");
					
					level.teddy_one_interacted = 1;

					trigger_one Delete();

					break;
				}
			}
		}
		wait 0.05;
	}
}


handle_teddy_two_interaction(teddy_two, trigger_two)
{
	while(1)
	{
		players = GetPlayers();

		if(IsDefined(trigger_two))
		{
			for (i = 0; i < players.size; i++)
			{
				if(players[i] IsTouching(trigger_two))  ///////////////////////////////////////
				{																			   //
					level.teddy_two_text = NewHudElem();											   //	
					level.teddy_two_text.alignX = "center";										   //
					level.teddy_two_text.alignY = "middle";										   //
					level.teddy_two_text.horzAlign = "center";									   //
					level.teddy_two_text.vertAlign = "middle";									   //
					level.teddy_two_text.y = 70;
					level.teddy_two_text.font = "default";												   //
					level.teddy_two_text.fontScale = 1;
					level.teddy_two_text.alpha = 1;										       //
					level.teddy_two_text SetText("Press ^3F ^7to activate this Teddy"); //Temporary block of code to experiment with using hudelem text instead of hintstrings to prevent the hintstring limit bug
					level.teddy_two_text fadeOverTime(1.5);
					level.teddy_two_text.alpha = 0;
				}																			   		   //

				if(players[i] IsTouching (trigger_two) && players[i] UseButtonPressed())
				{	
					teddy_two StopLoopSound();
					teddy_two PlaySound("meteor_affirm");
					
					level.teddy_two_interacted = 1;

					trigger_two Delete();

					break;
				}
			}
		}
		wait 0.05;
	}
}

handle_teddy_three_interaction(teddy_three, trigger_three)
{	
	while(1)
	{
		players = GetPlayers();

		if(IsDefined(trigger_three))
		{
			for (i = 0; i < players.size; i++)
			{
				if(players[i] IsTouching(trigger_three))  ///////////////////////////////////////
				{																			   //
					level.teddy_three_text = NewHudElem();											   //	
					level.teddy_three_text.alignX = "center";										   //
					level.teddy_three_text.alignY = "middle";										   //
					level.teddy_three_text.horzAlign = "center";									   //
					level.teddy_three_text.vertAlign = "middle";									   //
					level.teddy_three_text.y = 70;
					level.teddy_three_text.font = "default";												   //
					level.teddy_three_text.fontScale = 1;
					level.teddy_three_text.alpha = 1;										       //
					level.teddy_three_text SetText("Press ^3F ^7to activate this Teddy"); //Temporary block of code to experiment with using hudelem text instead of hintstrings to prevent the hintstring limit bug
					level.teddy_three_text fadeOverTime(1.5);
					level.teddy_three_text.alpha = 0;
				}																			   		   //

				if(players[i] IsTouching (trigger_three) && players[i] UseButtonPressed())
				{	
					teddy_three StopLoopSound();
					teddy_three PlaySound("meteor_affirm");
					
					level.teddy_three_interacted = 1;

					trigger_three Delete();

					break;
				}
			}
		}
		wait 0.05;
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