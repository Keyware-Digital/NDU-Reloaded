#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

init()
{
	init_weapons();
	init_weapon_upgrade();
	init_weapon_cabinet();
	init_treasure_chest();
	init_mystery_box_vars();
}

add_zombie_weapon( weapon_name, hint, cost, weaponVO, variation_count, ammo_cost  )
{
	if( IsDefined( level.zombie_include_weapons ) && !IsDefined( level.zombie_include_weapons[weapon_name] ) )
	{
		return;
	}

	// Check the table first
	table = "mp/zombiemode.csv";
	table_cost = TableLookUp( table, 0, weapon_name, 1 );
	table_ammo_cost = TableLookUp( table, 0, weapon_name, 2 );

	if( IsDefined( table_cost ) && table_cost != "" )
	{
		cost = round_up_to_ten( int( table_cost ) );
	}

	if( IsDefined( table_ammo_cost ) && table_ammo_cost != "" )
	{
		ammo_cost = round_up_to_ten( int( table_ammo_cost ) );
	}

	PrecacheItem( weapon_name );
	PrecacheString( hint );

	struct = SpawnStruct();

	if( !IsDefined( level.zombie_weapons ) )
	{
		level.zombie_weapons = [];
	}

	struct.weapon_name = weapon_name;
	struct.weapon_classname = "weapon_" + weapon_name;
	struct.hint = hint;
	struct.cost = cost;
	struct.sound = weaponVO;
	struct.variation_count = variation_count;
	struct.is_in_box = level.zombie_include_weapons[weapon_name];
	
	if( !IsDefined( ammo_cost ) )
	{
		ammo_cost = round_up_to_ten( int( cost * 0.5 ) );
	}

	struct.ammo_cost = ammo_cost;

	level.zombie_weapons[weapon_name] = struct;
}

prototype_weighting_func()
{
	return 1;
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
				num_to_add += int(level.zombie_include_weapons.size*0.15);			
			}			
			// after 8 pulls the Ray Gun percentage increases to 10%
			else if( level.pulls_since_last_ray_gun > 7 )
			{
				num_to_add += int(.1 * level.zombie_include_weapons.size);
            }
        }
        return num_to_add;
    }
}

include_zombie_weapon( weapon_name, in_box, weighting_func )
{
	if( !IsDefined( level.zombie_include_weapons ) )
	{
		level.zombie_include_weapons = [];
	}

	if( !isDefined( in_box ) )
	{
		in_box = true;
	}
	
	level.zombie_include_weapons[weapon_name] = in_box;

	if( !isDefined( weighting_func ) )
	{
		level.weapon_weighting_funcs[weapon_name] = maps\_zombiemode_weapons::prototype_weighting_func;
	}
	else
	{
		level.weapon_weighting_funcs[weapon_name] = weighting_func;
	}
}

