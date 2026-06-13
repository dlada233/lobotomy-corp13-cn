//Coded by Coxswain
/mob/living/simple_animal/hostile/abnormality/sphinx
	name = "斯芬克斯"
	desc = "一只巨大的石头猫像."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "sphinx"
	icon_living = "sphinx"
	var/icon_aggro = "sphinx_eye"
	portrait = "sphinx"
	speak_emote = list("intones")
	pixel_x = -16
	base_pixel_x = -16
	ranged = TRUE
	maxHealth = 1100
	health = 1100
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	stat_attack = HARD_CRIT
	move_to_delay = 4
	melee_damage_lower = 16
	melee_damage_upper = 18
	attack_sound = 'sound/abnormalities/sphinx/attack.ogg'
	attack_action_types = list(/datum/action/cooldown/sphinx_gaze, /datum/action/cooldown/sphinx_quake)
	can_breach = TRUE
	threat_level = WAW_LEVEL
	melee_damage_type = WHITE_DAMAGE
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(5, 10, 25, 25, 30),
		ABNORMALITY_WORK_INSIGHT = -25,
		ABNORMALITY_WORK_ATTACHMENT = 15,
		ABNORMALITY_WORK_REPRESSION = list(5, 10, 25, 25, 30),
	)
	work_damage_upper = 6
	work_damage_lower = 4
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/wrath

	ego_list = list(
		/datum/ego_datum/weapon/pharaoh,
		/datum/ego_datum/armor/pharaoh,
	)
	gift_type =  /datum/ego_gifts/pharaoh
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	secret_chance = TRUE // Why do we live, just to suffer?
	secret_icon_file = 'ModularTegustation/Teguicons/64x64.dmi'
	secret_icon_state = "sphonx"

	observation_prompt = "我发现自己身处一片古老土地<br>\
		无垠沙漠中矗立着无躯的巨大石腿。<br>\
		身旁，伟大的狮身人面像卧伏着。<br>它示意我解答碑文。<br>\
		碑文刻着陌生的字符，却清晰传递着雕刻者的激情：<br>\
		\"何物晨行四足，午行双足，暮行三足？\""
	observation_choices = list(
		"人类" = list(TRUE, "狮身人面像说了些什么。<br>它似乎愉悦或自豪。<br>\
			随后化为石头沉入沙中。<br>\
			此外别无他物。环绕着巨大残骸的衰败，<br>\
			唯有无边荒凉，<br>\
			平铺的寂寥黄沙延伸至远方。"),
		"怪物" = list(FALSE, "狮身人面像显出不悦。<br>\
			它吐出难以理解却伤人的话语。<br>\
			随后化为石头。<br>我试图移开视线，却发现自己也无法动弹。<br>\
			皮肤如石开裂，呼吸停滞。<br>我坠入深渊。<br>\
			...<br>\
			我被封入石中，永无尽头。<br>\
			无法尖叫，因无舌可鸣。<br>\
			无法视物，因无目可看。<br>\
			无法听闻，因无耳可听。<br>\
			不久心脏也被夺走。<br>最终空无一物。"),
	)

	//work-related
	var/list/workloot = list(
		/obj/item/golden_needle,
		/obj/item/canopic_jar,
	)
	//breach
	var/can_act = TRUE
	var/curse_cooldown
	var/curse_cooldown_time = 12 SECONDS
	var/quake_cooldown
	var/quake_cooldown_time = 6 SECONDS
	var/quake_damage = 20

//Playables buttons
	attack_action_types = list(
		/datum/action/cooldown/sphinx_gaze,
		/datum/action/cooldown/sphinx_quake,
	)

/datum/action/cooldown/sphinx_gaze
	name = "斯芬克斯的凝视"
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "sphinx"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = 12 SECONDS

/datum/action/cooldown/sphinx_gaze/Trigger()
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/sphinx/sphinx = owner
	if(!istype(sphinx))
		return FALSE
	if(sphinx.IsContained()) // No more using cooldowns while contained
		return FALSE
	if(sphinx.curse_cooldown_time > world.time || !sphinx.can_act)
		return FALSE
	StartCooldown()
	sphinx.StoneVision(FALSE)
	return TRUE

/datum/action/cooldown/sphinx_quake
	name = "斯芬克斯的地震"
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "ebony_barrier"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = 6 SECONDS

