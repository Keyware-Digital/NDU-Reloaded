#include common_scripts\utility;

#include maps\_utility;

#include maps\_zombiemode_utility;

init() {
    init_strings();
    init_sounds();
}

main() {

    maps\_destructible_opel_blitz::init();

    include_weapons();
    maps\_character_randomise::init();
    include_powerups();
    level thread betty_fx();
    //level thread dolphine_dive_fx();

    maps\nazi_zombie_prototype_fx::main();
    maps\_zombiemode::main();
	array_thread(GetPlayers(), ::reloading_monitor);
    thread maps\_explosive_barrels::init_explosive_barrels();
    thread maps\_monty_radio::init_monty_radio();
    thread maps\_samantha_says::init_samantha_says();
    animscripts\walking_anim::main();

    // used to modify the percentages of pulls of ray gun and tesla gun in magic box
	level.pulls_since_last_ray_gun = 0;
	level.pulls_since_last_tesla_gun = 0;
	level.player_drops_tesla_gun = false;

    // If you want to modify/add to the weapons table, please copy over the _zombiemode_weapons init_weapons() and paste it here.
    // I recommend putting it in it's own function...
    // If not a MOD, you may need to provide new localized strings to reflect the proper cost.

    level thread intro_screen();

    level thread maps\_zombiemode_betty::give_betties_after_rounds();

    //level thread health_show();

    level thread filtered_weapons();

}

betty_fx() {
    level._effect["betty_explode"] = loadfx("weapon/bouncing_betty/fx_explosion_betty_generic");
    level._effect["betty_trail"] = loadfx("weapon/bouncing_betty/fx_betty_trail");
}

/*dolphine_dive_fx() {
    level._effect[ "dolphine_dive_land" ] = loadfx ( "" );
}*/

init_strings() {
    PrecacheString( &"PROTOTYPE_PLACE");
    PrecacheString( &"PROTOTYPE_REGION");
    PrecacheString( &"PROTOTYPE_DATE");
}

init_sounds() {
    maps\_zombiemode_utility::add_sound("break_stone", "break_stone");
}

intro_screen() {

    flag_wait("all_players_connected");
    wait(2);
    level.intro_hud = [];
    for (i = 0; i < 4; i++) {
        level.intro_hud[i] = newHudElem();
        level.intro_hud[i].x = 0;
        level.intro_hud[i].y = 0;
        level.intro_hud[i].alignX = "left";
        level.intro_hud[i].alignY = "bottom";
        level.intro_hud[i].horzAlign = "left";
        level.intro_hud[i].vertAlign = "bottom";
        level.intro_hud[i].foreground = true;

        if (level.splitscreen && !level.hidef) {
            level.intro_hud[i].fontScale = 2.75;
        } else {
            level.intro_hud[i].fontScale = 1.75;
        }
        level.intro_hud[i].alpha = 0.0;
        level.intro_hud[i].color = (1, 1, 1);
        level.intro_hud[i].inuse = false;
    }
    level.intro_hud[0].y = -130;
    level.intro_hud[1].y = -110;
    level.intro_hud[2].y = -90;
    level.intro_hud[3].y = -70;
    level.intro_hud[0].x = 10;
    level.intro_hud[1].x = 10;
    level.intro_hud[2].x = 10;
    level.intro_hud[3].x = 10;

    level.intro_hud[0] settext( &"PROTOTYPE_PLACE");
    level.intro_hud[1] settext( &"PROTOTYPE_REGION");
    level.intro_hud[2] settext( &"PROTOTYPE_DATE");

    for (i = 0; i < 4; i++) {
        level.intro_hud[i] FadeOverTime(3.5);
        level.intro_hud[i].alpha = 1;
        wait(1.5);
    }
    wait(1.5);
    for (i = 0; i < 4; i++) {
        level.intro_hud[i] FadeOverTime(3.5);
        level.intro_hud[i].alpha = 0;
        wait(1.5);
    }
    wait(2);
    for (i = 0; i < 4; i++) {
        level.intro_hud[i] destroy();
    }
}

