/mob/living/simple_animal/hostile/abnormality/doomsday_calendar
	name = "终末日历"
	desc = "从刻在砖上的许多字母来看，很可能是预测某种日期的工具."
	health = 1212
	maxHealth = 1212
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "doomsday_inert"
	icon_living = "doomsday_inert"
	icon_dead = "doomsday_egg"
	core_icon = "doomsday_egg"
	portrait = "doomsday"
	light_color = COLOR_LIGHT_ORANGE
	light_range = 0
	light_power = 0
	base_pixel_x = -16
	pixel_x = -16
	can_breach = TRUE
	can_buckle = TRUE
	threat_level = HE_LEVEL
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.1, PALE_DAMAGE = 0.3)//only when initialized
	start_qliphoth = 5
	max_boxes = 18 // This must be defined here for later code to work.
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = 20,
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	work_damage_upper = 6
	work_damage_lower = 3
	work_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/wrath
	can_patrol = FALSE
	wander = FALSE
	del_on_death = FALSE
	death_message = "crumbles into bits."
	attack_sound = 'sound/abnormalities/doomsdaycalendar/Doomsday_Attack.ogg'
	melee_damage_lower = 10
	melee_damage_upper = 15
	melee_damage_type = BLACK_DAMAGE
	ego_list = list(
		/datum/ego_datum/weapon/impending_day,
		/datum/ego_datum/armor/impending_day,
	)
	gift_type =  /datum/ego_gifts/impending_day
	gift_message = "让血液流动，让火焰燃烧，让星星坠落."
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	observation_prompt = "我立于无尽长阶顶端的祭坛前，天空猩红，灼热气流舔舐着疼痛的皮肤。<br>世界正在终结。<br>\
		祭坛上绑着戴粘土面具的男子，他扭动啜泣，我却听不见言语。<br>\
		手中握着匕首。<br>我明白自己必须做什么。"
	observation_choices = list(
		"将匕首刺入其胸膛" = list(TRUE, "此刻我躺在祭坛上，沉重粘土面具压着头颅，粗绳捆缚四肢，滚烫空气灼烧皮肤。<br>\
		透过面具孔洞看见祭司，我乞求宽恕，却感到冰冷金属刺入胸腔。"),
		"割断绳索" = list(FALSE, "我割断绳索释放男子，他连声道谢后冲下长阶。<br>他逃不掉的。<br>我闭目接受终局。"),
	)

	var/player_count
	var/other_works_maximum
	var/other_works = 0
	var/flavor_dist = 40
	var/pulse_cooldown
	var/pulse_cooldown_time = 2 SECONDS
	var/pulse_damage = 2
	var/bonusRed = 0
	var/next_phase_time
	var/next_phase_time_cooldown = 45 SECONDS
	var/current_phase_num = -1
	var/aflame_range = 5//it goes up if ignored
	var/aflame_damage = 6
	var/gibtime = 5
	var/is_fed = FALSE
	var/is_firey = FALSE
	var/doll_count_maximum = 2
	var/list/spawned_dolls = list()
	pet_bonus = "rumbles" //saves a few lines of code by allowing funpet() to be called by attack_hand()

//*** Simple Mob Procs ***//
/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/Initialize()
	. = ..()
	updateWorkMaximum()
	RegisterSignal(SSdcs, COMSIG_GLOB_WORK_STARTED, PROC_REF(OnAbnoWork))

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/CanAttack(atom/the_target)//should only attack when it has fists
	return FALSE

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!IsContained())//if it's breaching
		CheckCountdown()
		if((pulse_cooldown < world.time) && (is_firey == TRUE))
			playsound(src, 'sound/effects/burn.ogg', 50, TRUE)
			AoeBurn()

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/death()
	density = FALSE
	playsound(src, 'sound/abnormalities/doomsdaycalendar/Doomsday_Dead.ogg', 100, 1)
	icon = 'ModularTegustation/Teguicons/abno_cores/he.dmi'
	for(var/mob/living/simple_animal/hostile/aminion/doomsday_doll/D in spawned_dolls) //delete the dolls when suppressed
		D.death()
		QDEL_IN(D, rand(1,5) SECONDS)
		spawned_dolls -= D
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_WORK_STARTED)
	return ..()

