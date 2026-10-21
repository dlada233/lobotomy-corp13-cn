#define BLESS_COOLDOWN (5 SECONDS)
/mob/living/simple_animal/hostile/abnormality/despair_knight
	name = "绝望骑士"//（出自脑叶）
	desc = "一个穿蓝色裙子的高个子人型异想体. \
	她的头有一半是黑色的，有尖锐的角段突出来."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "despair"
	icon_living = "despair"
	icon_dead = "despair_dead"
	core_icon = "despair_egg"
	portrait = "despair_knight"
	pixel_x = -8
	base_pixel_x = -8
	ranged = TRUE
	ranged_cooldown_time = 3 SECONDS
	minimum_distance = 2
	maxHealth = 800
	health = 800
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.0, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.5)
	stat_attack = HARD_CRIT
	del_on_death = FALSE
	death_sound = 'sound/abnormalities/despairknight/dead.ogg'
	threat_level = WAW_LEVEL
	can_patrol = FALSE
	can_breach = TRUE
	start_qliphoth = 1
	move_to_delay = 4

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 55, 55, 60),
		ABNORMALITY_WORK_REPRESSION = list(40, 40, 40, 35, 30),
	)
	work_damage_upper = 6
	work_damage_lower = 4
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gloom

	ego_list = list(
		/datum/ego_datum/weapon/despair,
		/datum/ego_datum/armor/despair,
	)
	gift_type =  /datum/ego_gifts/tears
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/wrath_servant = 2,
		/mob/living/simple_animal/hostile/abnormality/hatred_queen = 2,
		/mob/living/simple_animal/hostile/abnormality/greed_king = 2,
		/mob/living/simple_animal/hostile/abnormality/nihil = 1.5,
	)

	observation_prompt = "我曾为世间正义献身，守护我的国王、王国与弱者。<br>\
		然而最终，我未能守护住任何事物。<br>即便如此...我仍想守护某人，任何人..."
	observation_choices = list(
		"拒绝" = list(TRUE, "我不再被需要了吗？<br>\
			不...<br>你是说我该继续前行。<br>不知能否做到，但或许情况会好转。<br>我们只需尝试。"),
		"接受她的祝福" = list(FALSE, "谢谢你，尽管我只是个可悲的骑士，我仍渴望守护。若无法保护他人，我不如消失..."),
	)

	work_start_lines = list("%ABNO有时会无助地流泪，不愿和%PERSON说话.")
	middle_work_lines = list("%ABNO沉浸在她的过去，就同她的姐妹一样.")

	var/mob/living/carbon/human/blessed_human = null
	var/teleport_cooldown
	var/teleport_cooldown_time = 20 SECONDS
	var/swords = 0
	var/can_act = TRUE
	var/special_breach = FALSE

/mob/living/simple_animal/hostile/abnormality/despair_knight/ZeroQliphoth(mob/living/carbon/human/user)
	switch(swords)
		if(0)
			add_overlay(mutable_appearance('ModularTegustation/Teguicons/48x48.dmi', "despair_sword1", -ABOVE_MOB_LAYER))
			playsound(get_turf(src), 'sound/abnormalities/despairknight/attack.ogg', 50, 0, 4)
			datum_reference.qliphoth_change(1)
		if(1)
			add_overlay(mutable_appearance('ModularTegustation/Teguicons/48x48.dmi', "despair_sword2", -ABOVE_MOB_LAYER))
			playsound(get_turf(src), 'sound/abnormalities/despairknight/attack.ogg', 50, 0, 4)
			datum_reference.qliphoth_change(1)
		else
			cut_overlays()
			if(blessed_human)
				BlessedDeath()
			else
				BreachEffect()
			return
	swords += 1

/mob/living/simple_animal/hostile/abnormality/despair_knight/AttackingTarget(atom/attacked_target)
	if(!target)
		GiveTarget(attacked_target)
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/despair_knight/OpenFire()
	if(!can_act)
		return FALSE
	if(ranged_cooldown > world.time)
		return FALSE
	ranged_cooldown = world.time + ranged_cooldown_time
	for(var/i = 1 to 4)
		var/turf/T = get_step(get_turf(src), pick(1,2,4,5,6,8,9,10))
		if(T.density)
			i -= 1
			continue
		new /obj/effect/projectile_delayed(T, target, src, /obj/projectile/despair_rapier, 3)
	SLEEP_CHECK_DEATH(3)
	playsound(get_turf(src), 'sound/abnormalities/despairknight/attack.ogg', 50, 0, 4)
	return

/mob/living/simple_animal/hostile/abnormality/despair_knight/Life()
	. = ..()
	if(.)
		if(!client)
			if(teleport_cooldown <= world.time)
				TryTeleport()

