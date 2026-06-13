//Coded by Kirie Saito! EGO done by Chiemi <3
//Reworked by Crabby!!!!
#define STATUS_EFFECT_FAIRY_LIGHTS /datum/status_effect/fairy_lights
/mob/living/simple_animal/hostile/abnormality/titania
	name = "提泰妮娅"
	desc = "巨大的精灵."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "titania"
	icon_living = "titania"
	portrait = "titania"
	maxHealth = 1750
	health = 1750
	is_flying_animal = TRUE
	threat_level = ALEPH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 0, 45, 50),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 0, 30, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 10, 20, 40),
		ABNORMALITY_WORK_REPRESSION = 0,
	)
	start_qliphoth = 2
	move_to_delay = 4

	work_damage_upper = 9
	work_damage_lower = 6
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/lust
	can_breach = TRUE

	melee_damage_lower = 20
	melee_damage_upper = 27
	melee_damage_type = WHITE_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1)
	stat_attack = HARD_CRIT

	ego_list = list(
		/datum/ego_datum/weapon/soulmate,
		/datum/ego_datum/armor/soulmate,
	)
	gift_type = /datum/ego_gifts/soulmate
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	observation_prompt = "是你吗，奥伯龙？<br>我的宿敌，我深爱的魔鬼. <br>是你把毒草混合剂涂在我眼睛上的吗？"
	observation_choices = list(
		"我就是你要找的奥伯龙" = list(TRUE, "那个偷走我孩子的可憎之名. <br>通过你的死亡，我将最终复仇. "),
		"我不是他" = list(FALSE, "啊...<br>区区人类，人类，人类. <br>停止恐惧，我将解除你的痛苦. <br>作为花朵重生吧. "),
		"保持沉默" = list(FALSE, "啊...<br>区区人类，人类，人类. <br>停止恐惧，我将解除你的痛苦. <br>作为花朵重生吧. "),
	)
	patrol_cooldown_time = 5 SECONDS
	var/fairy_spawn_number = 3
	var/fairy_spawn_time = 5 SECONDS
	var/fairy_spawn_limit = 25 // Oh boy, what can go wrong?
	//Fairy spawn limit only matters for the spawn loop, players she kills and spawned via the law don't count
	var/list/spawned_mobs = list()
	/// Is user performing work not at full sanity at the beginning?
	var/agent_notfullsp = FALSE
	var/insane_counter = 0
	//Laws
	var/list/laws = list("melee", "ranged", "fairy", "armor", "ranged fairy")
	var/currentlaw
	var/nextlaw
	var/law_damage = 10		//Take damage, idiot
	var/law_timer = 60 SECONDS
	var/law_startup = 3 SECONDS
	//Oberon stuff
	var/fused = FALSE

/mob/living/simple_animal/hostile/abnormality/titania/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_HUMAN_INSANE, PROC_REF(OnHumanInsane))

/mob/living/simple_animal/hostile/abnormality/titania/Life()
	. = ..()
	if(fused) // So you can't just spoon her to death while in nobody is.
		adjustBruteLoss(-(maxHealth))

/mob/living/simple_animal/hostile/abnormality/titania/Move()
	if(fused)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/titania/CanAttack(atom/the_target)
	if(fused)
		return FALSE
	return ..()

//Attacking code
/mob/living/simple_animal/hostile/abnormality/titania/AttackingTarget(atom/attacked_target)
	if(fused)
		return FALSE
	var/mob/living/carbon/human/H = attacked_target
	. = ..()
	//Kills the weak immediately.
	if(ishuman(H) && (H.health < 0 || H.sanity_lost))
		say("我会让你摆脱痛苦，凡人.")
		//Double Check
		SpawnFairies(fairy_spawn_number * 2, H, ignore_cap = TRUE)
		Convert(H)
		return

