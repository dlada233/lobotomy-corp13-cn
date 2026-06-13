#define STATUS_EFFECT_PRANKED /datum/status_effect/pranked
/mob/living/simple_animal/hostile/abnormality/laetitia
	name = "蕾蒂希娅"
	desc = "小女巫."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "laetitia"
	portrait = "laetitia"
	maxHealth = 400
	health = 400
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 45, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = list(60, 60, 60, 65, 65),
		ABNORMALITY_WORK_REPRESSION = 0,
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/lust
	max_boxes = 16 // Accurate to base game
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 1
	melee_damage_upper = 2
	attack_verb_continuous = "slaps"
	attack_verb_simple = "slap"

	ego_list = list(
		/datum/ego_datum/weapon/prank,
		/datum/ego_datum/armor/prank,
	)
	gift_type = /datum/ego_gifts/prank
	gift_message = "希望您对此满意!"
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "这个地方如此阴暗，每个人看起来总是那么悲伤，而且从不微笑。<br>\
		独自悲伤很孤单，所以，这个小女孩一直在偷偷送给他们装满朋友的礼物！<br>\
		他们喜欢这个惊喜吗？"
	observation_choices = list(
		"说实话" = list(TRUE, "哦，真令人难过...<br>即使他们是我的朋友，也不代表他们也是你的朋友。<br>\
			我不会送你礼物，但是，你今天能留下来多陪我玩一会儿吗？"),
		"撒谎说他们喜欢" = list(FALSE, "我很高兴！<br>真希望我能看到他们的表情，我敢说他们一定很惊讶！<br>\
			你看起来也很孤单，希望我的礼物也能让你笑起来！"),
	)

	attack_action_types = list(/datum/action/cooldown/laetitia_gift, /datum/action/cooldown/laetitia_summon)
	var/breaching = FALSE
	var/summon_cooldown
	var/summon_cooldown_time = 60 SECONDS
	var/summon_count = 0

/datum/action/cooldown/laetitia_summon
	name = "呼叫朋友"
	icon_icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	button_icon_state = "prank_gift"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = 60 SECONDS
	var/delete_timer
	var/delete_cooldown = 30 SECONDS
	var/mob/living/simple_animal/hostile/aminion/gift/G1
	var/mob/living/simple_animal/hostile/aminion/gift/G2

/datum/action/cooldown/laetitia_summon/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/laetitia))
		return FALSE

	StartCooldown()
	G1 = new /mob/living/simple_animal/hostile/aminion/gift(owner.loc)
	G2 = new /mob/living/simple_animal/hostile/aminion/gift(owner.loc)
	delete_timer = addtimer(CALLBACK(src, PROC_REF(delete)), delete_cooldown, TIMER_STOPPABLE)
	// send poll to all ghosts and wait
	var/list/candidates = pollGhostCandidates("蕾蒂希娅在求救！你愿意保护她吗?", poll_time=100)
	if (LAZYLEN(candidates) > 0)
		var/mob/dead/observer/C = pick(candidates)
		G1.key = C.key
		candidates -= C
	if (LAZYLEN(candidates) > 0)
		var/mob/dead/observer/C = pick(candidates)
		G2.key = C.key
		candidates -= C

/datum/action/cooldown/laetitia_summon/proc/delete()
	if (!G1.ckey)
		qdel(G1)
	if (!G2.ckey)
		qdel(G2)

/datum/action/cooldown/laetitia_gift
	name = "Gift"
	icon_icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	button_icon_state = "prank_gift"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = 10 SECONDS
	var/view_distance = 3

