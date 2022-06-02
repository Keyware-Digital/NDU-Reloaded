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
    PrecacheShader("specialty_widows_wine_zombies");
}

init_perk_fx() {
    level._effect[ "fx_zmb_phdflopper_exp" ]	= loadfx ( "maps/zombie/fx_zmb_phdflopper_exp" );

}

init_perk_vars() {
	set_zombie_var("phd_max_range", 185); // PHD damage range
	set_zombie_var("phd_fall_damage", 1500); // PHD fall damage on zombies
	set_zombie_var("phd_fall_damage_multiplier", 2); // PHD extra damage if fall damage is bigger than player health
	set_zombie_var("phd_dive_damage", 5000); // PHD fall damage on zombies
    set_zombie_var("phd_minimum_fall", 20); // Minimum fall height required to activate PHD, 20 stops small height inclines from activating PHD
    set_zombie_var("staminup_sprint_scale", 1.07); // Leightweight
    set_zombie_var("staminup_sprint_max_duration", 8); // Marathon
    set_zombie_var("doubletap_fire_rate", 0.75); // Double taps fire multiplier, 0.0 to 1.0
    set_zombie_var("speed_reload_rate", 0.5); // Speed cola reload multiplier, 0.0 to 1.0
    set_zombie_var("juggernaut_health", 200); // Juggernaut health of player
}

random_perk_powerup_think() {

    if (!isdefined(self.perknum) || self.perknum == 0) // if player doesn't have any perks
    {
        self thread resetperkdefs();
        self thread death_check();
    }

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        if (!isdefined(players[i].perknum) || players[i].perknum == 11) // Disable Random Perk if everyone has max perks
        {
            level.zombie_vars[ "enableRandomPerk" ] = 0;     
        }
    }

    if (self maps\_laststand::player_is_in_laststand() || self.perknum == 11) // Max perks
    {
        return;
    }

    if (self.perkarray[self.perknum] == "specialty_armorvest") {
        self.maxhealth = level.zombie_vars[ "juggernaut_health" ];
    }

    if (self.perkarray[self.perknum] == "specialty_fasreload") {
        self setClientDvar( "perk_weapReloadMultiplier", level.zombie_vars[ "speed_reload_rate" ] );
    }

    if (self.perkarray[self.perknum] == "specialty_longersprint") {
        self setMoveSpeedScale( level.zombie_vars[ "staminup_sprint_scale" ] );
		self setClientDvar( "player_sprintTime", level.zombie_vars[ "staminup_sprint_max_duration" ] );
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
    self.perkarray[8] = "specialty_electriccherry";
    self.perkarray[9] = "specialty_mulekick";
    self.perkarray[10] = "specialty_widowswine";
    self.perkarray = array_randomize(self.perkarray);

    self.perknum = 0;
}

death_check() {

    self waittill_any("fake_death", "death", "player_downed", "second_chance");

    self UnsetPerk("specialty_armorvest");
    self UnsetPerk("specialty_quickrevive");
    self UnsetPerk("specialty_fastreload");
    self UnsetPerk("specialty_rof");
    self UnsetPerk("specialty_detectexplosive");
    self UnsetPerk("specialty_longersprint");
    self UnsetPerk("specialty_bulletaccuracy");
    self UnsetPerk("specialty_explosivedamage");
    self UnsetPerk("specialty_bulletdamage");
    self UnsetPerk("specialty_electriccherry");
    self UnsetPerk("specialty_mulekick");
    self UnsetPerk("specialty_widowswine");
    self perk_hud_destroy("specialty_armorvest");
    self perk_hud_destroy("specialty_quickrevive");
    self perk_hud_destroy("specialty_fastreload");
    self perk_hud_destroy("specialty_rof");
    self perk_hud_destroy("specialty_detectexplosive");
    self perk_hud_destroy("specialty_longersprint");
    self perk_hud_destroy("specialty_bulletaccuracy");
    self perk_hud_destroy("specialty_explosivedamage");
    self perk_hud_destroy("specialty_bulletdamage");
    self perk_hud_destroy("specialty_electriccherry");
    self perk_hud_destroy("specialty_mulekick");
    self perk_hud_destroy("specialty_widowswine");
    self.maxhealth = 100;
    self SetMoveSpeedScale(1);
    self setClientDvar("player_sprintTime", "4");

    wait(0.01);

    self.perknum = 0;
}

