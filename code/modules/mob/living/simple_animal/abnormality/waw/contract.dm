//Coded by me, Kirie Saito!

//Remind me to give it contract features later.....
/mob/living/simple_animal/hostile/abnormality/contract
	name = "一份合同，已签署"
	desc = "一个脑袋火红的男人坐在桌子后面."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "firstfold"
	portrait = "contract"
	maxHealth = 1000
	health = 1000
	threat_level = WAW_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 35, 45, 55),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 35, 45, 55),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 35, 45, 55),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 35, 45, 55),
	)
	pixel_x = -16
	base_pixel_x = -16
	start_qliphoth = 2
	work_damage_upper = 8
	work_damage_lower = 4
	work_damage_type = PALE_DAMAGE	//Lawyers take your fucking soul
	chem_type = /datum/reagent/abnormality/sin/lust
	can_spawn = FALSE // Useless slop abno.

	ego_list = list(
		/datum/ego_datum/weapon/infinity,
		/datum/ego_datum/armor/infinity,
	)
	gift_type = /datum/ego_gifts/infinity

	observation_prompt = "你面前坐着一位头部燃烧的男子。<br>\
		桌面上摆着份异常显眼的文件。<br>\
		\"根据协议，签署方可获得一份E.G.O.礼物。\"<br>\
		\"只需在此处签名。\"<br>\
		文件上字迹混乱难以辨认。<br>\
		一支钢笔凭空出现在你手中。<br>\
		对方似乎正失去耐心。<br>你要签名吗？"
	observation_choices = list(
		"不签字" = list(TRUE, "你仔细查看合同<br>\
			发现一行小字条款<br>\
			\"签署后灵魂归合同所有方\"<br>\
		拒绝后男子叹息着递上新合同。<br>\
		这份合同看似合法，你最终签了名。"),
		"签署合同" = list(FALSE, "你匆忙签下合同。<br>\
			片刻后感到灵魂缺失了一块。<br>\
			<br>\
			你恍惚离开，全然忘记合同内容。<br>\
			或许本该看清那些小字。"),
	)

	var/list/total_havers = list()
	var/list/fort_havers = list()
	var/list/prud_havers = list()
	var/list/temp_havers = list()
	var/list/just_havers = list()
	var/list/spawnables = list()
	var/total_per_contract = 4
	var/breaching
	var/summon_count = 0
	var/summon_cooldown
	var/summon_cooldown_time = 60 SECONDS

/mob/living/simple_animal/hostile/abnormality/contract/Initialize()
	. = ..()
	//We need a list of all abnormalities that are TETH to HE level and Can breach.
	var/list/queue = subtypesof(/mob/living/simple_animal/hostile/abnormality)
	for(var/i in queue)
		var/mob/living/simple_animal/hostile/abnormality/abno = i
		if(!(initial(abno.can_spawn)) || !(initial(abno.can_breach)))
			continue

		if((initial(abno.threat_level)) <= WAW_LEVEL)
			spawnables += abno

/mob/living/simple_animal/hostile/abnormality/contract/Life()
	. = ..()
	if(!breaching)
		return
	if(summon_count > 4)
		return
	if((summon_cooldown < world.time) && !(status_flags & GODMODE))
		Summon()
		summon_cooldown = world.time + summon_cooldown_time

/mob/living/simple_animal/hostile/abnormality/contract/WorkChance(mob/living/carbon/human/user, chance, work_type)
	. = chance
	if(!(user in total_havers))
		return

	if(ContractedUser(user, work_type))
		. *= 0.5

	return

/mob/living/simple_animal/hostile/abnormality/contract/AttemptWork(mob/living/carbon/human/user, work_type)
	work_damage_upper = initial(work_damage_upper)
	work_damage_lower = initial(work_damage_lower)
	if(ContractedUser(user, work_type) && .)
		work_damage_upper *= 0.3
		work_damage_lower *= 0.3
	if(user in total_havers)
		work_damage_upper *= 0.8
		work_damage_lower *= 0.8
		say("对的，对的，我记得这份合同.")

	. = ..()
	return

/mob/living/simple_animal/hostile/abnormality/contract/proc/ContractedUser(mob/living/carbon/human/user, work_type)
	. = FALSE
	if(!(user in total_havers))
		return

	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			if(user in fort_havers)
				return TRUE

		if(ABNORMALITY_WORK_INSIGHT)
			if(user in prud_havers)
				return TRUE

		if(ABNORMALITY_WORK_ATTACHMENT)
			if(user in temp_havers)
				return TRUE

		if(ABNORMALITY_WORK_REPRESSION)
			if(user in just_havers)
				return TRUE

/mob/living/simple_animal/hostile/abnormality/contract/proc/NewContract(mob/living/carbon/human/user, work_type)
	if((user in total_havers))
		return
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			if(fort_havers.len < total_per_contract)
				user.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, (fort_havers.len - 4)*-1 )
				fort_havers |= user
			else
				return

		if(ABNORMALITY_WORK_INSIGHT)
			if(prud_havers.len < total_per_contract)
				user.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, (prud_havers.len - 4)*-1 )
				prud_havers |= user
			else
				return

		if(ABNORMALITY_WORK_ATTACHMENT)
			if(temp_havers.len < total_per_contract)
				user.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, (temp_havers.len - 4)*-1 )
				temp_havers |= user
			else
				return

		if(ABNORMALITY_WORK_REPRESSION)
			if(just_havers.len < total_per_contract)
				user.adjust_attribute_buff(JUSTICE_ATTRIBUTE, (just_havers.len - 4)*-1 )
				just_havers |= user
			else
				return

	total_havers |= user
	say("就在虚线处签名...其余的就交给我处理.")
	return


//Meltdown
/mob/living/simple_animal/hostile/abnormality/contract/ZeroQliphoth(mob/living/carbon/human/user)
	Summon()
	datum_reference.qliphoth_change(2)

/mob/living/simple_animal/hostile/abnormality/contract/BreachEffect(mob/living/carbon/human/user, breach_type)//causes a runtime
	if(breach_type == BREACH_MINING)
		breaching = TRUE
	..()

/mob/living/simple_animal/hostile/abnormality/contract/proc/Summon(mob/living/carbon/human/user)
	// Don't need to lazylen this. If this is empty there is a SERIOUS PROBLEM.
	var/mob/living/simple_animal/hostile/abnormality/spawning = pick(spawnables)
	var/mob/living/simple_animal/hostile/abnormality/spawned = new spawning(get_turf(src))
	spawned.BreachEffect()
	spawned.color = "#000000"	//Make it black to look cool
	spawned.name = "???"
	spawned.desc = "这是什么东西?"
	spawned.faction = list("hostile")
	spawned.core_enabled = FALSE
	summon_count += 1

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/contract/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	NewContract(user, work_type)

/mob/living/simple_animal/hostile/abnormality/contract/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	work_damage_upper = initial(work_damage_upper)
	work_damage_lower = initial(work_damage_lower)
	return

/mob/living/simple_animal/hostile/abnormality/contract/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	NewContract(user, work_type)
	if(prob(20))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/contract/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return
