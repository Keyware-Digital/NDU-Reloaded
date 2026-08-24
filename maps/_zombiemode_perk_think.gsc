#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include maps\_zombiemode_net;

init()
{
    // Kept as a stub because _zombiemode.gsc calls
    // using this file for perk functions only
}

electric_cherry_function()
{
    self endon( "death" );
    self endon( "disconnect" );

    while ( self hasPerk( "specialty_boost" ) )
    {
        self waittill( "reload_start" );

        if ( !self hasPerk( "specialty_boost" ) )
            return;

        current_weapon = self GetCurrentWeapon();
        clip = WeaponClipSize( current_weapon );
        remaining = self GetCurrentWeaponClipAmmo();

        // Skip melee weapons or empty magazines
        if ( clip <= 0 )
            continue;

        cherry_ratio  = 1 - ( remaining / clip );
        cherry_radius = ( level.zombie_vars[ "electric_cherry_max_range" ] * cherry_ratio ) + 64;
        cherry_damage = level.zombie_vars[ "electric_cherry_max_damage" ] * cherry_ratio;

        self electric_cherry_shockwave( cherry_radius, cherry_damage );
        wait 5; // cooldown
    }
}

electric_cherry_shockwave( cherry_radius, cherry_damage )
{
    network_safe_play_fx_on_tag( "tesla_death_fx", 2, level._effect[ "tesla_shock_secondary" ], self, "J_SpineUpper" );
    self playsound( "imp_tesla" );

    zombies = GetAiSpeciesArray( "axis", "all" );

    for ( k = 0; k < zombies.size; k++ )
    {
        if ( !isDefined( zombies[k] ) || !isAlive( zombies[k] ) )
            continue;

        if ( distance( self.origin, zombies[k].origin ) < cherry_radius )
        {
            if ( isDefined( level.zombie_vars[ "zombie_powerup_insta_kill_on" ] ) && level.zombie_vars[ "zombie_powerup_insta_kill_on" ] )
                cherry_damage = zombies[k].health + 666;

            if ( zombies[k].health < cherry_damage )
            {
                // Instant kill
                // No dogs on this map – still use legs check for correct deathanim
                if ( isDefined( zombies[k].has_legs ) && zombies[k].has_legs )
                    zombies[k].deathanim = random( level._zombie_tesla_death[ zombies[k].animname ] );
                else
                    zombies[k].deathanim = random( level._zombie_tesla_crawl_death[ zombies[k].animname ] );

                zombies[k] DoDamage( zombies[k].health + 666, zombies[k].origin, self );
                zombies[k] electric_cherry_play_death_fx();

                points = level.zombie_vars[ "electric_cherry_points" ];
                if ( isDefined( level.zombie_vars[ "zombie_powerup_point_doubler_on" ] ) && level.zombie_vars[ "zombie_powerup_point_doubler_on" ] )
                    points *= 2;

                maps\_zombiemode_score::add_to_player_score( points );
            }
            else
            {
                // Partial damage + stun animation
                if ( zombies[k].ignoreall == false )
                {
                    if ( isDefined( level._zombie_board_taunt ) &&
                         isDefined( level._zombie_board_taunt["zombie"] ) &&
                         level._zombie_board_taunt["zombie"].size > 0 )
                    {
                        zombies[k] animscripted( "cherry_hit", zombies[k].origin, zombies[k].angles,
                            level._zombie_board_taunt["zombie"][ randomint( level._zombie_board_taunt["zombie"].size ) ] );
                    }
                }

                zombies[k] DoDamage( cherry_damage, zombies[k].origin, self );
                zombies[k] electric_cherry_play_death_fx();
            }
        }
        wait 0.01;
    }
}

electric_cherry_play_death_fx()
{
    tag = "J_SpineUpper";

    network_safe_play_fx_on_tag( "tesla_death_fx", 2, level._effect[ "tesla_shock" ], self, tag );
    self playsound( "imp_tesla" );

    if ( RandomInt( 100 ) < level.zombie_vars[ "tesla_head_gib_chance" ] )
    {
        wait( RandomFloat( 0.53, 1.0 ) );
        self maps\_zombiemode_spawner::zombie_head_gib();
    }
    else
    {
        network_safe_play_fx_on_tag( "tesla_death_fx", 2, level._effect[ "tesla_shock_eyes" ], self, "J_Eyeball_LE" );
    }
}

// Elemental Pop – fire / molotov boost
elemental_pop_boost( dmg, player, weapon )
{
    if ( !isDefined( player ) || !isAlive( player ) || !player hasPerk( "specialty_explosivedamage" ) )
        return dmg;

    // Molotov gets the boost always when the perk is owned
    if ( isDefined( weapon ) && weapon == "molotov" )
        return int( dmg * 1.17 );

    // Generic explosive boost (grenades, etc.)
    return int( dmg * 1.17 );
}

