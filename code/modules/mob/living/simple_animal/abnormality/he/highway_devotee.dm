/mob/living/simple_animal/hostile/abnormality/highway_devotee
	name = "公路里程表"
	desc = "一个巨大的牌子上写着“道路封闭”."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "highway_devotee"
	icon_living = "highway_devotee"
	portrait = "highway_devotee"
	maxHealth = 300
	health = 300
	ranged = TRUE
	attack_verb_continuous = "scorns"
	attack_verb_simple = "scorn"
	damage_coeff = list(BRUTE = 0, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	speak_emote = list("rasps")
	pixel_x = -16

	can_breach = TRUE
	threat_level = HE_LEVEL
	faction = list("neutral", "hostile")
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(55, 55, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = list(55, 55, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(30, 20, 10, 0, 0),
		ABNORMALITY_WORK_REPRESSION = list(30, 20, 10, 0, 0),
	)
	work_damage_upper = 5
	work_damage_lower = 2
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/sloth

	ego_list = list(
		/datum/ego_datum/weapon/uturn,
		/datum/ego_datum/armor/uturn,
	)
	gift_type =  /datum/ego_gifts/uturn
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	observation_prompt = "前方是条漫长宽阔的道路。<br>\
		入口处有人举着告示牌：<br>\
		\"此路单向通行，禁止掉头。\"<br>\
		\"若选择此路，返程将耗时漫长。\"<br>\
		正如其所言，道路似乎无限延伸至远方。"
	observation_choices = list(
		"放弃主路原路返回" = list(TRUE, "\"此刻道路看似空旷，但稍行片刻便会发现：<br>整条路堵满了车，行进速度将慢如爬行。\"<br>\
			\"掉头也不可行——当你决定返回时，后方早已堵满车辆。\"<br>\
			\"你做了正确选择。\"<br>\
			它露出浅笑。<br>\
			\"告示牌仍高举着，等待未来的公路使用者。"),
		"放弃主路改走小道" = list(FALSE, "\"不明智的选择。\"<br>\
			\"所有人遵循相同规则通行，这公路属于每位使用者。\"<br>\
			\"交通之神不会宽恕这种投机取巧的行为。\"<br>\
			你走上小道，背后刺人的目光伴随了你许久。"),
	)

	var/talk = FALSE
	var/list/structures = list()

/mob/living/simple_animal/hostile/abnormality/highway_devotee/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/highway_devotee/Life()
	..()
	//Only say this once
	if(talk)
		return
	for(var/mob/living/carbon/human/H in view(5, src))
		say("如果你走这条路，要花很长时间才能回到这里.")
		talk = TRUE
		break

/mob/living/simple_animal/hostile/abnormality/highway_devotee/death(gibbed)
	for(var/obj/Y in structures)
		qdel(Y)
	..()

/mob/living/simple_animal/hostile/abnormality/highway_devotee/proc/KillYourself()
	for(var/obj/Y in structures)
		qdel(Y)
	QDEL_NULL(src)

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/highway_devotee/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/highway_devotee/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-2)
	return

/mob/living/simple_animal/hostile/abnormality/highway_devotee/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	if(breach_type != BREACH_MINING)
		var/turf/T = pick(GLOB.xeno_spawn)
		forceMove(T)
	addtimer(CALLBACK(src, PROC_REF(KillYourself)), 3 MINUTES)
	dir = pick(list(NORTH, SOUTH, WEST, EAST))
	for(var/turf/open/U in range(2, src))
		var/obj/structure/blockedpath/P = new(U)
		structures += P

/obj/structure/blockedpath
	name = "公路里程表"
	icon_state = "blank"
	max_integrity = 3000000
	density = 1

