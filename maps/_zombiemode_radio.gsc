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
    
    while (1)
    {
        self waittill ("damage", damage, attacker, direction_vec, point, type);

        iPrintLn(damage); //Damage value taken from weapon
        iPrintLn(attacker); //Name of player who damaged entity
        iPrintLn(direction_vec); //Direction of attack?
        iPrintLn(point); //Point of origin of attack?
        iPrintLn(type); //Type of attack used (i.e. bullet type for guns)

        ////////////////////////////////////////////

        //You could make a complex ee with the above info and creating logic gates with other functions, but here's a simple example:
        //This will award 500 points only to someone who shoots the radio each time with a gun that does 20 damage and has pistol ammo, i.e. the starting guns

        if (type == "MOD_PISTOL_BULLET" && damage == 20)
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
        
        ////////////////////////////////////////////

        // if (isPlayerUsingWeapon(self, "stg44_pap") || isPlayerUsingWeapon(self, "kar98k"));

        // Increment the shot count //WIP
        // level.radio_shots++;

        // Check if the shot count reaches 5 //WIP
        // if (level.radio_shots >= 5)
        
        println("changing radio stations");
        
        SetClientSysState("levelNotify","kzmb_next_song");
        
        // Call the random_perk_powerup function from powerups.gsc
        // quick & dirty proof of concept for potential ee
        //radio_ee(self.origin);
        
        wait(1.0);
    }
}

/*radio_ee(radio_origin)  //robs janky ass code, pls fix dan
{
    valid_drop = false;

    while (!valid_drop)
    {
        radio_origin = radio_origin - (15, 15, 0);

        playable_area = getentarray("playable_area", "targetname");

        for (i = 0; i < playable_area.size; i++)
        {
            if (radio_origin istouching(playable_area[i]))
            {
                valid_drop = true;
                break;
            }
        }

        wait(0.01);
    }

        for (i = 0; i < level.zombie_powerup_array.size; i++)
    {
        if (level.zombie_powerup_array[i] == "random_perk")
        {
            level.zombie_powerup_index = i;
            break;
        }
    }
    
    // Spawn the power-up on the radio's location
    //play_sound_2D("bright_sting");
    level.zombie_vars["zombie_drop_item"] = 1;
    level.powerup_drop_count = 0;
    level thread maps\_zombiemode_powerups::powerup_drop(radio_origin); // Spawn the power-up on the radio's location
}*/

    //we need to add SetClientSysState("levelNotify","kzmb_next_song"); as the else statement

/*isPlayerUsingWeapon(player, weaponName)
{
    return player GetCurrentWeapon() == weaponName;
}*/