/datum/action/cooldown/laetitia_gift/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/laetitia))
		return FALSE
	var/kind = tgui_alert(owner, "什么样的礼物?", "自定义发言", list("Good", "Bad"))
	var/strength = text2num(tgui_alert(owner, "这份礼物的力量是什么?", "自定义发言", list("1", "2", "3")))
	if (strength == null)
		strength = 2
	var/obj/item/laetitia_gift/g = new /obj/item/laetitia_gift(owner.loc)
	g.strength = strength
	if (strength == 1)
		g.color = "#F48FB1"
		g.name = "小蕾蒂希娅的礼物"
	else if (strength == 3)
		g.color = "#C2185B"
		g.name = "大蕾蒂希娅的礼物"
	if (kind == "Good")
		g.strength *= -1
	StartCooldown()

/obj/item/laetitia_gift
	name = "蕾蒂希娅的礼物"
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "prank_gift"
	var/opening = FALSE
	var/oneuse = TRUE
	var/basepower = 5
	var/strength = 1

/obj/item/laetitia_gift/attack_self(mob/user)
	if(opening)
		to_chat(user, span_warning("你已经打开了这个礼物!"))
		return FALSE
	opening = TRUE
	to_chat(user, "打开礼物!")
	if(do_after(user, 5 SECONDS, src))
		playsound(get_turf(src), 'sound/abnormalities/laetitia/spider_born.ogg', 50, 1)
		if (istype(user, /mob/living))
			var/mob/living/L = user
			L.apply_damage((basepower*strength), RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), FALSE, TRUE)
		for(var/turf/T in range(2, user))
			new /obj/effect/temp_visual/smash_effect(T)
			user.HurtInTurf(T, list(), (basepower*strength), RED_DAMAGE, check_faction = FALSE, hurt_mechs = TRUE)
		to_chat(user, "你打开了礼物!")
		qdel(src)
	opening = FALSE

/mob/living/simple_animal/hostile/abnormality/laetitia/Life()
	. = ..()
	if(!breaching)
		return
	if((summon_cooldown < world.time) && !(status_flags & GODMODE))
		SummonAdds()

/mob/living/simple_animal/hostile/abnormality/laetitia/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	var/datum/status_effect/pranked/P = user.has_status_effect(STATUS_EFFECT_PRANKED)
	if(P)
		if(prob(15)) //15% chance to remove prank
			user.remove_status_effect(STATUS_EFFECT_PRANKED)
		else if(prob(15)) //15% chance to trigger explosion
			P.TriggerPrank()
	else
		if(prob(70)) //not 100% of the time to be funny
			var/datum/status_effect/pranked/SE = user.apply_status_effect(STATUS_EFFECT_PRANKED)
			SE.laetitia_datum_reference = datum_reference
	return

/mob/living/simple_animal/hostile/abnormality/laetitia/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	var/datum/status_effect/pranked/P = user.has_status_effect(STATUS_EFFECT_PRANKED)
	if(P && prob(30)) //30% to remove prank
		user.remove_status_effect(STATUS_EFFECT_PRANKED)
	return

/mob/living/simple_animal/hostile/abnormality/laetitia/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	var/datum/status_effect/pranked/P = user.has_status_effect(STATUS_EFFECT_PRANKED)
	if(P && prob(70)) //70% to trigger explosion
		P.TriggerPrank()
	return

/mob/living/simple_animal/hostile/abnormality/laetitia/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_MINING)
		breaching = TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/laetitia/proc/SummonAdds()//Mining breach summon
	summon_cooldown = world.time + summon_cooldown_time
	if(summon_count > 9)//this list is not subtracted when minions are killed. Limited to 10 per breach
		return
	var/turf/target_turf = get_turf(src)
	new /mob/living/simple_animal/hostile/aminion/gift(target_turf)
	summon_count += 1

//Her friend
/mob/living/simple_animal/hostile/aminion/gift
	name = "小女巫的朋友"
	desc = "这是一个可怕的肉体和眼睛的融合体"
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "witchfriend"
	icon_living = "witchfriend"
	icon_dead = "witchfriend_dead"
	maxHealth = 350
	health = 350
	pixel_x = -16
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1)
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	melee_damage_lower = 8
	melee_damage_upper = 10
	rapid_melee = 0.7
	faction = list("hostile", "laetitia")
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/abnormalities/laetitia/spider_attack.ogg'
	death_sound = 'sound/abnormalities/laetitia/spider_dead.ogg'
	threat_level = HE_LEVEL
	score_divider = 1.5

