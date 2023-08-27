#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

// TODO: Add more SFX that the EE uses, place each Samantha figure in their correct places, trigger the EE sound track and reward the player with max ammo.
// TIP: Shoot the circle metal base of the Samantha figures to destroy them

init_hide_and_seek()
{
	level.first_room_stairs_button_interacted = 0; 
	level.first_room_power_section_button_interacted = 0;
	level.help_room_button_interacted = 0;
	level.cabinet_room_button_interacted = 0;
	hide_and_seek_ee_done = 0;

    first_room_stairs_button = spawn("script_model", (200, 0, 266));
	button_trigger_one = spawn("trigger_radius", (first_room_stairs_button.origin - (0, 0, 50)), 0, 64, 64);
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

	thread handle_first_room_stairs_button(first_room_stairs_button, button_trigger_two);

	thread handle_first_room_power_section_button(first_room_power_section_button, button_trigger_one);

	thread handle_help_room_button(help_room_button, button_trigger_three);
	
	thread handle_cabinet_room_button(cabinet_room_button, button_trigger_four);

	players = GetPlayers();

	while (1) // Infinite loop to keep the script running
	{
		if (hide_and_seek_ee_done == 0 && level.first_room_stairs_button_interacted == 1 && level.first_room_power_section_button_interacted == 1 && level.help_room_button_interacted == 1 && level.cabinet_room_button_interacted == 1)
		{
			iprintln("spawning initial samantha figure next to the m1 carbine wall buy...");
			handle_samantha_figures();

			/*for (i = 0; i < players.size; i++)
			{
				players[i] thread maps\_sounds::samanthas_lullaby_ee_track_sound();
			}*/

			hide_and_seek_ee_done = 1; // Prevent the track being played more than once
		}

		wait 1; // Delay to prevent excessive looping
	}
}

/*
handle_button(button, button_trigger, button_interacted)
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

					iprintln("button pressed...");
					button_interacted = 1;

					button_trigger delete();

					break;
				}
			}
		}
		wait 0.05;
	}
}
*/

//These four functions below should be one function being fed vars like rotate_samantha_figure() but I don't know if passing an updated var value up after it's been passed down is possible in GSC
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

					button_trigger_one delete();

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

					button_trigger_two delete();

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

					button_trigger_three delete();

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

					button_trigger_four delete();

					break;
				}
			}
		}
		wait 0.05;
	}
}