init_weapons()
{
	// Zombify
	PrecacheItem( "zombie_melee" );

	//NDU: Reloaded
	add_zombie_weapon( "zombie_bowie_flourish",					"", 										10,			/*"vox_bowie",*/	5 );
	add_zombie_weapon( "mine_bouncing_betty",					&"ZOMBIE_WEAPON_BETTY_1000",				1000 );
	add_zombie_weapon( "mp40_bigammo_mp", 						&"ZOMBIE_WEAPON_MP40_1000", 				1000 );	
	add_zombie_weapon( "springfield_scoped_zombie_upgraded",    &"ZOMBIE_WEAPON_SPRINGFIELD_S_B_750",       1500,		/*"vox_raygun",*/	6 ); 
	//add_zombie_weapon( "tesla_gun",								&"ZOMBIE_BUY_TESLA", 					10,			/*"vox_tesla",*/	5 );
	add_zombie_weapon( "thompson_bigammo_mp", 					&"PROTOTYPE_ZOMBIE_WEAPON_THOMPSON_1500", 	1500 );
	//add_zombie_weapon( "walther_prototype",                   &"ZOMBIE_WEAPON_WALTHER_50",              	50,			/*"vox_raygun",*/	6 );
	//add_zombie_weapon( "zombie_cymbal_monkey",				&"ZOMBIE_WEAPON_SATCHEL_2000", 				2000,		/*"vox_monkey",*/	3 );
	add_zombie_weapon( "zombie_ppsh",                           &"ZOMBIE_WEAPON_PPSH_2000",                 2000 );
	add_zombie_weapon( "zombie_type100_smg",                    &"ZOMBIE_WEAPON_TYPE100_1000",              1000 );
	add_zombie_weapon( "zombie_perk_bottle",               		&"PROTOTYPE_ZOMBIE_WEAPON_PERKBOTTLE_10000",			10000 );

	// Pistols
	add_zombie_weapon( "colt", 									&"ZOMBIE_WEAPON_COLT_50", 					50 );
	add_zombie_weapon( "colt_dirty_harry", 						&"ZOMBIE_WEAPON_COLT_DH_100", 				100 );
	add_zombie_weapon( "nambu", 								&"ZOMBIE_WEAPON_NAMBU_50", 					50 );
	add_zombie_weapon( "sw_357", 								&"ZOMBIE_WEAPON_SW357_100", 				100 );
	add_zombie_weapon( "tokarev", 								&"ZOMBIE_WEAPON_TOKAREV_50", 				50 );
	add_zombie_weapon( "walther", 								&"ZOMBIE_WEAPON_WALTHER_50", 				50 );
	add_zombie_weapon( "zombie_colt", 							&"ZOMBIE_WEAPON_ZOMBIECOLT_25", 			25 );
                                                        		
	// Bolt Action                                      		
	add_zombie_weapon( "kar98k", 								&"PROTOTYPE_ZOMBIE_WEAPON_KAR_98K_200", 	200 );
	add_zombie_weapon( "kar98k_bayonet", 						&"ZOMBIE_WEAPON_KAR98K_B_200", 				200 );
	add_zombie_weapon( "mosin_rifle", 							&"ZOMBIE_WEAPON_MOSIN_200", 				200 );
	add_zombie_weapon( "mosin_rifle_bayonet", 					&"ZOMBIE_WEAPON_MOSIN_B_200", 				200 );
	add_zombie_weapon( "springfield", 							&"ZOMBIE_WEAPON_SPRINGFIELD_200", 			200 );
	add_zombie_weapon( "springfield_bayonet", 					&"ZOMBIE_WEAPON_SPRINGFIELD_B_200", 		200 );
	add_zombie_weapon( "type99_rifle", 							&"ZOMBIE_WEAPON_TYPE99_200", 				200 );
	add_zombie_weapon( "type99_rifle_bayonet", 					&"ZOMBIE_WEAPON_TYPE99_B_200", 				200 );
                                                        		
	// Semi Auto                                        		
	add_zombie_weapon( "gewehr43", 								&"ZOMBIE_WEAPON_GEWEHR43_600", 				600 );
	add_zombie_weapon( "m1carbine", 							&"PROTOTYPE_ZOMBIE_WEAPON_M1_CARBINE_600",	600 );
	add_zombie_weapon( "m1carbine_bayonet", 					&"ZOMBIE_WEAPON_M1CARBINE_B_600", 			600 );
	add_zombie_weapon( "m1garand", 								&"ZOMBIE_WEAPON_M1GARAND_600", 				600 );
	add_zombie_weapon( "m1garand_bayonet", 						&"ZOMBIE_WEAPON_M1GARAND_B_600", 			600 );
	add_zombie_weapon( "svt40", 								&"ZOMBIE_WEAPON_SVT40_600", 				600 );
                                                        		
	// Grenades                                         		
	add_zombie_weapon( "fraggrenade", 							&"ZOMBIE_WEAPON_FRAGGRENADE_250", 			250 );
	add_zombie_weapon( "molotov", 								&"ZOMBIE_WEAPON_MOLOTOV_200", 				200 );
	add_zombie_weapon( "stick_grenade", 						&"ZOMBIE_WEAPON_STICKGRENADE_250", 			250 );
	add_zombie_weapon( "stielhandgranate", 						&"PROTOTYPE_ZOMBIE_WEAPON_STIELHANDGRANATE_250", 		250 );
	add_zombie_weapon( "type97_frag", 							&"ZOMBIE_WEAPON_TYPE97FRAG_250", 			250 );

	// Scoped
	add_zombie_weapon( "kar98k_scoped_zombie", 					&"ZOMBIE_WEAPON_KAR98K_S_750", 				1500 );
	add_zombie_weapon( "kar98k_scoped_bayonet_zombie", 			&"ZOMBIE_WEAPON_KAR98K_S_B_750", 			750 );
	add_zombie_weapon( "mosin_rifle_scoped_zombie", 			&"ZOMBIE_WEAPON_MOSIN_S_750", 				750 );
	add_zombie_weapon( "mosin_rifle_scoped_bayonet_zombie", 	&"ZOMBIE_WEAPON_MOSIN_S_B_750", 			750 );
	add_zombie_weapon( "ptrs41_zombie", 						&"ZOMBIE_WEAPON_PTRS41_750", 				750 );
	add_zombie_weapon( "springfield_scoped_zombie", 			&"ZOMBIE_WEAPON_SPRINGFIELD_S_750", 		750 );
	add_zombie_weapon( "springfield_scoped_bayonet_zombie", 	&"ZOMBIE_WEAPON_SPRINGFIELD_S_B_750", 		750 );
	add_zombie_weapon( "type99_rifle_scoped_zombie", 			&"ZOMBIE_WEAPON_TYPE99_S_750", 				750 );
	add_zombie_weapon( "type99_rifle_scoped_bayonet_zombie", 	&"ZOMBIE_WEAPON_TYPE99_S_B_750", 			750 );
                                                                                                	
	// Full Auto                                                                                	
	add_zombie_weapon( "mp40", 								&"ZOMBIE_WEAPON_MP40_1000", 				1000 );
	add_zombie_weapon( "ppsh", 								&"ZOMBIE_WEAPON_PPSH_2000", 				2000 );
	add_zombie_weapon( "stg44", 							&"ZOMBIE_WEAPON_STG44_1200", 				1200 );
	add_zombie_weapon( "thompson", 							&"PROTOTYPE_ZOMBIE_WEAPON_THOMPSON_1500", 	1500 );
	add_zombie_weapon( "type100_smg", 						&"ZOMBIE_WEAPON_TYPE100_1000", 				1000 );
                                                        	
	// Shotguns                                         	
	add_zombie_weapon( "doublebarrel", 						&"PROTOTYPE_ZOMBIE_WEAPON_DOUBLEBARREL_1200", 			1200 );
	add_zombie_weapon( "doublebarrel_sawed_grip", 			&"PROTOTYPE_ZOMBIE_WEAPON_DOUBLEBARREL_SAWED_1200", 	1200 );
	add_zombie_weapon( "shotgun", 							&"PROTOTYPE_ZOMBIE_WEAPON_SHOTGUN_1500", 				1500 );
                                                        	
	// Heavy Machineguns                                	
	add_zombie_weapon( "30cal", 							&"ZOMBIE_WEAPON_30CAL_3000", 				3000 );
	add_zombie_weapon( "bar", 								&"PROTOTYPE_ZOMBIE_WEAPON_BAR_1800", 		1800 );
	add_zombie_weapon( "dp28", 								&"ZOMBIE_WEAPON_DP28_2250", 				2250 );
	add_zombie_weapon( "fg42", 								&"ZOMBIE_WEAPON_FG42_1200", 				1500 );
	add_zombie_weapon( "fg42_scoped", 						&"ZOMBIE_WEAPON_FG42_S_1200", 				1500 );
	add_zombie_weapon( "mg42", 								&"ZOMBIE_WEAPON_MG42_1200", 				3000 );
	add_zombie_weapon( "type99_lmg", 						&"ZOMBIE_WEAPON_TYPE99_LMG_1750", 			1750 );
                                                        	
	// Grenade Launcher                                 	
	add_zombie_weapon( "m1garand_gl", 						&"ZOMBIE_WEAPON_M1GARAND_GL_1200", 			1200 );
	add_zombie_weapon( "mosin_launcher", 					&"ZOMBIE_WEAPON_MOSIN_GL_1200", 			1200 );
	                                        				
	// Bipods                               				
	add_zombie_weapon( "30cal_bipod", 						&"ZOMBIE_WEAPON_30CAL_BIPOD_3500", 			3500 );
	add_zombie_weapon( "bar_bipod", 						&"ZOMBIE_WEAPON_BAR_BIPOD_2500", 			2500 );
	add_zombie_weapon( "dp28_bipod", 						&"ZOMBIE_WEAPON_DP28_BIPOD_2500", 			2500 );
	add_zombie_weapon( "fg42_bipod", 						&"ZOMBIE_WEAPON_FG42_BIPOD_2000", 			2000 );
	add_zombie_weapon( "mg42_bipod", 						&"ZOMBIE_WEAPON_MG42_BIPOD_3250", 			3250 );
	add_zombie_weapon( "type99_lmg_bipod", 					&"ZOMBIE_WEAPON_TYPE99_LMG_BIPOD_2250", 	2250 );
	
	// Rocket Launchers
	add_zombie_weapon( "bazooka", 							&"ZOMBIE_WEAPON_BAZOOKA_2000", 				2000 );
	add_zombie_weapon( "panzerschrek", 						&"ZOMBIE_WEAPON_PANZERSCHREK_2000", 		2000 );
	                                                    	
	// Flamethrower                                     	
	add_zombie_weapon( "m2_flamethrower_zombie", 			&"ZOMBIE_WEAPON_M2_FLAMETHROWER_3000", 		3000 );	
                                                        	
	// Special                                          	
	add_zombie_weapon( "mortar_round", 						&"ZOMBIE_WEAPON_MORTARROUND_2000", 			2000 );
	add_zombie_weapon( "satchel_charge", 					&"ZOMBIE_WEAPON_SATCHEL_2000", 				2000 );
	add_zombie_weapon( "ray_gun", 							&"ZOMBIE_WEAPON_RAYGUN_10000", 				10000,		/*"vox_raygun",*/		6 );                                   	
	
	// Precache the box padlock
	PrecacheModel("p6_anim_zm_al_magic_box_lock");
	
	// ONLY 1 (OR MORE) OF THE BELOW SHOULD BE ALLOWED
	add_limited_weapon( "m2_flamethrower_zombie", 1 );
}             

