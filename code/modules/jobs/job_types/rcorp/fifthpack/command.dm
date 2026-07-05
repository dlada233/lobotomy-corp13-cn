/datum/job/rcorp_captain/commander/assault
	title = "Assault Commander-突击指挥官"
	faction = "Station"
	exp_requirements = 3000
	maptype = "rcorp_fifth"
	trusted_only = FALSE

	outfit = /datum/outfit/job/commander/assault
	display_order = 1

	access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL, ACCESS_MANAGER)
	minimal_access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL, ACCESS_MANAGER)

	rank_title = "LCDR"
	job_important = "你是 Assault Commander-突击指挥官, 带领部队向前方发起攻击，你必须先向集团军做简报，确保自己有基本的计划，然后才能带领队伍前进."
	job_notice = " 先进行战前简报，然后通过军官房间的按钮打开通往外面的门，接着带领队伍发起冲锋."


/datum/outfit/job/commander/assault
	name = "Assault Commander-突击指挥官"
	jobtype = /datum/job/rcorp_captain/commander/assault

	belt = /obj/item/ego_weapon/city/rabbit_blade/command
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit/lcdr
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/assaultofficer
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	ears = /obj/item/radio/headset/heads/manager/alt
	head = /obj/item/clothing/head/beret/tegu/rcorp
	l_pocket = /obj/item/commandprojector
	r_pocket = /obj/item/flashlight/seclite
	r_hand = /obj/item/announcementmaker


/datum/job/rcorp_captain/commander/base
	title = "Base Commander-基地指挥官"
	trusted_only = FALSE
	outfit = /datum/outfit/job/commander/base
	display_order = 1.1
	exp_requirements = 1200
	maptype = "rcorp_fifth"
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)
	access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL)
	minimal_access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL)
	alt_titles = list("Base Commander-基地指挥官", "Senior Officer")
	rank_title = "CPT"
	job_important = "你是 Assault Commander-突击指挥官的得力助手，照顾好基地，并保护它免受敌人的侵害.  \
		如果你在前线被抓住，通讯就会中断. "
	job_notice = "管理你手下的初级军官"


/datum/outfit/job/commander/base
	name = "Base Commander-基地指挥官"
	jobtype = /datum/job/rcorp_captain/commander/lieutenant
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit/lcdr
	belt = /obj/item/ego_weapon/city/rabbit_blade
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/officer
	head = /obj/item/clothing/head/beret/tegu/captain
