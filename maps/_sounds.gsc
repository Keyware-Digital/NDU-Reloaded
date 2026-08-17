#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;

// ============================================================
// LEVEL OBJECTS / EE, ETC...
// ============================================================
button_press_sound() {
    hide_and_seek_ee_track_sound = Spawn("script_origin", self.origin);
    hide_and_seek_ee_track_sound PlaySound("button_press", "button_press_sound_done");
    hide_and_seek_ee_track_sound waittill("button_press_sound_done");
    hide_and_seek_ee_track_sound Delete();
}

cabinet_sound() {
    cabinetSong = "cabinetbox_sting_" + RandomInt(3);
    cabinet_sound = Spawn("script_origin", self.origin);
    cabinet_sound PlaySound(cabinetSong, "cabinetbox_sting_sound_done");
    cabinet_sound waittill("cabinetbox_sting_sound_done");
    cabinet_sound Delete();

}

cash_register_sound() {
    chash_register_sound = Spawn("script_origin", self.origin);
    chash_register_sound PlaySound("cha_ching", "cha_ching_sound_done");
    chash_register_sound waittill("cha_ching_sound_done");
    chash_register_sound Delete();

}

coalescence_sound() {
    coalescence_sound = Spawn("script_origin", self.origin);
    coalescence_sound PlaySound("coalescence", "coalescence_sound_done");
    coalescence_sound waittill("coalescence_sound_done");
    coalescence_sound Delete();
}

lightning_sound() {
    lightning_sound = Spawn("script_origin", self.origin);
    lightning_sound PlaySound("lightning_1", "lightning_1_sound_done");
    lightning_sound waittill("lightning_1_sound_done");
    lightning_sound Delete();
    
}

monty_dialogue_sound() {
    monty_dialogue_sound = Spawn("script_origin", self.origin);
    monty_dialogue_sound PlaySound("monty_dialogue", "monty_dialogue_sound_done");
    monty_dialogue_sound waittill("monty_dialogue_sound_done");
    monty_dialogue_sound Delete();	

    self coalescence_sound();
}

mystery_box_haunt_sound_loop()
{
    wait 0.33;
    haunt_sound = Spawn("script_origin", self.origin);
    haunt_sound PlayLoopSound("mystery_box_haunt");
    self waittill("stop_haunt_sound");
    haunt_sound StopLoopSound();
    haunt_sound Delete();
}

mystery_box_lock_sound() {
    mystery_box_lock_sound = Spawn("script_origin", self.origin);
    mystery_box_lock_sound PlaySound("mystery_box_lock", "mystery_box_lock_sound_done");
    mystery_box_lock_sound waittill("mystery_box_lock_sound_done");
    mystery_box_lock_sound Delete();

    self notify("mystery_box_lock_sound_done");

}

mystery_box_unlock_sound() {
    //wait 0.33;
    mystery_box_unlock_sound = Spawn("script_origin", self.origin);
    mystery_box_unlock_sound PlaySound("mystery_box_unlock", "mystery_box_unlock_sound_done");
    mystery_box_unlock_sound waittill("mystery_box_unlock_sound_done");
    mystery_box_unlock_sound Delete();

    self notify("mystery_box_unlock_sound_done");

}

no_purchase_sound() {
    no_purchase_sound = Spawn("script_origin", self.origin);
    no_purchase_sound PlaySound("no_purchase", "no_purchase_sound_done");
    no_purchase_sound waittill("no_purchase_sound_done");
    no_purchase_sound Delete();

}

phd_explosion_sound() {
    explosion = "explode_" + RandomInt(3);
    explosion_sound = Spawn("script_origin", self.origin);
    explosion_sound PlaySound(explosion, "explode_sound_done");
    explosion_sound waittill("explode_sound_done");
    explosion_sound Delete();

}

purchase_sound() {
    purchase_sound = Spawn("script_origin", self.origin);
    purchase_sound PlaySound("purchase", "purchase_sound_done");
    purchase_sound waittill("purchase_sound_done");
    purchase_sound Delete();

}

radio_ee_track_sound() {
    if (level.radioEETrackIndex >= 10) {
        // If all tracks have been played, reset the index
        level.radioEETrackIndex = 1;
    }

    radioEeTrackSound = "radio_ee_track_" + level.radioEETrackIndex;
    level.radioEETrackIndex++;

    radio_ee_track_sound = Spawn("script_origin", self.origin);
    radio_ee_track_sound PlaySound(radioEeTrackSound, "radio_ee_track_sound_done");
    radio_ee_track_sound waittill("radio_ee_track_sound_done");
    radio_ee_track_sound Delete();
}

