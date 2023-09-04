#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

//Share points amongst players, deliberately doesn't carry over between games, BO2 style bank system requires 100 points to withdraw

init_share_points() {

    withdrawCost = 100;
	level.shared_points = 0;

    bank_deposit = spawn("script_model", (264, 671.5, 25));	//was (100, 188, 50));
	bank_deposit_trigger = spawn("trigger_radius", (bank_deposit.origin), 0, 32, 32);
	bank_deposit.angles = (0, -160, 0);		//weird angle to fit box better
	bank_deposit setModel("zmb_mdl_cash_register");
	bank_deposit solid();
	//we might want to hide these hintstrings to make it harder to find and look more like it was always in the map
    bank_deposit_trigger setHintString(&"PROTOTYPE_ZOMBIE_CASH_REGISTER_DEPOSIT"); 
	bank_deposit_trigger setCursorHint("HINT_NOICON");

    bank_withdraw = spawn("script_model", (-36, 1015, 50)); 	//was (-15, 188, 50));
	bank_withdraw_trigger = spawn("trigger_radius", (bank_withdraw.origin), 0, 32, 32);	
	bank_withdraw.angles = (0, -260, 0);
	bank_withdraw setModel("zmb_mdl_cash_register");
	bank_withdraw solid();
    bank_withdraw_trigger setHintString(&"PROTOTYPE_ZOMBIE_CASH_REGISTER_WITHDRAW", "&&1", withdrawCost);
	bank_withdraw_trigger setCursorHint("HINT_NOICON");

	thread points_deposit(bank_deposit, bank_deposit_trigger);
	thread points_withdraw(bank_withdraw, bank_withdraw_trigger, withdrawCost);
}

points_deposit(bank_deposit, bank_deposit_trigger) {

	while(1) {
		
        bank_deposit_trigger waittill("trigger", player);

	    if(is_player_valid(player) && player isTouching (bank_deposit_trigger) && player useButtonPressed() && player.score >= 1000) {
            bank_deposit maps\_sounds::cash_register_sound();
            player maps\_zombiemode_score::minus_to_player_score(1000);
            level.shared_points += 1000;
	    }
		else if (player isTouching (bank_deposit_trigger) && player useButtonPressed() && player.score < 1000) {
			//player thread maps\_sounds::no_money_sound();
			bank_deposit play_sound_on_ent("no_purchase");
		}

        wait (0.025);
    }
}

points_withdraw(bank_withdraw, bank_withdraw_trigger, withdrawCost) {

	while(1) {

        bank_withdraw_trigger waittill("trigger", player);

        if(is_player_valid(player) && player isTouching (bank_withdraw_trigger) && player useButtonPressed() && level.shared_points > 0 && player.score >= 100) {
            player maps\_zombiemode_score::minus_to_player_score(withdrawCost);
            bank_withdraw maps\_sounds::cash_register_sound();
            player maps\_zombiemode_score::add_to_player_score(1000);
           	level.shared_points -= 1000;
        }
       	else if (player isTouching (bank_withdraw_trigger) && player useButtonPressed() && level.shared_points < 1000) {
           	//player thread maps\_sounds::no_money_sound();
			bank_withdraw play_sound_on_ent("no_purchase");
        }
		else if (player isTouching (bank_withdraw_trigger) && player useButtonPressed() && player.score < 100) {
			//player thread maps\_sounds::no_money_sound();
			bank_withdraw play_sound_on_ent("no_purchase");
		}

        wait (0.025);
	}
}