#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;

pain_vox_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    painSound = "_pain_exert_" + RandomInt(8);
    pain_vox_sound = Spawn("script_origin", self.origin);
	pain_vox_sound PlaySound("plr_" + index + painSound, "sound_done");
    pain_vox_sound waittill("sound_done");
	pain_vox_sound Delete();
    
}

melee_vox_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    meleeSound = "_knife_exert_" + RandomInt(3);
    melee_vox_sound = Spawn("script_origin", self.origin);
	melee_vox_sound PlaySound("plr_" + index + meleeSound, "sound_done");
	melee_vox_sound waittill("sound_done");
	melee_vox_sound Delete();

}

grenade_vox_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    grenadeSound = "_grenade_exert_" + RandomInt(6);
    grenade_vox_sound = Spawn("script_origin", self.origin);
	grenade_vox_sound PlaySound("plr_" + index + grenadeSound, "sound_done");
	grenade_vox_sound waittill("sound_done");
	grenade_vox_sound Delete();

}

molotov_vox_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    molotovSound = "_molotov_exert_" + RandomInt(3);
    molotov_vox_sound = Spawn("script_origin", self.origin);
	molotov_vox_sound PlaySound("plr_" + index + molotovSound, "sound_done");
	molotov_vox_sound waittill("sound_done");
	molotov_vox_sound Delete();

}

reload_vox_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    reloadSound = "_vox_reload_" + RandomInt(2);
    reload_vox_sound = Spawn("script_origin", self.origin);
	reload_vox_sound PlaySound("plr_" + index + reloadSound, "sound_done");
	reload_vox_sound waittill("sound_done");
	reload_vox_sound Delete();

}

no_ammo_vox() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    noAmmoSound = "_no_ammo";
    no_ammo_vox_sound = Spawn("script_origin", self.origin);
	no_ammo_vox_sound PlaySound("plr_" + index + noAmmoSound, "sound_done");
	no_ammo_vox_sound waittill("sound_done");
	no_ammo_vox_sound Delete();
	
}

powerup_start_sound() {
    level.powerup_sound = Spawn("script_origin", self.origin);
	level.powerup_sound PlaySound("spawn_powerup");
    level.powerup_sound PlayLoopSound("spawn_powerup_loop");

}

powerup_end_sound() {
    level.powerup_sound StopLoopSound();
	level.powerup_sound PlaySound("powerup_grabbed", "sound_done");
    level.powerup_sound waittill("sound_done");
	level.powerup_sound Delete();

}

dolphin_dive_launch_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
	launch = "_launch_exert_" + RandomInt(6);
	launch_sound = Spawn("script_origin", self.origin);
    launch_sound PlaySound("plr_" + index + launch, "sound_done");
	launch_sound waittill("sound_done");
	launch_sound Delete();

}

dolphin_dive_land_sound() {
	land = "_land_exert_" + RandomInt(6);
	index = maps\_zombiemode_weapons::get_player_index(self);
	land_sound = Spawn("script_origin", self.origin);
    land_sound PlaySound( "plr_" + index + land, "sound_done");
	land_sound waittill("sound_done");
	land_sound Delete();

}

phd_explosion_sound() {
    explosion = "explode_" + RandomInt(3);
    explosion_sound = Spawn("script_origin", self.origin);
    explosion_sound PlaySound(explosion, "sound_done");
    explosion_sound waittill("sound_done");
	explosion_sound Delete();

}

mystery_box_lock_sound() {
    mystery_box_lock_sound = Spawn("script_origin", self.origin);
	mystery_box_lock_sound PlaySound("mystery_box_lock", "sound_done");
	mystery_box_lock_sound waittill("sound_done");
	mystery_box_lock_sound Delete();

}

mystery_box_unlock_sound() {
	mystery_box_unlock_sound = Spawn("script_origin", self.origin);
	mystery_box_unlock_sound PlaySound("mystery_box_unlock", "sound_done");
	mystery_box_unlock_sound waittill("sound_done");
	mystery_box_unlock_sound Delete();

}

cabinet_sound() {
	cabinetSong = "cabinetbox_sting_" + RandomInt(3);
	cabinet_sound = Spawn("script_origin", self.origin);
	cabinet_sound PlaySound(cabinetSong, "sound_done");
	cabinet_sound waittill("sound_done");
	cabinet_sound Delete();

}