add_limited_weapon( weapon_name, amount )
{
	if( !IsDefined( level.limited_weapons ) )
	{
		level.limited_weapons = [];
	}

	level.limited_weapons[weapon_name] = amount;
}                                          	

// For buying weapon upgrades in the environment
init_weapon_upgrade()
{
	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" ); 

	for( i = 0; i < weapon_spawns.size; i++ )
	{
		hint_string = get_weapon_hint( weapon_spawns[i].zombie_weapon_upgrade ); 

		weapon_spawns[i] SetHintString( hint_string ); 
		weapon_spawns[i] setCursorHint( "HINT_NOICON" ); 
		weapon_spawns[i] UseTriggerRequireLookAt();

		weapon_spawns[i] thread weapon_spawn_think(); 
		model = getent( weapon_spawns[i].target, "targetname" ); 
		model hide(); 
	}
}

// weapon cabinets which open on use 
// V2
init_weapon_cabinet()
{
    // the triggers which are targeted at doors
    level.weapon_cabs = GetEntArray( "weapon_cabinet_use", "targetname" ); 
    
    for( i = 0; i < level.weapon_cabs.size; i++ )
    {
        level.weapon_cabs[i] setCursorHint( "HINT_NOICON" ); 
        level.weapon_cabs[i] UseTriggerRequireLookAt();
    }
    level.keep_ents = [];
    array_thread( level.weapon_cabs, ::weapon_cabinet_think ); 
}

init_mystery_box_vars() {
	set_zombie_var("zombie_mystery_box_padlock", 0);

}

// returns the trigger hint string for the given weapon
get_weapon_hint( weapon_name )
{
	AssertEx( IsDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon_name].hint;
}

get_weapon_cost( weapon_name )
{
	AssertEx( IsDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon_name].cost;
}

get_ammo_cost( weapon_name )
{
	AssertEx( IsDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon_name].ammo_cost;
}

get_is_in_box( weapon_name )
{
	AssertEx( IsDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );
	
	return level.zombie_weapons[weapon_name].is_in_box;
}

// for the random weapon chest
init_treasure_chest()
{
	// the triggers which are targeted at chests
	level.chests = GetEntArray( "treasure_chest_use", "targetname" ); 

	level.chest_accessed = 0;

	array_thread( level.chests, ::treasure_chest_think ); 
}

set_treasure_chest_cost( cost )
{
	level.zombie_treasure_chest_cost = cost;
}

treasure_chest_think(rand)
{
	cost = 950;

	if( IsDefined( level.zombie_treasure_chest_cost ) )
	{
		cost = level.zombie_treasure_chest_cost;
	}

	self SetHintString(&"PROTOTYPE_ZOMBIE_RANDOM_WEAPON_950");
	self setCursorHint( "HINT_NOICON" );

	if(isDefined(level.zombie_vars["zombie_fire_sale"]) && level.zombie_vars["zombie_fire_sale"])
	{
		self SetHintString(&"PROTOTYPE_ZOMBIE_RANDOM_WEAPON_10");
	}

	if(isDefined(level.zombie_vars["zombie_mystery_box_padlock"]) && level.zombie_vars["zombie_mystery_box_padlock"])
	{
		self SetHintString(&"PROTOTYPE_ZOMBIE_RANDOM_WEAPON_LOCKED_950");
	}	

	// waittill someuses uses this
	user = undefined;
	while( 1 )
	{
		self waittill( "trigger", user ); 

		if( user in_revive_trigger() )
		{
			wait( 0.1 );
			continue;
		}
		
		// make sure the user is a player, and that they can afford it
		if( is_player_valid( user ) && user.score >= level.zombie_treasure_chest_cost )
		{
			user maps\_zombiemode_score::minus_to_player_score( level.zombie_treasure_chest_cost ); 
			break; 
		}
		
		wait 0.05; 
	}
	
	// trigger_use->script_brushmodel lid->script_origin in radiant
	level.lid = getent( self.target, "targetname" ); 
	weapon_spawn_org = getent( level.lid.target, "targetname" ); 
	
	//open the lid
	level.lid thread treasure_chest_lid_open();
	
	// SRS 9/3/2008: added to help other functions know if we timed out on grabbing the item
	self.timedOut = false;
	
	// mario kart style weapon spawning
	weapon_spawn_org thread treasure_chest_weapon_spawn( self, user ); 
	
	// the glowfx	
	weapon_spawn_org thread treasure_chest_glowfx(); 
	
	// take away usability until model is done randomizing
	self disable_trigger(); 
	
	weapon_spawn_org waittill( "randomization_done" ); 

	self.grab_weapon_hint = true;

	level thread treasure_chest_user_hint( self, user );

	//Commence hintstring switch for each weapon in the mystery box

	switch(weapon_spawn_org.weapon_string)
		{
		case "mosin_rifle":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_MOSIN");
			break; 
		case "dp28":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_DP_27");
			break; 
		case "svt40":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_SVT_40");
			break;
		case "type99_lmg":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_TYPE_99");
			break;
		case "zombie_ppsh":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_PPSH_41");
			break;
		case "zombie_type100_smg":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_TYPE_100");
			break; 
		case "colt":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_COLT");
			break;     
		case "sw_357":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_SW357");
			break;  
		case "tokarev":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_TOKAREV");
			break;  
		case "gewehr43":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_GEWEHR_43");
			break;  
		case "stg44":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_STG_44");
			break;  
		case "thompson":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_THOMPSON");
			break;  
		case "mp40":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_MP_40");
			break;  
		case "springfield":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_SPRINGFIELD");
			break;  
		case "ptrs41_zombie":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_PTRS_41");
			break;  
		case "molotov":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_MOLOTOV");
			break;
		case "m1garand_gl":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_M1_GARAND_GL");
			break;  
		case "m2_flamethrower_zombie":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_M2_FLAMETHROWER");
			break;  
		case "doublebarrel":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_DOUBLEBARREL");
			break;  
		case "doublebarrel_sawed_grip":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_DOUBLEBARRELSAWED");
			break; 
		case "shotgun":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_SHOTGUN");
			break; 
		case "bar":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_BAR");
			break; 
		case "fg42_bipod":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_FG_42");
			break; 
		case "mg42_bipod":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_MG_42");
			break; 
		case "30cal_bipod":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_30_CAL_BIPOD");
			break; 
		case "panzerschrek":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_PANZERSCHREK");
			break; 
		case "ray_gun":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_RAY_GUN");
			break; 
		case "mine_bouncing_betty":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_MINE");
			break; 
		case "zombie_bowie_flourish":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_BOWIE_KNIFE");
			break;
		}
	
	self setCursorHint( "HINT_NOICON" ); 
	
	self enable_trigger(); 
	self thread treasure_chest_timeout();
	
	// make sure the guy that spent the money gets the item
	// SRS 9/3/2008: ...or item goes back into the box if we time out
	while( 1 )
	{
		self waittill( "trigger", grabber ); 

		if( grabber == user || grabber == level )
		{
			if( grabber == user && is_player_valid( user ) && user GetCurrentWeapon() != "mine_bouncing_betty" )
			{
				self notify( "user_grabbed_weapon" );
				if(weapon_spawn_org.weapon_string == "zombie_bowie_flourish")
				{
					if(!user hasperk("specialty_altmelee" || user.has_altmelee))
					{
						weapon_spawn_org notify("weapon_grabbed");
						level.lid thread treasure_chest_lid_close( self.timedOut );
						self.grab_weapon_hint = false;
						self disable_trigger();
						user maps\_zombiemode_bowie::give_bowie();
						break;
					}
					break;
				}
				else
				{
					user thread treasure_chest_give_weapon( weapon_spawn_org.weapon_string );
					break;
				}
			}
			else if( grabber == level )
			{
				// it timed out
				self.timedOut = true;
				break;
			}
		}

		wait 0.05; 
	}

	if(weapon_spawn_org.weapon_string != "zombie_bowie_flourish")
	{
		self.grab_weapon_hint = false;
		weapon_spawn_org notify( "weapon_grabbed" );
		level.lid thread treasure_chest_lid_close( self.timedOut );
		self disable_trigger();
		wait 3;
	}
	self enable_trigger(); 	
	self thread treasure_chest_think(); 
}