/datum/action/cooldown/sphinx_quake/Trigger()
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/sphinx/sphinx = owner
	if(!istype(sphinx))
		return FALSE
	if(sphinx.IsContained()) // No more using cooldowns while contained
		return FALSE
	if(sphinx.quake_cooldown > world.time || !sphinx.can_act)
		return FALSE
	StartCooldown()
	sphinx.Quake()
	return TRUE

/mob/living/simple_animal/hostile/abnormality/sphinx/InitializeSecretIcon()
	. = ..()
	icon_aggro = "sphonx_eye"

// Abnormality Work Stuff
/mob/living/simple_animal/hostile/abnormality/sphinx/WorkChance(mob/living/carbon/human/user, chance, work_type)
	var/player_temperance = get_modified_attribute_level(user, TEMPERANCE_ATTRIBUTE)
	var/work_chance_negative = 20 *((0.07*player_temperance-1.4)/(0.07*player_temperance+4)) // 20 is half of the usual temperance_mod of 40
	var/prudence_work_chance = clamp(get_modified_attribute_level(user, PRUDENCE_ATTRIBUTE) * 0.3, 0, 45) // Additional work chance based on prudence
	return prudence_work_chance + chance - work_chance_negative

/mob/living/simple_animal/hostile/abnormality/sphinx/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.sanity_lost)
		QDEL_NULL(user.ai_controller)
		user.ai_controller = /datum/ai_controller/insane/wander/sphinx
		user.InitializeAIController()

/mob/living/simple_animal/hostile/abnormality/sphinx/SuccessEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(prob(10))
		var/turf/dispense_turf = get_step(src, EAST)
		var/reward = pick(workloot)
		new reward(dispense_turf)

/mob/living/simple_animal/hostile/abnormality/sphinx/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	if(!user)
		return
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) >= 100)
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
	var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
	var/obj/item/organ/tongue/tongue = H.getorganslot(ORGAN_SLOT_TONGUE)
	var/chosenorgan = pick(eyes,ears,tongue)
	while(!chosenorgan)
		if(!eyes && !ears && !tongue)
			to_chat(H, span_warning("没有什么可失去的，于是你失去了生命."))
			H.dust()
			return
		chosenorgan = pick(eyes,ears,tongue)
	if(chosenorgan == eyes)
		to_chat(user, span_warning("一道闪光是你最后看到的东西..."))
	if(chosenorgan == ears)
		to_chat(user, span_warning("突然间，一切都安静下来了..."))
	if(chosenorgan == tongue)
		to_chat(user, span_warning("你的嘴感觉很不舒服..."))
	H.internal_organs -= chosenorgan
	qdel(chosenorgan)

// Breach
/mob/living/simple_animal/hostile/abnormality/sphinx/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	AddComponent(/datum/component/knockback, 3, FALSE, TRUE)
	GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/sphinx/Move()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/abnormality/sphinx/PickTarget(list/Targets)
	var/list/priority = list()
	for(var/mob/living/L in Targets)
		if(!CanAttack(L))
			continue
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.sanity_lost) //ignore the panicked
				continue
			else
				priority += L
		else
			priority += L
	if(LAZYLEN(priority))
		return pick(priority)

/mob/living/simple_animal/hostile/abnormality/sphinx/AttackingTarget(atom/attacked_target)
	if(!ishuman(attacked_target))
		if(!target)
			GiveTarget(attacked_target)
		return OpenFire(attacked_target)

	var/mob/living/carbon/human/H = attacked_target
	if(!H.sanity_lost)
		if(!target)
			GiveTarget(attacked_target)
		return OpenFire(attacked_target)

	QDEL_NULL(H.ai_controller)
	H.ai_controller = /datum/ai_controller/insane/wander/sphinx
	H.InitializeAIController()
	LoseTarget(H)

/mob/living/simple_animal/hostile/abnormality/sphinx/OpenFire()
	if(!can_act)
		return

	if((curse_cooldown <= world.time)  && !client)
		StoneVision(FALSE)
		return
	StoneThrow(target)

/mob/living/simple_animal/hostile/abnormality/sphinx/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!client)
		TryQuake()

/mob/living/simple_animal/hostile/abnormality/sphinx/attack_animal(mob/living/simple_animal/M)
	..()
	if(!client)
		TryQuake()

/mob/living/simple_animal/hostile/abnormality/sphinx/proc/StoneThrow()
	if(!can_act)
		return
	can_act = FALSE
	SLEEP_CHECK_DEATH(3)
	playsound(get_turf(target), 'sound/magic/arbiter/repulse.ogg', 20, 0, 5)
	new /obj/effect/temp_visual/rockwarning(get_turf(target), src)
	SLEEP_CHECK_DEATH(10)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/sphinx/proc/TryQuake()
	if((quake_cooldown <= world.time)  && !client)
		Quake()

