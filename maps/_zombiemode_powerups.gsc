#include maps\_utility;

#include common_scripts\utility;

#include maps\_zombiemode_utility;

//#include maps\_sounds;

init() {

    init_powerup_vars();

    init_powerup_effects();

    init_precache();

    init_powerups();

    init_mystery_weapon_costs();

    thread watch_for_drop();
}

init_powerup_vars() {

    // powerup Vars
    set_zombie_var("zombie_double_points", 1);
    set_zombie_var("zombie_insta_kill", 0);
    set_zombie_var("zombie_max_ammo", 0);
    set_zombie_var("zombie_carpenter", 0);
    set_zombie_var("zombie_death_machine", 0);
    set_zombie_var("zombie_nuke", 0);
    set_zombie_var("zombie_random_perk", 0);
    set_zombie_var("zombie_bonus_points", 0);
    set_zombie_var("zombie_fire_sale", 0);
    set_zombie_var("zombie_drop_item", 0);
    set_zombie_var("zombie_timer_offset", 350); // hud offsets
    set_zombie_var("zombie_timer_offset_interval", 30);
    set_zombie_var("zombie_powerup_double_points_on", false);
    set_zombie_var("zombie_powerup_insta_kill_on", false);
    set_zombie_var("zombie_powerup_max_ammo_on", false);
    set_zombie_var("zombie_powerup_carpenter_on", false);
    set_zombie_var("zombie_powerup_death_machine_on", false);
    set_zombie_var("zombie_powerup_nuke_on", false);
    set_zombie_var("zombie_powerup_random_perk_on", false);
    set_zombie_var("zombie_powerup_bonus_points_on", false);
    set_zombie_var("zombie_powerup_fire_sale_on", false);
    set_zombie_var("zombie_powerup_double_points_time", 30);
    set_zombie_var("zombie_powerup_insta_kill_time", 30);
    set_zombie_var("zombie_powerup_max_ammo_time", 5);
    set_zombie_var("zombie_powerup_carpenter_time", 5);
    set_zombie_var("zombie_powerup_death_machine_time", 30);
    set_zombie_var("zombie_powerup_nuke_time", 5);
    set_zombie_var("zombie_powerup_random_perk_time", 5);
    set_zombie_var("zombie_powerup_bonus_points_time", 5);
    set_zombie_var("zombie_powerup_fire_sale_time", 30);
    set_zombie_var("zombie_powerup_drop_increment", 2000); // lower this to make drop happen more often
    set_zombie_var("zombie_powerup_drop_max_per_round", 4); // increase this to make drop happen more often
    set_zombie_var("enableFireSale", 0);
    set_zombie_var("enableRandomPerk", 0);  
}

init_powerup_effects() {

    level._effect["powerup_on"] = loadfx("misc/fx_zombie_powerup_on");
    level._effect["powerup_on_bad"] = loadfx("powerups/fx_zombie_powerup_on_bad");
    level._effect["powerup_grabbed"] = loadfx("misc/fx_zombie_powerup_grab");
    level._effect["powerup_grabbed_wave"] = loadfx("misc/fx_zombie_powerup_wave");
}

init_precache() {

    PrecacheShader("specialty_double_points_zombies");
    PrecacheShader("specialty_insta_kill_zombies");
    PrecacheShader("specialty_max_ammo_zombies");
    PrecacheShader("specialty_carpenter_zombies");
    PrecacheShader("specialty_death_machine_zombies");
    PrecacheShader("specialty_nuke_zombies");
    PrecacheShader("specialty_random_perk_zombies");
    PrecacheShader("specialty_bonus_points_zombies");
    PrecacheShader("specialty_fire_sale_zombies");
}

init_powerups() {

    //Random Drops
    add_zombie_powerup("double_points", "zmb_pwr_up_double_points", &"ZOMBIE_POWER_UP_DOUBLE_POINTS");
    add_zombie_powerup("insta_kill", "zmb_pwr_up_insta_kill", &"ZOMBIE_POWER_UP_INSTA_KILL");
    add_zombie_powerup("max_ammo", "zmb_pwr_up_max_ammo", &"ZOMBIE_POWER_UP_MAX_AMMO");
    add_zombie_powerup("carpenter", "zmb_pwr_up_carpenter", &"ZOMBIE_POWER_UP_CARPENTER");
    add_zombie_powerup("death_machine", "zmb_pwr_up_death_machine", &"ZOMBIE_POWER_UP_DEATH_MACHINE");
	add_zombie_powerup("nuke", "zmb_pwr_up_nuke", &"ZOMBIE_POWER_UP_NUKE", "misc/fx_zombie_mini_nuke_hotness");
    add_zombie_powerup("bonus_points", "zmb_pwr_up_bonus_points", &"ZOMBIE_POWER_UP_BONUS_POINTS");
	add_zombie_powerup("random_perk", "zmb_pwr_up_perks_a_cola_world", &"ZOMBIE_POWER_UP_RANDOM_PERK");
    add_zombie_powerup("fire_sale", "zmb_pwr_up_fire_sale", &"ZOMBIE_POWER_UP_FIRE_SALE");

    // Randomize the order
    randomize_powerups();

    level.zombie_powerup_index = 0;
    randomize_powerups();

    level thread powerup_hud_overlay();
}

