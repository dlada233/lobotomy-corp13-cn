/mob/living/simple_animal/hostile/abnormality/ppodae
	name = "波迪"
	desc = "世界上最好的狗狗"
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "ppodae"
	icon_living = "ppodae"
	portrait = "ppodae"
	pixel_x = -8
	base_pixel_x = -8
	maxHealth = 230 //fast but low hp abno
	health = 230
	threat_level = TETH_LEVEL
	move_to_delay = 1
	faction = list("hostile")
	response_help_continuous = "pet"
	response_help_simple = "pet"
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = list(40, 40, 30, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = list(40, 40, 30, 30, 30),
	)
	work_damage_upper = 3
	work_damage_lower = 2
	work_damage_type = RED_DAMAGE
	max_boxes = 12
	chem_type = /datum/reagent/abnormality/sin/wrath
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	can_breach = TRUE
	start_qliphoth = 2
	vision_range = 14
	aggro_vision_range = 20
	stat_attack = HARD_CRIT

	ego_list = list(
		/datum/ego_datum/weapon/cute,
		/datum/ego_datum/armor/cute,
	)
	gift_type =  /datum/ego_gifts/cute
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY
	attack_action_types = list(/datum/action/cooldown/ppodae_transform)

	observation_prompt = "我面前站着一个生物，急切地等待下一餐。这个生物是..."
	observation_choices = list(
		"怪物" = list(TRUE, "我不知道之前怎么没看出来，我冲出去警告其他人。第二天就被解雇了。"),
		"小狗" = list(FALSE, "这是我见过最可爱的小狗。"),
	)

	var/smash_damage_low = 4
	var/smash_damage_high = 8
	var/smash_length = 2
	var/smash_width = 1
	var/can_act = TRUE
	var/buff_form = TRUE
	//Buff Form stuff
	var/buff_resist_red = 0.5
	var/buff_resist_white = 0.5
	var/buff_resist_black = 0.5
	var/buff_resist_pale = 0.5
	var/buff_speed = 2
	var/can_slam = TRUE
	//Cute Form stuff
	var/cute_resist_red = 1.5
	var/cute_resist_white = 0.8
	var/cute_resist_black = 1
	var/cute_resist_pale = 2
	var/cute_speed = 1
	//Other Stuff
	var/limb_heal = 0.02


/mob/living/simple_animal/hostile/abnormality/ppodae/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, "<h1>你是波迪，支援/战斗型异想体。</h1><br>\
		<b>|真可爱！|：你能在'可爱'和'强壮'形态间切换。\
		切换形态有10秒冷却时间，每次切换会产生持续9秒的烟雾。<br>\
		<br>\
		|好可爱！|：在'可爱'形态下，你获得巨大速度加成。近战攻击机甲或生物时，你会爬到它们下方。<br>\
		<br>\
		|真强壮！|：在'强壮'形态下，你受到的所有伤害减少50%，近战攻击会造成3x3范围伤害（对建筑特别有效）<br>\
		<br>\
		|他只是在玩耍|：当近战攻击昏迷或死亡的人类时，你能扯下肢体，恢复自身2%最大生命值（每具尸体最多4次）</b>")

/datum/action/cooldown/ppodae_transform
	name = "Transform!"
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "ppodae_transform"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = 12.5 SECONDS

/datum/action/cooldown/ppodae_transform/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/ppodae))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/ppodae/ppodae = owner
	if(ppodae.IsContained()) // No more using cooldowns while contained
		return FALSE
	StartCooldown()
	if(ppodae.buff_form)
		ppodae.buff_form = FALSE
		ppodae.UpdateForm()
	else
		ppodae.buff_form = TRUE
		ppodae.UpdateForm()
	return TRUE

