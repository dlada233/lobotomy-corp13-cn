//This abnormality does more things now! It should be enjoyable enough to play as.
/mob/living/simple_animal/hostile/abnormality/greed_king
	name = "贪婪女王"
	desc = "一个被困在魔法水晶里的女孩."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "kog"
	icon_living = "kog"
	portrait = "greed_king"
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 1500
	health = 1500
	ranged = TRUE
	attack_verb_continuous = "chomps"
	attack_verb_simple = "chomps"
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	speak_emote = list("states")
	vision_range = 14
	aggro_vision_range = 20
	stat_attack = HARD_CRIT
	melee_damage_lower = 20	//Shouldn't really attack unless a player in controlling it, I guess.
	melee_damage_upper = 30
	attack_sound = 'sound/abnormalities/kog/GreedHit1.ogg'
	can_breach = TRUE
	threat_level = WAW_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(25, 25, 50, 50, 55),
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 50, 50, 55),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 40, 40, 40),
	)
	work_damage_upper = 7
	work_damage_lower = 5
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gluttony

	observation_prompt = "拜托，别这样。<br>我或许丑陋不堪，但这对你无关紧要，对吧？<br>\
		你能听见我说话，我很高兴。<br>我曾为世界幸福而战。<br>但很快意识到：<br>\
		世界幸福即我之幸福。<br>我正竭力保持快乐。<br>\
		即便沦落至此等模样也不在乎。<br>见过我的姐妹们吗？<br>我们本是一体。<br>\
		并肩作战，目标一致。<br>话说，你现在幸福吗？"
	observation_choices = list(
		"是的，我很幸福" = list(TRUE, "（蛋剧烈震动）<br>\
			别撒谎。<br>若真如此，我们怎会沦落至此？<br>\
			你又为何变成这样？<br>如此薄弱的信念无法满足我的贪婪。<br>\
			但若你的答案是对未来的决心，而非陈述现状...<br>事情或许会慢慢改变。"),
		"不，我不幸福" = list(FALSE, "我早知你不幸福。<br>\
		你如我一般。<br>将自己困在蛋中，恰似我。<br>\
		琥珀色天空真美啊。<br>噢，我又饿了。"),
	)

	//Some Variables cannibalized from helper
	var/charge_check_time = 1 SECONDS
	var/teleport_cooldown
	var/dash_num = 100000	//Mostly a safeguard
	var/list/been_hit = list()
	var/can_act = TRUE
	var/initial_charge_damage = 400
	var/growing_charge_damage = 0

	var/nihil_present = FALSE

	ego_list = list(
		/datum/ego_datum/weapon/goldrush,
		/datum/ego_datum/armor/goldrush,
	)
	gift_type =  /datum/ego_gifts/goldrush
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/despair_knight = 2,
		/mob/living/simple_animal/hostile/abnormality/hatred_queen = 2,
		/mob/living/simple_animal/hostile/abnormality/wrath_servant = 2,
		/mob/living/simple_animal/hostile/abnormality/nihil = 1.5,
	)

	//PLAYABLES ATTACKS
	attack_action_types = list(
		/datum/action/innate/abnormality_attack/kog_dash,
		/datum/action/innate/abnormality_attack/kog_teleport,
	)

/mob/living/simple_animal/hostile/abnormality/greed_king/Login()
	. = ..()
	to_chat(src, "<h1>你是【贪婪女王】，坦克型异想体。</h1><br>\
		<b>|镀金牢笼|：你的体型为3x3格，但仍可进入1x1区域。<br>\
		<br>\
		|无尽饥渴|：点击近战范围外的格子时，会朝该方向发起冲锋。<br>\
		冲锋启动后将沿直线持续移动。<br>\
		初始冲锋造成200点红色伤害，每移动一格额外增加40点红色伤害。<br>\
		撞墙或任何致密物体时冲锋终止。（犀牛/其他异想体会阻挡冲锋）</b>")

/datum/action/innate/abnormality_attack/kog_dash
	name = "无尽饥渴"
	button_icon_state = "kog_charge"
	chosen_message = span_colossus("你现在要朝那个方向冲去.")
	chosen_attack_num = 1

/datum/action/innate/abnormality_attack/kog_teleport
	name = "传送"
	button_icon_state = "kog_teleport"
	chosen_message = span_warning("你现在将传送到设施大厅的随机区域.")
	chosen_attack_num = 2

/datum/action/innate/abnormality_attack/kog_teleport/Activate()
	addtimer(CALLBACK(A, TYPE_PROC_REF(/mob/living/simple_animal/hostile/abnormality/greed_king, startTeleport)), 1)
	to_chat(A, chosen_message)

