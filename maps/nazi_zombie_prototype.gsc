#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;

init() {
    init_strings();
}

main() {

    maps\_character_randomise::init();
    maps\_destructible_opel_blitz::init();
    maps\nazi_zombie_prototype_fx::main();
    level thread fx();

    include_powerups();
    include_weapons();

    maps\_zombiemode::main();

    level.pulls_since_last_ray_gun = 0;
    level.pulls_since_last_tesla_gun = 0;
    level.player_drops_tesla_gun = false;

    //init_sounds();
    animscripts\walking_anim::main();
    array_thread(GetPlayers(), ::player_zombie_awareness);

    //level thread dolphin_dive_fx();
    level thread filtered_weapons();
    //level thread health_show();
    level thread intro_screen();
    level thread maps\_zombiemode_betty::give_betties_after_rounds();

    level thread player_bounds_monitor();

    level thread spawn_collision_models();

    level thread weather_system();

    thread maps\_custom_radios::init_custom_radios();
    thread maps\_explosive_barrels::init_explosive_barrels();
    thread maps\_hide_and_seek::init_hide_and_seek();
    thread maps\_share_points::init_share_points();

    // If you want to modify/add to the weapons table, please copy over the _zombiemode_weapons init_weapons() and paste it here.
    // I recommend putting it in it's own function...
    // If not a MOD, you may need to provide new localized strings to reflect the proper cost.
}

fx() {
    level._effect["betty_explode"] = loadfx("weapon/bouncing_betty/fx_explosion_betty_generic");
    level._effect["betty_trail"] = loadfx("weapon/bouncing_betty/fx_betty_trail");
    //level._effect["dolphin_dive_land"] = loadfx ( "" );
    level._effect["raygun_impact"] = loadFX("misc/fx_exp_raygun_impact");
}

/*init_sounds()
{
	maps\_zombiemode_utility::add_sound( "break_stone", "break_stone" );
}*/

init_strings() {
    PrecacheString(&"PROTOTYPE_PLACE");
    PrecacheString(&"PROTOTYPE_REGION");
    PrecacheString(&"PROTOTYPE_DATE");
    PrecacheString(&"PROTOTYPE_ZOMBIE_CASH_REGISTER_WITHDRAW");
    PrecacheString(&"PROTOTYPE_ZOMBIE_CASH_REGISTER_DEPOSIT");
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
        level.intro_hud[i].fontScale = 1;
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
    include_weapon("dp28_crude");   // powerup only, dm placeholder for MG08
    include_weapon( "mine_bouncing_betty", true, ::prototype_betty_weighting_func );
    //include_weapon("mauser_c96");
    include_weapon("mosin_rifle");
    //include_weapon("mp40_bo3");
    include_weapon("ppsh41");
    include_weapon("svt40");
    include_weapon( "zombie_bowie_flourish", true, ::prototype_bowie_weighting_func );
    include_weapon("zombie_colt_upgraded");
    //include_weapon("zombie_cymbal_monkey", /*true,*/::prototype_cymbal_monkey_weighting_func);
    
    // Weapon cabinet only additions	
    //include_weapon("bloodhound");
    include_Weapon("m1921_thompson");
    include_weapon("mosin_rifle_scoped_zombie");
    include_weapon("mp40_bigammo_mp");
    include_weapon("perks_a_cola");
    include_weapon("ppsh41_drum");
    include_weapon("springfield_scoped_zombie");
    include_weapon("sten_mk5");
    include_weapon("stg44_pap");    // "b" variant of pap StG, 4-round burst.

    // Other
    //include_weapon("zombie_death_hands");
    //include_weapon("zombie_knuckle_crack");
    //include_weapon("zombie_punch_melee");

    // Cut content
    //include_weapon("kar98k_bayonet");
    //include_weapon("mosin_rifle_bayonet");
    //include_weapon("springfield_scoped_zombie_upgraded");
    //include_weapon("walther_prototype" );
    //include_weapon("tesla_gun", /*true,*/ );
    // JP weapons, to be removed because don't really fit in Nacht's europe setting
    //include_weapon("type99_lmg"); 
    //include_weapon("zombie_type100_smg");

    // Pistols
    include_weapon("colt");     //for Americans
    include_weapon("colt_wet");
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

    // Bipod / LMG
    include_weapon("30cal_bipod");
    //include_weapon("bar_bipod");
    include_weapon("fg42_bipod");
    include_weapon("mg42_bipod");

    // Heavy MG
    include_weapon("bar");

    // Rocket Launcher
    include_weapon("panzerschrek");

    // Special
    include_weapon( "ray_gun_mk1_v2", true, ::prototype_ray_gun_weighting_func );

    // Weapon limiter
    level.limited_weapons["colt"] = 0;
    level.limited_weapons["colt_wet"] = 0;
    //level.limited_weapons["mauser_c96"] = 0;
    level.limited_weapons["walther"] = 0;
    level.limited_weapons["tokarev"] = 0;
    level.limited_weapons["kar98k"] = 0;
    level.limited_weapons["dp28_crude"] = 0;
    //level.limited_weapons["kar98k_bayonet"] = 0;
    level.limited_weapons["kar98k_scoped_zombie"] = 0;
    level.limited_weapons["m1921_thompson"] = 0;
    //level.limited_weapons["m1carbine"] = 0;
    //level.limited_weapons["m1garand"] = 0;
    //level.limited_weapons["mosin_rifle_bayonet"] = 0;
    level.limited_weapons["mosin_rifle_scoped_zombie"] = 0;
    level.limited_weapons["mp40_bigammo_mp"] = 0;
    level.limited_weapons["perks_a_cola"] = 0;
    level.limited_weapons["ppsh41_drum"] = 0;
    //level.limited_weapons["springfield"] = 0;
    level.limited_weapons["springfield_scoped_zombie"] = 0;
    level.limited_weapons["sten_mk5"] = 0;
    level.limited_weapons["stg44_pap"] = 0;
    level.limited_weapons["zombie_colt_upgraded"] = 0;
    //level.limited_weapons["zombie_death_hands"] = 0;
    //level.limited_weapons["knuckle_crack_hands"] = 0;
}