perk_hud_create(perk) {

    if (!IsDefined(self.perk_hud)) {
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

    case "specialty_electriccherry":
        shader = "specialty_electric_cherry_zombies";
        break;

    case "specialty_mulekick":
        shader = "specialty_mule_kick_zombies";
        break;

    case "specialty_widowswine":
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
    if (!IsDefined(self.vox_nomoney_perk)) {
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

phd_fall_damage(iDamage, point, attacker, type)
{

    self EnableInvulnerability();

	explosion = "explode_" + RandomInt(2);

	PlaySoundAtPosition(explosion, self.origin);
	playFx( level._effect["fx_zmb_phdflopper_exp"], self.origin + ( 0, 0, 50 ));
	self VisionSetNaked("zombie_cosmodrome_divetonuke", 1);
    wait 0.5;
    self VisionSetNaked("zombie", 1);
		
	phd_damage = level.zombie_vars[ "phd_fall_damage" ] + iDamage;
	if (iDamage > self.health)
	{
		// Extra damage if the fall would actually kill you.
		phd_damage = phd_damage * level.zombie_vars[ "phd_fall_damage_multiplier" ];
	}
	
	zombies = GetAiSpeciesArray( "axis", "all" );
	for(i = 0; i < zombies.size; i++)
	{
		if ( distance( self.origin, zombies[i].origin ) <= level.zombie_vars[ "phd_max_range" ] )
		{
			if ( isDefined( level.zombie_vars["zombie_powerup_insta_kill_on"] ) && level.zombie_vars["zombie_powerup_insta_kill_on"] )
			phd_damage = zombies[i].health + 666;
		
			if (zombies[i].health <= phd_damage)
			{
                maps\_zombiemode_spawner::zombie_gib_on_damage(point, attacker, type);
				zombies[i] DoDamage( phd_damage , zombies[i].origin, point, attacker, type, self);
                //zombies[i] maps\_zombiemode_spawner::zombie_gib_on_damage(); // this needs to gib zombies like in BO1, currently gibs player
			}
			else
			{
                maps\_zombiemode_spawner::zombie_gib_on_damage(point, attacker, type);
				zombies[i] DoDamage( phd_damage , zombies[i].origin, point, attacker, type, self);
                //zombies[i] maps\_zombiemode_spawner::zombie_gib_on_damage(); // this needs to gib zombies like in BO1, currently gibs player
			}			
		}
		wait .01;
	}

    self DisableInvulnerability();
	
	wait 0.2;
}

phd_dive_damage(origin, point, attacker, type)
{

    self EnableInvulnerability();

	explosion = "explode_" + RandomInt(2);

	PlaySoundAtPosition(explosion, self.origin);
	playFx( level._effect["fx_zmb_phdflopper_exp"], origin + ( 0, 0, 50 ));
	self VisionSetNaked("cheat_contrast", 0.2);
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
                maps\_zombiemode_spawner::zombie_gib_on_damage(point, attacker, type);
				zombies[i] DoDamage( phd_damage , zombies[i].origin, point, attacker, type, self);
                //zombies[i] maps\_zombiemode_spawner::zombie_gib_on_damage(self, "J_Head"); // this needs to gib zombies like in BO1, currently gibs player
			}
			else
			{
                maps\_zombiemode_spawner::zombie_gib_on_damage(point, attacker, type);
				zombies[i] DoDamage( phd_damage , zombies[i].origin, point, attacker, type, self);
                //zombies[i] maps\_zombiemode_spawner::zombie_gib_on_damage(self, "J_Head"); // this needs to gib zombies like in BO1, currently gibs player
			}
		}
		wait .01;
	}

    self DisableInvulnerability();
	
	wait 0.2;
}

