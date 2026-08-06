#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include maps\_sounds;

init_custom_radios()
{
    level._effect["broken_radio_spark"] = LoadFx( "env/electrical/fx_elec_short_oneshot" );
	level.monty_radio_interacted = 0;
	monty_radio_finished = 0;

	// monty radio 1
    monty_radio = spawn("script_model", (320, 175, 25));	// default bo3 origin (280, 158, 0));
	monty_radio_trigger = spawn("trigger_radius", (monty_radio.origin), 0, 20, 20);		// was 0, 10, 10)
	monty_radio.angles = (0, 180, 0);	//was (0, 90, 0);
	monty_radio solid();
	monty_radio setModel("static_berlin_ger_radio_d");
	monty_radio playLoopSound("radio_static");

	// generic radio 1
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
    //weapon_fired_count_raygun = 0;     // Counts up-to 5 Ray Gun shots
    weapon_fired_count_stg = 0;        // Counts up-to 30 STG44 shots
    player_is_interacting_with_radio = 0;

    level.player_has_done_radio_ee_one   = 0;
    level.player_has_done_radio_ee_two   = 0;
    level.player_has_done_radio_ee_three = 1;
    level.player_has_done_radio_ee_four  = 1;

    level.radioEETrackIndex = 1;

    // Morse SOS state
    level.morse_progress            = 0;
    level.morse_last_hit_time       = 0;
    level.morse_current_group_count = 0;
    level.morse_generation          = 0;
    level.morse_radio               = generic_radio_one;
    level.morse_on_cooldown         = false; 

    //iPrintLnBold("^3Morse SOS system initialized");
    
    while (1)
    {
        generic_radio_one waittill ("damage", damage, attacker, direction_vec, point, type);

        if (!isDefined(attacker) || !isPlayer(attacker))
        {
            wait 0.05;
            continue;
        }

        player = attacker;
        current_weapon = player GetCurrentWeapon();

        PlayFX(level._effect["broken_radio_spark"], generic_radio_one.origin + (0,0,8));
        player thread button_press_sound();

        // EE 1
        if (level.player_has_done_radio_ee_one == 0 && current_weapon == "ray_gun_mk1_v2")
        {
            player.score += 500;
            player.score_total += 500;
            player maps\_zombiemode_score::set_player_score_hud();
            player thread cash_register_sound();
            level.player_has_done_radio_ee_one = 1;
            //iPrintLnBold("^2EE1 complete - 500 points");
            wait 0.05;
            continue;
        }

        // EE 2 
         if (level.player_has_done_radio_ee_two == 0 && current_weapon == "ray_gun_mk1_v2" && !level.morse_on_cooldown)
        {
            current_time = GetTime();

            // 666 ms window, plus creepy lore :)
            if (!isDefined(level.morse_last_hit_time) || level.morse_last_hit_time == 0 || (current_time - level.morse_last_hit_time) > 666)
            {
                level.morse_current_group_count = 1;
                //iPrintLn("^5New signal group started");
            }
            else
            {
                level.morse_current_group_count++;
                //iPrintLn("^5Same group - hit count now: " + level.morse_current_group_count);
            }

            level.morse_last_hit_time = current_time;
            level.morse_generation++;

           //iPrintLn("Generation: " + level.morse_generation + " | Progress: " + level.morse_progress + "/9");

            thread morse_group_timeout(level.morse_generation, player);
            wait 0.05;
            continue;
        }

        // EE 3 (disabled for now)
        if (level.player_has_done_radio_ee_three == 0 && current_weapon == "stg44_pap")
        {
            player_is_interacting_with_radio = 1;

            weapon_fired_count_stg++;
           //iPrintLn(weapon_fired_count_stg + " out of 30 STG44 shots done");

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

                level.player_has_done_radio_ee_three = 1;
                //iPrintLn("STG44 EE complete!");
                weapon_fired_count_stg = 0;
            }
            wait 0.05;
            continue;
        }

        // EE 4 (disabled for now)
        if (level.player_has_done_radio_ee_four == 0)
        {
            if (current_weapon == "springfield_scoped_zombie" || 
                current_weapon == "kar98k_scoped_zombie" || 
                current_weapon == "mosin_rifle_scoped_zombie")
            {
                player_is_interacting_with_radio = 1;
                //iPrintLn("Playing ee track...");
                player thread radio_ee_track_sound();
                level.player_has_done_radio_ee_four = 1;
                wait 0.05;
                continue;
            }
        }

        wait 0.05;
    }
}

