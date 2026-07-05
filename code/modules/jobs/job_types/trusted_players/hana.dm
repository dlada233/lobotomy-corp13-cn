//Hana
/datum/job/hana
	title = "Hana Representative - 一协会代表"
	outfit = /datum/outfit/job/hana
	department_head = list("your association")
	faction = "Station"
	supervisors = "your association"
	selection_color = "#ffffff"
	total_positions = 2
	spawn_positions = 2
	display_order = JOB_DISPLAY_ORDER_CAPTAIN
	trusted_only = TRUE
	access = list(ACCESS_NETWORK, ACCESS_COMMAND, ACCESS_MANAGER, ACCESS_CHANGE_IDS)
	minimal_access = list(ACCESS_NETWORK, ACCESS_COMMAND, ACCESS_MANAGER, ACCESS_CHANGE_IDS)
	departments = DEPARTMENT_HANA
	paycheck = 0
	mind_traits = list(TRAIT_WORK_FORBIDDEN, TRAIT_COMBATFEAR_IMMUNE)
	maptype = list("city", "fixers")
	job_important = "你是都市的管理者, 对当地的协会拥有一定的管理权力. \
		你必须帮助设立新的收尾人事务所，并颁发收尾人证书. \
		所有新设立的收尾人事务所必须在创建时进行申报，包括事务所名称和主管姓名."
	job_notice = "同时，你可以宣布新的禁忌事项(必须公开颁布)，并授权协会帮助执行这些规定. \
		你也可以在空闲时执行评级修订，发布任务和事务所检查. \
		更多信息，参阅 https://wiki.lc13.net/view/Hana_Association"


	//Mostly for armor.
	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 80,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 80,
	)

/datum/job/hana/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)

	//Don't give this shit to the interns, my lord
	if(paycheck==0)
		add_verb(outfit_owner, /client/proc/hanafetchquest)
//		add_verb(outfit_owner, /client/proc/hanaslayquest)
	if(SSmaptype.maptype == "fixers")
		for(var/datum/job/processing in SSjob.occupations)
			if(istype(processing, /datum/job/associateroaming) && processing.total_positions<6)	//Can have a max of 6 of these
				processing.total_positions +=2

	. = ..()

	return ..()

/datum/outfit/job/hana
	name = "Hana Representative - 一协会代表"
	jobtype = /datum/job/hana

	id = /obj/item/card/id/silver/plastic
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_cent
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/clothing/suit/armor/ego_gear/city/hana
	l_pocket = /obj/item/potential_tester

	backpack_contents = list(/obj/item/office_marker)

//Hana
/datum/job/hana/boss
	title = "Hana Administrator-一协会管理员"
	outfit = /datum/outfit/job/hana/admin
	total_positions = 1
	spawn_positions = 1
	display_order = JOB_DISPLAY_ORDER_MANAGER
	departments = DEPARTMENT_COMMAND | DEPARTMENT_HANA
	paycheck = 0


	//Mostly for armor.
	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 100,
		PRUDENCE_ATTRIBUTE = 100,
		TEMPERANCE_ATTRIBUTE = 100,
		JUSTICE_ATTRIBUTE = 100,
	)


/datum/outfit/job/hana/admin
	name = "Hana Administrator-一协会管理员"
	jobtype = /datum/job/hana/boss

	ears = /obj/item/radio/headset/heads/headset_association
	l_hand = /obj/item/clothing/suit/armor/ego_gear/city/hanacombat/paperwork

//Hana
/datum/job/hana/intern
	title = "Hana Intern - 一协会实习生"
	outfit = /datum/outfit/job/hana/intern
	total_positions = 2
	spawn_positions = 2
	display_order = JOB_DISPLAY_ORDER_INTERN
	paycheck = 1000
	trusted_only = FALSE


	//Mostly for armor.
	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 60,
	)

	job_important = "你是Hana协会的实习生，你的唯一工作是协助上级处理他们的事务. \
		你必须帮助设立新的收尾人事务所，并颁发收尾人证书. \
		所有新设立的收尾人事务所必须在创建时进行申报，包括事务所名称和主管姓名. "
	job_notice = "更多信息，参阅 https://wiki.lc13.net/view/Hana_Association"


/datum/outfit/job/hana/intern
	name = "Hana Intern - 一协会实习生"
	jobtype = /datum/job/hana/intern
	l_hand = null


/client/proc/hanafetchquest()
	set name = "发出收集任务"
	set category = "一协会任务"

	minor_announce("一协会已发出收集钻石硬币的任务，报酬将在完成任务后支付", "Hana Assignment:", TRUE)
	var/T = pick(SScityevents.distortion)
	var/Y = /obj/item/coin/diamond
	new Y (get_turf(T))

/client/proc/hanaslayquest()
	set name = "发出击杀任务"
	set category = "一协会任务"

	minor_announce("一协会已发出击杀未知扭曲的任务，报酬将在任务完成后支付", "Hana Assignment:", TRUE)
	var/T = pick(SScityevents.distortion)
	if(T)
		minor_announce("Found location", "Hana Assignment:", TRUE)
	new /obj/effect/bloodpool(get_turf(T))
	sleep(10)
	var/spawning = pick(SScityevents.distortions_available)
	new spawning (get_turf(T))
	if(spawning)
		minor_announce("Spawned enemy", "Hana Assignment:", TRUE)

