/mob/living/simple_animal/hostile/abnormality/warden
	name = "典狱长"
	desc = "一个异想体，以一根肉棍的形式穿戴裙子和悬挂眼睛，你不会想知道裙子下面是什么的."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "warden"
	icon_living = "warden"
	icon_dead = "warden_dead"
	portrait = "warden"
	maxHealth = 1000
	health = 1000
	pixel_x = -8
	base_pixel_x = -8
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 1.5)

	move_to_delay = 4
	melee_damage_lower = 15
	melee_damage_upper = 16
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/weapons/slashmiss.ogg'
	attack_verb_continuous = "claws"
	attack_verb_simple = "claws"
	del_on_death = FALSE
	can_breach = TRUE
	threat_level = WAW_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 15,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	work_damage_upper = 7
	work_damage_lower = 4
	work_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gluttony

	ego_list = list(
		/datum/ego_datum/weapon/correctional,
		/datum/ego_datum/armor/correctional,
	)
	gift_type =  /datum/ego_gifts/correctional
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	observation_prompt = "她游荡在设施走廊中，例行巡查并清除最后的幸存者。<br>\
		据我所知，整个设施只剩下我一个人。<br>\
		设施的埋葬程序已启动，逃生无望，但其他异想体仍困于各自的收容单元中，若其出逃，她会将其驱回。<br>\
		也许我也应该进入废弃单元，这样她或许就会放过我？"
	observation_choices = list(
		"进入单元" = list(TRUE, "我踏入单元反锁门扉，<br>就此困于其中。<br>\
			她经过收容单元，透过玻璃窥视后似乎感到满意。"),
		"向她投降" = list(FALSE, "我趁她巡查时与她面对面，<br>坦言疲惫只求终结.<br>\
			她向我趋近然后掀起裙摆(？)，我随机就被卷入其下，同事们竟然也在这里，而且还安然无恙地活着！<br>\
			但众人见了我之后神色却显露颓丧. <br>其中一个人漠然道：“这里面，你将与我们永世同在.”"),
	)

	var/finishing = FALSE

	var/captured_souls = 0

	var/resistance_decrease = 0.2

	var/base_red_resistance = 0.7
	var/base_white_resistance = 1.2
	var/base_black_resistance = 0.4
	var/base_pale_resistance = 1.5

	var/new_red_resistance = 0.7
	var/new_white_resistance = 1.2
	var/new_black_resistance = 0.4
	var/new_pale_resistance = 1.5

	var/damage_down = 2

/mob/living/simple_animal/hostile/abnormality/warden/Login()
	. = ..()
	to_chat(src, "<h1>你扮演典狱长——坦克型异想体。</h1><br>\
		<b>|灵魂守卫|：免疫所有远程攻击。<br>\
		<br>\
		|灵魂典狱长|：攻击尸体会将其化为尘埃，同时治疗自身并获得一层「捕获灵魂」<br>\
		每层「捕获灵魂」提升移速，降低10点近战伤害，并承受50%额外伤害。</b>")

/mob/living/simple_animal/hostile/abnormality/warden/AttackingTarget(atom/attacked_target)
	. = ..()
	if(.)
		if(finishing)
			return FALSE
		if(!istype(attacked_target, /mob/living/carbon/human))
			return
		var/mob/living/carbon/human/H = attacked_target

		if(H.health < 0)

			finishing = TRUE
			icon_state = "warden_attack"
			playsound(get_turf(src), 'sound/hallucinations/wail.ogg', 50, 1)
			SLEEP_CHECK_DEATH(5)

			//Takes your skin and leaves your bone. You are now a flesh servant under her skirt in GBJ
			H.dust(TRUE, TRUE)

			// it gets faster.

			if(IsCombatMap())
				captured_souls++
				new_red_resistance = (base_red_resistance + resistance_decrease * captured_souls)
				new_white_resistance = (base_white_resistance + resistance_decrease * captured_souls)
				new_black_resistance = (base_black_resistance + resistance_decrease * captured_souls)
				new_pale_resistance = (base_pale_resistance + resistance_decrease * captured_souls)
				ChangeResistances(list(RED_DAMAGE = new_red_resistance, WHITE_DAMAGE = new_white_resistance, BLACK_DAMAGE = new_black_resistance, PALE_DAMAGE = new_pale_resistance))
				to_chat(src, span_warning("当你俘获了一个灵魂，你会觉得自己变得更加...易碎."))

			if(move_to_delay>1)
				ChangeMoveToDelayBy(0.75, TRUE)
				if(melee_damage_lower > 4)
					melee_damage_lower -= damage_down
				if(IsCombatMap())
					if(melee_damage_upper > 4)
						melee_damage_upper -= damage_down
			adjustBruteLoss(-(maxHealth*0.2)) // Heals 20% HP.

			finishing = FALSE
			icon_state = "warden"

/mob/living/simple_animal/hostile/abnormality/warden/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/warden/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 80 && get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 80)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/warden/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/warden/CanAttack(atom/the_target)
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/warden/Move()
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/warden/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/warden/bullet_act(obj/projectile/P)
	visible_message(span_userdanger("[src]不受[P]的影响!"))
	HealingEffect("no_dam")
	P.Destroy()
