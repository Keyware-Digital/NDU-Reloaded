#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;

// Proof of concept, button easter egg from bo3 nacht possible

main()
{
    teddy = spawn("script_model", (-85, -480, 15));
	teddy.angles = (0, 45, 0);
	teddy setmodel("zombie_teddybear");

	collision = spawnCollision("collision_geo_32x32x32", "collider", teddy.origin, teddy.angles);
	collision LinkTo(teddy);

	collision PlayLoopSound("meteor_loop");
	/*collision SetCursorHint("HINT_NOICON");
 
	collision waittill("trigger", player);
 
	collision StopLoopSound();
	collision PlaySound("meteor_affirm");*/
}

// Ignore below, can use elements of the code for the button ee

/*
#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;

main()
{
	level.explosive_barrels = 0;
	level.barrel_count = 0;
	level.shot_explosive_barrels = 0;
	level.keep_explosive_barrels = [];
    thread explosive_barrels();
}

explosive_barrels()
{

	flag_wait("all_players_connected");

		all_explosive_barrels = GetEntArray("script_model","classname");

		for(i = 0; i < all_explosive_barrels.size; i++)
		{
			if(all_explosive_barrels[i].model == "global_explosive_barrel_japanese")
			{
				level.barrel_count++;
				level.keep_explosive_barrels = array_insert(level.keep_explosive_barrels,all_explosive_barrels[i],level.keep_explosive_barrels.size);
			}
			wait 0.05;
		}
		
		iPrintLn("There are " + level.barrel_count + " explosive barrels in this map.");
		
		array_thread(level.keep_explosive_barrels, ::explosive_barrels_think);
}

explosive_barrels_think()
{

	players = GetPlayers();

    while (1)
    {
        
		self waittill ("damage");
		
		for (i = 0; i < level.keep_explosive_barrels.size; i++)
		{
			self endon ("death");

			if (level.keep_explosive_barrels[i] == self)
			{
				level.shot_explosive_barrels++; // Increment the shot explosive_barrels counter
				break;
			}
		}

		iPrintLn("Explosive barrels shot: " + level.shot_explosive_barrels); // Print the updated shot explosive_barrels count

		if (level.shot_explosive_barrels == level.barrel_count) // Check if all explosive_barrels are shot
		{
			iPrintLn("DONE"); // Print "DONE" when all explosive_barrels are shot

        	for (k = 0; k < players.size; k++) {
			    iPrintLn("Playing ee track...");
                players[k] thread maps\_sounds::explosive_barrels_ee_track_sound();
			}
		}

		wait 1;
	}
}
*/