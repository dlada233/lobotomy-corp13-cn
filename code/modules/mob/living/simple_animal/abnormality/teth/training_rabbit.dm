/mob/living/simple_animal/hostile/abnormality/training_rabbit
	name = "教学兔兔Dummy"
	desc = "像兔子一样的训练假人，应该完全无害."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "training_rabbit"
	icon_living = "training_rabbit"
	portrait = "training_rabbit"
	maxHealth = 100
	health = 100
	threat_level = TETH_LEVEL
	fear_level = 0 //rabbit not scary
	move_to_delay = 16
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 65,
		ABNORMALITY_WORK_INSIGHT = 65,
		ABNORMALITY_WORK_ATTACHMENT = 100,
		ABNORMALITY_WORK_REPRESSION = 40,
	)
	work_damage_upper = 2
	work_damage_lower = 1
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/blood
	max_boxes = 10
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	can_breach = TRUE
	start_qliphoth = 1
	can_spawn = FALSE // Normally doesn't appear
	//ego_list = list(datum/ego_datum/weapon/training, datum/ego_datum/armor/training)
	gift_type =  /datum/ego_gifts/standard
	can_patrol = FALSE
	can_affect_emergency = FALSE
	trigger_lights = FALSE
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	secret_chance = TRUE // people NEEDED a bunny girl waifu
	secret_icon_file = 'ModularTegustation/Teguicons/64x64.dmi'
	secret_icon_state = "Bungal"
	secret_horizontal_offset = -16
	secret_gift = /datum/ego_gifts/bunny

	observation_prompt = "这是脑叶公司用于训练新员工的训练假人。<br>\
		但它真的只是个假人吗？<br>\
		仔细观察后，你发现..."
	observation_choices = list(
		"一具尸体?" = list(TRUE, "面部轮廓、躯干、四肢，更不用说那股恶臭...<br>\
			毫无疑问，这根本就是个装在裹尸袋里倒置的尸体。<br>\
			尽管如此，它仍向你提供着礼物，并像活物般持续移动。<br>\
			原来这就是所谓的异想体。<br>\
			难道脑叶公司的异想体都这么诡异？"),
		"什么都没有" = list(FALSE, "肯定是工作压力让你产生了幻觉。<br>这种离谱的东西怎么可能存在!"),
	)

/mob/living/simple_animal/hostile/abnormality/training_rabbit/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	GiveTarget(user)
	if(!client)
		addtimer(CALLBACK(src, PROC_REF(kill_dummy)), 30 SECONDS)
	if(icon_state == "Bungal")
		icon = 'ModularTegustation/Teguicons/64x96.dmi'
		icon_state = "Bungal_breach"
		pixel_x = -16

/mob/living/simple_animal/hostile/abnormality/training_rabbit/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/training_rabbit/proc/kill_dummy()
	QDEL_NULL(src)
