#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include maps\_zombiemode_powerups;

init_radio()
{
	// radio spark
	level._effect["broken_radio_spark"] = LoadFx( "env/electrical/fx_elec_short_oneshot" );

	// kzmb, for all the latest killer hits
	radios = getentarray("kzmb","targetname");
	
	// no radios, return
	if (!isDefined(radios) || !radios.size)
	{
		return;
	}
	
	array_thread(radios, ::zombie_radio_play );
}

zombie_radio_play() //default to restore
{
	self transmittargetname();

	self setcandamage(true);
	
	while (1)
	{
		self waittill ("damage");

		println("changing radio stations");

		SetClientSysState("levelNotify","kzmb_next_song");

		wait(1.0);
	}
}