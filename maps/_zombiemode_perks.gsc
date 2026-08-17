#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include maps\_hud_util;
//#include maps\_sounds;

init() {
    init_precache();
    init_perk_fx();
    init_perk_vars();

    level.reviveUsesLeft = level.zombie_vars[ "quick_revive_solo_max_times" ];
    level.is_solo_revive_distraction_active = false;
    level.zombiegoto = undefined;
}

init_precache() {
    PrecacheShader("specialty_deadshot_daiquiri_zombies");
    PrecacheShader("specialty_double_tap_zombies");
    PrecacheShader("specialty_electric_cherry_zombies");
    PrecacheShader("specialty_elemental_pop_zombies");
    PrecacheShader("specialty_juggernaut_zombies");
    //PrecacheShader("specialty_melee_macchiato_zombies");
    PrecacheShader("specialty_mule_kick_zombies");
    PrecacheShader("specialty_mule_kick_glow_zombies");
    PrecacheShader("specialty_phd_zombies");
    PrecacheShader("specialty_quick_revive_zombies");
    PrecacheShader("specialty_speed_cola_zombies");
    PrecacheShader("specialty_stamin_up_zombies");
    //PrecacheShader("specialty_tombstone_zombies");
    //PrecacheShader("specialty_vulture_aid_zombies");
    PrecacheShader("specialty_widows_wine_zombies");
    PrecacheModel("char_usa_raider_gear_flametank");
}

init_perk_fx() {
    level._effect["phdflopper_explosion"] = loadfx ("maps/zombie/fx_zmb_phdflopper_exp");

}

init_perk_vars() {
set_zombie_var("deadshot_extra_breath_time", 5); //Deadshot extra breath time
set_zombie_var("deadshot_spread_multiplier", 0.4225); //Deadshot hip fire reduction
set_zombie_var("doubletap_fire_rate", 0.75); //Double taps fire multiplier, 0.0 to 1.0
set_zombie_var("juggernaut_health", 200); //Juggernaut health of player
set_zombie_var("melee_macchiato_multiplier", 1.30); // Melee Macchiato damage multiplier
set_zombie_var("mulekick_max_weapon_slots", 3); //Mule Kick weapon slots
set_zombie_var("mulekick_min_weapon_slots", 2); //Default weapon slots
set_zombie_var("phd_dive_damage", 5000); //PHD fall damage on zombies
set_zombie_var("phd_max_range", 185); //PHD damage range
set_zombie_var("phd_minimum_fall", 20); //Minimum fall height required to activate PHD, 20 stops small height inclines from activating PHD
set_zombie_var("quick_revive_solo_max_times", 3); //Three revives solo only
set_zombie_var("speed_reload_rate", 0.5); //Speed cola reload multiplier, 0.0 to 1.0
set_zombie_var("staminup_sprint_max_duration", 8); //Marathon
set_zombie_var("staminup_sprint_scale", 1.07); //Lightweight
}

