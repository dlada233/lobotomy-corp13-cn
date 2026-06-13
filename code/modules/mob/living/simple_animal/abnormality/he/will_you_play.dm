//I literally devised a whole new number system just for this abno - Kirie
/mob/living/simple_animal/hostile/abnormality/willyouplay
	name = "来玩吗？"
	desc = "一个抱着泰迪熊的小女孩."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "willyouplay"
	portrait = "will_you_play"
	maxHealth = 220
	health = 220
	threat_level = HE_LEVEL
	work_chances = list(
		"石头" = 60,
		"布" = 60,
		"剪刀" = 60,
	)
	work_damage_upper = 6
	work_damage_lower = 3
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/wrath
	max_boxes = 15
	can_spawn = FALSE // Does Nothing.

	ego_list = list(
		/datum/ego_datum/weapon/scissors,
		/datum/ego_datum/armor/scissors,
	)
	gift_type = /datum/ego_gifts/voodoo
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS
	var/janken = 0			//0 for scissors, 1 for Rock, 2 for paper
	var/player = 0			//0 for scissors, 1 for Rock, 2 for paper
	var/last_worked	//You get less if you just worked her.

//Randomizes work rate
/mob/living/simple_animal/hostile/abnormality/willyouplay/AttemptWork(mob/living/carbon/human/user, work_type)
	if(prob(70))
		janken = 0
	else
		janken = pick(1,2)
	if(user == last_worked)
		say("再一次? 很好，我们再玩一遍.")
	else
		say("我出剪刀，你呢？")
	return TRUE


//Losing is good, Lose means the player loses the game
//This uses a trinary number system that encodes two numbers as one. Janken is the first digit, and player is the second digit
//you're going to have to do a little decryption, but it goes like this. Take the first number (janken) and then add the second numberx3 (player)
//This gives you all 9 unique states
/mob/living/simple_animal/hostile/abnormality/willyouplay/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(pe == 0) //work fail
		Win(user, work_type)
		return
	switch(work_type)
		if("剪刀")
			player = 0
		if("石头")
			player = 1
		if("布")
			player = 2

	player*=3
	player += janken

	var/cheat_chance = FALSE
	//If you paid PE to the rep, you can cheat in this game.
	for(var/upgradecheck in GLOB.jcorp_upgrades)
		if(upgradecheck == "Abno Luck")
			cheat_chance = TRUE

	//Goes through every use case.
	//Ties, When both digits are the same.
	//Lose, when the player loses
	//Win, when the player wins
	switch(player)
		if(0, 4, 8)
			if(prob(10) && cheat_chance)
				Lose(user, work_type)
			else
				Tie(user, work_type)
		if(2, 5, 6)
			Lose(user, work_type)
		if(1, 3, 7)
			if(prob(10) && cheat_chance)
				Lose(user, work_type)
			else
				Win(user, work_type)
	..()

/mob/living/simple_animal/hostile/abnormality/willyouplay/proc/Tie(mob/living/carbon/human/user, work_type)
	if(janken == 0)
		SLEEP_CHECK_DEATH(20)
		say("平局，你以为我不会出剪刀吗？")
		SLEEP_CHECK_DEATH(20)
		say("我不和不信任我的人玩.")
	else
		say("嗯，平局. 你这次很幸运..")
	IncreaseStats(user, 1, FALSE)

//Player wins RPS, loses an arm tho
/mob/living/simple_animal/hostile/abnormality/willyouplay/proc/Win(mob/living/carbon/human/user, work_type)
	say("你输了.")
	user.deal_damage(20, RED_DAMAGE)
	IncreaseStats(user, 1, FALSE)

	//Less than 80 fort and you lose an arm
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) <= 60)
		if(HAS_TRAIT(user, TRAIT_NODISMEMBER))
			return
		var/obj/item/bodypart/arm = pick(user.get_bodypart(BODY_ZONE_R_ARM), user.get_bodypart(BODY_ZONE_L_ARM))

		var/did_the_thing = (arm?.dismember()) //not all limbs can be removed, so important to check that we did. the. thing.
		if(!did_the_thing)
			return

/mob/living/simple_animal/hostile/abnormality/willyouplay/proc/Lose(mob/living/carbon/human/user, work_type)
	var/statgain = 0
	if(user == last_worked)
		statgain = -2

	if(janken == 0)
		statgain += 4
		SLEEP_CHECK_DEATH(20)
		say("你赢了. 剪刀只对布有用")
		IncreaseStats(user, statgain, TRUE)


	else	//Big Air bonus for picking the funny rare one
		statgain += 7
		say("你赢了, 现在滚出去.")
		IncreaseStats(user, statgain, TRUE)

/mob/living/simple_animal/hostile/abnormality/willyouplay/proc/IncreaseStats(mob/living/carbon/human/user, statgain, check_melt = FALSE)
	var/list/attribute_list = list(FORTITUDE_ATTRIBUTE, PRUDENCE_ATTRIBUTE, TEMPERANCE_ATTRIBUTE, JUSTICE_ATTRIBUTE)
	for(var/A in attribute_list)
		var/processing = get_raw_level(user, A)
		if(processing > 80)
			if(check_melt == TRUE && datum_reference.console.meltdown)
				user.adjust_attribute_level(A, 1)
			continue
		user.adjust_attribute_level(A, statgain)
	last_worked = user
