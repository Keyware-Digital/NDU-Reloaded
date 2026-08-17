#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include maps\_hud_util;

init()
{
    level.reviveUsesLeft = level.zombie_vars[ "quick_revive_solo_max_times" ];
    level.is_solo_revive_distraction_active = false;
    level.zombiegoto = undefined;

    // Solo revive prerequisite: create the pathable distraction point on map start
    if ( !isDefined( level.zombiegoto ) )
    {
        zombiegotolocations = GetStructArray( "zombiegoto", "targetname" );
        
        if ( zombiegotolocations.size > 0 )
        {
            zombiegotolocations = array_randomize( zombiegotolocations );
            level.zombiegoto = zombiegotolocations[0];
        }
        else
        {
            spawn_points = GetStructArray( "initial_spawn_points", "targetname" );
            if ( spawn_points.size > 0 )
            {
                spawn_points = array_randomize( spawn_points );
                level.zombiegoto = spawn_points[0];
            }
            else if ( isDefined( level.exterior_goals ) && level.exterior_goals.size > 0 )
            {
                level.zombiegoto = level.exterior_goals[ RandomInt( level.exterior_goals.size ) ];
            }
        }
    }

    if ( isDefined( level.zombiegoto ) )
    {
        level.zombiegoto create_zombie_point_of_interest( 2500, 128, 10000, true );
        level.zombiegoto.attract_to_origin = false;
        level.zombiegoto.poi_active = false;
    }
}

