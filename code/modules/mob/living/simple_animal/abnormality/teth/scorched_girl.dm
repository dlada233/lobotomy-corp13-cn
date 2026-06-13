/mob/living/simple_animal/hostile/abnormality/scorched_girl
	name = "焦化少女"
	desc = "像被烧成灰烬的女孩的畸形物. \
	即使没有任何东西可以燃烧，火仍然没有熄灭."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "scorched"
	icon_living = "scorched"
	core_icon = "scorch_egg"
	portrait = "scorched_girl"
	maxHealth = 120
	health = 120
	threat_level = TETH_LEVEL
	stat_attack = HARD_CRIT
	ranged = TRUE
	vision_range = 12
	aggro_vision_range = 24
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = list(60, 60, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(30, 15, 0, -40, -50),
		ABNORMALITY_WORK_REPRESSION = list(50, 50, 40, 40, 40),
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/envy
	max_boxes = 12
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 2, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	faction = list("hostile")
	can_breach = TRUE
	start_qliphoth = 2

	ego_list = list(
		/datum/ego_datum/weapon/match,
		/datum/ego_datum/armor/match,
	)
	gift_type =  /datum/ego_gifts/match
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "我以为很冷。\
		甚至没意识到就变暖了。钉在心脏上的火柴不停燃烧。\
		从未点燃过的火柴现在烧成了灰烬。也许这就是占据我身体的代价，如此明亮而炽烈地燃烧。\
		趁还能燃烧时奔跑吧。我一直在受苦，并将继续受苦。但为何你仍如此快乐？\
		我知道自己已成威胁。如果一切都不会改变，我至少想看到你受苦."
	observation_choices = list(
		"不要靠近她" = list(TRUE, "我停下了脚步，能看见远处的她. \
			\"也许你以为我是某种灯塔.\" \
			\"至少，我希望你能明白，当火焰将我全部吞噬后，留下的只有我的灰烬.\""),
		"靠近她" = list(FALSE, "来到我身边吧. \
			你很快也会像我一样化为灰烬."),
	)

	/// Restrict movement when this is set to TRUE
	var/exploding = FALSE
	/// Current cooldown for the players
	var/boom_cooldown
	/// Amount of RED damage done on explosion
	var/boom_damage = 300
	patrol_cooldown_time = 10 SECONDS //Scorched be zooming

/datum/action/innate/change_icon_scorch/Deactivate()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		owner.icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
		owner.icon_state = "scorched_breach"
		active = 0

/mob/living/simple_animal/hostile/abnormality/scorched_girl/patrol_select()
	var/turf/target_center
	var/highestcount = 0
	for(var/turf/T in GLOB.department_centers)
		var/targets_at_tile = 0
		for(var/mob/living/L in ohearers(10, T))
			if(!faction_check_mob(L) && L.stat != DEAD)
				targets_at_tile++
		if(targets_at_tile > highestcount)
			target_center = T
			highestcount = targets_at_tile
	if(!target_center)
		..()
	else
		patrol_path = get_path_to(src, target_center, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)

/mob/living/simple_animal/hostile/abnormality/scorched_girl/OpenFire()
	if(client)
		explode()
		return

	var/amount_inview = 0
	for(var/mob/living/carbon/human/H in ohearers(7, src))
		if(!faction_check_mob(H) && H.stat != DEAD)
			amount_inview += 1
	if(prob(amount_inview*20))
		explode()

/mob/living/simple_animal/hostile/abnormality/scorched_girl/Move()
	if(exploding)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/scorched_girl/CanAttack(atom/the_target)
	if(..())
		if(ishuman(the_target))
			return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/scorched_girl/AttackingTarget(atom/attacked_target)
	if(client)
		explode()
		return
	var/amount_inview = 0
	for(var/mob/living/carbon/human/H in ohearers(7, src))
		if(!faction_check_mob(H) && H.stat != DEAD)
			amount_inview += 1
	if(prob(amount_inview * 20))
		explode()
	return

/mob/living/simple_animal/hostile/abnormality/scorched_girl/proc/explode()
	if(boom_cooldown > world.time) // That's only for players
		return
	boom_cooldown = world.time + 3 SECONDS
	playsound(get_turf(src), 'sound/abnormalities/scorchedgirl/pre_ability.ogg', 50, 0, 2)
	if(client)
		if(!do_after(src, 1.5 SECONDS, target = src))
			return
	else
		SLEEP_CHECK_DEATH(1.5 SECONDS)
	exploding = TRUE
	playsound(get_turf(src), 'sound/abnormalities/scorchedgirl/ability.ogg', 60, 0, 4)
	SLEEP_CHECK_DEATH(3 SECONDS)
	// Ka-boom
	playsound(get_turf(src), 'sound/abnormalities/scorchedgirl/explosion.ogg', 125, 0, 8)
	for(var/mob/living/carbon/human/H in view(7, src))
		H.deal_damage(boom_damage, RED_DAMAGE)
		H.deal_damage(boom_damage * 0.5, FIRE)
		if(H.health < 0)
			H.gib()
	new /obj/effect/temp_visual/explosion(get_turf(src))
	var/datum/effect_system/smoke_spread/S = new
	S.set_up(7, get_turf(src))
	S.start()
	qdel(src)
	return

/mob/living/simple_animal/hostile/abnormality/scorched_girl/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/scorched_girl/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/scorched_girl/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	boom_cooldown = world.time + 5 SECONDS // So it doesn't instantly explode
	update_icon()
	GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/scorched_girl/update_icon_state()
	if(status_flags & GODMODE) // Not breaching
		icon_state = initial(icon)
	else // Breaching
		icon_state = "scorched_breach"
	icon_living = icon_state