raygun_stinger_sound() {
    good_stinger_sound = Spawn("script_origin", self.origin);
    good_stinger_sound PlaySound("raygun_stinger", "raygun_stinger_sound_done");
    good_stinger_sound waittill("sound_done");
    good_stinger_sound Delete();

}

sam_start_ee_vox_sound() {
    sam_start_ee_vox_sound = Spawn("script_origin", self.origin);
    sam_start_ee_vox_sound PlaySound("sam_fly_laugh", "sam_fly_laugh_sound_done");
    sam_start_ee_vox_sound waittill("sam_fly_laugh_sound_done");
    sam_start_ee_vox_sound Delete();
}

samantha_disappear_sound() {
    samantha_disappear_sound = Spawn("script_origin", self.origin);
    samantha_disappear_sound PlaySound("samantha_disappear", "samantha_disappear_sound_done");
    samantha_disappear_sound waittill("samantha_disappear_sound_done");
    samantha_disappear_sound Delete();
}

samantha_fail_sound() {
    samantha_fail_sound = Spawn("script_origin", self.origin);
    samantha_fail_sound PlaySound("samantha_fail", "samantha_fail_sound_done");
    samantha_fail_sound waittill("samantha_fail_sound_done");
    samantha_fail_sound Delete();
}

samantha_musicbox_sound_loop(samantha_figure)
{
    samantha_music_box_sound = Spawn("script_origin", self.origin);
    samantha_music_box_sound PlayLoopSound("musicbox_loop");

    samantha_figure waittill("stop_musicbox_sound");

    samantha_music_box_sound StopLoopSound();
    samantha_music_box_sound Delete();
}

samantha_start_sound() {
    samantha_start_sound = Spawn("script_origin", self.origin);
    samantha_start_sound PlaySound("samantha_start", "samantha_start_sound_done");
    samantha_start_sound waittill("samantha_start_sound_done");
    samantha_start_sound Delete();
}

samanthas_lullaby_ee_track_sound() {
    samanthas_lullaby_ee_track_sound = Spawn("script_origin", self.origin);
    samanthas_lullaby_ee_track_sound PlaySound("samanthas_lullaby", "samanthas_lullaby_ee_track_sound_done");
    samanthas_lullaby_ee_track_sound waittill("samanthas_lullaby_ee_track_sound_done");
    samanthas_lullaby_ee_track_sound Delete();
}

undone_ee_track_sound() {
    undone_ee_track_sound = Spawn("script_origin", self.origin);
    undone_ee_track_sound PlaySound("undone", "undone_ee_track_sound_done");
    undone_ee_track_sound waittill("undone_ee_track_sound_done");
    undone_ee_track_sound Delete();
}

// ============================================================
// PLAYER VOX
// ============================================================

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

announcer_vox_random_perk_sound()
{
    pickup_rp_sound = Spawn( "script_origin", self.origin );
    pickup_rp_sound PlaySound( "rp_vox", "rp_vox_sound_done" );
    pickup_rp_sound waittill( "rp_vox_sound_done" );
    pickup_rp_sound Delete();
}

blockers_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    blockersSound = "_blockers_" + RandomInt(5);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + blockersSound, "blockers_sound_done");
    sound_ent waittill("blockers_sound_done");
    sound_ent Delete();

    self notify("blockers_sound_done");
}

crappy_weapon_sound() {
    wait 0.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    crappyweaponSound = "_negative_" + RandomInt(3);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + crappyweaponSound, "negative_sound_done");
    sound_ent waittill("negative_sound_done");
    sound_ent Delete();

    self notify("weapon_vox_done");
}

death_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    deathSound = "_death_" + RandomInt(3);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + deathSound, "death_sound_done");
    sound_ent waittill("death_sound_done");
    sound_ent Delete();

    self notify("death_sound_done");
}

dolphin_dive_launch_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    launch = "_launch_exert_" + RandomInt(6);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + launch, "launch_exert_sound_done");
    sound_ent waittill("launch_exert_sound_done");
    sound_ent Delete();

    self notify("dolphin_dive_launch_sound_done");
}

