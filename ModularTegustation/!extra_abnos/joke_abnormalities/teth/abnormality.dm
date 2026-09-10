/mob/living/simple_animal/hostile/abnormality/an_abnormality
	name = "\"An Abnormality\""
	desc = "An entity lacking in description due to developer laziness."
	icon = 'icons/mob/actions/actions_abnormality.dmi'
	icon_state = "abnormality"
	icon_living = "abnormality"
	portrait = "bill"
	maxHealth = 700
	health = 700
	threat_level = TETH_LEVEL
	attack_sound = 'sound/weapons/bite.ogg'
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 60,
		ABNORMALITY_WORK_REPRESSION = 60,
	)
	work_damage_upper = 4
	work_damage_lower = 3
	work_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	melee_damage_lower = 8
	melee_damage_upper = 12
	can_breach = TRUE
	start_qliphoth = 1

	ego_list = list(
		/datum/ego_datum/weapon/an_ego,
		/datum/ego_datum/armor/an_ego,
	)
	gift_type =  /datum/ego_gifts/standard // Way too lazy to make its own gift
	abnormality_origin = ABNORMALITY_ORIGIN_JOKE

	observation_prompt = "//TODO - Add Observation Prompt"

	observation_choices = list(
		"What?" = list(TRUE, "A gift materializes on you a few moments later.<br>\
		Happy April fools!"),
	)

	work_start_lines = list("如果这不能被称为\"异想\"，那它又会是什么呢?")
	early_work_lines = list("%ABNO 看起来和手册里的小插画一摸一样.", "%ABNO 不像 %PERSON 所知道的任何一种生物.")
	middle_work_lines = list("%PERSON 犹豫地戳了下 %ABNO, 但没有得到回应.")
	late_work_lines = list("%ABNO 一瞬间消失无踪, 令 %PERSON 感到惊讶.", "%PERSON 听到远处传来模糊的笑声.")
	work_end_lines = list("%ABNO 真的是异常存在吗?")

/mob/living/simple_animal/hostile/abnormality/an_abnormality/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(prob(25))
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/an_abnormality/PostSpawn()
	. = ..()
	dir = SOUTH
