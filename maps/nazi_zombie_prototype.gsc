#include common_scripts\utility; 
#include maps\_utility;


main()
{
	maps\_destructible_opel_blitz::init();

	include_weapons();
	include_powerups();
    level thread rampage_fx();
	
	maps\nazi_zombie_prototype_fx::main();
	maps\_zombiemode::main();
	
	init_sounds();

	// If you want to modify/add to the weapons table, please copy over the _zombiemode_weapons init_weapons() and paste it here.
	// I recommend putting it in it's own function...
	// If not a MOD, you may need to provide new localized strings to reflect the proper cost.

	level thread intro_screen();
	
	level thread maps\_zombiemode_betty::give_betties_after_rounds();
	
}

rampage_fx()
{
level._effect["betty_explode"]			= loadfx("weapon/bouncing_betty/fx_explosion_betty_generic");
	level._effect["betty_trail"]			= loadfx("weapon/bouncing_betty/fx_betty_trail");
}
init_sounds()
{
	maps\_zombiemode_utility::add_sound( "break_stone", "break_stone" );
}
intro_screen()
{
	text_line[0] = "Abandoned Airfield";
	text_line[1] = "Morasko, Poland";
	text_line[2] = "August 30th, 1945";

	flag_wait( "all_players_connected" );
	wait(2);
	level.intro_hud = [];
	for(i = 0;  i < 3; i++)
	{
		level.intro_hud[i] = newHudElem();
		level.intro_hud[i].x = 0;
		level.intro_hud[i].y = 0;
		level.intro_hud[i].alignX = "left";
		level.intro_hud[i].alignY = "bottom";
		level.intro_hud[i].horzAlign = "left";
		level.intro_hud[i].vertAlign = "bottom";
		level.intro_hud[i].foreground = true;

		if ( level.splitscreen && !level.hidef )
		{
			level.intro_hud[i].fontScale = 2.75;
		}
		else
		{
			level.intro_hud[i].fontScale = 1.75;
		}
		level.intro_hud[i].alpha = 0.0;
		level.intro_hud[i].color = (1, 1, 1);
		level.intro_hud[i].inuse = false;
	}
	level.intro_hud[0].y = -110;
	level.intro_hud[1].y = -90;
	level.intro_hud[2].y = -70;


	level.intro_hud[0] settext(text_line[0]);
	level.intro_hud[1] settext(text_line[1]);
	level.intro_hud[2] settext(text_line[2]);

	for(i = 0 ; i < 3; i++)
	{
		level.intro_hud[i] FadeOverTime( 3.5 ); 
		level.intro_hud[i].alpha = 1;
		wait(1.5);
	}
	wait(1.5);
	for(i = 0 ; i < 3; i++)
	{
		level.intro_hud[i] FadeOverTime( 3.5 ); 
		level.intro_hud[i].alpha = 0;
		wait(1.5);
	}	
	//wait(1.5);
	for(i = 0 ; i < 3; i++)
	{
		level.intro_hud[i] destroy();
	}
}

// Include the weapons that are only inr your level so that the cost/hints are accurate
// Also adds these weapons to the random treasure chest.
include_weapons()
{
	// NDU Reloaded - Trebor
	include_weapon( "walther_prototype" );
	include_weapon( "mosin_rifle_bayonet" );
	include_weapon( "kar98k_bayonet" );
	include_weapon( "svt40" );
	include_weapon( "dp28" );
	include_weapon( "type99_lmg" );
	include_weapon( "zombie_type100_smg" );
	include_weapon( "zombie_ppsh" );
	include_weapon( "springfield_scoped_zombie_upgraded" );
	
	// Pistols
	//include_weapon( "colt" );
	//include_weapon( "colt_dirty_harry" );
	//include_weapon( "walther" );
	include_weapon( "sw_357" );
	
	// Semi Auto
	include_weapon( "m1carbine" );
	//include_weapon( "m1garand", false );
	include_weapon( "gewehr43" );

	// Full Auto
	include_weapon( "stg44" );
	include_weapon( "thompson" );
	include_weapon( "mp40" );
	
	// Bolt Action

	include_weapon( "kar98k", false );
	//include_weapon( "springfield", false );

	// Scoped
	include_weapon( "ptrs41_zombie" );
	include_weapon( "kar98k_scoped_zombie", false );
		
	// Grenade
	include_weapon( "molotov" );
	// JESSE: lets go all german grenades for consistency and to reduce annoyance factor
	//	include_weapon( "fraggrenade" );
	include_weapon( "stielhandgranate" );

	// Grenade Launcher
	include_weapon( "m1garand_gl" );
	include_weapon( "m7_launcher" );
	
	// Flamethrower
	include_weapon( "m2_flamethrower_zombie" );
	
	// Shotgun
	include_weapon( "doublebarrel" );
	include_weapon( "doublebarrel_sawed_grip" );
	include_weapon( "shotgun" );
	
	// Bipod
	include_weapon( "fg42_bipod" );
	include_weapon( "mg42_bipod" );
	include_weapon( "30cal_bipod" );

	// Heavy MG
	include_weapon( "bar" );

	// Rocket Launcher
	include_weapon( "panzerschrek" );

	// Special
	include_weapon( "ray_gun" );

	// bouncing betties
	include_weapon("mine_bouncing_betty");

	level.limited_weapons["kar98k"] = 0;
	level.limited_weapons["kar98k_scoped_zombie"] = 0;
	level.limited_weapons["m1carbine"] = 0;
	
}

// Rare Gun Weighting
add_walther_prototype()
{
    while(1)
    {
        level waittill( "between_round_over" );
        if(level.round_number >= 15)
        {
            maps\_zombiemode_weapons::add_limited_weapon( "walther_prototype", 1);
            break;    
        }
    }
}

add_springfield_scoped_zombie_upgraded()
{
    while(1)
    {
        level waittill( "between_round_over" );
        if(level.round_number >= 20)
        {
            maps\_zombiemode_weapons::add_limited_weapon( "springfield_scoped_zombie_upgraded", 1);
            break;    
        }
    }
}

prototype_ray_gun_weighting_func()
{
	{	
		num_to_add = 1;
		// increase the percentage of ray gun
		if( isDefined( level.pulls_since_last_ray_gun ) )
		{
			// after 12 pulls the ray gun percentage increases to 15%
			if( level.pulls_since_last_ray_gun > 11 )
			{
				num_to_add += int(level.zombie_include_weapons.size*0.1);
			}			
			// after 8 pulls the Ray Gun percentage increases to 10%
			else if( level.pulls_since_last_ray_gun > 7 )
			{
				num_to_add += int(.05 * level.zombie_include_weapons.size);
			}		
		}
		return num_to_add;	
	}
}

include_powerups()
{
	include_powerup( "nuke" );
	include_powerup( "insta_kill" );
	include_powerup( "double_points" );
	include_powerup( "full_ammo" );
	include_powerup( "carpenter" );
	include_powerup( "jugg" );
	include_powerup( "dtap" );
	include_powerup( "fastreload" );
	include_powerup( "revive" );
	include_powerup( "phd" );
	include_powerup( "sp" );
	include_powerup( "longersprint" );
	include_powerup( "aim" );
	include_powerup( "fireworks" );
}

include_weapon( weapon_name, in_box )
{
	maps\_zombiemode_weapons::include_zombie_weapon( weapon_name, in_box );
}

include_powerup( powerup_name )
{
	maps\_zombiemode_powerups::include_zombie_powerup( powerup_name );
}