init_mystery_weapon_costs() {
    level.zombie_treasure_chest_cost = 950;
    level.zombie_weapon_cabinet_cost = 1900;
}

powerup_hud_overlay()
{
	level endon ("disconnect");

	level.powerup_hud = [];

	for(i = 0; i < 9; i++)
	{
		level.powerup_hud[i] = create_simple_hud();
		level.powerup_hud[i].foreground = true; 
		level.powerup_hud[i].sort = 9; 
		level.powerup_hud[i].hidewheninmenu = false; 
		level.powerup_hud[i].alignX = "center"; 
		level.powerup_hud[i].alignY = "bottom";
		level.powerup_hud[i].horzAlign = "center"; 
		level.powerup_hud[i].vertAlign = "bottom";
		level.powerup_hud[i].x = 0;
		level.powerup_hud[i].y = level.powerup_hud[i].y - 35; 
		level.powerup_hud[i].alpha = 0;
		level.powerup_hud[i] MoveOverTime( 0.05 );
		level.powerup_hud[i] FadeOverTime( 0.05 );
	}
	
	icon_size = 32;
	
	level.powerup_hud[0] setshader("specialty_double_points_zombies", icon_size, icon_size);
	level.powerup_hud[1] setshader("specialty_insta_kill_zombies", icon_size, icon_size);
	level.powerup_hud[2] setshader("specialty_max_ammo_zombies", icon_size, icon_size);
	level.powerup_hud[3] setshader("specialty_carpenter_zombies", icon_size, icon_size);
	level.powerup_hud[4] setshader("specialty_death_machine_zombies", icon_size, icon_size);
	level.powerup_hud[5] setshader("specialty_nuke_zombies", icon_size, icon_size);
	level.powerup_hud[6] setshader("specialty_random_perk_zombies", icon_size, icon_size);
	level.powerup_hud[7] setshader("specialty_bonus_points_zombies", icon_size, icon_size);
	level.powerup_hud[8] setshader("specialty_fire_sale_zombies", icon_size, icon_size);
	
	level.powerup_hud[0] thread powerup_shader_timer("zombie_powerup_double_points_time", "zombie_powerup_double_points_on");
	level.powerup_hud[1] thread powerup_shader_timer("zombie_powerup_insta_kill_time", "zombie_powerup_insta_kill_on");
	level.powerup_hud[2] thread powerup_shader_hide("zombie_powerup_max_ammo_time", "zombie_powerup_max_ammo_on");
	level.powerup_hud[3] thread powerup_shader_hide("zombie_powerup_carpenter_time", "zombie_powerup_carpenter_on");
	level.powerup_hud[4] thread powerup_shader_timer("zombie_powerup_death_machine_time", "zombie_powerup_death_machine_on");
    level.powerup_hud[5] thread powerup_shader_hide("zombie_powerup_nuke_time", "zombie_powerup_nuke_on");
	level.powerup_hud[6] thread powerup_shader_hide("zombie_powerup_random_perk_time", "zombie_powerup_random_perk_on");
	level.powerup_hud[7] thread powerup_shader_hide("zombie_powerup_bonus_points_time", "zombie_powerup_bonus_points_on");
	level.powerup_hud[8] thread powerup_shader_timer("zombie_powerup_fire_sale_time", "zombie_powerup_fire_sale_on");
	
	while(true)
	{	
		level waittill("zombie_powerup_timer");
		
		powerup_statements = [];
		powerup_statements[powerup_statements.size] = level.zombie_vars["zombie_powerup_double_points_on"];
		powerup_statements[powerup_statements.size] = level.zombie_vars["zombie_powerup_insta_kill_on"];
    	powerup_statements[powerup_statements.size] = level.zombie_vars["zombie_powerup_max_ammo_on"];
		powerup_statements[powerup_statements.size] = level.zombie_vars["zombie_powerup_carpenter_on"];
		powerup_statements[powerup_statements.size] = level.zombie_vars["zombie_powerup_death_machine_on"];
    	powerup_statements[powerup_statements.size] = level.zombie_vars["zombie_powerup_nuke_on"];
		powerup_statements[powerup_statements.size] = level.zombie_vars["zombie_powerup_random_perk_on"];
		powerup_statements[powerup_statements.size] = level.zombie_vars["zombie_powerup_bonus_points_on"];
        powerup_statements[powerup_statements.size] = level.zombie_vars["zombie_powerup_fire_sale_on"];
			
		powerup_active_hud = [];
		
		for (i = 0; i < powerup_statements.size; i++)
		{	
			if (powerup_statements[i])
			{
				powerup_active_hud[powerup_active_hud.size] = level.powerup_hud[i];
			}
		}
		
		switch(powerup_active_hud.size)
		{
			case 0:
				// ignore
			break;
			
			case 1:
				powerup_active_hud[0].x = 0;
			break;
			
			case 2:
				powerup_active_hud[0].x = -24;
				
				powerup_active_hud[1].x = 24;
			break;
			
			case 3:
				powerup_active_hud[0].x = -48;
				
				powerup_active_hud[1].x = 0;
				
				powerup_active_hud[2].x = 48;
			break;
			
			case 4:
				powerup_active_hud[0].x = -72;
				
				powerup_active_hud[1].x = -24;
				
				powerup_active_hud[2].x = 24;
				
				powerup_active_hud[3].x = 72;
			break;

			case 5:
				powerup_active_hud[0].x = -96;
				
				powerup_active_hud[1].x = -48;
				
				powerup_active_hud[2].x = 0;
				
				powerup_active_hud[3].x = 48;

				powerup_active_hud[4].x = 96;
			break;

			case 6:
				powerup_active_hud[0].x = -120;
				
				powerup_active_hud[1].x = -72;
				
				powerup_active_hud[2].x = -24;
				
				powerup_active_hud[3].x = 24;

				powerup_active_hud[4].x = 72;

				powerup_active_hud[5].x = 120;
			break;

			case 7:
				powerup_active_hud[0].x = -120;
				
				powerup_active_hud[1].x = -96;
				
				powerup_active_hud[2].x = -48;
				
				powerup_active_hud[3].x = 0;

				powerup_active_hud[4].x = 48;

				powerup_active_hud[5].x = 96;

				powerup_active_hud[6].x = 120;
			break;

			case 8:
				powerup_active_hud[0].x = -168;
				
				powerup_active_hud[1].x = -120;
				
				powerup_active_hud[2].x = -72;
				
				powerup_active_hud[3].x = -24;

				powerup_active_hud[4].x = 24;

				powerup_active_hud[5].x = 72;

				powerup_active_hud[6].x = 120;

				powerup_active_hud[7].x = 168;
			break;

			case 9:
				powerup_active_hud[0].x = -168;
				
				powerup_active_hud[1].x = -120;
				
				powerup_active_hud[2].x = -96;
				
				powerup_active_hud[3].x = -48;

				powerup_active_hud[4].x = 0;

				powerup_active_hud[5].x = 48;

				powerup_active_hud[6].x = 96;

				powerup_active_hud[7].x = 120;

				powerup_active_hud[8].x = 168;
			break;
		}
	}
}

