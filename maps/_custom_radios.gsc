#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

init_custom_radios()
{
	level.monty_radio_interacted = 0;
	monty_radio_finished = 0;

	//monty radio 1
    monty_radio = spawn("script_model", (320, 175, 25));	//default bo3 origin (280, 158, 0));
	monty_radio_trigger = spawn("trigger_radius", (monty_radio.origin), 0, 20, 20);		//was 0, 10, 10)
	monty_radio.angles = (0, 180, 0);	//was (0, 90, 0);
	monty_radio solid();
	monty_radio setModel("static_berlin_ger_radio_d");
	monty_radio playLoopSound("radio_static");

	//generic radio 1
	generic_radio_one = spawn("script_model", (75, 1100, 0));
	generic_radio_one.angles = (0, 270, 0);
	generic_radio_one solid();
	generic_radio_one setModel("static_berlin_ger_radio_d");
    generic_radio_one setCanDamage(true);

	thread handle_monty_radio_interaction(monty_radio, monty_radio_trigger);
	
	thread handle_generic_radio_one_interaction(generic_radio_one);

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

// Rob broke this, currently only the ray gun ee works
handle_generic_radio_one_interaction(generic_radio_one)
{
    weapon_fired_count = 1;
    player_is_interacting_with_radio = 0; // We don't want radio functions overlapping
    player_has_done_radio_ee_one = 0;
    player_has_done_radio_ee_two = 0;
    player_has_done_radio_ee_three = 1; // Disabled for now, maybe add BO1 Dead Ops arcade music like the radio from the BO1 version of Nacht
    level.radioEETrackIndex = 1;
    
    while (1)
    {
        generic_radio_one waittill ("damage", damage, attacker, direction_vec, point, type);

        player_is_interacting_with_radio = 0; // Radio is no longer busy after loop is done

        players = GetPlayers();

        for (i = 0; i < players.size; i++) {
            
            if (player_is_interacting_with_radio == 0 && player_has_done_radio_ee_one == 0 && players[i] == attacker && attacker GetCurrentWeapon() == "ray_gun_mk1_v2")
            {

                player_is_interacting_with_radio = 1; // Radio is busy

                players[i].score += 500;
                players[i].score_total += 500;
                players[i] maps\_zombiemode_score::set_player_score_hud();
                players[i] thread maps\_sounds::cash_register_sound();
                player_has_done_radio_ee_one = 1;
            }
            
            if (player_is_interacting_with_radio == 0 && player_has_done_radio_ee_two == 0 && players[i] == attacker && attacker GetCurrentWeapon() == "stg44_pap") {

                player_is_interacting_with_radio = 1; // Radio is busy

                iPrintLn(weapon_fired_count + " out of 5 shots done" );

                if (weapon_fired_count == 5)
                {

                    powerup_spawn = (740.611, 907.825, 11.0648);       

                    for (k = 0; k < level.zombie_powerup_array.size; k++)
                    {
                        if (level.zombie_powerup_array[k] == "random_powerup")
                        {
                            level.zombie_powerup_index = k;
                            break;
                        }
                    }

                    self thread maps\_sounds::lightning_sound();
                    play_sound_2D("bright_sting");
                    level.zombie_vars["zombie_drop_item"] = 1;
                    level.powerup_drop_count = 0;
                    level thread maps\_zombiemode_powerups::powerup_drop(powerup_spawn);
                    player_has_done_radio_ee_two = 1;
                    iPrintLn(powerup_spawn);
                }
                else {
                    weapon_fired_count++;
                }

            }
            if(player_is_interacting_with_radio == 0 && player_has_done_radio_ee_three == 0 && players[i] == attacker && attacker GetCurrentWeapon() == "springfield_scoped_zombie" ) // Don't modify for now, add kar98k_scoped_zombie later.
            {

                player_is_interacting_with_radio = 1; // Radio is busy

                iPrintLn("Playing ee track...");
                players[i] thread maps\_sounds::radio_ee_track_sound();
                player_has_done_radio_ee_three = 1;
            }
        }
        
        wait 1;
    }
}/*