#include maps\_utility;

#include common_scripts\utility;

#include maps\_zombiemode_utility;

init() {

    init_powerup_vars();

    init_powerup_effects();

    init_precache();

    init_powerups();

    thread watch_for_drop();
}

init_powerup_vars() {

    // powerup Vars
    set_zombie_var("zombie_insta_kill", 0);
    set_zombie_var("zombie_point_scalar", 1);
    set_zombie_var("zombie_firesale", 0);
    set_zombie_var("zombie_drop_item", 0);
    set_zombie_var("zombie_timer_offset", 350); // hud offsets
    set_zombie_var("zombie_timer_offset_interval", 30);
    set_zombie_var("zombie_powerup_insta_kill_on", false);
    set_zombie_var("zombie_powerup_point_doubler_on", false);
    set_zombie_var("zombie_powerup_firesale_on", false);
    set_zombie_var("zombie_powerup_point_doubler_time", 30); // length of point doubler
    set_zombie_var("zombie_powerup_insta_kill_time", 30); // length of insta kill
    set_zombie_var("zombie_powerup_firesale_time", 30); // length of insta kill
    set_zombie_var("zombie_powerup_drop_increment", 2000); // lower this to make drop happen more often 400
    set_zombie_var("zombie_powerup_drop_max_per_round", 4); // lower this to make drop happen more often
}

init_powerup_effects() {

    level._effect["powerup_on"] = loadfx("misc/fx_zombie_powerup_on");
    level._effect["powerup_grabbed"] = loadfx("misc/fx_zombie_powerup_grab");
    level._effect["powerup_grabbed_wave"] = loadfx("misc/fx_zombie_powerup_wave");
}

init_precache() {

    PrecacheShader("specialty_2x_zombies");
    PrecacheShader("specialty_instakill_zombies");
    PrecacheShader("specialty_maxammo_zombies");
    PrecacheShader("specialty_repair_zombies");
    PrecacheShader("specialty_deathmachine_zombies");
    PrecacheShader("specialty_nuke_zombies");
    PrecacheShader("specialty_randomperk_zombies");
    PrecacheShader("specialty_bonuspoints_zombies");
    PrecacheShader("specialty_firesale_zombies");
    PrecacheModel("zombie_pickup_perkbottle");
}

init_powerups() {

    // Random Drops
    //add_zombie_powerup("nuke", "zombie_bomb", &"ZOMBIE_POWERUP_NUKE", "misc/fx_zombie_mini_nuke");
    //add_zombie_powerup("insta_kill", "zombie_skull", &"ZOMBIE_POWERUP_INSTA_KILL");
    //add_zombie_powerup("double_points", "zombie_x2_icon", &"ZOMBIE_POWERUP_DOUBLE_POINTS");
    //add_zombie_powerup("max_ammo", "zombie_ammocan", &"ZOMBIE_POWERUP_MAX_AMMO");
    //Additional
    //add_zombie_powerup("carpenter", "zombie_carpenter", &"ZOMBIE_POWERUP_MAX_AMMO");
    //add_zombie_powerup("randomperk", "zombie_pickup_perkbottle", &"ZOMBIE_POWERUP_MAX_AMMO");
    //add_zombie_powerup("bonus_points", "zombie_z_money_icon", &"ZOMBIE_POWERUP_BONUS_POINTS");
    add_zombie_powerup("firesale", "zombie_firesale", &"ZOMBIE_POWERUP_FIRESALE");

    // Randomize the order
    randomize_powerups();

    level.zombie_powerup_index = 0;
    randomize_powerups();

    level thread powerup_hud_overlay();
}

