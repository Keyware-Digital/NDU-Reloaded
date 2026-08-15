#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;

#using_animtree( "generic_human" );

init()
{
    self endon( "death" );
    level endon( "intermission" );

    self.dodge_cooldown     = false;
    self.dodge_animating    = false;
    self.a.steppedDir       = 0;
    self.a.lastSideStepTime = 0;

    if( !isDefined( level.dodge_settings_inited ) )
    {
        level.MIN_DODGE_DIST_SQ       = 48 * 48;
        level.MAX_DODGE_DIST_SQ       = 1500 * 1500; // was 1200 * 1200
        level.DODGE_REACTION_INTERVAL = 1500;   // was 1600
        level.dodge_settings_inited   = true;
    }

    while( 1 )
    {
        if( self.dodge_cooldown || self.dodge_animating )
        {
            wait( 0.35 );
            continue;
        }

        // Do not dodge while underground.
        if( !IsAlive( self ) || !self.has_legs || ( isDefined( self.in_the_ground ) && self.in_the_ground ) )
        {
            wait( 0.45 );
            continue;
        }

        // Zombie must have breached its entrance / barrier.
        if( !isDefined( self.dodge_allowed ) || !self.dodge_allowed )
        {
            wait( 0.45 );
            continue;
        }

        if( GetTime() - self.a.lastSideStepTime < level.DODGE_REACTION_INTERVAL )
        {
            wait( 0.15 );
            continue;
        }

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

            start = player GetEye();
            end   = start + ( AnglesToForward( player GetPlayerAngles() ) * 10000 );
            trace = BulletTrace( start, end, true, player );

            // Did the player's ADS trace actually hit this zombie?
            if( !isDefined( trace["entity"] ) || trace["entity"] != self )
                continue;

            distSq = DistanceSquared( self.origin, player.origin );
            if( distSq < level.MIN_DODGE_DIST_SQ || distSq > level.MAX_DODGE_DIST_SQ )
                continue;

            // 4% chance
            if( RandomInt( 100 ) >= 4 ) // was 3%
                continue;

            // IMPORTANT: only set global AFTER we know the dodge will actually play!
            self thread dodge( player );
            break;
        }

        wait( 0.1 );
    }
}

dodge( player )
{
    self endon( "death" );

    if( !IsAlive( self ) || self.dodge_cooldown || self.dodge_animating )
        return;

    self.dodge_cooldown     = true;
    self.dodge_animating    = true;
    self.a.lastSideStepTime = GetTime();

    anim_name = pick_dodge_anim();
    anime     = level.scr_anim["zombie"][anim_name];

    if( !IsDefined( anime ) )
    {
        self.dodge_animating = false;
        self.dodge_cooldown  = false;
        return;
    }

    // Proper Treyarch-style room/geo check
    if( !self mayMoveToPoint( self getAnimEndPos( anime ) ) )
    {
        self.dodge_animating = false;
        self.dodge_cooldown  = false;
        return;
    }

    // Only lock the player once we know the dodge will actually play
    if( isDefined( player ) && IsAlive( player ) )
    {
        player.dodge_global_cooldown = true;
        player thread dodge_global_cooldown_reset();
    }

    // Direction memory (rolls ignored)
    if( isSubStr( anim_name, "left" ) )
        self.a.steppedDir--;
    else if( isSubStr( anim_name, "right" ) )
        self.a.steppedDir++;

    self thread maps\_sounds::zombie_dodge_sound();

    if( !IsAlive( self ) )
    {
        self.dodge_animating = false;
        self.dodge_cooldown  = false;
        return;
    }

    self AnimMode( "gravity", false );
    self OrientMode( "face angle", self.angles[1] );

    self AnimScripted( "zombie_dodge", self.origin, self.angles, anime );

    wait( GetAnimLength( anime ) );

    if( IsAlive( self ) )
    {
        self AnimMode( "none", false );
        self OrientMode( "face default" );
    }

    self.dodge_animating = false;

    // Per-zombie hard cooldown to mitigate spam
    wait( 1 );  // was 5, primarily using interval instead
    self.dodge_cooldown = false;
}

pick_dodge_anim()
{
    if( self.a.steppedDir < 0 )
    {
        anims = [];
        anims[anims.size] = "sidestep_right_a";
        anims[anims.size] = "sidestep_right_b";
        return anims[ RandomInt( anims.size ) ];
    }
    else if( self.a.steppedDir > 0 )
    {
        anims = [];
        anims[anims.size] = "sidestep_left_a";
        anims[anims.size] = "sidestep_left_b";
        return anims[ RandomInt( anims.size ) ];
    }

    anims = [];
    anims[anims.size] = "roll_a";
    anims[anims.size] = "roll_b";
    anims[anims.size] = "roll_c";
    anims[anims.size] = "sidestep_left_a";
    anims[anims.size] = "sidestep_left_b";
    anims[anims.size] = "sidestep_right_a";
    anims[anims.size] = "sidestep_right_b";
    return anims[ RandomInt( anims.size ) ];
}

dodge_global_cooldown_reset()
{
    self endon( "death" );
    self endon( "disconnect" );

    wait( 1 );
    self.dodge_global_cooldown = false;
}