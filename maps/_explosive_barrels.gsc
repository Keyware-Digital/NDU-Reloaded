#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;

init_explosive_barrels()
{
	flag_wait("all_players_connected");

	explosive_barrels_entity = GetEntArray("explodable_barrel", "targetname");

	level.shot_explosive_barrels = 0;
	level.sam_ee_vox_sound_done = 0;

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

		for (i = 0; i < players.size; i++) {

			if (level.shot_explosive_barrels == 1 && level.sam_ee_vox_sound_done == 0)
			{
				players[i] thread maps\_sounds::sam_start_ee_vox_sound();	
				level.sam_ee_vox_sound_done = 1;
			}

			if (level.shot_explosive_barrels == 31)
			{
				players[i] thread maps\_sounds::explosive_barrels_ee_track_sound();
			}
		wait 1;
		}
	}
}