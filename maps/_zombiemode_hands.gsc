#include maps\_utility; 
#include common_scripts\utility; 
#include maps\_zombiemode_utility;

init()
{
	PrecacheItem( "zombie_death_hands" );
    PrecacheItem( "zombie_knuckle_crack" );
}

do_knuckle_crack()
{
    currentGun = self upgrade_knuckle_crack_begin();
    
    self.is_drinking = 1;
    self waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );
    
    self upgrade_knuckle_crack_end( currentGun );
    self.is_drinking = undefined;
}

upgrade_knuckle_crack_begin()
{
    self DisableOffhandWeapons();
    self DisableWeaponCycling();

    self AllowLean( false );
    self AllowAds( false );
    self AllowSprint( false );
    self AllowProne( false );		
    self AllowMelee( false );

    if ( self GetStance() == "prone" )
    {
        self SetStance( "crouch" );
    }

    currentGun = self GetCurrentWeapon();

    if ( currentGun != "none" && currentGun != "mine_bouncing_betty" )
    {
        self TakeWeapon( currentGun );
    }

    self GiveWeapon( "zombie_knuckle_crack" );
    self SwitchToWeapon( "zombie_knuckle_crack" );

    return currentGun;
}

upgrade_knuckle_crack_end( currentGun )
{
    self EnableOffhandWeapons();
    self EnableWeaponCycling();

    self AllowLean( true );
    self AllowAds( true );
    self AllowSprint( true );
    self AllowProne( true );
    self AllowMelee( true );

    // TODO: race condition?
    if ( self maps\_laststand::player_is_in_laststand() )
    {
        self TakeWeapon( "zombie_knuckle_crack" );
        return;
    }

    cabinetGun = self GetWeaponsListPrimaries();
    switchToGun = undefined;

    if ( isDefined( cabinetGun[0] ) && cabinetGun[0] == "stg44_pap" ||
         isDefined( cabinetGun[1] ) && cabinetGun[1] == "stg44_pap" ||
         isDefined( cabinetGun[2] ) && cabinetGun[2] == "stg44_pap" )
    {
        switchToGun = "stg44_pap";
    }

    if ( isDefined( switchToGun ) )
    {
        self SwitchToWeapon( switchToGun );
    }

    if ( isDefined( currentGun ) && currentGun != "none" )
    {
        self GiveWeapon( currentGun );
    }
}