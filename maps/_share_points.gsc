#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

//Share points amongst players, deliberately doesn't carry over between games, BO2 style bank system requires 100 points to withdraw.

init_share_points() {
    withdrawCost = 100;
	level.shared_points = 0;

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

	thread points_withdraw(bank_withdraw, bank_withdraw_trigger, withdrawCost);
	thread points_deposit(bank_deposit, bank_deposit_trigger);
}

points_withdraw(bank_withdraw, bank_withdraw_trigger, withdrawCost) {
	while(1) {
        bank_withdraw_trigger waittill("trigger", player);

        if(is_player_valid(player) && player IsTouching (bank_withdraw_trigger) && player UseButtonPressed() && level.shared_points > 0 && player.score >= 100) {
            player maps\_zombiemode_score::minus_to_player_score(withdrawCost);
            player playlocalsound("cha_ching");
            wait 0.1;
            player maps\_zombiemode_score::add_to_player_score(1000);
           	level.shared_points -= 1000;
        }
       	else if (level.shared_points < 1000) {
            player playLocalSound("no_money");
        }
		else if (player.score < 100) {
			player playLocalSound("no_money");
		}

        wait (1);
	}
}

points_deposit(bank_deposit, bank_deposit_trigger) {
	while(1) {
        bank_deposit_trigger waittill("trigger", player);

	    if(is_player_valid(player) && player IsTouching (bank_deposit_trigger) && player UseButtonPressed() && player.score >= 1000) {
            player playLocalSound("cha_ching");
            player maps\_zombiemode_score::minus_to_player_score(1000);
            level.shared_points += 1000;
	    }
		else {
			player playLocalSound("no_money");

		}
        wait (1);
    }
}