/mob/living/simple_animal/hostile/abnormality/ppodae/proc/UpdateForm()
	if(buff_form)
		ChangeResistances(list(RED_DAMAGE = buff_resist_red, WHITE_DAMAGE = buff_resist_white, BLACK_DAMAGE = buff_resist_black, PALE_DAMAGE = buff_resist_pale))
		move_to_delay = buff_speed
		icon_state = "ppodae_active"
		can_slam = TRUE
	else
		ChangeResistances(list(RED_DAMAGE = cute_resist_red, WHITE_DAMAGE = cute_resist_white, BLACK_DAMAGE = cute_resist_black, PALE_DAMAGE = cute_resist_pale))
		move_to_delay = cute_speed
		icon_state = "ppodae"
		can_slam = FALSE
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(1, src)
	smoke.start()
	qdel(smoke)
	UpdateSpeed()
	playsound(get_turf(src), 'sound/abnormalities/scaredycat/cateleport.ogg', 50, 0, 5)

/mob/living/simple_animal/hostile/abnormality/ppodae/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/ppodae/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	var/mob/living/carbon/L = attacked_target
	if(IsCombatMap())
		if(iscarbon(attacked_target) && (L.stat == DEAD))
			LimbSteal(L)
			return
	else
		if(iscarbon(attacked_target) && (L.health < 0 || L.stat == DEAD))
			LimbSteal(L)
			return

			// Taken from eldritch_demons.dm
	if(IsCombatMap())
		if(can_slam)
			return Smash(attacked_target)
		else if(isvehicle(attacked_target))
			var/obj/vehicle/V = attacked_target
			var/turf/target_turf = get_turf(V)
			forceMove(target_turf)
			manual_emote("爬到[V]下面!")
		else if (istype(attacked_target, /mob/living))
			if (attacked_target != src)
				var/turf/target_turf = get_turf(attacked_target)
				forceMove(target_turf)
				manual_emote("爬到[attacked_target]下面!")
	else
		return Smash(attacked_target)

/mob/living/simple_animal/hostile/abnormality/ppodae/proc/LimbSteal(mob/living/carbon/L)
	if(HAS_TRAIT(L, TRAIT_NODISMEMBER))
		return
	var/list/parts = list()
	for(var/X in L.bodyparts)
		var/obj/item/bodypart/bp = X
		if(bp.body_part != HEAD && bp.body_part != CHEST)
			if(bp.dismemberable)
				parts += bp
	if(length(parts))
		var/obj/item/bodypart/bp = pick(parts)
		bp.dismember()
		if(IsCombatMap())
			adjustHealth(-(maxHealth * limb_heal))
		bp.forceMove(get_turf(datum_reference.landmark)) // Teleports limb to containment
		QDEL_NULL(src)

//AoE attack taken from woodsman
/mob/living/simple_animal/hostile/abnormality/ppodae/proc/Smash(target)
	if (get_dist(src, target) > 1)
		return
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line = list()
	switch(dir_to_target)
		if(EAST)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, EAST, smash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, smash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, smash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(WEST)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, WEST, smash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, smash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, smash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(SOUTH)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, SOUTH, smash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, smash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, smash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(NORTH)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, NORTH, smash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, smash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, smash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		else
			for(var/turf/T in view(1, src))
				if (T.density)
					break
				if (T in area_of_effect)
					continue
				area_of_effect |= T
	if (!LAZYLEN(area_of_effect))
		return
	can_act = FALSE
	dir = dir_to_target
	var/smash_damage = rand(smash_damage_low, smash_damage_high)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/smash_effect(T)
		HurtInTurf(T, list(), smash_damage, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, hurt_structure = TRUE)
	playsound(get_turf(src), 'sound/abnormalities/ppodae/bark.wav', 100, 0, 5)
	playsound(get_turf(src), 'sound/abnormalities/ppodae/attack.wav', 50, 0, 5)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/ppodae/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type != ABNORMALITY_WORK_INSTINCT && prob(50))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/ppodae/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/ppodae/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon_state = "ppodae_active"
	GiveTarget(user)
	if(IsCombatMap())
		UpdateForm()
