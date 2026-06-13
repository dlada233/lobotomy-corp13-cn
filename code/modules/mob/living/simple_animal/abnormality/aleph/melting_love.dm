#define STATUS_EFFECT_MELTYLOVE /datum/status_effect/display/melting_love_blessing
#define STATUS_EFFECT_SLIMED  /datum/status_effect/melty_slimed
/mob/living/simple_animal/hostile/abnormality/melting_love
	name = "溶解之爱"
	desc = "粉色的黏液生物，维持着人类女性的形态."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "melting_love"
	icon_living = "melting_love"
	portrait = "melting_love"
	pixel_x = -16
	base_pixel_x = -16
	speak_emote = list("gurgle")
	attack_verb_continuous = "glomps"
	attack_verb_simple = "glomp"
	/* Stats */
	threat_level = ALEPH_LEVEL
	health = 2000 //Lacks self healing
	maxHealth = 2000
	obj_damage = 60
	damage_coeff = list(RED_DAMAGE = -1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0.8)
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 15
	melee_damage_upper = 20 // AOE damage increases it drastically
	projectiletype = /obj/projectile/melting_blob
	ranged = TRUE
	stat_attack = DEAD
	minimum_distance = 0
	ranged_cooldown_time = 5 SECONDS
	move_to_delay = 4
	/* Works */
	start_qliphoth = 3
	can_breach = TRUE
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(20, 20, 30, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(40, 40, 40, 45, 45),
		ABNORMALITY_WORK_ATTACHMENT = list(20, 30, 40, 50, 55),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 0, 0, 0),
	)
	work_damage_upper = 10
	work_damage_lower = 4
	work_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/lust
	max_boxes = 32
	/* Sounds */
	projectilesound = 'sound/abnormalities/meltinglove/ranged.ogg'
	attack_sound = 'sound/abnormalities/meltinglove/attack.ogg'
	death_sound = 'sound/abnormalities/meltinglove/death.ogg'
	/*Vars and others */
	loot = list(/obj/item/reagent_containers/glass/bucket/melting)
	del_on_death = FALSE
	ego_list = list(/datum/ego_datum/weapon/adoration, /datum/ego_datum/armor/adoration)
	gift_type =  /datum/ego_gifts/adoration
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "黏液渴望着关爱, 它覆盖了牢房的地板、墙壁和天花板. <br>\
		当你进入时，它们附着在你了你的衣服、口罩还有皮肤上. <br>在单元的中心, 黏液汇集的地方, 有一个女孩的身影. <br>\
		她害羞地朝你挥手. <br>你..."
	observation_choices = list(
		"从黏液处撤退" = list(TRUE, "你赶紧离开了收容单元, 粘在你身上的黏液转变为酸性黏液. 如果她得不到你的爱, 她将另寻它法..."),
		"靠近她" = list(FALSE, "你伸出手，她也向你伸出, 你的手指缠绕着黏糊糊的物质，而她咯咯地笑. <br>\"让我们永远在一起吧.\" <br>\
			你把手抽离, 但出来的只有黏液. <br>你尝试逃离, 但你的脚早已埋入了她的陷阱. <br>\"不要背叛我, 好吗?\" <br>这就是你最后所听到的话..."),
	)

	var/mob/living/carbon/human/gifted_human = null
	/// Amount of BLACK damage done to all enemies around main target on melee attack. Also includes original target
	var/radius_damage = 14

/mob/living/simple_animal/hostile/abnormality/melting_love/Login()
	. = ..()
	to_chat(src, "<h1>你是溶解之爱, 坦克型异想体.</h1><br>\
		<b>|吸收黏液|: 红色伤害会治愈你而不是造成伤害, 同样的效果也适用于你生产的小黏液们.<br>\
		<br>\
		|粘稠黏液|: 你的一些技能会对目标造成'黏液覆盖'效果.\
		遭到'黏液覆盖'效果的人将会持续承受黑色伤害并减慢移动速度.<br>\
		<br>\
		|溶解黏液|: 当你移动时，你会留下'溶解黏液'在地板上. 如果非黏液生物踩到'溶解黏液', 他们将被'黏液覆盖'.<br>\
		<br>\
		|传播爱...|: 当你攻击尸体, 你会把它转化成'小黏液', 小黏液存在的时间很短，死亡后会爆炸.\
		当它们死亡, 它们会对附近人类造成黑色伤害并在周围留下'溶解黏液'.\
		并且，如果你攻击你的'小黏液', 你将吞噬它并回复20%的HP.<br>\
		<br>\
		|永远在一起...|: 当你点击近战范围外的地块, 你将发射黏液弹. 让目标被'黏液覆盖'并且造成黑色伤害.\
		如果黏液弹击中尸体, 会转化尸体成为小黏液.</b>")

