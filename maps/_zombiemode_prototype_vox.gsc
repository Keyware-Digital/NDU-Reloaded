#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include maps\_sounds;

init()
{
    level.player_is_speaking = 0;
    level.zombies_are_close = 0;
}

blockers_vox_cooldown_reset()
{
    wait 3;
    self.blockers_vox_cooldown = false;
}

friendly_fire_sound_cooldown_reset()
{
    wait 2;
    self.friendly_fire_sound_cooldown = false;
}

killstreak_cooldown_reset()
{
    wait 7;
    self.killstreak_cooldown = false;
}

no_ammo_cooldown_reset()
{
    wait 20;
    self.no_ammo_cooldown = false;
}

player_friendly_fire_sound_monitor()
{
    self endon( "death" );
    self endon( "disconnect" );

    self.friendly_fire_sound_cooldown = false;

    while( 1 )
    {
        self waittill( "weapon_fired" );

        if( self.friendly_fire_sound_cooldown )
        {
            wait 0.05;
            continue;
        }

        if( self maps\_laststand::player_is_in_laststand() || self.is_zombie )
        {
            wait 0.05;
            continue;
        }

        current_weapon = self GetCurrentWeapon();
        if( !isDefined( current_weapon ) || current_weapon == "none" ||
            current_weapon == "zombie_perk_bottle_doubletap" ||
            current_weapon == "zombie_perk_bottle_jugg" ||
            current_weapon == "zombie_perk_bottle_revive" ||
            current_weapon == "zombie_perk_bottle_sleight" ||
            current_weapon == "mine_bouncing_betty" ||
            current_weapon == "syrette" ||
            current_weapon == "zombie_bowie_flourish" ||
            current_weapon == "zombie_death_hands" ||
            current_weapon == "zombie_knuckle_crack" ||
            current_weapon == "zombie_punch_melee" )
        {
            wait 0.05;
            continue;
        }

        start = self GetEye();
        end = start + ( AnglesToForward( self GetPlayerAngles() ) * 10000 );
        trace = BulletTrace( start, end, true, self );

        if( isDefined( trace["entity"] ) && isPlayer( trace["entity"] ) && trace["entity"] != self )
        {
            if( !trace["entity"].is_zombie &&
                !trace["entity"] maps\_laststand::player_is_in_laststand() &&
                trace["entity"].team == self.team )
            {
                chance = 50;
                if( RandomInt( 100 ) < chance )
                {
                    self.friendly_fire_sound_cooldown = true;
                    trace["entity"] thread player_vox_helper( ::friendly_fire_sound, "ff_sound_done" );
                    self thread friendly_fire_sound_cooldown_reset();
                }
            }
        }

        wait 0.05;
    }
}

player_lunge_knife_exert_sounds()
{
    self endon( "death" );

    while( 1 )
    {
        if( self IsMeleeing() )
        {
            if( isDefined( self.player_is_speaking ) && self.player_is_speaking )
            {
                self.player_is_speaking = 0;
                self notify( "melee_sound_done" );
                self notify( "active_melee_vox" );
            }

            self thread player_vox_helper( ::melee_vox_sound, "melee_sound_done" );

            while( self IsMeleeing() )
                wait 0.05;
        }

        wait 0.05;
    }
}

player_no_ammo_sounds()
{
    self endon( "death" );
    self endon( "disconnect" );

    self.no_ammo_cooldown = false;

    while( 1 )
    {
        if( self maps\_laststand::player_is_in_laststand() )
        {
            wait 0.5;
            continue;
        }

        if( self.no_ammo_cooldown )
        {
            wait 0.5;
            continue;
        }

        current_weapon = self GetCurrentWeapon();

        if( !IsDefined( current_weapon ) || current_weapon == "none" ||
            current_weapon == "zombie_perk_bottle_doubletap" ||
            current_weapon == "zombie_perk_bottle_jugg" ||
            current_weapon == "zombie_perk_bottle_revive" ||
            current_weapon == "zombie_perk_bottle_sleight" ||
            current_weapon == "mine_bouncing_betty" ||
            current_weapon == "syrette" ||
            current_weapon == "zombie_knuckle_crack" ||
            current_weapon == "zombie_bowie_flourish" ||
            current_weapon == "zombie_death_hands" ||
            current_weapon == "zombie_punch_melee" )
        {
            wait 0.5;
            continue;
        }

        if( IsDefined( level.filtered_weapon ) && level.filtered_weapon.size > 0 )
        {
            for( i = 0; i < level.filtered_weapon.size; i++ )
            {
                if( IsDefined( level.filtered_weapon[i] ) && current_weapon == level.filtered_weapon[i] )
                {
                    wait 0.5;
                    continue;
                }
            }
        }

        totalCurrentWeaponAmmo = self GetAmmoCount( current_weapon );
        if( totalCurrentWeaponAmmo == 0 )
        {
            wait 2;
            if( self GetCurrentWeapon() != current_weapon || self GetAmmoCount( current_weapon ) != 0 )
            {
                wait 0.5;
                continue;
            }

            self.no_ammo_cooldown = true;
            self thread player_vox_helper( ::no_ammo_vox, "no_ammo_sound_done" );
            self thread no_ammo_cooldown_reset();
        }

        wait 0.5;
    }
}

