/mob/living/simple_animal/hostile/abnormality/apex_predator
	name = "顶级掠食者"
	desc = "类似于被打烂的假人的畸形物."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "apex"
	icon_living = "apex"
	core_icon = "apex_egg"
	portrait = "apex"
	pixel_x = -16
	base_pixel_x = -16


	maxHealth = 800
	health = 800
	density = FALSE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.2, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	ranged = TRUE
	melee_damage_lower = 12
	melee_damage_upper = 15
	move_to_delay = 3

	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT

	fear_level = 0	//You should never notice it

	attack_sound = 'sound/abnormalities/fragment/attack.ogg'
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	faction = list("hostile")
	can_breach = TRUE
	threat_level = WAW_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 35, 40, 45),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 35, 40, 45),
		ABNORMALITY_WORK_ATTACHMENT = list(25, 20, 15, 10, 0),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 50, 55, 55),
	)
	work_damage_upper = 6
	work_damage_lower = 4
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/apex_predator
	harvest_phrase = span_notice("浑浊液体从%ABNO渗出，散发烧焦塑料的恶臭。你用%VESSEL收集了它。")
	harvest_phrase_third = "%PERSON用%VESSEL盛满从%ABNO渗出的浑浊恶臭液体。"

	ego_list = list(
		/datum/ego_datum/weapon/animalism,
		/datum/ego_datum/armor/animalism,
	)
	gift_type =  /datum/ego_gifts/animalism

	observation_prompt = "碰撞测试假人站在房间角落。<br>它以抽搐摇晃的动作摆动手臂。<br>\
		你不确定它是否能理解你。<br>虽有人形却无面部特征，<br>没有可注视的眼睛，<br>\
		仅是粗略的人形轮廓。<br>\
		有什么话能对它说吗？"
	observation_choices = list(
		"为什么？" = list(TRUE, "异想体突然停止动作。<br>它也不知如何回应，<br>\
			低头凝视地板仿佛在思考问题。<br>\
			最终只是耸耸肩。<br>或许本就没有答案。"),
		"揍它" = list(FALSE, "无需多言。<br>碰撞测试假人的存在意义就是承受暴力，<br>\
			为暴力而生的暴力。<br>\
			你冷笑着抽出警棍。"),
	)

	var/revealed = TRUE
	var/can_act = TRUE
	var/backstab_damage = 60
	var/agent_status //Used for insanity

	var/jumping	//Used so it can only start one jump at once
	var/busy	//Can we move now?

	var/jump_cooldown
	var/jump_cooldown_time = 5 SECONDS
	var/jump_damage = 15

	var/recloak_time = 0
	var/recloak_time_cooldown = 30 SECONDS


/mob/living/simple_animal/hostile/abnormality/apex_predator/Move()
	if(notransform)
		return ..()
	if(busy)
		return FALSE
	..()

/mob/living/simple_animal/hostile/abnormality/apex_predator/Life()
	. = ..()
	if(. && !(status_flags & GODMODE) && revealed && recloak_time < world.time)
		Cloak()

/mob/living/simple_animal/hostile/abnormality/apex_predator/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/apex_predator/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/apex_predator/AttemptWork(mob/living/carbon/human/user, work_type)
	if(user.health != user.maxHealth)
		work_damage_upper = 8
		work_damage_lower = 6
	return TRUE

/mob/living/simple_animal/hostile/abnormality/apex_predator/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.health < 0)
		datum_reference.qliphoth_change(-1)

	work_damage_upper = initial(work_damage_upper)
	work_damage_lower = initial(work_damage_lower)
	return

