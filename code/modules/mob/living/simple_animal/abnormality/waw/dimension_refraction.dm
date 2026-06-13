/mob/living/simple_animal/hostile/abnormality/dimensional_refraction
	name = "次元衍射变体"
	desc = "几乎看不见的薄雾"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "dmr_abnormality"
	icon_living = "dmr_abnormality"
	portrait = "dimension_refraction"
	del_on_death = TRUE
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -16
	base_pixel_y = -16

	maxHealth = 600
	health = 600
	blood_volume = 0
	density = FALSE
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)
	stat_attack = HARD_CRIT
	can_breach = TRUE
	threat_level = WAW_LEVEL
	fear_level = 0
	start_qliphoth = 2
	move_to_delay = 6
	trigger_lights = FALSE

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 40, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(35, 40, 45, 50, 55),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 40, 40, 40),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 40, 40, 40),
	)
	work_damage_upper = 7
	work_damage_lower = 4
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/sloth

	ego_list = list(
		/datum/ego_datum/weapon/diffraction,
		/datum/ego_datum/armor/diffraction,
	)
	gift_type =  /datum/ego_gifts/diffraction
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "它几乎无法通过任何手段被观测到，唯一能证明其存在的只有眼前水杯的变化。<br>\
		我冷静观察收容单元环境，当注意到杯内液体开始冒泡时便进行调整。"
	observation_choices = list(
		"留下观察" = list(TRUE, "我持续记录观测结果，此时杯中的水升到空中，水杯也随之浮起。<br>\
			水体以最精妙的方式包裹水杯形成球体，随后猛烈爆散，杯子粉碎成微尘。<br>\
			我离开收容单元，对观测结果感到满意。"),
		"离开收容单元" = list(FALSE, "手册要求若水杯出现剧烈变化需立即撤离。<br>离开时，水面恢复了平静。"),
	)

	var/cooldown_time = 2
	var/aoe_damage = 10

/mob/living/simple_animal/hostile/abnormality/dimensional_refraction/proc/Melter()
	for(var/mob/living/L in livinginview(1, src))
		if(faction_check_mob(L))
			continue
		L.deal_damage(aoe_damage, RED_DAMAGE)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))
	addtimer(CALLBACK(src, PROC_REF(Melter)), cooldown_time)


/mob/living/simple_animal/hostile/abnormality/dimensional_refraction/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/dimensional_refraction/PickTarget(list/Targets)
	return

//Cannot be automatically followed by manager camera follow command.
/mob/living/simple_animal/hostile/abnormality/dimensional_refraction/can_track(mob/living/user)
	return FALSE

/* Qliphoth/Breach effects */
/mob/living/simple_animal/hostile/abnormality/dimensional_refraction/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	alpha = 30
	addtimer(CALLBACK(src, PROC_REF(Melter)), cooldown_time)


/mob/living/simple_animal/hostile/abnormality/dimensional_refraction/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return
