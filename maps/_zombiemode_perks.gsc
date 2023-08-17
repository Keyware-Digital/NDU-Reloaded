#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;

init() {
    init_precache();
    init_perk_fx();
    init_perk_vars();

}

init_precache() {
    PrecacheShader("specialty_juggernaut_zombies");
    PrecacheShader("specialty_speed_cola_zombies");
    PrecacheShader("specialty_double_tap_zombies");
    PrecacheShader("specialty_quick_revive_zombies");
    PrecacheShader("specialty_phd_zombies");
    PrecacheShader("specialty_deadshot_daiquiri_zombies");
    PrecacheShader("specialty_elemental_pop_zombies");
    PrecacheShader("specialty_stamin_up_zombies");
    PrecacheShader("specialty_electric_cherry_zombies");
    PrecacheShader("specialty_mule_kick_zombies");
    PrecacheShader("specialty_mule_kick_glow_zombies");
    PrecacheShader("specialty_widows_wine_zombies");
    PrecacheItem( "zombie_knuckle_crack" );
}

init_perk_fx() {
    level._effect["fx_zmb_phdflopper_exp"] = loadfx ("maps/zombie/fx_zmb_phdflopper_exp");

}

init_perk_vars() {
	set_zombie_var("phd_max_range", 185); //PHD damage range
	set_zombie_var("phd_dive_damage", 5000); //PHD fall damage on zombies
    set_zombie_var("phd_minimum_fall", 20); //Minimum fall height required to activate PHD, 20 stops small height inclines from activating PHD
    set_zombie_var("staminup_sprint_scale", 1.07); //Leightweight
    set_zombie_var("staminup_sprint_max_duration", 8); //Marathon
    set_zombie_var("doubletap_fire_rate", 0.75); //Double taps fire multiplier, 0.0 to 1.0
    set_zombie_var("speed_reload_rate", 0.5); //Speed cola reload multiplier, 0.0 to 1.0
    set_zombie_var("juggernaut_health", 200); //Juggernaut health of player
	set_zombie_var("deadshot_spread_multiplier", 0.4225); //Deadshot hip fire reduction
	set_zombie_var("deadshot_extra_breath_time", 5); //Deadshot extra breath time
	set_zombie_var("mulekick_min_weapon_slots", 2); //Default weapon slots
	set_zombie_var("mulekick_max_weapon_slots",	3); //Mule Kick weapon slots
}

random_perk_powerup_think() {

    if (!isDefined(self.perknum) || self.perknum == 0) // if player doesn't have any perks
    {
        self thread resetperkdefs();
        self thread death_check();
    }

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        if (players[i].perknum == 11) // Disable Random Perk if everyone has max perks
        {
            level.zombie_vars["enableRandomPerk"] = 0;     
        }
        else if (players[i].perknum < 11 && level.zombie_vars["enableRandomPerk"] == 1)
        {
            level.zombie_vars["enableRandomPerk"] = 1;
        }
    }

    if (self maps\_laststand::player_is_in_laststand() || self.perknum == 11) // Max perks
    {
        return;
    }

    if (self.perkarray[self.perknum] == "specialty_armorvest") {
        self.maxhealth = level.zombie_vars["juggernaut_health"];
    }

    if (self.perkarray[self.perknum] == "specialty_fastreload") {
        self setClientDvar("perk_weapReloadMultiplier", level.zombie_vars["speed_reload_rate"]);
    }

    if (self.perkarray[self.perknum] == "specialty_longersprint") {
		self.movementSpeed = level.zombie_vars["staminup_sprint_scale"];
        self setMoveSpeedScale(level.zombie_vars["staminup_sprint_scale"] );
		self setClientDvar("player_sprintTime", level.zombie_vars["staminup_sprint_max_duration"]);
    }

    if (self.perkarray[self.perknum] == "specialty_explosivedamage") {
		self setClientDvar("player_hud_specialty_electric_cherry", 1);
    }

    if (self.perkarray[self.perknum] == "specialty_bulletaccuracy") {
		self setClientDvar("perk_weapSpreadMultiplier", level.zombie_vars["deadshot_spread_multiplier"]);
		self SetPerk("specialty_holdbreath"); //Iron lungs
		self setClientDvar("perk_extraBreath", level.zombie_vars["deadshot_extra_breath_time"]);
    }

    if(self.perkarray[self.perknum] == "specialty_extraammo") {
		self.muleCount = level.zombie_vars["mulekick_max_weapon_slots"];
        /*if (isDefined(self.muleLastWeapon))
	    {				
	        self GiveWeapon(self.muleLastWeapon);
	    }*/
    }

    self SetPerk(self.perkarray[self.perknum]);
    self perk_hud_create(self.perkarray[self.perknum]);

    self.perknum++; // add 1 perk to counter
}

