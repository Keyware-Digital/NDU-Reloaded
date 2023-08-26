#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

init_new_radios()
{
	level.monty_radio_interacted = 0;
	level.radio_two_interacted = 0;
//	level.radio_three_interacted = 0;
	ee_done = 0;
	ee2_done = 0;
//	ee3_done = 0;

	//radio 1
    monty_radio = Spawn("script_model", (320, 175, 25));	//default bo3 origin (280, 158, 0));
	monty_radio_trigger = Spawn("trigger_radius", (monty_radio.origin), 0, 20, 20);		//was 0, 10, 10)
	monty_radio.angles = (0, 180, 0);	//was (0, 90, 0);
	monty_radio Solid();
	monty_radio SetModel("static_berlin_ger_radio_d");
	monty_radio PlayLoopSound("radio_static");
	//radio 2, restore the default radio to vanilla behavior, and move its ee's to radio two.
	radio_two = Spawn("script_model", (75, 1100, 0));
	radio_two_trigger = Spawn("trigger_radius", (monty_radio.origin), 0, 10, 10);
	radio_two.angles = (0, 270, 0);
	radio_two Solid();
	radio_two SetModel("static_berlin_ger_radio_d");
	radio_two PlayLoopSound("radio_static");
	//radio 3, placeholder
//	radio_three = Spawn("script_model", (280, 158, 0));
//	radio_three_trigger = Spawn("trigger_radius", (monty_radio.origin), 0, 20, 20);
//	radio_three.angles = (0, 90, 0);
//	radio_three Solid();
//	radio_three SetModel("static_berlin_ger_radio_d");
//	radio_three PlayLoopSound("radio_static");

	thread handle_monty_radio_interaction(monty_radio, monty_radio_trigger);
	thread handle_radio_two_interaction(radio_two, radio_two_trigger);

	players = GetPlayers();

	while (1)
	{
		if ( ee_done == 0 && level.monty_radio_interacted == 1)
		{
			for (i = 0; i < players.size; i++)
			{
				monty_radio thread maps\_sounds::monty_dialogue_sound();
			}

			ee_done = 1;
		}

		if ( ee2_done == 0 && level.radio_two_interacted == 1)
		{
			for (i = 0; i < players.size; i++)
			{
				monty_radio thread maps\_sounds::monty_dialogue_sound();
			}

			ee2_done = 1;
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
					monty_radio StopLoopSound(.1);
					level.monty_radio_interacted = 1;

					monty_radio_trigger Delete();

					break;
				}
			}
		}
		wait 0.05;
	}
}

handle_radio_two_interaction(radio_two, radio_two_trigger)
{
    while (1)
    {
        players = GetPlayers();
        if (IsDefined(radio_two_trigger))
        {
            self waittill ("damage", damage, attacker, direction_vec, point, type);

            for (i = 0; i < players.size; i++)
            {
                if (isDefined(damage))
                {
                    IPrintLn("you found me hiding like an illegal migrant, give me money?");
                    radio_two StopLoopSound(.1);
                    level.radio_two_interaced = 2;
                    radio_two_trigger Delete();
                    break;
                }
            }
        }
        wait 0.05;
    }
}