powerup_hud_overlay() {

    level.powerup_hud_array = [];
    level.powerup_hud_array[0] = true;
    level.powerup_hud_array[1] = true;
    level.powerup_hud_array[2] = true;

    level.powerup_hud = [];
    level.powerup_hud_cover = [];
    level endon("disconnect");

    for (i = 0; i < 3; i++) {
        level.powerup_hud[i] = create_simple_hud();
        level.powerup_hud[i].foreground = true;
        level.powerup_hud[i].sort = 3;
        level.powerup_hud[i].hidewheninmenu = false;
        level.powerup_hud[i].alignX = "center";
        level.powerup_hud[i].alignY = "bottom";
        level.powerup_hud[i].horzAlign = "center";
        level.powerup_hud[i].vertAlign = "bottom";
        level.powerup_hud[i].x = -32 + (i * 15);
        level.powerup_hud[i].y = level.powerup_hud[i].y - 35;
        level.powerup_hud[i].alpha = 0.8;
    }

    shader_2x = "specialty_2x_zombies";
    shader_instakill = "specialty_instakill_zombies";
    shader_firesale = "specialty_firesale_zombies";

    while (true) {

        if (level.zombie_vars["zombie_powerup_point_doubler_time"] < 5) {
            wait(0.1);
            level.powerup_hud[0].alpha = 0;
            wait(0.1);

        } else if (level.zombie_vars["zombie_powerup_point_doubler_time"] < 10) {
            wait(0.2);
            level.powerup_hud[0].alpha = 0;
            wait(0.18);
        }

        if (level.zombie_vars["zombie_powerup_insta_kill_time"] < 5) {
            wait(0.1);
            level.powerup_hud[1].alpha = 0;
            wait(0.1);

        } else if (level.zombie_vars["zombie_powerup_insta_kill_time"] < 10) {
            wait(0.2);
            level.powerup_hud[1].alpha = 0;
            wait(0.18);

        }

        if (level.zombie_vars["zombie_powerup_firesale_time"] < 5) {
            wait(0.1);
            level.powerup_hud[2].alpha = 0;
            wait(0.1);

        } else if (level.zombie_vars["zombie_powerup_firesale_time"] < 10) {
            wait(0.2);
            level.powerup_hud[2].alpha = 0;
            wait(0.18);
        }

        if (level.zombie_vars["zombie_powerup_point_doubler_on"] == true && level.zombie_vars["zombie_powerup_insta_kill_on"] == true && level.zombie_vars["zombie_powerup_firesale_on"] == true) {

            level.powerup_hud[0].x = -24;
            level.powerup_hud[1].x = 24;
            level.powerup_hud[2].x = 48;
            level.powerup_hud[0].alpha = 1;
            level.powerup_hud[1].alpha = 1;
            level.powerup_hud[2].alpha = 1;
            level.powerup_hud[0] setshader(shader_2x, 32, 32);
            level.powerup_hud[1] setshader(shader_instakill, 32, 32);
            level.powerup_hud[2] setshader(shader_firesale, 32, 32);

        } else if (level.zombie_vars["zombie_powerup_point_doubler_on"] == true && level.zombie_vars["zombie_powerup_insta_kill_on"] == false  && level.zombie_vars["zombie_powerup_firesale_on"] == false) {
            level.powerup_hud[0].x = 0;
            level.powerup_hud[0] setshader(shader_2x, 32, 32);
            level.powerup_hud[0].alpha = 1;
            level.powerup_hud[1].alpha = 0;
            level.powerup_hud[2].alpha = 0;

        } else if (level.zombie_vars["zombie_powerup_insta_kill_on"] == true && level.zombie_vars["zombie_powerup_point_doubler_on"] == false  && level.zombie_vars["zombie_powerup_firesale_on"] == false) {

            level.powerup_hud[1].x = 0;
            level.powerup_hud[1] setshader(shader_instakill, 32, 32);
            level.powerup_hud[0].alpha = 0;
            level.powerup_hud[1].alpha = 1;
            level.powerup_hud[2].alpha = 0;
        } else if (level.zombie_vars["zombie_powerup_firesale_on"] == true && level.zombie_vars["zombie_powerup_insta_kill_on"] == false  && level.zombie_vars["zombie_powerup_point_doubler_on"] == false) {

            level.powerup_hud[2].x = 0;
            level.powerup_hud[2] setshader(shader_firesale, 32, 32);
            level.powerup_hud[0].alpha = 0;
            level.powerup_hud[1].alpha = 0;
            level.powerup_hud[2].alpha = 1;
        } else {

            level.powerup_hud[0].alpha = 0;
            level.powerup_hud[1].alpha = 0;
            level.powerup_hud[2].alpha = 0;

        }

        wait(0.01);

    }

}