treasure_chest_user_hint( trigger, user )
{
	dist = 128 * 128;
	while( 1 )
	{
		if( !IsDefined( trigger ) )
		{
			break;
		}

		if( trigger.grab_weapon_hint )
		{
			break;
		}

		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] == user )
			{
				continue;
			}

			if( DistanceSquared( players[i].origin, trigger.origin ) < dist )
			{
				players[i].ignoreTriggers = true;
			}
		}

		wait( 0.1 );
	}
}

treasure_chest_timeout()
{
	self endon( "user_grabbed_weapon" );
	
	wait( 12 );
	self notify( "trigger", level ); 
}

treasure_chest_lid_open()
{
	openRoll = 105;
	openTime = 0.5;
	
	self RotateRoll( 105, openTime, ( openTime * 0.5 ) );
	
	play_sound_at_pos( "open_chest", self.origin );
	play_sound_at_pos( "music_chest", self.origin );
}

treasure_chest_lid_close( timedOut )
{
	closeRoll = -105;
	closeTime = 0.5;
	
	self RotateRoll( closeRoll, closeTime, ( closeTime * 0.5 ) );
	play_sound_at_pos( "close_chest", self.origin );
}

treasure_chest_ChooseRandomWeapon( player )
{
    keys = GetArrayKeys( level.zombie_weapons );
 
    // Filter out any weapons the player already has
    filtered = [];
    for( i = 0; i < keys.size; i++ )
    {
        if( player HasWeapon( keys[i] ) )
        {
            continue;
        }
 
        filtered[filtered.size] = keys[i];
    }
 
    // Filter out the limited weapons
    if( IsDefined( level.limited_weapons ) )
    {
        keys2 = GetArrayKeys( level.limited_weapons );
        players = get_players();
        for( q = 0; q < keys2.size; q++ )
        {
            count = 0;
            for( i = 0; i < players.size; i++ )
            {
                if( players[i] HasWeapon( keys2[q] ) )
                {
                    count++;
                }
            }
 
            if( count == level.limited_weapons[keys2[q]] )
            {
                filtered = array_remove( filtered, keys2[q] );
            }
        }
    }
	
	// Filter molotov's if player has them.
    if(isDefined(player.has_molotovs) && player.has_molotovs)
    {
        filtered = array_remove(filtered, "molotov");
    }

	// Filter betty's if player has them.
    if(isDefined(player.has_betties) && player.has_betties)
    {
        filtered = array_remove(filtered, "mine_bouncing_betty");
    }

	// Filter bowie if player has it
	if(player HasPerk( "specialty_altmelee" ))
	{
    	filtered = array_remove(filtered, "zombie_bowie_flourish");
	}
 
    return filtered[RandomInt( filtered.size )];
}

treasure_chest_ChooseWeightedRandomWeapon( player )
{

	keys = GetArrayKeys( level.zombie_weapons );

	// Filter out any weapons the player already has
	filtered = [];
	for( i = 0; i < keys.size; i++ )
	{
		if( !get_is_in_box( keys[i] ) )
		{
			continue;
		}
		
		if( player has_weapon_or_upgrade( keys[i] ) )
		{
			continue;
		}

		if( !IsDefined( keys[i] ) )
		{
			continue;
		}

		num_entries = [[ level.weapon_weighting_funcs[keys[i]] ]]();
		
		for( j = 0; j < num_entries; j++ )
		{
			filtered[filtered.size] = keys[i];
		}
	}
}

mystery_box_padlock() {

    level.zombie_vars["zombie_mystery_box_padlock"] = 1;

    for(i=0;i<level.chests.size;i++) {
    level.chests[i] SetHintString( &"PROTOTYPE_ZOMBIE_RANDOM_WEAPON_LOCKED_950" );
    wait 0.05;
    }
}

