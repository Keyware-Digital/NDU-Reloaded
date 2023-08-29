#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;

announcer_vox_bonus_points_sound() {
    pickup_bonus_points_sound = Spawn("script_origin", self.origin);
	pickup_bonus_points_sound PlaySound("bp_vox", "bp_vox_sound_done");
	pickup_bonus_points_sound waittill("bp_vox_sound_done");
	pickup_bonus_points_sound Delete();
}

announcer_vox_carpenter_sound() {
    pickup_carpenter_sound = Spawn("script_origin", self.origin);
	pickup_carpenter_sound PlaySound("carp_vox", "carp_vox_sound_done");
	pickup_carpenter_sound waittill("carp_vox_sound_done");
	pickup_carpenter_sound Delete();
}

announcer_vox_death_machine_sound() {
    pickup_death_machine_sound = Spawn("script_origin", self.origin);
	pickup_death_machine_sound PlaySound("dm_vox", "dm_vox_sound_done");
	pickup_death_machine_sound waittill("dm_vox_sound_done");
	pickup_death_machine_sound Delete();
}

announcer_vox_double_points_sound() {
    pickup_double_points_sound = Spawn("script_origin", self.origin);
	pickup_double_points_sound PlaySound("dp_vox", "dp_vox_sound_done");
	pickup_double_points_sound waittill("dp_vox_sound_done");
	pickup_double_points_sound Delete();
}

announcer_vox_fire_sale_sound() {
    pickup_fire_sale_sound = Spawn("script_origin", self.origin);
	pickup_fire_sale_sound PlaySound("fs_vox", "fs_vox_sound_done");
	pickup_fire_sale_sound waittill("fs_vox_sound_done");
	pickup_fire_sale_sound Delete();
}

announcer_vox_insta_kill_sound() {
    pickup_insta_kill_sound = Spawn("script_origin", self.origin);
	pickup_insta_kill_sound PlaySound("insta_vox", "insta_vox_sound_done");
	pickup_insta_kill_sound waittill("insta_vox_sound_done");
	pickup_insta_kill_sound Delete();
}

announcer_vox_max_ammo_sound() {
    pickup_max_ammo_sound = Spawn("script_origin", self.origin);
	pickup_max_ammo_sound PlaySound("ma_vox", "ma_vox_sound_done");
	pickup_max_ammo_sound waittill("ma_vox_sound_done");
	pickup_max_ammo_sound Delete();
}

announcer_vox_nuke_sound() {
    pickup_nuke_sound = Spawn("script_origin", self.origin);
	pickup_nuke_sound PlaySound("nuke_vox", "nuke_vox_sound_done");
	pickup_nuke_sound waittill("nuke_vox_sound_done");
	pickup_nuke_sound Delete();
}

pain_vox_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    painSound = "_pain_exert_" + RandomInt(8);
    pain_vox_sound = Spawn("script_origin", self.origin);
	pain_vox_sound PlaySound("plr_" + index + painSound, "pain_exert_sound_done");
    pain_vox_sound waittill("pain_exert_sound_done");
	pain_vox_sound Delete();
    
}

death_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    deathSound = "_death_" + RandomInt(3);
    death_sound = Spawn("script_origin", self.origin);
	death_sound PlaySound("plr_" + index + deathSound, "death_sound_done");
    death_sound waittill("death_sound_done");
	death_sound Delete();
    
}

melee_vox_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    meleeSound = "_knife_exert_" + RandomInt(3);
    melee_vox_sound = Spawn("script_origin", self.origin);
	melee_vox_sound PlaySound("plr_" + index + meleeSound, "knife_exert_sound_done");
	melee_vox_sound waittill("knife_exert_sound_done");
	melee_vox_sound Delete();
	wait 0.55;	//cool down to prevent duplicate sounds on knife lunges

	self notify("melee_sound_finished");

}

