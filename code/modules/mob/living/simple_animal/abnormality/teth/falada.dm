//Coded by Coxswain
/mob/living/simple_animal/hostile/abnormality/falada
	name = "法拉达之魂"
	desc = "被砍下的马首."
	pixel_y = 64
	base_pixel_y = 64
	density = FALSE
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "falada"
	icon_living = "falada"
	portrait = "falada"
	faction = list("neutral")
	speak_emote = list("neighs")
	threat_level = TETH_LEVEL
	maxHealth = 55
	health = 55
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2) //goose stats
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 30,
		ABNORMALITY_WORK_INSIGHT = 30,
		ABNORMALITY_WORK_ATTACHMENT = 30,
		ABNORMALITY_WORK_REPRESSION = 30,
	)
	work_damage_upper = 3
	work_damage_lower = 2
	work_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/pride

	ego_list = list(
		/datum/ego_datum/weapon/zauberhorn,
		/datum/ego_datum/armor/zauberhorn,
	)
	gift_type =  /datum/ego_gifts/zauberhorn

	observation_prompt = "一个被斩下的马头高悬于墙上，啜泣着。<br>\
		你不禁对这生物心生怜悯。"
	observation_choices = list(
		"你怎么了?" = list(TRUE, "马头开始说话。<br>\
			\"呜呼哀哉，但愿如此——当权者本应让我替她一死。\"<br>\
			它的话语带着韵律，显然失去了重要之人。<br>\
			即便你无能为力，至少你在此倾听。"),
		"为什么拉长着脸?" = list(FALSE, "尽管你开了个蹩脚玩笑，马头仍在啜泣。<br>也许这不是最好的方式。"),
	)

	var/liked
	var/happy = TRUE
	pet_bonus = "neighs" //saves a few lines of code by allowing funpet() to be called by attack_hand()
	var/hint_cooldown
	var/hint_cooldown_time = 30 SECONDS
	var/list/cooldown = list("现在还不是时候。")

	var/list/instinct = list("我本该相信直觉，我本该在那邪恶女仆得逞前阻止她！看看我现在的样子！")

	var/list/insight = list("已故的公主极具洞察力，你若能如此，定有裨益。")

	var/list/attachment = list("可怜的阿妮朵丽，她对那女人的依恋太深，未能察觉其心中妒火。")

	var/list/repression = list("他们对我所做的一切，对她所做的一切，都不过是为了世间正义。")

// Work Mechanics
/mob/living/simple_animal/hostile/abnormality/falada/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/falada/ZeroQliphoth(mob/living/carbon/human/user)
	pissed()
	if(user)
		say("啊，阿妮朵丽，若你母亲知晓你的命运，她的心将会碎成两半.")
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/falada/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_MINING)
		pissed()
		qdel(src)

/mob/living/simple_animal/hostile/abnormality/falada/WorkChance(mob/living/carbon/human/user, chance)
	if(happy)
		chance+=30
	return chance

/mob/living/simple_animal/hostile/abnormality/falada/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type == liked || !liked)
		happy = TRUE
	else
		happy = FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/falada/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	liked = pick(
		ABNORMALITY_WORK_INSTINCT,
		ABNORMALITY_WORK_INSIGHT,
		ABNORMALITY_WORK_ATTACHMENT,
		ABNORMALITY_WORK_REPRESSION,
	)
	switch(liked)
		if(ABNORMALITY_WORK_INSTINCT)
			say(pick(instinct))
		if(ABNORMALITY_WORK_INSIGHT)
			say(pick(insight))
		if(ABNORMALITY_WORK_ATTACHMENT)
			say(pick(attachment))
		if(ABNORMALITY_WORK_REPRESSION)
			say(pick(repression))

// Breach
/mob/living/simple_animal/hostile/abnormality/falada/proc/pissed()
	var/turf/W = pick(GLOB.department_centers)
	for(var/turf/T in orange(1, W))
		new /obj/effect/temp_visual/dir_setting/cult/phase
		new /mob/living/simple_animal/hostile/retaliate/goose/falada(T)

// Repeat lines
/mob/living/simple_animal/hostile/abnormality/falada/funpet()
	if(!liked)
		return
	if(hint_cooldown > world.time)
		say(pick(cooldown))
		return
	hint_cooldown = world.time + hint_cooldown_time
	switch(liked)
		if(ABNORMALITY_WORK_INSTINCT)
			say(pick(instinct))
		if(ABNORMALITY_WORK_INSIGHT)
			say(pick(insight))
		if(ABNORMALITY_WORK_ATTACHMENT)
			say(pick(attachment))
		if(ABNORMALITY_WORK_REPRESSION)
			say(pick(attachment))
	return

// Spawned Mob
/mob/living/simple_animal/hostile/retaliate/goose/falada
	maxHealth = 40
	health = 40
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	faction = list("goose") //geese are demons
	attack_same = FALSE
	melee_damage_lower = 1
	melee_damage_upper = 3
	can_patrol = TRUE

/mob/living/simple_animal/hostile/retaliate/goose/falada/handle_automated_action()
	if(AIStatus == AI_OFF)
		return FALSE
	var/list/possible_targets = ListTargets() //we look around for potential targets and make it a list for later use.
	if(environment_smash)
		EscapeConfinement()
	if(AICanContinue(possible_targets))
		if(!QDELETED(target) && !targets_from.Adjacent(target))
			DestroyPathToTarget()
		if(!MoveToTarget(possible_targets))     //if we lose our target
			if(AIShouldSleep(possible_targets))	// we try to acquire a new one
				toggle_ai(AI_IDLE)			// otherwise we go idle
	return 1

/mob/living/simple_animal/hostile/retaliate/goose/falada/Found(atom/A)//This is here as a potential override to pick a specific target if available
	return
