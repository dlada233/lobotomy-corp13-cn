/mob/living/simple_animal/hostile/abnormality/fairy_longlegs
	name = "长腿精灵"
	desc = "它个子高大，像精灵一样，手臂像桨，不停地拿着三叶草，好像那是一把伞，树叶似乎潮湿了."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "fairy_longlegs"
	icon_living = "fairy_longlegs"
	icon_dead = "fairy_longlegs_dead"
	core_icon = "fairy_longlegs_dead"
	portrait = "fairy_long_legs"
	del_on_death = FALSE
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 260
	health = 260
	rapid_melee = 0.5
	move_to_delay = 4
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 3
	melee_damage_upper = 5
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/fairy_longlegs/attack.ogg'
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(90, 60, 55, 50, 45),
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = 30,
		ABNORMALITY_WORK_REPRESSION = 0,
		"避雨" = 0,
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gluttony
	death_message = "结合成一个原始的蛋."
	death_sound = 'sound/abnormalities/fairy_longlegs/death.ogg'
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/fairy_gentleman = 1.5,
		/mob/living/simple_animal/hostile/abnormality/fairy_festival = 1.5,
		/mob/living/simple_animal/hostile/abnormality/faelantern = 1.5,
	)

	ego_list = list(
		/datum/ego_datum/weapon/sticking,
		/datum/ego_datum/armor/sticking,
	)
	gift_type =  /datum/ego_gifts/fourleaf_clover

	observation_prompt = "来吧，何不和我一起待在伞下? <br>\
		就当是为了往日情谊?"
	observation_choices = list(
		"No" = list(TRUE, "你以为现在该长记性了。<br>\
			你离开收容单元，勉强躲过了即将到来的攻击。<br>\
			这家伙永远是个骗子。"),
		"Yes" = list(FALSE, "哎哟！<br>\
			你刚进入长腿精灵的攻击范围就遭到袭击。<br>\
			\"嘿，你真以为能成为我们一员吗？\"<br>\
			\"你可不是家族成员，废物。\"<br>\
			你走开包扎流血的伤口。"),
	)

	var/finishing = FALSE //cant move/attack when it's TRUE
	var/work_count = 0
	var/raining = FALSE
	var/ignored = 0 //stores the agent's choice: 0 - disabled/1- refused cover


/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/death(gibbed)
	icon = 'ModularTegustation/Teguicons/abno_cores/teth.dmi'
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/CanAttack(atom/the_target)
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/Move()
	if(finishing)
		return FALSE
	return ..()

/*** Work Proc ***/
/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/WorkComplete(user, work_type, pe, work_time, canceled)
	. = ..()
	work_count++
	if(work_count < 3)
		return
	if(!raining && (IsContained(src)))
		for(var/turf/open/O in view(3, src))
			new /obj/effect/rainy_effect(O)
	say("哦天哪，建议你别被这雨淋到.") //tries to trick people into getting cover
	sleep(1 SECONDS)
	say("想和我一起待在伞下吗?")
	raining = TRUE
	to_chat(user, span_notice("你感到雨水渗入衣服，或许该找个避雨处...."))
	return

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/AttemptWork(mob/living/carbon/human/user, work_type)
	if((work_type != "避雨")&& !raining)
		return TRUE
	if((work_type == "避雨") && !raining) //dumbass
		to_chat(user, span_notice("没有理由这样做，天空晴朗."))
		return FALSE
	if((work_type == "避雨") && raining) //Uh oh, you goofed up
		to_chat(user, span_danger("你决定在精灵的三叶草下避雨."))
		work_count = 0
		raining = FALSE
		Execute(user)
		return FALSE
	if((work_type != "避雨") && raining)
		for(var/obj/effect/rainy_effect/rain in range(3, src))
			rain.End(TRUE) //The rain actually heals you, lying bastard...
		work_count = 0
		ignored = TRUE
		raining = FALSE
		return TRUE


/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 40)
		datum_reference.qliphoth_change(-2)
	if (ignored) //refused his offer to take cover
		say("切，这该死的雨总是让我吃不上饭.")
		ignored = FALSE
		datum_reference.qliphoth_change(-2)

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/proc/Execute(mob/living/carbon/human/user)
	raining = FALSE
	user.Stun(3 SECONDS)
	step_towards(user, src)
	sleep(0.5 SECONDS)
	if(QDELETED(user))
		return
	step_towards(user, src)
	sleep(1.5 SECONDS)
	if(QDELETED(user))
		return
	user.visible_message(span_warning("你感到胸口一阵刺痛，那是...血吗?"))
	icon_state = "fairy_longlegs_healing"
	playsound(get_turf(src), 'sound/abnormalities/fairy_longlegs/heal.ogg', 50, 1)
	user.deal_damage(30, RED_DAMAGE)
	for(var/obj/effect/rainy_effect/rain in range(3, src))
		rain.End(FALSE)
	sleep(1.5 SECONDS)
	icon_state = "fairy_longlegs"

//Breach Stuff
/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/AttackingTarget(atom/attacked_target)
	if(finishing)
		return FALSE
	if(!istype(attacked_target, /mob/living/carbon/human))
		return ..()
	finishing = TRUE
	icon_state = "fairy_longlegs_healing"
	playsound(get_turf(src), 'sound/abnormalities/fairy_longlegs/heal.ogg', 50, 1)
	adjustBruteLoss(-(maxHealth*0.04))
	..()
	SLEEP_CHECK_DEATH(15)
	icon_state = "fairy_longlegs"
	finishing = FALSE

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	if(raining)
		for(var/obj/effect/rainy_effect/rain in range(3, src))
			rain.End(TRUE)

//Misc. Objects
/obj/effect/rainy_effect
	name = "雨"
	desc = "倾斜而下."
	icon = 'icons/effects/weather_effects.dmi'
	icon_state = "acid_rain"
	layer = POINT_LAYER //want this high but not above warnings
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE

/obj/effect/rainy_effect/proc/End(healing)
	if(healing)
		for(var/mob/living/carbon/human/H in get_turf(src))
			to_chat(H, span_nicegreen("这奇怪的雨让人恢复活力."))
			H.adjustBruteLoss(-20)
	QDEL_IN(src, 50)
