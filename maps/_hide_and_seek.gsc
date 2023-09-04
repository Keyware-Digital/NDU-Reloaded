#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

// TODO: Add more SFX that the EE uses, make the samantha figure spawn next to the m1 carbinet again being raised by a skeleton hand, interaction with it spawns a max ammo
// TIP: Shoot the head of the Samantha figures to destroy them

init_hide_and_seek()
{
	level.buttons_interacted = 0;
	button_step_done = 0;

    first_room_stairs_button = spawn("script_model", (200, 0, 266));
	button_trigger_one = spawn("trigger_radius", (first_room_stairs_button.origin - (0, 0, 100)), 0, 64, 64);	//lower trigger box so you can actviate without opening stairs.
	first_room_stairs_button.angles = (0, 0, 90);
	first_room_stairs_button setModel("zmb_mdl_button");
	first_room_stairs_button solid();

    first_room_power_section_button = spawn("script_model", (-113, -869, 113));
	button_trigger_two = spawn("trigger_radius", (first_room_power_section_button.origin - (0, 0, 5)), 0, 64, 64);
	first_room_power_section_button.angles = (0, -90, 0);
	first_room_power_section_button setModel("zmb_mdl_button");
	first_room_power_section_button solid();

    help_room_button = spawn("script_model", (260, 1113, 20));
	button_trigger_three = spawn("trigger_radius", (help_room_button.origin), 0, 64, 64);
	help_room_button.angles = (90, 0, 0);
	help_room_button setModel("zmb_mdl_button");
	help_room_button solid();

    cabinet_room_button = spawn("script_model", (830, 628, 210));
	button_trigger_four = spawn("trigger_radius", (cabinet_room_button.origin), 0, 64, 64);
	cabinet_room_button.angles = (0, 0, 180);
	cabinet_room_button setModel("zmb_mdl_button");
	cabinet_room_button solid();

	thread handle_button(first_room_stairs_button, button_trigger_one);

	thread handle_button(first_room_power_section_button, button_trigger_two);

	thread handle_button(help_room_button, button_trigger_three);
	
	thread handle_button(cabinet_room_button, button_trigger_four);

	//comment out the below and the above 4x theads to spawn figures instantly for debugging
	//handle_samantha_figures();

	players = GetPlayers();

	while (1) // Infinite loop to keep the script running
	{
		if (button_step_done == 0 && level.buttons_interacted == 4)
		{
			for (i = 0; i < players.size; i++)
			{
				players[i] maps\_sounds::samantha_start_sound();
			}

			handle_initial_samantha_figure();

			button_step_done = 1; // Prevent the track being played more than once
		}

		wait 0.05; // Delay to prevent excessive looping
	}
}

handle_button(button, button_trigger)
{
	while(1)
	{
		players = GetPlayers();

		if(IsDefined(button_trigger))
		{
			for (i = 0; i < players.size; i++)
			{																			   		   
				if(players[i] IsTouching (button_trigger) && players[i] UseButtonPressed())
				{		
					button thread maps\_sounds::button_press_sound();

					level.buttons_interacted++;

					button_trigger delete();

					break;
				}
			}
		}
		wait 0.05;
	}
}

handle_initial_samantha_figure()
{
	initial_samantha_figure = spawn("script_model", (-15, -430, 2));
	initial_samantha_figure_trigger = spawn("trigger_radius", (initial_samantha_figure.origin), 0, 64, 64);
	initial_samantha_figure.angles = (0, 90, -90);
	initial_samantha_figure setModel("zmb_mdl_samantha_figure");
	initial_samantha_figure solid();

	while(1)
	{
		players = GetPlayers();

		if(IsDefined(initial_samantha_figure_trigger))
		{
			for (i = 0; i < players.size; i++)
			{																			   		   
				if(players[i] IsTouching (initial_samantha_figure_trigger) && players[i] UseButtonPressed())
				{
					playFX(level._effect["raygun_impact"], initial_samantha_figure.origin);
					initial_samantha_figure delete();
					initial_samantha_figure_trigger delete();
					handle_samantha_figures();

					break;
				}
			}
		}
		wait 0.05;
	}
}