/mob/living/simple_animal/hostile/abnormality/sphinx/proc/Quake()
	if(quake_cooldown > world.time || !can_act)
		return
	quake_cooldown = world.time + quake_cooldown_time
	can_act = FALSE
	var/turf/origin = get_turf(src)
	playsound(origin, 'sound/magic/arbiter/knock.ogg', 25, 0, 5)
	SLEEP_CHECK_DEATH(9)
	playsound(get_turf(src), 'sound/effects/ordeals/brown/rock_attack.ogg', 50, 0, 8)
	for(var/turf/T in view(2, src))
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/victim in HurtInTurf(T, list(), quake_damage, WHITE_DAMAGE, null, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE))
			var/throw_target = get_edge_target_turf(victim, get_dir(victim, get_step_away(victim, src)))
			if(!victim.anchored)
				var/throw_velocity = (prob(60) ? 1 : 4)
				victim.throw_at(throw_target, rand(1, 2), throw_velocity, src)
	SLEEP_CHECK_DEATH(8)
	icon_state = icon_living
	SLEEP_CHECK_DEATH(3)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/sphinx/proc/StoneVision(attack_chain)
	if((curse_cooldown > world.time) && !attack_chain)
		return
	if(!attack_chain)
		playsound(get_turf(src), 'sound/abnormalities/sphinx/stone_ready.ogg', 50, 0, 5)
		icon_state = icon_aggro
		can_act = FALSE
		src.set_light(5, 7, "D4FAF37", TRUE)
		for(var/turf/T in view(7, src))
			if(T.density)
				continue
			new /obj/effect/temp_visual/stone_gaze(T)
	curse_cooldown = world.time + curse_cooldown_time
	SLEEP_CHECK_DEATH(12)
	for(var/mob/living/carbon/human/L in viewers(7, src))
		if(L.client && CanAttack(L) && L.stat != DEAD)
			if(!L.is_blind() && is_A_facing_B(L,src))
				StoneCurse(L)
	if(!attack_chain)
		StoneVision(TRUE)
		return
	icon_state = icon_living
	can_act = TRUE
	src.set_light(0, 0, null, FALSE) //using all params takes care of the other procs.
	return

/mob/living/simple_animal/hostile/abnormality/sphinx/proc/StoneCurse(target)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(!(H.has_movespeed_modifier(/datum/movespeed_modifier/petrify_partial)))
		H.add_movespeed_modifier(/datum/movespeed_modifier/petrify_partial)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/petrify_partial), 3 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		to_chat(H, span_warning("你的整个身体都感到沉重..."))
		playsound(get_turf(H), 'sound/abnormalities/sphinx/petrify.ogg', 50, 0, 5)
	else
		H.petrify()

// Insanity lines
/datum/ai_controller/insane/wander/sphinx
	lines_type = /datum/ai_behavior/say_line/insanity_sphinx

/datum/ai_behavior/say_line/insanity_sphinx
	lines = list(
		"我们的老主人在等着我们.",
		"聆听星星吧.",
		"人类的时代结束了...",
		"AHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHA!!",
		"我不能...它太多了!",
	)

// Objects - Items
/obj/item/golden_needle
	name = "金针"
	desc = "一对金色的针，可以治疗完全石化或给予免疫眩晕短时间. \
	即使你没有被石化，它也会有帮助..."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "gold_needles"

/obj/item/golden_needle/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(istype(A,/obj/structure/statue/petrified))
		playsound(A, 'sound/effects/break_stone.ogg', rand(10,50), TRUE)
		A.visible_message(span_danger("[A]恢复正常!"), span_userdanger("你从石化中恢复正常!"))
		A.Destroy()
		qdel(src)
		return TRUE

/obj/item/golden_needle/attack_self(mob/user)
	var/mob/living/carbon/human/H = user
	H.reagents.add_reagent(/datum/reagent/medicine/theonic_gold, 15)
	playsound(H, 'sound/effects/ordeals/green/stab.ogg', rand(10,50), TRUE)
	to_chat(H, span_warning("你把金针扎进静脉"))
	to_chat(user, span_userdanger("你感到不可阻挡!"))
	qdel(src)
	return

/obj/item/canopic_jar
	name = "坎努帕斯罐"
	desc = "这是一个充满不祥和恶臭的罐子，里面的东西可以用来替换缺失的器官. \
	一颗额外的心脏也很有用..."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "canopic_jar"