/mob/living/simple_animal/hostile/abnormality/despair_knight/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(CoreAnimation)), 5 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/despair_knight/proc/CoreAnimation()
	pixel_x = -16
	base_pixel_x = -16
	icon = 'ModularTegustation/Teguicons/abno_cores/waw.dmi'
	icon_state = core_icon
	animate(src, alpha = 255, time = 0)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/despair_knight/proc/BlessedDeath(datum/source, gibbed)
	SIGNAL_HANDLER
	blessed_human.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "despair", -MUTATIONS_LAYER))
	UnregisterSignal(blessed_human, COMSIG_LIVING_DEATH)
	UnregisterSignal(blessed_human, COMSIG_HUMAN_INSANE)
	blessed_human.physiology.red_mod /= 0.5
	blessed_human.physiology.white_mod /= 0.5
	blessed_human.physiology.black_mod /= 0.5
	blessed_human.physiology.pale_mod /= 2
	blessed_human.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, 50)
	blessed_human = null
	BreachEffect()
	return TRUE

/mob/living/simple_animal/hostile/abnormality/despair_knight/proc/TryTeleport()
	if(IsCombatMap())
		return FALSE
	if(teleport_cooldown > world.time)
		return FALSE
	if(special_breach)
		return
	if(target) // Actively fighting
		return FALSE
	teleport_cooldown = world.time + teleport_cooldown_time
	var/targets_in_range = 0
	for(var/mob/living/L in view(10, src))
		if(!faction_check_mob(L) && L.stat != DEAD && !(L.status_flags & GODMODE))
			targets_in_range += 1
	if(targets_in_range >= 3)
		return FALSE
	var/list/teleport_potential = list()
	for(var/turf/T in GLOB.department_centers)
		var/targets_at_tile = 0
		for(var/mob/living/L in view(10, T))
			if(!faction_check_mob(L) && L.stat != DEAD)
				targets_at_tile += 1
		if(targets_at_tile >= 2)
			teleport_potential += T
	if(!LAZYLEN(teleport_potential))
		return FALSE
	var/turf/teleport_target = pick(teleport_potential)
	animate(src, alpha = 0, time = 5)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	SLEEP_CHECK_DEATH(5) // TODO: Add some cool effects here
	animate(src, alpha = 255, time = 5)
	if(special_breach)
		return
	new /obj/effect/temp_visual/guardian/phase/out(teleport_target)
	forceMove(teleport_target)

/mob/living/simple_animal/hostile/abnormality/despair_knight/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(user.stat != DEAD && !blessed_human && istype(user) && (work_type == ABNORMALITY_WORK_ATTACHMENT))
		blessed_human = user
		RegisterSignal(user, COMSIG_LIVING_DEATH, PROC_REF(BlessedDeath))
		RegisterSignal(user, COMSIG_HUMAN_INSANE, PROC_REF(BlessedDeath))
		to_chat(user, span_nicegreen("你感觉被保护了."))
		user.physiology.red_mod *= 0.5
		user.physiology.white_mod *= 0.5
		user.physiology.black_mod *= 0.5
		user.physiology.pale_mod *= 2
		user.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "despair", -MUTATIONS_LAYER))
		playsound(get_turf(user), 'sound/abnormalities/despairknight/gift.ogg', 50, 0, 2)
		user.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, -50)
	return

/mob/living/simple_animal/hostile/abnormality/despair_knight/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	if(special_breach)
		return TRUE
	icon_living = "despair_breach"
	icon_state = icon_living
	addtimer(CALLBACK(src, PROC_REF(TryTeleport)), 5)
	return

/mob/living/simple_animal/hostile/abnormality/despair_knight/Move()
	if(!can_act)
		return FALSE
	return ..()

// Jester of nihil event code
/mob/living/simple_animal/hostile/abnormality/despair_knight/proc/EventStart()
	set waitfor = FALSE
	AIStatus = AI_OFF
	EventIcons()
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
	special_breach = TRUE
	SLEEP_CHECK_DEATH(24 SECONDS)
	icon_state = "despair_breach"
	name = "凝固的绝望"
	ADD_TRAIT(src, TRAIT_NOBLEED, MAGIC_TRAIT)
	pixel_x = -4
	base_pixel_x = -4
	var/newcolor = list(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	add_atom_colour(newcolor, FIXED_COLOUR_PRIORITY)
	status_flags |= GODMODE
	environment_smash = ENVIRONMENT_SMASH_NONE
	dir = SOUTH
	update_icon()

/mob/living/simple_animal/hostile/abnormality/despair_knight/proc/EventIcons()
	name = "正义之魔法少女"
	desc = "一位真正的魔法少女!"
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "despair_friendly"
	pixel_x = -8
	base_pixel_x = -8
	fear_level = 0
	faction = list("neutral")
