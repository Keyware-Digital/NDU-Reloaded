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
	if( isDefined( level.zombie_include_weapons ) && !isDefined( level.zombie_include_weapons[weapon_name] ) )
	{
		return;
	}

	// Check the table first
	table = "mp/zombiemode.csv";
	table_cost = TableLookUp( table, 0, weapon_name, 1 );
	table_ammo_cost = TableLookUp( table, 0, weapon_name, 2 );

	if( isDefined( table_cost ) && table_cost != "" )
	{
		cost = round_up_to_ten( int( table_cost ) );
	}

	if( isDefined( table_ammo_cost ) && table_ammo_cost != "" )
	{
		ammo_cost = round_up_to_ten( int( table_ammo_cost ) );
	}

	PrecacheItem( weapon_name );
	PrecacheString( hint );

	struct = SpawnStruct();

	if( !isDefined( level.zombie_weapons ) )
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
	
	if( !isDefined( ammo_cost ) )
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

/*prototype_cymbal_monkey_weighting_func()
{
	players = GetPlayers();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] has_weapon_or_upgrade( "zombie_cymbal_monkey" ) )
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
	players = GetPlayers();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] has_weapon_or_upgrade( "zombie_bowie_flourish" ) )
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
	players = GetPlayers();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] has_weapon_or_upgrade( "mine_bouncing_betty" ) )
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

include_zombie_weapon( weapon_name, in_box, weighting_func )
{
	if( !isDefined( level.zombie_include_weapons ) )
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
		level.weapon_weighting_funcs[weapon_name] = ::prototype_weighting_func;
	}
	else
	{
		level.weapon_weighting_funcs[weapon_name] = weighting_func;
	}
}

init_weapons()
{
	//Only guns that are wall buy guns require their true cost, every other gun needs to have zero cost to prevent errors and confusion
	// NDU: Reloaded
	add_zombie_weapon( "m1921_thompson", "", 0 );
	add_zombie_weapon( "mine_bouncing_betty", "", 0 );
	add_zombie_weapon( "mp40_bigammo_mp", "", 0 );	
	add_zombie_weapon( "ppsh41", "", 0 );
	add_zombie_weapon( "ppsh41_drum", "", 0 );
	add_zombie_weapon( "perks_a_cola", "", 0 );
	add_zombie_weapon( "stg44_pap", "", 0, 6 ); 
	add_zombie_weapon( "sten_mk5", "", 0 );
	//add_zombie_weapon( "zombie_cymbal_monkey", &"ZOMBIE_WEAPON_SATCHEL_2000", 2000, 3 );
	add_zombie_weapon( "zombie_bowie_flourish",	"", 0 );
	add_zombie_weapon( "zombie_type100_smg", "", 0 );

	// Other
	//add_zombie_weapon( "death_hands", 						&"PROTOTYPE_ZOMBIE_DEATH_HANDS_10000",		10000 );
	//add_zombie_weapon( "knuckle_crack_hands", 				&"PROTOTYPE_ZOMBIE_KNUCKLE_CRACK_10000",	10000 );

	// Cut content
	//add_zombie_weapon( "springfield_scoped_zombie_upgraded", "", 0 );
	//add_zombie_weapon( "tesla_gun", "", 0 );
	//add_zombie_weapon( "walther_prototype", "", 0 );
	
	// Pistols
	add_zombie_weapon( "colt", "", 0 );
	add_zombie_weapon( "colt_dirty_harry", "", 0 );
	add_zombie_weapon( "nambu", "", 0 );
	add_zombie_weapon( "sw_357", "", 0 );
	add_zombie_weapon( "tokarev", "", 0 );
	add_zombie_weapon( "walther", "", 0 );
                                                        		
	// Bolt Action                                      		
	add_zombie_weapon( "kar98k", "", 200 );
	add_zombie_weapon( "kar98k_bayonet", "", 0 );
	add_zombie_weapon( "mosin_rifle", "", 0 );
	add_zombie_weapon( "mosin_rifle_bayonet", "", 0 );
	add_zombie_weapon( "springfield", "", 0 );
	add_zombie_weapon( "springfield_bayonet", "", 0 );
	add_zombie_weapon( "type99_rifle", "", 0 );
	add_zombie_weapon( "type99_rifle_bayonet", "", 0 );
                                                        		
	// Semi Auto                                        		
	add_zombie_weapon( "gewehr43", "", 0 );
	add_zombie_weapon( "m1carbine", "", 600 );
	add_zombie_weapon( "m1carbine_bayonet", "", 0 );
	add_zombie_weapon( "m1garand", "", 600 );
	add_zombie_weapon( "m1garand_bayonet", "", 0 );
	add_zombie_weapon( "svt40", "", 0 );
                                                        		
	// Grenades                                         		
	add_zombie_weapon( "molotov", "", 0 );
	add_zombie_weapon( "stielhandgranate", "", 250 );

	// Scoped
	add_zombie_weapon( "kar98k_scoped_zombie", "", 0 );
	add_zombie_weapon( "kar98k_scoped_bayonet_zombie", "", 0 );
	add_zombie_weapon( "mosin_rifle_scoped_zombie", "", 0 );
	add_zombie_weapon( "mosin_rifle_scoped_bayonet_zombie", "", 0 );
	add_zombie_weapon( "ptrs41_zombie", "", 0 );
	add_zombie_weapon( "springfield_scoped_zombie", "", 0 );
	add_zombie_weapon( "springfield_scoped_bayonet_zombie", "", 0 );
	add_zombie_weapon( "type99_rifle_scoped_zombie", "", 0 );
	add_zombie_weapon( "type99_rifle_scoped_bayonet_zombie", "", 0 );
                                                                                                	
	// Full Auto                                                                                	
	add_zombie_weapon( "mp40", "", 0 );
	add_zombie_weapon( "ppsh", "", 0 );
	add_zombie_weapon( "stg44", "", 0 );
	add_zombie_weapon( "thompson", "", 1500 );
	add_zombie_weapon( "type100_smg", &"", 0 );
                                                        	
	// Shotguns                                         	
	add_zombie_weapon( "doublebarrel", "", 1200 );
	add_zombie_weapon( "doublebarrel_sawed_grip", "", 1200 );
	add_zombie_weapon( "shotgun", "", 1500 );
                                                        	
	// Heavy Machineguns                                	
	add_zombie_weapon( "30cal", "", 0 );
	add_zombie_weapon( "bar", "", 1800 );
	add_zombie_weapon( "dp28", "", 0 );
	add_zombie_weapon( "fg42", "", 0 );
	add_zombie_weapon( "fg42_scoped", "", 0 );
	add_zombie_weapon( "mg42", "", 0 );
	add_zombie_weapon( "type99_lmg", "", 0 );
                                                        	
	// Grenade Launcher                                 	
	add_zombie_weapon( "m1garand_gl", "", 0 );
	add_zombie_weapon( "mosin_launcher", "", 0 );
	                                        				
	// Bipods                               				
	add_zombie_weapon( "30cal_bipod", "", 0 );
	add_zombie_weapon( "bar_bipod", "", 0 );
	add_zombie_weapon( "dp28_bipod", "", 0 );
	add_zombie_weapon( "fg42_bipod", "", 0 );
	add_zombie_weapon( "mg42_bipod", "", 0 );
	add_zombie_weapon( "type99_lmg_bipod", "", 0 );
	
	// Rocket Launchers
	add_zombie_weapon( "bazooka", "", 0 );
	add_zombie_weapon( "panzerschrek", "", 0 );
	                                                    	
	// Flamethrower                                     	
	add_zombie_weapon( "m2_flamethrower_zombie", "", 0 );	
                                                        	
	// Special                                          	
	add_zombie_weapon( "mortar_round", "", 0 );
	add_zombie_weapon( "satchel_charge", "", 0 );
	add_zombie_weapon( "ray_gun_mk1_v2", "", 0, 6 );
	add_zombie_weapon( "zombie_melee", "", 0);
	
	// ONLY 1 (OR MORE) OF THE BELOW SHOULD BE ALLOWED
	add_limited_weapon( "m2_flamethrower_zombie", 1 );

	// Precache the padlock
	PrecacheModel("zmb_mdl_padlock");

}             

add_limited_weapon( weapon_name, amount )
{
	if( !isDefined( level.limited_weapons ) )
	{
		level.limited_weapons = [];
	}

	level.limited_weapons[weapon_name] = amount;
}                                          	

// For buying weapon upgrades in the environment
init_weapon_upgrade()
{

	weaponNameWallBuy = undefined;
	
	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" ); 

	for( i = 0; i < weapon_spawns.size; i++ )
	{

		weapon_name = get_weapon_name(weapon_spawns[i].zombie_weapon_upgrade);
		cost = get_weapon_cost( weapon_spawns[i].zombie_weapon_upgrade );

		switch(weapon_name)
		{
			case "kar98k":
			weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_KAR_98K";
				break; 
			case "m1carbine":
			weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_M1_CARBINE";
				break;
			case "thompson":
			weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_THOMPSON";
				break;  
			case "doublebarrel":
			weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_SHOTGUN_DOUBLE_BARRELED";
				break;
			case "bar":
			weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_BAR";
				break;
			case "shotgun":
			weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_SHOTGUN";
				break;
			case "doublebarrel_sawed_grip":
			weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_SHOTGUN_DOUBLE_BARRELED_SAWN_GRIP";
				break;
		}

		weapon_spawns[i] SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_WEAPONS_WALL_BUY", "&&1", weaponNameWallBuy, cost);
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

// returns the trigger hint string for the given weapon
get_weapon_name( weapon_name )
{
	AssertEx( isDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon_name].weapon_name;
}

get_weapon_hint( weapon_name )
{
	AssertEx( isDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon_name].hint;
}

get_weapon_cost( weapon_name )
{
	AssertEx( isDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon_name].cost;
}

get_ammo_cost( weapon_name )
{
	AssertEx( isDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon_name].ammo_cost;
}

get_is_in_box( weapon_name )
{
	AssertEx( isDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );
	
	return level.zombie_weapons[weapon_name].is_in_box;
}

// for the random weapon chest
init_treasure_chest()
{
	// the triggers which are targeted at chests
	level.chests = GetEntArray( "treasure_chest_use", "targetname" ); 

	array_thread( level.chests, ::treasure_chest_think ); 
}

init_mystery_box_vars() {
	set_zombie_var("zombie_mystery_box_padlock_cost", 2000);	// matched botd
	level.chest_accessed = 0;

}

set_treasure_chest_cost( cost )
{
	level.zombie_treasure_chest_cost = cost;
}

treasure_chest_think(rand)
{
	cost = 950;

	if( isDefined( level.zombie_treasure_chest_cost ) )
	{
		cost = level.zombie_treasure_chest_cost;
	}

	self SetHintString(&"PROTOTYPE_ZOMBIE_RANDOM_WEAPON", "&&1", cost);
	self setCursorHint( "HINT_NOICON" );
	self UseTriggerRequireLookAt();

	if(isDefined(level.zombie_vars["zombie_fire_sale"]) && level.zombie_vars["zombie_fire_sale"])
	{
		self SetHintString(&"PROTOTYPE_ZOMBIE_RANDOM_WEAPON", "&&1", cost);
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
	lid = getent( self.target, "targetname" ); 
	weapon_spawn_org = getent( lid.target, "targetname" ); 
    weaponNameMysteryBox = undefined;
	
	//open the lid
	lid thread treasure_chest_lid_open();
	
	// SRS 9/3/2008: added to help other functions know if we timed out on grabbing the item
	self.timedOut = false;
	
	// mario kart style weapon spawning
	weapon_spawn_org thread treasure_chest_weapon_spawn( self, user ); 
	
	// the glowfx	
	weapon_spawn_org thread treasure_chest_glowfx(); 
	
	// take away usability until model is done randomizing
	self disable_trigger(); 
	
	weapon_spawn_org waittill( "randomization_done" ); 

	if(isDefined(self.boxlocked) && self.boxlocked) // Padlock stuff
    {
        self.boxlocked = false;
        weapon_spawn_org notify("weapon_grabbed");
        lid thread treasure_chest_lid_close( self.timedOut );
        wait 3;
        self thread treasure_chest_think();
        return;
    }

	self.grab_weapon_hint = true;

	level thread treasure_chest_user_hint( self, user );

	//Commence hintstring weapon name value switch for each weapon in the mystery box

	switch(weapon_spawn_org.weapon_string)
	{
		case "30cal_bipod":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_30_CAL_BIPOD";
			break; 
		case "bar":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_BAR";
			break;
		case "colt":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_COLT_45";
			break;  
		case "dp28":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_DP_27";
			break;
		case "doublebarrel":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_SHOTGUN_DOUBLE_BARRELED";
			break;
		case "doublebarrel_sawed_grip":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_SHOTGUN_DOUBLE_BARRELED_SAWN_GRIP";
			break;
		case "fg42_bipod":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_FG_42_BIPOD";
			break;
		case "gewehr43":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_GEWEHR_43";
			break;
		case "m1garand_gl":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_M1_GARAND_GL";
	        break;
		case "m2_flamethrower_zombie":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_M2_FLAMETHROWER";
		    break;
		case "mg42_bipod":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_MG42_BIPOD";
		    break;
		case "mine_bouncing_betty":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_S_MINE";
		    break;
		case "molotov":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_MOLOTOV";
		    break;
		case "mosin_rifle":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_MOSIN_RIFLE";
		    break;
		case "mp40":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_MP_40";
		    break;
		case "panzerschrek":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_PANZERSCHREK";
		    break;
		case "ppsh41":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_PPSH_41";
		    break;
		case "ptrs41_zombie":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_PTRS_41";
		    break;
		case "ray_gun_mk1_v2":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_RAY_GUN";
		    break;
		case "shotgun":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_SHOTGUN";
		    break;
		case "springfield":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_SPRINGFIELD";
		    break;
		case "stg44":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_STG_44";
		    break;
		case "svt40":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_SVT_40";
		    break;
		case "sw_357":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_357_MAGNUM";
		    break;
		case "thompson":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_THOMPSON";
		    break;
		case "tokarev":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_TOKAREV";
		    break;
		case "type99_lmg":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_TYPE_99";
		    break;
		case "zombie_bowie_flourish":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_BOWIE";
		    break;
		case "zombie_type100_smg":
		weaponNameMysteryBox = &"PROTOTYPE_ZOMBIE_WEAPON_TYPE_100";
		    break;
	}

	self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_WEAPONS_BOX", "&&1", weaponNameMysteryBox);
	
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
					if( !user HasPerk("specialty_altmelee") || user.has_bowie)
					{
						weapon_spawn_org notify("weapon_grabbed");
						lid thread treasure_chest_lid_close( self.timedOut );
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
		lid thread treasure_chest_lid_close( self.timedOut );
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
		if( !isDefined( trigger ) )
		{
			break;
		}

		if( trigger.grab_weapon_hint )
		{
			break;
		}

		players = GetPlayers();
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
    if( isDefined( level.limited_weapons ) )
    {
        keys2 = GetArrayKeys( level.limited_weapons );
        players = GetPlayers();
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
	if(isDefined(player.has_bowie) && player.has_bowie)
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

		if( !isDefined( keys[i] ) )
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
 
treasure_chest_weapon_spawn( chest, player )
{
    assert(isDefined(player));
    // spawn the model
    model = spawn( "script_model", self.origin ); 
    model.angles = self.angles + ( 0, 90, 0 );
 
    floatHeight = 40;
 
    //move it up
	model moveto( model.origin + ( 0, 0, floatHeight ), 3, 2, 0.9 ); 

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
 
	//Padlock start
	
    chanceOfPadlock = RandomInt(100);

	//Teddy bear style chance of Padlock proc

    if(level.chest_accessed >= 4 && level.chest_accessed < 8) // 15% chance to get lock between round 4 and 7
    {
        chanceOfPadlock = chanceOfPadlock + 15;
    }
    else if(level.chest_accessed >= 8 && level.chest_accessed < 13) //30% chance to get lock between pull 8 and 12
    {
        chanceOfPadlock = chanceOfPadlock + 30;
    }
    else if(level.chest_accessed >= 13) //50% chance to get lock after 12th pull
    {
        chanceOfPadlock = 50;
    }

    if(chanceOfPadlock >= 100 && level.chest_accessed > 3 && !level.zombie_vars["zombie_fire_sale"])
    {
        chest.boxlocked = true;
		level.zombie_vars["enableFireSale"] = 0;
        model SetModel("zmb_mdl_padlock");
		level.zombie_mystery_box_padlock = 1;
        player maps\_zombiemode_score::add_to_player_score(950);

		mystery_box_lock_sound = Spawn("script_origin", chest.origin);
		mystery_box_lock_sound PlaySound("mystery_box_lock", "sound_done");

		cost = level.zombie_vars["zombie_mystery_box_padlock_cost"];
		
        chest SetHintString(&"PROTOTYPE_ZOMBIE_RANDOM_WEAPON_LOCKED", "&&1", cost);
		mystery_box_lock_sound waittill("sound_done");
		mystery_box_lock_sound Delete();
        chest enable_trigger();
        
        while(1)
        {
            chest waittill("trigger", player);
            if(player.score >= level.zombie_vars["zombie_mystery_box_padlock_cost"])
            {
                player PlaySound( "purchase" ); 
                player maps\_zombiemode_score::minus_to_player_score(level.zombie_vars["zombie_mystery_box_padlock_cost"]);
                break;
            }
            player PlaySound( "no_purchase" );
            wait 0.05;
        }

        level.zombie_vars["enableFireSale"] = 1;
        chest SetHintString("");
		mystery_box_unlock_sound = Spawn("script_origin", chest.origin);
		mystery_box_unlock_sound PlaySound("mystery_box_unlock", "sound_done");
		mystery_box_unlock_sound waittill("sound_done");
		mystery_box_unlock_sound Delete();
        model Delete();
		level.zombie_mystery_box_padlock = 0;
        level.chest_accessed = 0;
        self notify( "randomization_done" ); 
        return;
    }

    level.chest_accessed++;

	// Padlock end

	self notify( "randomization_done" );

    self.weapon_string = rand; // here's where the org get it's weapon type for the give function
 
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
	self.has_bowie = undefined;
}
	// SRS 9/3/2008: if we timed out, move the weapon back into the box instead of deleting it
timer_til_despawn(floatHeight)
{
	putBackTime = 12;
	self MoveTo( self.origin - ( 0, 0, floatHeight ), putBackTime, ( putBackTime * 0.5 ) );
	wait( putBackTime );

	if(isDefined(self))
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

	if( !self HasPerk("specialty_extraammo")) {
		self.muleCount = level.zombie_vars[ "mulekick_min_weapon_slots" ];
	}
	else {
		self.muleCount = level.zombie_vars[ "mulekick_max_weapon_slots" ];
	}

	if (WeaponClass( weapon_string ) != "grenade" && current_weapon != "mine_bouncing_betty")
	{
		if (primaryWeapons.size >= self.MuleCount)
		{
			self TakeWeapon( current_weapon ); 

			self GiveWeapon(weapon_string, 0);
			self GiveMaxAmmo(weapon_string);
			self SwitchToWeapon(weapon_string);
		}
		else
		{
			self GiveWeapon(weapon_string, 0);
			self GiveMaxAmmo(weapon_string);
			self SwitchToWeapon(weapon_string);
		}
		
		self maps\_zombiemode_perks::mule_kick_function(current_weapon, weapon_string);
	}
	else
	{
		self TakeWeapon(weapon_string);
		self GiveWeapon(weapon_string, 0);
		self GiveMaxAmmo(weapon_string);
	} 

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

		if( isDefined( current_weapon ) )
		{
			if( !( weapon_string == "fraggrenade" || weapon_string == "stielhandgranate" || weapon_string == "molotov" ) )
			self TakeWeapon( current_weapon ); 
		} 
	}

	if(( weapon_string ==  "ray_gun_mk1_v2" ))
	{
		thread play_raygun_stinger();
	}


	if( isDefined( primaryWeapons ) && !isDefined( current_weapon ) )
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

	if( isDefined( level.zombie_weapon_cabinet_cost ) )
	{
		cost = level.zombie_weapon_cabinet_cost;
	}

	self SetHintString(&"PROTOTYPE_ZOMBIE_CABINET_OPEN", "&&1", cost);
	self setCursorHint( "HINT_NOICON" );
	self UseTriggerRequireLookAt();

	if(isDefined(level.zombie_vars["zombie_fire_sale"]) && level.zombie_vars["zombie_fire_sale"])
	{
		self SetHintString(&"PROTOTYPE_ZOMBIE_CABINET_OPEN", "&&1", cost);
	}

	level.cabinetguns = [];
	level.cabinetguns[0] = "kar98k_scoped_zombie";						// default
	level.cabinetguns[1] = "kar98k_bayonet";	
	level.cabinetguns[2] = "m1garand";		
	level.cabinetguns[3] = "m1921_thompson";						
	level.cabinetguns[4] = "mosin_rifle_bayonet";
	level.cabinetguns[5] = "mosin_rifle_scoped_zombie";
	level.cabinetguns[6] = "mp40_bigammo_mp";
	level.cabinetguns[7] = "ppsh41_drum";
	level.cabinetguns[8] = "sten_mk5";
	/*level.cabinetguns[9] = "bloodhound";
	level.cabinetguns[10] = "placeholder;*/
	randomnumb = undefined;
	weaponNameMysteryCabinet = undefined;
	
    doors = getentarray( self.target, "targetname" );
    for( i = 0; i < doors.size; i++ )
    {
        doors[i] NotSolid();
    }

    //////////////////////// Horrible Script ////////////////////////
    /////////////////////////////////////////////////////////////////


    flag_wait("all_players_connected");
    if(!isDefined(level.cabinetthinkdone) || level.cabinetthinkdone == 0) // please for the love of god only do this once
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
	self.grab_weapon_hint = true;

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

	cabinetSong = "cabinetbox_sting_" + RandomInt(3);

	play_sound_at_pos( "open_chest", self.origin );

	cabinet_sound = Spawn("script_origin", self.origin);
	cabinet_sound PlaySound(cabinetSong, "sound_done");

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

	switch(chosenweapon)
	{
		case "kar98k_scoped_zombie":
		weaponNameMysteryCabinet = &"PROTOTYPE_ZOMBIE_WEAPON_KAR_98K_SCOPED";
			break; 
		case "kar98k_bayonet":
		weaponNameMysteryCabinet = &"PROTOTYPE_ZOMBIE_WEAPON_KAR_98K_BAYONET";
			break;
		case "m1garand":
		weaponNameMysteryCabinet = &"PROTOTYPE_ZOMBIE_WEAPON_M1_GARAND";
			break;  
		case "m1921_thompson":
		weaponNameMysteryCabinet = &"PROTOTYPE_ZOMBIE_WEAPON_THOMPSON_DRUM";
			break;
		case "mosin_rifle_bayonet":
		weaponNameMysteryCabinet = &"PROTOTYPE_ZOMBIE_WEAPON_MOSIN_RIFLE_BAYONET";
			break;
		case "mosin_rifle_scoped_zombie":
		weaponNameMysteryCabinet = &"PROTOTYPE_ZOMBIE_WEAPON_MOSIN_RIFLE_SCOPED";
			break;
		case "mp40_bigammo_mp":
		weaponNameMysteryCabinet = &"PROTOTYPE_ZOMBIE_WEAPON_MP_40_MAG";
			break;
		case "ppsh41_drum":
		weaponNameMysteryCabinet = &"PROTOTYPE_ZOMBIE_WEAPON_PPSH_41_DRUM";
			break;
		case "sten_mk5":
		weaponNameMysteryCabinet = &"PROTOTYPE_ZOMBIE_WEAPON_STEN";
		break;
	}

	self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_WEAPONS_BOX", "&&1", weaponNameMysteryCabinet);

	for(i=0;i<level.keep_ents.size;i++)
    {
        level.keep_ents[i] Hide();
    }

	luckyNumCabinet = RandomInt(100);
	
	if(!isDefined(player.perknum) || player.perknum < 11)	//check if player has max perks
	{
		if(luckyNumCabinet <= 100)	//10 out of 100 chance to get a perk
		{
			// Hide the weapon cabinet model so we can reset the angle and show the perk bottle at the correct angle without the player noticing
			weaponmodelstruct Hide();
			weaponmodelstruct.angles = self.angles + ( 0, 90, 0 );
			wait 0.05;
			weaponmodelstruct Show();
			weaponmodelstruct SetModel(GetWeaponModel( "perks_a_cola" ));
			chosenweapon = "perks_a_cola";

			switch(chosenweapon)
			{
				case "perks_a_cola":
				weaponNameMysteryCabinet = &"PROTOTYPE_ZOMBIE_WEAPON_RANDOM_PERK_BOTTLE";
					break;
			}

			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_WEAPONS_BOX", "&&1", weaponNameMysteryCabinet);
			level.zombie_vars["enableRandomPerk"] = 1;

		}
	}

    if(!(player hasWeapon("stg44_pap")))	//check if player has the stg
    {
		if(luckyNumCabinet <= 5)	//5 out of 100 chance to get a pap'd stg
		{
        	weaponmodelstruct Hide();
			weaponmodelstruct.angles = self.angles + ( -90,90,0 );	//so it gets displayed like the other cabinet weapons.
        	wait 0.05;
        	weaponmodelstruct Show();
        	weaponmodelstruct SetModel(GetWeaponModel( "stg44_pap" ));
        	chosenweapon = "stg44_pap";

			switch(chosenweapon)
			{
				case "stg44_pap":
				weaponNameMysteryCabinet = &"PROTOTYPE_ZOMBIE_WEAPON_STG_44_UPGRADED";
					break;
			}

			self SetHintString(&"PROTOTYPE_ZOMBIE_TRADE_WEAPONS_BOX", "&&1", weaponNameMysteryCabinet);
		}
    }

	level thread treasure_chest_user_hint( self, player );
	weaponmodelstruct MoveTo(self.origin - (20,0,6.5),10);

	self thread takenweapon(chosenweapon);
	self thread waitforexpire();

	self waittill_any("weapontaken","weaponexpired");

	self.grab_weapon_hint = false;

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
	cabinet_sound waittill("sound_done");
	cabinet_sound Delete();
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
	players = GetPlayers();
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

	self waittill("trigger", player);
	self play_sound_on_ent( "purchase" ); 
	self notify("weapontaken");

	if(chosenweapon == "perks_a_cola")
	{
		//thread play_raygun_stinger();		// we don't want the stinger sound for a perk bottle.
		current_weapon = player GetCurrentWeapon();
		player GiveWeapon(chosenweapon);
    	player.is_drinking = 1;
		player SwitchToWeapon(chosenweapon);
		player DisableOffhandWeapons();
		player DisableWeaponCycling();
		player AllowLean( false );
		player AllowAds( false );
		player AllowSprint( false );
		player AllowProne( false );		
		player AllowMelee( false );
		wait 2.5;

		//Force crouch stance when using perk bottle
		if(player GetStance() == "prone" && player.is_drinking == 1)
		{
			player SetStance("crouch");
		}	

		player AllowLean( true );
		player AllowAds( true );
		player AllowSprint( true );
		player AllowProne( true );		
		player AllowMelee( true );
    	player.is_drinking = undefined;
		player TakeWeapon(chosenweapon);
		player SwitchToWeapon(current_weapon);
		player EnableOffhandWeapons();
		player EnableWeaponCycling();

		player thread maps\_zombiemode_perks::random_perk_powerup_think();
		return;
	}

	/*if(chosenweapon == "springfield_scoped_zombie_upgraded" )
	{
		thread play_raygun_stinger();
	}*/

	if(chosenweapon == "stg44_pap")
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
	
	weapon_name_ammo_cost = get_weapon_name(self.zombie_weapon_upgrade);
	cost = get_weapon_cost( self.zombie_weapon_upgrade );
	ammo_cost = get_ammo_cost( self.zombie_weapon_upgrade );
	is_grenade = (WeaponType( self.zombie_weapon_upgrade ) == "grenade");
	weaponNameWallBuy = undefined;

	self.first_time_triggered = false; 
	while(1)
	{
		self waittill( "trigger", player ); 		
		// if not first time and they have the weapon give ammo

		if(isDefined(player.is_drinking))
		{
			wait(0.1);
			continue;
		}

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
		if( isDefined( weapons ) )
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

		if(is_grenade && player GetWeaponAmmoClip("stielhandgranate") >= grenadeMax)		// Trebor's wallbuy nade fix
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

						switch(weapon_name_ammo_cost)
						{
							case "kar98k":
							weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_KAR_98K";
								break; 
							case "m1carbine":
							weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_M1_CARBINE";
								break;
							case "thompson":
							weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_THOMPSON";
								break;  
							case "doublebarrel":
							weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_SHOTGUN_DOUBLE_BARRELED";
								break;
							case "bar":
							weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_BAR";
								break;
							case "shotgun":
							weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_SHOTGUN";
								break;
							case "doublebarrel_sawed_grip":
							weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_SHOTGUN_DOUBLE_BARRELED_SAWN_GRIP";
								break;
							case "stielhandgranate":
							weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_STIELHANDGRANATE";
								break;
						}

						self SetHintString(&"PROTOTYPE_ZOMBIE_WEAPON_COST_AMMO", "&&1", weaponNameWallBuy, ammo_cost);
	
						self setCursorHint( "HINT_NOICON" ); 

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
						switch(weapon_name_ammo_cost)
						{
							case "kar98k":
							weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_KAR_98K";
								break; 
							case "m1carbine":
							weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_M1_CARBINE";
								break;
							case "thompson":
							weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_THOMPSON";
								break;  
							case "doublebarrel":
							weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_SHOTGUN_DOUBLE_BARRELED";
								break;
							case "bar":
							weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_BAR";
								break;
							case "shotgun":
							weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_SHOTGUN";
								break;
							case "doublebarrel_sawed_grip":
							weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_SHOTGUN_DOUBLE_BARRELED_SAWN_GRIP";
								break;
							case "stielhandgranate":
							weaponNameWallBuy = &"PROTOTYPE_ZOMBIE_WEAPON_STIELHANDGRANATE";
								break;
						}

						self SetHintString(&"PROTOTYPE_ZOMBIE_WEAPON_COST_AMMO", "&&1", weaponNameWallBuy, ammo_cost);
	
						self setCursorHint( "HINT_NOICON" ); 
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

	if( !self HasPerk("specialty_extraammo")) {
		self.muleCount = level.zombie_vars[ "mulekick_min_weapon_slots" ];
		self.muleLastWeapon = undefined;
	}
	else {
		self.muleCount = level.zombie_vars[ "mulekick_max_weapon_slots" ];
	}

	// This should never be true for the first time.
	if( primaryWeapons.size >= self.MuleCount ) // he has two weapons
	{
		current_weapon = self getCurrentWeapon(); // get his current weapon

		if ( current_weapon == "mine_bouncing_betty" )
		{
			current_weapon = undefined;
		}

		if( isDefined( current_weapon ) )
		{
			if( !( weapon == "fraggrenade" || weapon == "stielhandgranate" || weapon == "molotov" /*|| weapon == "zombie_cymbal_monkey"*/ ) )
			{
				self TakeWeapon( current_weapon ); 
			}
		} 
	}
	else if ( !isDefined(self.muleLastWeapon) )
	{
		current_weapon = self getCurrentWeapon();
	}

	if( isDefined( primaryWeapons ) && !isDefined( current_weapon ) )
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
	self maps\_zombiemode_perks::mule_kick_function(current_weapon, weapon);

}

