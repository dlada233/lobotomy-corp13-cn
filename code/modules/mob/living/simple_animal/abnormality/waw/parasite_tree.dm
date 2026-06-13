#define THE_LIARS_BLESSING /datum/status_effect/display/parasite_tree_blessing
#define THE_TREE_CURSE /datum/status_effect/display/parasite_tree_curse

//Ive somehow created a system that connects several entities together by using locate. Im unsure if this fragile system
//is better than using global values. Evidence is leaning towards yes.

/mob/living/simple_animal/hostile/abnormality/parasite_tree
	name = "寄生树"
	desc = "一棵绿色的树皮树，树干中央嵌着一张平静的脸，它散发出一种宁静的气氛."
	icon = 'ModularTegustation/Teguicons/128x128.dmi'
	icon_state = "parasitetreeshine"
	icon_living = "parasitetreeshine"
	portrait = "parasite_tree"
	maxHealth = 1200
	health = 1200
	pixel_x = -48
	base_pixel_x = -48
	pixel_y = -10
	base_pixel_y = -10
	start_qliphoth = 5
	wander = 0
	can_patrol = FALSE
	threat_level = WAW_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 45,
		ABNORMALITY_WORK_INSIGHT = list(40, 40, 40, 45, 45),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 50, 50, 55),
		ABNORMALITY_WORK_REPRESSION = 20,
	)
	work_damage_upper = 6
	work_damage_lower = 5
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/sloth
	max_boxes = 24

	ego_list = list(
		/datum/ego_datum/weapon/hypocrisy,
		/datum/ego_datum/armor/hypocrisy,
	)

	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY
	gift_type =  /datum/ego_gifts/hypocrisy
	gift_message = "你的耳朵似乎变长了，真奇怪。"

	observation_prompt = "收容单元内植物疯长，尽管人造的地板和墙壁本不可能维持生命。<br>\
	在这片微型森林中央，你看到一棵葱郁大树，枝头硕果累累，树干上浮现安详面容。<br>\
	\"你好，你也是来接受祝福的吗？\"<br>\
	声音随风而来(明明没有风)带着甜美花香问道：\"我只想帮助大家，能把你的朋友们也带来吗？\""
	observation_choices = list(
		"接受祝福但拒绝要求" = list(TRUE, "\"坏孩子，我不需要你这样的人。\"<br>\
			祝福应当是自愿接受的，而并非是一种要求，<br>你离开收容室，暗自得意。"),
		"拒绝祝福" = list(FALSE, "\"若说你从不需要他人祝福，那便是谎言。\"树深深皱眉。<br>\
			\"...若不需要我的祝福，你就是坏人。<br>\
			这里没有你要的东西，离开吧。\"<br>\
			你离开葱郁的收容单元，树继续等待下一个落入陷阱者。"),
		"接受祝福并照做" = list(FALSE, "你找来最信任的同事们。<br>\
			\"跟我来，有好东西给你们看\"，你带他们来到树前，树干上仍是那副安详面容。<br>\
			\"好孩子，谢谢你带来这些孩子。\"<br>\
			当你们痴迷地望着即将绽放的花苞时，它说：\"让我赐予你们一些礼物...\"<br>\
			我感觉体内有什么东西正在萌发..."),
	)

	var/origin_cooldown = 0 //null when compared to numbers is a eldritch concept so world.time cannot be more or less.
	var/static/list/blessed = list() //keeps track of status effected individuals
	var/static/list/minions = list() //keeps track of minions if suppressed forcefully

/mob/living/simple_animal/hostile/abnormality/parasite_tree/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, PROC_REF(dropLeaf))

/mob/living/simple_animal/hostile/abnormality/parasite_tree/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(work_type != ABNORMALITY_WORK_REPRESSION && user.stat != DEAD)
		if(user.has_status_effect(THE_LIARS_BLESSING))
			var/mob/living/carbon/human/witness = locate(/mob/living/carbon/human) in livinginview(1, src) //included mostly for lore since you encourage people to use it.
			if(witness && !witness.has_status_effect(THE_LIARS_BLESSING))
				witness.apply_status_effect(THE_LIARS_BLESSING)
				to_chat(witness, span_notice("[src]周围的空气让你感到平静."))
		else if(datum_reference.qliphoth_meter <= 0)
			user.apply_status_effect(THE_TREE_CURSE)
		else
			user.apply_status_effect(THE_LIARS_BLESSING)
			if(prob(5))
				to_chat(user, span_notice("你听到一个声音，让你把需要帮助的人带到这里来."))
		return
	if(datum_reference.qliphoth_meter <= 4)
		if(canceled || pe < datum_reference.neutral_boxes)
			to_chat(user, span_notice("靠近[src]让你感到神清气爽."))
			if(datum_reference.qliphoth_meter >= 1)
				user.apply_status_effect(THE_LIARS_BLESSING)
			else
				user.apply_status_effect(THE_TREE_CURSE)
			return ..()
		if(locate(THE_TREE_CURSE) in blessed)
			resetQliphoth()
			for(var/datum/status_effect/display/parasite_tree_curse/curse in blessed)
				qdel(curse)
			to_chat(user, span_nicegreen("当你粉碎[src]的花朵时，猩红的眼睛闭上了."))
			return ..()
		to_chat(user, span_notice("当你摧毁花苞时，[src]沉默伫立."))
		resetQliphoth()
	return ..()

