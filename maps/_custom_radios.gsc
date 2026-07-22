#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

init_custom_radios()
{
    level._effect["broken_radio_spark"] = LoadFx( "env/electrical/fx_elec_short_oneshot" );
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

// currently only the ray gun ee works
handle_generic_radio_one_interaction(generic_radio_one)
{
    weapon_fired_count_raygun = 0;     // Counts up-to 5 Ray Gun shots
    weapon_fired_count_stg = 0;        // Counts up-to 30 STG44 shots

    player_is_interacting_with_radio = 0;  // We don't want radio functions overlapping
    player_has_done_radio_ee_one = 0;      
    player_has_done_radio_ee_two = 0; 
    player_has_done_radio_ee_three = 1;    // stg44_pap 30 shots, disabled for now
    player_has_done_radio_ee_four = 1;     // scoped rifles, disabled for now, maybe add BO1 Dead Ops arcade music like the radio from the BO1 version of Nacht

    level.radioEETrackIndex = 1;
    
    while (1)
    {
        generic_radio_one waittill ("damage", damage, attacker, direction_vec, point, type);

        player_is_interacting_with_radio = 0;

        if (!isDefined(attacker) || !isPlayer(attacker))
        {
            wait 0.1;
            continue;
        }

        players = GetPlayers();

        for (i = 0; i < players.size; i++) 
        {
            if (players[i] != attacker)
                continue;

            player = players[i];
            current_weapon = player GetCurrentWeapon();

            PlayFX(level._effect["broken_radio_spark"], generic_radio_one.origin + (0,0,8));
            player thread maps\_sounds::button_press_sound();

            // EE 1
            if (player_has_done_radio_ee_one == 0 && current_weapon == "ray_gun_mk1_v2")
            {
                player_is_interacting_with_radio = 1;
                player.score += 500;
                player.score_total += 500;
                player maps\_zombiemode_score::set_player_score_hud();
                player thread maps\_sounds::cash_register_sound();
                player_has_done_radio_ee_one = 1;
                //iPrintLn("Ray Gun score EE complete!");
                break;
            }

            // EE 2
            if (player_has_done_radio_ee_two == 0 && current_weapon == "ray_gun_mk1_v2")
            {
                player_is_interacting_with_radio = 1;

                weapon_fired_count_raygun++;
                iPrintLn(weapon_fired_count_raygun + " out of 5 Ray Gun shots done");

                if (weapon_fired_count_raygun >= 5)
                {
                    powerup_spawn = (740.611, 907.825, 11.0648);       

                    // Samantha-style powerup drop (more reliable)
                    for (k = 0; k < level.zombie_powerup_array.size; k++)
                    {
                        if (level.zombie_powerup_array[k] == "random_powerup")
                        {
                            level.zombie_powerup_index = k;
                            break;
                        }
                    }

                    play_sound_2D("bright_sting");
                    level.zombie_vars["zombie_drop_item"] = 1;
                    level.powerup_drop_count = 0;
                    // give a free random powerup or perk to all players
                    //level thread maps\_zombiemode_powerups::powerup_drop(powerup_spawn);
                    level thread maps\_zombiemode_powerups::force_specific_powerup( "random_perk", powerup_spawn );

                    player_has_done_radio_ee_two = 1;
                    iPrintLn("Ray Gun Powerup EE complete!");
                    weapon_fired_count_raygun = 0;
                }
                break;
            }

            // EE 3 (disabled for now)
            if (player_has_done_radio_ee_three == 0 && current_weapon == "stg44_pap")
            {
                player_is_interacting_with_radio = 1;

                weapon_fired_count_stg++;
                iPrintLn(weapon_fired_count_stg + " out of 30 STG44 shots done");

                if (weapon_fired_count_stg >= 30)
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

                    play_sound_2D("bright_sting");
                    level.zombie_vars["zombie_drop_item"] = 1;
                    level.powerup_drop_count = 0;
                    level thread maps\_zombiemode_powerups::powerup_drop(powerup_spawn);

                    player_has_done_radio_ee_three = 1;
                    iPrintLn("STG44 EE complete!");
                    weapon_fired_count_stg = 0;
                }
                break;
            }

            // EE 4 (disabled for now)
            if (player_has_done_radio_ee_four == 0)
            {
                if (current_weapon == "springfield_scoped_zombie" || 
                    current_weapon == "kar98k_scoped_zombie" || 
                    current_weapon == "mosin_rifle_scoped_zombie")
                {
                    player_is_interacting_with_radio = 1;
                    iPrintLn("Playing ee track...");
                    player thread maps\_sounds::radio_ee_track_sound();
                    player_has_done_radio_ee_four = 1;
                    break;
                }
            }
        }
        
        wait 0.50;
    }
}