morse_group_timeout(gen, player)
{
    wait 0.55;

    if (level.morse_generation != gen)
        return;

    if (level.morse_current_group_count <= 0)
        return;

    count = level.morse_current_group_count;
    level.morse_current_group_count = 0;

    // 1-2 hits = DOT, 3+ hits = DASH
    is_dot = (count <= 2);

    /*if (is_dot)
        iPrintLnBold("^3Detected: DOT  (hits: " + count + ")");
    else
        iPrintLnBold("^3Detected: DASH (hits: " + count + ")");*/

    expected_dot = (level.morse_progress < 3 || level.morse_progress >= 6);

    /*if (expected_dot)
        iPrintLn("Expected: DOT");
    else
        iPrintLn("Expected: DASH");*/

    if ((is_dot && expected_dot) || (!is_dot && !expected_dot))
    {
        // ===== SUCCESS =====
        level.morse_progress++;
        //iPrintLnBold("^2CORRECT! Progress: " + level.morse_progress + "/9");

        if (level.morse_progress == 1)
        {
            level.morse_radio playLoopSound("radio_loop");
            //iPrintLnBold("^5RADIO LOOP STARTED");
        }

        // Every successful signal
        playsoundatposition("radio_hit", level.morse_radio.origin);

        if (level.morse_progress >= 9)
        {
            //iPrintLnBold("^2^2^2 SOS COMPLETE!");

            // Stop the static loop
            level.morse_radio StopLoopSound(0.1);
            //iPrintLnBold("^5RADIO LOOP STOPPED");

            // Final success feedback + reward
            play_sound_2D("bright_sting");
            player thread player_vox_helper( ::pickup_bonus_points_sound, "powerup_pickup_sound_done" );

            powerup_spawn = (740.611, 907.825, 11.0648);

            for (k = 0; k < level.zombie_powerup_array.size; k++)
            {
                if (level.zombie_powerup_array[k] == "random_powerup")
                {
                    level.zombie_powerup_index = k;
                    break;
                }
            }

            level.zombie_vars["zombie_drop_item"] = 1;
            level.powerup_drop_count = 0;
            level thread maps\_zombiemode_powerups::force_specific_powerup("random_perk", powerup_spawn);

            level.player_has_done_radio_ee_two = 1;
            level.morse_progress = 0;
            return;
        }
    }
    else
    {
        // ===== FAIL =====
        level.morse_progress = 0;
        //iPrintLnBold("^1WRONG SIGNAL - reset to 0");

        level.morse_radio StopLoopSound(0.1);
        //iPrintLnBold("^5RADIO LOOP STOPPED");
        playsoundatposition("radio_fail", level.morse_radio.origin);

        if (isDefined(player) && isPlayer(player))
            player thread player_vox_helper( ::crappy_weapon_sound, "weapon_vox_done" );

        // Start 3 second cooldown
        level.morse_on_cooldown = true;
        thread morse_cooldown_timer();
    }

    if (level.morse_progress > 0 && level.morse_progress < 9)
        thread morse_sequence_idle_timeout(gen, player);
}

morse_sequence_idle_timeout(gen, player)
{
    wait 5.0;

    if (level.morse_generation == gen && level.morse_progress > 0 && level.morse_progress < 9)
    {
        level.morse_progress = 0;

        if (isDefined(level.morse_radio))
            level.morse_radio StopLoopSound(0.1);

        //iPrintLnBold("^1IDLE TIMEOUT - sequence reset");

        playsoundatposition("radio_fail", level.morse_radio.origin);

        if (isDefined(player) && isPlayer(player))
            player thread player_vox_helper( ::crappy_weapon_sound, "weapon_vox_done" );

        // Start the 3 second cooldown
        level.morse_on_cooldown = true;
        thread morse_cooldown_timer();
    }
}

morse_cooldown_timer()
{
    wait 3.0;

    level.morse_on_cooldown = false;

    playsoundatposition("radio_ready", level.morse_radio.origin);
}