/mob/living/simple_animal/hostile/abnormality/parasite_tree/ZeroQliphoth(mob/living/carbon/human/user)
	if(blessed.len > 0)
		cut_overlays()
		var/mutable_appearance/colored_overlay = mutable_appearance(icon, "parasitetreeeye", layer + 0.1)
		add_overlay(colored_overlay)
		icon_state = "parasitetreeshine_purple"
		for(var/datum/status_effect/display/parasite_tree_blessing/P in blessed)
			P.facadeFalls()
	else
		datum_reference.qliphoth_change(1)

/mob/living/simple_animal/hostile/abnormality/parasite_tree/OnQliphothChange(mob/living/carbon/human/user)
	cut_overlays()
	var/budlayer = layer + 0.1
	var/budtype
	switch(datum_reference.qliphoth_meter)
		if(1)
			budtype = "buds4"
		if(2)
			budtype = "buds3"
		if(3)
			budtype = "buds2"
		if(4)
			budtype = "buds1"
		else
			return
	var/mutable_appearance/colored_overlay = mutable_appearance(icon, budtype, budlayer)
	add_overlay(colored_overlay)

/mob/living/simple_animal/hostile/abnormality/parasite_tree/proc/resetQliphoth()
	icon_state = "parasitetreeshine"
	datum_reference.qliphoth_change(6)

/mob/living/simple_animal/hostile/abnormality/parasite_tree/proc/endBreach()
	if(locate(THE_LIARS_BLESSING) in blessed)
		for(var/datum/status_effect/display/parasite_tree_blessing/P in blessed)
			P.facadeFalls()
		return FALSE
	if(!minions.len && !locate(THE_TREE_CURSE) in blessed) //no minions? no blessed?
		cut_overlays()
		resetQliphoth() //return to non breached sprite while still in containment.
		return TRUE

/mob/living/simple_animal/hostile/abnormality/parasite_tree/proc/dropLeaf()
	SIGNAL_HANDLER

	if(origin_cooldown <= world.time && datum_reference.qliphoth_meter > 0) //cool it on the leaf dropping if your already breaching
		var/list/potentialFollowers = list()
		origin_cooldown = world.time + (10 SECONDS)
		for(var/mob/living/carbon/human/L in GLOB.player_list)
			if(!faction_check_mob(L) && L.stat != DEAD && L.z == z)
				potentialFollowers += L
				potentialFollowers[L] = 1
				if(L.health < (L.maxHealth * 0.6) || L.sanityhealth < (L.maxSanity * 0.6))
					potentialFollowers[L] += (L.health - 1) + (L.sanityhealth - 1)
		if(potentialFollowers.len)
			var/mob/living/carbon/human/chosen_agent = pickweight(potentialFollowers)
			to_chat(chosen_agent, span_nicegreen("一片大叶子落在附近."))
			var/list/possibleleafturf = list()
			for(var/turf/T in oview(3, chosen_agent))
				if(!T.density && !locate(/obj/structure/window || /obj/machinery/door) in T.contents)
					possibleleafturf += T
			if(possibleleafturf.len > 8) //if your in a area with less than 8 steps of space then theres no room for a leaf
				new /obj/structure/liars_leaf(pick(possibleleafturf))

	//SAPLING MINION
/mob/living/simple_animal/hostile/aminion/parasite_tree_sapling
	name = "有毒树种"
	desc = "这是一棵人形树，它痛苦的脸上喷出浓浓的有毒气体."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "sapling"
	icon_living = "sapling"
	maxHealth = 400
	health = 400
	can_patrol = FALSE
	wander = 0
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.8)
	ranged = TRUE
	ranged_cooldown_time = 1 SECONDS
	obj_damage = 0
	del_on_death = TRUE
	environment_smash = ENVIRONMENT_SMASH_NONE
	death_message = "粉碎成无数的海绵状碎片."
	death_sound = 'sound/creatures/venus_trap_death.ogg'
	attacked_sound = 'sound/creatures/venus_trap_hurt.ogg'
	projectilesound = 'sound/machines/clockcult/steam_whoosh.ogg'
	threat_level = HE_LEVEL
	score_divider = 8
	var/mob/living/simple_animal/hostile/abnormality/parasite_tree/connected_abno