// NDR heavily reworked solo revive function, previously inspired by Gympie's and Numan's
solo_quickrevive() 
{
    self endon( "disconnect" );
    self endon( "death" );

    // Already in a solo revive or no uses left → just die
    if ( isDefined( self.inSoloRevive ) || level.reviveUsesLeft <= 0 )
    {
        return;
    }

    self.inSoloRevive = true;
    level.is_solo_revive_distraction_active = true;

    // Pull zombies away from user
    if ( isDefined( level.zombiegoto ) )
    {
        level.zombiegoto.poi_active = true;
        level.zombiegoto.attract_to_origin = false;
    }

    // Force every living zombie to drop current target
    zombies = GetAiArray( "axis" );
    for ( i = 0; i < zombies.size; i++ )
    {
        if ( !isDefined( zombies[i] ) || !IsAlive( zombies[i] ) )
            continue;

        zombies[i] notify( "zombie_acquire_enemy" );
        zombies[i].favoriteenemy = undefined;
        zombies[i].ignore_player = undefined;
        zombies[i].ignoreall = true;
    }

    // Save state
    self.firstPistol = level.player_specific_add_weapon[maps\_zombiemode_weapons::get_player_index(self)];
    self.currentWeapon = self GetCurrentWeapon();
    self.currentStance = self GetStance();
    clipAmmo = [];
    weaponAmmo = [];
    lastStandAmmo = undefined;
    lastStandGun = undefined;
    lastStandClip = undefined;

    // Save weapons and ammo
    playerweapons = self GetWeaponsList();
    for (i = 0; i < playerweapons.size; i++) {
        clipAmmo[i] = self GetWeaponAmmoClip(playerweapons[i]);
        weaponAmmo[i] = self GetWeaponAmmoStock(playerweapons[i]);
        wait 0.05;
    }

    // Handle muleLastWeapon after saving ammo (may not need this)
    /*if (isDefined(self.muleLastWeapon)) {
        // Don't take muleLastWeapon here; let restoration handle it
    }*/

    if (self IsThrowingGrenade()) {
        self FreezeControls(true); // literally just to throw player's current grenade if they're stupid enough to play hot potato
        wait 0.05;
        self FreezeControls(false);
    }
    // start zombies targeting spawn struct instead. Rest is changed in zombiemode_spawner find_flesh() because we have to overwrite regular targeting.
    self.ignoreme = true;

    // put player in prone for now
    self AllowSprint(false);
    self AllowStand(false);
    self AllowCrouch(false);
    self SetStance("prone");

    self VisionSetNaked("laststand", 1);
    // if player has better downed gun, give it and check for ammo, then return it later
    self DisableWeaponCycling();

    // Last stand pistol
    lastStandGun   = "zombie_colt_upgraded";
    lastStandClip  = 8;
    lastStandAmmo  = 24;

    self TakeAllWeapons();
    self GiveWeapon(lastStandGun);
    self SwitchToWeapon(lastStandGun);
    self SetWeaponAmmoClip(lastStandGun, lastStandClip);
    self SetWeaponAmmoStock(lastStandGun, lastStandAmmo);

    // ===== PROGRESS BAR =====
    soloReviveTime = 10;

    // Kill any leftovers
    if ( isDefined( self.soloReviveProgressBar ) )
    {
        self.soloReviveProgressBar destroyElem();
        self.soloReviveProgressBar = undefined;
    }
    if ( isDefined( self.reviveProgressBar ) )
    {
        self.reviveProgressBar destroyElem();
        self.reviveProgressBar = undefined;
    }

    self.soloReviveProgressBar = self createPrimaryProgressBar();

    // Parent (background)
    self.soloReviveProgressBar.alignX = "center";
    self.soloReviveProgressBar.alignY = "middle";
    self.soloReviveProgressBar.horzAlign = "center";
    self.soloReviveProgressBar.vertAlign = "bottom";
    self.soloReviveProgressBar.x = 0;
    self.soloReviveProgressBar.y = -150;

    // Fill
    if ( isDefined( self.soloReviveProgressBar.bar ) )
    {
        self.soloReviveProgressBar.bar.alignX = "left";
        self.soloReviveProgressBar.bar.alignY = "middle";
        self.soloReviveProgressBar.bar.horzAlign = "center";
        self.soloReviveProgressBar.bar.vertAlign = "bottom";
        self.soloReviveProgressBar.bar.x = -60;
        self.soloReviveProgressBar.bar.y = -150;
    }

    self.soloReviveProgressBar updateBar( 0.01, 1 / soloReviveTime );

    // wait for revive and play text
    self.revive_hud setText( &"GAME_REVIVING" );
    self maps\_laststand::revive_hud_show();
    self.revive_hud.alignX = "center";
    self.revive_hud.alignY = "middle";
    self.revive_hud.horzAlign = "center";
    self.revive_hud.vertAlign = "bottom";
    self.revive_hud.x = 0;
    self.revive_hud.y = -175;

    wait( soloReviveTime );

    if ( isDefined( self.soloReviveProgressBar ) )
    {
        self.soloReviveProgressBar destroyElem();
        self.soloReviveProgressBar = undefined;
    }
    if ( isDefined( self.revive_hud ) )
        self maps\_laststand::revive_hud_hide();

    // Initialize muleCount if not set
    if ( !isDefined( self.muleCount ) )
    {
        if ( !self HasPerk( "specialty_extraammo" ) )
            self.muleCount = level.zombie_vars[ "mulekick_min_weapon_slots" ];
        else
            self.muleCount = level.zombie_vars[ "mulekick_max_weapon_slots" ];
    }

    // Restore weapons
    if ( self.currentWeapon != lastStandGun )
        self TakeAllWeapons();

    restoredWeapons = 0;
    for (i = 0; i < playerweapons.size; i++) {
        if (!isDefined(playerweapons[i])) {
            continue;
        }
        if (weaponType(playerweapons[i]) == "grenade") {
            self GiveWeapon(playerweapons[i]);
            if (isDefined(clipAmmo[i])) {
                self SetWeaponAmmoClip(playerweapons[i], clipAmmo[i]);
            }
        } else if (restoredWeapons < self.muleCount) {
            //IPrintLn(playerweapons[i]);
            self GiveWeapon(playerweapons[i]);
            if (isDefined(clipAmmo[i])) {
                self SetWeaponAmmoClip(playerweapons[i], clipAmmo[i]);
            } else {
            }
            if (isDefined(weaponAmmo[i])) {
                self SetWeaponAmmoStock(playerweapons[i], weaponAmmo[i]);
            } else {
            }
            restoredWeapons++;
        }
        wait 0.05;
    }

    // Try original weapon first
    self SwitchToWeapon(self.currentWeapon);

    // guarantee a real weapon is equipped after revive
    wait 0.1;
    curr = self GetCurrentWeapon();
    if ( curr == "none" || curr == "" || !self HasWeapon( curr ) )
    {
        primaries = self GetWeaponsListPrimaries();
        if ( primaries.size > 0 )
            self SwitchToWeapon( primaries[0] );
        else
        {
            all = self GetWeaponsList();
            if ( all.size > 0 )
                self SwitchToWeapon( all[0] );
        }
    }

    self EnableWeaponCycling();

    // Restore movement / vision
    self VisionSetNaked("zombie_bo3", 1);

    self AllowSprint(true);
    self AllowStand(true);
    self AllowCrouch(true);
    self SetStance("stand");
    self SetStance(self.currentStance);

    self.ignoreme = false;

    if ( !self HasPerk( "specialty_extraammo" ) )
    {
        self.muleLastWeapon = undefined;
    }

    // ===== USE COUNTER =====
    level.reviveUsesLeft--;

    if ( level.reviveUsesLeft <= 0 )
    {
        // Only show this when uses are actually gone
        self thread maps\_sounds::samantha_fail_sound();
        self iPrintLnBold( "No more Solo Revives remaining!" );
    }

    self.inSoloRevive = undefined;
    level.is_solo_revive_distraction_active = false;

    if ( isDefined( level.zombiegoto ) )
    {
        level.zombiegoto.poi_active = false;
    }

    // Wake the zombies up that were sent away
    zombies = GetAiArray( "axis" );
    for ( i = 0; i < zombies.size; i++ )
    {
        if ( !isDefined( zombies[i] ) || !IsAlive( zombies[i] ) )
            continue;

        zombies[i].ignoreall      = false;
        zombies[i].ignore_player = undefined;
        zombies[i].favoriteenemy = undefined;
        zombies[i] notify( "zombie_acquire_enemy" );
    }

    self notify( "player_revived" );
    self notify( "solo_revive_done" );
}