/mob/living/simple_animal/hostile/abnormality/greed_king/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(nihil_present)
		return
	if(!(status_flags & GODMODE))
		if(!(!can_act || client))
			charge_check()

/mob/living/simple_animal/hostile/abnormality/greed_king/AttackingTarget()
	if(!can_act)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/greed_king/Move()
	if(!client && !nihil_present)
		return FALSE
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/greed_king/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	//Center it on a hallway
	offsets_pixel_x = list("south" = -16, "north" = -16, "west" = -16, "east" = -16)
	offsets_pixel_y = list("south" = -8, "north" = -8, "west" = -8, "east" = -8)
	transform = matrix(1.5, MATRIX_SCALE)
	SetOccupiedTiles(1, 1, 1, 1)
	damage_effect_scale = 1.2
	startTeleport()	//Let's Spaghettioodle out of here

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/startTeleport()
	if(IsCombatMap())
		return
	if(nihil_present)
		return
	if(!can_act || teleport_cooldown > world.time || (status_flags & GODMODE))
		return
	teleport_cooldown = world.time + 4.9 SECONDS
	//set can_act, animate and call the proc that actually teleports.
	can_act = FALSE
	animate(src, alpha = 0, time = 5)
	addtimer(CALLBACK(src, PROC_REF(endTeleport)), 5)

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/endTeleport()
	var/turf/T = pick(GLOB.xeno_spawn)
	animate(src, alpha = 255, time = 5)
	forceMove(T)
	can_act = TRUE
	if(!client)
		addtimer(CALLBACK(src, PROC_REF(startTeleport)), 5 SECONDS)

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/charge_check()
	//targeting
	var/mob/living/carbon/human/target
	if(!can_act)
		return
	var/list/possible_targets = list()
	for(var/mob/living/carbon/human/H in view(20, src))
		possible_targets += H
	if(LAZYLEN(possible_targets))
		target = pick(possible_targets)
		//Start charge
		var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
		if(dir_to_target)
			can_act = FALSE
			addtimer(CALLBACK(src, PROC_REF(charge), dir_to_target, 0, initial_charge_damage), 2 SECONDS)
			return
	return