randomize_powerups() {

    level.zombie_powerup_array = array_randomize(level.zombie_powerup_array);
}

get_next_powerup() {

    if (level.zombie_powerup_index >= level.zombie_powerup_array.size) {
        level.zombie_powerup_index = 0;
        randomize_powerups();
    }

    powerup = level.zombie_powerup_array[level.zombie_powerup_index];

    level.zombie_powerup_index++;

    return powerup;
}

get_num_window_destroyed() {

    num = 0;
    for (i = 0; i < level.exterior_goals.size; i++) {

        if (all_chunks_destroyed(level.exterior_goals[i].barrier_chunks)) {
            num += 1;
        }
    }

    return num;
}

watch_for_drop() {

    players = GetPlayers();
    score_to_drop = (players.size * level.zombie_vars["zombie_score_start"]) + level.zombie_vars["zombie_powerup_drop_increment"];
    while (1) {
        players = GetPlayers();

        curr_total_score = 0;

        for (i = 0; i < players.size; i++) {
            curr_total_score += players[i].score_total * 2;
        }

        if (curr_total_score > score_to_drop) {
            level.zombie_vars["zombie_powerup_drop_increment"] *= 1.14;
            score_to_drop = curr_total_score + level.zombie_vars["zombie_powerup_drop_increment"];
            level.zombie_vars["zombie_drop_item"] = 1;
        }

        wait(0.5);
    }
}

add_zombie_powerup(powerup_name, model_name, hint, fx) {

    if (IsDefined(level.zombie_include_powerups) && !IsDefined(level.zombie_include_powerups[powerup_name])) {
        return;
    }

    PrecacheModel(model_name);
    PrecacheString(hint);

    struct = SpawnStruct();

    if (!IsDefined(level.zombie_powerups)) {
        level.zombie_powerups = [];
    }

    if (!IsDefined(level.zombie_powerup_array)) {
        level.zombie_powerup_array = [];
    }

    struct.powerup_name = powerup_name;
    struct.model_name = model_name;
    struct.weapon_classname = "script_model";
    struct.hint = hint;

    if (IsDefined(fx)) {
        struct.fx = LoadFx(fx);
    }

    level.zombie_powerups[powerup_name] = struct;
    level.zombie_powerup_array[level.zombie_powerup_array.size] = powerup_name;
}

include_zombie_powerup(powerup_name) {

    if (!IsDefined(level.zombie_include_powerups)) {
        level.zombie_include_powerups = [];
    }

    level.zombie_include_powerups[powerup_name] = true;
}

powerup_round_start() {

    level.powerup_drop_count = 0;
}

powerup_drop(drop_point) {

    rand_drop = randomint(100);

    if (level.powerup_drop_count == level.zombie_vars["zombie_powerup_drop_max_per_round"]) {
        println("^3POWERUP DROP EXCEEDED THE MAX PER ROUND!");
        return;
    }

    // some guys randomly drop, but most of the time they check for the drop flag
    if (rand_drop > 2) {
        if (!level.zombie_vars["zombie_drop_item"]) {
            return;
        }

        debug = "score";
    } else {
        debug = "random";
    }

    // never drop unless in the playable area
    playable_area = getentarray("playable_area", "targetname");

    powerup = spawn("script_model", drop_point + (0, 0, 40));

    //chris_p - fixed bug where you could not have more than 1 playable area trigger for the whole map
    valid_drop = false;
    for (i = 0; i < playable_area.size; i++) {
        if (powerup istouching(playable_area[i])) {
            valid_drop = true;
        }
    }

    if (!valid_drop) {
        powerup delete();
        return;
    }

    powerup powerup_setup();
    level.powerup_drop_count++;

    powerup thread powerup_timeout();
    powerup thread powerup_wobble();
    powerup thread powerup_grab();

    level.zombie_vars["zombie_drop_item"] = 0;

    // if is !is touching trig
    // return

    // spawn the model, do a ground trace and place above
    // start the movement logic, spawn the fx
    // start the time out logic
    // start the grab logic
}

