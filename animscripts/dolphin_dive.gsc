#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include maps\_anim;

#using_animtree("animations");

is_sprinting() {
	v = self GetVelocity();
	if( v[0] >= 170 || v[1] >= 170 || v[0] <= 170 - 170 * 2 || v[1] <= 170 - 170 * 2 )
		return true;
	return false;
}

update_angles_origin(dive_model) {
    self endon("disconnect");
    while(isDefined(dive_model) && isDefined(self)) {
        dive_model.origin = self.origin;
        dive_model.angles = self.angles;
		wait 0.01;
	}
}

get_surface() {
	return self.origin[2];
}

fake_model_timed_delete(players_dolphin_dive) {
	wait(0.5);

	players_dolphin_dive Delete();

	self show();
}

setup_player_dolphin_dive() {
	self.is_diving = false;
	self.can_flop = false;
	dolphin_dive_anim_start = %zmb_player_dolphin_dive_prone;
	dolphin_dive_anim_land = %zmb_player_dolphin_dive_land;

	level.dirt_shader = "overlay_screen_dirt";

	level.dirt_fade_time = 0.35;
	level.dirt_time = 1;
	
	thread setup_dirt_overlay();
	
	while(1) {
		angles = self GetPlayerAngles();
		angles = (0,angles[1],0);

		self.oldSurface = self get_surface();

		minFall = level.zombie_vars[ "phd_minimum_fall" ];
                
		if( self getStance() == "crouch" && self is_sprinting() && self isOnGround() && !self IsMeleeing() && !self.is_diving && !self maps\_laststand::player_is_in_laststand() /*&& !self.being_revived*/ && !level.intermission /*&& !self.is_melee_galva*/) // commented out variables that don't exist yet (causes undefined errors)
		{
			self setStance("prone");
			
			run_velocity = self GetVelocity();

			self.is_diving = true;

			self setClientDvar("hide_reload_hud", 1);
			self setClientDvar("ammocounterhide", 1);
			current_weapon = self GetCurrentWeapon();
			players_dolphin_dive = spawn("script_model", self.origin);

            player_char = level.random_character_index[self.entity_num];

            switch(player_char) {
                case 0:
                    players_dolphin_dive setModel("char_usa_marine_player_wet_body2_1");
                    players_dolphin_dive.headModel = "char_usa_marine_head4_2";
                    players_dolphin_dive attach(players_dolphin_dive.headModel, "", true);
                    players_dolphin_dive.hatModel = "char_usa_marine_helm1";
                    players_dolphin_dive attach(players_dolphin_dive.hatModel);
                    players_dolphin_dive.gearModel = "char_usa_raider_gear4";
                    players_dolphin_dive attach(players_dolphin_dive.gearModel);
                    break;
                case 1:
                    players_dolphin_dive setModel("char_ger_hnrgd_player_body_hmg");
                    players_dolphin_dive.headModel = "char_ger_hnrgd_player_head_hmg";
                    players_dolphin_dive attach(players_dolphin_dive.headModel, "", true);
                    break;
                case 2:
                    players_dolphin_dive setModel("char_usa_marine_player_body2_1");
                    players_dolphin_dive.headModel = "char_usa_marine_head4_4";
                    players_dolphin_dive attach(players_dolphin_dive.headModel, "", true);
                    players_dolphin_dive.hatModel = "char_usa_raider_helm1";
                    players_dolphin_dive attach(players_dolphin_dive.hatModel);
                    players_dolphin_dive.gearModel = "char_usa_raider_gear3";
                    players_dolphin_dive attach(players_dolphin_dive.gearModel);
                    break;
                case 3:
                    players_dolphin_dive setModel("char_rus_guard_player_body_smg");
                    players_dolphin_dive.headModel = "char_rus_guard_player_head_smg";
                    players_dolphin_dive attach(players_dolphin_dive.headModel, "", true);
                    break;
			}

			players_dolphin_dive hide();
            weapon_model = GetWeaponModel(current_weapon);
			
            if(isDefined(weapon_model) && weapon_model != "") {
                players_dolphin_dive attach(weapon_model, "tag_weapon_right");
            }

            if(getdvar("cg_thirdperson") == "0") {
                players_dolphin_dive SetInvisibleToPlayer(self);
            }
            else if(getdvar("cg_thirdperson") == "1") {
                self SetInvisibleToPlayer(self);
			}

			self thread update_angles_origin(players_dolphin_dive);

			self thread maps\_sounds::dolphin_dive_launch_sound();

			players_dolphin_dive UseAnimTree( #animtree );
			players_dolphin_dive setAnim(dolphin_dive_anim_start);

			wait 0.05;
		
			self hide();

			players_dolphin_dive show();
			self AllowMelee(false);
			self AllowLean(false);
			self AllowADS(false);
			self AllowSprint(false);
			self AllowStand(false);
			self AllowCrouch(false);
			self DisableOffhandWeapons();
			self DisableWeaponCycling();
			self DisableWeapons();
			
			for(l = 0; l < 5; l++) {
				self SetVelocity((run_velocity * 1.3) + AnglesToUp(angles) * 400);
				wait 0.05;
			}
			self SetVelocity(AnglesToForward(angles) * 280);

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			wait 0.1;

			while( !self IsOnGround() ) {	
				if( self HasPerk("specialty_detectexplosive") && self GetVelocity()[2] <= -363)
					self.can_flop = true;

				wait 0.05;
			}

			players_dolphin_dive UseAnimTree(#animtree);
			players_dolphin_dive setAnim(dolphin_dive_anim_land);

			self thread maps\_sounds::dolphin_dive_land_sound();

			//BO1 STYLE SCREEN SHAKE ON DIVE LAND
			EarthQuake(RandomFloatRange(0.30, 0.40), 0.45, self.origin, 16);

			self thread player_dirt_overlay();

			PlayFXOnTag(level._effect[ "dive_dust" ], self, "j_spinelower");
			
			self SetVelocity(AnglesToForward(angles) * 450);

			//self setStance("prone");

			self SetVelocity((0, 0, 0));

			wait 0.05;

			self.newSurface = self get_surface() + 0.007;
			actualFall = self.oldSurface - self.newSurface;

			if (self HasPerk("specialty_detectexplosive") && self.oldSurface > self.newSurface && minFall < actualFall) {
					origin = self.origin;
					maps\_zombiemode_perk_think::phd_dive_damage(origin);
					self.oldSurface = self get_surface();
					//wait 0.2;	
			}

			if( self.can_flop ) {
				self.can_flop = false;
			}
			
			//wait 0.4;
			
			self setClientDvar("hide_reload_hud", 0);
			self setClientDvar("ammocounterhide", 0);
			self AllowMelee(true);
			self AllowLean(true);
			self AllowADS(true);
			self AllowSprint(true);
			self AllowStand(true);
			self AllowCrouch(true);
			self EnableOffhandWeapons();
			self EnableWeaponCycling();
			self EnableWeapons();

			self thread fake_model_timed_delete(players_dolphin_dive);

			self.is_diving = false;

			//origin = self GetEye() + (AnglesToForward(self GetPlayerAngles()) * 3.25);

			// Wait until the player stands up before allowing a new dive
            while( self getStance() != "stand" ) {
                wait 0.05;
            }
            // Short buffer to ensure dive cycle stability
            wait 0.05;

			if( self IsOnGround() ) {
				self.oldSurface = self get_surface();
			}

        }
	    wait 0.05;
	}
}

setup_dirt_overlay()
{	
	flag_wait( "all_players_connected" );
	players = GetPlayers();
	
	for( i = 0; i < players.size; i++ )
	{
		players[i].dirt_hud = create_simple_hud(players[i]);
		players[i].dirt_hud.x = 0; 
		players[i].dirt_hud.y = 0; 
		players[i].dirt_hud.horzAlign = "fullscreen"; 
		players[i].dirt_hud.vertAlign = "fullscreen"; 
		players[i].dirt_hud.foreground = true;
		players[i].dirt_hud.alpha = 0;
		players[i].dirt_hud SetShader( level.dirt_shader, 640, 480 );
		players[i].dirt_hud.sort = 1;
	}
}

player_dirt_overlay() {
	//notify and endon is needed to immediately repeat the overlay on dive instead of waiting for the dirt overlay to finish
	//use this trick to make player melee grunt sounds more responsive 
	self notify("active_dirt_overlay");
	self endon("active_dirt_overlay");

	self.dirt_hud setShader(level.dirt_shader, 640, 480);

	self.dirt_hud FadeOverTime(level.dirt_fade_time);

	self.dirt_hud.alpha = 0.75;

	wait( level.dirt_time );

	self.dirt_hud FadeOverTime(level.dirt_fade_time);

	self.dirt_hud.alpha = 0;
}