resetperkdefs() {
    self.perkarray = [];
    self.perkarray[0] = "specialty_armorvest";
    self.perkarray[1] = "specialty_rof";
    self.perkarray[2] = "specialty_fastreload";
    self.perkarray[3] = "specialty_quickrevive";
    self.perkarray[4] = "specialty_detectexplosive";
    self.perkarray[5] = "specialty_longersprint";
    self.perkarray[6] = "specialty_bulletaccuracy";
    self.perkarray[7] = "specialty_explosivedamage";
    self.perkarray[8] = "specialty_boost";
    self.perkarray[9] = "specialty_extraammo";
    self.perkarray[10] = "specialty_specialgrenade";
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

	self UnsetPerk("specialty_holdbreath"); //Iron lungs (part of Deadshot Daiquiri)
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

    case "specialty_quickrevive":
        shader = "specialty_quick_revive_zombies";
        break;

    case "specialty_fastreload":
        shader = "specialty_speed_cola_zombies";
        break;

    case "specialty_rof":
        shader = "specialty_double_tap_zombies";
        break;

    case "specialty_detectexplosive":
        shader = "specialty_phd_zombies";
        break;

    case "specialty_longersprint":
        shader = "specialty_stamin_up_zombies";
        break;

    case "specialty_bulletaccuracy":
        shader = "specialty_deadshot_daiquiri_zombies";
        break;

    case "specialty_explosivedamage":
        shader = "specialty_elemental_pop_zombies";
        break;

    case "specialty_boost":
        shader = "specialty_electric_cherry_zombies";
        break;

    case "specialty_extraammo":
        shader = "specialty_mule_kick_zombies";
        break;

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
    hud.x = self.perk_hud.size * 30;
    hud.y = hud.y - 70;
    hud.alpha = 1;
    hud SetShader(shader, 24, 24);

    self.perk_hud[perk] = hud;
}

perk_hud_destroy(perk) {

    self.perk_hud[perk] destroy_hud();
    self.perk_hud[perk] = undefined;
}

play_no_money_perk_dialog() {

    index = maps\_zombiemode_weapons::get_player_index(self);

    player_index = "plr_" + index + "_";
    if (!isDefined(self.vox_nomoney_perk)) {
        num_variants = maps\_zombiemode_spawner::get_number_variants(player_index + "vox_nomoney_perk");
        self.vox_nomoney_perk = [];
        for (i = 0; i < num_variants; i++) {
            self.vox_nomoney_perk[self.vox_nomoney_perk.size] = "vox_nomoney_perk_" + i;
        }
        self.vox_nomoney_perk_available = self.vox_nomoney_perk;
    }
    sound_to_play = random(self.vox_nomoney_perk_available);

    self.vox_nomoney_perk_available = array_remove(self.vox_nomoney_perk_available, sound_to_play);

    if (self.vox_nomoney_perk_available.size < 1) {
        self.vox_nomoney_perk_available = self.vox_nomoney_perk;
    }

    self maps\_zombiemode_spawner::do_player_playdialog(player_index, sound_to_play, 0.25);

}

phd_dive_damage(origin)
{
    self thread maps\_sounds::phd_explosion_sound();
	playFx( level._effect["fx_zmb_phdflopper_exp"], self.origin + ( 0, 0, 50 ));
	self VisionSetNaked("zombie_cosmodrome_divetonuke", 1);
    wait 0.5;
    self VisionSetNaked("zombie", 1);
		
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
	
	wait 0.2;

}

player_switch_weapon_watcher()
{
	self endon( "disconnect" );

	while(1)
	{
		self waittill( "weapon_change_complete" );		
		
		if (self hasPerk("specialty_extraammo"))
		{
			if (isDefined(self.perk_hud["specialty_extraammo"]))
			{
				current_weapon = self getCurrentWeapon();
		
				if (isDefined(self.muleLastWeapon) && current_weapon == self.muleLastWeapon)
				{
					self.perk_hud["specialty_extraammo"] setShader("specialty_mule_kick_glow_zombies", 24, 24);
                    self setClientDvar("player_hud_specialty_mule_kick", 1);
				}
				else
				{
					self.perk_hud["specialty_extraammo"] setShader("specialty_mule_kick_zombies", 24, 24);
                    self setClientDvar("player_hud_specialty_mule_kick", 0);
				}
			}
		}
	}
}

//Fixed ugly bug while holding and/or cooking the grenade
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

