//Sephirah
/datum/job/command/sephirah
	title = "Sephirah"
	outfit = /datum/outfit/job/sephirah
	total_positions = 3
	spawn_positions = 3
	display_order = JOB_DISPLAY_ORDER_SEPHIRAH
	trusted_only = TRUE
	access = list(ACCESS_NETWORK, ACCESS_COMMAND, ACCESS_MANAGER) // Network is the trusted chat gamer access
	minimal_access = list(ACCESS_NETWORK, ACCESS_COMMAND, ACCESS_MANAGER)
	departments = DEPARTMENT_COMMAND
	mapexclude = list("wonderlabs", "mini", "lcorp_city", "enkephalin_rush")
	mind_traits = list(TRAIT_SANITYIMMUNE)
	job_important = "你是一名RP向角色，不得参与战斗. 协助主管，与员工和文职们进行RP."
	job_notice = "\
		在Gamemaster标签页中，你可以调整游戏参数. \
		这是一个OOC工具. 所以不要在IC里表示你能做到这一点. \
		如果任何IC行动针对你，要提醒管理员. \
		滥用此功能将导致白名单被取消.\
	"

	job_abbreviation = "SEPH"

/datum/job/command/sephirah/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	. = ..()
	//You're a fucking robot.
	//Okay maybe don't JUST let them grief.
	add_verb(outfit_owner, /mob/living/carbon/human/proc/QuestComplete)

	//NOW Let'em Grief
	add_verb(outfit_owner, /mob/living/carbon/human/proc/GameInfo)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/Announcement)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/RandomAbno)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/RandomSelection)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/NextAbno)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/SlowGame)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/QuickenGame)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/WorkMeltIncrease)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/WorkMeltDecrease)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/MeltIncrease)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/MeltDecrease)
	add_verb(outfit_owner, /mob/living/carbon/human/proc/BulletAuth)
	// a TGUI menu that SHOULD contain all the above actions
	var/datum/action/sephirah_game_panel/new_action = new(outfit_owner.mind || outfit_owner)
	new_action.Grant(outfit_owner)

	outfit_owner.apply_pref_name("sephirah", M.client)
	outfit_owner.name += " - [M.client.prefs.prefered_sephirah_department]"
	outfit_owner.real_name += " - [M.client.prefs.prefered_sephirah_department]"
	for(var/obj/item/card/id/Y in outfit_owner.contents)
		Y.registered_name = outfit_owner.name
		Y.update_label()

	//You're a robot, man
	if(M.client.prefs.prefered_sephirah_bodytype == "Box")
		outfit_owner.set_species(/datum/species/sephirah)
		outfit_owner.dna.features["mcolor"] = sanitize_hexcolor(M.client.prefs.prefered_sephirah_boxcolor)
		outfit_owner.update_body()
		outfit_owner.update_body_parts()
		outfit_owner.update_mutations_overlay() // no hulk lizard

	else
		outfit_owner.set_species(/datum/species/synth)

	outfit_owner.speech_span = SPAN_ROBOT

	//Adding huds, blame some guy from at least 3 years ago.
	var/datum/atom_hud/secsensor = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	secsensor.add_hud_to(outfit_owner)
	medsensor.add_hud_to(outfit_owner)

/datum/outfit/job/sephirah
	name = "Sephirah"
	jobtype = /datum/job/command/sephirah

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/heads/manager/alt
	uniform = /obj/item/clothing/under/rank/rnd/scientist
	shoes = /obj/item/clothing/shoes/laceup
	r_pocket = /obj/item/modular_computer/tablet/preset/advanced/command
	l_pocket = /obj/item/commandprojector

	box = /obj/item/storage/box/survival/lobotomy
	backpack_contents = list()

GLOBAL_LIST_INIT(sephirah_names, list(
	"Job", "Lot", "Isaac", "Lazarus", "Gaius", "Abel", "Enoch", "Jescha"
))




/*************************************************/
//Sephirah Gamemaster commands.

/mob/living/carbon/human/proc/QuestComplete()
	set name = "奖励点数"
	set category = "Sephirah.Events"
	SSlobotomy_corp.lob_points += 1
	minor_announce("本设施内的sephirah已决定进行奖励，因该设施及其主管的表现堪称典范. \
				1 LOB点数已经分发至主管账户中", "Central Command Alert:", TRUE)
	return

/mob/living/carbon/human/proc/RandomAbno()
	set name = "随机异想体"
	set category = "Sephirah.Events"
	for(var/obj/machinery/computer/abnormality_queue/Q in GLOB.lobotomy_devices)
		var/mob/living/simple_animal/hostile/abnormality/target_type = SSabnormality_queue.GetRandomPossibleAbnormality()
		if(Q.locked)
			to_chat(src, span_danger("异想体已被随机."))
			return

		Q.UpdateAnomaly(target_type, "danger rolled", TRUE)
		SSabnormality_queue.AnnounceLock()
		SSabnormality_queue.ClearChoices()

		//Literally being griefed.
		SSlobotomy_corp.lob_points += 1
		minor_announce("由于资源不足，已随机选择一个异想体，并发放LOB点数到您的账户. \
				提取部门对造成的不便感到抱歉", "提取警报:", TRUE)
		return