powerup_setup() {

    powerup = get_next_powerup();

    struct = level.zombie_powerups[powerup];
    self SetModel(struct.model_name);

    //TUEY Spawn Powerup
    PlaySoundatposition("spawn_powerup", self.origin);

    self.powerup_name = struct.powerup_name;
    self.hint = struct.hint;

    if (IsDefined(struct.fx)) {
        self.fx = struct.fx;
    }

    self PlayLoopSound("spawn_powerup_loop");
}

powerup_grab() {

    self endon("powerup_timedout");
    self endon("powerup_grabbed");

    while (isdefined(self)) {
        players = GetPlayers();

        for (i = 0; i < players.size; i++) {
            if (distance(players[i].origin, self.origin) < 64) {
                playfx(level._effect["powerup_grabbed"], self.origin);
                playfx(level._effect["powerup_grabbed_wave"], self.origin);

                if (IsDefined(level.zombie_powerup_grab_func)) {
                    level thread[[level.zombie_powerup_grab_func]]();
                } else {
                    switch (self.powerup_name) {
                    case "nuke":
                        level thread nuke_powerup(self);

                        //chrisp - adding powerup VO sounds
                        players[i] thread powerup_vo("nuke");
                        zombies = getaiarray("axis");
                        players[i].zombie_nuked = get_array_of_closest(self.origin, zombies);
                        players[i] notify("nuke_triggered");

                        break;
                    case "max_ammo":
                        level thread max_ammo_powerup(self);
                        players[i] thread powerup_vo("max_ammo");
                        break;
                    case "double_points":
                        level thread double_points_powerup(self);
                        players[i] thread powerup_vo("double_points");
                        break;
                    case "insta_kill":
                        level thread insta_kill_powerup(self);
                        players[i] thread powerup_vo("insta_kill");
                        break;
                    case "carpenter":
                        level thread carpenter_powerup(self.origin);
                        players[i] thread powerup_vo("carpenter");
                        break;
                    case "randomperk":
                        for (i = 0; i < players.size; i++) {
                            players[i] thread randomperk_powerup();
                        }
                        break;
                    case "bonus_points":
                        level thread bonus_points_powerup(self);
                        break;
                    case "firesale":
                        level thread firesale_powerup(self);
                        break;
                    default:
                        println("Unrecognized powerup.");
                        break;
                    }
                }

                wait(0.1);

                PlaySoundatposition("powerup_grabbed", self.origin);
                self StopLoopSound();

                self delete();
                self notify("powerup_grabbed");
            }
        }
        wait 0.1;
    }
}

randomperk_powerup(drop_item) {

    level thread maps\_zombiemode_perks::randomperk_powerup_think();

    level thread random_perk_on_hud(drop_item);

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        players[i] PlaySound("rp_vox");
    }
}

carpenter_powerup(origin, drop_item) {

    level thread carpenter_on_hud(drop_item);

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        players[i] PlaySound("carp_vox");
    }

    window_boards = getstructarray("exterior_goal", "targetname");
    total = level.exterior_goals.size;

    //COLLIN
    carp_ent = spawn("script_origin", (0, 0, 0));
    carp_ent PlayLoopSound("carp_loop");

    while (true) {
        windows = get_closest_window_repair(window_boards);
        if (!IsDefined(windows)) {
            carp_ent StopLoopSound(1);
            carp_ent PlaySound("carp_end", "sound_done");
            carp_ent waittill("sound_done");
            break;
        } else {
            window_boards = array_remove(window_boards, windows);
        }

        while (1) {
            if (all_chunks_intact(windows.barrier_chunks)) {
                break;
            }

            chunk = get_random_destroyed_chunk(windows.barrier_chunks);

            if (!IsDefined(chunk))
                break;

            windows thread maps\_zombiemode_blockers_new::replace_chunk(chunk, false, true);
            windows.clip enable_trigger();
            windows.clip DisconnectPaths();
            wait_network_frame();
            wait(0.05);
        }

        wait_network_frame();

    }

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        players[i].score += 200 * level.zombie_vars["zombie_point_scalar"];
        players[i].score_total += 200 * level.zombie_vars["zombie_point_scalar"];
        players[i] maps\_zombiemode_score::set_player_score_hud();
    }

    carp_ent delete();
}

