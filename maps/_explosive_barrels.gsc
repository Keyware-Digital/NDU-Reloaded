#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;

init_explosive_barrels()
{
	flag_wait("all_players_connected");

	explosive_barrels_entity = GetEntArray("explodable_barrel", "targetname");

    level.shot_explosive_barrels = 0;
    level.barrel_ee_started = 0;

    level.barrel_min_damage   = 25;
    level.barrel_max_damage   = 250;
    level.barrel_blast_radius = 225; // was 250

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
	while (1)
	{
        
        self waittill ("damage", amount, attacker, direction_vec, P, type);
            
        self endon ("death");

		level.shot_explosive_barrels++;
        //iPrintLn("barrel count: " + level.shot_explosive_barrels);

		players = GetPlayers();

			if (level.shot_explosive_barrels == 1 && level.barrel_ee_started == 0)
			{
				for (i = 0; i < players.size; i++) {
					level.barrel_ee_started = 1;
                    //iPrintLn("barrel ee started");
                    wait 1;
                }
            }

            if (level.shot_explosive_barrels == 31)
            {
                for (i = 0; i < players.size; i++) {
                    players[i] thread maps\_sounds::undone_ee_track_sound();
                    //iPrintLn("barrel ee song");
                    wait 1;
                }
            }

        self thread explodable_barrel_explode(attacker);
		break;
	}
}

explodable_barrel_explode(attacker)
{
    min_damage   = level.barrel_min_damage;
    max_damage   = level.barrel_max_damage;
    blast_radius = level.barrel_blast_radius;

	if( IsDefined( self.script_damage ) )
        max_damage = self.script_damage;

	if( IsDefined( self.radius ) )
        blast_radius = self.radius;

    if( !IsDefined(attacker) || !isplayer(attacker) )
        attacker = undefined;

    if( isplayer( attacker ) )
    {
        arcademode_assignpoints( "arcademode_score_explodableitem", attacker );
        //iPrintLn("barrel credit: " + attacker.playername);
    }

    // initial blast damage
    self radiusDamage(self.origin + (0,0,30), blast_radius, max_damage, min_damage, attacker);
    iPrintLn("barrel aoe applied");

    wait 0.05;

    self thread maps\_molotov::fire_burn_radius( attacker, 75, 15, 7.0 );
    //iPrintLn("barrel fire puddle started");
}