treasure_chest_weapon_spawn( chest, player )
{
    assert(IsDefined(player));
    // spawn the model
    model = spawn( "script_model", self.origin ); 
    model.angles = self.angles +( 0, 90, 0 );
 
    floatHeight = 40;
 
    //move it up
    model moveto( model.origin +( 0, 0, floatHeight ), 3, 2, 0.9 ); 
 
    // rotation would go here
 
    // make with the mario kart
    modelname = undefined; 
    rand = undefined; 
    for( i = 0; i < 40; i++ )
    {
        rand = treasure_chest_ChooseRandomWeapon( player );
        modelname = GetWeaponModel( rand );
        model setmodel( modelname ); 
 
        if( i < 20 )
        {
            wait( 0.05 ); 
        }
        else if( i < 30 )
        {
            wait( 0.1 ); 
        }
        else if( i < 35 )
        {
            wait( 0.2 ); 
        }
        else if( i < 38 )
        {
            wait( 0.3 ); 
        }
        modelname = GetWeaponModel( rand );
        model setmodel( modelname ); 
    }
 
	if(rand == "molotov")
    {
        player thread weapons_death_check();
    }

    if(rand == "mine_bouncing_betty")
    {
        player thread weapons_death_check();
    }

    if(rand == "zombie_bowie_flourish")
    {
        player thread weapons_death_check();
    }
 
	self.weapon_string = rand; // here's where the org get it's weapon type for the give function

	// random change of getting the joker that moves the box
	random = Randomint(100);
	chance_of_padlock = Randomint(100);

	// random change of getting the joker that moves the box

	//increase the chance of joker appearing from 0-100.

		if(!isDefined(level.zombie_vars["zombie_mystery_box_padlock"]) || !level.zombie_vars["zombie_mystery_box_padlock"])
		{
			if(level.chest_accessed)
			{		
				// PI_CHANGE_BEGIN - JMA - RandomInt(100) can return a number between 0-99.  If it's zero and chance_of_padlock is zero
				//									we can possibly have a padlock one after another.
				chance_of_padlock = -1;
				// PI_CHANGE_END
			}
			else
			{
				chance_of_padlock = level.chest_accessed + 20;
				
				// make sure padlock appears on the 8th pull if it hasn't moved from the initial spot
				if(level.chest_accessed >= 8)
				{
					chance_of_padlock = 100;
				}
				
				// pulls 4 thru 8, there is a 15% chance of getting the padlock
				// NOTE:  this happens in all cases
				if( level.chest_accessed >= 4 && level.chest_accessed < 8 )
				{
					if( random < 15 )
					{
						chance_of_padlock = 100;
					}
					else
					{
						chance_of_padlock = -1;
					}
				}
				
				// after the first magic box move the padlock percentages changes
				if(level.zombie_vars[ "enableFireSale" ] == 1)
				{
					// between pulls 8 thru 12, the padlock percent is 30%
					if( level.chest_accessed >= 8 && level.chest_accessed < 13 )
					{
						if( random < 30 )
						{
							chance_of_padlock = 100;
						}
						else
						{
							chance_of_padlock = -1;
						}
					}
					
					// after 12th pull, the padlock percent is 50%
					if( level.chest_accessed >= 13 )
					{
						if( random < 50 )
						{
							chance_of_padlock = 100;
						}
						else
						{
							chance_of_padlock = -1;
						}
					}
				}
			}

			if (random <= chance_of_padlock) // numan edit
			{
				if(!isdefined(level.zombie_vars["zombie_mystery_box_padlock"]) || !level.zombie_vars["zombie_mystery_box_padlock"])
				{


					model setmodel( "p6_anim_zm_al_magic_box_lock" );

					self thread mystery_box_padlock();

					for(i=0;i<level.chests.size;i++) {
    					level.chests[i] enable_trigger();
    				wait 0.05;
    				}

					PlaySoundAtPosition("mysterybox_lock", self.origin);
					PlaySoundAtPosition("la_vox", self.origin);

					model.angles = self.angles;		
					wait 1;

					cost = 1500;

					for(i=0;i<level.chests.size;i++) {
						level.chests[i] waittill( "trigger" , player );
						if(player.score < cost)
    					{
    						self play_sound_on_ent( "no_purchase" );
    						wait 0.5;
    						self thread mystery_box_padlock();
    						return;
    					}
    					else
    					{
							level.chests[i] disable_trigger();
							player maps\_zombiemode_score::minus_to_player_score(cost);
							play_sound_on_ent( "purchase" );
							level.lid thread treasure_chest_lid_close();
							model Delete();
							level.zombie_vars["zombie_mystery_box_padlock"] = 0;
							level.chest_accessed = 0;
							level.zombie_vars[ "enableFireSale" ] = 1;
							level.chests[i] enable_trigger(); 	
							level.chests[i] thread treasure_chest_think(); 
							return;
						}
    				wait 0.05;
    				}
				}
			}
		}

	self notify( "randomization_done" );

    model thread timer_til_despawn(floatHeight);
    self waittill( "weapon_grabbed" );
 
    if( !chest.timedOut )
    {
        model Delete();
    }
 
    return rand;
}
 
weapons_death_check() // numan - reset the betties var on death ( may be used for other offhand vars if needed )
{
    self waittill_any( "fake_death", "death" );
 
	self.has_molotovs = undefined;
    self.has_betties = undefined;
	self.has_altmelee = undefined;
}
	// SRS 9/3/2008: if we timed out, move the weapon back into the box instead of deleting it
timer_til_despawn(floatHeight)
{
	putBackTime = 12;
	self MoveTo( self.origin - ( 0, 0, floatHeight ), putBackTime, ( putBackTime * 0.5 ) );
	wait( putBackTime );

	if(isdefined(self))
	{	
		self Delete();
	}
}

treasure_chest_glowfx()
{
	fxObj = spawn( "script_model", self.origin +( 0, 0, 0 ) ); 
	fxobj setmodel( "tag_origin" ); 
	fxobj.angles = self.angles +( 90, 0, 0 ); 
	
	playfxontag( level._effect["chest_light"], fxObj, "tag_origin"  ); 

	self waittill( "weapon_grabbed" ); 
	
	fxobj delete(); 
}

// self is the player string comes from the randomization function
treasure_chest_give_weapon( weapon_string )
{
	primaryWeapons = self GetWeaponsListPrimaries(); 
	current_weapon = undefined; 

	// This should never be true for the first time.
	if( primaryWeapons.size >= 2 ) // he has two weapons
	{
		current_weapon = self getCurrentWeapon(); // get his current weapon
		
		if ( current_weapon == "mine_bouncing_betty" )
		{
			current_weapon = undefined;
		}

		if ( current_weapon == "zombie_bowie_flourish" )
		{
			current_weapon = undefined;
		}

		if( isdefined( current_weapon ) )
		{
			if( !( weapon_string == "fraggrenade" || weapon_string == "stielhandgranate" || weapon_string == "molotov" ) )
			self TakeWeapon( current_weapon ); 
		} 
	} 

	if(( weapon_string ==  "ray_gun" ))
	{
		thread play_raygun_stinger();
	}

	if( IsDefined( primaryWeapons ) && !isDefined( current_weapon ) )
	{
		for( i = 0; i < primaryWeapons.size; i++ )
		{
			if( primaryWeapons[i] == "colt" || primaryWeapons[i] == "walther" || primaryWeapons[i] == "tokarev" )
			{
				continue; 
			}

			if( weapon_string != "fraggrenade" && weapon_string != "stielhandgranate" && weapon_string != "molotov" )
			{
				self TakeWeapon( primaryWeapons[i] ); 
			}
		}
	}
	
	if( weapon_string == "mine_bouncing_betty" )
	{
		self maps\_zombiemode_betty::bouncing_betty_setup( self );
		return;
	}

	if( weapon_string == "zombie_bowie_flourish" )
	{
		self maps\_zombiemode_bowie::bowie_think( self );
		return;
	}

	self play_sound_on_ent( "purchase" ); 

	self GiveWeapon( weapon_string, 0 );
	self GiveMaxAmmo( weapon_string );
	self SwitchToWeapon( weapon_string ); 
}