/mob/living/simple_animal/hostile/aminion/parasite_tree_sapling/Initialize()
	. = ..()
	icon_living = "sapling[pick(1,2)]"
	icon_state = icon_living
	connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/parasite_tree) in GLOB.abnormality_mob_list
	if(connected_abno)
		connected_abno.minions += src

/mob/living/simple_animal/hostile/aminion/parasite_tree_sapling/death()
	if(connected_abno)
		connected_abno.minions -= src
		connected_abno.endBreach()
	for(var/atom/movable/AM in src)
		AM.forceMove(get_turf(src))
	..()

/mob/living/simple_animal/hostile/aminion/parasite_tree_sapling/CanAttack(mob/living/carbon/human/the_target) //Your target has to be human and not have the tree curse.
	if(isturf(the_target) || !the_target || the_target.type == /atom/movable/lighting_object) // bail out on invalids
		return FALSE

	if(ismob(the_target)) //Target is in godmode, ignore it.
		var/mob/M = the_target
		if(M.status_flags & GODMODE)
			return FALSE

	if(see_invisible < the_target.invisibility)//Target's invisible to us, forget it
		return FALSE

	if(ishuman(the_target) && the_target.stat != DEAD && !the_target.has_status_effect(THE_TREE_CURSE))
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/aminion/parasite_tree_sapling/Move()
	return FALSE

/mob/living/simple_animal/hostile/aminion/parasite_tree_sapling/AttackingTarget(atom/attacked_target)
	if(!target)
		GiveTarget(attacked_target)
	return OpenFire()

/mob/living/simple_animal/hostile/aminion/parasite_tree_sapling/OpenFire()
	if(ranged_cooldown > world.time)
		return FALSE
	ranged_cooldown = world.time + ranged_cooldown_time
	playsound(get_turf(src), projectilesound, 10, 1)
	var/smoke_test = locate(/obj/effect/particle_effect/smoke) in view(1, src)
	if(!smoke_test)
		var/datum/effect_system/smoke_spread/parasite_tree/S = new(get_turf(src))
		S.set_up(5, get_turf(src))
		S.start()
		return TRUE
	ranged_cooldown += 1 SECONDS

//SMOKE EFFECT
/obj/effect/particle_effect/smoke/parasite_tree
	name = "thick noxious fumes"
	color = "#AAFF00"
	lifetime = 3
	opaque = TRUE

/obj/effect/particle_effect/smoke/parasite_tree/smoke_mob(mob/living/carbon/C)
	if(!istype(C))
		return FALSE
	if(lifetime<1)
		return FALSE
	if(C.internal != null || C.has_smoke_protection())
		return FALSE
	if(C.smoke_delay)
		return FALSE
	if(!ishuman(C))
		return FALSE
	if(C.has_status_effect(THE_TREE_CURSE)) //If you have the status effect already dont mess with them.
		return FALSE
	C.smoke_delay++
	addtimer(CALLBACK(C, TYPE_PROC_REF(/mob/living, remove_smoke_delay)), 10)
	return smoke_mob_effect(C)


/obj/effect/particle_effect/smoke/parasite_tree/proc/smoke_mob_effect(mob/living/carbon/human/M)
	M.deal_damage(15, WHITE_DAMAGE)
	if(prob(15))
		M.emote("cough")
	if(M.sanity_lost)
		M.apply_status_effect(THE_TREE_CURSE)
	return TRUE

/datum/effect_system/smoke_spread/parasite_tree
	effect_type = /obj/effect/particle_effect/smoke/parasite_tree

// STATUS EFFECT
/datum/status_effect/display/parasite_tree_blessing
	id = "parasite_tree_blessing"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	tick_interval = 50
	alert_type = null
	on_remove_on_mob_delete = TRUE
	display_name = "hypocrisy"
	var/mob/living/simple_animal/hostile/abnormality/parasite_tree/connected_abno

/datum/status_effect/display/parasite_tree_blessing/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 10)
	status_holder.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 10)
	connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/parasite_tree) in GLOB.abnormality_mob_list
	if(!connected_abno)
		return
	connected_abno.blessed += src
	connected_abno.datum_reference.qliphoth_change(-1)

/datum/status_effect/display/parasite_tree_blessing/tick()
	. = ..()
	if(!ishuman(owner))
		QDEL_IN(src, 5)
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjustSanityLoss(-3)
	if(status_holder.stat == DEAD)
		qdel(src)

/datum/status_effect/display/parasite_tree_blessing/on_remove()
	if(!ishuman(owner))
		return ..()
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -10)
	status_holder.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -10)
	if(!connected_abno)
		return ..()
	connected_abno.blessed -= src
	if(status_holder.stat == DEAD)
		connected_abno.datum_reference.qliphoth_change(1)
	return ..()

