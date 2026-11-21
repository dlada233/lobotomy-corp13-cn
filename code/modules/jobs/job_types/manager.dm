/datum/job/manager
	title = "Manager"
	department_head = list("L Corp")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the manager"
	selection_color = "#bcbcef"
	display_order = JOB_DISPLAY_ORDER_MANAGER

	exp_requirements = 720
	exp_type = EXP_TYPE_CREW
	minimal_player_age = 7

	outfit = /datum/outfit/job/manager

	access = list(ACCESS_COMMAND, ACCESS_MANAGER) // LC13:To-Do
	minimal_access = list(ACCESS_COMMAND, ACCESS_MANAGER)
	departments = DEPARTMENT_COMMAND

	job_attribute_limit = 60
	roundstart_attributes = list(FORTITUDE_ATTRIBUTE, PRUDENCE_ATTRIBUTE = 60, TEMPERANCE_ATTRIBUTE, JUSTICE_ATTRIBUTE)
	mind_traits = list(TRAIT_WORK_FORBIDDEN, TRAIT_COMBATFEAR_IMMUNE)
	job_important = "你是主管. 你的目标是在推进整体工作进度的同时为员工和文职提供支援. 你能够选择将要到来的异想体, 能够购买设施升级以及解锁监控台的种种功能."
	mapexclude = list("enkephalin_rush")

	job_abbreviation = "MGR"

/datum/job/manager/announce(mob/living/carbon/human/outfit_owner)
	..()
	var/displayed_rank = title // Handle alt titles
	if(title in outfit_owner?.client?.prefs?.alt_titles_preferences)
		displayed_rank = outfit_owner.client.prefs.alt_titles_preferences[title]

	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce), "[displayed_rank] [outfit_owner.real_name] 已经到达了本设施."))

/datum/job/manager/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	. = ..()
	outfit_owner.grant_language(/datum/language/bong, TRUE, FALSE, LANGUAGE_MIND) //So they can understand the bong-bong but not speak it

	//Adding huds, blame some guy from at least 3 years ago.
	var/datum/atom_hud/secsensor = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]

	secsensor.add_hud_to(outfit_owner)
	medsensor.add_hud_to(outfit_owner)

/datum/outfit/job/manager
	name = "Manager"
	jobtype = /datum/job/manager

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/heads/manager/alt
	uniform = /obj/item/clothing/under/suit/lobotomy
	suit =  /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/laceup
	r_pocket = /obj/item/modular_computer/tablet/preset/advanced/command

	box = /obj/item/storage/box/survival/lobotomy
	backpack_contents = list(/obj/item/station_charter)
