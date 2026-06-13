#define STATUS_EFFECT_OVERWHELMING_FEAR /datum/status_effect/overwhelming_fear
/mob/living/simple_animal/hostile/abnormality/censored
	name = "数据删除"
	desc = "这是什么啊... 光是看着就够恶心的了..."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "censored"
	icon_living = "censored"
	portrait = "censored"
	pixel_x = -16
	base_pixel_x = -16
	speak_emote = list("screeches")
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"
	attack_sound = 'sound/abnormalities/censored/attack.ogg'
	/* Stats */
	threat_level = ALEPH_LEVEL
	fear_level = ALEPH_LEVEL + 3
	health = 1500
	maxHealth = 1500
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 1)
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 23
	melee_damage_upper = 26
	move_to_delay = 3
	ranged = TRUE
	/* Works */
	start_qliphoth = 2
	good_hater = TRUE
	success_boxes = 99 // Under normal circumstances, impossible
	can_breach = TRUE
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(80, 70, 60, 55, 50),
		ABNORMALITY_WORK_INSIGHT = list(90, 80, 70, 65, 60),
		ABNORMALITY_WORK_ATTACHMENT = list(70, 60, 50, 45, 40),
		ABNORMALITY_WORK_REPRESSION = 0,
		"Sacrifice" = 999,
	)
	work_damage_upper = 10
	work_damage_lower = 5
	work_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gluttony
	max_boxes = 32

	ego_list = list(
		/datum/ego_datum/weapon/censored,
		/datum/ego_datum/armor/censored,
	)

	gift_type =  /datum/ego_gifts/censored
	gift_message = "光是看着它就够让你感觉恶心的了."
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "这里的\[数据删除\]的收容单元. <br>许多没有植入认知滤网的主管在看见它的第一眼就陷入疯狂."
	observation_choices = list(
		"进入收容单元" = list(TRUE, "你进入了\[数据删除\]的收容单元, \[屏蔽\]的味道以及\[禁用\]的声音充斥在空气中. <br>\
			在经历磨难后, 你终于看见了\[数据删除\]. <br>你准备好直面恐惧了."),
		"不要进入" = list(FALSE, "一想到要进入收容单元，一股恶心的情绪便涌上心头，你于是转身离去. <br>\
			你还没有准备好创造未来."),
	)

	var/can_act = TRUE
	var/ability_damage = 60
	var/ability_cooldown
	var/ability_cooldown_time = 10 SECONDS

/mob/living/simple_animal/hostile/abnormality/censored/Login()
	. = ..()
	to_chat(src, "<h1>你是数据删除, 坦克型异想体.</h1><br>\
		<b>|'数据删除, 数据删除'|: 当你点击近战距离之外的地块时将发动远程攻击.<br>\
		在短暂延迟之后将向目标位置发射'数据删除'.<br>\
		任何被你的'数据删除'击中的人都将受到大量黑色伤害，并获得状态'过量恐惧'<br>\
		如果你不想发动远程攻击，按住SHIFT并单击地块即可关闭.<br>\
		<br>\
		|过量恐惧|: 拥有这种状态的人的精神值将会快速减少至最大精神值的30%, 这个效果持续20秒.<br>\
		<br>\
		|'...小数据删除?'|: 当你攻击死人的时候，你会将它们转化成'小数据删除'.<br>\
		每次转化'小数据删除'都会治疗你最大血上限10%的HP.<br>\
		然而, 一旦'小数据删除'被杀死, 周围所有人类的都会恢复40%的SP.</b>")


/mob/living/simple_animal/hostile/abnormality/censored/Life()
	. = ..()
	if(!.)
		return
	// Apply and refresh status effect to all humans nearby
	if(SSmaptype.maptype != "rcorp")
		for(var/mob/living/carbon/human/H in view(7, src))
			if(H.stat == DEAD)
				continue
			if(faction_check_mob(H))
				continue
			H.apply_status_effect(STATUS_EFFECT_OVERWHELMING_FEAR)

/mob/living/simple_animal/hostile/abnormality/censored/FearEffectText(mob/affected_mob, level = 0)
	level = num2text(clamp(level, 3, 5))
	var/list/result_text_list = list(
		"3" = list("我操我操我操!!!!", "救-救命...", "我不想死!"),
		"4" = list("什么啊这是...?", "我-我受不了了...", "我无法理解..."),
		"5" = list("全都结束了...", "啊..."),
	)
	return pick(result_text_list[level])