handle_samantha_figures()
{
	initial_samantha_figure = spawn("script_model", (-15, -400, 2));
	initial_samantha_figure.angles = (0, 90, -90);
	initial_samantha_figure setModel("zmb_mdl_samantha_figure");
	initial_samantha_figure solid();
	initial_samantha_figure setCanDamage(true);
	
	initial_samantha_figure waittill ("damage", damage, attacker, direction_vec, point, type);
	playFX(level._effect["raygun_impact"], initial_samantha_figure.origin);
	initial_samantha_figure delete();

	//Please move the figures to their proper locations
	iprintln("spawning first figure next to first room stairs for testing...");
	samantha_figure_one = spawn("script_model", (-15, 30, 15));
	samantha_figure_one.angles = (0, 45, 0);
	samantha_figure_one setModel("zmb_mdl_samantha_figure");
	samantha_figure_one playLoopSound("musicbox_loop");
	samantha_figure_one solid();
	samantha_figure_one setCanDamage(true);

	thread rotate_samantha_figure(samantha_figure_one);

	samantha_figure_one waittill ("damage", damage, attacker, direction_vec, point, type);
	playFX(level._effect["raygun_impact"], samantha_figure_one.origin);
	samantha_figure_one stopLoopSound(0.1);
	samantha_figure_one delete();

	samantha_figure_two = spawn("script_model", (-15, 60, 15));
	samantha_figure_two.angles = (0, 45, 0);
	samantha_figure_two setModel("zmb_mdl_samantha_figure");
	samantha_figure_two playLoopSound("musicbox_loop");
	samantha_figure_two solid();
	samantha_figure_two setCanDamage(true);

	thread rotate_samantha_figure(samantha_figure_two);

	samantha_figure_two waittill ("damage", damage, attacker, direction_vec, point, type);
	playFX(level._effect["raygun_impact"], samantha_figure_two.origin);
	samantha_figure_two StopLoopSound(0.1);
	samantha_figure_two delete();

	samantha_figure_three = spawn("script_model", (-15, 90, 15));
	samantha_figure_three.angles = (0, 45, 0);
	samantha_figure_three setModel("zmb_mdl_samantha_figure");
	samantha_figure_three playLoopSound("musicbox_loop");
	samantha_figure_three solid();
	samantha_figure_three setCanDamage(true);

	thread rotate_samantha_figure(samantha_figure_three);

	samantha_figure_three waittill ("damage", damage, attacker, direction_vec, point, type);
	playFX(level._effect["raygun_impact"], samantha_figure_three.origin);
	samantha_figure_three StopLoopSound(0.1);
	samantha_figure_three delete();

	samantha_figure_four = spawn("script_model", (-15, 120, 15));
	samantha_figure_four.angles = (0, 45, 0);
	samantha_figure_four setModel("zmb_mdl_samantha_figure");
	samantha_figure_four playLoopSound("musicbox_loop");
	samantha_figure_four solid();
	samantha_figure_four setCanDamage(true);

	thread rotate_samantha_figure(samantha_figure_four);

	samantha_figure_four waittill ("damage", damage, attacker, direction_vec, point, type);
	playFX(level._effect["raygun_impact"], samantha_figure_four.origin);
	samantha_figure_four StopLoopSound(0.1);
	samantha_figure_four delete();

	samantha_figure_five = spawn("script_model", (-15, 160, 15));
	samantha_figure_five.angles = (0, 45, 0);
	samantha_figure_five setModel("zmb_mdl_samantha_figure");
	samantha_figure_five playLoopSound("musicbox_loop");
	samantha_figure_five solid();
	samantha_figure_five setCanDamage(true);

	thread rotate_samantha_figure(samantha_figure_five);

	samantha_figure_five waittill ("damage", damage, attacker, direction_vec, point, type);
	playFX(level._effect["raygun_impact"], samantha_figure_five.origin);
	samantha_figure_five StopLoopSound(0.1);
	samantha_figure_five delete();

	samantha_figure_six = spawn("script_model", (-15, 200, 15));
	samantha_figure_six.angles = (0, 45, 0);
	samantha_figure_six setModel("zmb_mdl_samantha_figure");
	samantha_figure_six playLoopSound("musicbox_loop");
	samantha_figure_six solid();
	samantha_figure_six setCanDamage(true);

	thread rotate_samantha_figure(samantha_figure_six);

	samantha_figure_six waittill ("damage", damage, attacker, direction_vec, point, type);
	playFX(level._effect["raygun_impact"], samantha_figure_six.origin);
	samantha_figure_six StopLoopSound(0.1);
	samantha_figure_six delete();

	samantha_figure_seven = spawn("script_model", (-15, 240, 15));
	samantha_figure_seven.angles = (0, 45, 0);
	samantha_figure_seven setModel("zmb_mdl_samantha_figure");
	samantha_figure_seven playLoopSound("musicbox_loop");
	samantha_figure_seven solid();
	samantha_figure_seven setCanDamage(true);

	thread rotate_samantha_figure(samantha_figure_seven);

	samantha_figure_seven waittill ("damage", damage, attacker, direction_vec, point, type);
	playFX(level._effect["raygun_impact"], samantha_figure_seven.origin);
	samantha_figure_seven StopLoopSound(0.1);
	samantha_figure_seven delete();

	samantha_figure_eight = spawn("script_model", (-15, 280, 15));
	samantha_figure_eight.angles = (0, 45, 0);
	samantha_figure_eight setModel("zmb_mdl_samantha_figure");
	samantha_figure_eight playLoopSound("musicbox_loop");
	samantha_figure_eight solid();
	samantha_figure_eight setCanDamage(true);

	thread rotate_samantha_figure(samantha_figure_eight);

	samantha_figure_eight waittill ("damage", damage, attacker, direction_vec, point, type);
	playFX(level._effect["raygun_impact"], samantha_figure_eight.origin);
	samantha_figure_eight StopLoopSound(0.1);
	samantha_figure_eight delete();
}

rotate_samantha_figure(samantha_figure)
{
	while(isDefined(samantha_figure))
	{
		samantha_figure rotateYaw(360, 10);
		wait(0.5);
	}
}