// NDU: Reloaded's Mystery Box 2.0
weapon_cabinet_think()
{

	cost = 1900;	//costs twice as much as the regular mystery box

	if( IsDefined( level.zombie_weapon_cabinet_cost ) )
	{
		cost = level.zombie_weapon_cabinet_cost;
	}

	self SetHintString(&"PROTOTYPE_ZOMBIE_CABINET_OPEN_1900");
	self setCursorHint( "HINT_NOICON" );

	if(isDefined(level.zombie_vars["zombie_fire_sale"]) && level.zombie_vars["zombie_fire_sale"])
	{
		self SetHintString(&"PROTOTYPE_ZOMBIE_CABINET_OPEN_20");
	}

	level.cabinetguns = [];
	level.cabinetguns[0] = "kar98k_scoped_zombie";						//default
	level.cabinetguns[1] = "kar98k_bayonet";	
	level.cabinetguns[2] = "m1garand";		
	level.cabinetguns[3] = "mosin_rifle_scoped_zombie";						
	level.cabinetguns[4] = "mosin_rifle_bayonet";
	level.cabinetguns[5] = "mp40_bigammo_mp";
	level.cabinetguns[6] = "springfield_scoped_zombie_upgraded";
	level.cabinetguns[7] = "thompson_bigammo_mp";
	//level.cabinetguns[8] = "walther_prototype";
	//level.cabinetguns[8] = "placeholdergun";
	//level.cabinetguns[9] = "placeholdergun";
	//level.cabinetguns[10] = "type100smg_bigammo_mp";					//removed because glitched!
	randomnumb = undefined;
	
    doors = getentarray( self.target, "targetname" );
    for( i = 0; i < doors.size; i++ )
    {
        doors[i] NotSolid();
    }

    //////////////////////// Horrible Script ////////////////////////
    /////////////////////////////////////////////////////////////////


    flag_wait("all_players_connected");
    if(!isdefined(level.cabinetthinkdone) || level.cabinetthinkdone == 0) // please for the love of god only do this once
	{
		all_ents = GetEntArray("script_model","classname"); // i really hate this way of doing it but im not good enough to see another way currently
		for(i=0;i<all_ents.size;i++)
		{
			if(all_ents[i].model == "weapon_mp_kar98_scoped_rifle")
			{
				level.keep_ents = array_insert(level.keep_ents,all_ents[i],level.keep_ents.size);
			}
			wait 0.05;
		}
		level.cabinetthinkdone = 1;
	}

	/////////////////// Horrible Script Over ////////////////////////
	/////////////////// You're safe for now /////////////////////////

	self waittill("trigger",player);

	for(i=0;i<level.keep_ents.size;i++) // do cool floaty thing to both models
    {
        level.keep_ents[i] Show();
        if(i == 0)
        {
            coord = -10;
            self thread movecabinetguns(level.keep_ents[i],coord);
        }
        if(i == 1)
        {
            coord = 10;
            self thread movecabinetguns(level.keep_ents[i],coord);
        }
    }

	if(player.score < level.zombie_weapon_cabinet_cost)
    {
    	self play_sound_on_ent( "no_purchase" );
    	wait 0.5;
    	self thread weapon_cabinet_think();
    	return;
    }
    else
    {
		player maps\_zombiemode_score::minus_to_player_score(level.zombie_weapon_cabinet_cost);
		//play_sound_on_ent( "purchase" );
	}

	plyweapons = player GetWeaponsListPrimaries();
	level.cabinetguns = array_exclude(level.cabinetguns, plyweapons);

	self SetHintString( "" ); 

	weaponmodelstruct = Spawn("script_model",(self.origin - (20,0,6.5)));
	weaponmodelstruct RotateTo((-90,90,0),0.1);
	weaponmodelstruct Hide();

	wait 0.1;

	weaponmodel = GetWeaponModel( level.cabinetguns[randomint(level.cabinetguns.size)] );
	weaponmodelstruct SetModel(weaponmodel);

	weaponmodelstruct Show();

	for( i = 0; i < doors.size; i++ )
	{
		if( doors[i].model == "dest_test_cabinet_ldoor_dmg0" )
		{
			doors[i] thread weapon_cabinet_door_open( "left" ); 
		}
		else if( doors[i].model == "dest_test_cabinet_rdoor_dmg0" )
		{
			doors[i] thread weapon_cabinet_door_open( "right" ); 
		}
	}

	weaponmodelstruct MoveTo(self.origin - (0,0,6.5),4,0,4);

	cabinetsong = "cabinetbox_sting_" + RandomInt(2);
	cabinetlaugh = "cabinetbox_lottery_laugh";

	play_sound_at_pos( "open_chest", self.origin );
	PlaySoundAtPosition(cabinetsong,self.origin);
	PlaySoundAtPosition(cabinetlaugh,self.origin);

	self thread cabinet_glowfx();
	
	for( i = 0; i < 40; i++ )
	{

		weaponmodel = GetWeaponModel( level.cabinetguns[randomint(level.cabinetguns.size)] );
		weaponmodelstruct SetModel(weaponmodel);

		
		if( i < 20 )
		{
			wait( 0.05 ); 
		}
		else if( i < 30 )
		{
			wait( 0.1 ); 
		}
		else if( i < 35 )
		{
			wait( 0.2 ); 
		}
		else if( i < 38 )
		{
			wait( 0.3 ); 
		}

		randomnumb = level.cabinetguns[randomint(level.cabinetguns.size)];
		weaponmodel = GetWeaponModel( randomnumb );
		weaponmodelstruct SetModel(weaponmodel);

	}

	chosenweapon = randomnumb;

	//Commence hintstring switch for each weapon in the cabinet

	switch( chosenweapon )
		{
		case "kar98k_scoped_zombie":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_KAR_98K_SCOPED");
			break; 
		case "kar98k_bayonet":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_KAR_98K_BAYONET");
			break; 
		case "m1garand":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_M1_GARAND");
			break; 
		case "mosin_rifle_bayonet":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_MOSIN_RIFLE_BAYONET");
			break; 
		case "mosin_rifle_scoped_zombie":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_MOSIN_RIFLE_SCOPED");
			break;
		case "mp40_bigammo_mp":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_MP_40_MAG");
			break;
		case "springfield_scoped_zombie_upgraded":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_SPRINGFIELD_SCOPED_UPGRADED");
			break; 
		case "thompson_bigammo_mp":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_THOMPSON_MAG");
			break;     
		case "walther_prototype":
			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_WALTHER");
			break;  
		}

	for(i=0;i<level.keep_ents.size;i++)
    {
        level.keep_ents[i] Hide();
    }

	if(!isdefined(player.perknum) || player.perknum < 11)	//check if player has max perks
	{
		magicnum = RandomInt(100);
		if(magicnum <= 10)	//10 out of 100 chance to get a perk
		{
			weaponmodelstruct SetModel(GetWeaponModel( "zombie_perk_bottle" ));
			chosenweapon = "zombie_perk_bottle";
			self SetHintString(&"PROTOTYPE_ZOMBIE_WEAPON_PERKBOTTLE_10000");
		}
	}

	weaponmodelstruct MoveTo(self.origin - (20,0,6.5),10);

	self thread takenweapon(chosenweapon);
	self thread waitforexpire();

	self waittill_any("weapontaken","weaponexpired");

	self SetHintString( "" ); 

	weaponmodelstruct Hide();

	play_sound_at_pos( "close_chest", self.origin );
	for( i = 0; i < doors.size; i++ )
	{
		if( doors[i].model == "dest_test_cabinet_ldoor_dmg0" )
		{
			doors[i] thread weapon_cabinet_door_close( "left" ); 
		}
		else if( doors[i].model == "dest_test_cabinet_rdoor_dmg0" )
		{
			doors[i] thread weapon_cabinet_door_close( "right" ); 
		}
	}

	self SetHintString("");

	wait 3;
	self thread weapon_cabinet_think();

	chosenweapon = undefined;
	weaponmodel = undefined;
	weaponmodelstruct Delete();
}

