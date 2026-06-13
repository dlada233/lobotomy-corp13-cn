#define STATUS_EFFECT_COWARDICE /datum/status_effect/cowardice
/mob/living/simple_animal/hostile/abnormality/crumbling_armor
	name = "破裂铠甲"
	desc = "一套完全老化的武士式盔甲，头盔上有一个V形的纹章，它看起来很破旧."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "crumbling"
	portrait = "crumbling_armor"
	maxHealth = 230
	health = 230
	start_qliphoth = 3
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 50, 55, 55, 60),
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(60, 60, 65, 65, 70),
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/wrath
	max_boxes = 12

	ego_list = list(
		/datum/ego_datum/weapon/daredevil,
		/datum/ego_datum/armor/daredevil,
	)
	gift_type = null
	gift_chance = 100
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	secret_chance = TRUE
	secret_icon_state = "megalovania"

	observation_prompt = "夺走许多人生命的盔甲就在你面前. <br>如果你愿意，你可以穿上它."
	observation_choices = list(
		"穿上" = list(TRUE, "看起来你不是和平主义者. <br>你感受到盔甲的温暖欢迎."),
		"不要穿" = list(FALSE, "盔甲在等待另一个无畏的人."),
	)

	var/buff_icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	var/user_armored
	var/numbermarked
	var/meltdown_cooldown //no spamming the meltdown effect
	var/meltdown_cooldown_time = 30 SECONDS
	var/armor_dispensed

// Hacky code to make the final observation check for a gift type without actually having it as a gift type
/mob/living/simple_animal/hostile/abnormality/crumbling_armor/FinalObservation(mob/living/carbon/human/user)
	gift_type = /datum/ego_gifts/recklessCourage
	..()
	gift_type = null

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/ObservationResult(mob/living/carbon/human/user, success, reply)
	. = ..()
	if(success)
		var/datum/ego_gifts/recklessCourage/R = new
		user.Apply_Gift(R)
		if(!armor_dispensed) // You only get one of these. Ever.
			new /obj/item/clothing/suit/armor/ego_gear/he/crumbling_armor(get_turf(user))
			armor_dispensed = TRUE

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(1)

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/proc/Cut_Head(datum/source, datum/abnormality/datum_sent, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/courage) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/recklessCourage) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/recklessFoolish) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/foolish) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase1) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase2) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase3) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase4))
		if (work_type != ABNORMALITY_WORK_ATTACHMENT)
			return
		var/obj/item/bodypart/head/head = user.get_bodypart("head")
		//Thanks Red Queen
		if(!istype(head))
			return FALSE
		if(!isnull(user.ego_gift_list[HAT]) && istype(user.ego_gift_list[HAT], /datum/ego_gifts))
			var/datum/ego_gifts/removed_gift = user.ego_gift_list[HAT]
			removed_gift.Remove(user)
			//user.ego_gift_list[HAT].Remove(user)
		head.dismember()
		user.adjustBruteLoss(500)
		datum_reference.qliphoth_change(-1)
		return TRUE
	UnregisterSignal(user, COMSIG_WORK_STARTED)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if (get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 40)
		var/obj/item/bodypart/head/head = user.get_bodypart("head")
		//Thanks Red Queen
		if(!istype(head))
			return
		head.dismember()
		user.adjustBruteLoss(500)
		datum_reference.qliphoth_change(-1)
		return
	if(user.stat != DEAD && work_type == ABNORMALITY_WORK_REPRESSION)
		if (src.icon_state == "megalovania")
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase1)) // From Courage to Recklessness
				playsound(get_turf(user), 'sound/abnormalities/crumbling/megalovania.ogg', 50, 0, 2)
				var/datum/ego_gifts/phase2/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, span_userdanger("还需要多少?"))
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase2)) // From Recklessness to Foolishness
				playsound(get_turf(user), 'sound/abnormalities/crumbling/megalovania.ogg', 50, 0, 2)
				var/datum/ego_gifts/phase3/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, span_userdanger("你需要更多力量!"))
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase3)) // From Foolishness to Suicidal
				playsound(get_turf(user), 'sound/abnormalities/crumbling/megalovania.ogg', 50, 0, 2)
				var/datum/ego_gifts/phase4/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, span_userdanger("决心."))
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase4)) // You can progress no further down this fool-hardy path
				return
			playsound(get_turf(user), 'sound/abnormalities/crumbling/megalovania.ogg', 50, 0, 2)
			var/datum/ego_gifts/phase1/CAEG = new
			CAEG.datum_reference = datum_reference
			user.Apply_Gift(CAEG)
			RegisterSignal(user, COMSIG_WORK_STARTED, PROC_REF(Cut_Head))
			to_chat(user, span_userdanger("只要一滴血就够了..."))
		else
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/courage)) // From Courage to Recklessness
				playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
				var/datum/ego_gifts/recklessCourage/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, span_userdanger("你的肌肉随着力量而紧绷!"))
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/recklessCourage)) // From Recklessness to Foolishness
				playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
				var/datum/ego_gifts/recklessFoolish/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, span_userdanger("你觉得自己可以征服整个世界!"))
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/recklessFoolish)) // From Foolishness to Suicidal
				playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
				var/datum/ego_gifts/foolish/CAEG = new
				CAEG.datum_reference = datum_reference
				user.Apply_Gift(CAEG)
				to_chat(user, span_userdanger("你是行走在人间的神!"))
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/foolish)) // You can progress no further down this fool-hardy path
				return
			playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
			var/datum/ego_gifts/courage/CAEG = new
			CAEG.datum_reference = datum_reference
			user.Apply_Gift(CAEG)
			RegisterSignal(user, COMSIG_WORK_STARTED, PROC_REF(Cut_Head))
			to_chat(user, span_userdanger("一种奇怪的力量在你身上流动!"))
	return

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/ZeroQliphoth(mob/living/carbon/human/user)
	datum_reference.qliphoth_change(3) //no need for qliphoth to be stuck at 0
	if(meltdown_cooldown > world.time)
		return
	meltdown_cooldown = world.time + meltdown_cooldown_time
	MeltdownEffect()
	return

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/proc/MeltdownEffect(mob/living/carbon/human/user)
	var/list/potentialmarked = list()
	var/list/marked = list()
	sound_to_playing_players_on_level('sound/abnormalities/crumbling/globalwarning.ogg', 25, zlevel = z)
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(faction_check_mob(L, FALSE) || L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		potentialmarked += L
		to_chat(L, span_userdanger("你感到一种强烈的恐惧感."))

	numbermarked = 1 + round(LAZYLEN(potentialmarked) / 5, 1) //1 + 1 in 5 potential players, to the nearest whole number
	SLEEP_CHECK_DEATH(10 SECONDS)
	sound_to_playing_players_on_level('sound/abnormalities/crumbling/warning.ogg', 50, zlevel = z)
	var/mob/living/Y
	for(var/i = numbermarked, i>=1, i--)
		if(potentialmarked.len <= 0)
			break
		Y = pick(potentialmarked)
		potentialmarked -= Y
		if(Y.stat == DEAD) //they chose to die instead of facing the fear
			continue
		marked+=Y
		playsound(get_turf(Y), 'sound/abnormalities/crumbling/warning.ogg', 50, FALSE, -1)

	SLEEP_CHECK_DEATH(1 SECONDS)
	for(Y in marked)
		to_chat(Y, span_userdanger("让我看看你能否坚持自己的立场!"))
		new /obj/effect/temp_visual/markedfordeath(get_turf(Y))
		Y.apply_status_effect(STATUS_EFFECT_COWARDICE)

//status
/datum/status_effect/cowardice
	id = "cowardice"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/cowardice
	var/punishment_damage = 4

/atom/movable/screen/alert/status_effect/cowardice
	name = "怯懦"
	desc = "让我看看你能否坚持自己的立场!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "crumbling"

/datum/status_effect/cowardice/on_apply()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(Punishment))
	return..()

