//Representative
/datum/job/representative
	title = "公司代表"
	outfit = /datum/outfit/job/representative
	department_head = list("your corporation")
	faction = "Station"
	supervisors = "the manager"
	selection_color = "#777777"
	total_positions = 1
	spawn_positions = 1
	display_order = JOB_DISPLAY_ORDER_REPRESENTATIVE
	trusted_only = TRUE
	access = list(ACCESS_PHARMACY, ACCESS_COMMAND) // I want to use the number 69.
	minimal_access = list(ACCESS_PHARMACY, ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND
	mapexclude = list("wonderlabs", "mini", "enkephalin_rush")
	mind_traits = list(TRAIT_WORK_FORBIDDEN, TRAIT_COMBATFEAR_IMMUNE)
	job_abbreviation = "REP"

/datum/job/representative/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	outfit_owner.set_attribute_limit(0)
	to_chat(M, span_userdanger("这是一个RP向角色，你扮演你所选公司的代表. 欢迎随时向管理员咨询，以推进你希望的剧情塑造."))
	return ..()

/datum/outfit/job/representative
	name = "Main Office Representative"
	jobtype = /datum/job/representative

	belt = /obj/item/pda/lawyer
	ears = /obj/item/radio/headset/heads/rep
	uniform = /obj/item/clothing/under/suit/lobotomy
	shoes = /obj/item/clothing/shoes/laceup

	backpack_contents = list(
		/obj/item/storage/box/rxglasses/spyglasskit,
	)

/// Alternate corps you can pick
/datum/job/representative
	alt_titles = list(
		"R-公司代表",
		"W-公司代表",
		"K-公司代表",
		"N-公司代表",
		"P-公司代表",
		"J-公司代表",
	)

/datum/outfit/job/representative/rcorprepresentative
	name = "R Corp Representative"
	uniform = /obj/item/clothing/under/suit/lobotomy/rcorp

/datum/outfit/job/representative/wcorprepresentative
	name = "W Corp Representative"
	uniform = /obj/item/clothing/under/suit/lobotomy/wcorp_command

/datum/outfit/job/representative/kcorprepresentative
	name = "K Corp Representative"
	uniform = /obj/item/clothing/under/suit/lobotomy/kcorp
	suit = /obj/item/clothing/suit/armor/ego_gear/city/kcorp_sci

/datum/outfit/job/representative/ncorprepresentative
	name = "N Corp Representative"
	uniform = /obj/item/clothing/under/suit/lobotomy/ncorp

/datum/outfit/job/representative/pcorprepresentative
	name = "P Corp Representative"
	uniform = /obj/item/clothing/under/suit/lobotomy/pcorp

/datum/outfit/job/representitive/jcorprepresentative
	name = "J Corp Representative"
	uniform = /obj/item/clothing/under/suit/lobotomy/jcorp
