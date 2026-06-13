/mob/living/simple_animal/hostile/abnormality/forsaken_employee
	name = "被遗弃的员工"
	desc = "一个人似乎穿着L公司的制服，戴着锁链，头上戴着一个盒子，里面装着脑啡肽."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "forsaken_employee"
	portrait = "forsaken_employee"

	maxHealth = 250
	health = 250
	move_to_delay = 3

	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(30, 20, 0, -80, -80),
		ABNORMALITY_WORK_INSIGHT = list(50, 50, 40, 40, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(40, 40, 30, 30, 30),
		ABNORMALITY_WORK_REPRESSION = list(60, 60, 50, 50, 50),
	)
	work_damage_lower = 3
	work_damage_type = BLACK_DAMAGE

	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.3, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 1
	melee_damage_upper = 3
	melee_damage_type = BLACK_DAMAGE
	attack_sound = 'sound/abnormalities/ichthys/slap.ogg'

	ego_list = list(
		/datum/ego_datum/weapon/denial,
		/datum/ego_datum/armor/denial,
	)
	gift_type =  /datum/ego_gifts/denial
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS
	chem_type = /datum/reagent/abnormality/sin/gloom

	var/splash_cooldown
	var/splash_cooldown_time = 2 SECONDS

	//Observation is mostly mirror dungeon but with some changed phrasing
	observation_prompt = "塑料撞击声混杂着液体晃荡声。<br>\
		那东西似乎是曾经的员工。<br>\
		磨损的制服和员工证证实了其身份。<br>\
		证件已严重污损难以辨认。<br>\
		头顶脑啡肽盒的员工正猛撞收容单元的门。<br>\
		颈部的橡胶O型环是否用于防止脑啡肽泄漏？"
	observation_choices = list(
		"切断颈环" = list(TRUE, "刀刃不断从滑溜的O型环上弹开...<br>\
			\"呃呃呃...\"<br>\
			液体中的生物推开你逃走了。它更愿保持现状吗？<br>\
			仅留下一张小小的员工证。"),
		"不要切断颈环" = list(FALSE, "哐-哐-哐-撞门声与晃荡声持续不断。<br>\
			你持续观察倾听。仔细分辨发现声响带有节奏，或许其中自有乐趣。"),
	)

/mob/living/simple_animal/hostile/abnormality/forsaken_employee/FailureEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/forsaken_employee/BreachEffect(mob/living/carbon/human/user, breach_type)
	..()
	AddElement(/datum/element/waddling)
	AddComponent(/datum/component/knockback, 1, FALSE, TRUE)

/mob/living/simple_animal/hostile/abnormality/forsaken_employee/AttackingTarget(atom/attacked_target)
	splash()
	..()

/mob/living/simple_animal/hostile/abnormality/forsaken_employee/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	if(splash_cooldown <= world.time)
		playsound(src, 'sound/abnormalities/ichthys/hardslap.ogg', 60, 1)
		splash()


/mob/living/simple_animal/hostile/abnormality/forsaken_employee/proc/splash()
	new /obj/effect/gibspawner/generic/silent/wrath_acid/enkephalin(loc)
	splash_cooldown = world.time + splash_cooldown_time

/obj/effect/gibspawner/generic/silent/wrath_acid/enkephalin
	gibtypes = list(/obj/effect/decal/cleanable/wrath_acid/enkephalin)
	gibamounts = list(5)

/obj/effect/decal/cleanable/wrath_acid/enkephalin
	name = "脑啡肽"
	desc = "There are some harsh fumes coming off of it."
	icon_state = "acid_greyscale"
	random_icon_states = list("acid_greyscale")
	color = "#20f8ac"
	duration = 30 SECONDS

/obj/effect/decal/cleanable/wrath_acid/enkephalin/Crossed(atom/movable/AM)
	if(!ishuman(AM))
		return FALSE
	var/mob/living/carbon/human/H = AM
	H.apply_damage(1, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
	. = ..()
