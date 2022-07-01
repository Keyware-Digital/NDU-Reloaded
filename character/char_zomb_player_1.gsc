main()
{
self setModel("char_ger_hnrgd_player_body_hmg");
self.headModel = "char_ger_hnrgd_player_head_hmg";
self attach(self.headModel, "", true);
self.voice = "german";
}

precache()
{
precacheModel("char_ger_hnrgd_player_body_hmg");
precacheModel("char_ger_hnrgd_player_head_hmg");
}