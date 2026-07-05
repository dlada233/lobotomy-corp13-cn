/datum/job/rabbit
	title = "R-Corp Suppressive Rabbit - R-公司抑制兔子"
	faction = "Station"
	department_head = list("Rabbit Team Captain", "Commander")
	total_positions = 4
	spawn_positions = 3
	exp_requirements = 120
	supervisors = "the rabbit team captain and the commander"
	selection_color = "#d9b555"
	mind_traits = list(TRAIT_COMBATFEAR_IMMUNE)
	outfit = /datum/outfit/job/rabbit
	display_order = 9
	maptype = "rcorp"

	//Eat shit rabbits lol
	access = list()
	minimal_access = list()
	departments = DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
	rank_title = "SGT"
	job_important = "你扮演机动远程步兵角色."
	job_notice = "你是一名高级兔子，手持全自动步枪和多相刀刃，行动灵活，攻击力强大."

/datum/job/rabbit/assault
	title = "R-Corp Assault Rabbit - R-公司突击兔子"
	total_positions = 10
	spawn_positions = 8
	outfit = /datum/outfit/job/rabbit/assault
	rank_title = "RAF"
	job_important = "你扮演机动远程步兵角色."
	job_notice = "你是一名兔子，手持半自动、单相步枪和具有冲刺能力的刀刃，你是第四集团军的中坚力量."


/datum/job/rcorp_captain/rabbit
	title = "Rabbit Squad Captain-兔子队队长"
	faction = "Station"
	department_head = list("Commander")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the commander"
	selection_color = "#d1a83b"
	exp_requirements = 360
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp"

	outfit = /datum/outfit/job/rabbit/captain
	display_order = 5

	access = list(ACCESS_COMMAND)
	minimal_access = list(ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)
	rank_title = "CPT"
	job_important = "你是一名高级兔子，手持全自动步枪和多相刀刃，行动灵活，攻击力强大."
	job_notice = "访问你在指挥帐篷中的床位，收集你的单手兔子枪和多相刀刃."



/datum/outfit/job/rabbit
	name = "R-Corp Suppressive Rabbit - R-公司抑制兔子"
	jobtype = /datum/job/rabbit

	ears = /obj/item/radio/headset/headset_control
	glasses = /obj/item/clothing/glasses/sunglasses
	suit_store = /obj/item/gun/energy/e_gun/rabbit/nopin
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	belt = /obj/item/ego_weapon/city/rabbit_blade
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/rabbit_helmet/grunt
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/grunts
	l_pocket = /obj/item/flashlight/seclite
	r_pocket = /obj/item/pinpointer/nuke/rcorp

/datum/outfit/job/rabbit/assault
	name = "R-Corp Assault Rabbit - R-公司突击兔子"
	jobtype = /datum/job/rabbit/assault

	suit_store = /obj/item/ego_weapon/city/rabbit_rush
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/assault
	belt = null

/datum/outfit/job/rabbit/assault/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	var/belt = pick(
	/obj/item/gun/energy/e_gun/rabbitdash,
	/obj/item/gun/energy/e_gun/rabbitdash/small,
	/obj/item/gun/energy/e_gun/rabbitdash/sniper,
	/obj/item/gun/energy/e_gun/rabbitdash/white,
	/obj/item/gun/energy/e_gun/rabbitdash/black,
	/obj/item/gun/energy/e_gun/rabbitdash/shotgun,
	)
	H.equip_to_slot_or_del(new belt(H),ITEM_SLOT_BELT, TRUE)



/datum/outfit/job/rabbit/captain
	name = "Rabbit Squad Captain-兔子队队长"
	jobtype = /datum/job/rcorp_captain/rabbit
	glasses = /obj/item/clothing/glasses/hud/health/night/rabbit
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit
	belt = /obj/item/ego_weapon/city/rabbit_blade
	head = null
	suit_store = null
	ears = /obj/item/radio/headset/heads/headset_control
