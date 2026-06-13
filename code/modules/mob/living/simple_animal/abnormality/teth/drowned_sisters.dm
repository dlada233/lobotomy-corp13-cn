//She tells stories, and does sanity damage. What can I say?
/mob/living/simple_animal/hostile/abnormality/drownedsisters
	name = "溺毙姐妹"
	desc = "一对女孩被遮住脸."
	icon = 'ModularTegustation/Teguicons/96x64.dmi'
	icon_state = "sisters"
	portrait = "drowned_sisters"
	maxHealth = 230
	health = 230
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 50,
		ABNORMALITY_WORK_INSIGHT = 65,
		ABNORMALITY_WORK_ATTACHMENT = 50,
		ABNORMALITY_WORK_REPRESSION = 20,
	)
	start_qliphoth = 3
	work_damage_upper = 5 //Calculated later
	work_damage_lower = 2
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gloom
	pixel_x = -32
	base_pixel_x = -32

	ego_list = list(
		/datum/ego_datum/weapon/sorority,
		/datum/ego_datum/armor/sorority,
	)
	gift_type =  /datum/ego_gifts/sorority
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	observation_prompt = "你盘坐于异想体前，繁花掩去其面容与神情. <br>\
		\"哀哉吾等，已成罪人，请聆听，聆听这未知之罪，宽恕吾等悲恸...\""
	observation_choices = list(
		"听她们的故事" = list(TRUE, "你走出收容单元，她们的故事随风消散，只留下悲怆. <br>\
			将来你还会再来，但永远也无法解开她们哀伤."),
		"不要听故事" = list(TRUE, "你走出收容单元，她们的故事随风消散，只留下悲怆. <br>\
			将来你还会再来，但永远也无法解开她们哀伤."),
	)

	var/breaching = FALSE

//Work Mechanics
//Deals scaling work damage based off your stats.
/mob/living/simple_animal/hostile/abnormality/drownedsisters/AttemptWork(mob/living/carbon/human/user, work_type)
	if(breaching)
		return FALSE
	work_damage_upper = (get_attribute_level(user, PRUDENCE_ATTRIBUTE) -60) * -0.2
	work_damage_upper = max(3, work_damage_upper)	//So you don't get healing
	work_damage_lower = (get_attribute_level(user, PRUDENCE_ATTRIBUTE) -60) * -0.1
	work_damage_lower = max(1, work_damage_lower)	//So you don't get healing
	return ..()

/mob/living/simple_animal/hostile/abnormality/drownedsisters/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
// okay so according to the lore you're not really supposed to remember the stories she says so we're going to make it so your sanity goes back up
	if(!user.sanity_lost && pe != 0)
		user.adjustSanityLoss(-get_attribute_level(user, PRUDENCE_ATTRIBUTE))
	..()
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			datum_reference.qliphoth_change(-1)
		if(ABNORMALITY_WORK_ATTACHMENT)
			if(datum_reference.qliphoth_meter == 3)
				FloodRoom()
			else
				datum_reference.qliphoth_change(1)
	return

//Breaches
/mob/living/simple_animal/hostile/abnormality/drownedsisters/ZeroQliphoth(mob/living/carbon/human/user)
	datum_reference.qliphoth_change(3)
	if(!user)
		return
	to_chat(user, span_userdanger("你被一个看不见的攻击者攻击了!"))
	playsound(get_turf(src), 'sound/abnormalities/jangsan/tigerbite.ogg', 75, 0)
	user.deal_damage(50, RED_DAMAGE, null)
	if(user.health < 0 || user.stat == DEAD)
		user.gib()
	return

/mob/living/simple_animal/hostile/abnormality/drownedsisters/proc/FloodRoom() //Qliphoth Went over max
	breaching = TRUE
	for(var/turf/open/T in view(7, src))
		new /obj/effect/temp_visual/water_waves(T)
	playsound(get_turf(src), 'sound/abnormalities/piscinemermaid/waterjump.ogg', 75, 0)
	var/list/teleport_potential = list()
	for(var/turf/T in GLOB.department_centers)
		teleport_potential += T
	if(!LAZYLEN(teleport_potential))
		return
	for(var/mob/living/carbon/human/H in view(7, src))
		if(!H.sanity_lost)
			var/turf/teleport_target = pick(teleport_potential)
			TeleportPerson(H, teleport_target)
		else
			QDEL_NULL(H.ai_controller) //If they panicked, they just drown
			H.adjustOxyLoss(200)
	sleep(5 SECONDS)
	datum_reference.qliphoth_change(3)
	breaching = FALSE

/mob/living/simple_animal/hostile/abnormality/drownedsisters/proc/TeleportPerson(mob/living/carbon/human/H, turf/teleport_target)
	set waitfor = FALSE
	to_chat(H, span_userdanger("你无法呼吸!"))
	H.AdjustSleeping(10 SECONDS)
	animate(H, alpha = 0, time = 2 SECONDS)
	sleep(2 SECONDS)
	H.forceMove(get_turf(teleport_target)) // See ya!
	animate(H, alpha = 255, time = 0 SECONDS)
