/datum/job/supportofficer
	title = "Support Officer-支援军官"
	faction = "Station"
	department_head = list("Lieutenant Commander-中尉副指挥官", "Ground Commander-地面指挥官")
	total_positions = 3
	spawn_positions = 3
	supervisors = "your senior officers"
	selection_color = "#a18438"
	exp_requirements = 600
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp_fifth"
	outfit = /datum/outfit/job/supportofficer
	display_order = 1.99
	mind_traits = list(TRAIT_COMBATFEAR_IMMUNE)
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
	access = list(ACCESS_COMMAND)
	minimal_access = (ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP
	rank_title = "LT"
	job_important = "你担任R-公司的支援与指挥角色. 向指挥官汇报和提出建议，执行物资调配与部署."
	job_notice = "运行补给请求，协助R-公司人员在基地工作，部署后，使用你的信标选择你想要的类型."

/datum/job/supportofficer/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	var/datum/action/G = new /datum/action/cooldown/warbanner/captain
	G.Grant(H)

	G = new /datum/action/cooldown/warcry/captain
	G.Grant(H)


/datum/outfit/job/supportofficer
	name = "Support Officer-支援军官"
	jobtype = /datum/job/supportofficer
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit/officer
	belt = /obj/item/ego_weapon/city/rabbit_blade
	ears =  /obj/item/radio/headset/heads
	head = /obj/item/clothing/head/beret/tegu/rcorpofficer
	l_hand = /obj/item/choice_beacon/officer
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	l_pocket = /obj/item/flashlight/seclite
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/officer
