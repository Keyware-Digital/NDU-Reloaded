#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include maps\_zombiemode_net;
#include maps\_hud_util;
//#include maps\_sounds;

init() {
    init_precache();
    init_perk_fx();
    init_perk_vars();

    level.reviveUsesLeft = level.zombie_vars[ "quick_revive_solo_max_times" ];
    level.is_solo_revive_distraction_active = false;
}

init_precache() {
    PrecacheShader("specialty_deadshot_daiquiri_zombies");
    PrecacheShader("specialty_double_tap_zombies");
    PrecacheShader("specialty_electric_cherry_zombies");
    PrecacheShader("specialty_elemental_pop_zombies");
    PrecacheShader("specialty_juggernaut_zombies");
    PrecacheShader("specialty_melee_macchiato_zombies");
    PrecacheShader("specialty_mule_kick_zombies");
    PrecacheShader("specialty_mule_kick_glow_zombies");
    PrecacheShader("specialty_phd_zombies");
    PrecacheShader("specialty_quick_revive_zombies");
    PrecacheShader("specialty_speed_cola_zombies");
    PrecacheShader("specialty_stamin_up_zombies");
    //PrecacheShader("specialty_tombstone_zombies");
    //PrecacheShader("specialty_vulture_aid_zombies");
    PrecacheShader("specialty_widows_wine_zombies");
}

init_perk_fx() {
    level._effect["phdflopper_explosion"] = loadfx ("maps/zombie/fx_zmb_phdflopper_exp");

}

init_perk_vars() {
set_zombie_var("deadshot_extra_breath_time", 5); //Deadshot extra breath time
set_zombie_var("deadshot_spread_multiplier", 0.4225); //Deadshot hip fire reduction
set_zombie_var("doubletap_fire_rate", 0.75); //Double taps fire multiplier, 0.0 to 1.0
set_zombie_var("electric_cherry_max_range", 300 );      // max radius of the shockwave
set_zombie_var("electric_cherry_max_damage", 1000 );    // max damage of the shockwave
set_zombie_var("electric_cherry_points", 40 );          // points awarded on kill
set_zombie_var("tesla_head_gib_chance", 50 );           // % chance for head gib FX (optional but used)
set_zombie_var("juggernaut_health", 200); //Juggernaut health of player
set_zombie_var("melee_macchiato_multiplier", 1.75); // Melee Macchiato damage multiplier, was 1.66
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
        self.health    = level.zombie_vars["juggernaut_health"];
    }

    if (perk == "specialty_bulletaccuracy") {
        self setClientDvar("perk_weapSpreadMultiplier", level.zombie_vars["deadshot_spread_multiplier"]);
        self SetPerk("specialty_holdbreath"); //Iron lungs
        self setClientDvar("perk_extraBreath", level.zombie_vars["deadshot_extra_breath_time"]);
    }

    if (perk == "specialty_explosivedamage") {
        self setClientDvar("player_hud_specialty_elemental_pop", 1);
    }

    if(perk == "specialty_extraammo") {
        self.muleCount = level.zombie_vars["mulekick_max_weapon_slots"];
        /*if (isDefined(self.muleLastWeapon))
        {				
            self GiveWeapon(self.muleLastWeapon);
        }*/
    }

    if (perk == "specialty_fastreload") {
        self setClientDvar("perk_weapReloadMultiplier", level.zombie_vars["speed_reload_rate"]);
    }

    if (perk == "specialty_longersprint") {
        self.movementSpeed = level.zombie_vars["staminup_sprint_scale"];
        self setMoveSpeedScale(level.zombie_vars["staminup_sprint_scale"] );
        self setClientDvar("player_sprintTime", level.zombie_vars["staminup_sprint_max_duration"]);
    }

    self SetPerk(perk);
    self perk_hud_create(perk);

    if ( perk == "specialty_boost" )
    {
        self thread electric_cherry_function();
    }

    self.perknum++; // add 1 perk to counter
}

resetperkdefs()
{
    self.perkarray = [];
    //self.perkarray[0] = "";
    self.perkarray[ self.perkarray.size ] = "specialty_armorvest";          // Juggernog
    self.perkarray[ self.perkarray.size ] = "specialty_boost";              // Electric Cherry
    self.perkarray[ self.perkarray.size ] = "specialty_bulletaccuracy";     // Deadshot Daiquiri
    self.perkarray[ self.perkarray.size ] = "specialty_detectexplosive";    // PhD Flopper
    self.perkarray[ self.perkarray.size ] = "specialty_explosivedamage";    // Elemental Pop
    self.perkarray[ self.perkarray.size ] = "specialty_extraammo";          // Mule Kick
    self.perkarray[ self.perkarray.size ] = "specialty_fastreload";         // Speed Cola
    self.perkarray[ self.perkarray.size ] = "specialty_longersprint";       // Stamin-Up
    self.perkarray[ self.perkarray.size ] = "specialty_ordinance";          // Melee Macchiato
    //self.perkarray[ self.perkarray.size ] = "specialty_recon";            // Vulture Aid
    self.perkarray[ self.perkarray.size ] = "specialty_rof";                // Double Tap
    //self.perkarray[ self.perkarray.size ] = "specialty_shades";           // Tombstone
    self.perkarray[ self.perkarray.size ] = "specialty_specialgrenade";     // Widows Wine

    // Only include Quick Revive if solo uses are still available
    if ( !( get_players().size == 1 && isDefined( level.reviveUsesLeft ) && level.reviveUsesLeft <= 0 ) )
    {
        self.perkarray[ self.perkarray.size ] = "specialty_quickrevive";
    }

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
    self setClientDvar("player_hud_specialty_elemental_pop", 0);
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

    switch (perk)
    {
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
        case "specialty_ordinance":
            shader = "specialty_melee_macchiato_zombies";
            break;
        case "specialty_quickrevive":
            shader = "specialty_quick_revive_zombies";
            break;
        /*case "specialty_recon":
            shader = "specialty_vulture_aid_zombies";
            break;*/
        case "specialty_rof":
            shader = "specialty_double_tap_zombies";
            break;
        /*case "specialty_shades":
            shader = "specialty_tombstone_zombies";
            break;*/
        case "specialty_specialgrenade":
            shader = "specialty_widows_wine_zombies";
            break;
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
    hud.x = 96 + self.perk_hud.size * 30;
    hud.y = hud.y - 5;
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

                // Original (kept for reference – would crash on non-"zombie" animname):
                // zombies[k].deathanim = random( level._zombie_tesla_death[ zombies[k].animname ] );

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
                // No dogs on this map – dog check disabled
                // if ( zombies[k].ignoreall == false && zombies[k].animname != "zombie_dog" )
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

    // No dogs on this map – dog check disabled
    // if ( !self enemy_is_dog() )
    // {
        if ( RandomInt( 100 ) < level.zombie_vars[ "tesla_head_gib_chance" ] )
        {
            wait( RandomFloat( 0.53, 1.0 ) );
            self maps\_zombiemode_spawner::zombie_head_gib();
        }
        else
        {
            network_safe_play_fx_on_tag( "tesla_death_fx", 2, level._effect[ "tesla_shock_eyes" ], self, "J_Eyeball_LE" );
        }
    // }
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

    // Melee Macchiato logic (now using specialty_ordinance)
    if (mod == "MOD_MELEE" && attacker hasPerk("specialty_ordinance"))
    {
        extra = int(amount * (level.zombie_vars["melee_macchiato_multiplier"] - 1.0));
        if (extra > 0)
        {
            self DoDamage(extra, point, attacker);
            //attacker iPrintLnBold("^2Melee Macchiato: +" + extra + " bonus damage");
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