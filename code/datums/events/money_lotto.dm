/datum/event/money_lotto
	id = "money_lotto"
	name = "Money Lotto"
	description = "With some chance, one of the crew members will be able to win the lottery"

	mtth = 2 HOURS
	fire_only_once = TRUE

/datum/event/money_lotto/get_mtth()
	. = ..()
	. -= (SSevents.triggers.living_players_count * (8 MINUTES))
	. = max(1 HOUR, .)

/datum/event/money_lotto/on_fire()
	var/winner_name = "John Smith"
	var/winner_sum = 0
	var/deposit_success = 0

	winner_sum = pick(5000, 10000, 50000, 100000, 500000, 1000000, 1500000)
	if(prob(50))
		if(all_money_accounts.len)
			var/datum/money_account/D = pick(all_money_accounts)
			winner_name = D.owner_name
			if(!D.suspended)
				var/datum/transaction/T = new("Nyx Daily Grand Slam -Stellar- Lottery", "Winner!", winner_sum, "Biesel TCD Terminal #[rand(111,333)]")
				D.do_transaction(T)
				deposit_success = 1

	else
		winner_name = random_name(pick(MALE,FEMALE), species = SPECIES_HUMAN)
		deposit_success = pick(0,1)

	var/author = "[GLOB.using_map.company_name] Editor"
	var/channel = "Nyx Daily"

	var/body = "Nyx Daily wishes to congratulate <b>[winner_name]</b> for recieving the Nyx Stellar Slam Lottery, and receiving the out of this world sum of [winner_sum] credits!"
	if(!deposit_success)
		body += "<br>Unfortunately, we were unable to verify the account details provided, so we were unable to transfer the money. In order to have your winnings re-sent, send a cheque containing a processing fee of 5000 credits to the ND 'Stellar Slam' office on the Nyx gateway with your updated details."

	news_network.SubmitArticle(body, author, channel, null, 1)