/mob/living/simple_animal/hostile/abnormality/titania/proc/Convert(mob/living/carbon/human/H)
	H.visible_message(span_userdanger("[H]正变形成一朵花!"))
	var/mob/living/simple_animal/hostile/titania_flower/F = new(get_turf(H))
	F.alpha = 0
	animate(F, alpha = 255,time = 15)
	var/obj/effect/temp_visual/decoy/fading/D = new(get_turf(H), H)
	D.layer = ABOVE_MOB_LAYER
	for(var/obj/item/W in H)
		dropItemToGround(W)
		W.forceMove(F)
	H.death(TRUE)
	qdel(H)

// Modified patrolling
/mob/living/simple_animal/hostile/abnormality/titania/patrol_select()
	var/list/target_turfs = list() // Stolen from Punishing Bird
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.z != z) // Not on our level
			continue
		if(get_dist(src, H) < 4) // Unnecessary for this distance
			continue
		if(!H.has_status_effect(STATUS_EFFECT_FAIRY_LIGHTS))
			continue
		target_turfs += get_turf(H)

	var/turf/target_turf = get_closest_atom(/turf/open, target_turfs, src)
	if(istype(target_turf))
		patrol_path = get_path_to(src, target_turf, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)
		return
	return ..()

//Spawning Fairies
/mob/living/simple_animal/hostile/abnormality/titania/proc/FairyLoop()
	if(IsCombatMap())
		return
	SpawnFairies(rand(1, fairy_spawn_number))
	addtimer(CALLBACK(src, PROC_REF(FairyLoop)), fairy_spawn_time)

/mob/living/simple_animal/hostile/abnormality/titania/proc/SpawnFairies(amount, mob/turf_mob, ignore_cap = FALSE)
	if(!ignore_cap && (length(spawned_mobs) > fairy_spawn_limit))
		return

	var/turf/spawn_turf
	if(turf_mob)
		spawn_turf = get_turf(turf_mob)
	else
		spawn_turf = get_turf(src)

	for(var/i in 1 to amount)
		var/mob/living/simple_animal/hostile/aminion/fairyswarm/fairy = new(spawn_turf)
		fairy.faction = faction
		fairy.mommy = src
		if(fused)
			fairy.icon_state = "fairyswarm_oberon"
		spawned_mobs += fairy

/mob/living/simple_animal/hostile/abnormality/titania/proc/FairyOberon()
	for(var/mob/living/A in spawned_mobs)
		A.icon_state = "fairyswarm_oberon"
	for(var/mob/living/carbon/human/L in GLOB.player_list) // update debuffs
		var/datum/status_effect/fairy_lights/F = L.has_status_effect(STATUS_EFFECT_FAIRY_LIGHTS)
		if(F)
			F.UpdateOverlay()

//Cleaning fairies
/mob/living/simple_animal/hostile/abnormality/titania/death(gibbed)
	for(var/mob/living/A in spawned_mobs)
		A.death()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		var/datum/status_effect/fairy_lights/F = H.has_status_effect(STATUS_EFFECT_FAIRY_LIGHTS)
		if(F)
			qdel(F)
	return ..()

//------------------------------------------------------------------------------
//Fairy Laws
//------------------------------------------------------------------------------

/mob/living/simple_animal/hostile/abnormality/titania/proc/SetLaw()
	if(IsCombatMap())
		return


	var/lawmessage

	nextlaw = pick(laws.Copy() - currentlaw)

	switch(nextlaw)
		if("melee")
			lawmessage = "汝不得以近战攻击伤害女王."
		if("ranged")
			lawmessage = "汝不得以远程攻击伤害女王."
		if("fairy")
			lawmessage = "余之精灵今更坚韧."
		if("armor")
			lawmessage = "汝等女王不受红色伤害所伤."
		if("ranged fairy")
			lawmessage = "若以远程攻击袭余，余之精灵必前来相助."

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		to_chat(H, span_colossus("[lawmessage]"))
	addtimer(CALLBACK(src, PROC_REF(ActivateLaw)), law_startup)	//Start Law 3 Seconds


