/datum/job/raven
	title = "R-Corp Scout Raven - R-公司侦查渡鸦"
	faction = "Station"
	department_head = list("Raven Team Captain", "Commander")
	total_positions = 3
	spawn_positions = 3
	supervisors = "the raven team captain and the commander"
	selection_color = "#d9b555"
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	maptype = "rcorp"

	outfit = /datum/outfit/job/raven
	display_order = 8

	access = list(ACCESS_RND)
	minimal_access = list(ACCESS_RND)
	departments = DEPARTMENT_R_CORP
	mind_traits = list(TRAIT_COMBATFEAR_IMMUNE)
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 100
								)
	rank_title = "SPC"
	job_important = "你扮演侦查支援类角色."
	job_notice = "你不能使用枪支，但行动迅速，并且拥有夜视能力，在队伍前方侦察并传递信息. \
		你也能以手术般的精确度和高速度进行近战攻击."


/datum/job/raven/support
	title = "R-Corp Support Raven - R-公司支援渡鸦"
	total_positions = 2
	spawn_positions = 2
	display_order = 8.1
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 80
								)
	outfit = /datum/outfit/job/raven/support
	job_important = "你扮演情报支援类角色."
	job_notice = "你不能使用枪支，但拥有夜视能力，在你的背包里有各种工具可以提供信息并支援队友. \
		你不如侦查渡鸦速度快，尽量与队伍保持在一起."

/datum/job/rcorp_captain/raven
	title = "Rhino Squad Captain-乌鸦队队长"
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

	outfit = /datum/outfit/job/raven/captain
	display_order = 4

	access = list(ACCESS_RND, ACCESS_COMMAND)
	minimal_access = list(ACCESS_RND, ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 130
								)
	rank_title = "CPT"
	job_important = "你是情报支援部队的队长."
	job_notice = "前往指挥帐篷中的你的床位，收集情报支援工具. \
	收集并传递指挥部门之间的信息. \
	你是第四集团军中速度最快的单位，能以无人可及的速度发起攻击."

/datum/outfit/job/raven
	name = "R-Corp Scout Raven - R-公司侦查渡鸦"
	jobtype = /datum/job/raven

	ears = /obj/item/radio/headset/headset_information
	glasses = /obj/item/clothing/glasses/night/rabbit
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/rabbit_helmet/raven/grunt
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/raven
	belt = /obj/item/ego_weapon/city/rabbit_blade/raven
	r_pocket = /obj/item/pinpointer/nuke/rcorp
	backpack_contents = list(
		/obj/item/grenade/smokebomb = 1)

/datum/outfit/job/raven/support
	name = "R-Corp Support Raven - R-公司支援渡鸦"
	jobtype = /datum/job/raven/support
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/ravensup
	backpack_contents = list(
		/obj/item/powered_gadget/slowingtrapmk1 = 1,
		/obj/item/powered_gadget/detector_gadget/abnormality = 1,
		/obj/item/powered_gadget/vitals_projector = 1,
		/obj/item/powered_gadget/handheld_taser = 1,
		/obj/item/grenade/smokebomb = 1)

/datum/outfit/job/raven/captain
	name = "Rhino Squad Captain-乌鸦队队长"
	jobtype = /datum/job/rcorp_captain/raven
	glasses = /obj/item/clothing/glasses/hud/health/night/rabbit
	head = /obj/item/clothing/head/rabbit_helmet/raven
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/ravencap
	suit_store = null
	ears = /obj/item/radio/headset/heads/headset_information
