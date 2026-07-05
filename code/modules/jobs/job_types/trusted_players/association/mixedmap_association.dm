//Director
/datum/job/mixed_director
	title = "Association Section Director-协会科室主管"
	outfit = /datum/outfit/job/mixed_director
	department_head = list("your association")
	faction = "Station"
	supervisors = "your association"
	selection_color = "#e09660"
	total_positions = 1
	spawn_positions = 1
	display_order = JOB_DISPLAY_ORDER_DIRECTOR
	trusted_only = TRUE
	access = list(ACCESS_PHARMACY, ACCESS_NETWORK, ACCESS_RC_ANNOUNCE) // I want to use the number 69.
	minimal_access = list(ACCESS_PHARMACY, ACCESS_NETWORK, ACCESS_RC_ANNOUNCE)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_ASSOCIATION
	paycheck = 700
	maptype = list("lcorp_city")
	mind_traits = list(TRAIT_WORK_FORBIDDEN, TRAIT_COMBATFEAR_IMMUNE)

	//They actually need this for their weapons
	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 120,
		PRUDENCE_ATTRIBUTE = 120,
		TEMPERANCE_ATTRIBUTE = 120,
		JUSTICE_ATTRIBUTE = 120,
	)


/datum/job/mixed_director/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	to_chat(M, span_userdanger("这是一个RP向角色，你与L公司无任何关联， \
	未经设施主管许可，不要进入设施下层区域. 请使用事务所信标来选择你的协会. \
	除非自卫，否则不要参与战斗，你不是战斗角色，而是行政角色. \
	若无重要报酬，不得协助L-公司."))
	to_chat(M, span_danger("避免无故杀死其他玩家."))
	outfit_owner.set_attribute_limit(120)
	return ..()

/datum/outfit/job/mixed_director
	name = "Association Section Director-协会科室主管"
	jobtype = /datum/job/mixed_director

	belt = /obj/item/pda/security
	ears = null
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id/association

	backpack_contents = list()


//Veteran
/datum/job/mixed_veteran
	title = "Association Assistant Director-协会科室副管"
	outfit = /datum/outfit/job/veteran
	department_head = list("your association")
	faction = "Station"
	supervisors = "your association"
	selection_color = "#e09660"
	total_positions = 1
	spawn_positions = 1
	display_order = JOB_DISPLAY_ORDER_VETERAN
	trusted_only = TRUE
	access = list(ACCESS_PHARMACY, ACCESS_NETWORK, ACCESS_RC_ANNOUNCE) // I want to use the number 69.
	minimal_access = list(ACCESS_PHARMACY, ACCESS_NETWORK, ACCESS_RC_ANNOUNCE) // I want to use the number 69.
	departments = DEPARTMENT_ASSOCIATION | DEPARTMENT_FIXERS
	paycheck = 400
	maptype = list("lcorp_city")

	mind_traits = list(TRAIT_WORK_FORBIDDEN, TRAIT_COMBATFEAR_IMMUNE)
	//They actually need this for their weapons
	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 100,
		PRUDENCE_ATTRIBUTE = 100,
		TEMPERANCE_ATTRIBUTE = 100,
		JUSTICE_ATTRIBUTE = 100,
	)

/datum/job/veteran/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	to_chat(M, span_userdanger("这是一个RP向角色，你与L公司无任何关联， \
	未经设施主管许可，不要进入设施下层区域. 你在职位上是仅次于协会主管的协会第二把手， \
	可以提供前线指挥."))
	to_chat(M, span_danger("避免无故杀死其他玩家."))
	outfit_owner.set_attribute_limit(100)
	return ..()

/datum/outfit/job/mixed_veteran
	name = "Association Assistant Director-协会科室副管"
	jobtype = /datum/job/mixed_veteran

	belt = /obj/item/pda/security
	ears = null
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id/association

	backpack_contents = list()