/mob/living/simple_animal/hostile/abnormality/titania/proc/ActivateLaw()
	addtimer(CALLBACK(src, PROC_REF(SetLaw)), law_timer)	//Set Laws in 30 Seconds
	currentlaw = nextlaw
	to_chat(GLOB.clients, span_danger("新法律现已生效."))

	if(currentlaw == "fairies")
		for(var/mob/living/simple_animal/L in spawned_mobs)
			L.ChangeResistances(list(RED_DAMAGE = 0.1, WHITE_DAMAGE = 0.1, BLACK_DAMAGE = 0.1, PALE_DAMAGE = 0.1))
	else
		for(var/mob/living/simple_animal/L in spawned_mobs)
			L.ChangeResistances(list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1))


/mob/living/simple_animal/hostile/abnormality/titania/proc/Punishment(mob/living/sinner)
	to_chat(sinner, span_userdanger("你因违反精灵法则而受伤."))
	sinner.deal_damage(law_damage, PALE_DAMAGE)
	new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(sinner), pick(GLOB.alldirs))

//Ranged stuff
/mob/living/simple_animal/hostile/abnormality/titania/bullet_act(obj/projectile/Proj)
	..()

	if(!ishuman(Proj.firer))
		return

	if(currentlaw == "ranged")
		Punishment(Proj.firer)

	if(currentlaw == "armor" && Proj.damage_type == RED_DAMAGE)
		Punishment(Proj.firer)

	if(currentlaw == "ranged fairy")
		SpawnFairies(1)

//Melee stuff
/mob/living/simple_animal/hostile/abnormality/titania/attacked_by(obj/item/I, mob/living/user)
	..()

	if(!user)
		return

	if(currentlaw == "melee")
		Punishment(user)

	if(currentlaw == "armor" && I.damtype == RED_DAMAGE && I.force >= 10)
		Punishment(user)



//Breach, work, 'n' stuff
/mob/living/simple_animal/hostile/abnormality/titania/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	var/units_to_add = list(
		/mob/living/simple_animal/hostile/aminion/fairyswarm = 6,
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 6, TRUE, TRUE)
	addtimer(CALLBACK(src, PROC_REF(FairyLoop)), 10 SECONDS)	//10 seconds from now you start spawning fairies
	addtimer(CALLBACK(src, PROC_REF(SetLaw)), law_timer)	//Set Laws in 30 Seconds

/mob/living/simple_animal/hostile/abnormality/titania/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(agent_notfullsp)
		datum_reference.qliphoth_change(-1)
		agent_notfullsp = FALSE
	return

/mob/living/simple_animal/hostile/abnormality/titania/AttemptWork(mob/living/carbon/human/user, work_type)
	if(user.sanityhealth != user.maxSanity)
		agent_notfullsp = TRUE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/titania/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/titania/proc/OnHumanInsane(datum/source, mob/living/carbon/human/H, attribute)
	SIGNAL_HANDLER
	if(!IsContained())
		return FALSE
	if(!H.mind) // That wasn't a player at all...
		return FALSE
	if(H.z != z)
		return FALSE
	insane_counter += 1
	if(insane_counter >= 2)
		insane_counter = 0
		datum_reference.qliphoth_change(-1)
	return TRUE

//The flower
/mob/living/simple_animal/hostile/titania_flower
	name = "精灵花"
	desc = "A pretty purple flower."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "titania_flower"
	gender = NEUTER
	density = TRUE
	maxHealth = 200
	health = 200
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1)
	del_on_death = TRUE

/mob/living/simple_animal/hostile/titania_flower/Move()
	return FALSE

/mob/living/simple_animal/hostile/titania_flower/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/titania_flower/Destroy()
	for(var/atom/movable/AM in src) //morph code
		AM.forceMove(loc)
		if(prob(50))
			step(AM, pick(GLOB.alldirs))
	return ..()