get_closest_window_repair(windows) {

    current_window = undefined;
    for (i = 0; i < windows.size; i++) {
        if (all_chunks_intact(windows[i].barrier_chunks))
            continue;

        current_window = windows[i];

    }
    return current_window;
}

powerup_vo(type) {

    self endon("death");
    self endon("disconnect");

    index = maps\_zombiemode_weapons::get_player_index(self);
    sound = undefined;

    if (!isdefined(level.player_is_speaking)) {
        level.player_is_speaking = 0;
    }

    wait(randomfloatrange(1, 2));

    switch (type) {
    case "nuke":
        sound = "plr_" + index + "_vox_powerup_nuke_0";
        break;
    case "insta_kill":
        sound = "plr_" + index + "_vox_powerup_insta_0";
        break;
    case "max_ammo":
        sound = "plr_" + index + "_vox_powerup_ammo_0";
        break;
    case "double_points":
        sound = "plr_" + index + "_vox_powerup_double_0";
        break;
    case "carpenter":
        sound = "plr_0_vox_powerup_carp_" + index + "";
        break;
    }
    //This keeps multiple voice overs from playing on the same player (both killstreaks and headshots).
    if (level.player_is_speaking != 1 && isDefined(sound)) {
        level.player_is_speaking = 1;
        self PlaySound(sound, "sound_done");
        self waittill("sound_done");
        level.player_is_speaking = 0;
    }

}

powerup_wobble() {

    self endon("powerup_grabbed");
    self endon("powerup_timedout");

    if (isdefined(self)) {
        playfxontag(level._effect["powerup_on"], self, "tag_origin");
    }

    while (isdefined(self)) {
        waittime = randomfloatrange(2.5, 5);
        yaw = RandomInt(360);
        if (yaw > 300) {
            yaw = 300;
        } else if (yaw < 60) {
            yaw = 60;
        }
        yaw = self.angles[1] + yaw;
        self rotateto((-60 + randomint(120), yaw, -45 + randomint(90)), waittime, waittime * 0.5, waittime * 0.5);
        wait randomfloat(waittime - 0.1);
    }
}

powerup_timeout() {

    self endon("powerup_grabbed");

    wait 15;

    for (i = 0; i < 40; i++) {
        // hide and show
        if (i % 2) {
            self hide();
        } else {
            self show();
        }

        if (i < 15) {
            wait 0.5;
        } else if (i < 25) {
            wait 0.25;
        } else {
            wait 0.1;
        }
    }

    self notify("powerup_timedout");
    self delete();
}

nuke_powerup(drop_item) {

    level thread nuke_on_hud(drop_item);
    zombies = getaispeciesarray("axis");

    PlayFx(drop_item.fx, drop_item.origin);
    level thread nuke_flash();

    zombies = get_array_of_closest(drop_item.origin, zombies);

    for (i = 0; i < zombies.size; i++) {
        wait(randomfloatrange(0.1, 0.7));
        if (!IsDefined(zombies[i])) {
            continue;
        }

        if (zombies[i].animname == "boss_zombie") {
            continue;
        }

        if (is_magic_bullet_shield_enabled(zombies[i])) {
            continue;
        }

        if (i < 5 && !(zombies[i] enemy_is_dog())) {
            zombies[i] thread animscripts\death::flame_death_fx();

        }

        if (!(zombies[i] enemy_is_dog())) {
            zombies[i] maps\_zombiemode_spawner::zombie_head_gib();
        }

        zombies[i] dodamage(zombies[i].health + 666, zombies[i].origin);
        PlaySoundatposition("nuked", zombies[i].origin);
    }

    players = GetPlayers();
    for (i = 0; i < players.size; i++) {
        players[i].score += 400 * level.zombie_vars["zombie_point_scalar"];
        players[i].score_total += 400 * level.zombie_vars["zombie_point_scalar"];
        players[i] maps\_zombiemode_score::set_player_score_hud();
    }
}