mule_kick_think(old_weapon, new_weapon)
{
    if (!self hasperk("specialty_extraammo") )
    {
        return;
    }

    if (!isDefined(new_weapon))
    {
        return;
    }

    primaryWeapons = self GetWeaponsListPrimaries();
    if( primaryWeapons.size == level.zombie_vars[ "mulekick_max_weapon_slots" ] )
    {
        if (!isDefined(self.muleLastWeapon))
        {
            self.muleLastWeapon = new_weapon;
        }
        else if (isDefined(old_weapon) && old_weapon == self.muleLastWeapon)
        {
            self.muleLastWeapon = new_weapon;
        }
    }
}

mule_kick_update_hud()
{
    if ( !isDefined( self.perk_hud ) 
      || !isDefined( self.perk_hud[ "specialty_extraammo" ] ) 
      || !self hasPerk( "specialty_extraammo" ) )
    {
        self setClientDvar( "player_hud_specialty_mule_kick", 0 );

        // Only touch the hud element if it actually exists
        if ( isDefined( self.perk_hud ) && isDefined( self.perk_hud[ "specialty_extraammo" ] ) )
            self.perk_hud[ "specialty_extraammo" ] setShader( "specialty_mule_kick_zombies", 24, 24 );

        return;
    }

    primaries = self GetWeaponsListPrimaries();
    current   = self getCurrentWeapon();

    if ( primaries.size == level.zombie_vars[ "mulekick_max_weapon_slots" ]
      && isDefined( self.muleLastWeapon )
      && current == self.muleLastWeapon )
    {
        self.perk_hud[ "specialty_extraammo" ] setShader( "specialty_mule_kick_glow_zombies", 24, 24 );
        self setClientDvar( "player_hud_specialty_mule_kick", 0 );
        //self setClientDvar( "player_hud_specialty_mule_kick", 1 );
    }
    else
    {
        self.perk_hud[ "specialty_extraammo" ] setShader( "specialty_mule_kick_zombies", 24, 24 );
        self setClientDvar( "player_hud_specialty_mule_kick", 0 );
    }
}

player_switch_weapon_watcher()
{
    self endon( "disconnect" );

    //self iPrintLnBold( "^1Mule watcher started" );

    self mule_kick_update_hud();

    while ( 1 )
    {
        self waittill( "weapon_change" );
        //self iPrintLnBold( "^1weapon change complete" );
        self mule_kick_update_hud();
    }
}

phd_dive_damage(origin)
{
    self thread maps\_sounds::phd_explosion_sound();
    playFx( level._effect["phdflopper_explosion"], self.origin + ( 0, 0, 50 ));

    self thread phd_dive_vision();

    phd_damage = level.zombie_vars[ "phd_dive_damage" ];

    zombies = GetAiSpeciesArray( "axis", "all" );
    for(i = 0; i < zombies.size; i++)
    {
        range = distance( origin, zombies[i].origin );
        max_range = level.zombie_vars[ "phd_max_range" ];
        if ( range <= max_range )
        {
            phd_damage = int(phd_damage * (1 - (range / max_range)));

            if ( isDefined( level.zombie_vars["zombie_powerup_insta_kill_on"] ) && level.zombie_vars["zombie_powerup_insta_kill_on"] )
            phd_damage = zombies[i].health + 666;

            if (zombies[i].health <= phd_damage)
            {
                zombies[i] DoDamage( phd_damage, zombies[i].origin, self);
                zombies[i] maps\_zombiemode_spawner::zombie_head_gib();
            }
            else
            {
                zombies[i] DoDamage( phd_damage , zombies[i].origin, self);
                zombies[i] maps\_zombiemode_spawner::zombie_head_gib();
            }
        }

        wait .01;
    }

    wait 0.1;   //was 0.2
}

phd_dive_vision()
{
    self VisionSetNaked("zombie_cosmodrome_divetonuke", 0.1); //important, do not change, fade-in time
    wait 1; //change time between visions, can change
    self VisionSetNaked("zombie_bo3", 1); //important do not change, fade-in time
}

perks_zombie_hit_effect(amount, attacker, point, mod)
{
    if( !isDefined(attacker) || !isAlive( self ) || !isPlayer( attacker ) )
    {
        return;
    }

    // Melee Macchiato logic (now using specialty_ordinance)
    if (mod == "MOD_MELEE" && attacker hasPerk("specialty_ordinance"))
    {
        extra = int(amount * (level.zombie_vars["melee_macchiato_multiplier"] - 1.0));
        if (extra > 0)
        {
            self DoDamage(extra, point, attacker);
        }
        return;
    }

    // Double Tap logic
    hitLocation = self.damageLocation;
    health = self.health;

    if( mod != "MOD_PISTOL_BULLET" && mod != "MOD_RIFLE_BULLET")
    {
        return;
    }

    if (attacker hasPerk( "specialty_rof" ))
    {
        attacker maps\_zombiemode_score::player_add_points( "damage", mod, hitLocation);
        health = health - amount;
    }

    perks_zombie_hit_effect_check_health(health, attacker);
}

perks_zombie_hit_effect_check_health(health, attacker)
{
    // If there's no extra damage done
    if (health == self.health)
    {
        return;
    }

    if (health <= 0)
    {
        self doDamage( self.health + 666, self.origin, attacker );
        return;
    }

    // instead of doing damage and being inaccurate about the scoring the health is decreased instead
    self.health = health;
}



