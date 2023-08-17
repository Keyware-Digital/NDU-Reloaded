#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;

main()
{
	level.barrels = 0;
	level.barrel_count = 0;
	level.shot_barrels = 0;
	level.keep_barrels = [];
    thread barrels();
}

barrels()
{

	flag_wait("all_players_connected");

		all_barrels = GetEntArray("script_model","classname");

		for(i = 0; i < all_barrels.size; i++)
		{
			if(all_barrels[i].model == "global_explosive_barrel_japanese")
			{
				level.barrel_count++;
				level.keep_barrels = array_insert(level.keep_barrels,all_barrels[i],level.keep_barrels.size);
			}
			wait 0.05;
		}
		
		iPrintLn("There are " + level.barrel_count + " explosive barrels in this map.");
		
		array_thread(level.keep_barrels, ::barrels_think);
}

barrels_think()
{

	players = GetPlayers();

    while (1)
    {
        
		self waittill ("damage");
		
		for (i = 0; i < level.keep_barrels.size; i++)
		{
			self endon ("death");

			if (level.keep_barrels[i] == self)
			{
				level.shot_barrels++; // Increment the shot barrels counter
				break;
			}
		}

		iPrintLn("Barrels shot: " + level.shot_barrels); // Print the updated shot barrels count

		if (level.shot_barrels == level.barrel_count) // Check if all barrels are shot
		{
			iPrintLn("DONE"); // Print "DONE" when all barrels are shot

        	for (k = 0; k < players.size; k++) {
			    iPrintLn("Playing ee track...");
                players[k] thread maps\_sounds::barrel_ee_track_sound();
			}
		}

		wait 1;
	}
}