random_perk_powerup_think() {

    if (!isDefined(self.perknum) || self.perknum == 0) // if player doesn't have any perks
    {
        self thread resetperkdefs();
        self thread death_check();
    }

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        //if (players[i].perknum == 11) // old hardcoded perk limit
        if ( isDefined( players[i].perkarray ) && players[i].perknum >= players[i].perkarray.size ) // Disable Random Perk if this player has max perks
        {
            level.zombie_vars["enableRandomPerk"] = 0;
        }
        //else if (players[i].perknum < 11 && level.zombie_vars["enableRandomPerk"] == 1)
        else if ( isDefined( players[i].perkarray ) && players[i].perknum < players[i].perkarray.size && level.zombie_vars["enableRandomPerk"] == 1 )
        {
            level.zombie_vars["enableRandomPerk"] = 1;
        }
    }

    //if (self maps\_laststand::player_is_in_laststand() || self.perknum == 11) // Max perks
    if ( self maps\_laststand::player_is_in_laststand() || !isDefined( self.perkarray ) || self.perknum >= self.perkarray.size ) // Max perks
    {
        return;
    }

    perk = self.perkarray[self.perknum];

    if (perk == "specialty_armorvest") {
        self.maxhealth = level.zombie_vars["juggernaut_health"];
    }

    if (perk == "specialty_fastreload") {
        self setClientDvar("perk_weapReloadMultiplier", level.zombie_vars["speed_reload_rate"]);
    }

    if (perk == "specialty_longersprint") {
        self.movementSpeed = level.zombie_vars["staminup_sprint_scale"];
        self setMoveSpeedScale(level.zombie_vars["staminup_sprint_scale"] );
        self setClientDvar("player_sprintTime", level.zombie_vars["staminup_sprint_max_duration"]);
    }

    if (perk == "specialty_explosivedamage") {
        self setClientDvar("player_hud_specialty_electric_cherry", 1);
    }

    if (perk == "specialty_bulletaccuracy") {
        self setClientDvar("perk_weapSpreadMultiplier", level.zombie_vars["deadshot_spread_multiplier"]);
        self SetPerk("specialty_holdbreath"); //Iron lungs
        self setClientDvar("perk_extraBreath", level.zombie_vars["deadshot_extra_breath_time"]);
    }

    if(perk == "specialty_extraammo") {
        self.muleCount = level.zombie_vars["mulekick_max_weapon_slots"];
        /*if (isDefined(self.muleLastWeapon))
        {				
            self GiveWeapon(self.muleLastWeapon);
        }*/
    }

    self SetPerk(perk);
    self perk_hud_create(perk);

    self.perknum++; // add 1 perk to counter
}

resetperkdefs()
{
    self.perkarray = [];
    //self.perkarray[0] = "";
    self.perkarray[ self.perkarray.size ] = "specialty_armorvest";
    self.perkarray[ self.perkarray.size ] = "specialty_boost";
    self.perkarray[ self.perkarray.size ] = "specialty_bulletaccuracy";
    self.perkarray[ self.perkarray.size ] = "specialty_detectexplosive";
    self.perkarray[ self.perkarray.size ] = "specialty_explosivedamage";
    self.perkarray[ self.perkarray.size ] = "specialty_extraammo";
    self.perkarray[ self.perkarray.size ] = "specialty_fastreload";
    self.perkarray[ self.perkarray.size ] = "specialty_longersprint";
    //self.perkarray[ self.perkarray.size ] = "specialty_melee_macchiato_zombies";

    // Only include Quick Revive if solo uses are still available
    if ( !( get_players().size == 1 && isDefined( level.reviveUsesLeft ) && level.reviveUsesLeft <= 0 ) )
    {
        self.perkarray[ self.perkarray.size ] = "specialty_quickrevive";
    }

    self.perkarray[ self.perkarray.size ] = "specialty_rof";
    self.perkarray[ self.perkarray.size ] = "specialty_specialgrenade";
    //self.perkarray[ self.perkarray.size ] = "specialty_tombstone_zombies";
    //self.perkarray[ self.perkarray.size ] = "specialty_vulture_aid_zombies";

    self.perkarray = array_randomize(self.perkarray);

    self.perknum = 0;
}

death_check() {

    self waittill_any("fake_death", "death", "player_downed", "second_chance");

	self setMoveSpeedScale(1);

    for (i = 0; i < self.perkarray.size; i++)
    {
        self UnSetPerk(self.perkarray[i]);
        self perk_hud_destroy(self.perkarray[i]);
    }

	self UnsetPerk("specialty_holdbreath"); // Iron lungs (part of Deadshot Daiquiri)
	self setClientDvar("player_sprintTime", 4);
	self setClientDvar("perk_weapSpreadMultiplier", 0.65);
    self setClientDvar("player_hud_specialty_electric_cherry", 0);
    self setClientDvar("player_hud_specialty_mule_kick", 0);

    self.maxhealth = 100;
	self.movementSpeed = 1;
	if ( isDefined(self.muleLastWeapon) )
	{				
		self TakeWeapon( self.muleLastWeapon );
	}
			
	self.muleCount = level.zombie_vars[ "mulekick_min_weapon_slots" ];
	self.muleLastWeapon = undefined;

    wait(0.01);

    self.perknum = 0;
}

