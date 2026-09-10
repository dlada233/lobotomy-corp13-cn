/mob/living/simple_animal/hostile/abnormality/alriune
	name = "爱娜温"//（出自脑叶）
	desc = "高大的粉红色异想体，形似马匹。有六条尖腿，无臂的上半身覆盖亮蓝色叶片，眼窝空荡布满花朵，口中伸出粉色花朵。"
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "alriune"
	icon_living = "alriune"
	portrait = "alriune"

	pixel_x = -8
	base_pixel_x = -8

	maxHealth = 1000
	health = 1000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.2, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1.5)

	threat_level = WAW_LEVEL
	can_breach = TRUE
	start_qliphoth = 2
	// Work chances were slightly changed for it to be possible to get neutral result
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 45, 40, 35),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 50, 45, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 40, 35, 30),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 35, 30, 25),
	)
	work_damage_upper = 6
	work_damage_lower = 4
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/pride
	good_hater = TRUE

	light_color = COLOR_PINK
	light_range = 9
	light_power = 1

	observation_prompt = "你告诉我，落下的不是眼泪而是花瓣。<br>\
		\"我们都曾只是泥土，别在此谈论终结。\"<br>\
		你告诉我，身体绽放花朵仿佛那是遗言。<br>\"很快...\""
	observation_choices = list(
		"春天将会到来" = list(TRUE, "春天将至。<br>缓慢而狂喜地，我的终结开始了。"),
		"冬天将会到来" = list(TRUE, "冬天将至。<br>\
			在忙乱中，我的消亡渐渐走向终点。"),
	)

	work_start_lines = list("赤身裸体地来到这方天地的人儿啊，也将一丝不挂地归于天地之中.", "%ABNO记得它内里的黑灰.")
	early_work_lines = list("也许，我们是想创造一个没有心的人儿吧.", "那些花儿永不凋零，它们无可奈何地绽放着.")
	middle_work_lines = list("%PERSON想来一场春眠，如同花儿般的春眠.", "成簇的薰衣草将要铺满整个收容单元，将其晕染，%PERSON正为此而激动.")
	late_work_lines = list("复又盛放过，而复又凋零过的%ABNO理解了重生的意义. 无论行至何处，痕迹将存，而生命也将聚集至%ABNO.",
	"以花入眠的%PERSON身上涌出了沁人的芳香，而非鲜血.")
	work_end_lines = list("鲜花正在每个人的心头怒放.")

	/// Currently displayed petals. When value is at 3 - reset to 0 and perform attack
	var/petals_current = 0
	/// World time when petals_current will increase by 1
	var/petals_next = 0
	/// Delay used for petals_next
	var/petals_next_time = 5 SECONDS
	/// Amount of white damage done to everyone in view by the attack
	var/pulse_damage = 60

	ego_list = list(
		/datum/ego_datum/weapon/aroma,
		/datum/ego_datum/armor/aroma,
	)
	gift_type =  /datum/ego_gifts/aroma
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

/* Combat */

/mob/living/simple_animal/hostile/abnormality/alriune/Move()
	if(IsCombatMap())
		return ..()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/alriune/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!(status_flags & GODMODE))
		CheckAndPulse()

/mob/living/simple_animal/hostile/abnormality/alriune/CanAttack(atom/the_target)
	return FALSE

/// Check for petals_next and then perform actions
/mob/living/simple_animal/hostile/abnormality/alriune/proc/CheckAndPulse()
	if(world.time >= petals_next)
		petals_next = world.time + petals_next_time
		petals_current += 1
		if(petals_current >= 3) // Attack
			petals_current = 0
			playsound(src, 'sound/abnormalities/alriune/damage.ogg', 75, TRUE, 12)
			// Attack visual effect, so to speak
			for(var/turf/T in view(7, get_turf(src)))
				animate(T, color = COLOR_PINK, time = 2)
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(SetColorOverTime), T, initial(T.color), (2 SECONDS)), 4)
			for(var/mob/living/L in livinginview(7, get_turf(src)))
				if(faction_check_mob(L))
					continue
				if(L.stat == DEAD)
					continue
				L.deal_damage(pulse_damage, WHITE_DAMAGE, src, attack_type = (ATTACK_TYPE_SPECIAL))
				new /obj/effect/temp_visual/alriune_attack(get_turf(L))
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(H.sanity_lost)
						new /obj/effect/temp_visual/alriune_curtain(get_turf(H))
						addtimer(CALLBACK(H, TYPE_PROC_REF(/atom, add_overlay), \
							icon('ModularTegustation/Teguicons/tegu_effects.dmi', "alriune_kill")), 5)
						playsound(H, 'sound/abnormalities/alriune/kill.ogg', 75, TRUE)
						H.death()
			petals_next = world.time + (petals_next_time * 2)
			addtimer(CALLBACK(src, PROC_REF(TeleportAway)), 2 SECONDS)
		else
			playsound(src, 'sound/abnormalities/alriune/timer.ogg', 50, FALSE, 12)
		update_icon()


/mob/living/simple_animal/hostile/abnormality/alriune/proc/TeleportAway()
	if(IsCombatMap())
		return
	var/list/potential_turfs = list()
	for(var/turf/T in GLOB.xeno_spawn)
		if(get_dist(src, T) < 7)
			continue
		potential_turfs += T
	var/turf/T = pick(potential_turfs)
	if(!istype(T))
		return FALSE
	playsound(src, 'sound/abnormalities/alriune/curtain_out.ogg', 50, TRUE, 12)
	animate(src, alpha = 0, time = 15)
	SLEEP_CHECK_DEATH(15)
	forceMove(T)
	animate(src, alpha = 255, time = 15)
	playsound(src, 'sound/abnormalities/alriune/curtain_in.ogg', 50, TRUE, 12)

/* Overlays */
/mob/living/simple_animal/hostile/abnormality/alriune/update_overlays()
	. = ..()
	if(petals_current <= 0 || stat == DEAD || status_flags & GODMODE)
		cut_overlays()
		return

	var/mutable_appearance/petal_overlay = mutable_appearance(icon, "alriune_petal[petals_current]")
	. += petal_overlay

/* Work stuff */
/mob/living/simple_animal/hostile/abnormality/alriune/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(33))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/alriune/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/* Qliphoth/Breach effects */
/mob/living/simple_animal/hostile/abnormality/alriune/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	petals_next = world.time + petals_next_time + 30
	if(breach_type != BREACH_MINING)//in ER you get a few seconds to smack it down
		TeleportAway()
	icon_state = "alriune_active"
	return