/mob/living/simple_animal/hostile/abnormality/melting_love/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = (5 SECONDS))
	QDEL_IN(src, (5 SECONDS))
	return ..()

/* Attacks */
/mob/living/simple_animal/hostile/abnormality/melting_love/CanAttack(atom/the_target)
	if(isliving(the_target) && !ishuman(the_target))
		var/mob/living/L = the_target
		if(L.stat == DEAD)
			return FALSE
		if(L.type == /mob/living/simple_animal/hostile/aminion/slime && health <= maxHealth * 0.8) // We need healing
			return TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/melting_love/OpenFire(atom/A)
	if(get_dist(src, A) < 2) // We can't fire normal ranged attack that close
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/melting_love/AttackingTarget(atom/attacked_target)
	// Convert
	if(ishuman(attacked_target))
		var/mob/living/carbon/human/H = attacked_target
		if(H.stat == DEAD || H.health <= HEALTH_THRESHOLD_DEAD)
			return SlimeConvert(H)

	// Consume a slime. Cannot work on the big one, so the check is not istype()
	if(attacked_target.type == /mob/living/simple_animal/hostile/aminion/slime)
		var/mob/living/simple_animal/hostile/aminion/slime/S = attacked_target
		visible_message(span_warning("[src]吞噬[S], 恢复自身生命值."))
		. = ..() // We do a normal attack without AOE and then consume the slime to restore HP
		adjustBruteLoss(-maxHealth * 0.2)
		S.adjustBruteLoss(S.maxHealth) // To make sure it dies
		return .

	// AOE attack
	if(isliving(attacked_target) || ismecha(attacked_target))
		new /obj/effect/gibspawner/generic/silent/melty_slime(get_turf(attacked_target))
		for(var/turf/open/T in view(1, attacked_target))
			var/obj/effect/temp_visual/small_smoke/halfsecond/S = new(T)
			S.color = "#FF0081"
			var/list/got_hit = list()
			got_hit = HurtInTurf(T, got_hit, radius_damage, BLACK_DAMAGE, null, TRUE, FALSE, TRUE)
			for(var/mob/living/L in got_hit)
				L.apply_status_effect(STATUS_EFFECT_SLIMED)
	return ..()

/mob/living/simple_animal/hostile/abnormality/melting_love/bullet_act(obj/projectile/P)
	if (P.damage_type == RED_DAMAGE && !ishuman(P.firer))
		return BULLET_ACT_BLOCK
	. = ..()

/mob/living/simple_animal/hostile/abnormality/melting_love/Move()
	. = ..()
	var/turf/T = get_turf(src)
	if(!isturf(T) || isspaceturf(T))
		return
	if(locate(/obj/effect/decal/cleanable/melty_slime) in T)
		for(var/obj/effect/decal/cleanable/melty_slime/slime in T)
			slime.Refresh()
		return
	new /obj/effect/decal/cleanable/melty_slime(T)

