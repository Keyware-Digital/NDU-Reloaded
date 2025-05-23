#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_music;
#include maps\_zombiemode_utility;
//#include maps\_sounds;

#using_animtree("generic_human");

main() {
    init_shaders();
    init_models();
    init_strings();
    init_levelvars();
    init_animscripts();
    init_sounds();
    init_shellshocks();
    init_player_config();

    // the initial spawners
    level.enemy_spawns = getEntArray("zombie_spawner_init", "targetname");

    //maps\_destructible_type94truck::init(); 

    level.custom_introscreen = ::zombie_intro_screen;
    level.reset_clientdvars = ::onPlayerConnect_clientDvars;

    init_fx();

    // load map defaults
    maps\_load::main();

    level.hudelem_count = 0;
    // Call the other zombiemode scripts
    maps\_zombiemode_weapons::init();
    maps\_zombiemode_blockers_new::init();
    maps\_zombiemode_spawner::init();
    maps\_zombiemode_powerups::init();
    maps\_zombiemode_perks::init();
    maps\_zombiemode_radio::init_radio();


    init_utility();

    // register a client system...
    maps\_utility::registerClientSys("zombify");

    // fog settings
    //setexpfog( 150, 800, 0.803, 0.812, 0.794, 10 ); 

    //	level thread check_for_level_end(); 
    level thread coop_player_spawn_placement();

    // zombie ai and anim inits
    init_anims();

    // Sets up function pointers for animscripts to refer to
    level.playerlaststand_func = ::player_laststand;
    //	level.global_kill_func = maps\_zombiemode_spawner::zombie_death; 
    level.global_damage_func = maps\_zombiemode_spawner::zombie_damage;
    level.global_damage_func_ads = maps\_zombiemode_spawner::zombie_damage_ads;
    level.overridePlayerKilled = ::player_killed_override;
    level.overridePlayerDamage = ::player_damage_override;

    // used to a check in last stand for players to become zombies
    level.is_zombie_level = true;
    level.player_becomes_zombie = ::zombify_player;

    // so we dont get the uber colt when we're knocked out
    level.laststandpistol = "colt";

    level.round_start_time = 0;

    level thread onPlayerConnect();

    init_dvars();

    flag_wait("all_players_connected");

    //thread zombie_difficulty_ramp_up(); 

    // Start the Zombie MODE!
    level thread round_start();
    level thread players_playing();
    level thread setup_player_abilities();
    level thread setup_player_vars();

    DisableGrenadeSuicide();

    // Do a SaveGame, so we can restart properly when we die
    SaveGame("zombie_start", &"AUTOSAVE_LEVELSTART", "", true);

    // TESTING
    //	wait( 3 );
    //	level thread intermission();
    //	thread testing_spawner_bug();
}

testing_spawner_bug() {
    wait(0.1);
    level.round_number = 7;

    spawners = [];
    spawners[0] = GetEnt("testy", "targetname");
    while (1) {
        wait(1);
        level.enemy_spawns = spawners;
    }
}

init_shaders() {
    precacheshader("nazi_intro");
    precacheshader("zombie_intro");
    PrecacheShader("hud_chalk_1");
    PrecacheShader("hud_chalk_2");
    PrecacheShader("hud_chalk_3");
    PrecacheShader("hud_chalk_4");
    PrecacheShader("hud_chalk_5");
}

init_models() {
    precachemodel("char_ger_honorgd_zomb_behead");
    precachemodel("char_ger_zombieeye");
    PrecacheModel("char_usa_raider_gear_flametank");
    PrecacheModel("tag_origin");
    PrecacheModel("zombie_teddybear");
    PrecacheModel("collision_geo_32x32x32");
    PrecacheModel("static_berlin_ger_radio_d");
    PrecacheModel("zmb_mdl_samantha_figure");
    PrecacheModel("zmb_mdl_button");
    PrecacheModel("zmb_mdl_cash_register");
}

init_shellshocks() {
    level.player_killed_shellshock = "zombie_death";
    PrecacheShellshock(level.player_killed_shellshock);
}

init_strings() {
    PrecacheString( &"ZOMBIE_ROUND");
    PrecacheString( &"SCRIPT_PLUS");
    PrecacheString( &"ZOMBIE_GAME_OVER");
    PrecacheString( &"ZOMBIE_SURVIVED_ROUND");
    PrecacheString( &"ZOMBIE_SURVIVED_ROUNDS");

    add_zombie_hint("undefined", &"ZOMBIE_UNDEFINED");

    // Random Treasure Chest
    add_zombie_hint("default_treasure_chest", &"PROTOTYPE_ZOMBIE_RANDOM_WEAPON");

    // REWARD Barrier Pieces
    add_zombie_hint("default_reward_barrier_piece", &"PROTOTYPE_ZOMBIE_BUTTON_REWARD_BARRIER");

    // Debris
    add_zombie_hint("default_buy_debris", &"PROTOTYPE_ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS");

    //Doors
    add_zombie_hint("default_buy_door", &"PROTOTYPE_ZOMBIE_BUTTON_BUY_OPEN_DOOR");
}

init_sounds() {
    add_sound("end_of_round", "round_over");
    add_sound("end_of_game", "mx_game_over");
    add_sound("chalk_one_up", "chalk");
    add_sound("purchase", "cha_ching");
    add_sound("no_purchase", "no_cha_ching");

    // Zombification
    // TODO need to vary these up
    add_sound("playerzombie_usebutton_sound", "attack_vocals");
    add_sound("playerzombie_attackbutton_sound", "attack_vocals");
    add_sound("playerzombie_adsbutton_sound", "attack_vocals");

    // Head gib
    add_sound("zombie_head_gib", "zombie_head_gib");

    // Blockers
    add_sound("rebuild_barrier_piece", "repair_boards");
    add_sound("rebuild_barrier_hover", "boards_float");
    add_sound("debris_hover_loop", "couch_loop");
    add_sound("break_barrier_piece", "break_boards");
    add_sound("blocker_end_move", "board_slam");
    add_sound("barrier_rebuild_slam", "board_slam");

    // Doors
    add_sound("door_slide_open", "door_slide_open");
    add_sound("door_rotate_open", "door_slide_open");

    // Debris
    add_sound("debris_move", "weap_wall");

    // Random Weapon Chest
    add_sound("open_chest", "lid_open");
    add_sound("music_chest", "music_box");
    add_sound("close_chest", "lid_close");

    // Weapons on walls
    add_sound("weapon_show", "weap_wall");

}

init_levelvars() {
    level.intermission = false;
    level.zombie_total = 0;
    level.no_laststandmissionfail = true;

    level.zombie_vars = [];

    // Default to not zombify the player till further support
    set_zombie_var("zombify_player", false);

    set_zombie_var("below_world_check", -1000);

    // Respawn in the spectators in between rounds
    set_zombie_var("spectators_respawn", true);

    // Round	
    set_zombie_var("zombie_use_failsafe", true);
    set_zombie_var("zombie_round_time", 30);
    set_zombie_var("zombie_between_round_time", 10);
    set_zombie_var("zombie_intermission_time", 15);

    // Spawning
    set_zombie_var("zombie_spawn_delay", 3);

    // AI 
    set_zombie_var("zombie_health_increase", 100);
    set_zombie_var("zombie_health_increase_percent", 10, 100);
    set_zombie_var("zombie_health_start", 150);
    set_zombie_var("zombie_max_ai", 24);
    set_zombie_var("zombie_ai_per_player", 6);

    // Scoring
    set_zombie_var("zombie_score_start", 500);
    set_zombie_var("zombie_score_kill", 50);
    set_zombie_var("zombie_score_damage", 5);
    set_zombie_var("zombie_score_bonus_melee", 80);
    set_zombie_var("zombie_score_bonus_head", 50);
    set_zombie_var("zombie_score_bonus_neck", 20);
    set_zombie_var("zombie_score_bonus_torso", 10);
    set_zombie_var("zombie_score_bonus_burn", 10);

    set_zombie_var("penalty_no_revive_percent", 10, 100);
    set_zombie_var("penalty_died_percent", 0, 100);
    set_zombie_var("penalty_downed_percent", 5, 100);

    set_zombie_var("zombie_flame_dmg_point_delay", 500);

    if (IsSplitScreen()) {
        set_zombie_var("zombie_timer_offset", 280); // hud offsets
    }
}

init_dvars() {
    level.zombiemode = true;

    //coder mod: tkeegan - new code dvar
    setSavedDvar("zombiemode", "1");
    SetDvar("ui_gametype", "zom");

    if (GetDvar("zombie_debug") == "") {
        SetDvar("zombie_debug", "0");
    }

    if (GetDvar("zombie_cheat") == "") {
        SetDvar("zombie_cheat", "0");
    }
}

init_fx() {
    level._effect["wood_chunk_destory"] = loadfx("impacts/large_woodhit");

    level._effect["edge_fog"] = LoadFx("env/smoke/fx_fog_zombie_amb");
    level._effect["chest_light"] = LoadFx("env/light/fx_ray_sun_sm_short");

    level._effect["eye_glow"] = LoadFx("misc/fx_zombie_eye_single");

    level._effect["zombie_grain"] = LoadFx("misc/fx_zombie_grain_cloud");

    level._effect["headshot"] = LoadFX("impacts/flesh_hit_head_fatal_lg_exit");
    level._effect["headshot_nochunks"] = LoadFX("misc/fx_zombie_bloodsplat");
    level._effect["bloodspurt"] = LoadFX("misc/fx_zombie_bloodspurt");

    level._effect["rise_burst"] = LoadFx("maps/zombie/fx_mp_zombie_hand_dirt_burst");
    level._effect["rise_billow"] = LoadFx("maps/zombie/fx_mp_zombie_body_dirt_billowing");
    level._effect["rise_dust"] = LoadFx("maps/zombie/fx_mp_zombie_body_dust_falling");
    // Flamethrower
    level._effect["character_fire_pain_sm"] = loadfx("env/fire/fx_fire_player_sm_1sec");
    level._effect["character_fire_death_sm"] = loadfx("env/fire/fx_fire_player_md");
    level._effect["character_fire_death_torso"] = loadfx("env/fire/fx_fire_player_torso");
}

