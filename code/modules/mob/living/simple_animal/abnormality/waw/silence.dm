//Coded by me, Kirie Saito!
/mob/living/simple_animal/hostile/abnormality/silence
	name = "沉默的代价"
	desc = "一把挂着时钟的镰刀，静静地滴答作响."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "silence"
	portrait = "silence"
	maxHealth = 1000
	health = 1000

	threat_level = WAW_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 40, 50, 50),
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 30, 40, 40),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 50, 45, 45),
	)
	start_qliphoth = 1
	work_damage_upper = 8
	work_damage_lower = 6
	work_damage_type = PALE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gloom

	ego_list = list(
		/datum/ego_datum/weapon/thirteen,
		/datum/ego_datum/armor/thirteen,
	)
	gift_type = /datum/ego_gifts/thirteen
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	observation_prompt = "时间正在浪费。<br>时间所剩无几...<br>那不过是无谓的狂怒罢了。<br>\
		这座钟表不仅能收回你逝去的时间，更将赠予你额外光阴。"
	observation_choices = list(
		"使用钟表" = list(TRUE, "代价将随你的决定而至。<br>这本就是它的设计。"),
		"不使用钟表" = list(FALSE, "事实上你无权拒绝这份馈赠。<br>\
			无论接受与否，你终将收下它。"),
	)

	var/meltdown_cooldown_time = 13 MINUTES
	var/meltdown_cooldown
	var/worldwide_damage = 70	//If you're unarmored, it obliterates you
	var/safe = FALSE //work on it and you're safe for 13 minutes
	var/reset_time = 3 MINUTES //Don't hit everyone with the global pale if it was hit in a small period of time
	var/datum/looping_sound/silence/soundloop // Tick-tock, tick-tock

/mob/living/simple_animal/hostile/abnormality/silence/Initialize()
	. = ..()
	meltdown_cooldown = world.time + meltdown_cooldown_time
	soundloop = new(list(src), TRUE)

/mob/living/simple_animal/hostile/abnormality/silence/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/mob/living/simple_animal/hostile/abnormality/silence/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	safe = TRUE
	to_chat(user, span_nicegreen("丧钟不为你而鸣，暂时不为."))
	return

/mob/living/simple_animal/hostile/abnormality/silence/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(50))
		safe = TRUE
		to_chat(user, span_nicegreen("丧钟不为你而鸣，暂时不为."))
	return

/mob/living/simple_animal/hostile/abnormality/silence/Life()
	. = ..()
	if(meltdown_cooldown < world.time)
		meltdown_cooldown = world.time + meltdown_cooldown_time
		sound_to_playing_players_on_level('sound/abnormalities/silence/ambience.ogg', 50, zlevel = z)
		if(!safe)
			datum_reference.qliphoth_change(-1)
		safe = FALSE
	return

//Meltdown
/mob/living/simple_animal/hostile/abnormality/silence/ZeroQliphoth(mob/living/carbon/human/user)
	// You have mere seconds to live
	SLEEP_CHECK_DEATH(5 SECONDS)
	sound_to_playing_players_on_level('sound/abnormalities/silence/price.ogg', 50, zlevel = z)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(faction_check_mob(H, FALSE) || H.z != z || H.stat == DEAD)
			continue

		new /obj/effect/temp_visual/thirteen(get_turf(H))	//A visual effect if it hits
		H.deal_damage(worldwide_damage, PALE_DAMAGE)
	addtimer(CALLBACK(src, PROC_REF(Reset)), reset_time)
	return

/mob/living/simple_animal/hostile/abnormality/silence/proc/Reset()
	datum_reference.qliphoth_change(1)
