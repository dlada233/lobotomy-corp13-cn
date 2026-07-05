/datum/job/roadrunner
	title = "R-Corp Roadrunner - R-公司走鹃"
	faction = "Station"
	department_head = list("Roadrunner Squad Leader-走鹃队队长", "Commander")
	total_positions = 4
	spawn_positions = 3
	exp_requirements = 120
	supervisors = "the roadrunner squad leader and the commander"
	selection_color = "#d13711"

	outfit = /datum/outfit/job/roadrunner
	display_order = 13
	maptype = "rcorp_fifth"
	mind_traits = list(TRAIT_COMBATFEAR_IMMUNE)
	access = list()
	minimal_access = list()
	departments = DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 50,
								PRUDENCE_ATTRIBUTE = 50,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 130
								)
	rank_title = "SGT"
	job_important = "你扮演一名游击角色."
	job_notice = "你是一名配备多相枪和护盾的走鹃，你持续骚扰敌人并使他们没有时间休息整备."


/datum/job/rcorp_captain/roadrunner
	title = "Roadrunner Squad Leader-走鹃队队长"
	faction = "Station"
	department_head = list("Commander")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the commander"
	selection_color = "#d13711"
	exp_requirements = 360
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp_fifth"

	outfit = /datum/outfit/job/roadrunner/leader
	display_order = 4

	access = list(ACCESS_COMMAND)
	minimal_access = list(ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 70,
								PRUDENCE_ATTRIBUTE = 70,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 130
								)
	rank_title = "LT"
	job_important = "你是游击部队的指挥官."
	//job_notice = "Visit your bunks in the command tent to gather your one-handed rabbit gun and multiphase blade."


// Mostly uneditted outfit datums for gear that doesn't exist yet.
/datum/outfit/job/roadrunner
	name = "R-Corp Roadrunner - R-公司走鹃"
	jobtype = /datum/job/roadrunner

	ears = /obj/item/radio/headset/headset_information
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/rabbit_helmet/roadrunner
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/roadrunner
	belt = /obj/item/ego_weapon/city/rabbit_blade/raven
	l_pocket = /obj/item/flashlight/seclite
	r_pocket = /obj/item/pinpointer/nuke/rcorp

/datum/outfit/job/roadrunner/leader
	name = "Roadrunner Squad Leader-走鹃队队长"
	jobtype = /datum/job/rcorp_captain/roadrunner

	belt = /obj/item/ego_weapon/city/rabbit_blade/raven
	suit_store = null
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/roadrunnercap
	ears = /obj/item/radio/headset/heads/headset_control