raygun_stinger_sound() {
    good_stinger_sound = Spawn("script_origin", self.origin);
	good_stinger_sound PlaySound("raygun_stinger", "sound_done");
	good_stinger_sound waittill("sound_done");
	good_stinger_sound Delete();

}

great_weapon_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	greatweaponSound = "_positive_" + RandomInt(3);
    great_weapon_sound = Spawn("script_origin", self.origin);
	great_weapon_sound PlaySound("plr_" + index + greatweaponSound, "sound_done");
	great_weapon_sound waittill("sound_done");
	great_weapon_sound Delete();

}

crappy_weapon_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	crappyweaponSound = "_negative_" + RandomInt(3);
    crappy_weapon_sound = Spawn("script_origin", self.origin);
	crappy_weapon_sound PlaySound("plr_" + index + crappyweaponSound, "sound_done");
	crappy_weapon_sound waittill("sound_done");
	crappy_weapon_sound Delete();

}

pickup_betty_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupbettySound = "_betty_" + RandomInt(1);
    pickup_betty_sound = Spawn("script_origin", self.origin);
	pickup_betty_sound PlaySound("plr_" + index + pickupbettySound, "sound_done");
	pickup_betty_sound waittill("sound_done");
	pickup_betty_sound Delete();

}

pickup_bowie_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupbowieSound = "_melee_" + RandomInt(3);
    pickup_bowie_sound = Spawn("script_origin", self.origin);
	pickup_bowie_sound PlaySound("plr_" + index + pickupbowieSound, "sound_done");
	pickup_bowie_sound waittill("sound_done");
	pickup_bowie_sound Delete();

}

pickup_flamethrower_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupflamerSound = "_flamer_" + RandomInt(1);
    pickup_flamethrower_sound = Spawn("script_origin", self.origin);
	pickup_flamethrower_sound PlaySound("plr_" + index + pickupflamerSound, "sound_done");
	pickup_flamethrower_sound waittill("sound_done");
	pickup_flamethrower_sound Delete();

}

pickup_lmg_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickuplmgSound = "_lmg_" + RandomInt(1);
    pickup_lmg_sound = Spawn("script_origin", self.origin);
	pickup_lmg_sound PlaySound("plr_" + index + pickuplmgSound, "sound_done");
	pickup_lmg_sound waittill("sound_done");
	pickup_lmg_sound Delete();

}

pickup_panzerschrek_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickuprocketSound = "_rocket_" + RandomInt(1);
    pickup_panzerschrek_sound = Spawn("script_origin", self.origin);
	pickup_panzerschrek_sound PlaySound("plr_" + index + pickuprocketSound, "sound_done");
	pickup_panzerschrek_sound waittill("sound_done");
	pickup_panzerschrek_sound Delete();

}

pickup_semi_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupsemiSound = "_semi_" + RandomInt(1);
    pickup_semi_sound = Spawn("script_origin", self.origin);
	pickup_semi_sound PlaySound("plr_" + index + pickupsemiSound, "sound_done");
	pickup_semi_sound waittill("sound_done");
	pickup_semi_sound Delete();

}

pickup_shotgun_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupshotgunSound = "_shotgun_" + RandomInt(1);
    pickup_shotgun_sound = Spawn("script_origin", self.origin);
	pickup_shotgun_sound PlaySound("plr_" + index + pickupshotgunSound, "sound_done");
	pickup_shotgun_sound waittill("sound_done");
	pickup_shotgun_sound Delete();

}

pickup_smg_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupsmgSound = "_smg_" + RandomInt(1);
    pickup_smg_sound = Spawn("script_origin", self.origin);
	pickup_smg_sound PlaySound("plr_" + index + pickupsmgSound, "sound_done");
	pickup_smg_sound waittill("sound_done");
	pickup_smg_sound Delete();

}

pickup_sniper_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupsniperSound = "_sniper_" + RandomInt(3);
    pickup_sniper_sound = Spawn("script_origin", self.origin);
	pickup_sniper_sound PlaySound("plr_" + index + pickupsniperSound, "sound_done");
	pickup_sniper_sound waittill("sound_done");
	pickup_sniper_sound Delete();

}