nuke_flash() {

    PlaySoundatposition("nuke_flash", (0, 0, 0));

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        players[i] PlaySound("nuke_vox");
    }

    fadetowhite = newhudelem();

    fadetowhite.x = 0;
    fadetowhite.y = 0;
    fadetowhite.alpha = 0;

    fadetowhite.horzAlign = "fullscreen";
    fadetowhite.vertAlign = "fullscreen";
    fadetowhite.foreground = true;
    fadetowhite SetShader("white", 640, 480);

    // Fade into white
    fadetowhite FadeOverTime(0.2);
    fadetowhite.alpha = 0.8;

    wait 0.5;
    fadetowhite FadeOverTime(1.0);
    fadetowhite.alpha = 0;

    wait 1.1;
    fadetowhite destroy();
}

// double the points
double_points_powerup(drop_item) {

    level notify("powerup points scaled");
    level endon("powerup points scaled");

    level thread point_doubler_on_hud(drop_item);

    level.zombie_vars["zombie_point_scalar"] *= 2;

    wait 30;

    level.zombie_vars["zombie_point_scalar"] = 1;
}

max_ammo_powerup(drop_item) {

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        players[i] PlaySound("max_ammo");
        players[i] PlaySound("ma_vox");

        primaryWeapons = players[i] GetWeaponsList();

        for (x = 0; x < primaryWeapons.size; x++) {
            players[i] SetWeaponAmmoClip(primaryWeapons[x], WeaponClipSize(primaryWeapons[x]));
            players[i] GiveMaxAmmo(primaryWeapons[x], "stielhandgranate", 4);

            if (players[i] hasweapon("molotov")) {

                players[i] SetWeaponAmmoClip("molotov", 4);

            }
        }
    }

    level thread max_ammo_on_hud(drop_item);
}

bonus_points_powerup(drop_item) {

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        players[i] PlaySound("bp_vox");
        players[i].score += 500 * level.zombie_vars["zombie_point_scalar"];
        players[i].score_total += 500 * level.zombie_vars["zombie_point_scalar"];
        players[i] maps\_zombiemode_score::set_player_score_hud();
    }
    level thread bonus_points_on_hud(drop_item);
}

firesale_powerup(drop_item) {

    //level notify("powerup firesale");
    //level endon("powerup firesale");

    level thread firesale_on_hud(drop_item);

    level.zombie_vars["zombie_firesale"] = 1;
    wait(30);
    level.zombie_vars["zombie_firesale"] = 0;
    /*players = GetPlayers();
    for (i = 0; i < players.size; i++) {
        players[i] notify("firesale_over");

    }*/

}

insta_kill_powerup(drop_item) {

    level notify("powerup instakill");
    level endon("powerup instakill");

    level thread insta_kill_on_hud(drop_item);

    level.zombie_vars["zombie_insta_kill"] = 1;
    wait(30);
    level.zombie_vars["zombie_insta_kill"] = 0;
    players = GetPlayers();
    for (i = 0; i < players.size; i++) {
        players[i] notify("insta_kill_over");

    }

}

check_for_firesale(player) {

    if (IsDefined(player) && IsAlive(player) && level.zombie_vars["zombie_firesale"]) {
        return;
    }
}


check_for_instakill(player) {

    if (IsDefined(player) && IsAlive(player) && level.zombie_vars["zombie_insta_kill"]) {
        if (is_magic_bullet_shield_enabled(self)) {
            return;
        }

        if (self.animname == "boss_zombie") {
            return;
        }

        if (player.use_weapon_type == "MOD_MELEE") {
            player.last_kill_method = "MOD_MELEE";
            //BO3 Style melee points during instakill
            player.score += 70 * level.zombie_vars["zombie_point_scalar"];
            player.score_total += 70 * level.zombie_vars["zombie_point_scalar"];

        } else {
            player.last_kill_method = "MOD_UNKNOWN";

        }

        /*if( flag( "dog_round" ) )
        {
        	self DoDamage( self.health + 666, self.origin, player );
        	player notify("zombie_killed");
        }
        else*/
        {
            self maps\_zombiemode_spawner::zombie_head_gib();
            self DoDamage(self.health + 666, self.origin, player);
            player notify("zombie_killed");

        }
    }
}