solo_quickrevive() // numan solo revive function
{
    // gather some info

    self.inSoloRevive = true;
    self.firstPistol = level.player_specific_add_weapon[maps\_zombiemode_weapons::get_player_index(self)];
    self.currentWeapon = self GetCurrentWeapon();
    self.currentStance = self GetStance();
    clipAmmo = undefined;
    weaponAmmo = undefined;
    lastStandAmmo = undefined;
    lastStandGun = undefined;
    lastStandClip = undefined;

    playerweapons = self GetWeaponsList(); // returns an array of weapons and also weapons ammo
    for (i = 0; i < playerweapons.size; i++) {
        clipAmmo[i] = self GetWeaponAmmoClip(playerweapons[i]);
        weaponAmmo[i] = self GetWeaponAmmoStock(playerweapons[i]);
        wait 0.05;
    }

	if (isDefined(self.muleLastWeapon))
	{
		self TakeWeapon(self.muleLastWeapon);
	}

    if (self IsThrowingGrenade()) {
        self FreezeControls(true); // literally just to throw player's current grenade if they're stupid enough to play hot potato
        wait 0.05;
        self FreezeControls(false);
    }

    // start zombies targeting spawn struct instead. Rest is changed in zombiemode_spawner find_flesh() because we have to overwrite regular targeting.

    self.ignoreme = true;

    // put player in prone for now

    self AllowSprint(false);
    self AllowStand(false);
    self AllowCrouch(false);
    self SetStance("prone");

    self VisionSetNaked("laststand", 1);

    // if player has better downed gun, give it and check for ammo, then return it later

    self DisableWeaponCycling();

    if (self HasWeapon("ray_gun_mk1_v2")) {
        lastStandAmmo = 20;
        lastStandClip = 20;
        lastStandGun = "ray_gun_mk1_v2";
    } else if (self HasWeapon("sw_357")) {
        lastStandAmmo = 18;
        lastStandClip = 6;
        lastStandGun = "sw_357";
    } else if (self HasWeapon("walther") || self.firstPistol == "walther") {
        lastStandAmmo = 24;
        lastStandClip = 8;
        lastStandGun = "walther";
    } else if (self HasWeapon("tokarev") || self.firstPistol == "tokarev") {
        lastStandAmmo = 24;
        lastStandClip = 8;
        lastStandGun = "tokarev";
    } else {
        lastStandAmmo = 24;
        lastStandClip = 8;
        lastStandGun = "colt";
    }

    self TakeAllWeapons();

    self GiveWeapon(lastStandGun);
    self SwitchToWeapon(lastStandGun);
    self SetWeaponAmmoClip(lastStandGun, lastStandClip);
    self SetWeaponAmmoStock(lastStandGun, lastStandAmmo);

    soloReviveTime = 10;

    if (!isDefined(self.soloReviveProgressBar))
        self.soloReviveProgressBar = self maps\_hud_util::createPrimaryProgressBar();

    self.soloReviveProgressBar.alignX = "center";
    self.soloReviveProgressBar.alignY = "middle";
    self.soloReviveProgressBar.horzAlign = "center";
    self.soloReviveProgressBar.vertAlign = "bottom";
    self.soloReviveProgressBar.y = -190;

    self.soloReviveProgressBar maps\_hud_util::updateBar(0.01, 1 / soloReviveTime);

    // wait for revive and play text

    self.revive_hud setText( &"GAME_REVIVING", " ", self);
    self maps\_laststand::revive_hud_show();
    self.revive_hud.alignX = "center";
    self.revive_hud.alignY = "middle";
    self.revive_hud.horzAlign = "center";
    self.revive_hud.vertAlign = "bottom";
    self.revive_hud.y = -210;

    wait 10;

    if (isDefined(self.soloReviveProgressBar)) {
        self.soloReviveProgressBar maps\_hud_util::destroyElem();
    }

    if (isDefined(self.revive_hud)) {
        self maps\_laststand::revive_hud_hide();
    }

    // revert everything

    if (self.currentWeapon != lastStandGun) {
        self TakeAllWeapons();
    }

    for (i = 0; i < playerweapons.size; i++) {
        if (weaponType(playerweapons[i]) == "grenade") {
            self GiveWeapon(playerweapons[i]);
            self SetWeaponAmmoClip(playerweapons[i], clipAmmo[i]);
        } else {
            //IPrintLn(playerweapons[i]);
            self GiveWeapon(playerweapons[i]);
            self SetWeaponAmmoClip(playerweapons[i], clipAmmo[i]);
            self SetWeaponAmmoStock(playerweapons[i], weaponAmmo[i]);
        }
        wait 0.05;
    }

    self SwitchToWeapon(self.currentWeapon);
    self EnableWeaponCycling();

    self.inSoloRevive = undefined;

    self VisionSetNaked("zombie", 1);

    self AllowSprint(true);
    self AllowStand(true);
    self AllowCrouch(true);
    self SetStance("stand");

    self SetStance(self.currentStance);

    self.ignoreme = false;
}

mule_kick_function(old_weapon, new_weapon)
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
