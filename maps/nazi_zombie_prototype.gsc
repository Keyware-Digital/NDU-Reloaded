#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;

init()
{
	init_strings();
	init_sounds();
}

main()
{

	maps\_destructible_opel_blitz::init();

	include_weapons();
	maps\_character_randomise::init();
	include_powerups();
	level thread betty_fx();
	
	maps\nazi_zombie_prototype_fx::main();
	maps\_zombiemode::main();

	players = GetPlayers();

	for( i = 0; i < players.size; i++ )
	{
		players[i] SetClientDvar("sv_cheats", 1); //enable cheats for testing purposes
		players[i] SetClientDvar("player_lastStandBleedoutTime", 45);
		players[i] maps\_zombiemode_score::add_to_player_score(99999); //add points for testing purposes
	}

	// If you want to modify/add to the weapons table, please copy over the _zombiemode_weapons init_weapons() and paste it here.
	// I recommend putting it in it's own function...
	// If not a MOD, you may need to provide new localized strings to reflect the proper cost.

	level thread intro_screen();
	
	level thread maps\_zombiemode_betty::give_betties_after_rounds();

	//level thread health_show();
	
}

betty_fx()
{
level._effect["betty_explode"]			= loadfx("weapon/bouncing_betty/fx_explosion_betty_generic");
level._effect["betty_trail"]			= loadfx("weapon/bouncing_betty/fx_betty_trail");
}

init_strings()
{
	PrecacheString(&"PROTOTYPE_PLACE");
	PrecacheString(&"PROTOTYPE_REGION");
	PrecacheString(&"PROTOTYPE_DATE");
}

init_sounds()
{
	maps\_zombiemode_utility::add_sound( "break_stone", "break_stone" );
}

intro_screen()
{

	flag_wait( "all_players_connected" );
	wait(2);
	level.intro_hud = [];
	for(i = 0;  i < 4; i++)
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
	level.intro_hud[0].y = -130;
	level.intro_hud[1].y = -110;
	level.intro_hud[2].y = -90;
	level.intro_hud[3].y = -70;

	level.intro_hud[0] settext(&"PROTOTYPE_PLACE");
	level.intro_hud[1] settext(&"PROTOTYPE_REGION");
	level.intro_hud[2] settext(&"PROTOTYPE_DATE");
//	level.intro_hud[3] settext("placeholder_text");
//	level.intro_hud[1] settext(&"ZOMBIE_INTRO_FACTORY_LEVEL_TIME");
//	level.intro_hud[2] settext(&"ZOMBIE_INTRO_FACTORY_LEVEL_DATE");

	for(i = 0 ; i < 4; i++)
	{
		level.intro_hud[i] FadeOverTime( 3.5 ); 
		level.intro_hud[i].alpha = 1;
		wait(1.5);
	}
	wait(1.5);
	for(i = 0 ; i < 4; i++)
	{
		level.intro_hud[i] FadeOverTime( 3.5 ); 
		level.intro_hud[i].alpha = 0;
		wait(1.5);
	}	
	wait(2);
	for(i = 0 ; i < 4; i++)
	{
		level.intro_hud[i] destroy();
	}
}

// Include the weapons that are only inr your level so that the cost/hints are accurate
// Also adds these weapons to the random treasure chest.
include_weapons()
{
	// NDU: Reloaded (main box additions)

	include_weapon( "mosin_rifle" );
	include_weapon( "dp28" );
	//include_weapon( "kar98k_bayonet" );		//disabled in favour of Bowie.
	//include_weapon( "mosin_rifle_bayonet" );	//disabled in favour of Bowie.
	include_weapon( "svt40" );
	include_weapon( "type99_lmg" );
	//include_weapon( "walther_prototype" );	//disabled as we're giving the Germans standard Walthers.
	include_weapon( "zombie_ppsh" );
	include_weapon( "zombie_type100_smg" );

	// Weapon cabinet only additions		
	include_weapon( "mosin_rifle_scoped_zombie" );		
	include_weapon( "mp40_bigammo_mp" );		
	include_weapon( "springfield_scoped_zombie_upgraded" );		
	include_Weapon( "thompson_bigammo_mp");		
	include_weapon( "zombie_perk_bottle" );		
	
	// Pistols
	include_weapon( "colt" );		//for Americans
	//include_weapon( "colt_dirty_harry" );
	include_weapon( "walther" );	//for German
	include_weapon( "sw_357" );
	include_weapon( "tokarev" );	//for Russian
	
	// Semi Auto
	include_weapon( "m1carbine" );	//disabled in weapon limiter below
	include_weapon( "m1garand" );	//disabled in weapon limiter below in favour of mlgarand_gl
	include_weapon( "gewehr43" );

	// Full Auto
	include_weapon( "stg44" );
	include_weapon( "thompson" );
	include_weapon( "mp40" );
	
	// Bolt Action
	include_weapon( "kar98k" );			//disabled in weapon limiter below in favour of Mosin.
	include_weapon( "springfield" );
	
	// Scoped
	include_weapon( "ptrs41_zombie" );
	include_weapon( "kar98k_scoped_zombie" );	//weapon cabinet only
		
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
	include_weapon( "ray_gun", true, ::prototype_ray_gun_weighting_func );	//testing raygun weighting func.

	// bouncing betties & bowie
	include_weapon( "mine_bouncing_betty" );
	//include_weapon("zombie_bowie_flourish");

	// Weapon limiter
	level.limited_weapons["colt"] = 0;
	level.limited_weapons["walther"] = 0;
	level.limited_weapons["tokarev"] = 0;
	level.limited_weapons["kar98k"] = 0;
	level.limited_weapons["kar98k_scoped_zombie"] = 0;
	level.limited_weapons["m1carbine"] = 0;
	level.limited_weapons["m1garand"] = 0;
	level.limited_weapons["mosin_rifle_scoped_zombie"] = 0;
	level.limited_weapons["mp40_bigammo_mp"] = 0;
	//level.limited_weapons["springfield"] = 0;
	level.limited_weapons["springfield_scoped_zombie_upgraded"] = 0;
	level.limited_weapons["thompson_bigammo_mp"] = 0;
	level.limited_weapons["zombie_perk_bottle"] = 0;
}

// Rare weapon(s) weighting
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
	include_powerup( "randomperk" );
}

health_show()
{
	players = get_players();
	while(1)
	{
		IPrintLn(players[0].health);
		wait 0.3;
	}
}
