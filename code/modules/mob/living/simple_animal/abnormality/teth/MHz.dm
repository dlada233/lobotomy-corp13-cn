/mob/living/simple_animal/hostile/abnormality/mhz
	name = "1.76 MHz"
	desc = "除了噪点你什么都看不到."
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "mhz"
	icon_living = "mhz"
	portrait = "MHz"
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -32
	base_pixel_y = -32
	maxHealth = 230
	health = 230
	blood_volume = 0
	start_qliphoth = 4
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = list(40, 30, 20, 20, 20),
		ABNORMALITY_WORK_ATTACHMENT = list(20, 10, 0, 0, 0),
		ABNORMALITY_WORK_REPRESSION = list(55, 55, 60, 60, 60),
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/wrath
	max_boxes = 12

	ego_list = list(
		/datum/ego_datum/weapon/noise,
		/datum/ego_datum/armor/noise,
	)
	gift_type =  /datum/ego_gifts/noise
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/quiet_day = 1.5,
		/mob/living/simple_animal/hostile/abnormality/khz = 1.5,
		/mob/living/simple_animal/hostile/abnormality/army = 1.5,
	)

	observation_prompt = "你仍记得那天，也记得这个房间. <br>\
		等待时，你的收音机在静电噪音中发出嘶嘶声，幽灵般的声音埋没在电磁雪花里. <br>\
		\"救...命...\" <br>\
		来自过去的幽灵在呼唤，声音很熟悉却想不起是谁."
	observation_choices = list(
		"把你的无线电调至1.76MHz" = list(TRUE, "你调谐收音机，清晰听见她的恳求，她的声音如阳光般温暖. <br>\
			无法抑制的愤怒与对不公的悲伤充斥着你，你离开了收容室."),
		"忘记" = list(FALSE, "但你无法忘记，赎罪完成前绝不忘记."),
	)

	var/reset_time = 4 MINUTES //Qliphoth resets after this time. To prevent bugs

/mob/living/simple_animal/hostile/abnormality/mhz/WorkChance(mob/living/carbon/human/user, chance)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 40)
		return chance * 1.25
	return chance

/mob/living/simple_animal/hostile/abnormality/mhz/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(1)
	if(pe >= datum_reference.max_boxes)
		datum_reference.qliphoth_change(1)

/mob/living/simple_animal/hostile/abnormality/mhz/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/mhz/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/mhz/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.sanity_lost)
		datum_reference.qliphoth_change(-1)
	return ..()

/mob/living/simple_animal/hostile/abnormality/mhz/ZeroQliphoth(mob/living/carbon/human/user)
	addtimer(CALLBACK (datum_reference, TYPE_PROC_REF(/datum/abnormality, qliphoth_change), 4), reset_time)
	SSweather.run_weather(/datum/weather/mhz)

//We're gonna make it a weather that affects all hallways.
//We've tried the spreading stuff effect with Snow White and it's super laggy. Having 2 at once would be horrible.
/datum/weather/mhz
	name = "白噪音"
	immunity_type = "static"
	desc = "Static created by 1.76 MHz."
	telegraph_message = span_warning("你听到远处有什么声音.")
	telegraph_duration = 300
	weather_message = span_userdanger("<i>是....那是人类哀号的声音吗? 他们在受苦吗?</i>")
	weather_overlay = "mhz"
	weather_duration_lower = 1200		//2-3 minutes.
	weather_duration_upper = 1800
	end_duration = 100
	end_message = span_boldannounce("一切又平静下来了，你感到平静.")
	area_type = /area/facility_hallway
	target_trait = ZTRAIT_STATION

/datum/weather/mhz/weather_act(mob/living/carbon/human/L)
	if(ishuman(L))
		L.deal_damage(2, WHITE_DAMAGE)