/* Slime Conversion */
/mob/living/simple_animal/hostile/abnormality/melting_love/proc/SlimeConvert(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE
	if(H.has_status_effect(STATUS_EFFECT_MELTYLOVE))
		//The status effect should explode them eventually. If not we have a bigger problem.
		return FALSE
	visible_message(span_danger("[src]温柔拥抱[H]，一只小黏液随之出现!"))
	new /mob/living/simple_animal/hostile/aminion/slime(get_turf(H))
	H.gib(FALSE, TRUE, TRUE)
	return TRUE

/* Qliphoth things */
/mob/living/simple_animal/hostile/abnormality/melting_love/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(33) && user.has_status_effect(STATUS_EFFECT_MELTYLOVE))
		datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/melting_love/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(50))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/melting_love/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/melting_love/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_living = "melting_breach"
	icon_state = icon_living
	icon_dead = "melting_breach_dead"
	pixel_x = -32
	base_pixel_x = -32
	offsets_pixel_x = list("south" = -32, "north" = -32, "west" = -32, "east" = -32)
	SetOccupiedTiles(up = 1)
	desc = "粉色的驼背生物，有着长长的胳膊，还能看到从黏液内部伸出的骨头."
	if(istype(gifted_human))
		DissolveGifted(gifted_human)
	else
		Empower()

/* Gift */
/mob/living/simple_animal/hostile/abnormality/melting_love/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(GODMODE in user.status_flags)
		return
	if(!gifted_human && istype(user) && work_type != ABNORMALITY_WORK_REPRESSION && user.stat != DEAD && (status_flags & GODMODE))
		gifted_human = user
		RegisterSignal(gifted_human, COMSIG_WORK_COMPLETED, PROC_REF(GiftedAnger))
		user.apply_status_effect(STATUS_EFFECT_MELTYLOVE)
		to_chat(user, span_nicegreen("你感到自己被赠送了礼物..."))
		playsound(get_turf(user), 'sound/abnormalities/meltinglove/gift.ogg', 50, 0, 2)
		return
	if(istype(user) && user.has_status_effect(STATUS_EFFECT_MELTYLOVE))
		to_chat(gifted_human, span_nicegreen("溶解之爱因为看见你而感到很高兴!"))
		gifted_human.adjustSanityLoss(rand(-25,-35))
		return

/mob/living/simple_animal/hostile/abnormality/melting_love/WorkChance(mob/living/carbon/human/user, chance)
	if(user.has_status_effect(STATUS_EFFECT_MELTYLOVE))
		return chance + 10
	return chance

//Status effect will turn them into a slime if they died.
/mob/living/simple_animal/hostile/abnormality/melting_love/proc/DissolveGifted(mob/living/carbon/C)
	to_chat(C, span_userdanger("我感觉自己要撑破了!"))
	C.emote("scream")
	C.deal_damage(270, BLACK_DAMAGE)
	C.remove_status_effect(STATUS_EFFECT_MELTYLOVE)

/mob/living/simple_animal/hostile/abnormality/melting_love/proc/UnregisterGiftedSignals(mob/living/carbon/human/user)
	if(user)
		UnregisterSignal(user, COMSIG_WORK_COMPLETED)
		return TRUE