// zombie specific anims
init_anims() {
    // deaths
    level.scr_anim["zombie"]["death1"] = % ai_zombie_death_v1;
    level.scr_anim["zombie"]["death2"] = % ai_zombie_death_v2;
    level.scr_anim["zombie"]["death3"] = % ai_zombie_crawl_death_v1;
    level.scr_anim["zombie"]["death4"] = % ai_zombie_crawl_death_v2;

    // run cycles
    level.scr_anim["zombie"]["walk1"] = % ai_zombie_walk_v1;
    level.scr_anim["zombie"]["walk2"] = % ai_zombie_walk_v2;
    level.scr_anim["zombie"]["walk3"] = % ai_zombie_walk_v3;
    level.scr_anim["zombie"]["walk4"] = % ai_zombie_walk_v6;
    level.scr_anim["zombie"]["walk5"] = % ai_zombie_walk_v7;
    level.scr_anim["zombie"]["walk6"] = % ai_zombie_walk_v8;
    level.scr_anim["zombie"]["walk7"] = % ai_zombie_walk_v9;

    level.scr_anim["zombie"]["run1"] = % ai_zombie_walk_fast_v1;
    level.scr_anim["zombie"]["run2"] = % ai_zombie_walk_fast_v2;
    level.scr_anim["zombie"]["run3"] = % ai_zombie_walk_fast_v3;

    level.scr_anim["zombie"]["sprint1"] = % ai_zombie_sprint_v1;
    level.scr_anim["zombie"]["sprint2"] = % ai_zombie_sprint_v2;
    level.scr_anim["zombie"]["sprint3"] = % ai_zombie_sprint_v1;
    level.scr_anim["zombie"]["sprint4"] = % ai_zombie_run_v1;
    level.scr_anim["zombie"]["sprint5"] = % ai_zombie_sprint_v2;
    level.scr_anim["zombie"]["sprint6"] = % ai_zombie_sprint_v1;
    level.scr_anim["zombie"]["sprint7"] = % ai_zombie_sprint_v2;
    level.scr_anim["zombie"]["sprint8"] = % ai_zombie_run_v1;
    level.scr_anim["zombie"]["sprint9"] = % ai_zombie_run_v2;
    level.scr_anim["zombie"]["sprint10"] = % ai_zombie_sprint_v4;
    level.scr_anim["zombie"]["sprint11"] = % ai_zombie_sprint_v1;
    level.scr_anim["zombie"]["sprint12"] = % ai_zombie_sprint_v2;
    level.scr_anim["zombie"]["sprint13"] = % ai_zombie_sprint_v1;
    level.scr_anim["zombie"]["sprint14"] = % ai_zombie_run_v1;
    level.scr_anim["zombie"]["sprint15"] = % ai_zombie_sprint_v2;
    level.scr_anim["zombie"]["sprint16"] = % ai_zombie_sprint_v1;
    level.scr_anim["zombie"]["sprint17"] = % ai_zombie_sprint_v2;
    level.scr_anim["zombie"]["sprint18"] = % ai_zombie_run_v1;
    level.scr_anim["zombie"]["sprint19"] = % ai_zombie_run_v2;
    level.scr_anim["zombie"]["sprint20"] = % ai_zombie_sprint_v4;
    level.scr_anim["zombie"]["sprint21"] = % ai_zombie_walk_v7;

    // run cycles in prone
    level.scr_anim["zombie"]["crawl1"] = % ai_zombie_crawl;
    level.scr_anim["zombie"]["crawl2"] = % ai_zombie_crawl_v1;
    level.scr_anim["zombie"]["crawl3"] = % ai_zombie_crawl_v2;
    level.scr_anim["zombie"]["crawl4"] = % ai_zombie_crawl_v3;
    level.scr_anim["zombie"]["crawl5"] = % ai_zombie_crawl_v4;
    level.scr_anim["zombie"]["crawl6"] = % ai_zombie_crawl_v5;
    level.scr_anim["zombie"]["crawl_hand_1"] = % ai_zombie_walk_on_hands_a;
    level.scr_anim["zombie"]["crawl_hand_2"] = % ai_zombie_walk_on_hands_b;
    level.scr_anim["zombie"]["crawl_sprint1"] = % ai_zombie_crawl_sprint;
    level.scr_anim["zombie"]["crawl_sprint2"] = % ai_zombie_crawl_sprint_1;
    level.scr_anim["zombie"]["crawl_sprint3"] = % ai_zombie_crawl_sprint_2;

    if (!isDefined(level._zombie_melee)) {
        level._zombie_melee = [];
    }
    if (!isDefined(level._zombie_walk_melee)) {
        level._zombie_walk_melee = [];
    }
    if (!isDefined(level._zombie_run_melee)) {
        level._zombie_run_melee = [];
    }
    if (!isDefined(level._zombie_sprint_melee)) {
        level._zombie_sprint_melee = [];
    }

    level._zombie_melee["zombie"] = [];
    level._zombie_walk_melee["zombie"] = [];
    level._zombie_run_melee["zombie"] = [];
    level._zombie_sprint_melee["zombie"] = [];

    if (isDefined(level.zombie_anim_override)) {
        [
            [level.zombie_anim_override]
        ]();
    }

    level._zombie_walk_melee["zombie"][0] = % ai_zombie_attack_v2;
    level._zombie_run_melee["zombie"][0] = % ai_zombie_attack_forward_v2;
    level._zombie_sprint_melee["zombie"][0] = % ai_zombie_walk_attack_v4;

    // melee in crawl
    if (!isDefined(level._zombie_melee_crawl)) {
        level._zombie_melee_crawl = [];
    }
    level._zombie_melee_crawl["zombie"] = [];
    level._zombie_melee_crawl["zombie"][0] = % ai_zombie_attack_crawl;
    level._zombie_melee_crawl["zombie"][1] = % ai_zombie_attack_crawl_lunge;

    if (!isDefined(level._zombie_stumpy_melee)) {
        level._zombie_stumpy_melee = [];
    }
    level._zombie_stumpy_melee["zombie"] = [];
    level._zombie_stumpy_melee["zombie"][0] = % ai_zombie_walk_on_hands_shot_a;
    level._zombie_stumpy_melee["zombie"][1] = % ai_zombie_walk_on_hands_shot_b;

    // tesla deaths
    if (!isDefined(level._zombie_tesla_death)) {
        level._zombie_tesla_death = [];
    }
    level._zombie_tesla_death["zombie"] = [];
    level._zombie_tesla_death["zombie"][0] = % ai_zombie_tesla_death_a;
    level._zombie_tesla_death["zombie"][1] = % ai_zombie_tesla_death_b;
    level._zombie_tesla_death["zombie"][2] = % ai_zombie_tesla_death_c;
    level._zombie_tesla_death["zombie"][3] = % ai_zombie_tesla_death_d;
    level._zombie_tesla_death["zombie"][4] = % ai_zombie_tesla_death_e;

    if (!isDefined(level._zombie_tesla_crawl_death)) {
        level._zombie_tesla_crawl_death = [];
    }
    level._zombie_tesla_crawl_death["zombie"] = [];
    level._zombie_tesla_crawl_death["zombie"][0] = % ai_zombie_tesla_crawl_death_a;
    level._zombie_tesla_crawl_death["zombie"][1] = % ai_zombie_tesla_crawl_death_b;

    if (!isDefined(level._zombie_deaths)) {
        level._zombie_deaths = [];
    }
    level._zombie_deaths["zombie"] = [];
    level._zombie_deaths["zombie"][0] = % ch_dazed_a_death;
    level._zombie_deaths["zombie"][1] = % ch_dazed_b_death;
    level._zombie_deaths["zombie"][2] = % ch_dazed_c_death;
    level._zombie_deaths["zombie"][3] = % ch_dazed_d_death;

    if (!isDefined(level._zombie_rise_anims)) {
        level._zombie_rise_anims = [];
    }

    level._zombie_rise_anims["zombie"] = [];

    level._zombie_rise_anims["zombie"][1]["walk"][0] = % ai_zombie_traverse_ground_v1_walk;
    level._zombie_rise_anims["zombie"][1]["run"][0] = % ai_zombie_traverse_ground_v1_run;
    level._zombie_rise_anims["zombie"][1]["sprint"][0] = % ai_zombie_traverse_ground_climbout_fast;
    level._zombie_rise_anims["zombie"][2]["walk"][0] = % ai_zombie_traverse_ground_v2_walk_altA;

    if (!isDefined(level._zombie_rise_death_anims)) {
        level._zombie_rise_death_anims = [];
    }

    level._zombie_rise_death_anims["zombie"] = [];

    level._zombie_rise_death_anims["zombie"][1]["in"][0] = % ai_zombie_traverse_ground_v1_deathinside;
    level._zombie_rise_death_anims["zombie"][1]["in"][1] = % ai_zombie_traverse_ground_v1_deathinside_alt;

    level._zombie_rise_death_anims["zombie"][1]["out"][0] = % ai_zombie_traverse_ground_v1_deathoutside;
    level._zombie_rise_death_anims["zombie"][1]["out"][1] = % ai_zombie_traverse_ground_v1_deathoutside_alt;

    level._zombie_rise_death_anims["zombie"][2]["in"][0] = % ai_zombie_traverse_ground_v2_death_low;
    level._zombie_rise_death_anims["zombie"][2]["in"][1] = % ai_zombie_traverse_ground_v2_death_low_alt;

    level._zombie_rise_death_anims["zombie"][2]["out"][0] = % ai_zombie_traverse_ground_v2_death_high;
    level._zombie_rise_death_anims["zombie"][2]["out"][1] = % ai_zombie_traverse_ground_v2_death_high_alt;

    if (!isDefined(level._zombie_run_taunt)) {
        level._zombie_run_taunt = [];
    }
    if (!isDefined(level._zombie_board_taunt)) {
        level._zombie_board_taunt = [];
    }
    level._zombie_run_taunt["zombie"] = [];
    level._zombie_board_taunt["zombie"] = [];
    level._zombie_board_taunt["zombie"][0] = % ai_zombie_taunts_4;
    level._zombie_board_taunt["zombie"][1] = % ai_zombie_taunts_7;
    level._zombie_board_taunt["zombie"][2] = % ai_zombie_taunts_9;
    level._zombie_board_taunt["zombie"][3] = % ai_zombie_taunts_5b;
    level._zombie_board_taunt["zombie"][4] = % ai_zombie_taunts_5c;
    level._zombie_board_taunt["zombie"][5] = % ai_zombie_taunts_5d;
    level._zombie_board_taunt["zombie"][6] = % ai_zombie_taunts_5e;
    level._zombie_board_taunt["zombie"][7] = % ai_zombie_taunts_5f;
}

