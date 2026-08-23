#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;

init_explosive_barrels()
{
	flag_wait("all_players_connected");

	explosive_barrels_entity = GetEntArray("explodable_barrel", "targetname");

    level.shot_explosive_barrels = 0;
    level.barrel_ee_started = 0;
    level.barrel_explosion_this_frame = false;
    level.barrel_explosion_last = [];

    level.barrel_min_damage   = 25;
    level.barrel_max_damage   = 250;
    level.barrel_blast_radius = 250;

	all_explosive_barrels = [];

	for(i = 0; i < explosive_barrels_entity.size; i++)
	{
		all_explosive_barrels = array_insert(all_explosive_barrels,explosive_barrels_entity[i],all_explosive_barrels.size);
		wait 0.05;
	}

	array_thread(all_explosive_barrels, ::explosive_barrels_think);
}

explosive_barrels_think(all_explosive_barrels)
{
	self setcandamage(true);
	self endon ("death");

	while (1)
	{
		self waittill ("damage", amount, attacker, direction_vec, P, type);

		if(type == "MOD_MELEE" || type == "MOD_IMPACT")
			continue;

		if( IsDefined( self.script_requires_player ) && self.script_requires_player && !IsPlayer( attacker ) )
			continue;

		if( IsDefined( self.script_selfisattacker ) && self.script_selfisattacker )
            self.damage_owner = self;
		else
            self.damage_owner = attacker;

		level.shot_explosive_barrels++;

		players = GetPlayers();

		if (level.shot_explosive_barrels == 1 && level.barrel_ee_started == 0)
		{
			for (i = 0; i < players.size; i++) {
				level.barrel_ee_started = 1;
				wait 1;
			}
		}

		if (level.shot_explosive_barrels == 31)
		{
			for (i = 0; i < players.size; i++) {
				players[i] thread maps\_sounds::undone_ee_track_sound();
				wait 1;
			}
		}

		self thread explodable_barrel_explode();
		break;
	}
}

explodable_barrel_explode()
{
	self notify ("exploding");
	self notify ("death");

	level.barrel_explosion_this_frame = true;

    min_damage   = level.barrel_min_damage;
    max_damage   = level.barrel_max_damage;
    blast_radius = level.barrel_blast_radius;

	if( IsDefined( self.script_damage ) )
        max_damage = self.script_damage;

	if( IsDefined( self.radius ) )
        blast_radius = self.radius;

	attacker = undefined;

    if(isdefined(self.damage_owner))
	{
        attacker = self.damage_owner;
		if( isplayer( attacker ) )
		{
			arcademode_assignpoints( "arcademode_score_explodableitem", attacker );
		}
	}

	level.barrel_explosion_last[ "time" ]   = getTime();
	level.barrel_explosion_last[ "origin" ] = self.origin + ( 0, 0, 30 );

    // initial blast damage
    self radiusDamage(self.origin + (0,0,30), blast_radius, max_damage, min_damage, attacker);

	wait 0.05;
	level.barrel_explosion_this_frame = false;

	if( !isplayer( attacker ) )
		attacker = undefined;

	self thread maps\_molotov::fire_burn_radius( attacker, level.barrel_fire_radius, level.barrel_fire_height, level.barrel_fire_duration );
}