//*** Work Mechanics ***//
//Even clerks can appease it with their blood
/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/funpet(mob/living/carbon/human/user)
	if(IsContained() && datum_reference.qliphoth_meter != datum_reference.qliphoth_meter_max)
		if(do_after(user, gibtime, target = src))
			to_chat(user, span_warning("[src]咬你！似乎已经平息了."))
			user.adjustBruteLoss(9 - (datum_reference.qliphoth_meter * 2))
			datum_reference.qliphoth_change(1)
			return
		else
			to_chat(user, span_notice("也许还是别管这事吧."))

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/proc/OnAbnoWork(datum/source, datum/abnormality/abno_datum, mob/user, work_type)//from punishing bird
	SIGNAL_HANDLER
	if(!IsContained()) // If it's breaching right now
		return FALSE
	if(abno_datum == datum_reference)//If working on this abnormality
		return FALSE
	if(datum_reference.working)//If the abnormality is being worked on, may invalidate the previous conditional statement
		return FALSE
	++other_works
	if(other_works >= other_works_maximum)
		datum_reference.qliphoth_change(-1)
		other_works = 0
	return TRUE

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/WorkChance(mob/living/carbon/human/user, chance)
	if(bonusRed)
		return chance + (bonusRed * 3)//extra work success on instinct work if it's hungry. Up to +12%, making it a 72% base success rate at counter 1.
	return chance

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(work_type == ABNORMALITY_WORK_INSTINCT)
		return
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_INSTINCT)
		datum_reference.qliphoth_change(4)//Work damage is multiplied by missing qliphoth counter, restore it fully.
	return

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/AttemptWork(mob/living/carbon/human/user, work_type)
	datum_reference.max_boxes = (max_boxes + (5 - datum_reference.qliphoth_meter))//18 at max qliphoth, up to 22.
	if(work_type != ABNORMALITY_WORK_INSTINCT)// Sets bonus damage on instinct work only.
		bonusRed = 0
		return..()
	bonusRed = (2.5 - (datum_reference.qliphoth_meter))//It samples your blood if it's below the maximum counter, damage is RED instead of typeless
	if(bonusRed)
		to_chat(user, span_warning("一个黏土人偶端着碗来了，要求给他血."))
		playsound(src, 'sound/abnormalities/doomsdaycalendar/Lor_Slash_Generic.ogg', 40, 0, 1)
	return ..()

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/Worktick(mob/living/carbon/human/user)
	if(bonusRed) // If you have bonus red damage to apply...
		user.deal_damage(bonusRed, RED_DAMAGE)
	return ..()

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/OnQliphothChange(mob/living/carbon/human/user)//woodsman icon change
	. = ..()
	if(datum_reference.qliphoth_meter == 1)
		icon_state = "doomsday_active"
		playsound(get_turf(src), 'sound/abnormalities/doomsdaycalendar/Impending_Charge.ogg', 75, 0, 5)
	else
		icon_state = "doomsday_inert"

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/proc/updateWorkMaximum()
	player_count = 0
	for(var/mob/player in GLOB.player_list)
		if(isliving(player) && ishuman(player))
			player_count += 1
	other_works_maximum = (4 + round(player_count / 6))

//***Breach Mechanics***//
/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	if(breach_type != BREACH_MINING)
		var/turf/T = pick(GLOB.department_centers)
		forceMove(T)
	icon_state = "doomsday_active"
	AnnounceBreach()
	SpawnAdds()

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/proc/AnnounceBreach()
	send_to_playing_players(span_narsiesmall("天启的日子到了."))
	sound_to_playing_players('sound/creatures/narsie_rises.ogg')
	for(var/mob/living/carbon/human/H in livinginrange(20, src))//same range as universe aflame when fully charged
		if(H.z != z)
			return
		to_chat(H, span_boldwarning("你听到隆隆声..."))


/obj/effect/temp_visual/doomsday
	icon = 'icons/effects/effects.dmi'
	icon_state = "universe_aflame"
	alpha = 170
	duration = 50

