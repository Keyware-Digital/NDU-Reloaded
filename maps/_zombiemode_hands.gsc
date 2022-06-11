// Put knuckle_crack and death_hands here. Hands related stuff.

/*#include maps\_utility; 
#include common_scripts\utility; 
#include maps\_zombiemode_utility;

init()
{
    PrecacheItem( "zombie_knuckle_crack" );
}

	player thread do_knuckle_crack();

do_knuckle_crack()
{
	gun = self upgrade_knuckle_crack_begin();
	
	self.is_drinking = 1;
	self waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );
	
	self upgrade_knuckle_crack_end( gun );
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

	primaries = self GetWeaponsListPrimaries();

	gun = self GetCurrentWeapon();
	weapon = "zombie_knuckle_crack";
	
	if ( gun != "none" && gun != "mine_bouncing_betty" )
	{
		self TakeWeapon( gun );
	}
	else
	{
		return;
	}

	if( primaries.size <= 1 )
	{
		self GiveWeapon( "zombie_colt" );
	}
	
	self GiveWeapon( weapon );
	self SwitchToWeapon( weapon );

	return gun;
}

upgrade_knuckle_crack_end( gun )
{
	assert( gun != "zombie_perk_bottle_doubletap" );
	assert( gun != "zombie_perk_bottle_revive" );
	assert( gun != "zombie_perk_bottle_jugg" );
	assert( gun != "zombie_perk_bottle_sleight" );
	assert( gun != "syrette" );

	self EnableOffhandWeapons();
	self EnableWeaponCycling();

	self AllowLean( true );
	self AllowAds( true );
	self AllowSprint( true );
	self AllowProne( true );		
	self AllowMelee( true );
	weapon = "zombie_knuckle_crack";

	// TODO: race condition?
	if ( self maps\_laststand::player_is_in_laststand() )
	{
		self TakeWeapon(weapon);
		return;
	}

	self TakeWeapon(weapon);
	primaries = self GetWeaponsListPrimaries();
	if( isDefined( primaries ) && primaries.size > 0 )
	{
		self SwitchToWeapon( primaries[0] );
	}
	else
	{
		self SwitchToWeapon( "zombie_colt" );
	}
}*/