pickup_bonus_points_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupbonuspointsSound = "_points_" + RandomInt(1);
    pickup_bonus_points_sound = Spawn("script_origin", self.origin);
	pickup_bonus_points_sound PlaySound("plr_" + index + pickupbonuspointsSound, "sound_done");
	pickup_bonus_points_sound waittill("sound_done");
	pickup_bonus_points_sound Delete();
}

pickup_carpenter_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupcarpenterSound = "_repair_" + RandomInt(1);
    pickup_carpenter_sound = Spawn("script_origin", self.origin);
	pickup_carpenter_sound PlaySound("plr_" + index + pickupcarpenterSound, "sound_done");
	pickup_carpenter_sound waittill("sound_done");
	pickup_carpenter_sound Delete();
}

pickup_death_machine_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupdeathmachineSound = "_instakill_" + RandomInt(1);
    pickup_death_machine_sound = Spawn("script_origin", self.origin);
	pickup_death_machine_sound PlaySound("plr_" + index + pickupdeathmachineSound, "sound_done");
	pickup_death_machine_sound waittill("sound_done");
	pickup_death_machine_sound Delete();
}

pickup_doublepoints_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupdoublepointsSound = "_points_" + RandomInt(1);
    pickup_doublepoints_sound = Spawn("script_origin", self.origin);
	pickup_doublepoints_sound PlaySound("plr_" + index + pickupdoublepointsSound, "sound_done");
	pickup_doublepoints_sound waittill("sound_done");
	pickup_doublepoints_sound Delete();
}

pickup_firesale_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupfiresaleSound = "_points_" + RandomInt(1);
    pickup_firesale_sound = Spawn("script_origin", self.origin);
	pickup_firesale_sound PlaySound("plr_" + index + pickupfiresaleSound, "sound_done");
	pickup_firesale_sound waittill("sound_done");
	pickup_firesale_sound Delete();
}

pickup_insta_kill_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupinstakillSound = "_instakill_" + RandomInt(1);
    pickup_insta_kill_sound = Spawn("script_origin", self.origin);
	pickup_insta_kill_sound PlaySound("plr_" + index + pickupinstakillSound, "sound_done");
	pickup_insta_kill_sound waittill("sound_done");
	pickup_insta_kill_sound Delete();
}

pickup_maxammo_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupmaxammoSound = "_maxammo_" + RandomInt(1);
    pickup_maxammo_sound = Spawn("script_origin", self.origin);
	pickup_maxammo_sound PlaySound("plr_" + index + pickupmaxammoSound, "sound_done");
	pickup_maxammo_sound waittill("sound_done");
	pickup_maxammo_sound Delete();
}

pickup_nuke_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	pickupnukeSound = "_nuke_" + RandomInt(1);
    pickup_nuke_sound = Spawn("script_origin", self.origin);
	pickup_nuke_sound PlaySound("plr_" + index + pickupnukeSound, "sound_done");
	pickup_nuke_sound waittill("sound_done");
	pickup_nuke_sound Delete();
}

cash_register_sound() {
    chash_register_sound = Spawn("script_origin", self.origin);
	chash_register_sound PlaySound("cha_ching", "sound_done");
	chash_register_sound waittill("sound_done");
	chash_register_sound Delete();

}

purchase_sound() {
    purchase_sound = Spawn("script_origin", self.origin);
	purchase_sound PlaySound("purchase", "sound_done");
	purchase_sound waittill("sound_done");
	purchase_sound Delete();

}

no_purchase_sound() {
    no_purchase_sound = Spawn("script_origin", self.origin);
	no_purchase_sound PlaySound("no_purchase", "sound_done");
	no_purchase_sound waittill("sound_done");
	no_purchase_sound Delete();

}

no_money_sound() {
	index = maps\_zombiemode_weapons::get_player_index(self);
	momoneySound = "_nomoney_" + RandomInt(1);
    no_money_sound = Spawn("script_origin", self.origin);
	no_money_sound PlaySound("plr_" + index + momoneySound, "sound_done");
	no_money_sound waittill("sound_done");
	no_money_sound Delete();

}

lightning_sound() {
    lightning_sound = Spawn("script_origin", self.origin);
	lightning_sound PlaySound("lightning_1", "sound_done");
	lightning_sound waittill("sound_done");
	lightning_sound Delete();
    
}