// Initialize any animscript related variables
init_animscripts() {
    // Setup the animscripts, then override them (we call this just incase an AI has not yet spawned)
    animscripts\init::firstInit();

    anim.idleAnimArray["stand"] = [];
    anim.idleAnimWeights["stand"] = [];
    anim.idleAnimArray["stand"][0][0] = % ai_zombie_idle_v1_delta;
    anim.idleAnimWeights["stand"][0][0] = 10;

    anim.idleAnimArray["crouch"] = [];
    anim.idleAnimWeights["crouch"] = [];
    anim.idleAnimArray["crouch"][0][0] = % ai_zombie_idle_crawl_delta;
    anim.idleAnimWeights["crouch"][0][0] = 10;
}

init_player_config() {
    level.player_is_speaking = 0;
    level.zombies_are_close = 0;
    SetDvar( "perk_altMeleeDamage", 1000 ); // adjusts how much melee damage a player with the perk will do, needs only be set once
}

// Handles the intro screen
zombie_intro_screen(string1, string2, string3, string4, string5) {
    flag_wait("all_players_connected");

    wait(1);

    //TUEY Set music state to Splash Screencompass
    setmusicstate("SPLASH_SCREEN");
    wait(0.2);
    //TUEY Set music state to WAVE_1
    setmusicstate("WAVE_1");
}

players_playing() {
    // initialize level.players_playing
    players = GetPlayers();
    level.players_playing = players.size;

    wait(20);

    players = GetPlayers();
    level.players_playing = players.size;
}

//
// NETWORK SECTION ====================================================================== //
//

watchGrenadeThrow() {
    self endon("disconnect");
    self endon("death");

    while (1) {
        self waittill("grenade_fire", grenade);

        if (isDefined(grenade)) {
            if (self maps\_laststand::player_is_in_laststand()) {
                //wait(0.05);
                grenade delete();
            }
        }
    }
}

onPlayerConnect() {
    while (1) {
        level waittill("connecting", player);

        player.entity_num = player GetEntityNumber();
        player thread onPlayerSpawned();

        player thread onPlayerDisconnect();

        player thread watchGrenadeThrow();

        player.score = level.zombie_vars["zombie_score_start"];
        player.score_total = player.score;
        player.old_score = player.score;

        player.is_zombie = false;
        player.initialized = false;
        player.zombification_time = 0;
    }
}

onPlayerConnect_clientDvars() {
    self setClientDvars("cg_deadChatWithDead", "1",
        "cg_deadChatWithTeam", "1",
        "cg_deadHearTeamLiving", "1",
        "cg_deadHearAllLiving", "1",
        "cg_everyoneHearsEveryone", "1",
        "compass", "0",
        "hud_showStance", "0",
        "cg_thirdPerson", "0",
        "cg_fov", getdvar("cg_fov"),
        "cg_thirdPersonAngle", "0",
        "ammoCounterHide", "0",
        "miniscoreboardhide", "0",
        "ui_hud_hardcore", "0");

    self SetDepthOfField(0, 0, 512, 4000, 4, 0);
}

onPlayerDisconnect() {
    self waittill("disconnect");
    self remove_from_spectate_list();
}

onPlayerSpawned() {
    self endon("disconnect");

    while (1) {
        self waittill("spawned_player");

        self setClientDvars("cg_thirdPerson", "0",
            "cg_fov", getdvar("cg_fov"),
            "cg_thirdPersonAngle", "0");

        self SetDepthOfField(0, 0, 512, 4000, 4, 0);

        self add_to_spectate_list();

        if (isDefined(self.initialized)) {
            if (self.initialized == false) {
                self.initialized = true;
                //				self maps\_zombiemode_score::create_player_score_hud(); 

                // set the initial score on the hud		
                self maps\_zombiemode_score::set_player_score_hud(true);
                self thread player_zombie_breadcrumb();
                self thread player_reload_sounds();
                self thread player_no_ammo_sounds();
                self thread player_lunge_knife_exert_sounds();
                self thread player_throw_stielhandgranate_exert_sounds();
                self thread player_throw_molotov_exert_sounds();
                self thread player_friendly_fire_sound_monitor();
                self thread player_swarm_monitor(); 
            }
        }

    }
}

player_laststand() {
    self maps\_zombiemode_score::player_downed_penalty();

    if (isDefined(self.intermission) && self.intermission) {
        // Taken from _laststand since we will never go back to it...
        self.downs++;
        maps\_challenges_coop::doMissionCallback("playerDied", self);

        level waittill("forever");
    }
}

spawnSpectator() {
    self endon("disconnect");
    self endon("spawned_spectator");
    self notify("spawned");
    self notify("end_respawn");

    if (level.intermission) {
        return;
    }

    if (isDefined(level.no_spectator) && level.no_spectator) {
        wait(3);
        ExitLevel();
    }

    // The check_for_level_end looks for this
    self.is_zombie = true;

    // Remove all reviving abilities
    self notify("zombified");

    if (isDefined(self.revivetrigger)) {
        self.revivetrigger delete();
        self.revivetrigger = undefined;
    }

    self.zombification_time = getTime(); //set time when player died

    resetTimeout();

    // Stop shellshock and rumble
    self StopShellshock();
    self StopRumble("damage_heavy");

    self.sessionstate = "spectator";
    self.spectatorclient = -1;

    self remove_from_spectate_list();

    self.maxhealth = self.health;
    self.shellshocked = false;
    self.inWater = false;
    self.friendlydamage = undefined;
    self.hasSpawned = true;
    self.spawnTime = getTime();
    self.afk = false;

    println("*************************Zombie Spectator***");
    self detachAll();

    self setSpectatePermissions(true);
    self thread spectator_thread();

    self Spawn(self.origin, self.angles);
    self notify("spawned_spectator");
}

setSpectatePermissions(isOn) {
    self AllowSpectateTeam("allies", isOn);
    self AllowSpectateTeam("axis", false);
    self AllowSpectateTeam("freelook", false);
    self AllowSpectateTeam("none", false);
}

spectator_thread() {
    self endon("disconnect");
    self endon("spawned_player");

    if (IsSplitScreen()) {
        last_alive = undefined;
        players = GetPlayers();

        for (i = 0; i < players.size; i++) {
            if (!players[i].is_zombie) {
                last_alive = players[i];
            }
        }

        share_screen(last_alive, true);

        return;
    }

    self thread spectator_toggle_3rd_person();
}

spectator_toggle_3rd_person() {
    self endon("disconnect");
    self endon("spawned_player");

    third_person = true;
    self set_third_person(true);
    //	self NotifyOnCommand( "toggle_3rd_person", "weapnext" );

    //	while( 1 )
    //	{
    //		self waittill( "toggle_3rd_person" );
    //
    //		if( third_person )
    //		{
    //			third_person = false;
    //			self set_third_person( false );
    //			wait( 0.5 );
    //		}
    //		else
    //		{
    //			third_person = true;
    //			self set_third_person( true );
    //			wait( 0.5 );
    //		}
    //	}
}

set_third_person(value) {
    if (value) {
        self setClientDvars("cg_thirdPerson", "1",
            "cg_fov", getdvar("cg_fov"),
            "cg_thirdPersonAngle", "354");

        self setDepthOfField(0, 128, 512, 4000, 6, 1.8);
    } else {
        self setClientDvars("cg_thirdPerson", "0",
            "cg_fov", getdvar("cg_fov"), 
            "cg_thirdPersonAngle", "0");

        self setDepthOfField(0, 0, 512, 4000, 4, 0);
    }
}

spectators_respawn() {
    level endon("between_round_over");

    if (!isDefined(level.zombie_vars["spectators_respawn"]) || !level.zombie_vars["spectators_respawn"]) {
        return;
    }

    if (!isDefined(level.custom_spawnPlayer)) {
        // Custom spawn call for when they respawn from spectator
        level.custom_spawnPlayer = ::spectator_respawn;
    }

    while (1) {
        players = GetPlayers();
        for (i = 0; i < players.size; i++) {
            if (players[i].sessionstate == "spectator") {
                players[i][
                    [level.spawnPlayer]
                ]();
            }
        }

        wait(1);
    }
}

spectator_respawn() {
    println("*************************Respawn Spectator***");

    spawn_off_player = get_closest_valid_player(self.origin);
    origin = get_safe_breadcrumb_pos(spawn_off_player);

    self setSpectatePermissions(false);

    if (isDefined(origin)) {
        angles = VectorToAngles(spawn_off_player.origin - origin);
    } else {
        spawnpoints = GetEntArray("info_player_deathmatch", "classname");
        num = RandomInt(spawnpoints.size);
        origin = spawnpoints[num].origin;
        angles = spawnpoints[num].angles;
    }

    self Spawn(origin, angles);

    if (IsSplitScreen()) {
        last_alive = undefined;
        players = GetPlayers();

        for (i = 0; i < players.size; i++) {
            if (!players[i].is_zombie) {
                last_alive = players[i];
            }
        }

        share_screen(last_alive, false);
    }

    // The check_for_level_end looks for this
    self.is_zombie = false;
    self.ignoreme = false;

    setClientSysState("lsm", "0", self); // Notify client last stand ended.
    self RevivePlayer();

    self notify("spawned_player");

    // Penalize the player when we respawn, since he 'died'
    self maps\_zombiemode_score::player_reduce_points("died");

    return true;
}

get_safe_breadcrumb_pos(player) {
    players = GetPlayers();
    valid_players = [];

    min_dist = 150 * 150;
    for (i = 0; i < players.size; i++) {
        if (!is_player_valid(players[i])) {
            continue;
        }

        valid_players[valid_players.size] = players[i];
    }

    for (i = 0; i < valid_players.size; i++) {
        count = 0;
        for (q = 1; q < player.zombie_breadcrumbs.size; q++) {
            if (DistanceSquared(player.zombie_breadcrumbs[q], valid_players[i].origin) < min_dist) {
                continue;
            }

            count++;
            if (count == valid_players.size) {
                return player.zombie_breadcrumbs[q];
            }
        }
    }

    return undefined;
}

