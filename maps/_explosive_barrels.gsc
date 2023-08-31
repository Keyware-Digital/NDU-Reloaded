#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;

init_explosive_barrels()
{
	flag_wait("all_players_connected");

	explosive_barrels_entity = GetEntArray("explodable_barrel", "targetname");

	level.shot_explosive_barrels = 0;
	level.barrel_ee_started = 0;

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
        
		self waittill ("damage");
			
		self endon ("death");

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
		
	}
}