stielhandgranate_vox_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    stielhandgranateSound = "_stielhandgranate_exert_" + RandomInt(6);
    stielhandgranate_vox_sound = Spawn("script_origin", self.origin);
	stielhandgranate_vox_sound PlaySound("plr_" + index + stielhandgranateSound, "stielhandgranate_exert_sound_done");
	stielhandgranate_vox_sound waittill("stielhandgranate_exert_sound_done");
	stielhandgranate_vox_sound Delete();

	self notify("stielhandgranate_sound_finished");

}

molotov_vox_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    molotovSound = "_molotov_exert_" + RandomInt(3);
    molotov_vox_sound = Spawn("script_origin", self.origin);
	molotov_vox_sound PlaySound("plr_" + index + molotovSound, "molotov_exert_sound_done");
	molotov_vox_sound waittill("molotov_exert_sound_done");
	molotov_vox_sound Delete();

	self notify("molotov_sound_finished");

}

reload_vox_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    reloadSound = "_vox_reload_" + RandomInt(2);
    reload_vox_sound = Spawn("script_origin", self.origin);
	reload_vox_sound PlaySound("plr_" + index + reloadSound, "vox_reload_sound_done");
	reload_vox_sound waittill("vox_reload_sound_done");
	reload_vox_sound Delete();

	self notify("reloading_sound_finished");

}

no_ammo_vox() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    noAmmoSound = "_no_ammo";
    no_ammo_vox_sound = Spawn("script_origin", self.origin);
	no_ammo_vox_sound PlaySound("plr_" + index + noAmmoSound, "no_ammo_sound_done");
	no_ammo_vox_sound waittill("no_ammo_sound_done");
	no_ammo_vox_sound Delete();

	self notify("no_ammo_sound_finished");
	
}

powerup_start_sound() {
    level.powerup_sound = Spawn("script_origin", self.origin);
	level.powerup_sound PlaySound("spawn_powerup");
    level.powerup_sound PlayLoopSound("spawn_powerup_loop");

}

powerup_end_sound() {
    level.powerup_sound StopLoopSound();
	level.powerup_sound PlaySound("powerup_grabbed", "powerup_grabbed_sound_done");
    level.powerup_sound waittill("powerup_grabbed_sound_done");
	level.powerup_sound Delete();

}

dolphin_dive_launch_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
	launch = "_launch_exert_" + RandomInt(6);
	launch_sound = Spawn("script_origin", self.origin);
    launch_sound PlaySound("plr_" + index + launch, "launch_exert_sound_done");
	launch_sound waittill("launch_exert_sound_done");
	launch_sound Delete();

}

dolphin_dive_land_sound() {
	land = "_land_exert_" + RandomInt(6);
	index = maps\_zombiemode_weapons::get_player_index(self);
	land_sound = Spawn("script_origin", self.origin);
    land_sound PlaySound( "plr_" + index + land, "land_exert_sound_done");
	land_sound waittill("land_exert_sound_done");
	land_sound Delete();

}

phd_explosion_sound() {
    explosion = "explode_" + RandomInt(3);
    explosion_sound = Spawn("script_origin", self.origin);
    explosion_sound PlaySound(explosion, "explode_sound_done");
    explosion_sound waittill("explode_sound_done");
	explosion_sound Delete();

}

mystery_box_lock_sound() {
    mystery_box_lock_sound = Spawn("script_origin", self.origin);
	mystery_box_lock_sound PlaySound("mystery_box_lock", "mystery_box_lock_sound_done");
	mystery_box_lock_sound waittill("mystery_box_lock_sound_done");
	mystery_box_lock_sound Delete();

	self notify("mystery_box_lock_sound_finished");

}

mystery_box_unlock_sound() {
	mystery_box_unlock_sound = Spawn("script_origin", self.origin);
	mystery_box_unlock_sound PlaySound("mystery_box_unlock", "mystery_box_unlock_sound_done");
	mystery_box_unlock_sound waittill("mystery_box_unlock_sound_done");
	mystery_box_unlock_sound Delete();

	self notify("mystery_box_unlock_sound_finished");

}

