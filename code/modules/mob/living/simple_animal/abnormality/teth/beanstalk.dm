//Coded by Coxswain, sprite by Mel
/mob/living/simple_animal/hostile/abnormality/beanstalk
	name = "没有杰克的豆茎"
	desc = "一根巨大的茎，高度远超目视极限."
	icon = 'ModularTegustation/Teguicons/64x98.dmi'
	icon_state = "beanstalk"
	portrait = "beanstalk"
	maxHealth = 230
	health = 230
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(35, 45, 55, 0, 10),
		ABNORMALITY_WORK_INSIGHT = 55,
		ABNORMALITY_WORK_ATTACHMENT = 55,
		ABNORMALITY_WORK_REPRESSION = 35,
	)
	pixel_x = -16
	base_pixel_x = -16
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/wrath

	ego_list = list(
		/datum/ego_datum/weapon/bean,
		/datum/ego_datum/weapon/giant,
		/datum/ego_datum/armor/bean,
	)
	gift_type = /datum/ego_gifts/bean
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	observation_prompt = "你记得曾有位员工痴迷于这个异想体。<br>\"\
		如果你爬到顶端，就会找到你一直追寻的东西！\"，他逢人便说。<br>\
		有天他真的爬上了豆茎，再也没下来。<br>也许他在上面过得不错。"
	observation_choices = list( //TODO: Make this event a bit special
		"砍倒它" = list(TRUE, "如果某物庞大到无法理解，那它就不该存在，斧刃深深劈入茎干..."),
		"爬上豆茎" = list(FALSE, "你开始攀爬豆茎，但无论爬了多久，上方总还有更多茎干. 你眯眼望向云层，却仍看不到任何人影..."),
	)

	var/climbing = FALSE

/mob/living/simple_animal/hostile/abnormality/beanstalk/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/beanstalk/CanAttack(atom/the_target)
	return FALSE

//Performing instinct work at >4 fortitude starts a special work
/mob/living/simple_animal/hostile/abnormality/beanstalk/AttemptWork(mob/living/carbon/human/user, work_type)
	if((get_attribute_level(user, FORTITUDE_ATTRIBUTE) >= 80) && (work_type == ABNORMALITY_WORK_INSTINCT))
		work_damage_upper *= 2
		work_damage_lower *= 1.5
		climbing = TRUE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/beanstalk/proc/ResetWorkDamage()
	work_damage_upper = initial(work_damage_upper)
	work_damage_lower = initial(work_damage_lower)

//When working at <2 Temperance and Prudence, or when panicking it is an instant death.
/mob/living/simple_animal/hostile/abnormality/beanstalk/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40 && get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 40 || user.sanity_lost)
		user.Stun(30 SECONDS)
		step_towards(user, src)
		sleep(0.5 SECONDS)
		if(QDELETED(user))
			return
		step_towards(user, src)
		sleep(0.5 SECONDS)
		if(QDELETED(user))
			return
		animate(user, alpha = 0,pixel_x = 0, pixel_z = 16, time = 3 SECONDS)
		to_chat(user, span_userdanger("不管发生什么，你都会成功的!"))
		user.death(TRUE)
		QDEL_IN(user, 3.5 SECONDS)

//The special work, if you survive you get a powerful EGO gift.
	if(climbing)
		if(user.sanity_lost || user.stat >= SOFT_CRIT || user.stat == DEAD)
			work_damage_lower = initial(work_damage_lower)
			climbing = FALSE
			return

		user.Stun(3 SECONDS)
		step_towards(user, src)
		sleep(0.5 SECONDS)
		if(QDELETED(user))
			ResetWorkDamage()
			climbing = FALSE
			return
		step_towards(user, src)
		sleep(0.5 SECONDS)
		if(QDELETED(user))
			ResetWorkDamage()
			climbing = FALSE
			return
		to_chat(user, span_userdanger("开始攀爬!"))
		animate(user, alpha = 1,pixel_x = 0, pixel_z = 16, time = 3 SECONDS)
		user.pixel_z = 16
		user.Stun(10 SECONDS)
		sleep(6 SECONDS)
		if(QDELETED(user))
			ResetWorkDamage()
			climbing = FALSE
			return
		var/datum/ego_gifts/giant/BWJEG = new
		BWJEG.datum_reference = datum_reference
		user.Apply_Gift(BWJEG)
		animate(user, alpha = 255,pixel_x = 0, pixel_z = -16, time = 3 SECONDS)
		user.pixel_z = 0
		to_chat(user, span_userdanger("你带着巨人的宝藏回来了!"))

	ResetWorkDamage()
	climbing = FALSE

/datum/ego_gifts/giant
	name = "Giant"
	icon_state = "giant"
	fortitude_bonus = 8
	slot = LEFTBACK
