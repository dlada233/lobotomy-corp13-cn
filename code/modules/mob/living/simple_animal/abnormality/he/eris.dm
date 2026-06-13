/mob/living/simple_animal/hostile/abnormality/eris
	name = "厄里斯"
	desc = "一个高大的，吓人的没有嘴巴的女人."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "eris"
	icon_living = "eris"
	core_icon = "eris_egg"
	portrait = "eris"
	maxHealth = 600
	health = 600
	ranged = TRUE
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	stat_attack = HARD_CRIT
	melee_damage_lower = 3
	melee_damage_upper = 5
	move_to_delay = 2.6
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1)
	speak_emote = list("croons")
	pixel_x = -8

	can_breach = TRUE
	threat_level = HE_LEVEL
	pet_bonus = TRUE
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(35, 40, 40, 35, 35),
		ABNORMALITY_WORK_INSIGHT = list(35, 40, 40, 35, 35),
		ABNORMALITY_WORK_ATTACHMENT = 70,
		ABNORMALITY_WORK_REPRESSION = list(50, 55, 55, 50, 45),
	)
	work_damage_upper = 6
	work_damage_lower = 3
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/lust

	can_spawn = FALSE // Does Nothing.
	ego_list = list(
		/datum/ego_datum/weapon/coiling,
		/datum/ego_datum/armor/coiling,
	)
	gift_type =  /datum/ego_gifts/coiling
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	observation_prompt = "我置身于宴会中。<br>\
		猩红天鹅绒桌布铺展，异想体厄里斯端坐对面。<br>\
		\"感觉如何？\"<br>伪装成人类的怪物问道。<br>\
		空气中弥漫甜腻腐臭。<br>\
		餐盘堆满生肉脏器，蝇虫不时叮咬。<br>眼前的怪物正优雅持着刀叉进餐。<br>\
		我的餐盘中央赫然陈列着人头。<br>那是不久前负责厄里斯工作的员工。<br>\
		\"没胃口？或许该参观我的闺房？\"<br>\
		恶心，作呕。<br>我只想逃离此地。"
	observation_choices = list(
		"逃跑" = list(TRUE, "我起身致歉，冲向房门。<br>\
			门竟未上锁。<br>逃离时听见少女嗓音的模仿：<br>\
			\"早点回来呀，亲爱的！\"<br>\"晚餐永远为你准备，终有一天你会成为主菜！\""),
		"接受提议" = list(FALSE, "能有多糟？<br>我跟随厄里斯进入房间。<br>\
			数小时后，厄里斯与新的陌生人共进晚餐。<br>我的头颅正置于同样的餐盘中。"),
	)

	var/girlboss_level = 0

/mob/living/simple_animal/hostile/abnormality/eris/Login()
	. = ..()
	to_chat(src, "<h1>你扮演厄里斯，坦克型异想体</h1><br>\
		<b>|人形伪装|：仅能攻击濒死或已死亡的人类。<br>\
		吞噬符合条件的猎物可获得'致命魅力'层数。<br>\
		<br>\
		|共进晚餐|：每秒治疗视野内所有目标。<br>\
		治疗效果随'致命魅力'层数提升。<br>\
		<br>\
		|优雅形态|：受人类攻击时，对其造成WHITE伤害。<br>\
		伤害值随'致命魅力'层数增加。</b>")

//Okay, but here's the breach on death
/mob/living/simple_animal/hostile/abnormality/eris/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_mob_death)) // Hell

/mob/living/simple_animal/hostile/abnormality/eris/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/mob/living/simple_animal/hostile/abnormality/eris/proc/on_mob_death(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!IsContained()) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(died.z != z)
		return FALSE
	if(!died.mind)
		return FALSE
	datum_reference.qliphoth_change(-1) // One death reduces it
	return TRUE



//Okay, but here's the life stuff
/mob/living/simple_animal/hostile/abnormality/eris/Life()
	..()
	if(IsContained())
		return
	healpulse()

//Okay, but here's the patrolling stuff
/mob/living/simple_animal/hostile/abnormality/eris/patrol_select()
	var/list/target_turfs = list() // Stolen from Punishing Bird
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.z != z) // Not on our level
			continue
		if(H.stat >= SOFT_CRIT) // prefer the near dead.
			continue
		target_turfs += get_turf(H)

	var/turf/target_turf = get_closest_atom(/turf/open, target_turfs, src)
	if(istype(target_turf))
		patrol_path = get_path_to(src, target_turf, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)
		return
	return ..()