/mob/living/simple_animal/hostile/abnormality/greed_king/OpenFire() // This exists so players can manually charge during playable abnormalities.
	if(!can_act || (!client && !nihil_present))
		return
	switch(chosen_attack)
		if(1)
			var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
			can_act = FALSE
			// do particle effect
			charge(dir_to_target, 0, initial_charge_damage)
	return

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/charge(move_dir, times_ran, charge_damage)
	setDir(move_dir)
	var/stop_charge = FALSE
	if(times_ran >= dash_num)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		been_hit = list()
		stop_charge = TRUE
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		W.obj_destruction()
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			stop_charge = TRUE
	for(var/mob/living/simple_animal/hostile/abnormality/D in T.contents)	//This caused issues earlier
		if(D.density)
			stop_charge = TRUE

	//Stop charging
	if(stop_charge)
		can_act = FALSE
		addtimer(CALLBACK(src, PROC_REF(endCharge)), 10 SECONDS)
		been_hit = list()
		return
	forceMove(T)

	//Hiteffect stuff

	for(var/turf/U in range(1, T))
		var/list/new_hits = HurtInTurf(U, been_hit, 0, RED_DAMAGE, hurt_mechs = TRUE) - been_hit
		been_hit += new_hits
		for(var/mob/living/L in new_hits)
			if(!nihil_present)
				L.visible_message(span_boldwarning("[src]碾过[L]!"), span_userdanger("[src]用它的牙齿撕碎了你!"))
				playsound(L, attack_sound, 75, 1)
				new /obj/effect/temp_visual/kinetic_blast(get_turf(L))
				if(ishuman(L))
					L.deal_damage(charge_damage, RED_DAMAGE)
				else
					L.adjustRedLoss(100)
				if(L.stat >= HARD_CRIT)
					L.gib()
				playsound(L, 'sound/abnormalities/kog/GreedHit1.ogg', 20, 1)
				playsound(L, 'sound/abnormalities/kog/GreedHit2.ogg', 50, 1)
				for(var/obj/vehicle/V in new_hits)
					V.take_damage(100, RED_DAMAGE, attack_sound)
					V.visible_message(span_boldwarning("[src] crunches [V]!"))
					playsound(V, 'sound/abnormalities/kog/GreedHit1.ogg', 40, 1)
					playsound(V, 'sound/abnormalities/kog/GreedHit2.ogg', 30, 1)
				continue

			if(!ishuman(L))
				L.visible_message(span_boldwarning("[src]猛击了[L]!"), span_userdanger("[src]用她巨大的拳头砸你!"))
				playsound(L, attack_sound, 75, 1)
				new /obj/effect/temp_visual/kinetic_blast(get_turf(L))
				L.adjustRedLoss(100)
				if(L.stat >= HARD_CRIT)
					L.gib()
				playsound(L, 'sound/abnormalities/kog/GreedHit1.ogg', 20, 1)
				playsound(L, 'sound/abnormalities/kog/GreedHit2.ogg', 50, 1)

	playsound(src,'sound/effects/bamf.ogg', 70, TRUE, 20)
	for(var/turf/open/R in range(1, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(R)
	if (IsCombatMap())
		charge_damage = charge_damage + growing_charge_damage
	addtimer(CALLBACK(src, PROC_REF(charge), move_dir, (times_ran + 1), charge_damage), 3)

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/endCharge()
	can_act = TRUE
	if(!client)
		startTeleport()

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/greed_king/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(15))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/greed_king/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

//Nihil Event Code - TODO: Add attacks TODO: Add a way to teleport to nihil
/mob/living/simple_animal/hostile/abnormality/greed_king/proc/EventStart()
	set waitfor = FALSE
	NihilModeEnable()
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
	SLEEP_CHECK_DEATH(6 SECONDS)
	say("所以，你终于展现了自己.")
	SLEEP_CHECK_DEATH(6 SECONDS)
	say("小丑走了，世界终于可以摆脱悲伤了.")
	SLEEP_CHECK_DEATH(6 SECONDS)
	say("我们会彻底打败你的.")
	SLEEP_CHECK_DEATH(6 SECONDS)
	say("为了幸福!")
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5))

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/NihilModeEnable()
	NihilIconUpdate()
	nihil_present = TRUE
	fear_level = ZAYIN_LEVEL
	faction = list("neutral")

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/NihilIconUpdate()
	name = "幸福魔法少女"
	desc = "真正的魔法少女!"
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "kog"
	pixel_x = -8
	base_pixel_x = -8
	pixel_y = 0
	base_pixel_y = 0

/mob/living/simple_animal/hostile/abnormality/greed_king/Found(atom/A)
	if(istype(A, /mob/living/simple_animal/hostile/abnormality/nihil)) // 1st Priority
		return TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/greed_king/petrify(statue_timer)
	if(!isturf(loc))
		MoveStatue()
	AIStatus = AI_OFF
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "kog_statue"
	pixel_x = -16
	base_pixel_x = -16
	var/obj/structure/statue/petrified/magicalgirl/S = new(loc, src, statue_timer)
	S.name = "石化贪婪"
	ADD_TRAIT(src, TRAIT_NOBLEED, MAGIC_TRAIT)
	SLEEP_CHECK_DEATH(1)
	S.icon = src.icon
	S.icon_state = src.icon_state
	S.pixel_x = -8
	S.base_pixel_x = -8
	var/newcolor = list(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	S.add_atom_colour(newcolor, FIXED_COLOUR_PRIORITY)
	stat = DEAD
	return TRUE

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/MoveStatue()
	var/list/teleport_potential = list()
	if(!LAZYLEN(GLOB.department_centers))
		for(var/mob/living/L in GLOB.mob_living_list)
			if(L.stat == DEAD || L.z != z || L.status_flags & GODMODE)
				continue
			teleport_potential += get_turf(L)
	if(!LAZYLEN(teleport_potential))
		var/turf/P = pick(GLOB.department_centers)
		teleport_potential += P
	var/turf/teleport_target = pick(teleport_potential)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	new /obj/effect/temp_visual/guardian/phase/out(teleport_target)
	forceMove(teleport_target)

/mob/living/simple_animal/hostile/abnormality/greed_king/death(gibbed)
	if(!nihil_present)
		return ..()
	adjustBruteLoss(-999999)
	visible_message(span_boldwarning("哦，不，[src]被打败了!"))
	INVOKE_ASYNC(src, PROC_REF(petrify), 500000)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/greed_king/gib()
	if(nihil_present)
		death()
		return FALSE
	return ..()

//TODO: Make this do something
/obj/structure/blissfragment
	name = "灿烂的幸福"
	desc = "它看起来像一颗大宝石，打破它得到一个特殊的buff."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "bliss"
