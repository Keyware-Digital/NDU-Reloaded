main()
{
self setModel("char_ger_hnrgd_player_body_cqb");
self.headModel = "char_ger_hnrgd_player_head_cqb";
self attach(self.headModel, "", true);
}

precache()
{
precacheModel("char_ger_hnrgd_player_body_cqb");
precacheModel("char_ger_hnrgd_player_head_cqb");
}
