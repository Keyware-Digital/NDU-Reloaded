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

/*zombie_radio_play()
{
    self transmittargetname();
    self setcandamage(true);
    
    while (1)
    {
        self waittill ("damage", damage, attacker, direction_vec, point, type);

        if (type == "MOD_EXPLOSIVE" && damage == 100)
        {
            players = GetPlayers();

            for (i = 0; i < players.size; i++) {

                if (players[i] == attacker) {
                    players[i].score += 500;
                    players[i].score_total += 500;
                    players[i] maps\_zombiemode_score::set_player_score_hud();
                }
            }
        }
        else if (type == "MOD_WEAPON" && attacker isPlayer() && isPlayerUsingWeapon(attacker, "stg44_pap"))
        {
            level.radio_shots++;

            if (level.radio_shots >= 30)
            {
                radio_origin = self.origin;
                level.zombie_vars["zombie_drop_item"] = 1;
                level.powerup_drop_count = 0;
                level thread maps\_zombiemode_powerups::powerup_drop(radio_origin);
                level.radio_shots = 0;
            }
        }
        else
        {
            println("playing original music");
            SetClientSysState("levelNotify", "kzmb_next_song");
        }
        
        wait(1.0);
    }
}*/

isPlayerUsingWeapon(player, weaponName)
{
    return player GetCurrentWeapon() == weaponName;
}

zombie_radio_play()
{
    self transmittargetname();
    self setcandamage(true);

    weapon_fired_count = 0;
    
    while (1)
    {
        self waittill ("damage", damage, attacker, direction_vec, point, type);

        iPrintLn(damage); //Damage value taken from weapon
        iPrintLn(attacker); //Name of player who damaged entity
        iPrintLn(direction_vec); //Direction of bullet impact
        iPrintLn(point); //Origin of bullet impact
        iPrintLn(type); //Type of attack used (i.e. bullet type for guns)

        players = GetPlayers();

        for (i = 0; i < players.size; i++) {

            if (players[i] == attacker) {

            attacker waittill("weapon_fired");
            weapon_fired_count++;

            }
        }

        iPrintLn(weapon_fired_count);

        if (isPlayerUsingWeapon(attacker, "ray_gun_mk1_v2"))
        {
            players = GetPlayers();

            for (i = 0; i < players.size; i++) {

                if (players[i] == attacker) {
                    players[i].score += 500;
                    players[i].score_total += 500;
                    players[i] maps\_zombiemode_score::set_player_score_hud();
                }
            }
        }
        else if (isPlayerUsingWeapon(attacker, "stg44_pap") && weapon_fired_count >= 5)
        {
            powerup_spawn = (-100.611, 707.825, 21.0648);

                for (i = 0; i < level.zombie_powerup_array.size; i++)
                {
                    if (level.zombie_powerup_array[i] == "random_perk")
                    {
                        level.zombie_powerup_index = i;
                        break;
                    }
                }

            play_sound_2D("bright_sting");
            level.zombie_vars["zombie_drop_item"] = 1;
            level.powerup_drop_count = 0;
            //level thread maps\_zombiemode_powerups::powerup_drop(-183, 897, 41); // Spawn the power-up on the radio's location
            level thread maps\_zombiemode_powerups::powerup_drop(powerup_spawn);
            iPrintLn(powerup_spawn);
        }
        else if (isPlayerUsingWeapon(attacker, "kar98k"))
        {
            println("changing radio stations");
        
            SetClientSysState("levelNotify","kzmb_next_song");
        }
        
        wait 1;
    }
}

    //we need to add SetClientSysState("levelNotify","kzmb_next_song"); as the else statement

/*isPlayerUsingWeapon(player, weaponName)
{
    return player GetCurrentWeapon() == weaponName;
}*/

