/datum/job/rcorp_captain/commander
	title = "Ground Commander-地面指挥官"
	faction = "Station"
	department_head = list()
	total_positions = 1
	spawn_positions = 1
	supervisors = "the interests of R Corp"
	selection_color = "#a18438"
	exp_requirements = 3000
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp"
	trusted_only = TRUE
	mind_traits = list(TRAIT_COMBATFEAR_IMMUNE)
	outfit = /datum/outfit/job/commander
	display_order = 1

	access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL, ACCESS_MANAGER)
	minimal_access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL, ACCESS_MANAGER)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP
	mind_traits = list(TRAIT_COMBATFEAR_IMMUNE)
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 100,
								PRUDENCE_ATTRIBUTE = 100,
								TEMPERANCE_ATTRIBUTE = 0,
								JUSTICE_ATTRIBUTE = 100
								)
	alt_titles = list("Commander")
	rank_title = "CDR"
	job_important = "运用你的指挥艺术，带领R-公司第四集团军走向胜利. 你是R-公司雇佣军中最高级别的战斗人员之一."
	job_notice = " 先进行战前简报，然后通过军官房间的按钮打开通往室外的门."

/datum/job/rcorp_captain/commander/New()
	..()
	if(!trusted_only)
		return
	if(prob(10))
		rank_title = "JCDR"
		trusted_only = FALSE

/datum/job/rcorp_captain/commander/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	var/datum/action/G = new /datum/action/cooldown/warbanner/captain
	G.Grant(H)

	G = new /datum/action/cooldown/warcry/captain
	G.Grant(H)

/datum/job/rcorp_captain/commander/announce(mob/living/carbon/human/H)
	..()
	switch(rank_title)
		if("CDR")
			SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce), "全体注意，向指挥官[H.real_name] 致敬."))
		if("JCDR")
			SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce), "初级指挥官 [H.real_name] 已经到达指挥位置."))
		if("LCDR")
			SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce), "中尉指挥官 [H.real_name] 已经到达."))
		if("CPT")
			SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce), "队长 [H.real_name] 已经到达."))

/datum/outfit/job/commander
	name = "Ground Commander"
	jobtype = /datum/job/rcorp_captain/commander

	belt = null
	uniform = /obj/item/clothing/under/suit/lobotomy/rcorp_command
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	ears = /obj/item/radio/headset/heads/manager/alt
	head = /obj/item/clothing/head/beret/tegu/rcorp
	l_pocket = /obj/item/commandprojector
	r_hand = /obj/item/announcementmaker


/datum/job/rcorp_captain/commander/lieutenant
	title = "Lieutenant Commander-中尉副指挥官"
	trusted_only = FALSE
	outfit = /datum/outfit/job/commander/lieutenant
	display_order = 1.1
	exp_requirements = 1200
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)
	access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL)
	minimal_access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL)
	alt_titles = list("Base Commander-基地指挥官", "Senior Officer")
	rank_title = "LCDR"
	job_important = "你是指挥官的得力助手. 尽你所能协助他. 如果没有指挥官, 你将接替成为代理指挥官."
	job_notice = "管理你手下的初级军官"


/datum/outfit/job/commander/lieutenant
	name = "Lieutenant Commander-中尉副指挥官"
	jobtype = /datum/job/rcorp_captain/commander/lieutenant
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit/lcdr
	belt = /obj/item/ego_weapon/city/rabbit_blade


/obj/item/clothing/head/beret/tegu/rcorp
	name = "commander beret"
	desc = "A jet-black beret with the Ground Commander's rank pins on it."
	icon_state = "beret_rcorp"

/obj/item/clothing/neck/cloak/rcorp
	name = "ground commander's cloak"
	desc = "Worn by the rcorp commander of the 4th pack."
	icon_state = "rcorp"

/obj/item/clothing/under/suit/lobotomy/rcorp_command
	name = "ground commander's suit"
	desc = "Worn by the rcorp commander of the 4th pack."
	icon_state = "rcorp_command"

/*
Rcorp Ranks in order:

	Sr. Officer
CDR - Commander
JCDR - Jr Commander
LCDR - Lt Commander

	Jr. Officer
CPT - Captain
LT - Lieutenant

	Non-Officer

SGT - Sergeant
Sergeants are the heavy weapons specialists in the 4th Pack.

SPC - Specialist
Specialists are roles have have a job other than shooting. This includes medics, and scouts

RAF - RCorp Assault Force
Assault Rabbits.
*/
