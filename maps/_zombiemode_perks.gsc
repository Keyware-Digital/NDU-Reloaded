#include maps\_utility;

#include common_scripts\utility;

#include maps\_zombiemode_utility;

init() {
    init_precache();
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

random_perk_powerup_think() {

    if (!isdefined(self.perknum) || self.perknum == 0) // if player doesnt have any perks
    {
        self thread resetperkdefs();
        self thread death_check();
    }

    if (self maps\_laststand::player_is_in_laststand() || self.perknum == 8) //max perks
    {
        return;
    }

    if (self.perkarray[self.perknum] == "specialty_armorvest") {
        self.maxhealth = 200;
    }

    if (self.perkarray[self.perknum] == "specialty_longersprint") {
        self SetMoveSpeedScale(1);
        self setClientDvar("perk_sprintMultiplier", "1");
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