/datum/status_effect/cowardice/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	return..()

/datum/status_effect/cowardice/proc/Punishment()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/status_holder = owner
	if(!istype(status_holder))
		return
	var/obj/item/bodypart/head/holders_head = owner.get_bodypart("head")
	if(!istype(holders_head))
		return FALSE
	playsound(get_turf(status_holder), 'sound/abnormalities/crumbling/attack.ogg', 50, FALSE)
	status_holder.deal_damage(punishment_damage, PALE_DAMAGE)
	if(status_holder.health < 0)
		holders_head.dismember()
	new /obj/effect/temp_visual/slice(get_turf(status_holder))
	qdel(src)


//gifts
/datum/ego_gifts/courage
	name = "激励勇气"
	icon_state = "courage"
	justice_bonus = 10
	slot = HAT
/datum/ego_gifts/recklessCourage
	name = "鲁莽勇气"
	icon_state = "recklessFirst"
	fortitude_bonus = -5
	justice_bonus = 10
	slot = HAT
/datum/ego_gifts/recklessFoolish
	name = "鲁莽愚行"
	icon_state = "recklessSecond"
	fortitude_bonus = -10
	justice_bonus = 15
	slot = HAT
/datum/ego_gifts/foolish
	name = "鲁莽愚行"
	icon_state = "foolish"
	fortitude_bonus = -20
	justice_bonus = 20
	slot = HAT
/datum/ego_gifts/phase1
	name = "Lv 4"
	icon_state = "phase1"
	justice_bonus = 10
	slot = HAT
/datum/ego_gifts/phase2
	name = "Lv 10"
	icon_state = "phase2"
	fortitude_bonus = -5
	justice_bonus = 10
	slot = HAT
/datum/ego_gifts/phase3
	name = "Lv 15"
	icon_state = "phase3"
	fortitude_bonus = -10
	justice_bonus = 15
	slot = HAT
/datum/ego_gifts/phase4
	name = "Lv 19"
	icon_state = "phase4"
	fortitude_bonus = -20
	justice_bonus = 20
	slot = HAT

#undef STATUS_EFFECT_COWARDICE
