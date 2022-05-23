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
    PrecacheShader("specialty_fast_reload_zombies");
    PrecacheShader("specialty_double_tap_zombies");
    PrecacheShader("specialty_quick_revive_zombies");
    PrecacheShader("specialty_phd_zombies");
    PrecacheShader("specialty_aim_zombies");
    PrecacheShader("specialty_fireworks_zombies");
    PrecacheShader("specialty_longer_sprint_zombies");
    PrecacheShader("specialty_electric_cherry_zombies");
    PrecacheShader("specialty_mule_kick_zombies");
    PrecacheShader("specialty_widows_wine_zombies");
}

init_perk_fx() {
	level._effect[ "fx_zombie_mini_nuke" ]	= loadfx ( "misc/fx_zombie_mini_nuke" );
    level._effect[ "fx_zmb_phdflopper_exp" ]	= loadfx ( "maps/zombie/fx_zmb_phdflopper_exp" );

}

init_perk_vars() {
	set_zombie_var( "phd_max_range",					300 );		// PHD nuke effects range
	set_zombie_var( "phd_use_fall_damage",				0 );		// Use my solution that when the player normally receives fall damage it will also creates a d2p explosive (1 = yes, 0 = no)
	set_zombie_var( "phd_fall_damage",					1500 );		// PHD nuke effects fall damage on zombies
	set_zombie_var( "phd_fall_damage_multiplier",		2 );		// PHD nuke extra damage if fall damage is bigger than player it's health
	set_zombie_var( "phd_d2p_damage",					5000 );		// PHD nuke effects fall damage on zombies
	set_zombie_var( "phd_d2p_points",					50 );		// PHD nuke Points given for a kill
}

random_perk_powerup_think() {

    if (!isdefined(self.perknum) || self.perknum == 0) // if player doesnt have any perks
    {
        self thread resetperkdefs();
        self thread death_check();
    }

    if (self maps\_laststand::player_is_in_laststand() || self.perknum == 11) //max perks
    {
        return;
    }

    if (self.perkarray[self.perknum] == "specialty_armorvest") {
        self.maxhealth = 200;
    }

    if (self.perkarray[self.perknum] == "specialty_longersprint") {
        self SetMoveSpeedScale(1.07);   //Lightweight
        self setClientDvar("perk_sprintMultiplier", "2");   //Marathon
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
    self setClientDvar("perk_sprintMultiplier", "1");

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
        shader = "specialty_fast_reload_zombies";
        break;

    case "specialty_rof":
        shader = "specialty_double_tap_zombies";
        break;

    case "specialty_detectexplosive":
        shader = "specialty_phd_zombies";
        break;

    case "specialty_longersprint":
        shader = "specialty_longer_sprint_zombies";
        break;

    case "specialty_bulletaccuracy":
        shader = "specialty_aim_zombies";
        break;

    case "specialty_explosivedamage":
        shader = "specialty_fireworks_zombies";
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

phd_fall_damage(iDamage)
{

    self EnableInvulnerability();

	explosion = "explode_" + RandomInt(2);

	PlaySoundAtPosition(explosion, self.origin);
	playFx( level._effect["fx_zmb_phdflopper_exp"], self.origin + ( 0, 0, 50 ));
	self VisionSetNaked("cheat_contrast", 0.2);
    wait 1;
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
				zombies[i] DoDamage( phd_damage, zombies[i].origin, self);
			}
			else
			{
				zombies[i] DoDamage( phd_damage , zombies[i].origin, self);
			}			
		}
		wait .01;
	}

    self DisableInvulnerability();
	
	wait 0.2;
}

phd_dive_damage(origin)
{

    self EnableInvulnerability();

	explosion = "explode_" + RandomInt(2);

	PlaySoundAtPosition(explosion, self.origin);
	playFx( level._effect["fx_zmb_phdflopper_exp"], origin + ( 0, 0, 50 ));
	self VisionSetNaked("cheat_contrast", 0.2);
    wait 1;
    self VisionSetNaked("zombie", 1);
		
	phd_damage = level.zombie_vars[ "phd_d2p_damage" ];
	
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
			}
			else
			{
				zombies[i] DoDamage( phd_damage , zombies[i].origin, self);

			}
		}
		wait .01;
	}

    self DisableInvulnerability();
	
	wait 0.2;
}