cabinet_sound() {
	cabinetSong = "cabinetbox_sting_" + RandomInt(3);
	cabinet_sound = Spawn("script_origin", self.origin);
	cabinet_sound PlaySound(cabinetSong, "cabinetbox_sting_sound_done");
	cabinet_sound waittill("cabinetbox_sting_sound_done");
	cabinet_sound Delete();

}

raygun_stinger_sound() {
    good_stinger_sound = Spawn("script_origin", self.origin);
	good_stinger_sound PlaySound("raygun_stinger", "raygun_stinger_sound_done");
	good_stinger_sound waittill("sound_done");
	good_stinger_sound Delete();

}

great_weapon_sound() {
	wait 0.60;
	index = maps\_zombiemode_weapons::get_player_index(self);
	greatweaponSound = "_positive_" + RandomInt(3);
    great_weapon_sound = Spawn("script_origin", self.origin);
	great_weapon_sound PlaySound("plr_" + index + greatweaponSound, "positive_sound_done");
	great_weapon_sound waittill("positive_sound_done");
	great_weapon_sound Delete();

}

crappy_weapon_sound() {
	wait 0.60;
	index = maps\_zombiemode_weapons::get_player_index(self);
	crappyweaponSound = "_negative_" + RandomInt(3);
    crappy_weapon_sound = Spawn("script_origin", self.origin);
	crappy_weapon_sound PlaySound("plr_" + index + crappyweaponSound, "negative_sound_done");
	crappy_weapon_sound waittill("negative_sound_done");
	crappy_weapon_sound Delete();

}

pickup_betty_sound() {
	wait 0.60;
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupbettySound = "_betty_" + RandomInt(1);
    pickup_betty_sound = Spawn("script_origin", self.origin);
	pickup_betty_sound PlaySound("plr_" + index + pickupbettySound, "betty_sound_done");
	pickup_betty_sound waittill("betty_sound_done");
	pickup_betty_sound Delete();

}

pickup_bowie_sound() {	//melee_kill in files
	wait 0.60;
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupbowieSound = "_melee_" + RandomInt(3);
    pickup_bowie_sound = Spawn("script_origin", self.origin);
	pickup_bowie_sound PlaySound("plr_" + index + pickupbowieSound, "melee_sound_done");
	pickup_bowie_sound waittill("melee_sound_done");
	pickup_bowie_sound Delete();

}

pickup_flamethrower_sound() {
	wait 0.60;
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupflamerSound = "_flamer_" + RandomInt(1);
    pickup_flamethrower_sound = Spawn("script_origin", self.origin);
	pickup_flamethrower_sound PlaySound("plr_" + index + pickupflamerSound, "flamer_sound_done");
	pickup_flamethrower_sound waittill("flamer_sound_done");
	pickup_flamethrower_sound Delete();

}

pickup_lmg_sound() {
	wait 0.60;
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickuplmgSound = "_lmg_" + RandomInt(1);
    pickup_lmg_sound = Spawn("script_origin", self.origin);
	pickup_lmg_sound PlaySound("plr_" + index + pickuplmgSound, "lmg_sound_done");
	pickup_lmg_sound waittill("lmg_sound_done");
	pickup_lmg_sound Delete();

}

pickup_panzerschrek_sound() {
	wait 0.60;
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickuprocketSound = "_rocket_" + RandomInt(1);
    pickup_panzerschrek_sound = Spawn("script_origin", self.origin);
	pickup_panzerschrek_sound PlaySound("plr_" + index + pickuprocketSound, "rocket_sound_done");
	pickup_panzerschrek_sound waittill("rocket_sound_done");
	pickup_panzerschrek_sound Delete();

}

pickup_semi_sound() {
	wait 0.60;
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupsemiSound = "_semi_" + RandomInt(1);
    pickup_semi_sound = Spawn("script_origin", self.origin);
	pickup_semi_sound PlaySound("plr_" + index + pickupsemiSound, "semi_sound_done");
	pickup_semi_sound waittill("semi_sound_done");
	pickup_semi_sound Delete();

}

