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

    if(isDefined(player.has_betties) && player.has_betties)
    {
        filtered = array_remove(filtered, "mine_bouncing_betty");
    }

    return filtered[RandomInt( filtered.size )];
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

    if(rand == "mine_bouncing_betty")
    {
        player thread weapons_death_check();
    }

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

    self.has_betties = undefined;
}