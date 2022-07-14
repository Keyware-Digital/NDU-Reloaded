#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include maps\_anim;
#using_animtree("animations");

isSprinting()
{
	v = self GetVelocity();
	if( v[0] >= 170 || v[1] >= 170 || v[0] <= 170 - 170 * 2 || v[1] <= 170 - 170 * 2 )
		return true;
	return false;
}

update_angles_origin(players_dolphin_dive)
{
	while(isDefined(players_dolphin_dive))
	{
		players_dolphin_dive.origin = self.origin;
		players_dolphin_dive.angles = self.angles;
		wait 0.01;
	}
}

getSurface()
{
	return self.origin[2];
}

setup_player_dolphin_dive()
{

	self.is_diving = false;
	self.can_flop = false;
	dolphin_dive_anim_start = %zmb_player_dolphin_dive_action;
	dolphin_dive_anim_land = %zmb_player_dolphin_dive_land;
	
	while(1)
	{
		angles = self GetPlayerAngles();
		angles = (0,angles[1],0);

		self.oldSurface = self getSurface();

		minFall = level.zombie_vars[ "phd_minimum_fall" ];
                
		if( self getStance() == "crouch" && self isSprinting() && self isOnGround() && !self IsMeleeing() && !self maps\_laststand::player_is_in_laststand() /*&& !self.being_revived*/ && !level.intermission /*&& !self.is_melee_galva*/) // commented out variables that don't exist yet (causes undefined errors)
		{
			self setStance("prone");
			
			run_velocity = self GetVelocity();

			self.is_diving = true;

			self setClientDvar("hide_reload_hud", 1);
			self setClientDvar("ammocounterhide", 1);
			current_weapon = self GetCurrentWeapon();
			players_dolphin_dive = spawn("script_model", self.origin);

			players = GetPlayers();

			for (i = 0; i < players.size; i++) {

				switch(level.random_character_index[i])
				{
					case 0:
					players_dolphin_dive setModel("char_usa_marine_player_body2_1");
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
			}

			players_dolphin_dive hide();
			players_dolphin_dive attach(GetWeaponModel(current_weapon), "tag_weapon_right");
			if(getdvar("cg_thirdperson") == "0") {
				players_dolphin_dive setInVisibleToPlayer(self);
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
			
			for(l = 0; l < 5; l++)
			{
				self SetVelocity((run_velocity * 1.3) + AnglesToUp(angles) * 400);
				wait 0.05;
			}
			self SetVelocity(AnglesToForward(angles) * 280);

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			wait 0.1;

			while( !self IsOnGround() )
			{	
				if( self HasPerk("specialty_detectexplosive") && self GetVelocity()[2] <= -363)
					self.can_flop = true;

				wait 0.05;
			}
			self SetVelocity(AnglesToForward(angles) * 450);
			self setStance("prone");
			players_dolphin_dive UseAnimTree(#animtree);
			players_dolphin_dive setAnim(dolphin_dive_anim_land);

			self thread maps\_sounds::dolphin_dive_land_sound();

			wait 0.05;

			self.newSurface = self getSurface() + 0.007;
			actualFall = self.oldSurface - self.newSurface;

			if (self HasPerk("specialty_detectexplosive") && self.oldSurface > self.newSurface && minFall < actualFall)
			{
					origin = self.origin;
					maps\_zombiemode_perks::phd_dive_damage(origin);
					self.oldSurface = self getSurface();
					wait 0.2;	
			}

			if( self.can_flop )
			{
				self.can_flop = false;
			}
			
			wait 0.4;
			
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
			players_dolphin_dive Delete();
			self show();

			self.is_diving = false;

			if( self IsOnGround() )
			{
				self.oldSurface = self getSurface();
				//playfxOnTag(level._effect[ "dolphine_dive_land" ], self.origin + (0, 0, 50));
			}

        }
	    wait 0.05;
	}
}