round_spawning() {
    level endon("intermission");
    if (level.intermission) {
        return;
    }

    if (level.enemy_spawns.size < 1) {
        ASSERTMSG("No spawners with targetname zombie_spawner in map.");
        return;
    }

    //level.zombies = [];	

    count = 0;

    //CODER MOD: TOMMY K
    players = GetPlayers();
    for (i = 0; i < players.size; i++) {
        players[i].zombification_time = 0;
    }

    level.round_start_time = getTime();

    max = level.zombie_vars["zombie_max_ai"];

    multiplier = level.round_number / 5;
    if (multiplier < 1) {
        multiplier = 1;
    }

    // After round 10, exponentially have more AI attack the player
    if (level.round_number >= 10) {
        multiplier *= level.round_number * 0.15;
    }

    max += int(((GetPlayers().size - 1) * level.zombie_vars["zombie_ai_per_player"]) * multiplier);
    // This makes it so round 1 on solo always spawns 6 zombies, like BO1 onwards
    if(level.round_number < 3)
		{
			if(get_players().size > 1)
			{

				max = get_players().size * 3 + level.round_number;

			}
			else
			{

				max = 6;	

			}
		}
		else if ( level.first_round )
		{
			max = int( max * 0.2 );	
		}
		else if (level.round_number < 3)
		{
			max = int( max * 0.4 );
		}
		else if (level.round_number < 4)
		{
			max = int( max * 0.6 );
		}
		else if (level.round_number < 5)
		{
			max = int( max * 0.8 );
		}

    level.zombie_total = max;

    while (count < max) {
        spawn_point = level.enemy_spawns[RandomInt(level.enemy_spawns.size)];

        while (get_enemy_count() > 31) {
            wait(0.05);
        }

        ai = spawn_zombie(spawn_point);

        if (isDefined(ai)) {
            level.zombie_total--;

            //level.zombies[level.zombies.size] = ai;

            ai thread round_spawn_failsafe();
            count++;
        }

        wait(level.zombie_vars["zombie_spawn_delay"]);

        // TESTING! Only 1 Zombie for testing
        //		level waittill( "forever" );
    }
}

//bo3 style end of round points rewards, probably should be xp instead
round_completion_award_points() {
    maxPoints = 50 * level.round_number;
    
    if(maxPoints >= 1000)
    {
        maxPoints = 1000;
    }

    level.round_completion_award_points_text = [];

    for (i = 0; i < 4; i++) {
        level.round_completion_award_points_text[i] = newHudElem();
        level.round_completion_award_points_text[i].x = 0;
        level.round_completion_award_points_text[i].y = 0;
        level.round_completion_award_points_text[i].alignX = "center";
        level.round_completion_award_points_text[i].alignY = "middle";
        level.round_completion_award_points_text[i].horzAlign = "center";
        level.round_completion_award_points_text[i].vertAlign = "middle";
        level.round_completion_award_points_text[i].foreground = true;
        level.round_completion_award_points_text[i].alpha = 1;
    }

    level.round_completion_award_points_text[0].y = 0;
    level.round_completion_award_points_text[1].y = 15;
    level.round_completion_award_points_text[0].x = -15;
    level.round_completion_award_points_text[1].x = 0;

    for (i = 0; i < 4; i++) {
    level.round_completion_award_points_text[i].fontScale = 1.75;
    }

    wait(0.05);

    for (i = 0; i < 4; i++) {
    level.round_completion_award_points_text[i].fontScale = 3.5;
    }

    level.round_completion_award_points_text[0] setText("+" + maxPoints);
    
    wait(0.05);

    for (i = 0; i < 4; i++) {
    level.round_completion_award_points_text[i].fontScale = 1.75;
    }

    level.round_completion_award_points_text[1] setText("Survived"); // Add to localised strings like the rest

    for (i = 0; i < 4; i++) {
        level.round_completion_award_points_text[i] fadeOverTime(1);
        level.round_completion_award_points_text[i].alpha = 0;
        wait(0.75);
    }

    wait(0.25);

    for (i = 0; i < 4; i++) {
        level.round_completion_award_points_text[i] destroy();
    }

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        players[i] maps\_zombiemode_score::add_to_player_score(maxPoints);
    }
}

round_text(text) {
    if (level.first_round) {
        intro = true;
    } else {
        intro = false;
    }

    hud = create_simple_hud();
    hud.horzAlign = "center";
    hud.vertAlign = "middle";
    hud.alignX = "center";
    hud.alignY = "middle";
    hud.y = -100;
    hud.foreground = 1;
    hud.fontscale = 16.0;
    hud.alpha = 0;
    hud.color = (1, 1, 1);

    hud SetText(text);
    hud FadeOverTime(1.5);
    hud.alpha = 1;
    wait(1.5);

    if (intro) {
        wait(1);
        level notify("intro_change_color");
    }

    hud FadeOverTime(3);
    //hud.color = ( 0.8, 0, 0 );
    hud.color = (0.423, 0.004, 0);
    wait(3);

    if (intro) {
        level waittill("intro_hud_done");
    }

    hud FadeOverTime(1.5);
    hud.alpha = 0;
    wait(1.5);
    hud destroy();
}

round_start() {
    level.zombie_health = level.zombie_vars["zombie_health_start"];
    level.round_number = 1;
    level.first_round = true;

    // so players get init'ed with grenades
    players = GetPlayers();
    for (i = 0; i < players.size; i++) {
        players[i] giveweapon("stielhandgranate");
        players[i] setweaponammoclip("stielhandgranate", 0);
    }

    //level thread bunker_ui(); 

    level.chalk_hud1 = create_chalk_hud();
    level.chalk_hud2 = create_chalk_hud(64);

    //	level waittill( "introscreen_done" );

    level thread round_think();
}

create_chalk_hud(x) {
    if (!isDefined(x)) {
        x = 0;
    }

    hud = create_simple_hud();
    hud.alignX = "left";
    hud.alignY = "bottom";
    hud.horzAlign = "left";
    hud.vertAlign = "bottom";
    hud.color = (0.423, 0.004, 0);
    hud.x = x;
    hud.alpha = 0;

    hud SetShader("hud_chalk_1", 64, 64);

    return hud;
}

chalk_one_up() {
    if (level.first_round) {
        intro = true;
    } else {
        intro = false;
    }

    round = undefined;
    if (intro) {
        round = create_simple_hud();
        round.alignX = "center";
        round.alignY = "bottom";
        round.horzAlign = "center";
        round.vertAlign = "bottom";
        round.fontscale = 16;
        round.color = (1, 1, 1);
		round.x = 0;
		round.y = -265;
        round.alpha = 0;
        round SetText( &"ZOMBIE_ROUND");

        round FadeOverTime(1);
        round.alpha = 1;
        wait(1);

        round FadeOverTime(3);
        //		round.color = ( 0.8, 0, 0 );
        round.color = (0.423, 0.004, 0);
    }

    hud = undefined;
    if (level.round_number < 6 || level.round_number > 10) {
        hud = level.chalk_hud1;
        hud.fontscale = 32;
    } else if (level.round_number < 11) {
        hud = level.chalk_hud2;
    }

	if( intro )
	{
		hud.alpha = 0;
		hud.horzAlign = "center";
		hud.x = -5;
		hud.y = -200;
	}

    hud FadeOverTime(0.5);
    hud.alpha = 0;

    if (level.round_number == 11 && isDefined(level.chalk_hud2)) {
        level.chalk_hud2 FadeOverTime(0.5);
        level.chalk_hud2.alpha = 0;
    }

    wait(0.5);

    play_sound_at_pos("chalk_one_up", (0, 0, 0));

    if (level.round_number == 11 && isDefined(level.chalk_hud2)) {
        level.chalk_hud2 destroy_hud();
    }

    if (level.round_number > 10) {
        hud SetValue(level.round_number);
    }

    hud FadeOverTime(0.5);
    hud.alpha = 1;

    if (intro) {
        wait(3);

        if (isDefined(round)) {
            round FadeOverTime(1);
            round.alpha = 0;
        }

        wait(0.25);

        level notify("intro_hud_done");
        hud MoveOverTime(1.75);
        hud.horzAlign = "left";
        //		hud.x = 0;
        hud.y = 0;
        wait(2);

        round destroy_hud();
    }

    if (level.round_number > 10) {} else if (level.round_number > 5) {
        hud SetShader("hud_chalk_" + (level.round_number - 5), 64, 64);
    } else if (level.round_number > 1) {
        hud SetShader("hud_chalk_" + level.round_number, 64, 64);
    }

    //	ReportMTU(level.round_number);	// In network debug instrumented builds, causes network spike report to generate.
}

chalk_round_hint() {
    huds = [];
    huds[huds.size] = level.chalk_hud1;

    if (level.round_number > 5 && level.round_number < 11) {
        huds[huds.size] = level.chalk_hud2;
    }

    time = level.zombie_vars["zombie_between_round_time"];
    for (i = 0; i < huds.size; i++) {
        huds[i] FadeOverTime(time * 0.25);
        huds[i].color = (1, 1, 1);
    }

    wait(time * 0.25);
    play_sound_at_pos("end_of_round", (0, 0, 0));

    // Pulse
    fade_time = 0.5;
    steps = (time * 0.5) / fade_time;
    for (q = 0; q < steps; q++) {
        for (i = 0; i < huds.size; i++) {
            if (!isDefined(huds[i])) {
                continue;
            }

            huds[i] FadeOverTime(fade_time);
            huds[i].alpha = 0;
        }

        wait(fade_time);

        for (i = 0; i < huds.size; i++) {
            if (!isDefined(huds[i])) {
                continue;
            }

            huds[i] FadeOverTime(fade_time);
            huds[i].alpha = 1;
        }

        wait(fade_time);
    }

    for (i = 0; i < huds.size; i++) {
        if (!isDefined(huds[i])) {
            continue;
        }

        huds[i] FadeOverTime(time * 0.25);
        //		huds[i].color = ( 0.8, 0, 0 );
        huds[i].color = (0.423, 0.004, 0);
        huds[i].alpha = 1;
    }
}