/mob/living/simple_animal/hostile/aminion/gift/Initialize()
	. = ..()
	playsound(get_turf(src), 'sound/abnormalities/laetitia/spider_born.ogg', 50, 1)

/mob/living/simple_animal/hostile/aminion/gift/AttackingTarget(atom/attacked_target)
	if (istype(attacked_target, /mob/living/simple_animal/hostile/abnormality/laetitia))
		manual_emote("拍拍蕾蒂希娅")
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/aminion/gift/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	return ..()

//Given Prank Gift
//Explodes after 3 to 4 minutes
/datum/status_effect/pranked
	id = "pranked"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	var/laetitia_datum_reference
	var/obj/prank_overlay

/datum/status_effect/pranked/on_creation(mob/living/new_owner, ...)
	duration = rand(1800,2400)
	return ..()

/datum/status_effect/pranked/on_apply()
	if(get_attribute_level(owner, PRUDENCE_ATTRIBUTE) >= 80)
		to_chat(owner, span_warning("你感到有东西溜进了你的口袋."))
	RegisterSignal(owner, COMSIG_WORK_STARTED, PROC_REF(WorkCheck))
	return ..()

/datum/status_effect/pranked/tick()
	if(!(duration - world.time) <= 100) //at most a 10 second warning
		return
	if(prank_overlay && (get_attribute_level(owner, PRUDENCE_ATTRIBUTE) < 60))
		return
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	//i swear this is all necessary
	prank_overlay = new
	prank_overlay.icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	prank_overlay.icon_state = "prank_gift"
	prank_overlay.layer = -BODY_FRONT_LAYER
	prank_overlay.plane = FLOAT_PLANE
	prank_overlay.mouse_opacity = 0
	prank_overlay.vis_flags = VIS_INHERIT_ID
	prank_overlay.alpha = 0
	to_chat(status_holder, span_danger("你的心形礼物开始破裂..."))
	animate(prank_overlay, alpha = 255, time = (duration - world.time))
	status_holder.vis_contents += prank_overlay

/datum/status_effect/pranked/on_remove()
	UnregisterSignal(owner, COMSIG_WORK_STARTED)
	if(prank_overlay in owner.vis_contents)
		owner.vis_contents -= prank_overlay
	if(!duration < world.time) //if prank removed due to it expiring
		return
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_userdanger("你感到身体深处有东西爆炸了!"))
	status_holder.vis_contents -= prank_overlay
	var/location = get_turf(status_holder)
	new /mob/living/simple_animal/hostile/aminion/gift(location)
	var/rand_dir = pick(NORTH, SOUTH, EAST, WEST)
	var/atom/throw_target = get_edge_target_turf(status_holder, rand_dir)
	if(!status_holder.anchored)
		status_holder.throw_at(throw_target, rand(1, 3), 7, status_holder)
	status_holder.deal_damage(50, RED_DAMAGE)//Usually a kill, you can block it if you're good

/datum/status_effect/pranked/proc/TriggerPrank()
	//immediately set to 10 seconds, don't shorten if less than 10 seconds remaining
	var/newduration = duration - world.time
	newduration = clamp(newduration, 0, 100)
	duration = world.time + newduration

//Half prank duration once if you work with another abnorm
/datum/status_effect/pranked/proc/WorkCheck(datum/source, datum/abnormality/datum_sent, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if(datum_sent == laetitia_datum_reference)
		return
	var/newduration = duration
	newduration = (newduration - world.time)/2
	duration = newduration + world.time
	UnregisterSignal(owner, COMSIG_WORK_STARTED)

#undef STATUS_EFFECT_PRANKED
