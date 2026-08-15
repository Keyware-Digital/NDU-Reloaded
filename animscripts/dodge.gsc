#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;

#using_animtree( "generic_human" );


init()
{
	self endon( "death" );
	level endon( "intermission" );

	self.dodge_cooldown = false;
	self.dodge_animating = false;

	//IPrintLnBold( "^2DODGE MONITOR STARTED" );

	while( 1 )
	{
		wait( 0.1 );

		if( self.dodge_cooldown )
			continue;

		if( self.dodge_animating )
			continue;

		if( !self.has_legs )
			continue;

		// Do not dodge while underground.
		if( isDefined( self.in_the_ground ) && self.in_the_ground )
			continue;

		// Zombie must have breached its entrance / barrier.
		if( !isDefined( self.dodge_allowed ) || !self.dodge_allowed )
			continue;

		players = GetPlayers();

		for( i = 0; i < players.size; i++ )
		{
			player = players[i];

			if( !isDefined( player ) || !IsAlive( player ) )
				continue;

			if( player maps\_laststand::player_is_in_laststand() )
				continue;

			// Must actually be ADS.
			if( !player AdsButtonPressed() )
				continue;

			// Prevent several zombies from dodging from the same ADS sweep.
			if( isDefined( player.dodge_global_cooldown ) && player.dodge_global_cooldown )
				continue;

			// Use the same proven ADS trace already used elsewhere in the codebase.
			start = player GetEye();
			end = start + (AnglesToForward( player GetPlayerAngles() ) * 10000);

			trace = BulletTrace( start, end, true, player );

			// Did the player's ADS trace actually hit this zombie?
			if( isDefined( trace["entity"] ) && trace["entity"] == self )
			{
				// 3% chance.
				if( RandomInt( 100 ) < 3 )
				{
					// Short global cooldown for this player.
					player.dodge_global_cooldown = true;
					player thread dodge_global_cooldown_reset();

					self thread dodge();
					break;
				}
			}
		}
	}
}

dodge()
{
    self endon( "death" );

    if( self.dodge_cooldown || self.dodge_animating )
        return;

    self.dodge_cooldown = true;
    self.dodge_animating = true;

    anims = [];

	// rolls disabled as they're a bit buggy in WaW
    //anims[anims.size] = "roll_a";
    //anims[anims.size] = "roll_b";
    //anims[anims.size] = "roll_c";
    anims[anims.size] = "sidestep_left_a";
    anims[anims.size] = "sidestep_left_b";
    anims[anims.size] = "sidestep_right_a";
    anims[anims.size] = "sidestep_right_b";

    anim_name = anims[RandomInt(anims.size)];
    anime = level.scr_anim["zombie"][anim_name];

    // IPrintLnBold( "^3ZOMBIE DODGE: " + anim_name );

    self thread maps\_sounds::zombie_taunt_sound();
    // wait( 0.05 );

    self AnimScripted( "zombie_dodge", self.origin, self.angles, anime );

    wait( GetAnimLength( anime ) );

    self.dodge_animating = false;

    // Per-zombie cooldown.
    wait( 7 );

    self.dodge_cooldown = false;
}

dodge_global_cooldown_reset()
{
	self endon( "death" );
	self endon( "disconnect" );

	wait( 1 );

	self.dodge_global_cooldown = false;
}