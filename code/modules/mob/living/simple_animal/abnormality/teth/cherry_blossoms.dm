#define STATUS_EFFECT_MARKEDFORDEATH /datum/status_effect/markedfordeath
/mob/living/simple_animal/hostile/abnormality/cherry_blossoms
	name = "樱下墓"
	desc = "一棵美丽的樱花树."
	icon = 'ModularTegustation/Teguicons/128x128.dmi'
	icon_state = "graveofcherryblossoms_3"
	portrait = "cherry_blossoms"
	pixel_x = -48
	base_pixel_x = -48
	pixel_y = -16
	base_pixel_y = -16
	maxHealth = 230
	health = 230
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 55,
		ABNORMALITY_WORK_ATTACHMENT = 55,
		ABNORMALITY_WORK_REPRESSION = 20,
	)
	start_qliphoth = 3
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/lust
	max_boxes = 12
	good_hater = TRUE

	ego_list = list(
		/datum/ego_datum/weapon/blossom,
		/datum/ego_datum/armor/blossom,
	)
	gift_type = /datum/ego_gifts/blossom
	abnormality_origin = ABNORMALITY_ORIGIN_ALTERED

	observation_prompt = "树上点缀着美丽的叶子，四处生长。<br>\
		在这阴暗沉闷的场所中，你本不敢奢望能见到此等景象。<br>\
		你可以在开始工作前，花点时间欣赏眼前的美景。"
	observation_choices = list(
		"欣赏美景" = list(TRUE, "仅仅是花片刻欣赏此等美丽之物，你便感到精神焕发. <br>\
			这并不意味着你不知道这是个危险的异想体. <br>\
			即便在可怖之物中，亦存在美感. <br>\
			就连这树下的尸骸想必也会赞同你的想法."),
	)

	var/number_of_marks = 5

/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.sanity_lost)
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(70))
		datum_reference.qliphoth_change(-1)
	if(datum_reference.qliphoth_meter !=3)
		icon_state = "graveofcherryblossoms_[datum_reference.qliphoth_meter]"

/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/ZeroQliphoth(mob/living/carbon/human/user)
	INVOKE_ASYNC(src, PROC_REF(mark_for_death))
	icon_state = "graveofcherryblossoms_0"
	datum_reference.qliphoth_change(3)

/mob/living/simple_animal/hostile/abnormality/cherry_blossoms/proc/mark_for_death()
	var/list/potentialmarked = list()
	var/list/marked = list()

	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		potentialmarked += L
		to_chat(L, span_danger("现在樱花盛开的季节."))

	SLEEP_CHECK_DEATH(10 SECONDS)
	for(var/blossoming in 1 to number_of_marks)
		var/mob/living/Y = pick(potentialmarked)
		if(faction_check_mob(Y, FALSE) || Y.z != z || Y.stat == DEAD)
			continue
		if(Y in marked)
			continue
		marked += Y
		new /obj/effect/temp_visual/markedfordeath(get_turf(Y))
		to_chat(Y, span_userdanger("你感觉自己要死了!"))
		Y.apply_status_effect(STATUS_EFFECT_MARKEDFORDEATH)

//Mark for Death
//A very quick, frantic 10 seconds of instadeath.
/datum/status_effect/markedfordeath
	id = "markedfordeath"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/marked

/atom/movable/screen/alert/status_effect/marked
	name = "死亡标记"
	desc = "你被死亡标记了，你会死的."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "marked_for_death"

/datum/status_effect/markedfordeath/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod *= 3
	status_holder.physiology.white_mod *= 3
	status_holder.physiology.black_mod *= 3
	status_holder.physiology.pale_mod *= 3

/datum/status_effect/markedfordeath/tick()
	var/mob/living/carbon/human/status_holder = owner
	if(status_holder.sanity_lost)
		status_holder.death()
	if(owner.stat != DEAD)
		return
	for(var/mob/living/carbon/human/affected_human in GLOB.player_list)
		if(affected_human.stat == DEAD)
			continue
		affected_human.adjustBruteLoss(-500) // It heals everyone to full
		affected_human.restoreSanity() // It heals everyone to full
		affected_human.remove_status_effect(STATUS_EFFECT_MARKEDFORDEATH)

/datum/status_effect/markedfordeath/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod /= 3
	status_holder.physiology.white_mod /= 3
	status_holder.physiology.black_mod /= 3
	status_holder.physiology.pale_mod /= 3

#undef STATUS_EFFECT_MARKEDFORDEATH