/mob/living/simple_animal/hostile/abnormality/melting_love/proc/GiftedAnger(datum/source, datum/abnormality/datum_sent, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		to_chat(gifted_human, span_userdanger("[src]不喜欢这样!"))
		datum_reference.qliphoth_change(-1)

/* Checking if bigslime is dead or not and apply a damage buff if yes */
/mob/living/simple_animal/hostile/abnormality/melting_love/proc/SlimeDeath(datum/source, gibbed)
	SIGNAL_HANDLER
	Empower()
	for(var/mob/M in GLOB.player_list)
		if(M.z == z && M.client)
			to_chat(M, span_userdanger("你可以听到一声黏糊糊的哭声!"))
			SEND_SOUND(M, 'sound/abnormalities/meltinglove/empower.ogg')
			flash_color(M, flash_color = "#FF0081", flash_time = 50)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/melting_love/proc/Empower()
	ChangeMoveToDelayBy(-0.5)
	melee_damage_lower += 8
	melee_damage_upper += 8
	radius_damage += 8
	projectiletype = /obj/projectile/melting_blob/enraged
	adjustBruteLoss(-maxHealth, forced = TRUE)
	desc += " 它看起来很生气."

/mob/living/simple_animal/hostile/abnormality/melting_love/proc/SpawnBigSlime(mob/living/simple_animal/hostile/aminion/slime/big/S)
	gifted_human = null
	datum_reference.qliphoth_change(-9)
	if(S)
		RegisterSignal(S, COMSIG_LIVING_DEATH, PROC_REF(SlimeDeath))

/* Slimes (HE) */
/mob/living/simple_animal/hostile/aminion/slime
	name = "小黏液"
	desc = "一名前员工的遗骸漂浮在其中..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "little_slime"
	icon_living = "little_slime"
	speak_emote = list("gurgle")
	attack_verb_continuous = "glomps"
	attack_verb_simple = "glomp"
	/* Stats */
	health = 400
	maxHealth = 400
	obj_damage = 60
	damage_coeff = list(RED_DAMAGE = -1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 10
	melee_damage_upper = 15
	rapid_melee = 2
	speed = 2
	move_to_delay = 3
	/* Sounds */
	death_sound = 'sound/abnormalities/meltinglove/pawn_death.ogg'
	attack_sound = 'sound/abnormalities/meltinglove/pawn_attack.ogg'
	/* Vars and others */
	robust_searching = TRUE
	stat_attack = DEAD
	del_on_death = TRUE
	score_divider = 2
	threat_level = HE_LEVEL
	var/spawn_sound = 'sound/abnormalities/meltinglove/pawn_convert.ogg'
	var/statuschance = 25
	var/death_damage = 10
	var/death_slime_range = 1
	var/decay_damage = 10
	var/decay_timer = 4

/mob/living/simple_animal/hostile/aminion/slime/Login()
	. = ..()
	to_chat(src, "<h1>你小黏液, 溶解之爱的小部下.</h1><br>\
		<b>|消耗...|: 你每4秒承受20点黑色伤害, 这意味着你只有40秒的寿命, 除非有人对你造成红色伤害. \
		一旦你死亡，你会在3x3的范围内爆出'黏液', 这将对附近的所有人造成20点黑色伤害.<br>\
		<br>\
		|妈妈?|: 溶解之爱能通过攻击你来吞噬掉你，以此恢复她20%的HP.</b>")

/mob/living/simple_animal/hostile/aminion/slime/Initialize()
	. = ..()
	playsound(get_turf(src), spawn_sound, 50, 1)
	var/matrix/init_transform = transform
	transform *= 0.1
	alpha = 25
	animate(src, alpha = 255, transform = init_transform, time = 5)
	if(SSmaptype.maptype == "rcorp")
		addtimer(CALLBACK(src, PROC_REF(decay)), decay_timer SECONDS, TIMER_STOPPABLE)

/mob/living/simple_animal/hostile/aminion/slime/proc/decay()
	to_chat(src, span_userdanger("你感觉自己正在崩解..."))
	src.deal_damage(decay_damage, BLACK_DAMAGE)
	if (stat != DEAD)
		addtimer(CALLBACK(src, PROC_REF(decay)), decay_timer SECONDS, TIMER_STOPPABLE)

/mob/living/simple_animal/hostile/aminion/slime/death()
	for(var/atom/movable/AM in src)
		AM.forceMove(get_turf(src))
	if(SSmaptype.maptype == "rcorp")
		for(var/turf/open/R in range(death_slime_range, src))
			new /obj/effect/decal/cleanable/melty_slime(R)
		for(var/mob/living/L in view(death_slime_range, src))
			if(L.stat != DEAD && !istype(L, /mob/living/simple_animal/hostile/aminion/slime))
				L.apply_damage(death_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
	return ..()

/mob/living/simple_animal/hostile/aminion/slime/CanAttack(atom/the_target)
	if(isliving(the_target) && !ishuman(the_target))
		var/mob/living/L = the_target
		if(L.stat == DEAD)
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/aminion/slime/AttackingTarget(atom/attacked_target)
	// Convert
	if(ishuman(attacked_target))
		var/mob/living/carbon/human/H = attacked_target
		if(H.stat == DEAD || H.health <= HEALTH_THRESHOLD_DEAD)
			return SlimeConvert(H)
		if(prob(statuschance))
			H.apply_status_effect(STATUS_EFFECT_SLIMED)
	return ..()

/mob/living/simple_animal/hostile/aminion/slime/proc/SlimeConvert(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE
	visible_message(span_danger("[src]温柔拥抱[H]，一只小黏液随即出现!"))
	new /mob/living/simple_animal/hostile/aminion/slime(get_turf(H))
	H.gib(FALSE, TRUE, TRUE)
	return TRUE

//3 monsters including parasite tree sapling and naked nest use this proc i might make it part of the root in the future -IP
/mob/living/simple_animal/hostile/aminion/slime/proc/NestedItems(mob/living/simple_animal/hostile/nest, obj/item/nested_item)
	if(nested_item)
		nested_item.forceMove(nest)

/* Big Slimes (WAW) */
/mob/living/simple_animal/hostile/aminion/slime/big
	name = "大黏液"
	desc = "某位被给予礼物的前员工的遗骸飘荡在其中..."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "big_slime"
	icon_living = "big_slime"
	pixel_x = -8
	base_pixel_x = -8
	/* Stats */
	health = 800
	maxHealth = 800
	melee_damage_lower = 12
	melee_damage_upper = 20
	spawn_sound = 'sound/abnormalities/meltinglove/pawn_big_convert.ogg'
	statuschance = 75
	score_divider = 2
	threat_level = WAW_LEVEL

/*
* MELTY BLESSING
* I want to say that this blessing is a
* bit haphazardly stapled on by me. Half of the mechanics
* are inside melty and the other half is in the status effect
* unsure if this is good. -IP
*/
/datum/status_effect/display/melting_love_blessing
	id = "melting_love_blessing"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	tick_interval = 50
	alert_type = null
	on_remove_on_mob_delete = TRUE
	display_name = "melty_love"
	var/mob/living/simple_animal/hostile/abnormality/melting_love/connected_abno

/datum/status_effect/display/melting_love_blessing/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 30)
	connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/melting_love) in GLOB.abnormality_mob_list

/datum/status_effect/display/melting_love_blessing/tick()
	. = ..()
	if(!ishuman(owner))
		QDEL_IN(src, 5)
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjustSanityLoss(-10)
	if(status_holder.stat == DEAD)
		qdel(src)

/datum/status_effect/display/melting_love_blessing/on_remove()
	if(!ishuman(owner))
		return ..()
	if(!Dissolve(owner) && istype(owner) && connected_abno)
		connected_abno.UnregisterGiftedSignals(owner)
	return ..()

/datum/status_effect/display/melting_love_blessing/proc/Dissolve(mob/living/carbon/human/H)
	if(H)
		H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -30)
		if(H.stat == DEAD)
			var/mob/living/simple_animal/hostile/aminion/slime/big/new_mob = new(owner.loc)
			NestedItems(new_mob, H.get_item_by_slot(ITEM_SLOT_SUITSTORE))
			NestedItems(new_mob, H.get_item_by_slot(ITEM_SLOT_BELT))
			NestedItems(new_mob, H.get_item_by_slot(ITEM_SLOT_BACK))
			NestedItems(new_mob, H.get_item_by_slot(ITEM_SLOT_OCLOTHING))
			if(connected_abno)
				connected_abno.SpawnBigSlime(new_mob)
			H.gib(FALSE, TRUE, TRUE)
			return new_mob

/datum/status_effect/display/melting_love_blessing/proc/NestedItems(mob/living/simple_animal/hostile/nest, obj/item/nested_item)
	if(nested_item)
		nested_item.forceMove(nest)

//Slime trails
/obj/effect/decal/cleanable/melty_slime
	name = "黏液"
	desc = "It looks corrosive."
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "melty_slime3"
	random_icon_states = list("melty_slime3")
	mergeable_decal = TRUE
	var/duration = 30 SECONDS
	var/state = 3
	var/timer1
	var/timer2
	var/list/slime_types = list(
		/mob/living/simple_animal/hostile/abnormality/melting_love,
		/mob/living/simple_animal/hostile/aminion/slime/big,
		/mob/living/simple_animal/hostile/aminion/slime
	)

/obj/effect/decal/cleanable/melty_slime/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	START_PROCESSING(SSobj, src)
	duration += world.time
	timer1 = addtimer(CALLBACK(src, PROC_REF(Reduce)), 10 SECONDS, TIMER_STOPPABLE)
	timer2 = addtimer(CALLBACK(src, PROC_REF(Reduce)), 20 SECONDS, TIMER_STOPPABLE)

/obj/effect/decal/cleanable/melty_slime/proc/Refresh()
	icon_state = "melty_slime3"
	duration = 30 SECONDS
	if(timer1)
		deltimer(timer1)
		timer1 = null
	if(timer2)
		deltimer(timer2)
		timer2 = null
	timer1 = addtimer(CALLBACK(src, PROC_REF(Reduce)), 10 SECONDS, TIMER_STOPPABLE)
	timer2 = addtimer(CALLBACK(src, PROC_REF(Reduce)), 20 SECONDS, TIMER_STOPPABLE)


/obj/effect/decal/cleanable/melty_slime/proc/Reduce()
	state -= 1
	icon_state = "melty_slime[state]"
	update_icon()

/obj/effect/decal/cleanable/melty_slime/process(delta_time)
	if(world.time > duration)
		Remove()

/obj/effect/decal/cleanable/melty_slime/proc/Remove()
	STOP_PROCESSING(SSobj, src)
	animate(src, time = (5 SECONDS), alpha = 0)
	QDEL_IN(src, 5 SECONDS)

/obj/effect/decal/cleanable/melty_slime/proc/streak(list/directions, mapload=FALSE)
	set waitfor = FALSE
	var/direction = pick(directions)
	for(var/i in 0 to pick(0, 200; 1, 150; 2, 50; 3, 17; 50)) //the 3% chance of 50 steps is intentional and played for laughs.
		if (!mapload)
			sleep(2)
		if(!step_to(src, get_step(src, direction), 0))
			break

/obj/effect/decal/cleanable/melty_slime/Crossed(atom/movable/AM)
	. = ..()
	if(!isliving(AM))
		return FALSE
	if(is_type_in_list(AM, slime_types, FALSE))
		return
	if(istype(AM, /mob/living/simple_animal/projectile_blocker_dummy))
		var/mob/living/simple_animal/projectile_blocker_dummy/pbd = AM
		if(is_type_in_list(pbd.parent, slime_types, FALSE))
			return
	var/mob/living/L = AM
	if((("hostile" in L.faction) && (SSmaptype.maptype in SSmaptype.combatmaps)))
		return
	L.apply_status_effect(STATUS_EFFECT_SLIMED)

/obj/effect/gibspawner/generic/silent/melty_slime
	gibtypes = list(/obj/effect/decal/cleanable/melty_slime)
	gibamounts = list(3)

/obj/effect/gibspawner/generic/silent/melty_slime/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(WEST, NORTHWEST, SOUTHWEST, NORTH))
	. = ..()
	return