/mob/living/carbon/human/proc/RandomSelection()
	set name = "随机异想体选择"
	set category = "Sephirah.Events"

	SSabnormality_queue.next_abno_spawn = world.time + SSabnormality_queue.next_abno_spawn_time + ((min(16, SSabnormality_queue.spawned_abnos) - 6) * 6) SECONDS
	SSabnormality_queue.PickAbno()

	//Literally being griefed.
	SSlobotomy_corp.lob_points += 0.25
	minor_announce("提取部门在选择异想体时出现了错误. 提取部门对此表示歉意， \
			并已将实际的 [GetFacilityUpgradeValue(UPGRADE_ABNO_QUEUE_COUNT)] 异想体发送到您的管理终端.", "提取警报:", TRUE)
	return

//See next abnormality
/mob/living/carbon/human/proc/NextAbno()
	set name = "检查下个异想体"
	set category = "Sephirah"
	//Abno stuff, so you can grief more effectively.
	var/mob/living/simple_animal/hostile/abnormality/queued_abno = SSabnormality_queue.queued_abnormality
	to_chat(src, span_notice("当前状态:"))
	to_chat(src, span_notice("异想体数量: [SSabnormality_queue.spawned_abnos]."))
	to_chat(src, span_notice("下个异想体: [initial(queued_abno.name)]."))

//Speed stuff
GLOBAL_VAR_INIT(Sephirahspeed, 0)

/mob/living/carbon/human/proc/SlowGame()
	set name = "异想体到达时间减缓"
	set category = "Sephirah.Game Changes"
	if(GLOB.Sephirahspeed > -3)
		SSabnormality_queue.next_abno_spawn_time *= 1.2
		GLOB.Sephirahspeed --
		to_chat(src, span_notice("你减缓了异想体的到达."))
		message_admins("<span class='notice'>一个sephirah ([src.ckey]) 减缓了异想体的到达.</span>")
	else
		to_chat(src, span_notice("异想体提取无法更慢了."))

/mob/living/carbon/human/proc/QuickenGame()
	set name = "异想体到达时间加快"
	set category = "Sephirah.Game Changes"

	if(GLOB.Sephirahspeed < 3)
		SSabnormality_queue.next_abno_spawn_time /= 1.2
		GLOB.Sephirahspeed ++
		to_chat(src, span_notice("你加速了异想体的到达."))
		message_admins("<span class='notice'>A sephirah ([src.ckey]) 加快了异想体的到达.</span>")
	else
		to_chat(src, span_notice("异想体提取无法更快了."))

//Ordeal Stuff
GLOBAL_VAR_INIT(Sephirahordealspeed, 0)

/mob/living/carbon/human/proc/WorkMeltIncrease()
	set name = "熔毁时间增加"
	set category = "Sephirah.Game Changes"

	if(GLOB.Sephirahordealspeed > 5)
		to_chat(src, span_notice("熔毁时间增加了!"))
		return

	GLOB.Sephirahordealspeed ++
	to_chat(src, span_notice("熔毁时间增加了!"))
	message_admins("<span class='notice'>A sephirah ([src.ckey]) has made works per melt longer.</span>")


/mob/living/carbon/human/proc/WorkMeltDecrease()
	set name = "熔毁时间减少"
	set category = "Sephirah.Game Changes"

	if(GLOB.Sephirahordealspeed < -3 )
		to_chat(src, span_notice("熔毁时间减少了!"))
		return

	GLOB.Sephirahordealspeed --
	to_chat(src, span_notice("熔毁时间减少了!"))
	message_admins("<span class='notice'>A sephirah ([src.ckey]) has made works per melt shorter.</span>")


GLOBAL_VAR_INIT(Sephirahmeltmodifier, 0)

/mob/living/carbon/human/proc/MeltIncrease()
	set name = "异想体熔毁数量增加"
	set category = "Sephirah.Game Changes"

	if(GLOB.Sephirahmeltmodifier > 5)
		to_chat(src, span_notice("Too many abnormalities are melting!"))
		return

	GLOB.Sephirahmeltmodifier ++
	to_chat(src, span_notice("One more abnormality will melt per event."))
	message_admins("<span class='notice'>A sephirah ([src.ckey]) has made more abnormalities melt per event.</span>")


/mob/living/carbon/human/proc/MeltDecrease()
	set name = "异想体熔毁数量减少"
	set category = "Sephirah.Game Changes"

	if(GLOB.Sephirahmeltmodifier < -1*SSlobotomy_corp.qliphoth_meltdown_amount+2)
		to_chat(src, span_notice("Too little abnormalities are melting!"))
		return

	GLOB.Sephirahmeltmodifier --
	to_chat(src, span_notice("One less abnormality will melt per event."))
	message_admins("<span class='notice'>A sephirah ([src.ckey]) has made less abnormalities melt per event.</span>")