player_reload_sounds()
{
    self endon( "death" );
    self endon( "disconnect" );

    self.reload_cooldown = false;

    while( 1 )
    {
        self waittill( "reload_start" );
        wait 0.05;

        current_weapon = self GetCurrentWeapon();
        if( IsDefined( level.filtered_weapon ) && level.filtered_weapon.size > 0 )
        {
            for( i = 0; i < level.filtered_weapon.size; i++ )
            {
                if( IsDefined( level.filtered_weapon[i] ) && current_weapon == level.filtered_weapon[i] )
                {
                    continue;
                }
            }
        }

        if( !self.reload_cooldown )
        {
            zombies = GetAiArray( "axis" );
            level.zombies_are_close = 0;
            for( i = 0; i < zombies.size; i++ )
            {
                if( IsDefined( zombies[i] ) && IsAlive( zombies[i] ) )
                {
                    if( zombies[i].origin[2] < self.origin[2] + 80 &&
                        zombies[i].origin[2] > self.origin[2] - 80 &&
                        Distance( zombies[i].origin, self.origin ) <= 225 )
                    {
                        level.zombies_are_close = 1;
                        break;
                    }
                }
            }

            if( self.reloading && get_enemy_count() + level.zombie_total >= 6 && level.zombies_are_close == 1 )
            {
                self.reload_cooldown = true;
                self thread player_vox_helper( ::reload_vox_sound, "reloading_sound_done" );
                self thread reload_cooldown_reset();
            }
        }
        wait 0.05;
    }
}

player_swarm_monitor()
{
    self endon( "death" );
    self endon( "disconnect" );

    if( !IsDefined( self ) || !IsPlayer( self ) )
        return;

    self.swarm_cooldown = false;

    while( 1 )
    {
        if( !self.swarm_cooldown )
        {
            zombies = GetAiArray( "axis" );
            zombies_nearby = 0;

            for( i = 0; i < zombies.size; i++ )
            {
                zombie = zombies[i];
                if( !IsDefined( zombie ) || !IsAlive( zombie ) )
                    continue;

                if( zombie.origin[2] < self.origin[2] + 80 &&
                    zombie.origin[2] > self.origin[2] - 80 &&
                    Distance( zombie.origin, self.origin ) <= 200 )
                {
                    zombies_nearby++;
                }
            }

            if( zombies_nearby >= 6 )
            {
                chance = 50;
                if( RandomInt( 100 ) < chance )
                {
                    self.swarm_cooldown = true;
                    self thread player_vox_helper( ::swarm_sound, "swarm_sound_done" );
                    self thread swarm_cooldown_reset();
                }
            }
        }

        wait 0.5;
    }
}

player_throw_molotov_exert_sounds()
{
    self endon( "death" );

    while( 1 )
    {
        self waittill( "grenade_fire", grenade2, weaponName );

        if( weaponName == "molotov" && self IsThrowingGrenade() )
        {
            self thread player_vox_helper( ::molotov_vox_sound, "molotov_sound_done" );
        }
    }
}

player_throw_stielhandgranate_exert_sounds()
{
    self endon( "death" );

    while( 1 )
    {
        self waittill( "grenade_fire", grenade, weaponName );

        if( weaponName == "Stielhandgranate" && self IsThrowingGrenade() )
        {
            self thread player_vox_helper( ::stielhandgranate_vox_sound, "stielhandgranate_sound_done" );
        }
        wait 0.05;
    }
}

quip_sound_trigger()
{
    self endon("disconnect");

    // Skip if on sound cooldown
    if (IsDefined(self.quip_sound_cooldown) && self.quip_sound_cooldown)
        return;

    self.quip_sound_cooldown = true;

    self thread maps\_sounds::player_vox_helper( maps\_sounds::quip_sound, "quip_sound_done", 6.0 );

    self thread quip_sound_cooldown_reset();
}

reload_cooldown_reset()
{
    wait 5;
    self.reload_cooldown = false;
}

swarm_cooldown_reset()
{
    wait 7;
    self.swarm_cooldown = false;
}

quip_sound_cooldown_reset()
{
    wait 2; // 2-second cooldown to prevent sound spam
    self.quip_sound_cooldown = false;
}
