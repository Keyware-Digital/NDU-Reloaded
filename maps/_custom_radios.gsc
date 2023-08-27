#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

init_custom_radios()
{
	level.monty_radio_interacted = 0;
	level.generic_radio_two_interacted = 0;
//	level.radio_three_interacted = 0;

	monty_radio_finished = 0;
	generic_radio_one_finished = 0;
	generic_radio_two_finished = 0;

	//radio 1
    monty_radio = spawn("script_model", (320, 175, 25));	//default bo3 origin (280, 158, 0));
	monty_radio_trigger = spawn("trigger_radius", (monty_radio.origin), 0, 20, 20);		//was 0, 10, 10)
	monty_radio.angles = (0, 180, 0);	//was (0, 90, 0);
	monty_radio solid();
	monty_radio setModel("static_berlin_ger_radio_d");
	monty_radio playLoopSound("radio_static");

	//radio 2, restore the default radio to vanilla behavior, and move its ee's to radio two.
	generic_radio_one = spawn("script_model", (75, 1100, 0));
	generic_radio_one_trigger = spawn("trigger_radius", (generic_radio_one.origin), 0, 10, 10);
	generic_radio_one.angles = (0, 270, 0);
	generic_radio_one solid();
	generic_radio_one setCanDamage(true);
	generic_radio_one setModel("static_berlin_ger_radio_d");

	//radio 3, placeholder
//	radio_three = Spawn("script_model", (280, 158, 0));
//	radio_three_trigger = Spawn("trigger_radius", (monty_radio.origin), 0, 20, 20);
//	radio_three.angles = (0, 90, 0);
//	radio_three Solid();
//	radio_three SetModel("static_berlin_ger_radio_d");
//	radio_three PlayLoopSound("radio_static");

	thread handle_monty_radio_interaction(monty_radio, monty_radio_trigger);
	
	thread handle_generic_radio_one_interaction(generic_radio_one, generic_radio_one_trigger);

	players = GetPlayers();

	while (1)
	{
		if ( monty_radio_finished == 0 && level.monty_radio_interacted == 1)
		{
			for (i = 0; i < players.size; i++)
			{
				monty_radio thread maps\_sounds::monty_dialogue_sound();
			}

			monty_radio_finished = 1;
		}

		if ( generic_radio_one_finished == 0 && level.generic_radio_two_interacted == 1)
		{
			for (i = 0; i < players.size; i++)
			{
				monty_radio thread maps\_sounds::monty_dialogue_sound();
			}

			generic_radio_one_finished = 1;
		}

		wait 1;
	}
}

handle_monty_radio_interaction(monty_radio, monty_radio_trigger)
{
	while(1)
	{
		players = GetPlayers();

		if(IsDefined(monty_radio_trigger))
		{
			for (i = 0; i < players.size; i++)
			{														   		   
				if(players[i] IsTouching (monty_radio_trigger) && players[i] UseButtonPressed())
				{
					monty_radio StopLoopSound(0.1);
					level.monty_radio_interacted = 1;

					monty_radio_trigger Delete();

					break;
				}
			}
		}
		wait 0.05;
	}
}

// You don't handle the below radio type like the one above, the one above is setup for user interaction and is one time use, the original radio is setup to cycle through stuff
handle_generic_radio_one_interaction(generic_radio_one, generic_radio_one_trigger)
{
    while (1)
    {
        if (IsDefined(generic_radio_one_trigger))
        {
            self waittill ("damage", damage, attacker, direction_vec, point, type);

			level.generic_radio_two_interacted = 1;
			generic_radio_one_trigger Delete();
			break;
        }
        wait 0.05;
    }
}

