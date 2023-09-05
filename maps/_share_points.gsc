#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include maps\_hintstrings;

//Share points amongst players, deliberately doesn't carry over between games, BO2 style bank system requires 100 points to withdraw

init_share_points() {

    withdrawCost = 100;
	level.shared_points = 0;
	test = "Hold ^3&&1 ^7to deposit 1000 points";

	players = GetPlayers();

    bank_deposit = spawn("script_model", (264, 671.5, 25));	//was (100, 188, 50));
	bank_deposit_trigger = spawn("trigger_radius", (bank_deposit.origin), 0, 32, 32);
	bank_deposit.angles = (0, -160, 0);		//weird angle to fit box better
	bank_deposit setModel("zmb_mdl_cash_register");
	bank_deposit solid();
    bank_deposit_trigger _setHintString(test); // Would like to make this only appear when looking at the trigger but trigger_radius might make that impossible
	bank_deposit_trigger setCursorHint("HINT_NOICON");

    bank_withdraw = spawn("script_model", (-36, 1015, 50)); 	//was (-15, 188, 50));
	bank_withdraw_trigger = spawn("trigger_radius", (bank_withdraw.origin), 0, 32, 32);	
	bank_withdraw.angles = (0, -260, 0);
	bank_withdraw setModel("zmb_mdl_cash_register");
	bank_withdraw solid();
    bank_withdraw_trigger setHintString(&"PROTOTYPE_ZOMBIE_CASH_REGISTER_WITHDRAW", "&&1", withdrawCost); // Would like to make this only appear when looking at the trigger but trigger_radius might make that impossible
	bank_withdraw_trigger setCursorHint("HINT_NOICON");

	thread points_deposit(bank_deposit, bank_deposit_trigger, players);
	thread points_withdraw(bank_withdraw, bank_withdraw_trigger, withdrawCost, players);
}

points_deposit(bank_deposit, bank_deposit_trigger, players) {

	while(1) {
		
        bank_deposit_trigger waittill("trigger", player);

	    if(is_player_valid(player) && player isTouching (bank_deposit_trigger) && player useButtonPressed() && player.score >= 1000) {
            bank_deposit thread maps\_sounds::cash_register_sound(); // Threaded so the rest of the code doesn't wait for the sound to finish playing
			wait (0.5); // The delay between deposits
            player maps\_zombiemode_score::minus_to_player_score(1000);
            level.shared_points += 1000;
	    }
		else if (player isTouching (bank_deposit_trigger) && player useButtonPressed() && player.score < 1000) {
			for( i = 0; i < players.size; i++ ) {
				players[i] maps\_sounds::no_money_sound(); // Doesn't need threading as it doesn't interrupt deposits and you don't want to spam this sound
			}

			bank_deposit play_sound_on_ent("no_purchase"); // Doesn't need threading as it doesn't interrupt deposits and you don't want to spam this sound
		}

        wait (0.05); // Has nothing to do with the delay in deposits, this wait simply prevents the while loop from potentially crashing the game
    }
}

points_withdraw(bank_withdraw, bank_withdraw_trigger, withdrawCost, players) {

	while(1) {

        bank_withdraw_trigger waittill("trigger", player);

        if(is_player_valid(player) && player isTouching (bank_withdraw_trigger) && player useButtonPressed() && level.shared_points > 0 && player.score >= 100) {
            player maps\_zombiemode_score::minus_to_player_score(withdrawCost);
            bank_withdraw thread maps\_sounds::cash_register_sound(); // Threaded so the rest of the code doesn't wait for the sound to finish playing
			wait (0.5); // The delay between withdrawls
            player maps\_zombiemode_score::add_to_player_score(1000);
           	level.shared_points -= 1000;
        }
       	else if (player isTouching (bank_withdraw_trigger) && player useButtonPressed() && level.shared_points < 1000) {
			for( i = 0; i < players.size; i++ ) {
				players[i] maps\_sounds::no_money_sound(); // Doesn't need threading as it doesn't interrupt deposits and you don't want to spam this sound
			}

			bank_withdraw play_sound_on_ent("no_purchase"); // Doesn't need threading as it doesn't interrupt deposits and you don't want to spam this sound
        }
		else if (player isTouching (bank_withdraw_trigger) && player useButtonPressed() && player.score < 100) {
			for( i = 0; i < players.size; i++ ) {
				players[i] maps\_sounds::no_money_sound(); // Doesn't need threading as it doesn't interrupt deposits and you don't want to spam this sound
			}

			bank_withdraw play_sound_on_ent("no_purchase"); // Doesn't need threading as it doesn't interrupt deposits and you don't want to spam this sound
		}

        wait (0.05); // Has nothing to do with the delay in withdrawls, this wait simply prevents the while loop from potentially crashing the game
	}
}