round_think() {
    //TUEY - MOVE THIS LATER
    //TUEY Set music state to round 1
    setmusicstate("WAVE_1");

    while (1) {
        //////////////////////////////////////////
        //designed by prod DT#36173
        maxreward = 50 * level.round_number;
        if (maxreward > 500)
            maxreward = 500;
        level.zombie_vars["rebuild_barrier_cap_per_round"] = maxreward;
        //////////////////////////////////////////

        level.round_timer = level.zombie_vars["zombie_round_time"];

        ai_calculate_health();
        add_later_round_spawners();

        chalk_one_up();
        //		round_text( &"ZOMBIE_ROUND_BEGIN" );

        maps\_zombiemode_powerups::powerup_round_start();

        players = GetPlayers();
        array_thread(players, maps\_zombiemode_blockers_new::rebuild_barrier_reward_reset);

        level thread award_grenades_for_survivors();
        level thread round_spawning();

        round_wait();
        level thread round_completion_award_points();

        level.first_round = false;

        level thread spectators_respawn();

        //		round_text( &"ZOMBIE_ROUND_END" );
        level thread chalk_round_hint();

        wait(level.zombie_vars["zombie_between_round_time"]);

        // here's the difficulty increase over time area
        timer = level.zombie_vars["zombie_spawn_delay"];

        if (timer < 0.08) {
            timer = 0.08;
        }

        level.zombie_vars["zombie_spawn_delay"] = timer * 0.95;

        // Increase the zombie move speed
        level.zombie_move_speed = level.round_number * 8;

        level.round_number++;

        level notify("between_round_over");
    }
}

award_grenades_for_survivors() {
    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        if (!players[i].is_zombie) {
            if (!players[i] HasWeapon("stielhandgranate")) {
                players[i] GiveWeapon("stielhandgranate");
                players[i] SetWeaponAmmoClip("stielhandgranate", 0);
            }

            if (players[i] GetFractionMaxAmmo("stielhandgranate") < .25) {
                players[i] SetWeaponAmmoClip("stielhandgranate", 2);
            } else if (players[i] GetFractionMaxAmmo("stielhandgranate") < .5) {
                players[i] SetWeaponAmmoClip("stielhandgranate", 3);
            } else {
                players[i] SetWeaponAmmoClip("stielhandgranate", 4);
            }

            if (players[i] GetFractionMaxAmmo("molotov") < .25) {
                players[i] SetWeaponAmmoClip("molotov", 2);
            } else if (players[i] GetFractionMaxAmmo("molotov") < .5) {
                players[i] SetWeaponAmmoClip("molotov", 3);
            } else {
                players[i] SetWeaponAmmoClip("molotov", 4);
            }
        }
    }
}

ai_calculate_health() {
    // After round 10, get exponentially harder
    if (level.round_number >= 10) {
        level.zombie_health += Int(level.zombie_health * level.zombie_vars["zombie_health_increase_percent"]);
        return;
    }

    if (level.round_number > 1) {
        level.zombie_health = Int(level.zombie_health + level.zombie_vars["zombie_health_increase"]);
    }

}

//put the conditions in here which should
//cause the failsafe to reset
round_spawn_failsafe() {
    self endon("death"); //guy just died

    //////////////////////////////////////////////////////////////
    //FAILSAFE "hack shit"  DT#33203
    //////////////////////////////////////////////////////////////
    prevorigin = self.origin;
    while (1) {
        if (!level.zombie_vars["zombie_use_failsafe"]) {
            return;
        }

        wait(30);

        //if i've torn a board down in the last 5 seconds, just 
        //wait 30 again.
        if (isDefined(self.lastchunk_destroy_time)) {
            if ((getTime() - self.lastchunk_destroy_time) < 5000)
                continue;
        }

        //fell out of world
        if (self.origin[2] < level.zombie_vars["below_world_check"]) {
            self dodamage(self.health + 100, (0, 0, 0));
            break;
        }

        //hasnt moved 24 inches in 30 seconds?	
        if (DistanceSquared(self.origin, prevorigin) < 576) {
            self dodamage(self.health + 100, (0, 0, 0));
            break;
        }

        prevorigin = self.origin;
    }
    //////////////////////////////////////////////////////////////
    //END OF FAILSAFE "hack shit"
    //////////////////////////////////////////////////////////////
}

// Waits for the time and the ai to die
round_wait() {
    wait(1);

    while (get_enemy_count() > 0 || level.zombie_total > 0 || level.intermission) {
        wait(0.5);
    }
}

zombify_player() {
    self maps\_zombiemode_score::player_died_penalty();

    if (!isDefined(level.zombie_vars["zombify_player"]) || !level.zombie_vars["zombify_player"]) {
        self thread spawnSpectator();
        return;
    }

    self.ignoreme = true;
    self.is_zombie = true;
    self.zombification_time = getTime();

    self.team = "axis";
    self notify("zombified");

    if (isDefined(self.revivetrigger)) {
        self.revivetrigger Delete();
    }
    self.revivetrigger = undefined;

    self setMoveSpeedScale(0.3);
    self reviveplayer();

    self TakeAllWeapons();
    self starttanning();
    self GiveWeapon("zombie_melee", 0);
    self SwitchToWeapon("zombie_melee");
    self DisableWeaponCycling();
    self DisableOffhandWeapons();
    self VisionSetNaked("zombie_turned", 1);

    maps\_utility::setClientSysState("zombify", 1, self); // Zombie grain goooo

    self thread maps\_zombiemode_spawner::zombie_eye_glow();

    // set up the ground ref ent
    self thread injured_walk();
    // allow for zombie attacks, but they lose points?

    self thread playerzombie_player_damage();
    self thread playerzombie_soundboard();
}

playerzombie_player_damage() {
    self endon("death");
    self endon("disconnect");

    self thread playerzombie_infinite_health(); // manually keep regular health up
    self.zombiehealth = level.zombie_health;

    // enable PVP damage on this guy
    // self EnablePvPDamage(); 

    while (1) {
        self waittill("damage", amount, attacker, directionVec, point, type);

        if (!isDefined(attacker) || !IsPlayer(attacker)) {
            wait(0.05);
            continue;
        }

        self.zombiehealth -= amount;

        if (self.zombiehealth <= 0) {
            // "down" the zombie
            self thread playerzombie_downed_state();
            self waittill("playerzombie_downed_state_done");
            self.zombiehealth = level.zombie_health;
        }
    }
}

playerzombie_downed_state() {
    self endon("death");
    self endon("disconnect");

    downTime = 15;

    startTime = GetTime();
    endTime = startTime + (downTime * 1000);

    self thread playerzombie_downed_hud();

    self.playerzombie_soundboard_disable = true;
    self thread maps\_zombiemode_spawner::zombie_eye_glow_stop();
    self DisableWeapons();
    self AllowStand(false);
    self AllowCrouch(false);
    self AllowProne(true);

    while (GetTime() < endTime) {
        wait(0.05);
    }

    self.playerzombie_soundboard_disable = false;
    self thread maps\_zombiemode_spawner::zombie_eye_glow();
    self EnableWeapons();
    self AllowStand(true);
    self AllowCrouch(false);
    self AllowProne(false);

    self notify("playerzombie_downed_state_done");
}

playerzombie_downed_hud() {
    self endon("death");
    self endon("disconnect");

    text = NewClientHudElem(self);
    text.alignX = "center";
    text.alignY = "middle";
    text.horzAlign = "center";
    text.vertAlign = "bottom";
    text.foreground = true;
    text.font = "default";
    text.fontScale = 1.8;
    text.alpha = 0;
    text.color = (1.0, 1.0, 1.0);
    text SetText( &"ZOMBIE_PLAYERZOMBIE_DOWNED");

    text.y = -113;
    if (IsSplitScreen()) {
        text.y = -137;
    }

    text FadeOverTime(0.1);
    text.alpha = 1;

    self waittill("playerzombie_downed_state_done");

    text FadeOverTime(0.1);
    text.alpha = 0;
}

playerzombie_infinite_health() {
    self endon("death");
    self endon("disconnect");

    bighealth = 100000;

    while (1) {
        if (self.health < bighealth) {
            self.health = bighealth;
        }

        wait(0.1);
    }
}

playerzombie_soundboard() {
    self endon("death");
    self endon("disconnect");

    self.playerzombie_soundboard_disable = false;

    self.buttonpressed_use = false;
    self.buttonpressed_attack = false;
    self.buttonpressed_ads = false;

    self.useSound_waitTime = 3 * 1000; // milliseconds
    self.useSound_nextTime = GetTime();
    useSound = "playerzombie_usebutton_sound";

    self.attackSound_waitTime = 3 * 1000;
    self.attackSound_nextTime = GetTime();
    attackSound = "playerzombie_attackbutton_sound";

    self.adsSound_waitTime = 3 * 1000;
    self.adsSound_nextTime = GetTime();
    adsSound = "playerzombie_adsbutton_sound";

    self.inputSound_nextTime = GetTime(); // don't want to be able to do all sounds at once

    while (1) {
        if (self.playerzombie_soundboard_disable) {
            wait(0.05);
            continue;
        }

        if (self UseButtonPressed()) {
            if (self can_do_input("use")) {
                self thread playerzombie_play_sound(useSound);
                self thread playerzombie_waitfor_buttonrelease("use");
                self.useSound_nextTime = GetTime() + self.useSound_waitTime;
            }
        } else if (self AttackButtonPressed()) {
            if (self can_do_input("attack")) {
                self thread playerzombie_play_sound(attackSound);
                self thread playerzombie_waitfor_buttonrelease("attack");
                self.attackSound_nextTime = GetTime() + self.attackSound_waitTime;
            }
        } else if (self AdsButtonPressed()) {
            if (self can_do_input("ads")) {
                self thread playerzombie_play_sound(adsSound);
                self thread playerzombie_waitfor_buttonrelease("ads");
                self.adsSound_nextTime = GetTime() + self.adsSound_waitTime;
            }
        }

        wait(0.05);
    }
}

can_do_input(inputType) {
    if (GetTime() < self.inputSound_nextTime) {
        return false;
    }

    canDo = false;

    switch (inputType) {
    case "use":
        if (GetTime() >= self.useSound_nextTime && !self.buttonpressed_use) {
            canDo = true;
        }
        break;

    case "attack":
        if (GetTime() >= self.attackSound_nextTime && !self.buttonpressed_attack) {
            canDo = true;
        }
        break;

    case "ads":
        if (GetTime() >= self.useSound_nextTime && !self.buttonpressed_ads) {
            canDo = true;
        }
        break;

    default:
        ASSERTMSG("can_do_input(): didn't recognize inputType of " + inputType);
        break;
    }

    return canDo;
}

playerzombie_play_sound(alias) {
    self play_sound_on_ent(alias);
}

