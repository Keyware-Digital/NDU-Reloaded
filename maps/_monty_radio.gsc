#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

init_monty_radio()
{
	level.monty_radio_interacted = 0;
	ee_done = 0;

    monty_radio = Spawn("script_model", (280, 158, 0));
	monty_radio_trigger = Spawn("trigger_radius", (monty_radio.origin), 0, 10, 10);
	monty_radio.angles = (0, 90, 0);
	monty_radio Solid();
	monty_radio SetModel("static_berlin_ger_radio_d");

	monty_radio PlayLoopSound("radio_static");
	thread handle_monty_radio_interaction(monty_radio, monty_radio_trigger);

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