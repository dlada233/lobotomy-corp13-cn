/mob/living/simple_animal/hostile/abnormality/watchman
	name = "守夜人"
	desc = "一个人举着一盏大灯笼，这盏灯尽管有可见的火焰，却不发光."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "watchman"
	icon_living = "watchman"
	portrait = "watchman"
	del_on_death = FALSE
	maxHealth = 420
	health = 420
	rapid_melee = 2
	move_to_delay = 6
	see_in_dark = 30
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	melee_damage_lower = 3
	melee_damage_upper = 4 //He doesn't really attack but I guess if he does he would deal this kind of damage
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = "swing_hit"
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	faction = list("neutral", "hostile")
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 10,
	)
	work_damage_upper = 6
	work_damage_lower = 3
	work_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/pride

	ego_list = list(
		/datum/ego_datum/weapon/alleyway,
		/datum/ego_datum/armor/alleyway,
	)

	gift_type =  /datum/ego_gifts/alleyway
	light_color = "FFFFFFF"
	light_power = -10

	observation_prompt = "\"无自然造物在黑夜游荡，你该寻找庇护所。\"<br>\
		守夜人向你招手示意。<br>你..."
	observation_choices = list(
		"靠近" = list(TRUE, "很好。<br>夜间在林中游荡不安全。<br>\
			随我来，我带你回家。"),
		"逃跑" = list(FALSE, "没跑多远就听到嚎叫尖啸。<br>\
			无数利爪尖牙同时撕咬你。<br>此刻你才明白为何要畏惧黑夜。"),
	)

	// Speech Lines
	speak_chance = 4
	var/speak_normal = list(
		"#夜幕降临，找安全处躲避。",
		"#又一夜，又一轮值。",
		"#在外注意安全。",
		"#夜间在街上游荡不安全。",
		"#当心黑暗中的存在。",
	)
	var/speak_alert = list(
		"黑夜造物正在游荡，快找庇护所。",
		"黑夜已成黑暗生物的巢穴，务必小心。",
		"外面不安全，速速回家。",
		"此等黑暗藏匿邪恶，注意安全。",
		"但愿夜行生物速归巢穴...",
	)
	var/speak_attacked_human = list(
		"#除了殴打守夜人就无事可做吗..?",
		"#现在的年轻人啊...",
		"#有些人简直胆大包天..!",
		"#愿你灾祸缠身，命不久矣。",
	)
	var/speak_attacked_monster = list(
		"滚开，肮脏的夜行怪物！",
		"此地不欢迎尔等！",
		"就不该来此！",
		"这黑暗非你独有，怪物！",
	)
	// Breached Abno tracker.
	var/list/dangers = list()
	var/pulse_cooldown
	var/pulse_cooldown_time = 0.5
	var/pulse_damage = 2
	var/damage_taken = 0
	var/times_fled = 0

/mob/living/simple_animal/hostile/abnormality/watchman/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/watchman/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	. = ..()
	if(GLOB.emergency_level >= TRUMPET_1)
		datum_reference.qliphoth_change(-3)
	return

/mob/living/simple_animal/hostile/abnormality/watchman/WorkChance(mob/living/carbon/human/user, chance)
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) >= 80)
		var/newchance = chance - 20 //You suck, die. I hate you
		return newchance
	return chance

/mob/living/simple_animal/hostile/abnormality/watchman/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	set_light(15)	//Makes everything around it really dark
	filters += filter(type="drop_shadow", x=0, y=0, size=5, offset=2, color=rgb(27, 255, 6))

/mob/living/simple_animal/hostile/abnormality/watchman/Life()
	. = ..()
	if(src.IsContained())
		return
	if((pulse_cooldown <= world.time))
		return Pulse()

/mob/living/simple_animal/hostile/abnormality/watchman/proc/Pulse() // We deal about 2 white every half-second in our view, if you get hit 10 times, you start taking black. 20 and you start taking pale.
	pulse_cooldown = world.time + pulse_cooldown_time
	for(var/turf/T in oview(15, src))
		for(var/mob/living/L in HurtInTurf(T, list(), pulse_damage, WHITE_DAMAGE, check_faction = TRUE, exact_faction_match = TRUE, hurt_mechs = TRUE))
			var/datum/status_effect/stacking/gloam/G = L.has_status_effect(/datum/status_effect/stacking/gloam)
			if(!G)
				L.apply_status_effect(/datum/status_effect/stacking/gloam, 1)
				continue
			G.add_stacks(1)
			G.refresh()