pickup_shotgun_sound() {
	wait 0.60;
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupshotgunSound = "_shotgun_" + RandomInt(1);
    pickup_shotgun_sound = Spawn("script_origin", self.origin);
	pickup_shotgun_sound PlaySound("plr_" + index + pickupshotgunSound, "shotgun_sound_done");
	pickup_shotgun_sound waittill("shotgun_sound_done");
	pickup_shotgun_sound Delete();

}

pickup_smg_sound() {
	wait 0.60;
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupsmgSound = "_smg_" + RandomInt(1);
    pickup_smg_sound = Spawn("script_origin", self.origin);
	pickup_smg_sound PlaySound("plr_" + index + pickupsmgSound, "smg_sound_done");
	pickup_smg_sound waittill("smg_sound_done");
	pickup_smg_sound Delete();

}

pickup_sniper_sound() {
	wait 0.60;
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupsniperSound = "_sniper_" + RandomInt(3);
    pickup_sniper_sound = Spawn("script_origin", self.origin);
	pickup_sniper_sound PlaySound("plr_" + index + pickupsniperSound, "sniper_sound_done");
	pickup_sniper_sound waittill("sniper_sound_done");
	pickup_sniper_sound Delete();

}

pickup_bonus_points_sound() {
	wait 0.80;
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupbonuspointsSound = "_points_" + RandomInt(1);
    pickup_bonus_points_sound = Spawn("script_origin", self.origin);
	pickup_bonus_points_sound PlaySound("plr_" + index + pickupbonuspointsSound, "bonus_points_sound_done");
	pickup_bonus_points_sound waittill("bonus_points_sound_done");
	pickup_bonus_points_sound Delete();
}

pickup_carpenter_sound() {
	wait 0.80;
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupcarpenterSound = "_repair_" + RandomInt(1);
    pickup_carpenter_sound = Spawn("script_origin", self.origin);
	pickup_carpenter_sound PlaySound("plr_" + index + pickupcarpenterSound, "repair_sound_done");
	pickup_carpenter_sound waittill("repair_sound_done");
	pickup_carpenter_sound Delete();
}

pickup_death_machine_sound() {
	wait 0.80;
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupdeathmachineSound = "_instakill_" + RandomInt(1);
    pickup_death_machine_sound = Spawn("script_origin", self.origin);
	pickup_death_machine_sound PlaySound("plr_" + index + pickupdeathmachineSound, "instakill_sound_done");
	pickup_death_machine_sound waittill("instakill_sound_done");
	pickup_death_machine_sound Delete();
}

pickup_doublepoints_sound() {
	wait 0.80;
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupdoublepointsSound = "_points_" + RandomInt(1);
    pickup_doublepoints_sound = Spawn("script_origin", self.origin);
	pickup_doublepoints_sound PlaySound("plr_" + index + pickupdoublepointsSound, "double_points_sound_done");
	pickup_doublepoints_sound waittill("double_points_sound_done");
	pickup_doublepoints_sound Delete();
}

pickup_firesale_sound() {
	wait 0.80;
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupfiresaleSound = "_points_" + RandomInt(1);
    pickup_firesale_sound = Spawn("script_origin", self.origin);
	pickup_firesale_sound PlaySound("plr_" + index + pickupfiresaleSound, "fs_sound_done");
	pickup_firesale_sound waittill("fs_sound_done");
	pickup_firesale_sound Delete();
}

pickup_insta_kill_sound() {
	wait 0.80;
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupinstakillSound = "_instakill_" + RandomInt(1);
    pickup_insta_kill_sound = Spawn("script_origin", self.origin);
	pickup_insta_kill_sound PlaySound("plr_" + index + pickupinstakillSound, "instakill_sound_done");
	pickup_insta_kill_sound waittill("instakill_sound_done");
	pickup_insta_kill_sound Delete();
}

pickup_maxammo_sound() {
	wait 0.80;
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupmaxammoSound = "_maxammo_" + RandomInt(1);
    pickup_maxammo_sound = Spawn("script_origin", self.origin);
	pickup_maxammo_sound PlaySound("plr_" + index + pickupmaxammoSound, "maxammo_sound_done");
	pickup_maxammo_sound waittill("maxammo_sound_done");
	pickup_maxammo_sound Delete();
}

