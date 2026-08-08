#include clientscripts\_utility;

init() {
	level thread player_init();
	level thread fov_monitor();
}

player_init() {
	waitforclient(0);
}

fov_monitor() {
	for(;;)
	{
		level waittill ("set_client_fov");
        setClientDvar("cg_fov", getDvar("ui_cg_fov"));
	}
}