dolphin_dive_land_sound() {
    land = "_land_exert_" + RandomInt(6);
    index = maps\_zombiemode_weapons::get_player_index(self);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + land, "land_exert_sound_done");
    sound_ent waittill("land_exert_sound_done");
    sound_ent Delete();

    self notify("dolphin_dive_land_sound_done");
}

explosive_kill_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    explosivekillSound = "_explosive_" + RandomInt(5);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + explosivekillSound, "explosive_sound_done");
    sound_ent waittill("explosive_sound_done");
    sound_ent Delete();

    self notify("explosive_sound_done");
}

friendly_fire_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    friendlyfireSound = "_ff_" + RandomInt(3);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + friendlyfireSound, "ff_sound_done");
    sound_ent waittill("ff_sound_done");
    sound_ent Delete();

    self notify("ff_sound_done");
}

great_weapon_sound() {
    wait 0.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    greatweaponSound = "_positive_" + RandomInt(3);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + greatweaponSound, "positive_sound_done");
    sound_ent waittill("positive_sound_done");
    sound_ent Delete();

    self notify("weapon_vox_done");
}

headshot_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    headshotSound = "_headshot_" + RandomInt(5);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + headshotSound, "headshot_sound_done");
    sound_ent waittill("headshot_sound_done");
    sound_ent Delete();

    self notify("headshot_sound_done");
}

killstreak_sound() {
    //wait 0.125;
    index = maps\_zombiemode_weapons::get_player_index(self);
    killstreakSound = "_killstreak_" + RandomInt(3);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + killstreakSound, "killstreak_sound_done");
    sound_ent waittill("killstreak_sound_done");
    sound_ent Delete();

    self notify("killstreak_sound_done");
}

melee_vox_sound()
{
    self notify( "active_melee_vox" );
    self endon( "active_melee_vox" );
    self endon( "death" );

    index = maps\_zombiemode_weapons::get_player_index( self );
    meleeSound = "_knife_exert_" + RandomInt( 3 );

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound( "plr_" + index + meleeSound, "knife_exert_sound_done" );
    sound_ent waittill( "knife_exert_sound_done" );
    sound_ent Delete();

    self notify( "melee_sound_done" );
}

molotov_vox_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    molotovSound = "_molotov_exert_" + RandomInt(3);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + molotovSound, "molotov_exert_sound_done");
    sound_ent waittill("molotov_exert_sound_done");
    sound_ent Delete();

    self notify("molotov_sound_done");
}

no_ammo_vox() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    noAmmoSound = "_no_ammo";

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + noAmmoSound, "no_ammo_sound_done");
    sound_ent waittill("no_ammo_sound_done");
    sound_ent Delete();

    self notify("no_ammo_sound_done");
}

no_money_sound() {
    wait 0.5;	// small delay after no purchase sound
    index = maps\_zombiemode_weapons::get_player_index(self);
    momoneySound = "_nomoney_" + RandomInt(1);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + momoneySound, "nomoney_sound_done");
    sound_ent waittill("nomoney_sound_done");
    sound_ent Delete();

    wait 0.5;	// small delay to alleviate spamming
    self notify( "no_money_sound_done" );
}

pain_vox_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    painSound = "_pain_exert_" + RandomInt(8);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + painSound, "pain_exert_sound_done");
    sound_ent waittill("pain_exert_sound_done");
    sound_ent Delete();

    self notify("pain_exert_sound_done");
}

pickup_betty_sound() {
    wait 0.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    pickupbettySound = "_betty_" + RandomInt(1);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + pickupbettySound, "betty_sound_done");
    sound_ent waittill("betty_sound_done");
    sound_ent Delete();

    self notify("weapon_vox_done");
}

pickup_bonus_points_sound() {
    wait 1.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    pickupbonuspointsSound = "_points_" + RandomInt(1);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + pickupbonuspointsSound, "bonus_points_sound_done");
    sound_ent waittill("bonus_points_sound_done");
    sound_ent Delete();

    self notify("powerup_pickup_sound_done");
}

pickup_bowie_sound() {	// melee_kill in files
    wait 0.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    pickupbowieSound = "_melee_" + RandomInt(3);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + pickupbowieSound, "melee_sound_done");
    sound_ent waittill("melee_sound_done");
    sound_ent Delete();

    self notify("weapon_vox_done");
}

