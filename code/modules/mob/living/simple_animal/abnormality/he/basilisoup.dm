// Abnormality sprited by Mel Taculo
/mob/living/simple_animal/hostile/abnormality/basilisoup
	name = "一辈子汤"
	desc = "一种巨大的鸟或蜥蜴，以锅为头，从皮肤里渗出汤."
	icon = 'ModularTegustation/Teguicons/96x48.dmi'
	icon_state = "basilisoup"
	icon_living = "basilisoup"
	portrait = "basilisoup"
	pixel_x = -32
	base_pixel_x = -32
	maxHealth = 520 // Quite high HP
	health = 520
	move_to_delay = 4 //High range, and thus slow
	rapid_melee = 1
	melee_reach = 2 // Long neck = long range
	ranged = TRUE
	threat_level = HE_LEVEL
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5, FIRE = 0.6)
	melee_damage_lower = 5
	melee_damage_upper = 8
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/mountain/bite.ogg'
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 30,
		ABNORMALITY_WORK_INSIGHT = 30,
		ABNORMALITY_WORK_ATTACHMENT = 30,
		ABNORMALITY_WORK_REPRESSION = 10,
	)
	work_damage_upper = 6
	work_damage_lower = 3
	work_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/lust

	ego_list = list(
		/datum/ego_datum/armor/lifestew,
		/datum/ego_datum/weapon/lifestew_lance,
		/datum/ego_datum/weapon/lifestew
	)
	gift_type = /datum/ego_gifts/lifestew
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	observation_prompt = "我面前是一口铜制汤锅，旁边放着一把木勺。我往锅里一看，只见水和一块孤零零的石头，正从明火上沸腾翻滚."
	observation_choices = list(
		"尝一口汤" = list(TRUE, "我拿起木勺，喝了一口汤，味道难以形容地好。这确实是一种魔法."),
		"把它打翻" = list(FALSE, "锅在地板上翻滚，水和一块石头覆盖了整个地面。从石头里煮汤？荒谬至极."),
	)

	var/spit_cooldown
	var/spit_cooldown_time = 12 SECONDS
	var/can_act = TRUE
	/// Actually it fires this amount thrice, so, multiply it by 3 to get actual amount
	var/spit_amount = 9
	/// Stolen charge code from KOG
	var/charging = FALSE
	/// the length of the dash, in tiles
	var/charge_num = 10
	var/dash_cooldown = 0
	var/dash_cooldown_time = 8 SECONDS
	/// Damage dealt with a charge hit, this is intentionally a bit on the low side
	var/charge_damage = 15
	/// Those hit by the charge won't be hit again by the same charge
	var/list/been_hit = list()
	/// The soup connected to us
	var/obj/structure/basilisoup_pot/connected_soup = null

	attack_action_types = list(
		/datum/action/innate/abnormality_attack/Spit,
		/datum/action/innate/abnormality_attack/Charge,
	)

// Player-Controlled code
/datum/action/innate/abnormality_attack/Spit
	name = "汤吐"
	button_icon_state = "soupspit"
	chosen_message = span_colossus("你现在会在攻击时吐出胃里的东西.")
	chosen_attack_num = 1

/datum/action/innate/abnormality_attack/Charge
	name = "冲锋"
	button_icon_state = "wrath_dash"
	chosen_message = span_colossus("你现在可以在攻击时冲锋.")
	chosen_attack_num = 2

/mob/living/simple_animal/hostile/abnormality/basilisoup/Destroy()
	connected_soup = null
	return ..()

//Spawning
/mob/living/simple_animal/hostile/abnormality/basilisoup/PostSpawn()
	. = ..()
	if(IsCombatMap())
		return
	animate(src, alpha = 0, time = 0 SECONDS) //We hide until we actually breach
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	density = FALSE
	var/soup_located = locate(/obj/structure/basilisoup_pot) in datum_reference.connected_structures
	if(soup_located)
		connected_soup = soup_located

