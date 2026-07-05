/datum/job/reindeer
	title = "R-Corp Medical Reindeer - R-公司医疗驯鹿"
	faction = "Station"
	department_head = list("Reindeer Team Captain", "Commander")
	total_positions = 3
	spawn_positions = 3
	supervisors = "the reindeer team captain and the commander"
	selection_color = "#d9b555"
	exp_requirements = 240
	exp_type = EXP_TYPE_CREW
	maptype = "rcorp"

	outfit = /datum/outfit/job/reindeer
	display_order = 7

	access = list(ACCESS_MEDICAL)
	minimal_access = list(ACCESS_MEDICAL)
	departments = DEPARTMENT_R_CORP | DEPARTMENT_MEDICAL
	mind_traits = list(TRAIT_COMBATFEAR_IMMUNE)
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
	rank_title = "SPC"
	job_important = "你扮演防御性医疗支援角色，千万不要使光束交叉."
	job_notice = "你主要是支援角色。在基地西南部的医疗帐篷中收集你的物资，分散行动以达到最大效果."

/datum/job/reindeer/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	//Adding huds, blame some guy from at least 3 years ago.
	var/datum/atom_hud/secsensor = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	secsensor.add_hud_to(H)
	medsensor.add_hud_to(H)

/datum/job/reindeer/berserker
	title = "R-Corp Berserker Reindeer - R-公司狂战士驯鹿"
	total_positions = 2
	spawn_positions = 2
	outfit = /datum/outfit/job/reindeer/berserker
	display_order = 7.1

	rank_title = "SGT"
	job_important = "你扮演进攻性医疗角色，千万不要使光束交叉."
	job_notice = "你是一个进攻性支援角色，当你与敌人相连时，你的手杖会治愈周围人的理智，分散行动以达到最大效果."


/datum/job/rcorp_captain/reindeer
	title = "Reindeer Squad Captain-驯鹿队队长"
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

	outfit = /datum/outfit/job/reindeer/captain
	display_order = 3

	access = list(ACCESS_MEDICAL, ACCESS_COMMAND)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP | DEPARTMENT_MEDICAL

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)
	rank_title = "CPT"
	job_important = "你是医疗部队的队长。"
	job_notice = "前往指挥帐篷中的你的床位，收集你的医疗物资，并将你的单位分散成小队."


/datum/outfit/job/reindeer
	name = "R-Corp Medical Reindeer - R-公司医疗驯鹿"
	jobtype = /datum/job/reindeer

	ears = /obj/item/radio/headset/headset_welfare
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/rabbit_helmet/reindeer/grunt
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/reindeermed
	l_pocket = /obj/item/flashlight/seclite
	r_pocket = /obj/item/pinpointer/nuke/rcorp
	l_hand = /obj/item/gun/medbeam
	belt = null


/datum/outfit/job/reindeer/berserker
	name = "R-Corp Berserker Reindeer - R-公司狂战士驯鹿"
	jobtype = /datum/job/reindeer/berserker

	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	l_hand = /obj/item/gun/mindwhip
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/reindeerberserk


/datum/outfit/job/reindeer/captain
	name = "Reindeer Squad Captain-驯鹿队队长"
	jobtype = /datum/job/rcorp_captain/reindeer
	glasses = /obj/item/clothing/glasses/hud/health/night/rabbit
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/reindeercap
	belt = /obj/item/ego_weapon/city/rabbit_blade
	head = /obj/item/clothing/head/rabbit_helmet/reindeer
	ears = /obj/item/radio/headset/heads/headset_welfare