pickup_carpenter_sound() {
    wait 1.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    pickupcarpenterSound = "_repair_" + RandomInt(1);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + pickupcarpenterSound, "repair_sound_done");
    sound_ent waittill("repair_sound_done");
    sound_ent Delete();

    self notify("powerup_pickup_sound_done");
}

pickup_death_machine_sound() {
    wait 1.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    pickupdeathmachineSound = "_instakill_" + RandomInt(1);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + pickupdeathmachineSound, "instakill_sound_done");
    sound_ent waittill("instakill_sound_done");
    sound_ent Delete();

    self notify("powerup_pickup_sound_done");
}

pickup_doublepoints_sound() {
    wait 1.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    pickupdoublepointsSound = "_points_" + RandomInt(1);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + pickupdoublepointsSound, "double_points_sound_done");
    sound_ent waittill("double_points_sound_done");
    sound_ent Delete();

    self notify("powerup_pickup_sound_done");
}

pickup_firesale_sound() {
    wait 1.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    pickupfiresaleSound = "_points_" + RandomInt(1);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + pickupfiresaleSound, "fs_sound_done");
    sound_ent waittill("fs_sound_done");
    sound_ent Delete();

    self notify("powerup_pickup_sound_done");
}

pickup_flamethrower_sound() {
    wait 0.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    pickupflamerSound = "_flamer_" + RandomInt(1);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + pickupflamerSound, "flamer_sound_done");
    sound_ent waittill("flamer_sound_done");
    sound_ent Delete();

    self notify("weapon_vox_done");
}

pickup_insta_kill_sound() {
    wait 1.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    pickupinstakillSound = "_instakill_" + RandomInt(1);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + pickupinstakillSound, "instakill_sound_done");
    sound_ent waittill("instakill_sound_done");
    sound_ent Delete();

    self notify("powerup_pickup_sound_done");
}

pickup_lmg_sound() {
    wait 0.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    pickuplmgSound = "_lmg_" + RandomInt(1);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + pickuplmgSound, "lmg_sound_done");
    sound_ent waittill("lmg_sound_done");
    sound_ent Delete();

    self notify("weapon_vox_done");
}

pickup_maxammo_sound() {
    wait 1.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    pickupmaxammoSound = "_maxammo_" + RandomInt(1);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + pickupmaxammoSound, "maxammo_sound_done");
    sound_ent waittill("maxammo_sound_done");
    sound_ent Delete();

    self notify("powerup_pickup_sound_done");
}

pickup_nuke_sound() {
    wait 1.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    pickupnukeSound = "_nuke_" + RandomInt(1);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + pickupnukeSound, "nuke_sound_done");
    sound_ent waittill("nuke_sound_done");
    sound_ent Delete();

    self notify("powerup_pickup_sound_done");
}

pickup_panzerschrek_sound() {
    wait 0.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    pickuprocketSound = "_rocket_" + RandomInt(1);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + pickuprocketSound, "rocket_sound_done");
    sound_ent waittill("rocket_sound_done");
    sound_ent Delete();

    self notify("weapon_vox_done");
}

pickup_semi_sound() {
    wait 0.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    pickupsemiSound = "_semi_" + RandomInt(1);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + pickupsemiSound, "semi_sound_done");
    sound_ent waittill("semi_sound_done");
    sound_ent Delete();

    self notify("weapon_vox_done");
}

pickup_shotgun_sound() {
    wait 0.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    pickupshotgunSound = "_shotgun_" + RandomInt(1);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + pickupshotgunSound, "shotgun_sound_done");
    sound_ent waittill("shotgun_sound_done");
    sound_ent Delete();

    self notify("weapon_vox_done");
}

pickup_smg_sound() {
    wait 0.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    pickupsmgSound = "_smg_" + RandomInt(1);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + pickupsmgSound, "smg_sound_done");
    sound_ent waittill("smg_sound_done");
    sound_ent Delete();

    self notify("weapon_vox_done");
}

pickup_sniper_sound() {
    wait 0.66;
    index = maps\_zombiemode_weapons::get_player_index(self);
    pickupsniperSound = "_sniper_" + RandomInt(3);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + pickupsniperSound, "sniper_sound_done");
    sound_ent waittill("sniper_sound_done");
    sound_ent Delete();

    self notify("weapon_vox_done");
}

