#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

//TODO: Make it so the BO2 style bank system (carries over sessions) is shared among players

init_share_points()
{
    withdrawCost = -100;

    bank_withdraw = spawn("script_model", (-15, 188, 50));
	bank_withdraw_trigger = spawn("trigger_radius", (bank_withdraw.origin - (0, 0, 100)), 0, 64, 64);
	bank_withdraw.angles = (0, -90, 0);
	bank_withdraw setModel("zmb_mdl_cash_register");
	bank_withdraw solid();
    bank_withdraw_trigger setHintString(&"PROTOTYPE_ZOMBIE_CASH_REGISTER_WITHDRAW", "&&1", withdrawCost);
	bank_withdraw_trigger setCursorHint("HINT_NOICON");

    bank_deposit = spawn("script_model", (100, 188, 50));
	bank_deposit_trigger = spawn("trigger_radius", (bank_deposit.origin - (0, 0, 100)), 0, 64, 64);	//lower trigger box so you can actviate without opening stairs.
	bank_deposit.angles = (0, -90, 0);
	bank_deposit setModel("zmb_mdl_cash_register");
	bank_deposit solid();
    bank_deposit_trigger setHintString(&"PROTOTYPE_ZOMBIE_CASH_REGISTER_DEPOSIT"); 
	bank_deposit_trigger setCursorHint("HINT_NOICON");

    user = undefined;

	players = getPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i].stored_points = players[i] GetStat(3005);
		if (!(players[i].stored_points >= 0 || players[i].stored_points < 251))
		{
		    players[i].stored_points = 0;
		    players[i] SetStat(3005,players[i].stored_points);
		}
	}
	self thread points_withdraw(bank_withdraw, bank_withdraw_trigger, user, withdrawCost);
	self thread points_deposit(bank_deposit, bank_deposit_trigger, user);
}

points_withdraw(bank_withdraw, bank_withdraw_trigger, user, withdrawCost)
{
	while(1)
	{
        bank_withdraw_trigger waittill("trigger", user);
        if(is_player_valid(user) && user IsTouching (bank_withdraw_trigger) && user UseButtonPressed() && user.stored_points > 0 && user.score >= 100)
        {
            user maps\_zombiemode_score::add_to_player_score(withdrawCost);
            user playlocalsound("cha_ching");
            wait 0.1;
            user maps\_zombiemode_score::add_to_player_score(1000);
            user.stored_points -=1;
            user SetStat(3005, user.stored_points);
        }
        wait (1);
	}
}

points_deposit(bank_deposit, bank_deposit_trigger, user)
{
	while(1)
	{
        bank_deposit_trigger waittill("trigger", user);
	    if(is_player_valid(user) && user IsTouching (bank_deposit_trigger) && user UseButtonPressed() && user.score >= 1000 && user.stored_points < 250)
	    {
            user playlocalsound("cha_ching");
            user maps\_zombiemode_score::add_to_player_score( -1000 );
            user.stored_points +=1;
            user SetStat(3005, user.stored_points);
            wait 0.1;
	    }
        wait (1);
    }
}