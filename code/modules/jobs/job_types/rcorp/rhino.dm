/datum/job/rhino
	title = "R-Corp Gunner Rhino - R-公司机枪手犀牛"
	faction = "Station"
	department_head = list("Rhino Team Captain", "Commander")
	total_positions = 2
	spawn_positions = 2
	supervisors = "the rhino team captain and the commander"
	selection_color = "#d9b555"
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	maptype = "rcorp"

	outfit = /datum/outfit/job/rhino
	display_order = 6

	access = list(ACCESS_ARMORY, ACCESS_CENT_GENERAL)
	minimal_access = list(ACCESS_ARMORY, ACCESS_CENT_GENERAL)
	departments = DEPARTMENT_R_CORP
	mind_traits = list(TRAIT_COMBATFEAR_IMMUNE)
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 40
								)
	rank_title = "SGT"
	job_important = "你扮演远程装甲单位的角色."
	job_notice = "在西北部的补给帐篷中装备你的机甲，占据前排，并为兔子们提供掩护. \
		你可以用焊枪修复你的机甲。记住，某些攻击可以穿透你的机甲"

/datum/job/rhino/hammer
	title = "R-Corp Hammer Rhino - R-公司重锤犀牛"
	total_positions = 1
	spawn_positions = 1
	display_order = 6.1
	outfit = /datum/outfit/job/rhino/melee

	access = list(ACCESS_ARMORY, ACCESS_CENT_THUNDER)
	minimal_access = list(ACCESS_ARMORY, ACCESS_CENT_THUNDER)

	job_important = "你扮演近战装甲单位的角色."

/datum/job/rcorp_captain/rhino
	title = "Rhino Squad Captain-犀牛队队长"
	faction = "Station"
	department_head = list("Commander")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the commander"
	selection_color = "#d1a83b"
	exp_requirements = 600
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp"

	outfit = /datum/outfit/job/rhino/captain
	display_order = 2

	access = list(ACCESS_ARMORY, ACCESS_COMMAND, ACCESS_CENT_GENERAL)
	minimal_access = list(ACCESS_ARMORY, ACCESS_COMMAND, ACCESS_CENT_GENERAL)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)
	rank_title = "CPT"
	job_important = "你是装甲部队的队长。"
	job_notice = "前往指挥帐篷中的你的床位，收集你的机甲，并在前线带领犀牛队."



/datum/outfit/job/rhino
	name = "R-Corp Gunner Rhino - R-公司机枪手犀牛"
	jobtype = /datum/job/rhino

	ears = /obj/item/radio/headset/headset_discipline
	glasses = /obj/item/clothing/glasses/hud/diagnostic/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	belt = /obj/item/storage/belt/rhino/full

/datum/outfit/job/rhino/melee
	name = "R-Corp Hammer Rhino - R-公司重锤犀牛"
	jobtype = /datum/job/rhino/hammer



/datum/outfit/job/rhino/captain
	name = "Rhino Squad Captain-犀牛队队长"
	jobtype = /datum/job/rcorp_captain/rhino
	glasses = /obj/item/clothing/glasses/hud/diagnostic/sunglasses
	ears = /obj/item/radio/headset/heads/headset_discipline
	belt = /obj/item/storage/belt/rhino/captain