//The Mini fairies
/mob/living/simple_animal/hostile/aminion/fairyswarm
	name = "精灵"
	desc = "渺小，但非常饥饿的精灵."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "fairyswarm"
	icon_living = "fairyswarm"
	pass_flags = PASSTABLE | PASSMOB
	is_flying_animal = TRUE
	density = FALSE
	a_intent = INTENT_HARM
	health = 10
	maxHealth = 10
	melee_damage_lower = 1
	melee_damage_upper = 3
	melee_damage_type = WHITE_DAMAGE
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	attack_verb_continuous = "cuts"
	attack_verb_simple = "cut"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	mob_size = MOB_SIZE_TINY
	del_on_death = TRUE
	can_patrol = TRUE
	can_affect_emergency = FALSE
	fear_level = 0
	var/mob/living/simple_animal/hostile/abnormality/titania/mommy
	var/mob/living/carbon/human/hitOnce = null
	var/datum/status_effect/fairy_lights/status

/mob/living/simple_animal/hostile/aminion/fairyswarm/Initialize()
	. = ..()
	pixel_x = rand(-16, 16)
	pixel_y = rand(-16, 16)

/mob/living/simple_animal/hostile/aminion/fairyswarm/EscapeConfinement()
	if(status)
		return
	return ..()

/mob/living/simple_animal/hostile/aminion/fairyswarm/MovedTryAttack()
	return FALSE

/mob/living/simple_animal/hostile/aminion/fairyswarm/Destroy()
	if(status)
		status.fairies -= src
		status.UpdateOverlay()
		status = null
	if(mommy)
		mommy.spawned_mobs -= src
		mommy = null
	return ..()

//Attacking code
/mob/living/simple_animal/hostile/aminion/fairyswarm/AttackingTarget(atom/attacked_target)
	if(ishuman(target))
		if(hitOnce == target)
			var/mob/living/victim = target
			if (victim.has_status_effect(STATUS_EFFECT_FAIRY_LIGHTS))
				var/datum/status_effect/fairy_lights/F = victim.has_status_effect(STATUS_EFFECT_FAIRY_LIGHTS)
				if(F.fairies.len < F.limit)
					F.duration = world.time + 30 SECONDS
					F.AddToPlayer(src)
					to_chat(victim, span_userdanger("另一只精灵正环绕你!"))
			else
				var/datum/status_effect/fairy_lights/F = victim.apply_status_effect(STATUS_EFFECT_FAIRY_LIGHTS)
				F.AddToPlayer(src)
				to_chat(victim, span_userdanger("一只精灵正环绕你!"))
		else
			hitOnce = target
	. = ..()

/datum/status_effect/fairy_lights
	id = "fairy_lights"
	alert_type = /atom/movable/screen/alert/status_effect/fairy_lights
	duration = 30 SECONDS // Hits 15 times
	tick_interval = 2 SECONDS
	var/list/fairies = list()
	var/limit = 4
	var/current_overlay = ""

/atom/movable/screen/alert/status_effect/fairy_lights
	name = "精灵光辉"
	desc = "围绕你飞舞的精灵正在对你造成白色伤害！"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "fairy_lights"

/datum/status_effect/fairy_lights/on_apply()
	. = ..()
	if(!owner)
		return
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(HurtFaries))

/datum/status_effect/fairy_lights/on_remove()
	. = ..()
	if(!owner)
		return
	if(fairies.len > 0)
		for(var/mob/living/simple_animal/hostile/aminion/fairyswarm/fairy in fairies)
			fairy.toggle_ai(AI_ON)
			fairy.forceMove(get_turf(owner))
			fairy.status = null
			fairies -= fairy
	if(ishuman(owner))
		owner.cut_overlay(mutable_appearance('icons/effects/32x64.dmi', current_overlay, -FIRE_LAYER))
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)