// Include the weapons that are only inr your level so that the cost/hints are accurate
// Also adds these weapons to the random treasure chest.
include_weapons() {

    // NDU: Reloaded (main box additions)
    include_weapon("dp28");
    include_weapon("mine_bouncing_betty", /*true,*/::prototype_betty_weighting_func);
    include_weapon("mosin_rifle");
    include_weapon("ppsh41");
    include_weapon("svt40");
    include_weapon("type99_lmg");           //remove japenese theatre weapons at some point and replaced with something else.
    include_weapon("zombie_bowie_flourish", /*true,*/::prototype_bowie_weighting_func);
    //include_weapon("zombie_cymbal_monkey", /*true,*/::prototype_cymbal_monkey_weighting_func);
    include_weapon("zombie_type100_smg");   //remove japenese theatre weapons at some point and replaced with something else.

    // Weapon cabinet only additions	
    include_weapon("kar98k_bayonet");	
    include_Weapon("m1921_thompson");
    include_weapon("mosin_rifle_bayonet");
    include_weapon("mosin_rifle_scoped_zombie");
    include_weapon("mp40_bigammo_mp");
    include_weapon("perks_a_cola");
    include_weapon("ppsh41_drum");
    include_weapon("springfield_scoped_zombie");
    include_weapon("sten_mk5");
    include_weapon("stg44_pap");

    // Other
    //include_weapon("death_hands");
    //include_weapon("knuckle_crack_hands");

    // Cut content
    //include_weapon("springfield_scoped_zombie_upgraded");
    //include_weapon("walther_prototype" );
    //include_weapon("tesla_gun", /*true,*/ );

    // Pistols
    include_weapon("colt");     //for Americans
    //include_weapon("colt_dirty_harry");
    include_weapon("walther");  //for German
    include_weapon("sw_357");
    include_weapon("tokarev");  //for Russian

    // Semi Auto
    include_weapon("m1carbine");    //disabled in weapon limiter below
    include_weapon("m1garand");     //disabled in weapon limiter below in favour of mlgarand_gl
    include_weapon("gewehr43");

    // Full Auto
    include_weapon("stg44");
    include_weapon("thompson");
    include_weapon("mp40");

    // Bolt Action
    include_weapon("kar98k");   //disabled in weapon limiter below in favour of Mosin.
    include_weapon("springfield");

    // Scoped
    include_weapon("ptrs41_zombie");
    include_weapon("kar98k_scoped_zombie"); //weapon cabinet only

    // Grenade
    include_weapon("molotov");
    // JESSE: lets go all german grenades for consistency and to reduce annoyance factor
    //	include_weapon( "fraggrenade" );
    include_weapon("stielhandgranate");

    // Grenade Launcher
    include_weapon("m1garand_gl");
    include_weapon("m7_launcher");

    // Flamethrower
    include_weapon("m2_flamethrower_zombie");

    // Shotgun
    include_weapon("doublebarrel");
    include_weapon("doublebarrel_sawed_grip");
    include_weapon("shotgun");

    // Bipod
    include_weapon("30cal_bipod");
    include_weapon("fg42_bipod");
    include_weapon("mg42_bipod");

    // Heavy MG
    include_weapon("bar");

    // Rocket Launcher
    include_weapon("panzerschrek");

    // Special
    include_weapon("ray_gun_mk1_v2", /*true,*/::prototype_ray_gun_weighting_func);

    // Weapon limiter
    level.limited_weapons["colt"] = 0;
    level.limited_weapons["walther"] = 0;
    level.limited_weapons["tokarev"] = 0;
    level.limited_weapons["kar98k"] = 0;
    level.limited_weapons["kar98k_bayonet"] = 0;
    level.limited_weapons["kar98k_scoped_zombie"] = 0;
    level.limited_weapons["m1921_thompson"] = 0;
    //level.limited_weapons["m1carbine"] = 0;
    level.limited_weapons["m1garand"] = 0;
    level.limited_weapons["mosin_rifle_bayonet"] = 0;
    level.limited_weapons["mosin_rifle_scoped_zombie"] = 0;
    level.limited_weapons["mp40_bigammo_mp"] = 0;
    level.limited_weapons["perks_a_cola"] = 0;
    level.limited_weapons["ppsh41_drum"] = 0;
    //level.limited_weapons["springfield"] = 0;
    level.limited_weapons["springfield_scoped_zombie"] = 0;
    level.limited_weapons["sten_mk5"] = 0;
    level.limited_weapons["stg44_pap"] = 0;
    //level.limited_weapons["death_hands"] = 0;
    //level.limited_weapons["knuckle_crack_hands"] = 0;
}