spawn_samantha_figures(position, angles) {
    samantha_figure = spawn("script_model", position);
    samantha_figure.angles = angles;
    samantha_figure setModel("zmb_mdl_samantha_figure");
    samantha_figure playLoopSound("musicbox_loop");
    samantha_figure solid();
    samantha_figure setCanDamage(true);

    thread rotate_samantha_figure(samantha_figure);
    thread init_samantha_figure_timeout();
    thread handle_samantha_figure_timeout(samantha_figure);

    return samantha_figure; // Return the spawned figure
}

handle_samantha_figures()
{
    level.samantha_figure_timed_out = 0;
    level.hide_and_seek_done = 0;

    samantha_figure_positions = [];
    samantha_figure_positions[0] = (145, -528, 158);
    samantha_figure_positions[1] = (308.5, -1417.5, 59.5);
    samantha_figure_positions[2] = (-385.5, -702, 44);
    samantha_figure_positions[3] = (750, -333, 0);
    samantha_figure_positions[4] = (-405, 570, 84.5);
    samantha_figure_positions[5] = (-106, 646, 294);
    samantha_figure_positions[6] = (445, 306, 158);
    samantha_figure_positions[7] = (1228, 594.5, 273.75);

    samantha_figure_angles = [];
    samantha_figure_angles[0] = (0, 45, 0);
    samantha_figure_angles[1] = (0, 45, 0);
    samantha_figure_angles[2] = (0, 45, 0);
    samantha_figure_angles[3] = (0, 45, 0);
    samantha_figure_angles[4] = (0, 45, 0);
    samantha_figure_angles[5] = (0, 45, 0);
    samantha_figure_angles[6] = (0, 45, 0);
    samantha_figure_angles[7] = (0, 45, 0);

    samantha_figures = [];

    for (i = 0; i < samantha_figure_positions.size; i++)
    {
        samantha_figure = spawn_samantha_figures(samantha_figure_positions[i], samantha_figure_angles[i]);
        samantha_figures[i] = samantha_figure; // Store the spawned figure in the array
    }

    while (1)
    {
        for (i = 0; i < samantha_figures.size; i++)
        {
            samantha_figure = samantha_figures[i];

			thread samantha_figure_damage(samantha_figure);
        }

        /*if (level.samantha_figure_shot == 1)
        {
            // Handle other actions when a figure is shot
        }*/

        wait 0.05;
    }
}

//Causes script error, can be fixed
samantha_figure_damage(samantha_figure)
{
		samantha_figure waittill("damage", damage, attacker, direction_vec, point, type);
		level.samantha_figure_shot = 1;
		playFX(level._effect["raygun_impact"], samantha_figure.origin);
		samantha_figure StopLoopSound(0.1);


		samantha_figure delete();

	// Check if the 8th Samantha figure is deleted, then set hide_and_seek_done to 1
		if (samantha_figure == samantha_figure[7])
			level.hide_and_seek_done = 1;
}

rotate_samantha_figure(samantha_figure)
{
	while(isDefined(samantha_figure))
	{
		samantha_figure rotateYaw(360, 10);
		wait(0.5);
	}
}

init_samantha_figure_timeout()
{
	wait(60); // Give the player one minute to destroy all samantha figures
	level.samantha_figure_timed_out = 1;
}

handle_samantha_figure_timeout(samantha_figure)
{
	while(1)
	{
		if(level.samantha_figure_timed_out == 1 && level.hide_and_seek_done == 0){

			while(isDefined(samantha_figure))
			{
				samantha_figure Delete();
			}
			
			players = GetPlayers();

			for (i = 0; i < players.size; i++)
			{
				players[i] maps\_sounds::samantha_fail_sound();
			}
			
			handle_initial_samantha_figure(); // If the player has failed to destroy all samantha figures, reset back to this step
		}
		wait 0.05;
	}
}