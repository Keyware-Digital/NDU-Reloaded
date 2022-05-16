#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#using_animtree( "animations" );

setup_player_dolphin_dive()
{
	if (!level.zombie_vars[ "dolphin_dive" ])
	{
		return;
	}

	index = maps\_zombiemode_weapons::get_player_index(self);

	self.is_diving = false;
	self.can_flop = false;
	d2p_anim_start = %pb_dw_dive_prone;
	d2p_anim_land = %pb_dw_dive_prone_land;
	
	while(1)
	{
		angles = self GetPlayerAngles();
		angles = (0,angles[1],0);
                
		if( self getStance() == "crouch" && self isSprinting() && self isOnGround() && !self IsMeleeing() && !self maps\_laststand::player_is_in_laststand() && !self.being_revived && !level.intermission && !self.is_melee_galva)
		{
			self setStance("prone");
			
			run_velocity = self GetVelocity();
			rand = randomintrange(0, 8);
			self PlaySound("plr_" + index + "_vox_gen_exert_" + rand);
			self.is_diving = true;
			self setClientDvar("hide_reload_hud", 1);
			self setClientDvar("ammocounterhide", 1);
			current_weapon = self GetCurrentWeapon();
			players_d2p = spawn("script_model", self.origin);
			players_d2p setModel(self.model);
			players_d2p hide();
			players_d2p attach(GetWeaponModel(current_weapon), "tag_weapon_right");
			players_d2p setInVisibleToPlayer(self);
			self thread update_angles_origin(players_d2p);
			players_d2p UseAnimTree( #animtree );
			players_d2p setAnim(d2p_anim_start);

			wait .05;
		
			self hide();
			players_d2p show();
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
				wait .05;
			}
			self SetVelocity(AnglesToForward(angles) * 280);

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			wait .1;

			while( !self IsOnGround() )
			{	
				if( self HasPerk("specialty_detectexplosive") && self GetVelocity()[2] <= -363)
					self.can_flop = true;

				wait .05;
			}
			self SetVelocity(AnglesToForward(angles) * 450);
			self setStance("prone");
			players_d2p UseAnimTree( #animtree );
			players_d2p setAnim(d2p_anim_land);

			// self playSound("d2p_fall");
			// self playSound("d2p_slide");

			wait .05;

			if( self.can_flop )
			{
				self.can_flop = false;
				origin = self.origin;
				//maps\_zombiemode_perks_functions::phd_function_d2p_damage(origin);
			}
			
			wait .4;
			
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
			players_d2p delete();
			self show();
			self.is_diving = false;
        }
	    wait .05;
	}
}

isSprinting()
{
	v = self GetVelocity();
	if( v[0] >= 170 || v[1] >= 170 || v[0] <= 170 - 170 * 2 || v[1] <= 170 - 170 * 2 )
		return true;
	return false;
}

update_angles_origin(players_d2p)
{
	while(isDefined(players_d2p))
	{
		players_d2p.origin = self.origin;
		players_d2p.angles = self.angles;
		wait .01;
	}
}

phd_sounds(aliasname, num)
{
	rand = randomint(num);
	self playsound(aliasname + rand);
}