playerzombie_waitfor_buttonrelease(inputType) {
    if (inputType != "use" && inputType != "attack" && inputType != "ads") {
        ASSERTMSG("playerzombie_waitfor_buttonrelease(): inputType of " + inputType + " is not recognized.");
        return;
    }

    notifyString = "waitfor_buttonrelease_" + inputType;
    self notify(notifyString);
    self endon(notifyString);

    if (inputType == "use") {
        self.buttonpressed_use = true;
        while (self UseButtonPressed()) {
            wait(0.05);
        }
        self.buttonpressed_use = false;
    } else if (inputType == "attack") {
        self.buttonpressed_attack = true;
        while (self AttackButtonPressed()) {
            wait(0.05);
        }
        self.buttonpressed_attack = false;
    } else if (inputType == "ads") {
        self.buttonpressed_ads = true;
        while (self AdsButtonPressed()) {
            wait(0.05);
        }
        self.buttonpressed_ads = false;
    }
}

player_damage_override(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime) {

    players = GetPlayers();

    if (isDefined(self.inSoloRevive)) {
        return;
    }  

    if(level.player_is_speaking != 1) {

        level.player_is_speaking = 1;

        self thread maps\_sounds::pain_vox_sound();

        level.player_is_speaking = 0;
    }

    if (self HasPerk("specialty_detectexplosive") &&
        (sMeansOfDeath == "MOD_GRENADE_SPLASH" ||
            sMeansOfDeath == "MOD_GRENADE" ||
            sMeansOfDeath == "MOD_EXPLOSIVE" ||
            sMeansOfDeath == "MOD_PROJECTILE" ||
            sMeansOfDeath == "MOD_PROJECTILE_SPLASH" ||
            sMeansOfDeath == "MOD_BURNED")) {

        // Think "IF" is not necessary but just to be sure
        if (!maps\_laststand::player_is_in_laststand()) {
            //self RevivePlayer();
            self setBlur(0, 0);
        }

        return;
    }
    
    // Nade dmg fix
    if (sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH") {
        if (self.health > 75) {
            finalDamage = 75;
            self maps\_callbackglobal::finishPlayerDamageWrapper(eInflictor, eAttacker, finalDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime);
            return;
        }
    }

    if (self HasPerk("specialty_quickrevive") && self.health < iDamage && players.size == 1) {
        self notify("second_chance");
        self thread maps\_zombiemode_perks::solo_quickrevive(); // custom solo revive function below
        return;
    }

    if (iDamage < self.health) {
        self maps\_callbackglobal::finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime);
        return;
    }

    if (level.intermission) {
        level waittill("forever");
    }

    players = GetPlayers();
    count = 0;
    for (i = 0; i < players.size; i++) {
        if (players[i] == self || players[i].is_zombie || players[i] maps\_laststand::player_is_in_laststand() || players[i].sessionstate == "spectator") {
            count++;
        }
    }

    if (count < players.size) {
        self maps\_callbackglobal::finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime);
        self thread maps\_laststand::PlayerLastStand(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime);
        return;
    }

    self.intermission = true;
    self player_fake_death();

    if (count == players.size) {
        end_game();
    }
}

/*play_death_hands_animation(player)
{
	player DisableOffhandWeapons();
	player DisableWeaponCycling();

	player AllowLean( false );
	player AllowAds( false );
	player AllowSprint( false );
	player AllowProne( false );
	player AllowMelee( false );

    // Play the "zombie_death_hands" animation here
	self SwitchToWeapon("zombie_death_hands");
	wait 0.1; // Adjust this delay as needed
	//player Notify("zombie_death_hands_start");  //dont think we need this line

	// Wait for the animation to finish
	self waittill("zombie_death_hands_end");

	// Restore player actions - don't think we want this, keep disabled
	//player EnableOffhandWeapons();
	//player EnableWeaponCycling();

	//player AllowLean( true );
	//player AllowAds( true );
	//player AllowSprint( true );
	//player AllowProne( true );
	//player AllowMelee( true );
}*/

end_game() {
    level.intermission = true;

    update_leaderboards();

    game_over = NewHudElem(self);
    game_over.alignX = "center";
    game_over.alignY = "middle";
    game_over.horzAlign = "center";
    game_over.vertAlign = "middle";
    game_over.y -= 10;
    game_over.foreground = true;
    game_over.fontScale = 3;
    game_over.alpha = 0;
    game_over.color = (1.0, 1.0, 1.0);
    game_over SetText( &"ZOMBIE_GAME_OVER");

    game_over FadeOverTime(1);
    game_over.alpha = 1;

    survived = NewHudElem(self);
    survived.alignX = "center";
    survived.alignY = "middle";
    survived.horzAlign = "center";
    survived.vertAlign = "middle";
    survived.y += 20;
    survived.foreground = true;
    survived.fontScale = 2;
    survived.alpha = 0;
    survived.color = (1.0, 1.0, 1.0);

    if (level.round_number < 2) {
        survived SetText( &"ZOMBIE_SURVIVED_ROUND");
    } else {
        survived SetText( &"ZOMBIE_SURVIVED_ROUNDS", level.round_number);
    }

    survived FadeOverTime(1);
    survived.alpha = 1;

    wait(1);
    play_sound_at_pos("end_of_game", (0, 0, 0));
    wait(2);
    intermission();

    wait(level.zombie_vars["zombie_intermission_time"]);

    level notify("stop_intermission");
    array_thread(GetPlayers(), ::player_exit_level);

    wait(1.5);

    if (is_coop()) {
        ExitLevel(false);
    } else {
        MissionFailed();
    }

    // Let's not exit the function
    wait(666);
}

update_leaderboards() {
    if (level.systemLink || IsSplitScreen()) {
        return;
    }

    nazizombies_upload_highscore();
}

player_fake_death() {
    self TakeAllWeapons();
    //self GiveWeapon(bo2_deathhands);
    //self GiveMaxAmmo(bo2_deathhands);
    //self SwitchToWeapon(bo2_deathhands);
    self AllowStand(false);
    self AllowCrouch(false);
    self.ignoreme = true;
    self EnableInvulnerability();
    self thread maps\_sounds::death_sound();

    wait(1);
    self FreezeControls(true);
}

player_exit_level() {
    self AllowStand(true);
    self AllowCrouch(false);
    self AllowProne(false);

    if (isDefined(self.game_over_bg)) {
        self.game_over_bg.foreground = true;
        self.game_over_bg.sort = 100;
        self.game_over_bg FadeOverTime(1);
        self.game_over_bg.alpha = 1;
    }
}

player_killed_override() {
    // BLANK
    level waittill("forever");
}

injured_walk() {
    self.ground_ref_ent = Spawn("script_model", (0, 0, 0));

    self.player_speed = 50;

    // TODO do death countdown	
    self AllowSprint(false);
    self AllowProne(false);
    self AllowCrouch(false);
    self AllowAds(false);
    self AllowJump(false);

    self PlayerSetGroundReferenceEnt(self.ground_ref_ent);
    self thread limp();
}

limp() {
    level endon("disconnect");
    level endon("death");
    // TODO uncomment when/if SetBlur works again
    //self thread player_random_blur(); 

    stumble = 0;
    alt = 0;

    while (1) {
        velocity = self GetVelocity();
        player_speed = abs(velocity[0]) + abs(velocity[1]);

        if (player_speed < 10) {
            wait(0.05);
            continue;
        }

        speed_multiplier = player_speed / self.player_speed;

        p = RandomFloatRange(3, 5);
        if (RandomInt(100) < 20) {
            p *= 3;
        }
        r = RandomFloatRange(3, 7);
        y = RandomFloatRange(-8, -2);

        stumble_angles = (p, y, r);
        stumble_angles = vector_multiply(stumble_angles, speed_multiplier);

        stumble_time = RandomFloatRange(.35, .45);
        recover_time = RandomFloatRange(.65, .8);

        stumble++;
        if (speed_multiplier > 1.3) {
            stumble++;
        }

        self thread stumble(stumble_angles, stumble_time, recover_time);

        level waittill("recovered");
    }
}

stumble(stumble_angles, stumble_time, recover_time, no_notify) {
    stumble_angles = self adjust_angles_to_player(stumble_angles);

    self.ground_ref_ent RotateTo(stumble_angles, stumble_time, (stumble_time / 4 * 3), (stumble_time / 4));
    self.ground_ref_ent waittill("rotatedone");

    base_angles = (RandomFloat(4) - 4, RandomFloat(5), 0);
    base_angles = self adjust_angles_to_player(base_angles);

    self.ground_ref_ent RotateTo(base_angles, recover_time, 0, (recover_time / 2));
    self.ground_ref_ent waittill("rotatedone");

    if (!isDefined(no_notify)) {
        level notify("recovered");
    }
}

adjust_angles_to_player(stumble_angles) {
    pa = stumble_angles[0];
    ra = stumble_angles[2];

    rv = AnglesToRight(self.angles);
    fv = AnglesToForward(self.angles);

    rva = (rv[0], 0, rv[1] * -1);
    fva = (fv[0], 0, fv[1] * -1);
    angles = vector_multiply(rva, pa);
    angles = angles + vector_multiply(fva, ra);
    return angles + (0, stumble_angles[1], 0);
}

coop_player_spawn_placement() {
    structs = getstructarray("initial_spawn_points", "targetname");

    flag_wait("all_players_connected");

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        players[i] setorigin(structs[i].origin);
        players[i] setplayerangles(structs[i].angles);
    }
}