powerup_shader_timer(timerName, booleanName)
{
	while(1)
	{
		if (!level.zombie_vars[booleanName] || level.zombie_vars[timerName] <= 0.5)
		{
			self.alpha = 0;
		}	
		else if (level.zombie_vars[timerName] < 5)
		{
			wait(0.1);		
			self.alpha = 0;
			wait(0.1);
			self.alpha = 1;
		}
		else if (level.zombie_vars[timerName] < 10)
		{
			wait(0.2);
			self.alpha = 0;
			wait(0.18);
			self.alpha = 1;
		}
		else if( level.zombie_vars[timerName] >= 10 && level.zombie_vars[booleanName])
		{
			self.alpha = 1;
		}
		
		wait 0.01;
	}
}

powerup_shader_hide(timerName, booleanName) {
	while(1)
	{
		if (!level.zombie_vars[booleanName] || level.zombie_vars[timerName] <= 0.5)
		{
			self.alpha = 0;
		}	
		else if (level.zombie_vars[timerName] < 5)
		{	
			self.alpha = 1;
			wait(5.0);
			self.alpha = 0;
		}
		wait 0.01;
	}
}

randomize_powerups() {

    level.zombie_powerup_array = array_randomize(level.zombie_powerup_array);
}

get_valid_powerup()
{

	powerup = get_next_powerup();
	while(1)
	{	
        if(powerup == "fire_sale" && level.zombie_vars["enableFireSale"] == 0) {
            powerup = get_next_powerup();

        }
        else if(powerup == "random_perk" && level.zombie_vars["enableRandomPerk"] == 0) {
            powerup = get_next_powerup();

        }
		else
		{
			return powerup;
		}
	}
}

get_next_powerup()
{
	powerup = level.zombie_powerup_array[ level.zombie_powerup_index ];
	level.zombie_powerup_index++;
	if( level.zombie_powerup_index >= level.zombie_powerup_array.size )
	{
		level.zombie_powerup_index = 0;
		randomize_powerups();
	}
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
            curr_total_score += players[i].score_total;
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

    if (isDefined(level.zombie_include_powerups) && !isDefined(level.zombie_include_powerups[powerup_name])) {
        return;
    }

    PrecacheModel(model_name);
    PrecacheString(hint);

    struct = SpawnStruct();

    if (!isDefined(level.zombie_powerups)) {
        level.zombie_powerups = [];
    }

    if (!isDefined(level.zombie_powerup_array)) {
        level.zombie_powerup_array = [];
    }

    struct.powerup_name = powerup_name;
    struct.model_name = model_name;
    struct.weapon_classname = "script_model";
    struct.hint = hint;

    if (isDefined(fx)) {
        struct.fx = LoadFx(fx);
    }

    level.zombie_powerups[powerup_name] = struct;
    level.zombie_powerup_array[level.zombie_powerup_array.size] = powerup_name;
}

