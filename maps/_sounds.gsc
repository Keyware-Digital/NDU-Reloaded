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

reload_vox_sound() {
    index = maps\_zombiemode_weapons::get_player_index(self);
    reloadSound = "_vox_reload_" + RandomInt(2);
    reload_vox_sound = Spawn("script_origin", self.origin);
	reload_vox_sound PlaySound("plr_" + index + reloadSound, "sound_done");
	reload_vox_sound waittill("sound_done");
	reload_vox_sound Delete();

}

powerup_start_sound() {
    level.powerup_sound = Spawn("script_origin", self.origin);
	level.powerup_sound PlaySound("spawn_powerup", "sound_done");
    level.powerup_sound waittill("sound_done");
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