/obj/item/canopic_jar/attack_self(mob/user)
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/ears/ears = user.getorganslot(ORGAN_SLOT_EARS)
	var/obj/item/organ/tongue/tongue = user.getorganslot(ORGAN_SLOT_TONGUE)
	var/obj/item/organ/eyes/eyes = user.getorganslot(ORGAN_SLOT_EYES)
	for(var/organ in H.internal_organs)
		if(!eyes || !ears || !tongue)
			H.regenerate_organs()
		else
			H.reagents.add_reagent(/datum/reagent/medicine/ichor, 15)
			to_chat(user, span_userdanger("你感到心率正在上升!"))
		playsound(H, 'sound/items/eatfood.ogg', rand(25,50), TRUE)
		to_chat(H, span_warning("你捏着鼻子，把瓶子里的东西一饮而尽!"))
		qdel(src)
		return

// Chems
/datum/reagent/medicine/ichor //from jar
	name = "浓水"
	description = "异常物质"
	reagent_state = LIQUID
	color = "#D2FFFA"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 30

/datum/reagent/medicine/ichor/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier(/datum/movespeed_modifier/reagent/ichor_boost)

/datum/reagent/medicine/ichor/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/ichor_boost)
	..()

/datum/reagent/medicine/ichor/overdose_process(mob/living/carbon/M)
	if(prob(25))
		M.reagents.remove_reagent(type, metabolization_rate*15)
		M.vomit(20, TRUE, TRUE, 1, FALSE, FALSE, FALSE, TRUE) //copied from vomitting extra organs

/datum/movespeed_modifier/reagent/ichor_boost
	multiplicative_slowdown = -0.25

/datum/reagent/medicine/theonic_gold //from needle
	name = "Theonic gold"
	description = "an anomalous substance"
	reagent_state = LIQUID
	color = "#D2FFFA"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 30

/datum/reagent/medicine/theonic_gold/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_STUNRESISTANCE, type)
	L.adjustStaminaLoss(-10, 0)

/datum/reagent/medicine/theonic_gold/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_STUNRESISTANCE, type)
	..()

/datum/reagent/medicine/theonic_gold/overdose_process(mob/living/carbon/M)
	if(prob(3) && iscarbon(M))
		M.visible_message(span_danger("[M]开始癫痫发作!"), span_userdanger("你癫痫发作了!"))
		M.Unconscious(100)
		M.Jitter(350)

// Objects - Effects
/obj/effect/temp_visual/stone_gaze
	name = "stone gaze"
	icon_state = "ironfoam"
	duration = 2 SECONDS

/obj/effect/temp_visual/stone_gaze/Initialize()
	. = ..()
	alpha = rand(75,255)
	animate(src, alpha = 0, time = 20)

/datum/movespeed_modifier/petrify_partial
	variable = TRUE
	multiplicative_slowdown = 2

	//Effects
/obj/effect/temp_visual/rockattack
	icon = 'icons/effects/effects.dmi'
	icon_state = "rockattack"
	duration = 6
	randomdir = TRUE // random spike appearance
	layer = ABOVE_MOB_LAYER

/obj/effect/temp_visual/rockwarning
	name = "moving rocks"
	desc = "A target warning you of incoming pain"
	icon = 'icons/effects/effects.dmi'
	icon_state = "rockwarning"
	duration = 10
	layer = RIPPLE_LAYER // We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what is about to hit you.
	var/damage = 24 //Red Damage
	var/mob/living/caster // who made this, anyway

/obj/effect/temp_visual/rockwarning/Initialize(mapload, new_caster)
	. = ..()
	if(new_caster)
		caster = new_caster
	addtimer(CALLBACK(src, PROC_REF(explode)), 0.9 SECONDS)

/obj/effect/temp_visual/rockwarning/proc/explode()
	var/turf/target_turf = get_turf(src)
	if(!target_turf)
		return
	if(QDELETED(caster) || caster?.stat == DEAD || !caster)
		return
	playsound(target_turf, 'sound/effects/ordeals/brown/rock_attack.ogg', 50, 0, 8)
	new /obj/effect/temp_visual/rockattack(target_turf)
	for(var/turf/T in view(1, src))
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in caster.HurtInTurf(T, list(), damage, RED_DAMAGE, null, TRUE, FALSE, TRUE, hurt_hidden = TRUE, hurt_structure = TRUE))
			if(L.health < 0)
				L.gib()
	qdel(src)