movecabinetguns( cabinetmodel, coord)
{
    self endon("weapontaken");
    self endon("weaponexpired");

    cabinetmodel MoveTo(self.origin - (20,coord,5.5),0.05);

    for( i = 0; i < 35; i++ )
    {

        cabinetmodel SetModel(GetWeaponModel(level.cabinetguns[RandomInt(level.cabinetguns.size)]));
        
        if( i < 20 )
        {
            wait( 0.05 ); 
        }
        else if( i < 30 )
        {
            wait( 0.1 ); 
        }
        else if( i < 35 )
        {
            wait( 0.2 ); 
        }
        else if( i < 38 )
        {
            wait( 0.3 ); 
        }
        cabinetmodel SetModel(GetWeaponModel(level.cabinetguns[RandomInt(level.cabinetguns.size)]));
    }
}

play_raygun_stinger()
{
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] PlaySound("raygun_stinger");
	}
}

cabinet_glowfx()
{
	fxObj = spawn( "script_model", self.origin -( 0, 0, 30 ) ); 
	fxobj setmodel( "tag_origin" ); 
	fxobj.angles = self.angles +( 90, 0, 0 ); 
	
	playfxontag( level._effect["chest_light"], fxObj, "tag_origin"  ); 

	self waittill_any("weapontaken","weaponexpired");
	
	fxobj delete(); 
}

waitforexpire()
{
	self endon("weapontaken");
	wait 8;
	self notify("weaponexpired");
}

takenweapon(chosenweapon)
{
	self endon("weaponexpired");

	self waittill("trigger",player);
	self play_sound_on_ent( "purchase" ); 
	self notify("weapontaken");

	if(chosenweapon == "zombie_perk_bottle")
	{
		//thread play_raygun_stinger();		//We don't want the stinger sound for a perk bottle.
		current_weapon = player GetCurrentWeapon();
		player DisableOffhandWeapons();
		player DisableWeaponCycling();
		player GiveWeapon(chosenweapon);
		player SwitchToWeapon(chosenweapon);
		wait 2.5;
		player TakeWeapon(chosenweapon);
		player EnableWeaponCycling();
		player SwitchToWeapon(current_weapon);
		player EnableOffhandWeapons();
		player thread maps\_zombiemode_perks::random_perk_powerup_think();
		return;
	}

	if(chosenweapon == "springfield_scoped_zombie_upgraded" )
	{
		thread play_raygun_stinger();
	}

	plyweapons = player GetWeaponsListPrimaries();
	if(plyweapons.size >= 2)
	{
		if(player GetCurrentWeapon() == "mine_bouncing_betty")
		{
			player TakeWeapon(plyweapons[0]);
		}
		else
		{
			player TakeWeapon(player GetCurrentWeapon());
		}
	}
	player GiveWeapon(chosenweapon);
	player SwitchToWeapon(chosenweapon);
}

weapon_cabinet_door_open( left_or_right )
{
	if( left_or_right == "left" )
	{
		self rotateyaw( 120, 0.3, 0.2, 0.1 ); 	
	}
	else if( left_or_right == "right" )
	{
		self rotateyaw( -120, 0.3, 0.2, 0.1 ); 	
	}	
}

weapon_cabinet_door_close( left_or_right )
{
	if( left_or_right == "left" )
	{
		self rotateyaw( -120, 0.3, 0.2, 0.1 ); 	
	}
	else if( left_or_right == "right" )
	{
		self rotateyaw( 120, 0.3, 0.2, 0.1 ); 	
	}	
}

