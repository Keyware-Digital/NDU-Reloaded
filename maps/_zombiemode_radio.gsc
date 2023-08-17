#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include maps\_zombiemode_powerups;

init_radio()
{
	// radio spark
	level._effect["broken_radio_spark"] = LoadFx( "env/electrical/fx_elec_short_oneshot" );

	// kzmb, for all the latest killer hits
	radios = getentarray("kzmb","targetname");
	
	// no radios, return
	if (!isDefined(radios) || !radios.size)
	{
		return;
	}
	
	array_thread(radios, ::zombie_radio_play );
}

zombie_radio_play()
{
    self transmittargetname();
    self setcandamage(true);

    weapon_fired_count = 1;
    radio_station_count = 13;
    player_is_interacting_with_radio = 0; // We don't want radio functions overlapping
    player_has_done_radio_ee_one = 0;
    player_has_done_radio_ee_two = 0;
    player_has_done_radio_ee_three = 1; // Disabled for now, maybe add BO1 Dead Ops arcade music like the radio from the BO1 version of Nacht
    level.radioEETrackIndex = 1;
    
    while (1)
    {
        self waittill ("damage", damage, attacker, direction_vec, point, type);

        //Maybe spawn something under each light that is lit?
        //Maybe spawn something in the tunnel?
        //Add ee songs from other maps to be played when doing something with the radio and stop the original ones from playing until afterwards?

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
            
            if (player_is_interacting_with_radio == 0 && player_has_done_radio_ee_two == 0 && radio_station_count == 13 && players[i] == attacker && attacker GetCurrentWeapon() == "stg44_pap") {

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
            //will only play ee songs if they aren't playing already, the vanilla radio is uninitialised or playing the empty radio station, if the person interacting with the radio is the attacker and if the attacker is using a scoped rifle.
            if(player_is_interacting_with_radio == 0 && player_has_done_radio_ee_three == 0 && radio_station_count == 13 && players[i] == attacker && attacker GetCurrentWeapon() == "kar98k_scoped_zombie" || attacker GetCurrentWeapon() == "springfield_scoped_zombie") 
            {

                player_is_interacting_with_radio = 1; // Radio is busy

                iPrintLn("Playing ee track...");
                players[i] thread maps\_sounds::radio_ee_track_sound();
                player_has_done_radio_ee_three = 1;
	            players[i] waittill("ee_track_sound_finished");
                player_has_done_radio_ee_three = 0;
            }
            
            if(player_is_interacting_with_radio == 0 && player_has_done_radio_ee_three == 0 && radio_station_count <= 13 && players[i] == attacker){
                player_is_interacting_with_radio = 1; // Radio is busy
                SetClientSysState("levelNotify","kzmb_next_song"); //has 13 radio stations, the last one is empty for silence
                wait 2; //wait for radio stations to change or desync occurs
                // Make sure only 13 radio stations are tracked
                if (radio_station_count == 13){
                    radio_station_count = 1;
                }
                else {
                    radio_station_count++;
                }
                iPrintLn("changing to radio station " + radio_station_count);
            }

        }
        
        wait 1;
    }
}