pickup_nuke_sound() {
	wait 0.80;
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupnukeSound = "_nuke_" + RandomInt(1);
    pickup_nuke_sound = Spawn("script_origin", self.origin);
	pickup_nuke_sound PlaySound("plr_" + index + pickupnukeSound, "nuke_sound_done");
	pickup_nuke_sound waittill("nuke_sound_done");
	pickup_nuke_sound Delete();
}

quip_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	quipSound = "_quip_" + RandomInt(3);
    quip_sound = Spawn("script_origin", self.origin);
	quip_sound PlaySound("plr_" + index + quipSound, "_quip_sound_done");
	quip_sound waittill("quip_sound_done");
	quip_sound Delete();

}

blockers_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	blockersSound = "_blockers_" + RandomInt(5);
    blockers_sound = Spawn("script_origin", self.origin);
	blockers_sound  PlaySound("plr_" + index + blockersSound, "_blockers_sound_done");
	blockers_sound  waittill("blockers_sound_done");
	blockers_sound  Delete();

}

explosive_kill_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	explosivekillSound = "_explosive_" + RandomInt(5);
    explosive_kill_sound = Spawn("script_origin", self.origin);
	explosive_kill_sound PlaySound("plr_" + index + explosivekillSound, "_explosive_sound_done");
	explosive_kill_sound waittill("explosive_sound_done");
	explosive_kill_sound Delete();

}

killstreak_sound() {
	wait 0.125;
	index = maps\_zombiemode_weapons::get_player_index(self);
	killstreakSound = "_killstreak_" + RandomInt(3);
    killstreak_sound = Spawn("script_origin", self.origin);
	killstreak_sound PlaySound("plr_" + index + killstreakSound, "_killstreak_sound_done");
	killstreak_sound waittill("killstreak_sound_done");
	killstreak_sound Delete();

}

friendly_fire_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	friendlyfireSound = "_ff_" + RandomInt(3);
    friendly_fire_sound = Spawn("script_origin", self.origin);
	friendly_fire_sound PlaySound("plr_" + index + friendlyfireSound, "_ff_sound_done");
	friendly_fire_sound waittill("ff_sound_done");
	friendly_fire_sound Delete();

}

headshot_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	headshotSound = "_headshot_" + RandomInt(5);
    headshot_sound = Spawn("script_origin", self.origin);
	headshot_sound PlaySound("plr_" + index + headshotSound, "_headshot_sound_done");
	headshot_sound waittill("headshot_sound_done");
	headshot_sound Delete();

}

revive_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	reviveSound = "_revive_" + RandomInt(3);
    revive_sound = Spawn("script_origin", self.origin);
	revive_sound PlaySound("plr_" + index + reviveSound, "_revive_sound_done");
	revive_sound waittill("revive_sound_done");
	revive_sound Delete();

}

swarm_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	swarmSound = "_swarm_" + RandomInt(4);
    swarm_sound = Spawn("script_origin", self.origin);
	swarm_sound PlaySound("plr_" + index + swarmSound, "_swarm_sound_done");
	swarm_sound waittill("swarm_sound_done");
	swarm_sound Delete();

}

plant_mine_sound() {
	wait 0.125;
	index = maps\_zombiemode_weapons::get_player_index(self);
	plantmineSound = "_plantmine_" + RandomInt(4);
    plant_mine_sound = Spawn("script_origin", self.origin);
	plant_mine_sound PlaySound("plr_" + index + plantmineSound, "_plant_mine_sound_done");
	plant_mine_sound waittill("plant_mine_sound_done");
	plant_mine_sound Delete();

}

cash_register_sound() {
    chash_register_sound = Spawn("script_origin", self.origin);
	chash_register_sound PlaySound("cha_ching", "cha_ching_sound_done");
	chash_register_sound waittill("cha_ching_sound_done");
	chash_register_sound Delete();

}

purchase_sound() {
    purchase_sound = Spawn("script_origin", self.origin);
	purchase_sound PlaySound("purchase", "purchase_sound_done");
	purchase_sound waittill("purchase_sound_done");
	purchase_sound Delete();

}