/mob/living/simple_animal/hostile/abnormality/apex_predator/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	Cloak()
	GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/apex_predator/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return
	if(!revealed)
		//Will want this to be crazy
		say("在你身后.")

		SLEEP_CHECK_DEATH(7)
		Decloak()
		SLEEP_CHECK_DEATH(3)
		//Backstab
		if(attacked_target in range(1, src))
			if(isliving(attacked_target))
				var/mob/living/V = attacked_target
				visible_message(span_danger("[src]撕开了[attacked_target]的内脏!"))
				new /obj/effect/gibspawner/generic(get_turf(V))
				V.deal_damage(backstab_damage, RED_DAMAGE)
			//Backstab succeeds from any one of 3 tiles behind a mecha, backstab from directly behind gets boosted by mecha directional armor weakness
			else if(ismecha(attacked_target))
				var/relative_angle = abs(dir2angle(attacked_target.dir) - dir2angle(get_dir(attacked_target, src)))
				relative_angle = relative_angle > 180 ? 360 - relative_angle : relative_angle
				if(relative_angle >= 135)
					visible_message(span_danger("[src]撕碎[attacked_target]的护甲!"))
					var/obj/vehicle/sealed/mecha/M = attacked_target
					M.take_damage(backstab_damage, RED_DAMAGE, attack_dir = get_dir(M, src))
					new /obj/effect/temp_visual/kinetic_blast(get_turf(M))
				else
					visible_message(span_danger("[src]的攻击错过了[attacked_target]的弱点!"))
					..()
			else
				..()
			SLEEP_CHECK_DEATH(20)
			Cloak()
			//Remove target
			FindTarget()
		else
			if(!jumping)
				if(!target)
					GiveTarget(attacked_target)
				Jump()
		return
	..()


//Getting hit decloaks
/mob/living/simple_animal/hostile/abnormality/apex_predator/attackby(obj/item/I, mob/living/user, params)
	..()
	Decloak()

/mob/living/simple_animal/hostile/abnormality/apex_predator/bullet_act(obj/projectile/P)
	..()
	Decloak()

/mob/living/simple_animal/hostile/abnormality/apex_predator/proc/Cloak()
	alpha = 10
	revealed = FALSE
	density = FALSE
	QuickChangeLights(FALSE)

/mob/living/simple_animal/hostile/abnormality/apex_predator/proc/Decloak()
	recloak_time = world.time + recloak_time_cooldown
	alpha = 255
	revealed = TRUE
	density = TRUE
	QuickChangeLights(TRUE)

/mob/living/simple_animal/hostile/abnormality/apex_predator/OpenFire()
	if(!revealed)
		return

	//For readability
	if(!jumping && (jump_cooldown < world.time) && !(status_flags & GODMODE))
		Jump()

/mob/living/simple_animal/hostile/abnormality/apex_predator/proc/Jump()
	jumping = TRUE
	busy = TRUE
	icon_state = "apex_crouch"
	addtimer(CALLBACK(src, PROC_REF(Leap)), 5)

/mob/living/simple_animal/hostile/abnormality/apex_predator/proc/Leap()
	density = FALSE
	var/turf/target_turf = get_turf(target)
	playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
	notransform = TRUE
	throw_at(target_turf, 7, 1, src, FALSE, callback = CALLBACK(src, PROC_REF(Slam)))
	icon_state = "apex_leap"

	addtimer(CALLBACK(src, PROC_REF(Slam)), 10)

/mob/living/simple_animal/hostile/abnormality/apex_predator/proc/Slam()
	notransform = FALSE
	icon_state = "apex_crouch"
	playsound(src, 'sound/effects/meteorimpact.ogg', 300, FALSE, 9)
	for(var/turf/T in range(1, src))
		HurtInTurf(T, list(), jump_damage, RED_DAMAGE, null, TRUE, FALSE, TRUE)
		new /obj/effect/temp_visual/kinetic_blast(T)
	addtimer(CALLBACK(src, PROC_REF(Reset)), 12)

/mob/living/simple_animal/hostile/abnormality/apex_predator/proc/Reset()
	density = TRUE
	busy = FALSE
	jumping = FALSE
	icon_state = "apex"
	jump_cooldown = world.time + jump_cooldown_time

/datum/reagent/abnormality/apex_predator
	name = "橡皮泥麻醉"
	description = "一种有塑料臭味的混浊液体，它在缝合身体创伤的同时削弱了心智."
	color = "#e4ebf5"
	health_restore = 4
	stat_changes = list(0, -15, 0, 0)
	damage_mods = list(1, 1.5, 1, 1) //heals a lot but it severely weakens your purdence and white resistance