//Okay, but here's the attacking stuff
/mob/living/simple_animal/hostile/abnormality/eris/CanAttack(atom/the_target)
	if(!ishuman(the_target))
		return FALSE
	var/mob/living/H = the_target
	if(H.stat >= SOFT_CRIT)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/eris/AttackingTarget(atom/attacked_target)
	if(ishuman(attacked_target))
		var/mob/living/H = attacked_target
		if(H.stat >= SOFT_CRIT)
			Dine(attacked_target)
			return
	..()

//Okay, but here's the cannibalism
/mob/living/simple_animal/hostile/abnormality/eris/proc/Dine(mob/living/carbon/human/poorfuck)
	manual_emote("打开她的下巴，露出许多排牙齿!")
	playsound(get_turf(src), 'sound/abnormalities/bigbird/bite.ogg', 50, 1, 2)
	poorfuck.dust(TRUE, TRUE)
	new /obj/effect/gibspawner/generic/silent(get_turf(poorfuck))

	//Lose sanity
	for(var/mob/living/carbon/human/H in view(10, get_turf(src)))
		H.deal_damage(girlboss_level*10, WHITE_DAMAGE)

	SLEEP_CHECK_DEATH(10)
	manual_emote("用手帕擦嘴")
	SLEEP_CHECK_DEATH(15)
	say("谢谢你请我吃饭，亲爱的.")
	girlboss_level += 1

//Okay, but here's the Sex work
/mob/living/simple_animal/hostile/abnormality/eris/funpet(mob/living/carbon/human/current_petter)
	..()
	if(!(status_flags & GODMODE))
		return

	emote("giggles")
	current_petter.Stun(30 SECONDS)
	SLEEP_CHECK_DEATH(20)
	say("我很高兴你来吃晚饭，亲爱的.")
	SLEEP_CHECK_DEATH(20)
	say("哦，你看起来如此...美味的.")
	SLEEP_CHECK_DEATH(20)
	emote("giggles")
	SLEEP_CHECK_DEATH(20)
	say("这是你的报酬，你永远属于我.")
	SLEEP_CHECK_DEATH(20)
	manual_emote("打开她的下巴，露出许多排牙齿!")

	playsound(get_turf(src), 'sound/abnormalities/bigbird/bite.ogg', 50, 1, 2)
	new /obj/effect/gibspawner/generic/silent(get_turf(current_petter))
	current_petter.dust(TRUE, TRUE)

	SLEEP_CHECK_DEATH(20)
	manual_emote("用手帕擦嘴")
	SLEEP_CHECK_DEATH(20)
	say("谢谢你请我吃饭，亲爱的.")
	girlboss_level += 5
	datum_reference.qliphoth_change(-3)

//Okay, but here's the math
/mob/living/simple_animal/hostile/abnormality/eris/proc/healpulse()
	for(var/mob/living/H in view(10, get_turf(src)))
		if(H.stat >= SOFT_CRIT)
			continue
		//Shamelessly fucking stolen from risk of rain's teddy bear.
		var/healamount = 2 * (TOUGHER_TIMES(girlboss_level))
		H.adjustBruteLoss(-healamount)	//Healing for those around.
		new /obj/effect/temp_visual/heal(get_turf(H), "#FF4444")

//Okay but here's the defensive options
/mob/living/simple_animal/hostile/abnormality/eris/bullet_act(obj/projectile/Proj)
	..()
	if(!ishuman(Proj.firer))
		return
	var/mob/living/carbon/human/H = Proj.firer
	H.deal_damage(3*(TOUGHER_TIMES(girlboss_level)), WHITE_DAMAGE)


/mob/living/simple_animal/hostile/abnormality/eris/attacked_by(obj/item/I, mob/living/user)
	..()
	if(!user)
		return
	user.deal_damage(3*(TOUGHER_TIMES(girlboss_level)), WHITE_DAMAGE)


//Okay, but here's the work effects

/mob/living/simple_animal/hostile/abnormality/eris/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_ATTACHMENT)
		if(prob(20))
			Dine(user)

/mob/living/simple_animal/hostile/abnormality/eris/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-3)
	return

/mob/living/simple_animal/hostile/abnormality/eris/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	update_icon()
	GiveTarget(user)


