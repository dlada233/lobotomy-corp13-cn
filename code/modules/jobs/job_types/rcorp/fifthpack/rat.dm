/datum/job/rat
	title = "R-Corp Rat - R-公司老鼠"
	faction = "Station"
	department_head = list("Rat Squad Leader-老鼠队队长", "Commander")
	total_positions = 15
	spawn_positions = 15
	supervisors = "the rat squad leader and the commander"
	selection_color = "#d13711"

	outfit = /datum/outfit/job/rat
	display_order = 10
	maptype = "rcorp_fifth"

	access = list()
	minimal_access = list()
	departments = DEPARTMENT_R_CORP | DEPARTMENT_MEDICAL
	mind_traits = list(TRAIT_COMBATFEAR_IMMUNE)
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
	rank_title = "RAF"
	job_important = "你扮演一个多样化的作战单位，你也是唯一的医疗人员，除你之外，没人拥有医疗设备."
	job_notice = "你是一名携带霰弹枪，多相刀和微型医疗包的老鼠，你的职责取决于当前任务的需求."

/datum/job/rat/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	//Adding huds, blame some guy from at least 3 years ago.
	var/datum/atom_hud/secsensor = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	secsensor.add_hud_to(H)
	medsensor.add_hud_to(H)

/datum/job/rcorp_captain/rat
	title = "Rat Squad Leader-老鼠队队长"
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

	outfit = /datum/outfit/job/rat/leader
	display_order = 2

	access = list(ACCESS_COMMAND)
	minimal_access = list(ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP | DEPARTMENT_MEDICAL

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80,
								)
	rank_title = "LT"
	job_important = "你是一只多样化的作战部队的队长."
	//job_notice = "Visit your bunks in the command tent to gather your one-handed rabbit gun and multiphase blade."

/datum/job/rcorp_captain/rat/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	var/datum/atom_hud/secsensor = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	secsensor.add_hud_to(H)
	medsensor.add_hud_to(H)

// Mostly uneditted outfit datums for gear that doesn't exist yet.
/datum/outfit/job/rat
	name = "R-Corp Rat - R-公司老鼠"
	jobtype = /datum/job/rat

	ears = /obj/item/radio/headset/headset_welfare
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/rabbit_helmet/rat
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/rat
	belt = /obj/item/ego_weapon/city/rabbit_blade
	suit_store = /obj/item/gun/energy/e_gun/rabbitdash/shotgun
	l_pocket = /obj/item/flashlight/seclite
	r_pocket = /obj/item/pinpointer/nuke/rcorp
	backpack_contents = list(
		/obj/item/grenade/r_corp,
		/obj/item/grenade/r_corp/black,
		/obj/item/grenade/r_corp/white,
		/obj/item/storage/firstaid/revival = 1)


/datum/outfit/job/rat/leader
	name = "Rat Squad Leader-老鼠队队长"
	jobtype = /datum/job/rcorp_captain/rat

	belt = /obj/item/ego_weapon/city/rabbit_blade
	head = /obj/item/clothing/head/beret/tegu/rcorpofficer
	ears = /obj/item/radio/headset/heads/headset_welfare