player_zombie_breadcrumb() {
    self endon("disconnect");

    min_dist = 20 * 20;
    total_crumbs = 20;

    self.zombie_breadcrumbs = [];
    self.zombie_breadcrumbs[0] = self.origin;

    self thread debug_breadcrumbs();

    while (1) {
        if (self IsOnGround()) {
            store_crumb = true;
            crumb = self.origin;

            for (i = 0; i < self.zombie_breadcrumbs.size; i++) {
                if (DistanceSquared(crumb, self.zombie_breadcrumbs[i], min_dist) < min_dist) {
                    store_crumb = false;
                }
            }

            if (store_crumb) {
                self.zombie_breadcrumbs = array_insert(self.zombie_breadcrumbs, crumb, 0);
                self.zombie_breadcrumbs = array_limiter(self.zombie_breadcrumbs, total_crumbs);
            }
        }

        wait(0.1);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////LEADERBOARD CODE///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//CODER MOD: TOMMY K
nazizombies_upload_highscore() {
    // Nazi Zombie Leaderboards
    // nazi_zombie_prototype_waves = 13
    // nazi_zombie_prototype_points = 14

    // this has gotta be the dumbest way of doing this, but at 1:33am in the morning my brain is fried!
    playersRank = 1;
    if (level.players_playing == 1)
        playersRank = 4;
    else if (level.players_playing == 2)
        playersRank = 3;
    else if (level.players_playing == 3)
        playersRank = 2;

    players = GetPlayers();
    for (i = 0; i < players.size; i++) {
        pre_highest_wave = players[i] zombieStatGet("nz_prototype_highestwave");
        pre_time_in_wave = players[i] zombieStatGet("nz_prototype_timeinwave");

        new_highest_wave = level.round_number + "" + playersRank;
        new_highest_wave = int(new_highest_wave);

        if (new_highest_wave >= pre_highest_wave) {
            if (players[i].zombification_time == 0) {
                players[i].zombification_time = getTime();
            }

            player_survival_time = players[i].zombification_time - level.round_start_time;
            player_survival_time = int(player_survival_time / 1000);

            if (new_highest_wave > pre_highest_wave || player_survival_time > pre_time_in_wave) {
                // 13 = nazi_zombie_prototype_waves leaderboard				
                rankNumber = makeRankNumber(level.round_number, playersRank, player_survival_time);

                players[i] UploadScore(13, int(rankNumber), level.round_number, player_survival_time, level.players_playing);

                players[i] zombieStatSet("nz_prototype_highestwave", new_highest_wave);
                players[i] zombieStatSet("nz_prototype_timeinwave", player_survival_time);
            }
        }

        pre_total_points = players[i] zombieStatGet("nz_prototype_totalpoints");
        if (players[i].score_total > pre_total_points) {
            // 14 = nazi_zombie_prototype_waves leaderboard
            //total_spent = players[i].score_total - players[i].score; 

            players[i] UploadScore(14, players[i].score_total, players[i].kills, level.players_playing);

            players[i] zombieStatSet("nz_prototype_totalpoints", players[i].score_total);
        }
    }
}

makeRankNumber(wave, players, time) {
    if (time > 86400)
        time = 86400; // cap it at like 1 day, need to cap cause you know some muppet is gonna end up trying it

    //pad out time
    padding = "";
    if (10 > time)
        padding += "0000";
    else if (100 > time)
        padding += "000";
    else if (1000 > time)
        padding += "00";
    else if (10000 > time)
        padding += "0";

    rank = wave + "" + players + padding + time;

    return rank;
}

//CODER MOD: TOMMY K
/*
=============
statGet
Returns the value of the named stat
=============
*/
zombieStatGet(dataName) {
    if (level.systemLink || true == IsSplitScreen()) {
        return;
    }

    return self getStat(int(tableLookup("mp/playerStatsTable.csv", 1, dataName, 0)));
}

//CODER MOD: TOMMY K
/*
=============
setStat
Sets the value of the named stat
=============
*/
zombieStatSet(dataName, value) {
    if (level.systemLink || true == IsSplitScreen()) {
        return;
    }

    self setStat(int(tableLookup("mp/playerStatsTable.csv", 1, dataName, 0)), value);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//
// INTERMISSION =========================================================== //
//

intermission() {
    level.intermission = true;
    level notify("intermission");

    players = GetPlayers();
    for (i = 0; i < players.size; i++) {
        setClientsysstate("levelNotify", "zi", players[i]); // Tell clientscripts we're in zombie intermission

        players[i] setClientDvars("cg_thirdPerson", "0" , "cg_fov", getdvar("cg_fov") );

        players[i].health = 100; // This is needed so the player view doesn't get stuck
        players[i] thread player_intermission();
    }

    wait(0.25);

    // Delay the last stand monitor so we are 100% sure the zombie intermission ("zi") is set on the cients
    players = GetPlayers();
    for (i = 0; i < players.size; i++) {
        setClientSysState("lsm", "1", players[i]);
    }

    visionset = "zombie";
    if (isDefined(level.zombie_vars["intermission_visionset"])) {
        visionset = level.zombie_vars["intermission_visionset"];
    }

    level thread maps\_utility::set_all_players_visionset(visionset, 2);
    level thread zombie_game_over_death();
}

zombie_game_over_death() {
    // Kill remaining zombies, in style!
    zombies = GetAiArray("axis");
    for (i = 0; i < zombies.size; i++) {
        if (!IsAlive(zombies[i])) {
            continue;
        }

        zombies[i] SetGoalPos(zombies[i].origin);
    }

    for (i = 0; i < zombies.size; i++) {
        if (!IsAlive(zombies[i])) {
            continue;
        }

        wait(0.5 + RandomFloat(2));

        zombies[i] maps\_zombiemode_spawner::zombie_head_gib();
        zombies[i] DoDamage(zombies[i].health + 666, zombies[i].origin);
    }
}

player_intermission() {
    self closeMenu();
    self closeInGameMenu();

    level endon("stop_intermission");

    //Show total gained point for end scoreboard and lobby
    self.score = self.score_total;

    self.sessionstate = "intermission";
    self.spectatorclient = -1;
    self.killcamentity = -1;
    self.archivetime = 0;
    self.psoffsettime = 0;
    self.friendlydamage = undefined;

    points = getstructarray("intermission", "targetname");

    if (!isDefined(points) || points.size == 0) {
        points = getentarray("info_intermission", "classname");
        if (points.size < 1) {
            println("NO info_intermission POINTS IN MAP");
            return;
        }
    }

    self.game_over_bg = NewClientHudelem(self);
    self.game_over_bg.horzAlign = "fullscreen";
    self.game_over_bg.vertAlign = "fullscreen";
    self.game_over_bg SetShader("black", 640, 480);
    self.game_over_bg.alpha = 1;

    org = undefined;
    while (1) {
        points = array_randomize(points);
        for (i = 0; i < points.size; i++) {
            point = points[i];
            // Only spawn once if we are using 'moving' org
            // If only using info_intermissions, this will respawn after 5 seconds.
            if (!isDefined(org)) {
                self Spawn(point.origin, point.angles);
            }

            // Only used with STRUCTS
            if (isDefined(points[i].target)) {
                if (!isDefined(org)) {
                    org = Spawn("script_origin", self.origin + (0, 0, -60));
                }

                self LinkTo(org, "", (0, 0, -60), (0, 0, 0));
                self SetPlayerAngles(points[i].angles);
                org.origin = points[i].origin;

                speed = 20;
                if (isDefined(points[i].speed)) {
                    speed = points[i].speed;
                }

                target_point = getstruct(points[i].target, "targetname");
                dist = Distance(points[i].origin, target_point.origin);
                time = dist / speed;

                q_time = time * 0.25;
                if (q_time > 1) {
                    q_time = 1;
                }

                self.game_over_bg FadeOverTime(q_time);
                self.game_over_bg.alpha = 0;

                org MoveTo(target_point.origin, time, q_time, q_time);
                wait(time - q_time);

                self.game_over_bg FadeOverTime(q_time);
                self.game_over_bg.alpha = 1;

                wait(q_time);
            } else {
                self.game_over_bg FadeOverTime(1);
                self.game_over_bg.alpha = 0;

                wait(5);

                self.game_over_bg FadeOverTime(1);
                self.game_over_bg.alpha = 1;

                wait(1);
            }
        }
    }
}

get_players_alive() {
	players = get_players(); // We Get An Array With All Players Currently Ingame (Alive or Dead) 
	playersAlive = []; // A New Array To Hold Players Which Are Alive

	for(i = 0; i < players.size; i++) { // Running Through The Players Array
		if( isPlayer(players[i]) && isAlive(players[i]) ) { // Checking If A Single Player Is A Player & is Alive
			playersAlive[playersAlive.size] = players[i]; // If The Above Evaluates To True We'll Add This Player To The playersAlive Array
		}
	}

	return playersAlive; // Return The playersAlive Array
}

setup_player_abilities()
{
	
	players = GetPlayers();
	for (i = 0; i < players.size; i++)
    {
		players[i] thread animscripts\dolphin_dive::setup_player_dolphin_dive();
        players[i] thread maps\_zombiemode_perks::player_switch_weapon_watcher();
        players[i] thread maps\_zombiemode_perks::player_cook_grenade_watcher();
	}
}

setup_player_vars()
{

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        players[i] setClientDvar("player_lastStandBleedoutTime", 45);
        players[i] setClientDvar("player_hud_specialty_electric_cherry", 0);
        players[i] setClientDvar("player_hud_specialty_mule_kick", 0);
        // enable sv_cheats just to set level of detail for everyone
        players[i] setClientDvar("sv_cheats", 1);
        // these set the level of detail relative to distance (should really be set in the menus as one option like mature content and set via dvarint)
        players[i] setClientDvar("r_lodBiasRigid", -1000);
        players[i] setClientDvar("r_lodBiasSkinned", -1000);
        players[i] setClientDvar("r_lodScaleRigid", 1);
        players[i] setClientDvar("r_lodScaleSkinned", 1);
        // disable sv_cheats immediately afterwards so players can't use vars that are flagged as cheats
        players[i] setClientDvar("sv_cheats", 0);

        num = players[i].entity_num;

        //Assign a colour to a player based on their player number, in solo this is zero so the colour will always be white like in BO3
		switch(num)
		{
			case 0:
            players[i] setClientDvar("cg_ScoresColor_Gamertag_" + i, level.character_colour[0]);
				break; 
			case 1:
            players[i] setClientDvar("cg_ScoresColor_Gamertag_" + i, level.character_colour[1]);
				break;
			case 2:
            players[i] setClientDvar("cg_ScoresColor_Gamertag_" + i, level.character_colour[2]);
				break;  
			case 3:
            players[i] setClientDvar("cg_ScoresColor_Gamertag_" + i, level.character_colour[3]);
				break;
		}


        //Sets the correct player portrait based on what character they randomly spawned as
		switch(level.random_character_index[i])
		{
			case 0:
            players[i] setClientDvar("plr_hud_portrait", 0);
				break; 
			case 1:
            players[i] setClientDvar("plr_hud_portrait", 1);
				break;
			case 2:
            players[i] setClientDvar("plr_hud_portrait", 2);
				break;  
			case 3:
            players[i] setClientDvar("plr_hud_portrait", 3);
				break;
		}

        // enable sv_cheats for developers for testing purposes, this enables the use of vars flagged as cheats
        if (players[i].playername == "ReubenUKGB" || players[i].playername == "TreborUK") {
            players[i] setClientDvar("sv_cheats", 1);
            //players[i] maps\_zombiemode_score::add_to_player_score(100000); //comment out for default behaviour
        }
    }
}

player_reload_sounds()
{
    self endon( "death" );
    self endon( "disconnect" );

    self.reload_cooldown = false;

    while( 1 )
    {
        // Wait for reload to start
        self waittill( "reload_start" );
        wait 0.05; // Small delay to sync with reloading_monitor()

        // Skip if weapon is filtered (handled in reloading_monitor, but double-check)
        current_weapon = self GetCurrentWeapon();
        if( IsDefined( level.filtered_weapon ) && level.filtered_weapon.size > 0 )
        {
            for( i = 0; i < level.filtered_weapon.size; i++ )
            {
                if( IsDefined( level.filtered_weapon[i] ) && current_weapon == level.filtered_weapon[i] )
                {
                    //IPrintLnBold("Reload sound skipped for filtered weapon: " + current_weapon); // Debug
                    continue; // Skip to next reload event
                }
            }
        }

        // Only proceed if not in cooldown and not speaking
        if( !IsDefined( level.player_is_speaking ) )
        {
            level.player_is_speaking = 0;
        }
        if( level.player_is_speaking != 1 && !self.reload_cooldown )
        {
            // Check for nearby zombies
            zombies = GetAiArray( "axis" );
            level.zombies_are_close = 0;
            for( i = 0; i < zombies.size; i++ )
            {
                if( IsDefined( zombies[i] ) && IsAlive( zombies[i] ) )
                {
                    // Check height and distance (using Distance() and 225 inches)
                    if( zombies[i].origin[2] < self.origin[2] + 80 && zombies[i].origin[2] > self.origin[2] - 80 && Distance( zombies[i].origin, self.origin ) <= 225 )
                    {
                        level.zombies_are_close = 1;
                        break; // One close zombie is enough
                    }
                }
            }

            // Play sound if conditions are met
            if( self.reloading && get_enemy_count() + level.zombie_total >= 6 && level.zombies_are_close == 1 )
            {
                //IPrintLnBold("Reload sound triggered: zombies close, " + (get_enemy_count() + level.zombie_total) + " total enemies"); // Debug
                self.reload_cooldown = true;
                level.player_is_speaking = 1;
                self thread maps\_sounds::reload_vox_sound();
                self waittill( "reloading_sound_finished" );
                level.player_is_speaking = 0;
                self thread reload_cooldown_reset();
            }
        }
        wait 0.05; // Small wait to prevent tight looping
    }
}
reload_cooldown_reset()
{
    wait 5; // Cooldown duration to cover reload animations
    self.reload_cooldown = false;
}

player_no_ammo_sounds()
{
    self endon("death");
    self endon("disconnect");

    self.no_ammo_cooldown = false;

    while(1)
    {
        // Skip if in Last Stand
        if(self maps\_laststand::player_is_in_laststand())
        {
            wait 0.5;
            continue;
        }

        // Skip if on cooldown or speaking
        if(self.no_ammo_cooldown || level.player_is_speaking == 1)
        {
            wait 0.5;
            continue;
        }

        // Get current weapon
        current_weapon = self GetCurrentWeapon();

        // Skip invalid or filtered weapons
        if(!IsDefined(current_weapon) || current_weapon == "none" || current_weapon == "zombie_perk_bottle_doubletap" || 
           current_weapon == "zombie_perk_bottle_jugg" || current_weapon == "zombie_perk_bottle_revive" || 
           current_weapon == "zombie_perk_bottle_sleight" || current_weapon == "mine_bouncing_betty" || 
           current_weapon == "syrette" || current_weapon == "zombie_knuckle_crack" || current_weapon == "zombie_bowie_flourish")
        {
            wait 0.5;
            continue;
        }
        if(IsDefined(level.filtered_weapon) && level.filtered_weapon.size > 0)
        {
            for(i = 0; i < level.filtered_weapon.size; i++)
            {
                if(IsDefined(level.filtered_weapon[i]) && current_weapon == level.filtered_weapon[i])
                {
                    //IPrintLnBold("No ammo sound skipped for filtered weapon: " + current_weapon); // Debug
                    wait 0.5;
                    continue;
                }
            }
        }

        // Check ammo count
        totalCurrentWeaponAmmo = self GetAmmoCount(current_weapon);
        if(totalCurrentWeaponAmmo == 0)
        {
            // Delay to confirm no ammo (handles weapon switches)
            wait 2; // Matches Treyarch's delay
            if(self GetCurrentWeapon() != current_weapon || self GetAmmoCount(current_weapon) != 0)
            {
                //IPrintLnBold("No ammo sound skipped: weapon changed or ammo restored"); // Debug
                wait 0.5;
                continue;
            }

            //IPrintLnBold("No ammo sound triggered for weapon: " + current_weapon); // Debug
            self.no_ammo_cooldown = true;
            level.player_is_speaking = 1;
            self thread maps\_sounds::no_ammo_vox();
            self waittill("no_ammo_sound_finished");
            level.player_is_speaking = 0;
            self thread no_ammo_cooldown_reset();
        }

        wait 0.5; // Check every 0.5 seconds
    }
}
no_ammo_cooldown_reset()
{
    wait 20; // Matches Treyarch's cooldown
    self.no_ammo_cooldown = false;
}

player_lunge_knife_exert_sounds()
{
    self endon( "death" );

    while(1)
    {
        wait (0.01); // was 1.25, moved "waits" to sounds.gsc.

        if(level.player_is_speaking == 0) {
            if(self IsMeleeing()) {

                level.player_is_speaking = 1;

                self thread maps\_sounds::melee_vox_sound();

                self waittill("melee_sound_finished");

                level.player_is_speaking = 0;
            }
        }
        wait(0.01);  //was 0.05, prevent sound from playing more than once during long knive lunges
    }
}

player_throw_stielhandgranate_exert_sounds()
{
    self endon("death");

    while (1)
    {
      	self waittill("grenade_fire", grenade, weaponName);

        if (level.player_is_speaking == 0 && weaponName == "Stielhandgranate" && self IsThrowingGrenade()) //for some reason the game only accepts Stielhandgranate and not stielhandgranate, might have to capitalise others?
        {
            level.player_is_speaking = 1;

            self thread maps\_sounds::stielhandgranate_vox_sound();

            self waittill("stielhandgranate_sound_finished");

            level.player_is_speaking = 0;
        }
        wait(0.05);
    }
}

player_throw_molotov_exert_sounds()
{
    self endon("death");

    while (1)
    {
      	self waittill("grenade_fire", grenade2, weaponName);

        if (level.player_is_speaking == 0 && weaponName == "molotov" && self IsThrowingGrenade())
        {
            level.player_is_speaking = 1;

            self thread maps\_sounds::molotov_vox_sound();

            self waittill("molotov_sound_finished");

            level.player_is_speaking = 0;
        }
    }
}

player_friendly_fire_sound_monitor()
{
    self endon("death");
    self endon("disconnect");

    self.friendly_fire_sound_cooldown = false;

    while (1)
    {
        // Wait for the player to fire their weapon
        self waittill("weapon_fired");

        // Skip if on cooldown or speaking
        if (self.friendly_fire_sound_cooldown || level.player_is_speaking == 1)
        {
            wait(0.05);
            continue;
        }

        // Skip if in last stand or a zombie
        if (self maps\_laststand::player_is_in_laststand() || self.is_zombie)
        {
            wait(0.05);
            continue;
        }

        // Filter out the crap
        current_weapon = self GetCurrentWeapon();
        if (!isDefined(current_weapon) || current_weapon == "none" || 
            current_weapon == "zombie_perk_bottle_doubletap" || 
            current_weapon == "zombie_perk_bottle_jugg" || 
            current_weapon == "zombie_perk_bottle_revive" || 
            current_weapon == "zombie_perk_bottle_sleight" || 
            current_weapon == "mine_bouncing_betty" || 
            current_weapon == "syrette" || 
            current_weapon == "zombie_knuckle_crack" || 
            current_weapon == "zombie_bowie_flourish")
        {
            wait(0.05);
            continue;
        }

        // Perform a bullet trace to see what the player is aiming at
        start = self GetEye();
        end = start + (AnglesToForward(self GetPlayerAngles()) * 10000);
        trace = BulletTrace(start, end, true, self);

        // Check if the hit entity is a player, not the shooter, and a valid teammate
        if (isDefined(trace["entity"]) && isPlayer(trace["entity"]) && trace["entity"] != self)
        {
            // Ensure the target is a teammate (not a zombie, not in last stand, on the same team)
            if (!trace["entity"].is_zombie && !trace["entity"] maps\_laststand::player_is_in_laststand() && trace["entity"].team == self.team)
            {
                // Trigger the friendly fire sound on the TARGET player
                self.friendly_fire_sound_cooldown = true;
                trace["entity"] thread maps\_sounds::friendly_fire_sound();
                // Wait for the target's sound to finish or timeout
                trace["entity"] waittill_notify_or_timeout("_ff_sound_done", 5);
                self thread friendly_fire_sound_cooldown_reset();
            }
        }

        wait(0.05);
    }
}
friendly_fire_sound_cooldown_reset()
{
    wait(2); // 2-second cooldown to prevent sound spam
    self.friendly_fire_sound_cooldown = false;
}

// Monitors each player for swarm conditions (6+ zombies within 175 inches)
player_swarm_monitor()
{
    self endon("death");
    self endon("disconnect");

    if (!IsDefined(self) || !IsPlayer(self))
    {
        return;
    }

    self.swarm_cooldown = false;

    while (1)
    {
        if (!IsDefined(level.player_is_speaking))
        {
            level.player_is_speaking = 0;
        }
        if (level.player_is_speaking != 1 && !self.swarm_cooldown)
        {
            zombies = GetAiArray("axis");
            zombies_nearby = 0;
            for (i = 0; i < zombies.size; i++)
            {
                if (IsDefined(zombies[i]) && IsAlive(zombies[i]))
                {
                    if (zombies[i].origin[2] < self.origin[2] + 80 && 
                        zombies[i].origin[2] > self.origin[2] - 80 && 
                        Distance(zombies[i].origin, self.origin) <= 200)
                    {
                        zombies_nearby++;
                    }
                }
            }

            if (zombies_nearby >= 6)
            {
                self.swarm_cooldown = true;
                level.player_is_speaking = 1;
                self thread maps\_sounds::swarm_sound();
                self waittill_notify_or_timeout("_swarm_sound_done", 5);
                level.player_is_speaking = 0;
                self thread swarm_cooldown_reset();
            }
        }
        wait 0.5;
    }
}

// Resets the swarm sound cooldown
swarm_cooldown_reset()
{
    wait 5;
    self.swarm_cooldown = false;
}