/datum/status_effect/fairy_lights/proc/AddToPlayer(mob/living/simple_animal/hostile/aminion/fairyswarm/F)
	if(F)
		fairies += F
		F.forceMove(owner)
		F.status = src
		F.toggle_ai(AI_OFF)
		UpdateOverlay()

/datum/status_effect/fairy_lights/proc/UpdateOverlay()
	if(fairies.len < 1)//to prevent overlays from sticking
		return
	if(fairies.len > 1)
		linked_alert.desc = "[fairies.len]个小精灵环绕在你的头顶，使你受到白色伤害!."
	else
		linked_alert.desc = "一个小精灵环绕在你的头顶，使你受到白色伤害!."
	if(ishuman(owner))
		var/old_overlay = current_overlay
		current_overlay = "fairy_lights_[fairies.len]"
		var/mob/living/simple_animal/hostile/aminion/fairyswarm/F = fairies[1]
		if(F)
			if(F.icon_state == "fairyswarm_oberon")
				current_overlay += "_oberon"
		owner.cut_overlay(mutable_appearance('icons/effects/32x64.dmi', old_overlay, -FIRE_LAYER))
		owner.cut_overlay(mutable_appearance('icons/effects/32x64.dmi', current_overlay, -FIRE_LAYER))
		owner.add_overlay(mutable_appearance('icons/effects/32x64.dmi', current_overlay, -FIRE_LAYER))

/datum/status_effect/fairy_lights/proc/HurtFaries(datum/source, damage, damagetype, def_zone)
	if(!owner || damagetype != RED_DAMAGE)//I know in wonderlab it says red or white but if it was white than fairies could kill the fairies inside you
		return
	if(!damage || damage < 15)
		return
	if(fairies.len > 1)
		to_chat(owner, span_nicegreen("这道致命的攻击消灭了所有环绕你的精灵."))
	else
		to_chat(owner, span_nicegreen("这道攻击消灭了环绕你的精灵."))
	for(var/mob/living/simple_animal/hostile/aminion/fairyswarm/F in fairies)
		qdel(F)
	qdel(src)

/datum/status_effect/fairy_lights/tick()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(fairies.len > 1)
		owner.visible_message(span_danger("围绕[owner]飞舞的精灵正在将花蜜洒在他们的头上!"), span_danger("飞舞的精灵正在将花蜜洒在你身上!"))
	else
		owner.visible_message(span_danger("环绕[owner]的精灵正在将花蜜洒在他们的头上!"), span_danger("环绕你的精灵正在将花蜜洒在你身上!"))
	playsound(owner, 'sound/effects/magic.ogg', 25, TRUE)
	H.deal_damage(3 * fairies.len, WHITE_DAMAGE)
	if(H.sanity_lost && H.stat != DEAD)
		H.death()
		H.visible_message(span_userdanger("[H]倒在地上，花朵从他的身体中开始绽放!"))
		var/obj/flower_overlay = new
		flower_overlay.icon = 'ModularTegustation/Teguicons/32x32.dmi'
		flower_overlay.icon_state = "fairy_kill"
		flower_overlay.layer = -BODY_FRONT_LAYER
		flower_overlay.plane = FLOAT_PLANE
		flower_overlay.mouse_opacity = 0
		flower_overlay.vis_flags = VIS_INHERIT_ID
		flower_overlay.alpha = 0
		flower_overlay.setDir(H.dir)
		animate(flower_overlay, alpha = 255, time = 2 SECONDS)
		H.vis_contents += flower_overlay
		for(var/mob/living/simple_animal/hostile/aminion/fairyswarm/fairy in fairies)
			if(fairy.mommy)
				fairy.mommy.SpawnFairies(1, H, ignore_cap = TRUE)
		qdel(src)

#undef STATUS_EFFECT_FAIRY_LIGHTS