//Execution barrets
GLOBAL_LIST_EMPTY(SephirahBullet)

/mob/living/carbon/human/proc/BulletAuth()
	set name = "授权处决弹"
	set category = "Sephirah"
	GLOB.SephirahBullet |= src.ckey
	if(length(GLOB.SephirahBullet) == 2)
		if(SSmaptype.maptype == "skeld")
			minor_announce("处决弹授权项目出现错误. \
				处决弹将不再向本设施供给.", "控制部警告:", TRUE)
		else
			minor_announce("本设施主管已被认为值得信任，将授权处决弹使用. \
				处决弹将立刻送达.", "惩戒部警告:", TRUE)
			GLOB.execution_enabled = TRUE

	else
		to_chat(src, span_notice("你的上级已通知你获得授权。提醒：处决弹需要两位Sephirah的授权."))
		message_admins(span_notice("一位sephirah ([src.ckey])给予了处决弹的授权."))

/mob/living/carbon/human/proc/Announcement()
	set name = "发表公告"
	set category = "Sephirah"
	var/input = stripped_input(src,"公告内容?", ,"测试公告")
	minor_announce("[input]" , "来自Sephirah的官方公告: [src.name]")

//See next abnormality
/mob/living/carbon/human/proc/GameInfo()
	set name = "检查游戏信息"
	set category = "Sephirah"
	//So you can see what the others have done
	to_chat(src, span_notice("当前情况:"))
	to_chat(src, span_notice("Sephirah熔毁修改: [GLOB.Sephirahmeltmodifier]."))
	to_chat(src, span_notice("Sephirah熔毁时间修改: [GLOB.Sephirahordealspeed]."))
	to_chat(src, span_notice("异想体到达时间修改: [GLOB.Sephirahordealspeed]."))

// TGUI stuff below

/datum/action/sephirah_game_panel
	name = "打开Sephirah游戏控制面板"
	desc = "这让你能够以各种方式操作游戏，滥用可能导致被封禁"
	button_icon_state = "round_end"

/datum/action/sephirah_game_panel/ui_state(mob/user)
	return GLOB.always_state // this line of code is actually needed, else it IMMEDIATELLY closes itself. Luv myself TGUI <3

/datum/action/sephirah_game_panel/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	message_admins("[owner] has opened the sephirah game control panel")
	ui_interact(owner)

/datum/action/sephirah_game_panel/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SephirahPanel")
		ui.open()
		ui.set_autoupdate(TRUE)

/datum/action/sephirah_game_panel/ui_data(mob/user)
	. = ..()
	var/list/data = list()

	data["abno_number"] = SSabnormality_queue.spawned_abnos

	data["abnormality_arrival"] = GLOB.Sephirahspeed
	data["meltdown_speed"] = GLOB.Sephirahordealspeed


	var/mob/living/simple_animal/hostile/abnormality/queued_abno = SSabnormality_queue.queued_abnormality
	data["queued_abno"] = initial(queued_abno.name)

	// START OF ARRIVAL INFORMATION
	var/safe_abnormality_delay
	if(SSabnormality_queue.next_abno_spawn != INFINITY) // Happens when starting abnormalities are being selected, or things break
		safe_abnormality_delay = floor(SSabnormality_queue.next_abno_spawn)
	else
		safe_abnormality_delay = ABNORMALITY_DELAY + SSticker.round_start_time

	data["previous_arrival_time"] = floor(SSabnormality_queue.previous_abno_spawn ? SSabnormality_queue.previous_abno_spawn : ROUNDTIME)
	data["current_arrival_time"] = floor(world.time)
	data["next_arrival_time"] = safe_abnormality_delay + 5 SECONDS // The seconds are because the subsystem fires every 10 seconds
	// END OF ARRIVAL INFORMATION

	return data

/datum/action/sephirah_game_panel/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	if(!ishuman(owner)) // we are calling human procs, so processing actions from non-humans is dangerous
		return
	var/mob/living/carbon/human/hooman = owner

	switch(action) // maybe change labels?
		if("Make announcement")
			hooman.Announcement()

		if("Complete quest")
			hooman.QuestComplete()

		if("Randomize abnormality")
			hooman.RandomAbno()

		if("Randomize selection")
			hooman.RandomSelection()

		if("Authorize execution bullets")
			hooman.BulletAuth()

		if("Slow abnormality arrival")
			hooman.SlowGame()

		if("Quicken abnormality arrival")
			hooman.QuickenGame()

		if("Increase Work per Meltdown ratio")
			hooman.WorkMeltIncrease()

		if("Decrease Work per Meltdown ratio")
			hooman.WorkMeltDecrease()

		if("Increase abnormality per meltdown ratio")
			hooman.MeltIncrease()

		if("Decrease abnormality per meltdown")
			hooman.MeltDecrease()


