/mob/living/simple_animal/hostile/abnormality/barkley
	name = "查尔斯·巴克利闭嘴灌篮外传: 胡普兹·巴克利传奇第一章"// 这是来源于一个同人游戏名称，它原名更长：Tales of Game's Studios Presents Chef Boyardee's Barkley, Shut Up and Jam: Gaiden, Chapter 1 of the Hoopz Barkley SaGa
	desc = "身穿篮球球衣的高大男子."
	health = 4000
	maxHealth = 4000
	pixel_x = -12
	base_pixel_x = -12
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "barkley"
	icon_living = "barkley"
	portrait = "barkley"
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	is_flying_animal = TRUE
	del_on_death = FALSE
	can_breach = FALSE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 5
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 35,
		ABNORMALITY_WORK_INSIGHT = 35,
		ABNORMALITY_WORK_ATTACHMENT = 35,
		ABNORMALITY_WORK_REPRESSION = 35,
	)
	work_damage_upper = 9
	work_damage_lower = 6
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/chaosdunk,
		/datum/ego_datum/armor/chaosdunk,
	)
	abnormality_origin = ABNORMALITY_ORIGIN_JOKE

	// Lacks a final obs
	work_start_lines = list("%ABNO蕴含着篮球能量.")

	var/explosion_amt = 3

/mob/living/simple_animal/hostile/abnormality/barkley/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(30))
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/barkley/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/barkley/ZeroQliphoth(mob/living/carbon/human/user)
	. = ..()
	ChaosDunk(user)

/mob/living/simple_animal/hostile/abnormality/barkley/OnQliphothChange(mob/living/carbon/human/user)
	. = ..()
	if(datum_reference.qliphoth_meter == 1)
		icon_state = "barkley_angry"
	else
		icon_state = icon_living

/mob/living/simple_animal/hostile/abnormality/barkley/proc/ChaosDunk()
	show_global_blurb(10 SECONDS, "混沌灌篮警告", text_align = "center", screen_location = "Center-6,Center+3")
	priority_announce("混沌灌篮警告! 检测到19.7兆焦耳的负篮球质子涌现.\
	混沌灌篮即将发生. 请立刻寻找庇护所. 这不是演习.", "混沌灌篮警告", sound='sound/effects/combat_suppression_start.ogg')
	explosion(src, 20, 20)
	sleep(10 SECONDS)
	Explode()
	Cinematic(CINEMATIC_CHAOS_DUNK, world)

/mob/living/simple_animal/hostile/abnormality/barkley/proc/Explode()
	set waitfor = FALSE
	sleep(5 SECONDS)
	var/list/spawns = GLOB.xeno_spawn.Copy()
	var/list/depts = GLOB.department_centers.Copy()
	for(var/i = 1 to explosion_amt)
		if(prob(70))
			for(var/turf/T in depts)
				explosion(T, 20, 20)
				sleep(10)
			continue
		for(var/turf/T in spawns)
			explosion(T, 20, 20)//this is in EVERY xenospawn
	qdel(src)