//Attack Status Effect
/datum/status_effect/melty_slimed
	id = "melty_slimed"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/melty_slimed
	duration = 10 SECONDS // Hits 5 times
	tick_interval = 2 SECONDS

/atom/movable/screen/alert/status_effect/melty_slimed
	name = "黏液覆盖"
	desc = "黏液粘在了你的皮肤上，减慢速度并承受黑色伤害!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "slimed"

/datum/status_effect/melty_slimed/tick()
	. = ..()
	if(!isliving(owner))
		return
	var/mob/living/L = owner
	L.deal_damage(5, BLACK_DAMAGE)
	owner.playsound_local(owner, 'sound/effects/wounds/sizzle2.ogg', 25, TRUE)
	if(!ishuman(L))
		return
	if((L.sanityhealth <= 0) || (L.health <= 0))
		var/turf/T = get_turf(L)
		new /mob/living/simple_animal/hostile/aminion/slime(T)
		L.gib(FALSE, TRUE, TRUE)

/datum/status_effect/melty_slimed/on_apply()
	owner.add_movespeed_modifier(/datum/movespeed_modifier/slimed)
	owner.playsound_local(owner, 'sound/abnormalities/meltinglove/ranged_hit.ogg', 50, TRUE)
	return ..()

/datum/status_effect/melty_slimed/on_remove()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/slimed)
	return ..()

/datum/movespeed_modifier/slimed
	multiplicative_slowdown = 1
	variable = FALSE

#undef STATUS_EFFECT_SLIMED
#undef STATUS_EFFECT_MELTYLOVE