perk_hud_create(perk) {

    if (!isDefined(self.perk_hud)) {
        self.perk_hud = [];
    }

    shader = "";

    switch (perk) {
    case "specialty_armorvest":
        shader = "specialty_juggernaut_zombies";
        break;
    case "specialty_boost":
        shader = "specialty_electric_cherry_zombies";
        break;
    case "specialty_bulletaccuracy":
        shader = "specialty_deadshot_daiquiri_zombies";
        break;
    case "specialty_detectexplosive":
        shader = "specialty_phd_zombies";
        break;
    case "specialty_explosivedamage":
        shader = "specialty_elemental_pop_zombies";
        break;
    case "specialty_extraammo":
        shader = "specialty_mule_kick_zombies";
        break;
    case "specialty_fastreload":
        shader = "specialty_speed_cola_zombies";
        break;
    case "specialty_longersprint":
        shader = "specialty_stamin_up_zombies";
        break;
    /*case "specialty_melee_macchiato_zombies":
        shader = "specialty_melee_macchiato_zombies";
        break;*/
    case "specialty_quickrevive":
        shader = "specialty_quick_revive_zombies";
        break;
    case "specialty_rof":
        shader = "specialty_double_tap_zombies";
        break;
    case "specialty_specialgrenade":
        shader = "specialty_widows_wine_zombies";
        break;
    /*case "specialty_tombstone_zombies":
        shader = "specialty_tombstone_zombies";
        break;
    case "specialty_vulture_aid_zombies":
        shader = "specialty_vulture_aid_zombies";
        break;*/
    default:
        shader = "";
        break;
    }

    hud = create_simple_hud(self);
    hud.foreground = true;
    hud.sort = 1;
    hud.hidewheninmenu = false;
    hud.alignX = "left";
    hud.alignY = "bottom";
    hud.horzAlign = "left";
    hud.vertAlign = "bottom";
    hud.x = self.perk_hud.size * 30;
    hud.y = hud.y - 70;
    hud.alpha = 1;
    hud SetShader(shader, 24, 24);

    self.perk_hud[perk] = hud;
}

perk_hud_destroy(perk)
{
    if (isDefined(self.perk_hud) && isDefined(self.perk_hud[perk]))
    {
        self.perk_hud[perk] destroy_hud();
        self.perk_hud[perk] = undefined;
    }
}

phd_dive_damage(origin) {
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

phd_dive_vision() {

    self VisionSetNaked("zombie_cosmodrome_divetonuke", 0.1); //important, do not change, fade-in time
    wait 1; //change time between visions, can change
    self VisionSetNaked("zombie_bo3", 1); //important do not change, fade-in time

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

// Fixed nasty bug while holding and/or cooking the grenade
player_cook_grenade_watcher()
{
	self endon( "disconnect" ); 

	while(1)
	{
		self waittill("grenade_fire", grenade, weaponName);

		if(isDefined(grenade))
		{
			wait 0.125;
			
			if (isDefined(grenade) && distance( self.origin, grenade.origin ) <= 0 && self fragButtonPressed() && self isThrowingGrenade())
			{
				self FreezeControls(true);
				self DisableOffhandWeapons();
				
				grenade delete();
				
				ammo_clip = self GetWeaponAmmoClip( weaponName );
				self TakeWeapon(weaponName);
				
				if(self fragButtonPressed())
				{
					self waittill("grenade_fire", grenade2, weaponName);
					if(isDefined(grenade2))
					{
						grenade2 delete();
					}
				}
				
				wait 0.05;
				
				self EnableOffhandWeapons();
				self FreezeControls(false);
				
				wait 1.75;
				
				self GiveWeapon(weaponName);
				self SetWeaponAmmoClip(weaponName, ammo_clip);
			}
		}
	}
}

perks_zombie_hit_effect(amount, attacker, point, mod)
{
	if( !isDefined(attacker) || !isAlive( self ) || !isPlayer( attacker ) )
	{
		return;
	}

    /*// Melee macchiato logic
    if ( mod == "MOD_MELEE" && attacker hasPerk( "specialty_melee_macchiato_zombies" ) )
    {
        extra = int( amount * ( level.zombie_vars["melee_macchiato_multiplier"] - 1.0 ) );
        if ( extra > 0 )
        {
            self DoDamage( extra, point, attacker );
        }
        return;
    }*/

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
