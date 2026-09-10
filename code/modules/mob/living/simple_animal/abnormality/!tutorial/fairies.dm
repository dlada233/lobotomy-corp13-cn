/mob/living/simple_animal/hostile/abnormality/fairy_swarm
	name = "精灵群"
	desc = "一群叽叽喳喳的精灵."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "fairies"
	icon_living = "fairies"
	portrait = "fairies"
	maxHealth = 20
	health = 20
	is_flying_animal = TRUE
	threat_level = TETH_LEVEL
	fear_level = 0
	move_to_delay = 5
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 20,
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	melee_damage_lower = 1
	melee_damage_upper = 2
	melee_damage_type = PALE_DAMAGE
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = PALE_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.5)
	can_breach = TRUE
	start_qliphoth = 2
	can_spawn = FALSE // Normally doesn't appear

	// Tutorial abnormality - doesn't really need a final observation.
	work_start_lines = list("%ABNO 不过是一小群精灵, 还不能称其为 \"盛宴\".")
	middle_work_lines = list("初级员工无需了解 \"精灵的关怀\" 这一说法的真正含义.")

/mob/living/simple_animal/hostile/abnormality/fairy_swarm/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	GiveTarget(user)
	addtimer(CALLBACK(src, PROC_REF(die)), 60 SECONDS)

/mob/living/simple_animal/hostile/abnormality/fairy_swarm/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/fairy_swarm/proc/die()
	QDEL_NULL(src)