/mob/living/simple_animal/hostile/abnormality/basilisoup/HandleStructures()
	. = ..()
	if(!.)
		return
	if(!locate(/obj/structure/basilisoup_pot) in datum_reference.connected_structures)
		connected_soup = SpawnConnectedStructure(/obj/structure/basilisoup_pot, 0, 1)

// Work Mechanics
/mob/living/simple_animal/hostile/abnormality/basilisoup/AttemptWork(mob/living/carbon/human/user, work_type)
	switch(connected_soup.soup_level)
		if(1 to 50)
			connected_soup.AdjustSoupLevels(-10)
		if(51 to 100)
			connected_soup.AdjustSoupLevels(-15)

	if(connected_soup.poisoned)
		animate(src, alpha = 255, time = 3 SECONDS)
		density = TRUE
		INVOKE_ASYNC(src, PROC_REF(Spit), user)	// Guaranteed death for lower level agents

	return ..()

/mob/living/simple_animal/hostile/abnormality/basilisoup/WorkChance(mob/living/carbon/human/user, chance)
	switch(connected_soup.soup_level)
		if(1 to 50)
			chance += 15

		if(51 to 100)
			chance += 20

	if(connected_soup.poisoned) // Not a good time
		chance -= 50

	return chance

/mob/living/simple_animal/hostile/abnormality/basilisoup/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	. = ..()
	if(connected_soup.soup_level == 0)
		datum_reference.qliphoth_change(-1)

	if(connected_soup.poisoned)
		datum_reference.qliphoth_change(-1)

	if(connected_soup.soup_level > 50)
		var/obj/item/food/lifestew_glob/thesoup = new(get_turf(src))
		thesoup.throw_at(user, 3, 3)

/mob/living/simple_animal/hostile/abnormality/basilisoup/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

//Breach
/mob/living/simple_animal/hostile/abnormality/basilisoup/BreachEffect()
	. = ..()
	animate(src, alpha = 255, time = 3 SECONDS)
	density = TRUE
	mouse_opacity = MOUSE_OPACITY_ICON

/mob/living/simple_animal/hostile/abnormality/basilisoup/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return
	. = ..()
	if(ishuman(attacked_target))
		var/mob/living/carbon/human/H = attacked_target
		if(H.nutrition >= NUTRITION_LEVEL_FAT)
			playsound(get_turf(src), 'sound/abnormalities/bigbird/bite.ogg', 50, 1, 2)
			H.gib()
			adjustBruteLoss(-maxHealth, forced = TRUE) //full heal after a full meal

/mob/living/simple_animal/hostile/abnormality/basilisoup/OpenFire(atom/A)
	if(!can_act)
		return
	if(client)
		switch(chosen_attack)
			if(1)
				Spit(target)
			if(2)
				if(dash_cooldown <= world.time)
					dash_cooldown = world.time + dash_cooldown_time
					var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
					can_act = FALSE
					charge(dir_to_target, 0, target)
		return
	var/dist = get_dist(target, src)
	if(dash_cooldown <= world.time)
		var/chance_to_dash = 25
		if(dist > 6)
			chance_to_dash = 100
		if(prob(chance_to_dash) && dash_cooldown <= world.time)
			dash_cooldown = world.time + dash_cooldown_time
			var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
			can_act = FALSE
			charge(dir_to_target, 0, target)
			return
	if(spit_cooldown <= world.time && dist < 7)
		Spit(target)

