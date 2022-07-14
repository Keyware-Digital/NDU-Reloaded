#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;

init()
{
	randomise_character_index();
	get_player_score_colours();
}

randomise_character_index()
{
	level.random_character_index = [];
	for( i = 0; i < 4; i++ )
	{
		level.random_character_index[ i ] = i;
	}
	level.random_character_index = array_randomize( level.random_character_index );
}

get_player_score_colours()
{
	level.character_colour = [];
	for( i = 0; i < 4; i++ )
	{
		level.character_colour[ i ] = GetDvar( "cg_ScoresColor_Gamertag_" + i);
	}
}