weapon_spawn_think()
{
	cost = get_weapon_cost( self.zombie_weapon_upgrade );
	ammo_cost = get_ammo_cost( self.zombie_weapon_upgrade );
	is_grenade = (WeaponType( self.zombie_weapon_upgrade ) == "grenade");


	self.first_time_triggered = false; 
	for( ;; )
	{
		self waittill( "trigger", player ); 		
		// if not first time and they have the weapon give ammo
		
		if( !is_player_valid( player ) )
		{
			player thread ignore_triggers( 0.5 );
			continue;
		}

		if( player in_revive_trigger() )
		{
			wait( 0.1 );
			continue;
		}
		
		player_has_weapon = false; 
		weapons = player GetWeaponsList(); 
		if( IsDefined( weapons ) )
		{
			for( i = 0; i < weapons.size; i++ )
			{
				if( weapons[i] == self.zombie_weapon_upgrade )
				{
					player_has_weapon = true; 
				}
			}
		}		

		grenadeMax = WeaponMaxAmmo( "stielhandgranate" );

		if(is_grenade && player GetWeaponAmmoClip("stielhandgranate") >= grenadeMax)
        {
            continue;
		}
		
		if( !player_has_weapon )
		{
			// else make the weapon show and give it
			if( player.score >= cost )
			{
				if( self.first_time_triggered == false )
				{
					model = getent( self.target, "targetname" ); 
//					model show(); 
					model thread weapon_show( player ); 
					self.first_time_triggered = true; 
					
					if(!is_grenade)
					{
						self SetHintString( &"PROTOTYPE_ZOMBIE_WEAPONCOSTAMMO", cost, ammo_cost ); 
					}
				}
			
				player maps\_zombiemode_score::minus_to_player_score( cost ); 

				player weapon_give( self.zombie_weapon_upgrade ); 
			}
			else
			{
				play_sound_on_ent( "no_purchase" );
			}
		}
		else
		{
			// if the player does have this then give him ammo.
			if( player.score >= ammo_cost )
			{
				if( self.first_time_triggered == false )
				{
					model = getent( self.target, "targetname" ); 
//					model show(); 
					model thread weapon_show( player ); 
					self.first_time_triggered = true;
					if(!is_grenade)
					{ 
						self SetHintString( &"PROTOTYPE_ZOMBIE_WEAPONCOSTAMMO", cost, ammo_cost ); 
					}
				}
				
				ammo_given = player ammo_give( self.zombie_weapon_upgrade ); 
				if( ammo_given )
				{
					if(is_grenade)
					{
						player maps\_zombiemode_score::minus_to_player_score( cost ); // this give him ammo to early
					}
					else
					{
						player maps\_zombiemode_score::minus_to_player_score( ammo_cost ); // this give him ammo to early
					}
				}
			}
			else
			{
				play_sound_on_ent( "no_purchase" );
			}
		}
	}
}

weapon_show( player )
{
	player_angles = VectorToAngles( player.origin - self.origin ); 

	player_yaw = player_angles[1]; 
	weapon_yaw = self.angles[1]; 

	yaw_diff = AngleClamp180( player_yaw - weapon_yaw ); 

	if( yaw_diff > 0 )
	{
		yaw = weapon_yaw - 90; 
	}
	else
	{
		yaw = weapon_yaw + 90; 
	}

	self.og_origin = self.origin; 
	self.origin = self.origin +( AnglesToForward( ( 0, yaw, 0 ) ) * 8 ); 

	wait( 0.05 ); 
	self Show(); 

	play_sound_at_pos( "weapon_show", self.origin, self );

	time = 1; 
	self MoveTo( self.og_origin, time ); 
}

weapon_give( weapon )
{

	primaryWeapons = self GetWeaponsListPrimaries(); 
	current_weapon = undefined; 

	// This should never be true for the first time.
	if( primaryWeapons.size >= 2 ) // he has two weapons
	{
		current_weapon = self getCurrentWeapon(); // get his current weapon

		if( isdefined( current_weapon ) )
		{
			if( !( weapon == "fraggrenade" || weapon == "stielhandgranate" || weapon == "molotov" ) )
			{
				self TakeWeapon( current_weapon ); 
			}
		} 
	} 

	if( IsDefined( primaryWeapons ) && !isDefined( current_weapon ) )
	{
		for( i = 0; i < primaryWeapons.size; i++ )
		{
			if(primaryWeapons[i] == "colt" || primaryWeapons[i] == "walther" || primaryWeapons[i] == "tokarev")
			{
				continue; 
			}

			if( weapon != "fraggrenade" && weapon != "stielhandgranate" && weapon != "molotov" )
			{
				self TakeWeapon( primaryWeapons[i] ); 
			}
		}
	}

	self play_sound_on_ent( "purchase" );
	self GiveWeapon( weapon, 0 ); 
	self GiveMaxAmmo( weapon ); 
	self SwitchToWeapon( weapon ); 

}

ammo_give( weapon )
{
	// We assume before calling this function we already checked to see if the player has this weapon...

	// Should we give ammo to the player
	give_ammo = false; 
	
	// get the max allowed ammo on the current weapon
	stockMax = WeaponMaxAmmo( weapon ); 
	
	// Get the current weapon clip/magazine ammo count
	clipCount = self GetWeaponAmmoClip( weapon ); 

	// Get the current weapon reserve ammo count
	ammoCount = self getammocount(weapon);

	// Check to see if ammo belongs to a primary weapon
	if( weapon != "fraggrenade" && weapon != "stielhandgranate" && weapon != "molotov" )
	{
		if( isdefined( weapon ) )  
		{
	
			// compare it with the ammo player actually has, if more or equal just dont give the ammo, else do
			if(ammoCount + clipcount >= stockMax)	
			{
				give_ammo = false; 
			}
			else
			{
				give_ammo = true; // give the ammo to the player
			}
		}
				
	}
	else
	{
		// Ammo belongs to secondary weapon
		if( self hasweapon( weapon ) )
		{
			// Check if the player has less than max stock, if no give ammo
			if(ammoCount < stockMax)
			{
				// give the ammo to the player
				give_ammo = true; 					
			}
		}		
	}	


	if( give_ammo )
	{
		self playsound( "cha_ching" ); 
		self GivemaxAmmo( weapon ); 
		self SetWeaponAmmoClip( weapon, WeaponClipSize( weapon ) );
		return true;
	}

	if( !give_ammo )
	{
		return false;
	}
}

get_player_index(player)
{
	assert( IsPlayer( player ) );
	assert( IsDefined( player.entity_num ) );
/#
	// used for testing to switch player's VO in-game from devgui
	if( player.entity_num == 0 && GetDVar( "zombie_player_vo_overwrite" ) != "" )
	{
		new_vo_index = GetDVarInt( "zombie_player_vo_overwrite" );
		return new_vo_index;
	}
#/
	return level.random_character_index[player.entity_num];
}

//test
has_weapon_or_upgrade( weaponname )
{
	has_weapon = false;
	if (self maps\_laststand::player_is_in_laststand())
	{
		for( m = 0; m < self.weaponInventory.size; m++ )
		{
			if (self.weaponInventory[m] == weaponname || self.weaponInventory[m] == weaponname+"_upgraded" )
			{
				has_weapon = true;
			}
		}
	}
	else
	{
		// If the weapon you're checking doesn't exist, it will return undefined
		if( IsDefined( level.zombie_include_weapons[weaponname] ) )
		{
			has_weapon = self HasWeapon( weaponname );
		}
	
		if( !has_weapon && isdefined( level.zombie_include_weapons[weaponname+"_upgraded"] ) )
		{
			has_weapon = self HasWeapon( weaponname+"_upgraded" );
		}
	}

	return has_weapon;
}