plant_mine_sound() {
    wait 0.33;
    index = maps\_zombiemode_weapons::get_player_index(self);
    plantmineSound = "_plantmine_" + RandomInt(4);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + plantmineSound, "plant_mine_sound_done");
    sound_ent waittill("plant_mine_sound_done");
    sound_ent Delete();

    self notify("plant_mine_sound_done");
}

quip_sound() {
    wait 4; // 2s after revive
    index = maps\_zombiemode_weapons::get_player_index(self);
    quipSound = "_quip_" + RandomInt(3);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + quipSound, "quip_sound_done");
    sound_ent waittill("quip_sound_done");
    sound_ent Delete();

    self notify("quip_sound_done");
}

reload_vox_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    reloadSound = "_vox_reload_" + RandomInt(2);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + reloadSound, "vox_reload_sound_done");
    sound_ent waittill("vox_reload_sound_done");
    sound_ent Delete();

    self notify("reloading_sound_done");
}

revive_sound() {
    wait 2;
    index = maps\_zombiemode_weapons::get_player_index(self);
    reviveSound = "_revive_" + RandomInt(3);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + reviveSound, "revive_sound_done");
    sound_ent waittill("revive_sound_done");
    sound_ent Delete();
}

stielhandgranate_vox_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    stielhandgranateSound = "_stielhandgranate_exert_" + RandomInt(6);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + stielhandgranateSound, "stielhandgranate_exert_sound_done");
    sound_ent waittill("stielhandgranate_exert_sound_done");
    sound_ent Delete();

    self notify("stielhandgranate_sound_done");
}

swarm_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    swarmSound = "_swarm_" + RandomInt(4);

    sound_ent = Spawn("script_origin", self.origin);
    sound_ent LinkTo(self);

    sound_ent PlaySound("plr_" + index + swarmSound, "swarm_sound_done");
    sound_ent waittill("swarm_sound_done");
    sound_ent Delete();

    self notify("swarm_sound_done");
}

// ============================================================
// WEATHER
// ============================================================
weather_lightning_sound()
{
    weather_lightning_sound = Spawn("script_origin", self.origin);
    weather_lightning_sound PlaySound("weather_lightning", "weather_lightning_sound_done");
    weather_lightning_sound waittill("weather_lightning_sound_done");
    weather_lightning_sound Delete();
}

weather_thunder_sound()
{
    weather_thunder_sound = Spawn("script_origin", self.origin);
    weather_thunder_sound PlaySound("weather_thunder", "weather_thunder_sound_done");
    weather_thunder_sound waittill("weather_thunder_sound_done");
    weather_thunder_sound Delete();
}

// ============================================================
// ZOMBIES
// ============================================================

zombie_dodge_sound()
{
    self endon( "death" );

    sound_ent = Spawn( "script_origin", self.origin );
    sound_ent LinkTo( self );

    sound_ent PlaySound( "zombie_groan_dodge", "zombie_dodge_sound_done" );
    sound_ent waittill( "zombie_dodge_sound_done" );
    sound_ent Delete();
}

zombie_follow_sound()
{
    self endon( "death" );

    sound_ent = Spawn( "script_origin", self.origin );
    sound_ent LinkTo( self );

    sound_ent PlaySound( "zombie_groan_follow", "zombie_groan_follow_done" );
    sound_ent waittill( "zombie_groan_follow_done" );
    sound_ent Delete();
}

zombie_follow_sound_loop()
{
    self endon( "death" );

    self.follow_sound_playing = true;

    wait 1.66;

    while ( isDefined( level.zombiegoto ) && level.is_solo_revive_distraction_active )
    {
        // Only 33% chance each cycle so it’s not constant spam
        if ( RandomInt( 100 ) < 33 )
        {
            self thread zombie_follow_sound();
        }

        wait randomfloatrange( 2.8, 4.6 );
    }

    self.follow_sound_playing = undefined;
}

// ============================================================
// HELPERS, ETC...
// ============================================================
player_vox_helper(sound_func, notify_str, timeout)
{
    if (!IsDefined(timeout))
        timeout = 4.0;

    if (!IsDefined(self.player_is_speaking))
        self.player_is_speaking = 0;

    if (self.player_is_speaking == 1)
        return;

    self.player_is_speaking = 1;

    self thread [[sound_func]]();

    self thread player_vox_timeout(timeout, notify_str);
    self waittill(notify_str);

    self.player_is_speaking = 0;
}

player_vox_timeout(timeout, notify_str)
{
    self endon(notify_str);
    wait(timeout);
    self notify(notify_str);
}