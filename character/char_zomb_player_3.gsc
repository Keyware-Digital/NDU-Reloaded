 main()
{
self setModel("char_rus_guard_player_body_smg");
self.headModel = "char_rus_guard_player_head_smg";
self attach(self.headModel, "", true);
}

precache()
{
precacheModel("char_rus_guard_player_body_smg");
precacheModel("char_rus_guard_player_head_smg");

}