include_zombie_powerup(powerup_name) {

    if (!isDefined(level.zombie_include_powerups)) {
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

    powerup = get_valid_powerup();

    struct = level.zombie_powerups[powerup];

    self SetModel(struct.model_name);

    playsoundatposition("spawn_powerup", self.origin);

    self.powerup_name = struct.powerup_name;
    self.hint = struct.hint;

    if (isDefined(struct.fx)) {
        self.fx = struct.fx;
    }

    self PlayLoopSound("spawn_powerup_loop");

}

powerup_grab() {

    self endon("powerup_timedout");
    self endon("powerup_grabbed");

    while (isDefined(self)) {
        players = GetPlayers();

        for (i = 0; i < players.size; i++) {
            if (distance(players[i].origin, self.origin) < 64) {
                playfx(level._effect["powerup_grabbed"], self.origin);
                playfx(level._effect["powerup_grabbed_wave"], self.origin);

                if (isDefined(level.zombie_powerup_grab_func)) {
                    level thread[[level.zombie_powerup_grab_func]]();
                } else {
                    switch (self.powerup_name) {
                    case "double_points":
                        level thread double_points_powerup(self);
                        players[i] thread powerup_vo("double_points");
                        break;
                    case "insta_kill":
                        level thread insta_kill_powerup(self);
                        players[i] thread powerup_vo("insta_kill");
                        break;
                    case "max_ammo":
                        level thread max_ammo_powerup(self);
                        players[i] thread powerup_vo("max_ammo");
                        break;
                    case "carpenter":
                        level thread carpenter_powerup(self.origin);
                        players[i] thread powerup_vo("carpenter");
                        break;
                    case "death_machine":
                        level thread death_machine_powerup(self);
                        players[i] thread powerup_vo("death_machine");
                        break;
                    case "nuke":
                        level thread nuke_powerup(self);

                        //chrisp - adding powerup VO sounds
                        players[i] thread powerup_vo("nuke");
                        zombies = getaiarray("axis");
                        players[i].zombie_nuked = get_array_of_closest(self.origin, zombies);
                        players[i] notify("nuke_triggered");

                        break;
                    case "random_perk":
                        level thread random_perk_powerup(self);
                        break;
                    case "bonus_points":
                        level thread bonus_points_powerup(self);
                        break;
                    case "fire_sale":
                        level thread fire_sale_powerup(self);
                        break;
                    default:
                        println("Unrecognized powerup.");
                        break;
                    }
                }

				wait( 0.1 );

				playsoundatposition("powerup_grabbed", self.origin);
				self stoploopsound();

				self delete();
				self notify ("powerup_grabbed");
            }
        }
        wait 0.1;
    }
}

powerup_vo(type) {

    self endon("death");
    self endon("disconnect");

    index = maps\_zombiemode_weapons::get_player_index(self);
    sound = undefined;

    if (!isDefined(level.player_is_speaking)) {
        level.player_is_speaking = 0;
    }

    wait(randomfloatrange(1, 2));

    switch (type) {
    case "bonus_points":
        //wait 3;
        self thread maps\_sounds::pickup_bonus_points_sound();
        //sound = "plr_0_vox_powerup_carp_" + index + "";
        break;
    case "carpenter":
        //wait 3;
        self thread maps\_sounds::pickup_carpenter_sound();
        //sound = "plr_0_vox_powerup_carp_" + index + "";
        break;
    case "death_machine":
        //wait 3;
        self thread maps\_sounds::pickup_death_machine_sound();
        //sound = "plr_" + index + "_vox_powerup_insta_0";
        break;
    case "double_points":
        //wait 3;
        self thread maps\_sounds::pickup_doublepoints_sound();
        //sound = "plr_" + index + "_vox_powerup_double_0";
        break;
    case "fire_sale":
        //wait 3;
        self thread maps\_sounds::pickup_firesale_sound();
        //sound = "plr_" + index + "_vox_powerup_double_0";
        break;
    case "insta_kill":
        //wait 3;
        self thread maps\_sounds::pickup_insta_kill_sound();
        //sound = "plr_" + index + "_vox_powerup_insta_0";
        break;
    case "max_ammo":
        //wait 3;
        self thread maps\_sounds::pickup_maxammo_sound();
        //sound = "plr_" + index + "_vox_powerup_ammo_0";
        break;
    case "nuke":
        //wait 3;
        self thread maps\_sounds::pickup_nuke_sound();
        //sound = "plr_" + index + "_vox_powerup_nuke_0";
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

    if (isDefined(self)) {
        playfxontag(level._effect["powerup_on"], self, "tag_origin");
    }

    while (isDefined(self)) {
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

// double the points
double_points_powerup(drop_item) {

    level notify("powerup points scaled");
    level endon("powerup points scaled");

    level thread double_points_on_hud(drop_item);

    level.zombie_vars["zombie_double_points"] *= 2;

    wait 30;

    level.zombie_vars["zombie_double_points"] = 1;
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

check_for_instakill(player, mod, hit_location)
{
	if( isDefined( player ) && IsAlive( player ) && level.zombie_vars["zombie_insta_kill"])
	{
        modName = remove_mod_from_methodofdeath( mod );

		self maps\_zombiemode_spawner::zombie_head_gib();
		self DoDamage(self.health + 666, self.origin, player, modName, hit_location);
        player notify("zombie_killed");
	}
}

max_ammo_powerup(drop_item) {

    level thread max_ammo_on_hud(drop_item);

    level.zombie_vars["zombie_max_ammo"] = 1;

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        //players[i] PlaySound("max_ammo");

        primaryWeapons = players[i] GetWeaponsList();

        for (x = 0; x < primaryWeapons.size; x++) {
            players[i] SetWeaponAmmoClip(primaryWeapons[x], WeaponClipSize(primaryWeapons[x]));
            players[i] GiveMaxAmmo(primaryWeapons[x], "stielhandgranate", 4);

            if (players[i] hasweapon("molotov")) {

                players[i] SetWeaponAmmoClip("molotov", 4);

            }
        }
    }

    wait(5);

    level.zombie_vars["zombie_max_ammo"] = 0;

}

carpenter_powerup(origin, drop_item) {

    level thread carpenter_on_hud(drop_item);

    level.zombie_vars["zombie_carpenter"] = 1;

    window_boards = getstructarray("exterior_goal", "targetname");
    total = level.exterior_goals.size;

    //COLLIN
    carp_ent = spawn("script_origin", (0, 0, 0));
    carp_ent PlayLoopSound("carp_loop");

    while (true) {
        windows = get_closest_window_repair(window_boards);
        if (!isDefined(windows)) {
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

            if (!isDefined(chunk))
                break;

            windows thread maps\_zombiemode_blockers_new::replace_chunk(chunk, false, true);
            windows.clip enable_trigger();
            windows.clip DisconnectPaths();
            wait_network_frame();
            wait(0.05);
        }

        wait_network_frame();

    }

    playersAlive = maps\_zombiemode::get_players_alive();

    for(i = 0; i < playersAlive.size; i++) {
        playersAlive[i].score += 200 * level.zombie_vars["zombie_double_points"];
        playersAlive[i].score_total += 200 * level.zombie_vars["zombie_double_points"];
        playersAlive[i] maps\_zombiemode_score::set_player_score_hud();
    }

    carp_ent delete();

    wait(5);

    level.zombie_vars["zombie_carpenter"] = 0;

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

death_machine_powerup(drop_item) {

    level thread death_machine_on_hud(drop_item);

    level.zombie_vars["zombie_death_machine"] = 1;

    wait(5);

    level.zombie_vars["zombie_death_machine"] = 0;

}

nuke_powerup(drop_item) {

    level thread nuke_on_hud(drop_item);
    zombies = getaispeciesarray("axis");

    PlayFx(drop_item.fx, drop_item.origin);
    level thread nuke_flash();

    zombies = get_array_of_closest(drop_item.origin, zombies);

    for (i = 0; i < zombies.size; i++) {
        wait(randomfloatrange(0.1, 0.7));
        if (!isDefined(zombies[i])) {
            continue;
        }

        if (i < 5) {
            zombies[i] thread animscripts\death::flame_death_fx();

        }
        
        zombies[i] maps\_zombiemode_spawner::zombie_head_gib();

        zombies[i] dodamage(zombies[i].health + 666, zombies[i].origin);
        zombies[i] PlaySound("nuked");
    }

    playersAlive = maps\_zombiemode::get_players_alive();

    for(i = 0; i < playersAlive.size; i++) {
        playersAlive[i].score += 400 * level.zombie_vars["zombie_double_points"];
        playersAlive[i].score_total += 400 * level.zombie_vars["zombie_double_points"];
        playersAlive[i] maps\_zombiemode_score::set_player_score_hud();
    }
}

nuke_flash()
{	
	
	fadetowhite = newhudelem();

	fadetowhite.x = 0; 
	fadetowhite.y = 0; 
	fadetowhite.alpha = 0; 

	fadetowhite.horzAlign = "fullscreen"; 
	fadetowhite.vertAlign = "fullscreen"; 
	fadetowhite.foreground = true; 
	fadetowhite SetShader( "white", 640, 480 ); 

	// Fade into white
	fadetowhite FadeOverTime( 0.2 );
	fadetowhite.alpha = 0.5;            //0.8

	wait 0.5;
	fadetowhite FadeOverTime( 1.0 );
	fadetowhite.alpha = 0.8;            //was 0

	wait 1.0;
	fadetowhite destroy();
}

random_perk_powerup(drop_item) {

    level thread random_perk_on_hud(drop_item);

    level.zombie_vars["zombie_random_perk"] = 1;

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        players[i] thread maps\_zombiemode_perks::random_perk_powerup_think();
    }

    wait(5);

    level.zombie_vars["zombie_random_perk"] = 0;    

}

bonus_points_powerup(drop_item) {

    level thread bonus_points_on_hud(drop_item);

    level.zombie_vars["zombie_bonus_points"] = 1;

    playersAlive = maps\_zombiemode::get_players_alive();

    for(i = 0; i < playersAlive.size; i++) {
        playersAlive[i].score += 500 * level.zombie_vars["zombie_double_points"];
        playersAlive[i].score_total += 500 * level.zombie_vars["zombie_double_points"];
        playersAlive[i] maps\_zombiemode_score::set_player_score_hud();
    }

    wait(5);

    level.zombie_vars["zombie_bonus_points"] = 0;

}



fire_sale_powerup(drop_item) {

    level thread fire_sale_on_hud(drop_item);

    level.zombie_vars["zombie_fire_sale"] = 1;

    if(!isDefined(level.zombie_mystery_box_padlock) || level.zombie_mystery_box_padlock == 0) {
        for(i=0;i<level.chests.size;i++) {
            level.zombie_treasure_chest_cost = 10;
            cost = level.zombie_treasure_chest_cost;
            level.chests[i] SetHintString( &"PROTOTYPE_ZOMBIE_RANDOM_WEAPON", "&&1", cost );
            wait 0.05;
        }

        for(i=0;i<level.weapon_cabs.size;i++) {
            level.zombie_weapon_cabinet_cost = 20;
            cost = level.zombie_weapon_cabinet_cost;
            level.weapon_cabs[i] SetHintString( &"PROTOTYPE_ZOMBIE_CABINET_OPEN", "&&1", cost );
            wait 0.05;
        }
    }

    wait(30);
    level.zombie_vars["zombie_fire_sale"] = 0;

    if(!isDefined(level.zombie_mystery_box_padlock) || level.zombie_mystery_box_padlock == 0) {
        for(i=0;i<level.chests.size;i++) {
            level.zombie_treasure_chest_cost = 950;
            cost = level.zombie_treasure_chest_cost;
            level.chests[i] SetHintString( &"PROTOTYPE_ZOMBIE_RANDOM_WEAPON", "&&1", cost );
            wait 0.05;
        }

        for(i=0;i<level.weapon_cabs.size;i++) {
            level.zombie_weapon_cabinet_cost = 1900;
            cost = level.zombie_weapon_cabinet_cost;
            level.weapon_cabs[i] SetHintString( &"PROTOTYPE_ZOMBIE_CABINET_OPEN", "&&1", cost );
            wait 0.05;
        }
    }
}

double_points_on_hud(drop_item) {

    self endon("disconnect");

    // check to see if this is on or not
    if (level.zombie_vars["zombie_powerup_double_points_on"]) {
        // reset the time and keep going
        level.zombie_vars["zombie_powerup_double_points_time"] = 30;
        return;
    }

    level.zombie_vars["zombie_powerup_double_points_on"] = true;

    // set time remaining for double points
    level thread time_remaining_on_double_points_powerup();

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

max_ammo_on_hud(drop_item) {

    self endon("disconnect");

    // check to see if this is on or not
    if (level.zombie_vars["zombie_powerup_max_ammo_on"]) {
        // reset the time and keep going
        level.zombie_vars["zombie_powerup_max_ammo_time"] = 5;
        return;
    }

    level.zombie_vars["zombie_powerup_max_ammo_on"] = true;

    // set time remaining for max ammo
    level thread time_remaining_on_max_ammo_powerup();
}

carpenter_on_hud(drop_item) {

    self endon("disconnect");

    // check to see if this is on or not
    if (level.zombie_vars["zombie_powerup_carpenter_on"]) {
        // reset the time and keep going
        level.zombie_vars["zombie_powerup_carpenter_time"] = 5;
        return;
    }

    level.zombie_vars["zombie_powerup_carpenter_on"] = true;

    // set time remaining for carpenter
    level thread time_remaining_on_carpenter_powerup();
}

death_machine_on_hud(drop_item) {

    self endon("disconnect");

    // check to see if this is on or not
    if (level.zombie_vars["zombie_powerup_death_machine_on"]) {
        // reset the time and keep going
        level.zombie_vars["zombie_powerup_death_machine_time"] = 30;
        return;
    }

    level.zombie_vars["zombie_powerup_death_machine_on"] = true;

    // set time remaining for death machine
    level thread time_remaining_on_death_machine_powerup();
}

nuke_on_hud(drop_item) {

    self endon("disconnect");

    // check to see if this is on or not
    if (level.zombie_vars["zombie_powerup_nuke_on"]) {
        // reset the time and keep going
        level.zombie_vars["zombie_powerup_nuke_time"] = 5;
        return;
    }

    level.zombie_vars["zombie_powerup_nuke_on"] = true;

    // set time remaining for nuke
    level thread time_remaining_on_nuke_powerup();
}

random_perk_on_hud(drop_item) {

    self endon("disconnect");

    // check to see if this is on or not
    if (level.zombie_vars["zombie_powerup_random_perk_on"]) {
        // reset the time and keep going
        level.zombie_vars["zombie_powerup_random_perk_time"] = 5;
        return;
    }

    level.zombie_vars["zombie_powerup_random_perk_on"] = true;

    // set time remaining for random perk
    level thread time_remaining_on_random_perk_powerup();
}

bonus_points_on_hud(drop_item) {

    self endon("disconnect");

    // check to see if this is on or not
    if (level.zombie_vars["zombie_powerup_bonus_points_on"]) {
        // reset the time and keep going
        level.zombie_vars["zombie_powerup_bonus_points_time"] = 5;
        return;
    }

    level.zombie_vars["zombie_powerup_bonus_points_on"] = true;

    // set time remaining for bonus points
    level thread time_remaining_on_bonus_points_powerup();
}

fire_sale_on_hud(drop_item) {

    self endon("disconnect");

    // check to see if this is on or not
    if (level.zombie_vars["zombie_powerup_fire_sale_on"]) {
        // reset the time and keep going
        level.zombie_vars["zombie_powerup_fire_sale_time"] = 30;
        return;
    }

    level.zombie_vars["zombie_powerup_fire_sale_on"] = true;

    // set time remaining for fire sale
    level thread time_remaining_on_fire_sale_powerup();

}

time_remaining_on_double_points_powerup() {

    level notify("zombie_powerup_timer");

    players = GetPlayers();

    for (i = 0; i < players.size; i++) {
        //players[i] PlaySound("dp_vox");
        players[i] thread maps\_sounds::announcer_vox_double_points_sound();
    }

    x2_ent = spawn("script_origin", (0, 0, 0));
    x2_ent PlayLoopSound("double_point_loop");

    // time it down!
    while (level.zombie_vars["zombie_powerup_double_points_time"] >= 0) {
        wait 0.1;
        level.zombie_vars["zombie_powerup_double_points_time"] = level.zombie_vars["zombie_powerup_double_points_time"] - 0.1;
    }

    level notify("zombie_powerup_timer");

    // turn off the timer
    level.zombie_vars["zombie_powerup_double_points_on"] = false;

    for (i = 0; i < players.size; i++) {
        players[i] PlaySound("points_loop_off");
    }

    x2_ent StopLoopSound(2);

    // remove the offset to make room for new powerups, reset timer for next time
    level.zombie_vars["zombie_powerup_double_points_time"] = 30;
    x2_ent delete();
}

time_remaining_on_insta_kill_powerup() {

    level notify("zombie_powerup_timer");

    players = GetPlayers();
    for (i = 0; i < players.size; i++) {
        //players[i] PlaySound("insta_kill");
        //players[i] PlaySound("insta_vox");
        players[i] thread maps\_sounds::announcer_vox_insta_kill_sound();
    }

    insta_kill_ent = spawn("script_origin", (0, 0, 0));
    insta_kill_ent PlayLoopSound("insta_kill_loop");

    // time it down!
    while (level.zombie_vars["zombie_powerup_insta_kill_time"] >= 0) {
        wait 0.1;
        level.zombie_vars["zombie_powerup_insta_kill_time"] = level.zombie_vars["zombie_powerup_insta_kill_time"] - 0.1;
    }

    level notify("zombie_powerup_timer");

    insta_kill_ent StopLoopSound(2);
    // turn off the timer
    level.zombie_vars["zombie_powerup_insta_kill_on"] = false;

    for (i = 0; i < players.size; i++) {
        players[i] PlaySound("points_loop_off");
    }

    // remove the offset to make room for new powerups, reset timer for next time
    level.zombie_vars["zombie_powerup_insta_kill_time"] = 30;
    insta_kill_ent delete();
}

time_remaining_on_max_ammo_powerup() {

    level notify("zombie_powerup_timer");

    players = GetPlayers();
    for (i = 0; i < players.size; i++) {
        //players[i] PlaySound("ma_vox");
        players[i] thread maps\_sounds::announcer_vox_max_ammo_sound();
    }

    // time it down!
    while (level.zombie_vars["zombie_powerup_max_ammo_time"] >= 0) {
        wait 0.1;
        level.zombie_vars["zombie_powerup_max_ammo_time"] = level.zombie_vars["zombie_powerup_max_ammo_time"] - 0.1;
    }

    level notify("zombie_powerup_timer");

    // turn off the timer
    level.zombie_vars["zombie_powerup_max_ammo_on"] = false;

    // remove the offset to make room for new powerups, reset timer for next time
    level.zombie_vars["zombie_powerup_max_ammo_time"] = 5;
}

time_remaining_on_carpenter_powerup() {

    level notify("zombie_powerup_timer");

    players = GetPlayers();
    for (i = 0; i < players.size; i++) {
        //players[i] PlaySound("carp_vox");
        players[i] thread maps\_sounds::announcer_vox_carpenter_sound();
    }

    // time it down!
    while (level.zombie_vars["zombie_powerup_carpenter_time"] >= 0) {
        wait 0.1;
        level.zombie_vars["zombie_powerup_carpenter_time"] = level.zombie_vars["zombie_powerup_carpenter_time"] - 0.1;
    }

    level notify("zombie_powerup_timer");

    // turn off the timer
    level.zombie_vars["zombie_powerup_carpenter_on"] = false;

    // remove the offset to make room for new powerups, reset timer for next time
    level.zombie_vars["zombie_powerup_carpenter_time"] = 5;
}

time_remaining_on_death_machine_powerup() {

    level notify("zombie_powerup_timer");

    players = GetPlayers();
    for (i = 0; i < players.size; i++) {
       //players[i] PlaySound("dm_vox");
        players[i] thread maps\_sounds::announcer_vox_death_machine_sound();
    }

    // time it down!
    while (level.zombie_vars["zombie_powerup_death_machine_time"] >= 0) {
        wait 0.1;
        level.zombie_vars["zombie_powerup_death_machine_time"] = level.zombie_vars["zombie_powerup_death_machine_time"] - 0.1;
    }

    level notify("zombie_powerup_timer");

    // turn off the timer
    level.zombie_vars["zombie_powerup_death_machine_on"] = false;

    for (i = 0; i < players.size; i++) {
        players[i] PlaySound("points_loop_off");
    }

    // remove the offset to make room for new powerups, reset timer for next time
    level.zombie_vars["zombie_powerup_death_machine_time"] = 30;
}

time_remaining_on_nuke_powerup() {

    level notify("zombie_powerup_timer");

    players = GetPlayers();
    for (i = 0; i < players.size; i++) {
        players[i] PlaySound("nuke_flash");
        //players[i] PlaySound("nuke_vox");
        players[i] thread maps\_sounds::announcer_vox_nuke_sound();
    }

    // time it down!
    while (level.zombie_vars["zombie_powerup_nuke_time"] >= 0) {
        wait 0.1;
        level.zombie_vars["zombie_powerup_nuke_time"] = level.zombie_vars["zombie_powerup_nuke_time"] - 0.1;
    }

    level notify("zombie_powerup_timer");

    // turn off the timer
    level.zombie_vars["zombie_powerup_nuke_on"] = false;

    // remove the offset to make room for new powerups, reset timer for next time
    level.zombie_vars["zombie_powerup_nuke_time"] = 5;
}

time_remaining_on_bonus_points_powerup() {

    level notify("zombie_powerup_timer");

    players = GetPlayers();
    for (i = 0; i < players.size; i++) {
        //players[i] PlaySound("bp_vox");
        players[i] thread maps\_sounds::announcer_vox_bonus_points_sound();
    }

    // time it down!
    while (level.zombie_vars["zombie_powerup_bonus_points_time"] >= 0) {
        wait 0.1;
        level.zombie_vars["zombie_powerup_bonus_points_time"] = level.zombie_vars["zombie_powerup_bonus_points_time"] - 0.1;
    }

    level notify("zombie_powerup_timer");

    // turn off the timer
    level.zombie_vars["zombie_powerup_bonus_points_on"] = false;

    // remove the offset to make room for new powerups, reset timer for next time
    level.zombie_vars["zombie_powerup_bonus_points_time"] = 5;
}

time_remaining_on_random_perk_powerup() {

    level notify("zombie_powerup_timer");

    players = GetPlayers();
    for (i = 0; i < players.size; i++) {
        players[i] PlaySound("rp_vox");
    }

    // time it down!
    while (level.zombie_vars["zombie_powerup_random_perk_time"] >= 0) {
        wait 0.1;
        level.zombie_vars["zombie_powerup_random_perk_time"] = level.zombie_vars["zombie_powerup_random_perk_time"] - 0.1;
    }

    level notify("zombie_powerup_timer");

    // turn off the timer
    level.zombie_vars["zombie_powerup_random_perk_on"] = false;

    // remove the offset to make room for new powerups, reset timer for next time
    level.zombie_vars["zombie_powerup_random_perk_time"] = 5;
}

time_remaining_on_fire_sale_powerup() {

    level notify("zombie_powerup_timer");

    players = GetPlayers();
    for (i = 0; i < players.size; i++) {
        //players[i] PlaySound("fs_vox");
        players[i] thread maps\_sounds::announcer_vox_fire_sale_sound();
        wait 1;
    }

    for(i=0;i<level.chests.size;i++) {
        level.chests[i].fire_sale_ent_chests = spawn("script_origin", (level.chests[i].origin));
        level.chests[i].fire_sale_ent_chests PlayLoopSound("fire_sale_loop");
        wait 0.05;
    }

    for(i=0;i<level.weapon_cabs.size;i++) {
        level.weapon_cabs[i].fire_sale_ent_weapon_cabs = spawn("script_origin", (level.weapon_cabs[i].origin));
        level.weapon_cabs[i].fire_sale_ent_weapon_cabs PlayLoopSound("fire_sale_loop");
        wait 0.05;
    }

    // time it down!
    while (level.zombie_vars["zombie_powerup_fire_sale_time"] >= 0) {
        wait 0.1;
        level.zombie_vars["zombie_powerup_fire_sale_time"] = level.zombie_vars["zombie_powerup_fire_sale_time"] - 0.1;
    }

    level notify("zombie_powerup_timer");

    // turn off the timer
    level.zombie_vars["zombie_powerup_fire_sale_on"] = false;

    for (i = 0; i < players.size; i++) {
        players[i] PlaySound("points_loop_off");
    }

    for(i=0;i<level.chests.size;i++) {
        level.chests[i].fire_sale_ent_chests StopLoopSound(2);
        level.chests[i].fire_sale_ent_chests Delete();
        wait 0.05;
    }

    for(i=0;i<level.weapon_cabs.size;i++) {
        level.weapon_cabs[i].fire_sale_ent_weapon_cabs StopLoopSound(2);
        level.weapon_cabs[i].fire_sale_ent_weapon_cabs Delete();
        wait 0.05;
    }     

    // remove the offset to make room for new powerups, reset timer for next time
    level.zombie_vars["zombie_powerup_fire_sale_time"] = 30;
}