// Rare weapon(s) weighting
prototype_ray_gun_weighting_func() {
    {
        num_to_add = 1;
        // increase the percentage of ray gun
        if (isDefined(level.pulls_since_last_ray_gun)) {
            // after 12 pulls the ray gun percentage increases to 15%
            if (level.pulls_since_last_ray_gun > 11) {
                num_to_add += int(level.zombie_include_weapons.size * 0.1);
            }
            // after 8 pulls the Ray Gun percentage increases to 10%
            else if (level.pulls_since_last_ray_gun > 7) {
                num_to_add += int(.05 * level.zombie_include_weapons.size);
            }
        }
        return num_to_add;
    }
}

/*prototype_cymbal_monkey_weighting_func()
{
	players = get_players();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] maps\_zombiemode_weapons::has_weapon_or_upgrade( "zombie_cymbal_monkey" ) )
		{
			count++;
		}
	}
	if ( count > 0 )
	{
		return 1;
	}
	else
	{
		if( level.round_number < 11 )
		{
			return 3;
		}
		else
		{
			return 5;
		}
	}
}*/

prototype_bowie_weighting_func()
{
	players = get_players();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] maps\_zombiemode_weapons::has_weapon_or_upgrade( "zombie_bowie_flourish" ) )
		{
			count++;
		}
	}
	if ( count > 0 )
	{
		return 1;
	}
	else
	{
		if( level.round_number < 10 )
		{
			return 3;
		}
		else
		{
			return 5;
		}
	}
}

prototype_betty_weighting_func()
{
	players = get_players();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] maps\_zombiemode_weapons::has_weapon_or_upgrade( "mine_bouncing_betty" ) )
		{
			count++;
		}
	}
	if ( count > 0 )
	{
		return 1;
	}
	else
	{
		if( level.round_number < 9 )
		{
			return 3;
		}
		else
		{
			return 5;
		}
	}
}

include_powerups() {
    include_powerup("nuke");
    include_powerup("insta_kill");
    include_powerup("double_points");
    include_powerup("max_ammo");
    include_powerup("carpenter");
    include_powerup("death_machine");
    include_powerup("random_perk");
    include_powerup("bonus_points");
    include_powerup("fire_sale");
}

health_show() {
    players = GetPlayers();
    while (1) {
        //IPrintLn(players[0].health);
        wait 0.3;
    }
}

//Puts weapons that need filtering into an array to be called later
filtered_weapons()
{
	level.filtered_weapon = [];
	level.filtered_weapon[level.filtered_weapon.size] = "none";
    level.filtered_weapon[level.filtered_weapon.size] = "mine_bouncing_betty";
	level.filtered_weapon[level.filtered_weapon.size] = "perks_a_cola";
	level.filtered_weapon[level.filtered_weapon.size] = "molotov";
	level.filtered_weapon[level.filtered_weapon.size] = "stielhandgranate";
    level.filtered_weapon[level.filtered_weapon.size] = "zombie_bowie_flourish";
    level.filtered_weapon[level.filtered_weapon.size] = "m2_flamethrower_zombie";
	//level.filtered_weapon[level.filtered_weapon.size] = "zombie_cymbal_monkey";
}

reloading_monitor()
{
    
	while(1)
	{
		self.reloading = false;
		self waittill("reload_start");
        current_weapon = self GetCurrentWeapon();

        for ( i = 0; i < level.filtered_weapon.size; i++ )
        {
            if (current_weapon == level.filtered_weapon[i])
            {
                return;
            }
        }

		currentMagAmmo = self GetWeaponAmmoClip(current_weapon); //store their current mag ammo during the reload
		self.reloading = true;
        while(currentMagAmmo == self GetWeaponAmmoClip(current_weapon)) { //Wait for the ammo to change to something other than what we caught during the reload
			wait 0.01;
        }
	}
}
