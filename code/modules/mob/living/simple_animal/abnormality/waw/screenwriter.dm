#define STATUS_EFFECT_ACTOR /datum/status_effect/actor
//Coded by Coxswain, Sprited by Quack
/*
Bit of a complicated abnormality, but to put to sum it up,
it debuffs random players and then summons a murderer to kill them one at a time.
Defeating the murderer also surpresses the abnormality.
*/
/mob/living/simple_animal/hostile/abnormality/screenwriter
	name = "落魄编剧的笔记"
	desc = "一本记有剧本的笔记本. 其标题为 \"原罪\"."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "screenwriter"
	portrait = "screenwriter"
	maxHealth = 1000
	health = 1000
	damage_coeff = list(RED_DAMAGE = 1.3, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.3, PALE_DAMAGE = 1.5)
	faction = list("hostile")
	threat_level = WAW_LEVEL
	start_qliphoth = 2
	blood_volume = 0
	work_chances = list(
		"营养" = 35,
		"清洁" = 35,
		"共识" = 35,
		"娱乐" = 35,
		"暴力" = 35,
	)
	work_attribute_types = list(
		"营养" = FORTITUDE_ATTRIBUTE,
		"清洁" = PRUDENCE_ATTRIBUTE,
		"共识" = PRUDENCE_ATTRIBUTE,
		"娱乐" = TEMPERANCE_ATTRIBUTE,
		"暴力" = JUSTICE_ATTRIBUTE,
	)
	max_boxes = 24
	work_damage_upper = 6
	work_damage_lower = 4
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gluttony

	ego_list = list(
		/datum/ego_datum/weapon/scene,
		/datum/ego_datum/armor/scene,
	)
	gift_type = /datum/ego_gifts/scene
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK //Technically it was in the beta but I dont want it showing it up in LC-only modes

	observation_prompt = "这出戏很久以前就开始了，这有个杀了很多人的人，而你则拿着枪."
	observation_choices = list( //TODO: multiple texts
		"射击那个人" = list(TRUE, "不管你是否开枪，这出戏都会以悲剧收场."),
		"等待然后观察" = list(TRUE, "不管你是否开枪，这出戏都会以悲剧收场."),
		"射击其他人" = list(TRUE, "不管你是否开枪，这出戏都会以悲剧收场."),
	)

	pet_bonus = "shuffles" //saves a few lines of code by allowing funpet() to be called by attack_hand()
	var/mob/living/simple_animal/hostile/aminion/actor/A
	var/happy = FALSE
	var/melting
	var/preferred_work_type

//Init stuff
/mob/living/simple_animal/hostile/abnormality/screenwriter/PostSpawn()
	. = ..()
	preferred_work_type = pick(work_chances)
	SpawnIcon()

/mob/living/simple_animal/hostile/abnormality/screenwriter/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/screenwriter/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/screenwriter/Destroy()
	if(A)
		A.death()
	EndScenario(FALSE)
	return ..()

//Work stuff
/mob/living/simple_animal/hostile/abnormality/screenwriter/AttemptWork(mob/living/carbon/human/user, work_type)
	if(A)
		to_chat(user, span_warning("异想体忽略了你!"))
		return FALSE
	if(work_type == preferred_work_type || !preferred_work_type)
		happy = TRUE
	else
		happy = FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/screenwriter/WorkChance(mob/living/carbon/human/user, chance)
	if(happy)
		chance+=30
	return chance

/mob/living/simple_animal/hostile/abnormality/screenwriter/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	preferred_work_type = pick(work_chances)
	SpawnIcon()

/mob/living/simple_animal/hostile/abnormality/screenwriter/MeltdownStart()
	. = ..()
	melting = TRUE

/mob/living/simple_animal/hostile/abnormality/screenwriter/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

