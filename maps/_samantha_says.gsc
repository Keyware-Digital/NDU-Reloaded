#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

// Proof of concept, this will be turned into the samantha dolls button easter egg from bo3 nacht
//Testing new way of spawning stuff in to improve cabinet share feature too

init_samantha_says()
{
	// Make these returns instead of level vars at some point
	level.first_room_stairs_button_interacted = 0; 
	level.first_room_power_section_button_interacted = 0;
	level.help_room_button_interacted = 0;
	level.cabinet_room_button_interacted = 0;
	ee_done = 0;

    first_room_stairs_button = spawn("script_model", (200, 0, 267));
	button_trigger_one = spawn("trigger_radius", (first_room_stairs_button.origin - (0, 0, 50)), 0, 64, 64);
	first_room_stairs_button.angles = (0, 0, 90);
	first_room_stairs_button Solid();
	first_room_stairs_button setmodel("zmb_mdl_button");

    first_room_power_section_button = spawn("script_model", (-113, -869, 113));
	button_trigger_two = spawn("trigger_radius", (first_room_power_section_button.origin - (0, 0, 3)), 0, 64, 64);
	first_room_power_section_button.angles = (0, -90, 0);
	first_room_power_section_button Solid();
	first_room_power_section_button setmodel("zmb_mdl_button");

    help_room_button = spawn("script_model", (260, 1113, 20));
	button_trigger_three = spawn("trigger_radius", (help_room_button.origin), 0, 64, 64);
	help_room_button.angles = (90, 0, 0);
	help_room_button Solid();
	help_room_button setmodel("zmb_mdl_button");

    cabinet_room_button = spawn("script_model", (830, 630, 210));
	button_trigger_four = spawn("trigger_radius", (cabinet_room_button.origin), 0, 64, 64);
	cabinet_room_button.angles = (0, 0, 180);
	cabinet_room_button Solid();
	cabinet_room_button setmodel("zmb_mdl_button");

	thread handle_first_room_stairs_button(first_room_stairs_button, button_trigger_two);

	thread handle_first_room_power_section_button(first_room_power_section_button, button_trigger_one);

	thread handle_help_room_button(help_room_button, button_trigger_three);
	
	thread handle_cabinet_room_button(cabinet_room_button, button_trigger_four);

	players = GetPlayers();

	while (1) // Infinite loop to keep the script running
	{
		if (ee_done == 0 && level.first_room_power_section_button_interacted == 1 && level.first_room_stairs_button_interacted == 1 && level.help_room_button_interacted == 1 && level.cabinet_room_button_interacted == 1)
		{
			iprintln("samantha figure step soon, spawning initial samantha figure...");

			samantha_figure_one = spawn("script_model", (-15, 0, 15));
			samantha_figure_trigger_one = spawn("trigger_radius", (samantha_figure_one.origin), 0, 64, 64);
			samantha_figure_one.angles = (0, 45, 0);
			samantha_figure_one Solid();
			samantha_figure_one setmodel("zmb_mdl_samantha_figure");
			/*for (i = 0; i < players.size; i++)
			{
				players[i] thread maps\_sounds::samantha_says_ee_track_sound();
			}*/

			ee_done = 1; // Prevent the track being played more than once
		}

		wait 1; // Delay to prevent excessive looping
	}
}

handle_first_room_stairs_button(first_room_stairs_button, button_trigger_one)
{
	while(1)
	{
		players = GetPlayers();

		if(IsDefined(button_trigger_one))
		{
			for (i = 0; i < players.size; i++)
			{																			   		   
				if(players[i] IsTouching (button_trigger_one) && players[i] UseButtonPressed())
				{		
					first_room_stairs_button thread maps\_sounds::button_press_sound();

					iprintln("button pressed...");
					level.first_room_stairs_button_interacted = 1;

					button_trigger_one Delete();

					break;
				}
			}
		}
		wait 0.05;
	}
}

handle_first_room_power_section_button(first_room_power_section_button, button_trigger_two)
{
	while(1)
	{
		players = GetPlayers();

		if(IsDefined(button_trigger_two))
		{
			for (i = 0; i < players.size; i++)
			{																			   		   
				if(players[i] IsTouching (button_trigger_two) && players[i] UseButtonPressed())
				{		
					first_room_power_section_button thread maps\_sounds::button_press_sound();

					iprintln("button pressed...");
					level.first_room_power_section_button_interacted = 1;

					button_trigger_two Delete();

					break;
				}
			}
		}
		wait 0.05;
	}
}

handle_help_room_button(help_room_button, button_trigger_three)
{
	while(1)
	{
		players = GetPlayers();

		if(IsDefined(button_trigger_three))
		{
			for (i = 0; i < players.size; i++)
			{																			   		   
				if(players[i] IsTouching (button_trigger_three) && players[i] UseButtonPressed())
				{		
					help_room_button thread maps\_sounds::button_press_sound();
					
					iprintln("button pressed...");
					level.help_room_button_interacted = 1;

					button_trigger_three Delete();

					break;
				}
			}
		}
		wait 0.05;
	}
}

handle_cabinet_room_button(cabinet_room_button, button_trigger_four)
{
	while(1)
	{
		players = GetPlayers();

		if(IsDefined(button_trigger_four))
		{
			for (i = 0; i < players.size; i++)
			{																			   		   
				if(players[i] IsTouching (button_trigger_four) && players[i] UseButtonPressed())
				{		
					cabinet_room_button thread maps\_sounds::button_press_sound();

					iprintln("button pressed...");
					level.cabinet_room_button_interacted = 1;

					button_trigger_four Delete();

					break;
				}
			}
		}
		wait 0.05;
	}
}