insta_kill_on_hud(drop_item) {

    self endon("disconnect");

    // check to see if this is on or not
    if (level.zombie_vars["zombie_powerup_insta_kill_on"]) {
        // reset the time and keep going
        level.zombie_vars["zombie_powerup_insta_kill_time"] = 30;
        return;
    }

    level.zombie_vars["zombie_powerup_insta_kill_on"] = true;

    // set time remaining for insta kill
    level thread time_remaining_on_insta_kill_powerup();
}

time_remaining_on_insta_kill_powerup() {

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        players[i] PlaySound("insta_vox");
    }
    temp_enta = spawn("script_origin", (0, 0, 0));
    temp_enta PlayLoopSound("insta_kill_loop");

    // time it down!
    while (level.zombie_vars["zombie_powerup_insta_kill_time"] >= 0) {
        wait 0.1;
        level.zombie_vars["zombie_powerup_insta_kill_time"] = level.zombie_vars["zombie_powerup_insta_kill_time"] - 0.1;
    }

    players = GetPlayers();
    for (i = 0; i < players.size; i++) {

        players[i] PlaySound("insta_kill");

    }

    temp_enta StopLoopSound(2);
    // turn off the timer
    level.zombie_vars["zombie_powerup_insta_kill_on"] = false;

    // remove the offset to make room for new powerups, reset timer for next time
    level.zombie_vars["zombie_powerup_insta_kill_time"] = 30;
    temp_enta delete();
}

point_doubler_on_hud(drop_item) {

    self endon("disconnect");

    // check to see if this is on or not
    if (level.zombie_vars["zombie_powerup_point_doubler_on"]) {
        // reset the time and keep going
        level.zombie_vars["zombie_powerup_point_doubler_time"] = 30;
        return;
    }

    level.zombie_vars["zombie_powerup_point_doubler_on"] = true;

    // set time remaining for point doubler
    level thread time_remaining_on_point_doubler_powerup();

}
time_remaining_on_point_doubler_powerup() {

    temp_ent = spawn("script_origin", (0, 0, 0));
    temp_ent PlayLoopSound("double_point_loop");

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        players[i] PlaySound("dp_vox");
    }

    // time it down!
    while (level.zombie_vars["zombie_powerup_point_doubler_time"] >= 0) {
        wait 0.1;
        level.zombie_vars["zombie_powerup_point_doubler_time"] = level.zombie_vars["zombie_powerup_point_doubler_time"] - 0.1;
    }

    // turn off the timer
    level.zombie_vars["zombie_powerup_point_doubler_on"] = false;
    players = GetPlayers();
    for (i = 0; i < players.size; i++) {
        players[i] PlaySound("points_loop_off");
    }
    temp_ent StopLoopSound(2);

    // remove the offset to make room for new powerups, reset timer for next time
    level.zombie_vars["zombie_powerup_point_doubler_time"] = 30;
    temp_ent delete();
}

firesale_on_hud(drop_item) {

    self endon("disconnect");

    // check to see if this is on or not
    if (level.zombie_vars["zombie_powerup_firesale_on"]) {
        // reset the time and keep going
        level.zombie_vars["zombie_powerup_firesale_time"] = 30;
        return;
    }

    level.zombie_vars["zombie_powerup_firesale_on"] = true;

    // set time remaining for firesale
    level thread time_remaining_on_firesale_powerup();

}

time_remaining_on_firesale_powerup() {
    
    fs_loop = "firesale_loop";

    temp_ent = spawn("script_origin", (0, 0, 0));
    temp_ent PlayLoopSound(fs_loop);

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        players[i] PlaySound("fs_vox");
    }

    // time it down!
    while (level.zombie_vars["zombie_powerup_firesale_time"] >= 0) {
        wait 0.1;
        level.zombie_vars["zombie_powerup_firesale_time"] = level.zombie_vars["zombie_powerup_firesale_time"] - 0.1;
    }

    // turn off the timer
    level.zombie_vars["zombie_powerup_firesale_on"] = false;
    players = GetPlayers();
    for (i = 0; i < players.size; i++) {
        players[i] PlaySound("points_loop_off");
    }
    temp_ent StopLoopSound(2);

    // remove the offset to make room for new powerups, reset timer for next time
    level.zombie_vars["zombie_powerup_firesale_time"] = 30;
    temp_ent delete();
}

