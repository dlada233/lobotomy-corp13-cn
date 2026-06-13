// coded by Byrene on July 2022. my first code, please go easy on me
// shoutout to InsightfulParasite for doing the sprites
/mob/living/simple_animal/hostile/abnormality/happyteddybear
	name = "快乐泰迪"
	desc = "一只破旧的泰迪熊，它少了一只眼睛，从各种破口中溢出填充物."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "teddy"
	icon_living = "teddy"
	portrait = "happy_teddy_bear"
	// adding this for when it drops you
	layer = BELOW_OBJ_LAYER
	maxHealth = 500
	health = 500
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(40, 45, 45, 35, 35),
		ABNORMALITY_WORK_ATTACHMENT = list(60, 60, 60, 50, 45),
		ABNORMALITY_WORK_REPRESSION = list(40, 45, 45, 40, 35),
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gloom
	max_boxes = 15
	response_help_continuous = "hugs" // :-)
	response_help_simple = "hug"
	buckled_mobs = list()
	buckle_lying = FALSE

	ego_list = list(
		/datum/ego_datum/weapon/paw,
		/datum/ego_datum/armor/paw,
	)
	gift_type =  /datum/ego_gifts/bearpaw
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/hurting_teddy = 1.5,
	)
	observation_prompt = "眼前是件被遗弃的垃圾：泰迪熊玩偶. <br>它的绒毛四处支棱. <br>\
		积满的灰尘诉说着它被抛弃的岁月. <br>作为眼睛的纽扣中，有一颗已摇摇欲坠."
	observation_choices = list(
		"取下纽扣" = list(TRUE, "你取下那颗纽扣。<br>\
			莫名的感到不安。<br>\
			这枚老旧腐朽的纽扣有点令人不适。<br>\
			你小心翼翼地将制服纽扣缝制到原位上。<br>\
			纽扣不对称让玩偶略显怪异，但看起来还是比之前好一点。"),
		"置之不理" = list(FALSE, "你不知如何处置，最终选择离开。<br>\
			泰迪熊静坐原处，纹丝未动。"),
	)

	/// if the same person works on Happy Teddy Bear twice in a row, the person will die unless certain requirements are met.
	var/last_worker = null
	var/hugging = FALSE
	var/break_check

/mob/living/simple_animal/hostile/abnormality/happyteddybear/proc/Strangle(mob/living/carbon/human/user)
	hugging = TRUE
	user.Stun(30 SECONDS)
	step_towards(user, src)
	sleep(0.5 SECONDS)
	if(QDELETED(user))
		hugging = FALSE
		last_worker = null
		return
	step_towards(user, src)
	sleep(0.5 SECONDS)
	if(QDELETED(user))
		hugging = FALSE
		last_worker = null
		return
	buckle_mob(user, force = TRUE, check_loc = FALSE)
	icon_state = "teddy_hug"
	visible_message(span_warning("[src]拥抱[user]!"))
	var/last_pinged = 0
	var/time_strangled = 0
	while(user.stat != DEAD)
		if(time_strangled >= 4 && get_attribute_level(user, FORTITUDE_ATTRIBUTE) >= 80)
			if(user.stat != UNCONSCIOUS) //Wouldn't make sense if they break free while passed out
				break_check = TRUE
				unbuckle_mob(user, force=TRUE)
				icon_state = "teddy"
				visible_message(span_warning("[user]挣脱了[src]的拥抱!"))
				hugging = FALSE
				last_worker = null
				user.SetStun(0)
				break_check = FALSE
				return
		if(time_strangled > 30) // up to 30 seconds, so this doesn't go on forever
			user.death(gibbed=FALSE)
			break
		if(world.time > last_pinged + 5 SECONDS)
			to_chat(user, span_userdanger("[src] 让你窒息!"))
			last_pinged = world.time
		user.adjustOxyLoss(10, updating_health=TRUE, forced=TRUE)
		time_strangled++
		SLEEP_CHECK_DEATH(1 SECONDS)
		if(QDELETED(user))
			hugging = FALSE
			last_worker = null
			icon_state = "teddy"
			return
	unbuckle_mob(user, force=TRUE)
	icon_state = "teddy"
	visible_message(span_warning("[src]将[user]掉落到地上!"))
	hugging = FALSE
	last_worker = null

// can only unbuckle dead things
// hopefully prevents people from attempting to "save" the victim, which would break the immersion
// (because strangle code will continue whether they're buckled or not)
/mob/living/simple_animal/hostile/abnormality/happyteddybear/unbuckle_mob(mob/living/buckled_mob, force)
	if(buckled_mob.stat != DEAD && break_check == FALSE)
		return
	..()

/mob/living/simple_animal/hostile/abnormality/happyteddybear/AttemptWork(mob/living/carbon/human/user, work_type)
	if(hugging) // can't work while someone is being killed by it
		return FALSE
	if(user == last_worker)
		Strangle(user)
		return FALSE
	last_worker = user
	return TRUE