/* Combat */
/mob/living/simple_animal/hostile/abnormality/censored/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/censored/Moved()
	. = ..()
	if(!(status_flags & GODMODE))
		for(var/mob/living/carbon/human/H in view(1, src))
			if(H.stat >= SOFT_CRIT || H.health < 0)
				Convert(H)
				break

/mob/living/simple_animal/hostile/abnormality/censored/CanAttack(atom/the_target)
	if(isliving(the_target) && !ishuman(the_target))
		var/mob/living/L = the_target
		if(L.stat == DEAD)
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/censored/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!can_act)
		return

	if(!ishuman(attacked_target))
		return

	var/mob/living/carbon/human/H = attacked_target
	if(H.stat >= SOFT_CRIT || H.health < 0)
		return Convert(H)

	return ..()

/mob/living/simple_animal/hostile/abnormality/censored/OpenFire()
	if(!can_act)
		return

	if(client)
		switch(chosen_attack)
			if(1)
				RangedAbility(target)
		return

	if(ability_cooldown <= world.time && prob(50))
		RangedAbility(target)

	return

/mob/living/simple_animal/hostile/abnormality/censored/proc/Convert(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(!can_act)
		return
	can_act = FALSE
	forceMove(get_turf(H))
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
	playsound(src, 'sound/abnormalities/censored/convert.ogg', 45, FALSE, 5)
	SLEEP_CHECK_DEATH(3)
	new /obj/effect/temp_visual/censored(get_turf(src))
	for(var/i = 1 to 3)
		new /obj/effect/gibspawner/generic/silent(get_turf(src))
		SLEEP_CHECK_DEATH(5.5)
	var/mob/living/simple_animal/hostile/aminion/mini_censored/C = new(get_turf(src))
	if(!QDELETED(H))
		C.desc = "这到底是什么东西? 它就不应该存在... 但冷静下来一想, 它让你想起了[H.real_name]..."
		H.gib()
	ChangeResistances(list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 1))
	adjustBruteLoss(-(maxHealth*0.1))
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/censored/proc/RangedAbility(atom/target)
	if(!can_act)
		return
	if(world.time < ability_cooldown)
		return
	can_act = FALSE
	ability_cooldown = world.time + ability_cooldown_time
	var/turf/T = get_ranged_target_turf_direct(src, get_turf(target), 10, rand(-10,10))
	var/list/turf_list = list()
	playsound(src, 'sound/abnormalities/censored/ability.ogg', 50, FALSE, 5)
	for(var/turf/TT in getline(src, T))
		if(TT.density)
			break
		new /obj/effect/temp_visual/cult/sparks(TT)
		turf_list += TT
		T = TT
	if(!LAZYLEN(turf_list))
		can_act = TRUE
		return
	for(var/i = 1 to 3)
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
		D.alpha = 100
		D.pixel_x = base_pixel_x + rand(-8, 8)
		D.pixel_y = base_pixel_y + rand(-8, 8)
		animate(D, alpha = 0, transform = matrix()*1.2, time = 8)
		SLEEP_CHECK_DEATH(0.15 SECONDS)
	SLEEP_CHECK_DEATH(0.3 SECONDS)
	Beam(T, "censored", time = 10)
	playsound(src, 'sound/weapons/ego/censored3.ogg', 75, FALSE, 5)
	for(var/turf/TT in turf_list)
		for(var/mob/living/L in HurtInTurf(TT, list(), ability_damage, BLACK_DAMAGE, null, TRUE, FALSE, TRUE, hurt_structure = TRUE))
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))
			L.apply_status_effect(STATUS_EFFECT_OVERWHELMING_FEAR)
	can_act = TRUE

