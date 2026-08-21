#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;

// inspired by CoD WaW: Zombies Remastered, with thanks

track_molotov()
{
    self endon( "disconnect" );
    self waittill( "spawned_player" );

    for( ;; )
    {
        self waittill( "grenade_fire", grenade, weapon_name );

        if( isSubStr( weapon_name, "molotov" ) )
        {
            grenade thread molotov_grenade_think( self );
        }
    }
}

molotov_grenade_think( player )
{
    // Wait until the grenade stops moving
    old_pos = self.origin;
    velocity_sq = 10000 * 10000;

    while( velocity_sq > 0 )
    {
        wait( 0.05 );
        velocity_sq = DistanceSquared( self.origin, old_pos );
        old_pos = self.origin;
    }

    // Don't start fire underwater
    if( self depthinwater() > 0 )
        return;

    // Create the fire (radius, height, duration)
    self thread fire_burn_radius( player, 75, 15, 7.0 );    // was 80, 15, 8.0
}

fire_burn_radius( attacker, radius, height, duration )
{
    fire_trigger = Spawn( "trigger_radius", self.origin, 0, radius, height );
    time_left = duration;

    while( time_left > 0 )
    {
        wait( 0.05 );
        time_left -= 0.05;

        zombies = get_array_of_closest( fire_trigger.origin, GetAiArray( "axis" ) );

        for( i = 0; i < zombies.size; i++ )
        {
            zombie = zombies[i];

            if( !IsDefined( zombie ) || !zombie IsTouching( fire_trigger ) )
                continue;

            if( IsDefined( zombie.molotov_flamed ) && zombie.molotov_flamed )
                continue;

            zombie.molotov_flamed = true;

            // Visuals (limit full flame FX to closest 4 to avoid spam)
            if( i < 4 )
                zombie thread animscripts\death::flame_death_fx();
            else
                zombie StartTanning();

            zombie thread molotov_burn_damage( attacker );
        }
    }

    fire_trigger Delete();
}

molotov_burn_damage( player )
{
    self endon( "death" );

    ticks_left = RandomIntRange( 2, 5 );		// 2–4 ticks

    if( self.moveplaybackrate > 0.85 )
        self.moveplaybackrate = 0.85;

    while( ticks_left > 0 )
    {
    if( level.round_number < 6 )
        dmg = level.zombie_health * RandomFloatRange( 0.25, 0.33 ); // was 0.2, 0.3
    else if( level.round_number < 9 )
        dmg = level.zombie_health * RandomFloatRange( 0.17, 0.27 ); // was 0.15, 0.25
    else if( level.round_number < 11 )
        dmg = level.zombie_health * RandomFloatRange( 0.12, 0.22 ); // was 0.10, 0.20
    else
        dmg = level.zombie_health * RandomFloatRange( 0.10, 0.17 ); // was 0.10, 0.15

        if( IsDefined( player ) && IsAlive( player ) )
            self DoDamage( dmg, self.origin, player );
        else
            self DoDamage( dmg, self.origin, level );

        ticks_left--;

        if( ticks_left <= 0 )
            break;

        wait( RandomFloatRange( 1.0, 2.33 ) );  // was 3.0
    }

    self.molotov_flamed = undefined;
}