/datum/status_effect/display/parasite_tree_blessing/proc/facadeFalls()
	owner.apply_status_effect(THE_TREE_CURSE)
	qdel(src)

		//CURSE EFFECT
/datum/status_effect/display/parasite_tree_curse
	id = "parasite_tree_curse"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	tick_interval = 50
	alert_type = null
	on_remove_on_mob_delete = TRUE //Alot of people get gibbed by abnormalities, so this ensures they are removed from the blessed list.
	display_name = "hypocrisy"
	var/mob/living/simple_animal/hostile/abnormality/parasite_tree/connected_abno

/datum/status_effect/display/parasite_tree_curse/on_apply()
	. = ..()
	connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/parasite_tree) in GLOB.abnormality_mob_list
	to_chat(owner, span_warning("你感到皮肤下有东西发芽了！是时候以树的姿态重生了."))
	if(connected_abno)
		connected_abno.blessed += src

/datum/status_effect/display/parasite_tree_curse/tick()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	var/tree_toxin = status_holder.maxSanity * 0.20
	status_holder.deal_damage(tree_toxin, WHITE_DAMAGE)
	if(status_holder.sanity_lost || status_holder.stat == DEAD)
		qdel(src)

/datum/status_effect/display/parasite_tree_curse/on_remove()
	var/mob/living/carbon/human/status_holder = owner
	if(connected_abno)
		connected_abno.blessed -= src
		if(!status_holder || status_holder.stat == DEAD)
			connected_abno.endBreach()
	//If you have melting love and parasite tree blessing, melting loves blessing gets priority
	if(TransformOverride(status_holder))
		connected_abno.endBreach()
		return ..()
	if(status_holder.sanity_lost && status_holder.stat != DEAD)
		var/mob/living/simple_animal/hostile/aminion/parasite_tree_sapling/new_mob = new(owner.loc)
		nested_items(new_mob, status_holder.get_item_by_slot(ITEM_SLOT_SUITSTORE))
		nested_items(new_mob, status_holder.get_item_by_slot(ITEM_SLOT_BELT))
		nested_items(new_mob, status_holder.get_item_by_slot(ITEM_SLOT_BACK))
		nested_items(new_mob, status_holder.get_item_by_slot(ITEM_SLOT_OCLOTHING))
		QDEL_IN(owner, 5) //rabbit sanity implant explodes at 5
	return ..()

/datum/status_effect/display/parasite_tree_curse/TweakDisplayIcon()
	..()
	icon_overlay.color = "#4B0076" //indigo

/datum/status_effect/display/parasite_tree_curse/proc/TransformOverride(mob/living/carbon/human/H)
	if(H && H.has_status_effect(/datum/status_effect/display/melting_love_blessing))
		to_chat(H, span_warning("你感觉到粉红色的粘液在你变成木头之前就溶解了你的肉."))
		H.deal_damage(400, BLACK_DAMAGE)
		H.remove_status_effect(/datum/status_effect/display/melting_love_blessing)
		if(!H || H.stat == DEAD)
			return TRUE

/datum/status_effect/display/parasite_tree_curse/proc/nested_items(mob/living/simple_animal/hostile/nest, obj/item/nested_item)
	if(nested_item)
		nested_item.forceMove(nest)

//Parasite Tree Ego Weapon Trap
/obj/structure/liars_leaf
	gender = PLURAL
	name = "奇怪的树叶"
	desc = "大树上的叶子，触摸它会治愈你的伤口."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "liars_leaf"
	anchored = TRUE
	density = FALSE
	resistance_flags = FLAMMABLE
	max_integrity = 15
	color = "#AAFF00"
	var/windup = 0

/obj/structure/liars_leaf/Initialize()
	. = ..()
	for(var/obj/structure/liars_leaf/leaf in view(1, get_turf(src)))
		if(leaf != src)
			qdel(src)
	windup = world.time + (1 SECONDS)
	QDEL_IN(src, (15 SECONDS))

/obj/structure/liars_leaf/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM) && windup <= world.time)
		var/mob/living/carbon/human/L = AM
		var/heal_amount = -10
		if(!L.has_status_effect(THE_TREE_CURSE) && !L.has_status_effect(THE_LIARS_BLESSING))
			heal_amount = L.maxHealth * -0.25
			L.apply_status_effect(THE_LIARS_BLESSING)
		L.adjustBruteLoss(heal_amount)
		new /obj/effect/temp_visual/cloud_swirl(get_turf(L)) //placeholder
		to_chat(L, span_nicegreen("你的重伤口在接触到[src]后恢复了."))
		qdel(src)

#undef THE_LIARS_BLESSING
#undef THE_TREE_CURSE
