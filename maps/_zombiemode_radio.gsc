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

    weapon_fired_count = 0;
    level.eeTrackIndex = 1;
    
    while (1)
    {
        self waittill ("damage", damage, attacker, direction_vec, point, type);

        iPrintLn(damage); //Damage value taken from weapon
        iPrintLn(attacker); //Name of player who damaged entity
        iPrintLn(direction_vec); //Direction of bullet impact
        iPrintLn(point); //Origin of bullet impact
        iPrintLn(type); //Type of attack used (i.e. MOD_MELEE)

        //Maybe spawn something under each light that is lit?
        //Maybe spawn something in the tunnel?
        //Add ee songs from other maps to be played when doing something with the radio and stop the original ones from playing until afterwards?

        players = GetPlayers();

        for (i = 0; i < players.size; i++) {

            if (players[i] == attacker && attacker GetCurrentWeapon() == "stg44_pap") {
                weapon_fired_count++;
                iPrintLn(weapon_fired_count);
            }

            if (level.player_has_done_radio_ee_one == 0 && players[i] == attacker && attacker GetCurrentWeapon() == "ray_gun_mk1_v2")
            {
                if (players[i] == attacker) {
                    players[i].score += 500;
                    players[i].score_total += 500;
                    maps\_zombiemode_score::set_player_score_hud();
                    players[i]thread maps\_sounds::cash_register_sound();
                }
                
                level.player_has_done_radio_ee_one = 1;
            }
            else if (level.player_has_done_radio_ee_two == 0 && weapon_fired_count == 5)
            {

                powerup_spawn = (720.611, 907.825, 21.0648);       

                    for (i = 0; i < level.zombie_powerup_array.size; i++)
                    {
                        if (level.zombie_powerup_array[i] == "random_powerup")
                        {
                            level.zombie_powerup_index = i;
                            break;
                        }
                    }

                self thread maps\_sounds::lightning_sound();
                play_sound_2D("bright_sting");
                level.zombie_vars["zombie_drop_item"] = 1;
                level.powerup_drop_count = 0;
                level thread maps\_zombiemode_powerups::powerup_drop(powerup_spawn);
                level.player_has_done_radio_ee_two = 1;
                iPrintLn(powerup_spawn);
            }
            else
            {
                if(level.player_has_done_radio_ee_three == 0 && players[i] == attacker && attacker GetCurrentWeapon() == "kar98k_scoped_zombie"){
                    players[i] thread maps\_sounds::ee_track_sound();
                    level.player_has_done_radio_ee_three = 1;
	                players[i] waittill("ee_track_sound_finished");
                    level.player_has_done_radio_ee_three = 0;

                }
                else if(level.player_has_done_radio_ee_three == 0){
                    iPrintLn("changing radio stations");
                    SetClientSysState("levelNotify","kzmb_next_song");
                }
          
            }
        }
        
        wait 1;
    }
}