/* Work */
/mob/living/simple_animal/hostile/abnormality/censored/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type == "献祭")
		to_chat(user, span_warning("你犹豫了一会..."))
		datum_reference.working = TRUE
		if(!do_after(user, 3 SECONDS, target = user))
			to_chat(user, span_warning("你觉得不值得."))
			datum_reference.working = FALSE
			return null
		user.Stun(30 SECONDS)
		step_towards(user, src)
		sleep(0.3 SECONDS)
		if(QDELETED(user))
			return TRUE
		step_towards(user, src)
		new /obj/effect/temp_visual/censored(get_turf(src))
		sleep(0.3 SECONDS)
		if(QDELETED(user))
			return TRUE
		playsound(src, 'sound/abnormalities/censored/sacrifice.ogg', 45, FALSE, 10)
		if(status_flags & GODMODE) //If CENSORED is still contained within this small time frame
			datum_reference.qliphoth_change(1)
			user.death()
			for(var/i = 1 to 3)
				new /obj/effect/gibspawner/generic/silent(get_turf(src))
				sleep(5.4)
			QDEL_NULL(user)
		else
			user.AdjustStun(-999) //run for your life
		datum_reference.working = FALSE
		return null
	return TRUE

/mob/living/simple_animal/hostile/abnormality/censored/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.sanity_lost)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/censored/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/censored/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon_living = "censored_breach"
	icon_state = icon_living
	return

/* The mini censoreds */
/mob/living/simple_animal/hostile/aminion/mini_censored
	name = "???"
	desc = "这什么鬼东西? 它就不应该存在..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "censored_mini"
	icon_living = "censored_mini"
	speak_emote = list("screeches")
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"
	attack_sound = 'sound/abnormalities/censored/mini_attack.ogg'
	/* Stats */
	health = 300
	maxHealth = 300
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1)
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 13
	melee_damage_upper = 16
	speed = 2
	move_to_delay = 4
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	density = FALSE
	score_divider = 2
	threat_level = WAW_LEVEL
	fear_level = ALEPH_LEVEL + 2
	var/recoved_sanity = 0.2

/mob/living/simple_animal/hostile/aminion/mini_censored/Initialize()
	. = ..()
	playsound(get_turf(src), 'sound/abnormalities/censored/mini_born.ogg', 50, 1, 4)
	base_pixel_x = rand(-6,6)
	pixel_x = base_pixel_x
	base_pixel_y = rand(-6,6)
	pixel_y = base_pixel_y
	if(SSmaptype.maptype == "rcorp")
		density = TRUE

/mob/living/simple_animal/hostile/aminion/mini_censored/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(status_flags & GODMODE)
		return FALSE
	for(var/i = 1 to 2)
		addtimer(CALLBACK(src, PROC_REF(ShakePixels)), i*5 + rand(1, 4))
	ShakePixels()
	return

/mob/living/simple_animal/hostile/aminion/mini_censored/proc/ShakePixels()
	animate(src, pixel_x = base_pixel_x + rand(-3, 3), pixel_y = base_pixel_y + rand(-3, 3), time = 2)
	return

/mob/living/simple_animal/hostile/aminion/mini_censored/death(gibbed)
	if(SSmaptype.maptype == "rcorp")
		for(var/mob/living/carbon/human/H in view(5, src))
			if(H.stat == DEAD)
				continue
			if(faction_check_mob(H))
				continue
			H.adjustSanityLoss(-(H.getMaxSanity() * recoved_sanity))
			playsound(H, 'sound/abnormalities/voiddream/skill.ogg', 40, TRUE, 2)
			to_chat(H, span_nicegreen("好... 现在它死了."))
	return ..()

// Status effect applied by CENSORED
/datum/status_effect/overwhelming_fear
	id = "overwhelming_fear"
	status_type = STATUS_EFFECT_REFRESH
	duration = 20 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/overwhelming_fear
	/// The damage will not be done below that percentage of max sanity
	var/sanity_limit_percent = 0.3
	/// How much percents of max sanity is dealt as pure sanity damage each tick
	var/sanity_damage_percent = 0.05

/atom/movable/screen/alert/status_effect/overwhelming_fear
	name = "压倒性的恐惧"
	desc = "你发现很难重整精神. 你的精神值会慢慢下降到20%."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "overwhelming_fear"

/datum/status_effect/overwhelming_fear/on_apply()
	if(!ishuman(owner))
		return FALSE
	return ..()

/datum/status_effect/overwhelming_fear/tick()
	. = ..()
	var/mob/living/carbon/human/status_holder = owner
	if(status_holder.getSanityLoss() >= status_holder.getMaxSanity() * sanity_limit_percent)
		return
	status_holder.adjustSanityLoss(status_holder.getMaxSanity() * sanity_damage_percent)