/obj/effect/temp_visual/doomsday/Initialize()
	add_overlay(mutable_appearance('icons/effects/effects.dmi', "empdisable", -ABOVE_OBJ_LAYER))
	return ..()

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/proc/CheckCountdown()//grabbed from TSO
	if(world.time >= next_phase_time) // Next phase
		if(current_phase_num < 4)
			current_phase_num += 1
		switch(current_phase_num)
			if(1)
				next_phase_time_cooldown = 30 SECONDS
				for(var/mob/living/carbon/human/H in livinginview(10, src))
					to_chat(H, span_boldwarning("[src]似乎心烦意乱，因为它的砖块开始发出嘎嘎声."))
				CheckFed()
				SpawnAdds()
				icon_state = "doomsday_angry"
			if(2)
				for(var/mob/living/carbon/human/H in livinginview(10, src))
					to_chat(H, span_boldwarning("[src]发出的热量令人难以忍受."))
				CheckFed()
				SpawnAdds()
				icon_state = "doomsday_firey"
				EnableFire()
			if(3)
				for(var/mob/living/carbon/human/H in livinginview(10, src))
					to_chat(H, span_boldwarning("[src]呈现出不祥的外观并开始发光."))
				CheckFed()
				SpawnAdds()
				icon_state = "doomsday_charging"
				EnableFire()
			if(4)//begin nuking
				CheckFed()
				icon_state = "doomsday_universe"
				EnableFire()
		next_phase_time = world.time + next_phase_time_cooldown

		if(current_phase_num >= 4)//UNIVERSE AFLAME!
			for(var/turf/T in range(aflame_range, src))
				for(var/mob/living/carbon/human/H in T)
					to_chat(H, span_narsiesmall("星星在闪烁，当它们闪耀时，它们会夺走我们所有人的视线."))
			playsound(src, 'sound/abnormalities/doomsdaycalendar/Impending_Charge.ogg', 50, TRUE)
			SLEEP_CHECK_DEATH(15 SECONDS)
			playsound(src, 'sound/abnormalities/doomsdaycalendar/Doomsday_Universe.ogg', 50, TRUE)
			for(var/turf/T in range(aflame_range, src))
				if(prob(25))
					new /obj/effect/temp_visual/doomsday(T)
				for(var/mob/living/H in T)
					if(isabnormalitymob(H))
						var/mob/living/simple_animal/hostile/abnormality/A = H
						if(!(A.IsContained()))
							continue
						A.datum_reference.qliphoth_change(-1)
					if(faction_check_mob(H))
						continue
					H.deal_damage(aflame_damage, BLACK_DAMAGE)
					if(H.stat >= SOFT_CRIT || H.health < 0)
						H.fire_stacks += 1
						H.IgniteMob()//unforunately this fire isn' blue.
			adjustBruteLoss(500)

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/proc/AoeBurn()
	pulse_cooldown = world.time + pulse_cooldown_time
	for(var/mob/living/L in livinginview(10, src))
		if(faction_check_mob(L))
			continue
		L.deal_damage(pulse_damage, RED_DAMAGE)

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/proc/EnableFire()
	if(current_phase_num <= 1)
		return
	if(pulse_damage <= 0)
		set_light_on(FALSE)
		update_light()
		is_firey = FALSE
		return
	light_range = 10
	light_power = 10
	set_light_on(TRUE)
	update_light()
	is_firey = TRUE

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/proc/CheckFed()
	if(IsContained())
		return
	if(!is_fed)
		pulse_damage += 1
		aflame_range += 5
		aflame_damage += 3
	doll_count_maximum += 1
	is_fed = FALSE

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/user_buckle_mob(mob/living/M, mob/user, check_loc)
	if(IsContained())//is contained
		return FALSE
	if(M.stat != DEAD)
		return FALSE
	if(do_after(user, 20, target = M))
		if(!ishuman(M) && !istype(M, /mob/living/simple_animal/hostile/aminion/doomsday_doll))
			to_chat(user, span_warning("[src]拒绝你的提议!"))
			return
		if(istype(M ,/mob/living/simple_animal/hostile/aminion/doomsday_doll))
			spawned_dolls -= M
		to_chat(user, span_nicegreen("[src]满足于你的供品!"))
		M.gib()
		is_fed = TRUE
		adjustBruteLoss(150)
		pulse_damage -= 1
		playsound(get_turf(src),'sound/effects/limbus_death.ogg', 50, 1)
		AddModifier(/datum/dc_change/sacrificed)

//***Simple Mobs***//
//clay dolls
/mob/living/simple_animal/hostile/aminion/doomsday_doll
	name = "末日人偶"
	desc = "模模糊糊的人形人物，戴着沉重的粘土头盔."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "doomsday_doll"
	icon_living = "doomsday_doll"
	icon_dead = "doomsday_doll_dead"
	speak_emote = list("groans", "moans", "howls", "screeches", "grunts")
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	attack_sound = 'sound/abnormalities/doomsdaycalendar/Doomsday_Slash.ogg'
	/*Stats*/
	health = 150
	maxHealth = 150
	obj_damage = 50
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1.5)
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 4
	melee_damage_upper = 6
	move_to_delay = 3
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	move_resist = MOVE_RESIST_DEFAULT
	del_on_death = FALSE
	density = TRUE
	threat_level = TETH_LEVEL
	score_divider = 4//they're cannon fodder anyways
	var/can_act = TRUE

/mob/living/simple_animal/hostile/aminion/doomsday_doll/Initialize()
	. = ..()
	base_pixel_x = rand(-6,6)
	pixel_x = base_pixel_x
	base_pixel_y = rand(-6,6)
	pixel_y = base_pixel_y

/mob/living/simple_animal/hostile/abnormality/doomsday_calendar/proc/SpawnAdds()
	var/doll_count = length(spawned_dolls)
	if (doll_count >= doll_count_maximum)
		return
	for(var/i = doll_count, i < doll_count_maximum, i++)//This counts up
		var /mob/living/simple_animal/hostile/aminion/doomsday_doll/D= new(get_turf(src))
		spawned_dolls += D