//Repeat Lines
/mob/living/simple_animal/hostile/abnormality/screenwriter/funpet(mob/petter)
	SpawnIcon()
	switch(preferred_work_type)
		if("营养")
			to_chat(petter, span_nicegreen("这一页上有一幅画，画的是骨头上的肉."))
		if("清洁")
			to_chat(petter, span_nicegreen("这一页上有一幅洗涤器的画像."))
		if("共识")
			to_chat(petter, span_nicegreen("这一页上有一幅手牵手的图画."))
		if("娱乐")
			to_chat(petter, span_nicegreen("这一页上有一幅玩具球的图画."))
		if("暴力")
			to_chat(petter, span_nicegreen("这一页上描绘了一根难看的鞭子."))

//Breach
/mob/living/simple_animal/hostile/abnormality/screenwriter/ZeroQliphoth(mob/living/carbon/human/user)
	if(QDELETED(A))
		A = null
	if(A)
		return
	MeltdownEffect()
	return

/mob/living/simple_animal/hostile/abnormality/screenwriter/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_MINING)
		MeltdownEffect()

/mob/living/simple_animal/hostile/abnormality/screenwriter/proc/MeltdownEffect()
	var/turf/actor_location = pick(GLOB.department_centers) //Spawn the murderer
	A = new (actor_location)
	RegisterSignal(A, COMSIG_LIVING_DEATH, PROC_REF(EndScenario))
	var/list/potentialmarked = list()
	var/list/marked = list()
	var/mob/living/carbon/human/Y
	sound_to_playing_players_on_level('sound/abnormalities/screenwriter/start.ogg', 50, zlevel = z)
	for(var/mob/living/carbon/human/L in GLOB.player_list) // Choose some players to debuff
		if(faction_check_mob(L, FALSE) || L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		potentialmarked += L
	var/numbermarked = 1 + round(LAZYLEN(potentialmarked) / 5, 1) //1 + 1 in 5 potential players, to the nearest whole number
	for(var/i = numbermarked, i>=1, i--)
		if(potentialmarked.len <= 0)
			break
		Y = pick(potentialmarked)
		potentialmarked -= Y
		if(Y.stat == DEAD || Y.is_working)
			continue
		marked+=Y
	if(marked.len <= 0) //Oh no, everyone's dead!
		return
	var/list/role_list = list(
		"懦夫",
		"破碎者",
		"失败者",
	)
	for(Y in marked)
		to_chat(Y, span_warning("戏剧要开始了，你还记得台词吗？"))
		Y.apply_status_effect(STATUS_EFFECT_ACTOR)
		var/datum/status_effect/actor/S = Y.has_status_effect(/datum/status_effect/actor)
		if(LAZYLEN(role_list) > 2)
			S.role = pick_n_take(role_list)

		else
			S.role = "受害者"
		to_chat(Y, span_userdanger("你将扮演[S.role]!"))
		S.AssignRole()

/mob/living/simple_animal/hostile/abnormality/screenwriter/proc/EndScenario(should_sleep = TRUE)
	if(should_sleep)
		sleep(30)
	sound_to_playing_players_on_level('sound/abnormalities/screenwriter/finish.ogg', 25, zlevel = z)
	for(var/mob/living/carbon/human/L in GLOB.player_list) // cleanse debuffs
		if(faction_check_mob(L, FALSE) || L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		var/datum/status_effect/actor/S = L.has_status_effect(/datum/status_effect/actor)
		if(S)
			qdel(S)
	if(A)
		UnregisterSignal(A, COMSIG_LIVING_DEATH)

//Overlays
/mob/living/simple_animal/hostile/abnormality/screenwriter/proc/SpawnIcon()
	var/obj/effect/temp_visual/screenwriteroverlay/SO = new(get_turf(src))
	SO.icon_state = preferred_work_type
	SO.update_icon()

/obj/effect/temp_visual/screenwriteroverlay
	icon = 'icons/effects/effects.dmi'
	icon_state = ""
	duration = 3 SECONDS

/obj/effect/temp_visual/screenwriteroverlay/Initialize() // We want it slightly to upwards and to the side. Perfect!
	. = ..()
	src.pixel_z = 24
	src.pixel_x = 32
	src.alpha = 255
	animate(src, alpha = 255,pixel_x = 32, pixel_z = 24, time = 0 SECONDS)

//Status Effect
/datum/status_effect/actor
	id = "actor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 5 MINUTES //It will go away eventually if you leave the z level or something
	alert_type = null
	var/role = "nobody"
	var/stat_modifier
	var/stat

/datum/status_effect/actor/tick()
	if(owner.stat == DEAD)
		qdel(src)

/datum/status_effect/actor/on_remove()
	var/mob/living/carbon/human/H = owner
	owner.cut_overlay(mutable_appearance('icons/effects/32x64.dmi', role, -ABOVE_MOB_LAYER))
	if(role == "受害者")
		H.adjust_all_attribute_bonuses(-stat_modifier)
	else
		H.adjust_attribute_bonus(stat, -stat_modifier)
	return..()

/datum/status_effect/actor/proc/ChangeToVictim() // So you have chosen death
	if(role == "受害者")
		return
	var/mob/living/carbon/human/status_holder = owner
	if(stat)
		status_holder.adjust_attribute_bonus(stat, -stat_modifier)
	else
		return
	stat_modifier = -40
	status_holder.adjust_all_attribute_bonuses(stat_modifier)
	owner.cut_overlay(mutable_appearance('icons/effects/32x64.dmi', role, -ABOVE_MOB_LAYER))
	role = "受害者"
	owner.add_overlay(mutable_appearance('icons/effects/32x64.dmi', role, -ABOVE_MOB_LAYER))
	playsound(get_turf(owner), 'sound/abnormalities/someonesportrait/panic.ogg', 40, FALSE, -5)
	to_chat(owner, span_userdanger("你将扮演受害者!"))

/datum/status_effect/actor/proc/AssignRole()
	var/mob/living/carbon/human/status_holder = owner
	owner.add_overlay(mutable_appearance('icons/effects/32x64.dmi', role, -ABOVE_MOB_LAYER))
	switch(role)
		if("懦夫")
			stat_modifier = -75
			stat = JUSTICE_ATTRIBUTE
		if("破碎者")
			stat_modifier = -100
			stat = FORTITUDE_ATTRIBUTE
		if("失败者")
			stat_modifier = -100
			stat = PRUDENCE_ATTRIBUTE
		if("受害者")
			stat_modifier = -40
			status_holder.adjust_all_attribute_bonuses(stat_modifier)
			return
	status_holder.adjust_attribute_bonus(stat, stat_modifier)

//Mob
/mob/living/simple_animal/hostile/aminion/actor
	name = "演员A"
	desc = "一个戴着诡异面具的男人，他一只手拿着一把精致的手枪，另一只手拿着一把刀."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "actor"
	icon_living = "actor"
	icon_dead = "actor_dead"
	faction = list("hostile")
	maxHealth = 800
	health = 800
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 5
	melee_damage_upper = 10
	rapid_melee = 3
	melee_queue_distance = 4
	ranged = TRUE
	ranged_cooldown_time = 16
	rapid = 3
	rapid_fire_delay = 4
	projectilesound = 'sound/effects/ordeals/white/pale_pistol.ogg'
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	damage_coeff = list(RED_DAMAGE = 1.3, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.3, PALE_DAMAGE = 1.5)
	move_resist = MOVE_FORCE_OVERPOWERING
	projectiletype = /obj/projectile/actor
	attack_sound = 'sound/effects/ordeals/white/pale_knife.ogg'
	del_on_death = FALSE
	can_patrol = TRUE

/mob/living/simple_animal/hostile/aminion/actor/Initialize()
	. = ..()
	add_overlay(mutable_appearance('icons/effects/32x64.dmi', "abandoned", -ABOVE_MOB_LAYER))

// Patrol Code
/mob/living/simple_animal/hostile/aminion/actor/patrol_select() //Hunt down the "victim"s
	var/mob/living/carbon/human/potential_target
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(faction_check_mob(L, FALSE) || L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		var/datum/status_effect/actor/S = L.has_status_effect(/datum/status_effect/actor)
		if(!S)
			continue
		potential_target = L
		if(S.role == "受害者") //We found 'em!
			patrol_to(get_turf(L))
			return
	if(potential_target)
		var/datum/status_effect/actor/S = potential_target.has_status_effect(/datum/status_effect/actor)
		S.ChangeToVictim()
		patrol_to(get_turf(potential_target))
		return
	return ..()

/mob/living/simple_animal/hostile/aminion/actor/PickTarget(list/Targets)
	var/list/priority = list()
	for(var/mob/living/L in Targets)
		if(!CanAttack(L))
			continue
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.sanity_lost) //ignore the panicked
				if(istype(H.ai_controller, /datum/ai_controller/insane/suicide/scene))
					continue
				priority += L
			else
				priority += L
		else
			priority += L
	if(LAZYLEN(priority))
		return pick(priority)

/mob/living/simple_animal/hostile/aminion/actor/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!ishuman(attacked_target))
		return

	var/mob/living/carbon/human/H = attacked_target
	if(!H.sanity_lost)
		return

	QDEL_NULL(H.ai_controller)
	H.ai_controller = /datum/ai_controller/insane/suicide/scene
	H.InitializeAIController()
	H.apply_status_effect(/datum/status_effect/panicked_type/scene)
	LoseTarget(H)

/mob/living/simple_animal/hostile/aminion/actor/death(gibbed)
	icon_state = icon_dead
	playsound(get_turf(src), 'sound/effects/ordeals/white/pale_pistol.ogg', 100, FALSE, 4)
	visible_message(span_nicegreen("你听到远处的枪声，[src]倒在了地上"))
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

//AI
/datum/ai_controller/insane/suicide/scene
	lines_type = /datum/ai_behavior/say_line/insanity_scene
	suicide_timer = 20 //Suicides very quickly

/datum/ai_behavior/say_line/insanity_scene
	lines = list(
		"如果你是个仁慈的好人, 就请打开坟墓, 将我放进去.",
		"你的刀很快，我会这样带着一个吻死去.",
		"他已经杀了我，朋友，快跑吧，我求求你！",
		"出来吧，杀人犯！你扼杀了我的心！",
		"就这样我就死了，就这样，就这样，就这样. 如今我已死去，如今我已离去，我的灵魂会在天空！",
	)

/datum/status_effect/panicked_type/scene
	icon = "scene"

/datum/ai_controller/insane/suicide/scene/PerformIdleBehavior(delta_time) //Override the behavior to suit our needs a little better
	var/mob/living/carbon/human/human_pawn = pawn
	var/suicide_target = 22
	if(DT_PROB(70, delta_time))
		current_behaviors += GET_AI_BEHAVIOR(lines_type)
		human_pawn.jitteriness += 10
		human_pawn.do_jitter_animation(human_pawn.jitteriness)
		suicide_timer += 1
	if((suicide_timer >= suicide_target) && (human_pawn.mobility_flags & MOBILITY_MOVE))
		human_pawn.visible_message(span_danger("[human_pawn]不知从哪里冒出来一把刀，刺伤了自己!"))
		playsound(get_turf(human_pawn), 'sound/weapons/fixer/generic/nail1.ogg', 100, FALSE, 4)
		human_pawn.adjustBruteLoss(400)
		human_pawn.jitteriness = 0
		var/sanity_damage = get_user_level(human_pawn) * 15
		for(var/mob/living/carbon/human/H in view(7, human_pawn))
			if(HAS_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE))
				continue
			H.deal_damage(sanity_damage, WHITE_DAMAGE)


#undef STATUS_EFFECT_ACTOR