ammo_give( weapon )
{
	//We assume before calling this function we already checked to see if the player has this weapon...

	//Should we give ammo to the player
	give_ammo = false; 

	defaultMagAmmo = WeaponClipSize(weapon); //default clip size

	defaultWeaponAmmo = WeaponMaxAmmo(weapon); //default reserve ammo

	totalCurrentWeaponAmmo = self GetAmmoCount(weapon); //current clip + reserve ammo

	//Check to see if ammo belongs to a primary weapon
	if(weapon != "fraggrenade" && weapon != "stielhandgranate" && weapon != "molotov")
	{
		if( isDefined( weapon ) )  
		{
			//Compare player current weapon ammo, if equal to default weapon ammo then don't give ammo, else do
			if(totalCurrentWeaponAmmo == defaultMagAmmo + defaultWeaponAmmo)	
			{
				give_ammo = false; 
			}
			else
			{
				give_ammo = true;
			}
		}
				
	}
	else
	{
		//Ammo belongs to secondary weapon
		if( self hasweapon( weapon ) )
		{
			//Check if the player has less than max stock, if no give ammo
			if(totalCurrentWeaponAmmo == defaultMagAmmo + defaultWeaponAmmo)	
			{
				give_ammo = false; 
			}
			else
			{
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
	assert( isDefined( player.entity_num ) );
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
		if( isDefined( level.zombie_include_weapons[weaponname] ) )
		{
			has_weapon = self HasWeapon( weaponname );
		}
	
		if( !has_weapon && isDefined( level.zombie_include_weapons[weaponname+"_upgraded"] ) )
		{
			has_weapon = self HasWeapon( weaponname+"_upgraded" );
		}
	}

	return has_weapon;
}