//Spit Attack
/mob/living/simple_animal/hostile/abnormality/basilisoup/proc/Spit(atom/target)
	if(spit_cooldown > world.time)
		return
	can_act = FALSE
	visible_message(span_danger("[src] prepares to spit at [target]!"))
	playsound(get_turf(src), 'sound/abnormalities/basilisoup/spit1.ogg', 120, 1, 3)
	icon_state = "basilisoup_prepare"
	SLEEP_CHECK_DEATH(20)
	icon_state = "basilisoup"
	spit_cooldown = world.time + spit_cooldown_time
	playsound(get_turf(src), 'sound/abnormalities/basilisoup/spit2.ogg', 75, 1, 3)
	for(var/k = 1 to 3)
		var/turf/startloc = get_turf(targets_from)
		for(var/i = 1 to spit_amount)
			var/obj/projectile/lifestew_spit/P = new(get_turf(src))
			P.starting = startloc
			P.firer = src
			P.fired_from = src
			P.yo = target.y - startloc.y
			P.xo = target.x - startloc.x
			P.original = target
			P.preparePixelProjectile(target, src)
			P.fire()
		SLEEP_CHECK_DEATH(2)
	can_act = TRUE

//Charge - Deals low damage but is fast
/mob/living/simple_animal/hostile/abnormality/basilisoup/proc/charge(move_dir, times_ran, target)
	setDir(move_dir)
	var/stop_charge = FALSE
	if(times_ran >= charge_num)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		been_hit = list()
		stop_charge = TRUE
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			stop_charge = TRUE
	for(var/mob/living/simple_animal/hostile/abnormality/D in T.contents)	//This caused issues earlier
		if(D.density)
			stop_charge = TRUE

	//Stop charging
	if(stop_charge)
		can_act = TRUE
		been_hit = list()
		return
	forceMove(T)

	for(var/turf/U in range(1, T))
		var/list/new_hits = HurtInTurf(U, been_hit, 0, BLACK_DAMAGE, hurt_mechs = TRUE) - been_hit
		been_hit += new_hits
		for(var/mob/living/L in new_hits)
			var/atom/throw_target = get_edge_target_turf(L, get_dir(L, get_step_away(L, get_turf(src))))
			L.visible_message(span_boldwarning("[src]猛烈撞击[L]!"), span_userdanger("[src]用牙齿和爪子撕碎了你!"))
			playsound(L, 'sound/weapons/genhit2.ogg', 75, 1)
			new /obj/effect/temp_visual/kinetic_blast(get_turf(L))
			L.deal_damage(charge_damage, BLACK_DAMAGE)
			L.throw_at(throw_target, 3, 2)
			for(var/obj/vehicle/V in new_hits)
				V.take_damage(charge_damage, BLACK_DAMAGE, attack_sound)
				V.visible_message(span_boldwarning("[src] crunches [V]!"))
				playsound(V, 'sound/weapons/genhit2.ogg', 75, 1)
			continue

	playsound(src,'sound/effects/bamf.ogg', 40, TRUE, 20)
	for(var/turf/open/R in range(1, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(R)
	addtimer(CALLBACK(src, PROC_REF(charge), move_dir, (times_ran + 1)), 2)

/mob/living/simple_animal/hostile/abnormality/basilisoup/Move(turf/newloc, dir, step_x, step_y)
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/basilisoup/CanAttack(atom/the_target)
	if(!can_act)
		return FALSE
	return ..()

// Objects - Structures
/obj/structure/basilisoup_pot
	name = "汤锅"
	desc = "在一个相当大的热源上盛满的锅."
	icon = 'icons/obj/fireplace.dmi'
	icon_state = "basilisoup"
	pixel_x = -16
	base_pixel_x = -16
	anchored = TRUE
	density = TRUE
	layer = ABOVE_OBJ_LAYER
	resistance_flags = INDESTRUCTIBLE
	can_buckle = TRUE
	var/soup_level = 0
	var/poisoned = FALSE
	var/list/valid_types = list(
		/obj/item/food,
		/obj/item/grown,
		/obj/item/seeds,
		/obj/item/organ,
		/obj/item/bodypart,
		/obj/item/toy/plush, //It's funny
		/obj/item/clothing/mask/facehugger/bongy,
	)
	var/list/verboten_types = list(
		/obj/item/food/lifestew_glob,
		/obj/item/food/salad/lifestew,
	)
	var/list/rawfood = list( //"Technically edible" foodstuffs that are converted to soup
		/datum/reagent/consumable/nutriment/organ_tissue,
		/datum/reagent/consumable/nutriment/vile_fluid,
	)

/obj/structure/basilisoup_pot/examine(mob/user)
	. = ..()
	if(soup_level)
		. += span_notice("看起来[soup_level]%满.")
		. += span_notice("如果有足够的汤，你可以用碗舀一碗，或者洒出有害的内容.")

/obj/structure/basilisoup_pot/update_overlays()
	. = ..()
	switch(soup_level)
		if(0)

		if(1 to 49)
			. += "soup_1"

		if(50 to 99)
			. += "soup_2"

		if(100)
			. += "soup_3"

/obj/structure/basilisoup_pot/proc/add_food(obj/item/wack, mob/user)
	if(!is_type_in_list(wack, valid_types))
		to_chat(user, span_notice("这不能放进汤里!"))
		return
	if(soup_level >= 100)
		to_chat(user, span_notice("汤锅已经装不下了!"))
		return
	if(is_type_in_list(wack, verboten_types))
		to_chat(user, span_notice("把旧汤倒回锅里让你感到不安。这太不卫生了!"))
		return
	if(istype(wack, /obj/item/toy/plush))
		to_chat(user, span_notice("你将[wack]投入一辈子汤。它沉入锅底，再无踪迹。"))
		AdjustSoupLevels(1)
		var/obj/item/toy/plush/deadplushie = wack
		var/datum/component/squeak/squeaky = deadplushie.GetComponent(/datum/component/squeak)
		if(squeaky)
			squeaky.play_squeak()
		else
			playsound(src, 'sound/effects/bubbles.ogg', 80, TRUE, -3)
		qdel(wack)
		return
	if(istype(wack, /obj/item/food))
		var/obj/item/food/THEFOODITEM = wack
		var/list/cookable_stuff = list()
		cookable_stuff += rawfood
		cookable_stuff += subtypesof(/datum/reagent/consumable)
		var/list/nasty_stuff = typesof(/datum/reagent/toxin)
		var/list/cached_reagents = THEFOODITEM.reagents.reagent_list
		for(var/_reagent in cached_reagents)
			var/datum/reagent/R = _reagent
			var/reagent_amount = 0
			reagent_amount = round(R.volume, 0.0001)
			if(is_type_in_list(R, nasty_stuff))
				poisoned = TRUE //uh oh...
				AdjustSoupLevels(reagent_amount)
			if(is_type_in_list(R, cookable_stuff))
				AdjustSoupLevels(reagent_amount)
	else
		AdjustSoupLevels(rand(1, 3))
	to_chat(user, span_notice("你将[wack]投入一辈子汤."))
	qdel(wack)
	playsound(src, 'sound/effects/bubbles.ogg', 80, TRUE, -3)


/obj/structure/basilisoup_pot/proc/dump_soup(obj/item/object, mob/user)
	if(!object)
		to_chat(user, span_notice("如果你使用碗应该可以舀起一些汤."))
		return

	qdel(object)
	AdjustSoupLevels(-20)
	to_chat(user, span_notice("你舀起一些汤."))
	var/obj/item/food/salad/lifestew/thesoup = new(get_turf(user))
	if(poisoned) //Poisoned soup has added spewum to make you puke
		thesoup.reagents.add_reagent(/datum/reagent/toxin/spewium, 5)

/obj/structure/basilisoup_pot/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if(soup_level >= 20 && user.a_intent == INTENT_HELP)
		dump_soup(null, user)
		return

	if(soup_level == 0)
		return

	switch(alert("要清空汤锅吗?","浪费食物?","是","否"))
		if("是")
			AdjustSoupLevels(-soup_level)
			to_chat(usr, span_notice("你把汤全倒在地板上!"))
			playsound(get_turf(src), 'sound/effects/splat.ogg', 50, TRUE)

		if("否")
			to_chat(usr, span_notice("你决定不浪费食物."))

/obj/structure/basilisoup_pot/attackby(obj/item/object, mob/user, params)
	if(istype(object, /obj/item/reagent_containers/glass/bowl))
		if(soup_level >= 20)
			dump_soup(object, user)
		return
	if(add_food(object, user))
		return
	return ..()

/obj/structure/basilisoup_pot/proc/AdjustSoupLevels(addition)
	soup_level = clamp(soup_level + addition, 0, 100)
	if(soup_level == 0) //Dumped all the poison out
		poisoned = FALSE
	update_icon()

/obj/structure/basilisoup_pot/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if(M == user)
		return

	if(!ishostile(M) && !ishuman(M))
		to_chat(user, span_warning("你还没饿到想吃[M]的程度."))
		return

	if(soup_level == 100)
		to_chat(user, span_notice("汤锅已经装不下了!"))
		return

	if(M.stat != DEAD)
		to_chat(user, span_warning("怎能如此残忍？[M]还活着!"))
		return

	to_chat(user, span_warning("你开始将[M]拖向汤锅."))
	if(!do_after(user, 4 SECONDS, M)) //If you're going to throw someone else, they have to be dead first.
		to_chat(user, span_warning("你放弃了将[M]投入汤锅的念头."))

	to_chat(user, span_notice("你将[M]抛入汤锅! 何等野蛮!"))
	buckle_mob(M, check_loc = check_loc)

/obj/structure/basilisoup_pot/post_buckle_mob(mob/living/carbon/human/soup_sacrifice)
	if(istype(soup_sacrifice))
		AdjustSoupLevels(25)
	else
		AdjustSoupLevels(15)

	qdel(soup_sacrifice)
	playsound(src, 'sound/abnormalities/bloodbath/Bloodbath_EyeOn.ogg', 80, FALSE, -3)
	var/list/water_area = range(1, src)
	for(var/turf/open/O in water_area)
		var/obj/effect/particle_effect/water/soupeffect = new(O)
		soupeffect.color = "#622F22"
	return ..()

//The stars of the show
/obj/item/food/lifestew_glob
	name = "一辈子汤凝块"
	desc = "据说熬煮终生的浓汤，其稠度足以维持形态。尽管成分存疑，却散发着诱人香气."
	icon = 'icons/obj/food/soupsalad.dmi'
	icon_state = "lifetime_stew_chunk"
	food_reagents = list(/datum/reagent/consumable/lifestew = 3)
	tastes = list("the best soup you ever tasted" = 1)
	foodtypes = GRAIN | MEAT | VEGETABLES

/obj/item/food/salad/lifestew
	name = "一辈子汤"
	desc = "据说熬煮终生的汤品，碗底可见一块石头。成分虽可疑，但香气令人垂涎。"
	icon_state = "lifetime_stew"
	food_reagents = list(/datum/reagent/consumable/lifestew = 5)
	tastes = list("the best soup you ever tasted" = 1)
	foodtypes = GRAIN | MEAT | VEGETABLES

//The chemical
/datum/reagent/consumable/lifestew
	name = "一辈子汤"
	description = "完全无法辨识的浓稠美味汤羹。"
	nutriment_factor = 20 * REAGENTS_METABOLISM //Hyper fattening
	var/health_restore = 5 // % of health restored per tick. For reference, Salicylic Acid is 4. Set to negative and it'll hurt!
	var/sanity_restore = 3 // % of sanity restored per tick. For reference, Mental Stabilizator is 5. Set to negative and it'll hurt!

/datum/reagent/consumable/lifestew/on_mob_life(mob/living/L)
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	H.adjustBruteLoss(-health_restore*REAGENTS_EFFECT_MULTIPLIER)
	H.adjustSanityLoss(-sanity_restore*REAGENTS_EFFECT_MULTIPLIER)
	return ..()