perks_zombie_hit_effect(amount, attacker, point, mod)
{
	if( !isDefined(attacker) || !isAlive( self ) || !isPlayer( attacker ) )
	{
		return;
	}
	
	is_dog = self enemy_is_dog();

	hitLocation = self.damageLocation;
	health = self.health;
	

	if( mod != "MOD_PISTOL_BULLET" && mod != "MOD_RIFLE_BULLET")
	{
		return;
	}

    // Double Tap 2.0
	if( isDefined(attacker) && isplayer(attacker) && isAlive(attacker) )
	{
		if(attacker HasPerk("specialty_rof") && ( mod == "MOD_PISTOL_BULLET" || mod == "MOD_RIFLE_BULLET" ) )		//change specialty to "bulletdamage" for stopping power
		{
            self setClientDvar( "perk_weapRateMultiplier", level.zombie_vars[ "doubletap_fire_rate" ] );
		    attacker maps\_zombiemode_score::player_add_points( "damage", mod, hitLocation, is_dog );
		    health = health - amount;
		}
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

perks_quick_revive_think(iDamage) {

    players = GetPlayers();

    if (isdefined(self.inSoloRevive)) {
        return;
    }    

    if (self HasPerk("specialty_quickrevive") && self.health < iDamage && players.size == 1) {
        self notify("second_chance");
        self thread solo_quickrevive(); // custom solo revive function below
        return;
    }

}

solo_quickrevive() // numan solo revive function
{
    // gather some info

    self.inSoloRevive = true;
    self.defaultPistol = level.player_specific_add_weapon[maps\_zombiemode_weapons::get_player_index(self)];
    self.currentweapon = self GetCurrentWeapon();
    self.currentstance = self GetStance();
    clipammo = undefined;
    weaponammo = undefined;
    lstandammo = undefined;
    lstandgun = undefined;
    lstandclip = undefined;

    playerweapons = self GetWeaponsList(); // returns an array of weapons and also weapons ammo
    for (i = 0; i < playerweapons.size; i++) {
        clipammo[i] = self GetWeaponAmmoClip(playerweapons[i]);
        weaponammo[i] = self GetWeaponAmmoStock(playerweapons[i]);
        wait 0.05;
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

    iPrintLn(self.defaultPistol);

    self DisableWeaponCycling();

    if (self HasWeapon("ray_gun")) {
        lstandammo = 20;
        lstandclip = 20;
        lstandgun = "ray_gun";
    } else if (self HasWeapon("sw_357")) {
        lstandammo = 18;
        lstandclip = 6;
        lstandgun = "sw_357";
    } else if (self HasWeapon("walther") || self.defaultPistol == "walther") {
        lstandammo = 24;
        lstandclip = 8;
        lstandgun = "walther";
    } else if (self HasWeapon("tokarev") || self.defaultPistol == "tokarev") {
        lstandammo = 24;
        lstandclip = 8;
        lstandgun = "tokarev";
    } else {
        lstandammo = 24;
        lstandclip = 8;
        lstandgun = "colt";
    }

    self TakeAllWeapons();

    self GiveWeapon(lstandgun);
    self SwitchToWeapon(lstandgun);
    self SetWeaponAmmoClip(lstandgun, lstandclip);
    self SetWeaponAmmoStock(lstandgun, lstandammo);

    soloReviveTime = 10;

    if (!isdefined(self.soloReviveProgressBar))
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

    if (isdefined(self.soloReviveProgressBar)) {
        self.soloReviveProgressBar maps\_hud_util::destroyElem();
    }

    if (isdefined(self.revive_hud)) {
        self maps\_laststand::revive_hud_hide();
    }

    // revert everything

    if (self.currentweapon != lstandgun) {
        self TakeAllWeapons();
    }

    for (i = 0; i < playerweapons.size; i++) {
        if (weaponType(playerweapons[i]) == "grenade") {
            self GiveWeapon(playerweapons[i]);
            self SetWeaponAmmoClip(playerweapons[i], clipammo[i]);
        } else {
            //IPrintLn(playerweapons[i]);
            self GiveWeapon(playerweapons[i]);
            self SetWeaponAmmoClip(playerweapons[i], clipammo[i]);
            self SetWeaponAmmoStock(playerweapons[i], weaponammo[i]);
        }
        wait 0.05;
    }

    self SwitchToWeapon(self.currentweapon);
    self EnableWeaponCycling();

    self.inSoloRevive = undefined;

    self VisionSetNaked("zombie", 1);

    self AllowSprint(true);
    self AllowStand(true);
    self AllowCrouch(true);
    self SetStance("stand");

    self SetStance(self.currentstance);

    self.ignoreme = false;
}