no_purchase_sound() {
    no_purchase_sound = Spawn("script_origin", self.origin);
	no_purchase_sound PlaySound("no_purchase", "no_purchase_sound_done");
	no_purchase_sound waittill("no_purchase_sound_done");
	no_purchase_sound Delete();

}

no_money_sound() {
	wait 0.5;
	index = maps\_zombiemode_weapons::get_player_index(self);
	momoneySound = "_nomoney_" + RandomInt(1);
    no_money_sound = Spawn("script_origin", self.origin);
	no_money_sound PlaySound("plr_" + index + momoneySound, "nomoney_sound_done");
	no_money_sound waittill("nomoney_sound_done");
	no_money_sound Delete();

}

lightning_sound() {
    lightning_sound = Spawn("script_origin", self.origin);
	lightning_sound PlaySound("lightning_1", "lightning_1_sound_done");
	lightning_sound waittill("lightning_1_sound_done");
	lightning_sound Delete();
    
}

sam_start_ee_vox_sound() {
    sam_start_ee_vox_sound = Spawn("script_origin", self.origin);
    sam_start_ee_vox_sound PlaySound("sam_fly_laugh", "sam_fly_laugh_sound_done");
    sam_start_ee_vox_sound waittill("sam_fly_laugh_sound_done");
    sam_start_ee_vox_sound Delete();
}

undone_ee_track_sound() {
    undone_ee_track_sound = Spawn("script_origin", self.origin);
    undone_ee_track_sound PlaySound("undone", "undone_ee_track_sound_done");
    undone_ee_track_sound waittill("undone_ee_track_sound_done");
    undone_ee_track_sound Delete();
}

monty_dialogue_sound() {
    monty_dialogue_sound = Spawn("script_origin", self.origin);
    monty_dialogue_sound PlaySound("monty_dialogue", "monty_dialogue_sound_done");
    monty_dialogue_sound waittill("monty_dialogue_sound_done");
    monty_dialogue_sound Delete();	
}

button_press_sound() {
    hide_and_seek_ee_track_sound = Spawn("script_origin", self.origin);
    hide_and_seek_ee_track_sound PlaySound("button_press", "button_press_sound_done");
    hide_and_seek_ee_track_sound waittill("button_press_sound_done");
    hide_and_seek_ee_track_sound Delete();
}

samantha_start_sound() {
    samantha_start_sound = Spawn("script_origin", self.origin);
    samantha_start_sound PlaySound("samantha_start", "samantha_start_sound_done");
    samantha_start_sound waittill("samantha_start_sound_done");
    samantha_start_sound Delete();
}

samantha_fail_sound() {
    samantha_fail_sound = Spawn("script_origin", self.origin);
    samantha_fail_sound PlaySound("samantha_fail", "samantha_fail_sound_done");
    samantha_fail_sound waittill("samantha_fail_sound_done");
    samantha_fail_sound Delete();
}

samanthas_lullaby_ee_track_sound() {
    samanthas_lullaby_ee_track_sound = Spawn("script_origin", self.origin);
    samanthas_lullaby_ee_track_sound PlaySound("samanthas_lullaby", "samanthas_lullaby_ee_track_sound_done");
    samanthas_lullaby_ee_track_sound waittill("samanthas_lullaby_ee_track_sound_done");
    samanthas_lullaby_ee_track_sound Delete();
}

radio_ee_track_sound() {
    if (level.radioEETrackIndex >= 10) {
        // If all tracks have been played, reset the index
        level.radioEETrackIndex = 1;
    }

    radioEeTrackSound = "radio_ee_track_" + level.radioEETrackIndex;
    level.radioEETrackIndex++;

    radio_ee_track_sound = Spawn("script_origin", self.origin);
    radio_ee_track_sound PlaySound(radioEeTrackSound);
    wait 1;
	radio_ee_track_sound StopSound(radioEeTrackSound);
	wait 1;
    radio_ee_track_sound Delete();

    self notify("ee_track_sound_finished");
}