max_ammo_on_hud(drop_item) {

    self endon("disconnect");

    shader_maxammo = "specialty_maxammo_zombies";

    // set up the hudelem
    hudelem = maps\_hud_util::createFontString("objective", 2);
    hudelem maps\_hud_util::setPoint("TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - (level.zombie_vars["zombie_timer_offset_interval"] * 2));
    hudelem.sort = 1;
    hudelem.alignX = "center";
    hudelem.alignY = "middle";
    hudelem.horzAlign = "center";
    hudelem.vertAlign = "bottom";
    hudelem.y = -108;
    hudelem SetShader(shader_maxammo, 32, 32);
    hudelem.alpha = 1;
    hudelem fadeovertime(0.5);

    // destroy shader after a few seconds
    hudelem thread powerup_destroy_hud();
}

bonus_points_on_hud(drop_item) {

    self endon("disconnect");

    shader_bonuspoints = "specialty_bonuspoints_zombies";

    // set up the hudelem
    hudelem = maps\_hud_util::createFontString("objective", 2);
    hudelem maps\_hud_util::setPoint("TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - (level.zombie_vars["zombie_timer_offset_interval"] * 2));
    hudelem.sort = 1;
    hudelem.alignX = "center";
    hudelem.alignY = "middle";
    hudelem.horzAlign = "center";
    hudelem.vertAlign = "bottom";
    hudelem.y = -108;
    hudelem SetShader(shader_bonuspoints, 32, 32);
    hudelem.alpha = 1;
    hudelem fadeovertime(0.5);

    // destroy shader after a few seconds
    hudelem thread powerup_destroy_hud();
}

nuke_on_hud(drop_item) {

    self endon("disconnect");

    shader_nuke = "specialty_nuke_zombies";

    // set up the hudelem
    hudelem = maps\_hud_util::createFontString("objective", 2);
    hudelem maps\_hud_util::setPoint("TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - (level.zombie_vars["zombie_timer_offset_interval"] * 2));
    hudelem.sort = 1;
    hudelem.alignX = "center";
    hudelem.alignY = "middle";
    hudelem.horzAlign = "center";
    hudelem.vertAlign = "bottom";
    hudelem.y = -108;
    hudelem SetShader(shader_nuke, 32, 32);
    hudelem.alpha = 1;
    hudelem fadeovertime(0.5);

    // destroy shader after a few seconds
    hudelem thread powerup_destroy_hud();
}

carpenter_on_hud(drop_item) {

    self endon("disconnect");

    shader_carpenter = "specialty_repair_zombies";

    // set up the hudelem
    hudelem = maps\_hud_util::createFontString("objective", 2);
    hudelem maps\_hud_util::setPoint("TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - (level.zombie_vars["zombie_timer_offset_interval"] * 2));
    hudelem.sort = 1;
    hudelem.alignX = "center";
    hudelem.alignY = "middle";
    hudelem.horzAlign = "center";
    hudelem.vertAlign = "bottom";
    hudelem.y = -108;
    hudelem SetShader(shader_carpenter, 32, 32);
    hudelem.alpha = 1;
    hudelem fadeovertime(0.5);

    // destroy shader after a few seconds
    hudelem thread powerup_destroy_hud();
}

random_perk_on_hud(drop_item) {

    self endon("disconnect");

    shader_randomperk = "specialty_randomperk_zombies";

    // set up the hudelem
    hudelem = maps\_hud_util::createFontString("objective", 2);
    hudelem maps\_hud_util::setPoint("TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - (level.zombie_vars["zombie_timer_offset_interval"] * 2));
    hudelem.sort = 1;
    hudelem.alignX = "center";
    hudelem.alignY = "middle";
    hudelem.horzAlign = "center";
    hudelem.vertAlign = "bottom";
    hudelem.y = -108;
    hudelem SetShader(shader_randomperk, 32, 32);
    hudelem.alpha = 1;
    hudelem fadeovertime(0.5);

    // destroy shader after a few seconds
    hudelem thread powerup_destroy_hud();
}

powerup_destroy_hud() {

    wait 5.0;

    self.alpha = 0;

    wait 0.5;

    self destroy();
}