// Puts weapons that need filtering into an array to be called later
filtered_weapons()
{
    level.filtered_weapon = [];
    level.filtered_weapon[level.filtered_weapon.size] = "m2_flamethrower_zombie";
    level.filtered_weapon[level.filtered_weapon.size] = "mine_bouncing_betty";
    level.filtered_weapon[level.filtered_weapon.size] = "molotov";
    level.filtered_weapon[level.filtered_weapon.size] = "none";
    level.filtered_weapon[level.filtered_weapon.size] = "perks_a_cola";
    level.filtered_weapon[level.filtered_weapon.size] = "stielhandgranate";
    level.filtered_weapon[level.filtered_weapon.size] = "zombie_bowie_flourish";
    //level.filtered_weapon[level.filtered_weapon.size] = "zombie_cymbal_monkey";
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

// Rare weapon(s) weighting
prototype_ray_gun_weighting_func()
{
    num_to_add = 1;

    if (isDefined(level.pulls_since_last_ray_gun))
    {
        // after 12 pulls the ray gun percentage increases to 15%
        if (level.pulls_since_last_ray_gun > 11)
        {
            num_to_add += int(level.zombie_include_weapons.size * 0.15);
        }
        // after 8 pulls the Ray Gun percentage increases to 10%
        else if (level.pulls_since_last_ray_gun > 7)
        {
            num_to_add += int(level.zombie_include_weapons.size * 0.1);
        }
    }

    return num_to_add;
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

player_zombie_awareness()
{
    self endon("disconnect");
    self endon("death");
    
    while(1)
    {
        wait(1);
        
        zombie = get_closest_ai(self.origin,"axis");
        
        if(!isDefined(zombie))
        {
            continue;
        }
        
        dist = 200;
        
        switch(zombie.zombie_move_speed)
        {
            case "walk": dist = 200; break;
            case "run":  dist = 250; break;
            case "sprint": dist = 275; break;
        }
        
        if( distance2d(zombie.origin, self.origin) < dist
            && zombie.origin[2] < self.origin[2] + 80
            && zombie.origin[2] > self.origin[2] - 80 )
        {				
            yaw = self animscripts\utility::GetYawToSpot( zombie.origin );
            
            if( yaw < -100 || yaw > 100 )
            {
                zombie playsound ("behind_vocals");
            }			
        }		
    }	
}

// BO3 style random lightning + thunder throughout the map
// this should be moved to nazi_zombie_prototype_amb.csc like the rest
weather_system()
{
    level endon("intermission");
    flag_wait("all_players_connected");
    
    wait(25);   // short settle time for testing

    while(1)
    {
        wait(RandomFloatRange(90, 180));

        if(RandomInt(100) < 40)
        {
            players = get_players();
            if(players.size < 1)
                continue;

            // Lightning first + quick white flash
            //iprintln("Weather system: Lightning sequence triggered.");
            players[0] thread maps\_sounds::weather_lightning_sound();
            level thread lightning_flash();   // <--- ONLY on lightning

            // Small random delay before the thunder boom
            wait(RandomFloatRange(0.4, 1.8));

            // Then thunder (NO flash)
            //iprintln("Weather system: Thunder sequence triggered.");
            players[0] thread maps\_sounds::weather_thunder_sound();
        }
    }
}

// disable if annoying
lightning_flash()
{
    fadetowhite = newhudelem();

    fadetowhite.x = 0; 
    fadetowhite.y = 0; 
    fadetowhite.alpha = 0; 

    fadetowhite.horzAlign = "fullscreen"; 
    fadetowhite.vertAlign = "fullscreen"; 
    fadetowhite.foreground = true; 
    fadetowhite SetShader( "white", 640, 480 ); 

    // Instant bright flash
    fadetowhite FadeOverTime( 0.05 );
    fadetowhite.alpha = 0.85;

    wait( 0.07 );           // hold the bright flash for a tiny moment, was 0.08

    fadetowhite FadeOverTime( 0.12 );
    fadetowhite.alpha = 0;

    wait( 0.15 );
    fadetowhite destroy();
}

// map exploit fixes
player_bounds_monitor() {
    players = get_players();

    for (i = 0; i < players.size; i++) {
        players[i] thread monitor_debris();
        players[i] thread monitor_map_bounds();
    }
}

monitor_debris() {
    self endon("disconnect");
    self endon("death");
    level endon("debris_purchased");

    couch_height_limit = 145;
    last_valid_pos = self.origin;

    while (1) {
        if (self.origin[2] > couch_height_limit) {
            self setorigin(last_valid_pos);
        }
        else {
            last_valid_pos = self.origin;
        }

        wait(0.05);
    }
}

is_within_volume(min_x, max_x, min_y, max_y, min_z, max_z) {
    if (self.origin[0] > max_x || self.origin[0] < min_x)
        return false;
    if (self.origin[1] > max_y || self.origin[1] < min_y)
        return false;
    if (self.origin[2] > max_z || self.origin[2] < min_z)
        return false;

    return true;
}

monitor_map_bounds() {
    self endon("disconnect");

    margin = 32;

    playable_areas = [];

    playable_areas[0]["min"] = (361, 591, -11);
    playable_areas[0]["max"] = (1068 - margin, 1031 - margin, 235);

    playable_areas[1]["min"] = (-288 + margin, 591, -11);
    playable_areas[1]["max"] = (361, 1160 - margin, 235);

    playable_areas[2]["min"] = (-272 + margin, 120, -11);
    playable_areas[2]["max"] = (370 - margin, 591, 235);

    playable_areas[3]["min"] = (-272 + margin, -912 + margin, -11);
    playable_areas[3]["max"] = (273 - margin, 120, 235);

    self.last_valid_pos = self.origin;

    while (1) {
        is_out = true;

        for (i = 0; i < playable_areas.size; i++) {
            if (self is_within_volume(playable_areas[i]["min"][0], playable_areas[i]["max"][0], playable_areas[i]["min"][1], playable_areas[i]["max"][1], playable_areas[i]["min"][2], playable_areas[i]["max"][2])) {
                is_out = false;
            }
        }

        if (is_out) {
            self setorigin(self.last_valid_pos);
        }
        else {
            self.last_valid_pos = self.origin;
        }

        wait(0.05);
    }
}

spawn_collision_models() {
    spawncollision("collision_geo_32x32x128", "collider", (116, -125, 160), (0, 0, 0));
    spawncollision("collision_geo_32x32x32", "collider", (376, 643, 184), (0, 0, 0));
    spawncollision("collision_geo_64x64x64", "collider", (816, 625, 12), (0, 0, 0));
    spawncollision("collision_geo_32x32x128", "collider", (222, 138, 60), (0, 0, 0)); 
    spawncollision("collision_geo_64x64x64", "collider", (-138, -159, 156), (0, 0, 0));
    spawncollision("collision_geo_64x64x64", "collider", (192, 349 ,185), (0, 0, 0));
    spawncollision("collision_geo_32x32x32", "collider", (519 ,765, 155), (0, 0, 0));
    spawncollision("collision_geo_32x32x128", "collider", (-210, 641, 218), (0, 0, 0));
    spawncollision("collision_geo_32x32x32", "collider", (142 ,-100 ,91), (0, 0, 0));
    spawncollision("collision_geo_32x32x128", "collider", (199, 117, 18), (0, 0, 0));
}
