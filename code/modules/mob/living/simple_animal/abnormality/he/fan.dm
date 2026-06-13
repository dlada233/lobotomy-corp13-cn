//I think I want to do the idea of temptation.
//The works are always max but you can only do it 3 times per person.	-Kirie
/mob/living/simple_animal/hostile/abnormality/fan
	name = "F.A.N."
	desc = "它似乎是个办公室电风扇."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "fan"
	portrait = "fan"
	maxHealth = 300
	health = 300
	speak_emote = list("states")
	speech_span = SPAN_ROBOT
	threat_level = HE_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 100,
		ABNORMALITY_WORK_INSIGHT = 100,
		ABNORMALITY_WORK_ATTACHMENT = 100,
		ABNORMALITY_WORK_REPRESSION = 100,
	)
	work_damage_upper = 7
	work_damage_lower = 5
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/sloth
	max_boxes = 12

	ego_list = list(
		/datum/ego_datum/weapon/metal,
		/datum/ego_datum/armor/metal,
	)
	gift_type = /datum/ego_gifts/metal
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK
	can_spawn = FALSE // Does Nothing.

	observation_prompt = "这是个普通的金属办公室风扇。<br>目前处于关闭状态，你感到闷热。<br>\
		要打开吗？"
	observation_choices = list(
		"调到3档" = list(TRUE, "你设置为最高档位。<br>微风舒适宜人，适合小憩..."),
		"保持关闭" = list(FALSE, "虽只是古老都市传说，但据说这种风扇在睡眠时开启会致命..."),
		"调到1档" = list(FALSE, "风力不足，还是太热！"),
		"调到2档" = list(FALSE, "几乎感觉不到风，只差一点..."),
	)

	var/list/safe = list()
	var/list/warning = list()
	var/list/danger = list()
	pet_bonus = "powers on" //saves a few lines of code by allowing funpet() to be called by attack_hand()
	var/safework = FALSE //Safe if the abnormality was melting
	var/successcount
	var/turned_off = FALSE
	var/list/opposed_weather_list = list(
		/datum/weather/thunderstorm,
		/datum/weather/fog,
		/datum/weather/freezing_wind
		)

/mob/living/simple_animal/hostile/abnormality/fan/examine(mob/user)
	. = ..()
	if(turned_off)
		. += span_notice("看起来好像关机了.")

//Work Mechanics
/mob/living/simple_animal/hostile/abnormality/fan/WorkChance(mob/living/carbon/human/user, chance)
	var/newchance = 100 - (successcount*3)
	return newchance

/mob/living/simple_animal/hostile/abnormality/fan/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	successcount+=1

/mob/living/simple_animal/hostile/abnormality/fan/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user in danger)
		if(safework)
			to_chat(user, span_notice("这次你不会觉得很受诱惑."))
			safework = FALSE
			return
		to_chat(user, span_danger("Oh."))
		user.throw_at(src, 10, 10, user, spin = TRUE, gentle = FALSE, quickstart = TRUE)
		SLEEP_CHECK_DEATH(3)
		playsound(loc, 'sound/machines/juicer.ogg', 100, TRUE)
		user.gib()

	else if(user in warning)
		danger+=user
		to_chat(user, span_nicegreen("你感到欣喜若狂."))

	else if(user in safe)
		warning+=user
		to_chat(user, span_nicegreen("你感到神清气爽."))

	else
		safe+=user
		to_chat(user, span_nicegreen("你还想多享受会儿."))

//Meltdown
/mob/living/simple_animal/hostile/abnormality/fan/AttemptWork(mob/living/carbon/human/user, work_type)
	if(turned_off)
		to_chat(user, span_nicegreen("你按下启动开关。啊，感觉真舒服."))
		TurnOn()
		return FALSE
	if(datum_reference.console.meltdown)
		safework = TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/fan/funpet(mob/petter)
	if(turned_off)
		to_chat(petter, span_nicegreen("你按下启动开关。啊，感觉真舒服."))
		TurnOn()

//Breach
/mob/living/simple_animal/hostile/abnormality/fan/ZeroQliphoth(mob/living/carbon/human/user)
	. = ..()
	if(!turned_off)
		TurnOff()

/mob/living/simple_animal/hostile/abnormality/fan/proc/TurnOn(mob/living/carbon/human/user)
	turned_off = FALSE
	icon_state = "fan"
	playsound(get_turf(src), 'sound/abnormalities/FAN/turnon.ogg', 100, FALSE, 2)
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		var/datum/status_effect/stacking/fanhot/V = L.has_status_effect(/datum/status_effect/stacking/fanhot)
		if(!V)
			continue
		else
			qdel(V)

/mob/living/simple_animal/hostile/abnormality/fan/proc/TurnOff(mob/living/carbon/human/user)
	turned_off = TRUE
	icon_state = "fan_idle"
	playsound(get_turf(src), 'sound/abnormalities/FAN/turnoff.ogg', 100, TRUE, 2)
	HeatWave()
	sound_to_playing_players_on_level('sound/abnormalities/seasons/summer_idle.ogg', 150, zlevel = z)

/mob/living/simple_animal/hostile/abnormality/fan/proc/HeatWave()
	set waitfor = FALSE
	if(!turned_off)
		datum_reference.qliphoth_change(1)
		return

	for(var/W in SSweather.processing) // Supernatural weather should prevent the AC being turned off from making it hot.
		var/datum/weather/V = W
		if(V.type in opposed_weather_list)
			return

	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(z != L.z || L.stat >= HARD_CRIT) // on a different Z level or dead
			continue
		var/datum/status_effect/stacking/fanhot/V = L.has_status_effect(/datum/status_effect/stacking/fanhot)
		if(!V)
			L.apply_status_effect(/datum/status_effect/stacking/fanhot)
		else
			V.add_stacks(1)
			V.refresh()
	SLEEP_CHECK_DEATH(3 SECONDS)
	HeatWave(TRUE)

/datum/status_effect/stacking/fanhot
	id = "stacking_fanhot"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 20 SECONDS
	alert_type = null
	stack_decay = 0
	tick_interval = 10
	stacks = 1
	stack_threshold = 33
	max_stacks = 35
	on_remove_on_mob_delete = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/fanhot
	consumed_on_threshold = FALSE

/atom/movable/screen/alert/status_effect/fanhot
	name = "热"
	desc = "谁去把空调打开!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "hot"

/datum/status_effect/stacking/fanhot/on_apply()
	. = ..()
	to_chat(owner, span_warning("你开始出汗了."))
	if(owner.client)
		owner.add_client_colour(/datum/client_colour/glass_colour/orange)

/datum/status_effect/stacking/fanhot/add_stacks(stacks_added)
	. = ..()
	if(!stacks_added)
		return
	if(stacks < 10)
		return
	owner.deal_damage((stacks / 10), FIRE)
	owner.playsound_local(owner, 'sound/effects/burn.ogg', 25, TRUE)

/datum/status_effect/stacking/fanhot/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	to_chat(owner, span_nicegreen("有人把空调打开了! 好耶!"))
	if(owner.client)
		owner.remove_client_colour(/datum/client_colour/glass_colour/orange)

/datum/status_effect/stacking/fanhot/threshold_cross_effect()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_warning("太热了!"))
	owner.apply_lc_burn(10)
	stacks -= 10