// Watchman teleports away 3 times before being suppressed, but only needs to take about 50 damage.
/mob/living/simple_animal/hostile/abnormality/watchman/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0 && !forced)
		damage_taken += .
	if(times_fled >= 3)
		return
	if(damage_taken >= 100) // 100 health is the threshold to teleport away
		if(times_fled >= 3)
			return
		damage_taken = 0
		TryTeleport()
		times_fled += 1
		adjustHealth(-420, TRUE, TRUE)
		adjustHealth(times_fled * 100, TRUE, TRUE)

/mob/living/simple_animal/hostile/abnormality/watchman/proc/TryTeleport()
	if(IsCombatMap())
		return FALSE
	say(pick(speak_attacked_human))
	var/turf/teleport_target = pick(GLOB.department_centers)
	animate(src, alpha = 0, time = 5)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	SLEEP_CHECK_DEATH(5)
	animate(src, alpha = 255, time = 5)
	new /obj/effect/temp_visual/guardian/phase/out(teleport_target)
	forceMove(teleport_target)

/mob/living/simple_animal/hostile/abnormality/watchman/death(gibbed)
	clear_filters()
	icon_state = core_icon
	icon = 'ModularTegustation/Teguicons/abno_cores/he.dmi'
	set_light(0)
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

/datum/status_effect/stacking/gloam // non-visual indicator of how many times you've been hit
	id = "stacking_gloam"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 5 SECONDS
	tick_interval = 25 SECONDS // Ticks do nothing for this, -1 will not stop processing since there is still a duration.
	alert_type = null
	stack_decay = 0
	stacks = 1
	max_stacks = 30
	alert_type = null
	consumed_on_threshold = FALSE
	var/played_warning_sound = FALSE

/datum/status_effect/stacking/gloam/add_stacks(stacks_added)
	..()
	if(stacks_added <= 0) // We don't want damage ticks from stack decay, or ticks in general.
		return
	if(stacks >= 15)
		var/damage_dealt = (stacks / 2) // ramping 8 - 15 damage
		owner.deal_damage(damage_dealt, BLACK_DAMAGE)
		var/thesound = pick('sound/hallucinations/growl1.ogg','sound/hallucinations/growl2.ogg', 'sound/hallucinations/growl3.ogg',)
		owner.playsound_local(get_turf(src), thesound, 50, TRUE)
		return
	if(stacks >= 10)
		owner.deal_damage(4, BLACK_DAMAGE)
		if(!played_warning_sound)
			var/thesound = pick('sound/hallucinations/turn_around1.ogg','sound/hallucinations/turn_around2.ogg',)
			owner.playsound_local(get_turf(src), thesound, 50, TRUE)
			played_warning_sound = TRUE


/// ======================SPEECH CODE======================
/mob/living/simple_animal/hostile/abnormality/watchman/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(speak_chance)
		if(prob(speak_chance*2))
			say(pick(speak_attacked_monster))

/mob/living/simple_animal/hostile/abnormality/watchman/proc/HandleSpeech()
	// Add new threats.
	if(health <= 0)
		return
	for(var/mob/living/simple_animal/hostile/H in view(7, src))
		if(H == src)
			continue
		if(istype(H, /mob/living/simple_animal/hostile/abnormality))
			var/mob/living/simple_animal/hostile/abnormality/A = H
			if(A.IsContained())
				continue
		dangers |= H
	// Begin cleaning the list up.
	var/prune_list = dangers.Copy()
	for(var/mob/living/simple_animal/hostile/H in dangers)
		if(QDELETED(H) || H.stat == DEAD || !istype(H))
			prune_list -= H
	for(var/mob/living/simple_animal/hostile/abnormality/A in dangers)
		if(!A.IsContained())
			continue
		prune_list -= A
	dangers = prune_list
	// End cleaning up the list.
	if(speak_chance)
		if(prob(speak_chance))
			if(dangers.len)
				say(pick(speak_alert))
			else
				say(pick(speak_normal))

/mob/living/simple_animal/hostile/abnormality/watchman/handle_automated_action()
	. = ..()
	HandleSpeech()

/mob/living/simple_animal/hostile/abnormality/watchman/handle_automated_movement()
	. = ..()
	HandleSpeech()

/mob/living/simple_animal/hostile/abnormality/watchman/patrol_step(dest)
	. = ..()
	HandleSpeech()


