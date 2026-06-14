/obj/machinery/computer/abnormality
	name = "异想体工作终端"
	desc = "Used to perform various tasks with the abnormalities."
	icon_screen = "abnormality_work"
	resistance_flags = INDESTRUCTIBLE

	/// Datum reference of the abnormality this console is related to
	var/datum/abnormality/datum_reference = null
	/// Is the abnormality in process of qliphoth meltdown?
	var/meltdown = FALSE
	/// How much ticks left to pass before the effect of meltdown occurs?
	var/meltdown_time = 0
	/// Can the abnormality even meltdown?
	var/can_meltdown = TRUE
	/// Will works send signals and be logged?
	var/recorded = TRUE
	/// Special tutorial abnormality behaviors.
	var/tutorial = FALSE
	/// Work types will instead redirect to those, if listed.
	var/list/scramble_list = list()
	/// Work types revealed by understanding
	var/list/revealed_list = list()
	///Linked Panel
	var/obj/machinery/containment_panel/linked_panel
	/// Accumulated abnormality chemical.
	var/chem_charges = 0
	/// Extraction Officer Visual effect.
	var/obj/effect/vfx = null
	/// Extraction Officer Work bonus/penalty.
	var/work_bonus = 0
	/// Stored reference to Extraction Officer Tool.
	var/obj/item/extraction/key/EOTool = null
	/// Console Upgrades
	var/list/mechanical_upgrades = list(
		"abnochem" = 0,
		"workrate" = 0,
		)

/obj/machinery/computer/abnormality/Initialize()
	. = ..()
	GLOB.lobotomy_devices += src
	flags_1 |= NODECONSTRUCT_1

/obj/machinery/computer/abnormality/Destroy()
	GLOB.lobotomy_devices -= src
	..()

/obj/machinery/computer/abnormality/update_overlays()
	. = ..()
	if(meltdown)
		SSvis_overlays.add_vis_overlay(src, icon, "abnormality_meltdown[meltdown]", layer + 0.1, plane, dir)

/obj/machinery/computer/abnormality/examine(mob/user)
	. = ..()
	if(!datum_reference)
		return
	. += span_info("这台终端连接到 [datum_reference.GetName()]的收容单元.")
	var/threat_level = "<span style='color: [THREAT_TO_COLOR[datum_reference.GetRiskLevel()]]'>[THREAT_TO_NAME[datum_reference.GetRiskLevel()]]</span>"
	. += span_info("风险等级: ") + "[threat_level]" // Professionals have standards
	if(datum_reference.qliphoth_meter_max > 0)
		. += span_info("当前逆卡巴拉计数器: [datum_reference.qliphoth_meter].")
	if(datum_reference.overload_chance[user.ckey])
		. += span_warning("当前个体逆卡巴拉过载: [datum_reference.overload_chance[user.ckey]]%.")
	if(meltdown)
		var/melt_text = ""
		switch(meltdown)
			if(MELTDOWN_GRAY)
				melt_text = " 黑雾. 成功率降低 10%"
			if(MELTDOWN_GOLD)
				melt_text = "：金色. 未能处理将治愈调律者"
			if(MELTDOWN_PURPLE)
				melt_text = "：波浪. 处理后清除黑暗波浪"
			if(MELTDOWN_CYAN)
				melt_text = "：支柱. 成功率降低 20%. 未能处理将导致调律者发动致命攻击"
			if(MELTDOWN_BLACK)
				melt_text = "：疯狂. 未能处理将导致其他异想体突破收容"
		. += span_warning("收容单元正处于逆卡巴拉熔毁状态[melt_text]. 时间剩余: [meltdown_time].")
	//Show what upgrades you have. I dont have visuals for the upgrades yet so for now just exsamine tell them.
	. += span_info("终端已配备以下升级:")
	var/upgrade_list = ""
	for(var/i in mechanical_upgrades)
		if(mechanical_upgrades[i] == 0)
			continue
		upgrade_list += "[i]|"
	. += upgrade_list

/obj/machinery/computer/abnormality/ui_interact(mob/user)
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	if(!istype(datum_reference))
		to_chat(user, span_boldannounce("终端没有储存任何信息!"))
		return
	var/dat
	dat += "<b><span style='color: [THREAT_TO_COLOR[datum_reference.GetRiskLevel()]]'>\[[THREAT_TO_NAME[datum_reference.GetRiskLevel()]]\]</span> [datum_reference.GetName()]</b><br>"
	if(datum_reference.overload_chance[user.ckey])
		dat += "<span style='color: [COLOR_VERY_SOFT_YELLOW]'>个人工作成功率修正为 [datum_reference.overload_chance[user.ckey]]%.</span><br>"
		if(datum_reference.overload_chance_limit < 0 && datum_reference.overload_chance[user.ckey] <= datum_reference.overload_chance_limit) // How the fuck did you hit the limit..?
			dat += "<span style='color: [COLOR_MOSTLY_PURE_RED]'>处理其他的异想体吧, 我求你了...</span><br>"
	if(datum_reference.understanding != 0)
		dat += "<span style='color: [COLOR_BLUE_LIGHT]'>当前理解进度: [round((datum_reference.understanding/datum_reference.max_understanding)*100, 0.01)]%, 增加 [datum_reference.understanding]% 工作成功率和工作速度.</span><br>"
		if(datum_reference.observation_ready)
			dat += "<A href='byond://?src=[REF(src)];final_observation=1'>最终观察已就绪</A> <br>"
	if(work_bonus == EXTRACTION_KEY)
		dat += "<span style='color: [COLOR_VERY_SOFT_YELLOW]'>工作速度和成功率正因低水平的逆卡巴拉抑制而受到积极影响.</span><br>"
	dat += "<br>"

	//Abnormality portraits
	for(var/pahs in GLOB.abnormality_portraits)
		user << browse_rsc(pahs)
	dat += {"<div style="float:right; width: 50%;">
	<img src='[datum_reference.GetPortrait()].png' class="fit-picture" width="192" height="192">
	</div>"}
	dat += "<br>"

	var/list/work_list = datum_reference.available_work
	if(!tutorial && istype(SSlobotomy_corp.core_suppression, /datum/suppression/information))
		work_list = shuffle(work_list) // A minor annoyance, at most
	for(var/wt in work_list)
		var/work_display = "[wt]工作"
		if(scramble_list[wt] != null)
			work_display += "?"
		var/datum/suppression/information/I = GetCoreSuppression(/datum/suppression/information)
		if(!tutorial && istype(I))
			work_display = Gibberish(work_display, TRUE, I.gibberish_value)
		if(HAS_TRAIT(user, TRAIT_WORK_KNOWLEDGE) || mechanical_upgrades["workrate"] || (wt in revealed_list))
			dat += "<A href='byond://?src=[REF(src)];do_work=[wt]'>[work_display] \[[floor(datum_reference.get_work_chance(wt, user))]%\]</A> <br>"
		else
			dat += "<A href='byond://?src=[REF(src)];do_work=[wt]'>[work_display]</A> <br>"

	var/datum/browser/popup = new(user, "abno_work", "异想体工作终端", 450, 350)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/computer/abnormality/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		usr.set_machine(src)
		if(href_list["do_work"] in datum_reference.available_work)
			if(HAS_TRAIT(usr, TRAIT_WORK_FORBIDDEN) && recorded) //let clerks work training rabbit
				to_chat(usr, span_warning("这台终端无法被[prob(0.1) ? "一个卑微的文职" : "你"]所使用!"))
				return
			if(datum_reference.working)
				to_chat(usr, span_warning("终端正在运作中!"))
				return
			if(!istype(datum_reference.current) || (datum_reference.current.stat == DEAD))
				to_chat(usr, span_warning("异想体正在进行复原过程!"))
				return
			if(!(datum_reference.current.status_flags & GODMODE))
				to_chat(usr, span_warning("该异想体已经突破了收容!"))
				return
			var/work_attempt = datum_reference.current.AttemptWork(usr, href_list["do_work"])
			if(!work_attempt)
				if(work_attempt == FALSE)
					to_chat(usr, span_warning("此操作目前不可用."))
				return
			start_work(usr, href_list["do_work"])
		if(href_list["final_observation"])
			if(HAS_TRAIT(usr, TRAIT_WORK_FORBIDDEN)) //gifts are only for agents
				to_chat(usr, span_warning("你无法执行此操作!"))
				return
			if(datum_reference.working)
				to_chat(usr, span_warning("终端正在运作中!"))
				return
			if(!istype(datum_reference.current) || (datum_reference.current.stat == DEAD))
				to_chat(usr, span_warning("异想体正在进行复原过程!"))
				return
			if(!(datum_reference.current.status_flags & GODMODE))
				to_chat(usr, span_warning("该异想体已经突破了收容!"))
				return
			datum_reference.current.FinalObservation(usr)

	add_fingerprint(usr)
	updateUsrDialog()

/obj/machinery/computer/abnormality/proc/start_work(mob/living/carbon/human/user, work_type)
	var/sanity_result = round(datum_reference.current.fear_level - get_user_level(user))
	var/sanity_damage = 0
	switch(sanity_result)
		if(1)
			sanity_damage = user.maxSanity*0.1
		if(2)
			sanity_damage = user.maxSanity*0.3
		if(3)
			sanity_damage = user.maxSanity*0.6
		if(4 to INFINITY)
			sanity_damage = user.maxSanity
	var/work_time = datum_reference.max_boxes
	if(work_type in scramble_list)
		work_type = scramble_list[work_type]
	if(recorded)
		SEND_SIGNAL(user, COMSIG_WORK_STARTED, datum_reference, user, work_type)
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_WORK_STARTED, datum_reference, user, work_type)
	if(linked_panel)
		linked_panel.console_working()
	if(!HAS_TRAIT(user, TRAIT_WORKFEAR_IMMUNE))
		user.adjustSanityLoss(sanity_damage)
	if(user.stat == DEAD || user.sanity_lost)
		finish_work(user, work_type, 0) // Assume total failure
		return
	switch(sanity_result)
		if(-INFINITY to -1)
			to_chat(user, span_nicegreen("这差事太简单了!"))
		if(0)
			to_chat(user, span_notice("我可以一直这么做下去."))
		if(1)
			to_chat(user, span_warning("按照标准程序操作就好..."))
		if(2)
			to_chat(user, span_danger("冷静... 冷静..."))
		if(3 to INFINITY)
			to_chat(user, span_userdanger("我还没准备好!"))
	var/was_melting = meltdown //to remember if it was melting down before the work started
	meltdown = FALSE // Reset meltdown
	if(was_melting)
		SEND_SIGNAL(src, COMSIG_MELTDOWN_FINISHED, datum_reference, TRUE)
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MELTDOWN_FINISHED, datum_reference, TRUE)
	update_icon()
	datum_reference.working = TRUE
	var/work_chance = datum_reference.get_work_chance(work_type, user)
	if(was_melting == MELTDOWN_GRAY)
		work_chance -= 10
	if(was_melting == MELTDOWN_CYAN)
		work_chance -= 20
	var/work_speed = 1.5 SECONDS / (1 + ((get_modified_attribute_level(user, TEMPERANCE_ATTRIBUTE) + datum_reference.understanding) / 100))
	switch(work_bonus)
		if(EXTRACTION_KEY)
			if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
				work_speed *= 0.8 //20% faster work
			else
				work_speed *= 0.9 //10% faster work
	work_speed /= user.physiology.work_speed_mod
	var/success_boxes = 0
	var/total_boxes = 0
	var/canceled = FALSE
	ADD_TRAIT(user, TRAIT_STUNIMMUNE, src)
	ADD_TRAIT(user, TRAIT_PUSHIMMUNE, src)
	user.density = FALSE // If they can be walked through they can't be switched! I didn't wanna add chairs because if there WAS it'd nullify the ability to DODGE issues that appear.
	user.set_anchored(TRUE)
	user.is_working = TRUE
	// Initial chance and speed values before work started, in case they get overriden by abnormality
	var/init_work_chance = work_chance
	var/init_work_speed = work_speed
	while(total_boxes < work_time)
		if(!CheckStatus(user))
			break
		work_speed = datum_reference.current.SpeedWorktickOverride(user, work_speed, init_work_speed, work_type)
		if(do_after(user, work_speed, src, IGNORE_HELD_ITEM))
			if(!CheckStatus(user))
				break
			for(var/shield_type in typesof(/datum/status_effect/interventionshield))
				user.remove_status_effect(shield_type)
			work_chance = datum_reference.current.ChanceWorktickOverride(user, work_chance, init_work_chance, work_type)
			if(do_work(work_chance))
				success_boxes++
				datum_reference.current.WorktickSuccess(user)
			else
				datum_reference.current.WorktickFailure(user)
			total_boxes++
			datum_reference.current.Worktick(user)
		else
			if(!CheckStatus(user)) // No punishment if the thing is already breached or any other issue is prevelant.
				break
			for(var/i = 0 to round((work_time - total_boxes)*(1-((work_chance*0.5)/100)), 1)) // Take double of what you'd fail on average as NE box damage.
				datum_reference.current.WorktickFailure(user)
			playsound(src, 'sound/machines/synth_no.ogg', 75, FALSE, -4)
			to_chat(user, span_warning("当你的工作提前终止，异想体将感到不满!"))
			success_boxes = 0
			canceled = TRUE
			break
	REMOVE_TRAIT(user, TRAIT_STUNIMMUNE, src)
	REMOVE_TRAIT(user, TRAIT_PUSHIMMUNE, src)
	user.density = TRUE
	user.set_anchored(FALSE)
	user.is_working = FALSE
	finish_work(user, work_type, success_boxes, work_speed, was_melting, canceled)

/obj/machinery/computer/abnormality/proc/CheckStatus(mob/living/carbon/human/user)
	if(user.sanity_lost)
		return FALSE // Lost sanity
	if(user.health < 0)
		return FALSE // Dying
	if(!(datum_reference.current.status_flags & GODMODE))
		return FALSE // Somehow it escaped
	return TRUE

/obj/machinery/computer/abnormality/proc/do_work(chance)
	if(prob(chance))
		return TRUE
	return FALSE

/obj/machinery/computer/abnormality/proc/finish_work(mob/living/carbon/human/user, work_type, pe = 0, work_speed = 2 SECONDS, was_melting, canceled = FALSE)
	if(recorded)
		SEND_SIGNAL(user, COMSIG_WORK_COMPLETED, datum_reference, user, work_type)
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_WORK_COMPLETED, datum_reference, user, work_type)
	if(linked_panel)
		linked_panel.console_status(src)
	if(!work_type)
		work_type = pick(datum_reference.available_work)
	if(datum_reference.max_boxes != 0) // All these messages should be visible (on the console) and audible (announced by machine)
		audible_message(span_notice("[work_type]工作结束了. 得到[pe]/[datum_reference.max_boxes] PE."),\
				span_notice("[work_type]工作结束了. 得到[pe]/[datum_reference.max_boxes] PE."))
		if(pe >= datum_reference.success_boxes)
			audible_message(span_notice("工作结果: 优"),\
				span_notice("工作结果: 优"))
		else if(pe >= datum_reference.neutral_boxes)
			audible_message(span_notice("工作结果: 一般"),\
				span_notice("工作结果: 一般"))
		else
			audible_message(span_notice("工作结果: 差"),\
				span_notice("工作结果: 差"))
	if(istype(user))
		datum_reference.work_complete(user, work_type, pe, work_speed*datum_reference.max_boxes, was_melting, canceled)
		if(recorded) //neither rabbit nor tutorial calls this
			SSlobotomy_corp.WorkComplete(pe, (meltdown_time <= 0))
	chem_charges ++
	meltdown_time = 0
	datum_reference.working = FALSE
	return TRUE

/obj/machinery/computer/abnormality/process()
	if(..())
		if(meltdown)
			meltdown_time -= 1
			if(meltdown_time <= 0)
				qliphoth_meltdown_effect()

/obj/machinery/computer/abnormality/proc/start_meltdown(melt_type = MELTDOWN_NORMAL, min_time = 60, max_time = 90)
	meltdown_time = rand(min_time, max_time) + (GetFacilityUpgradeValue(UPGRADE_ABNO_MELT_TIME) * \
					(GetCoreSuppression(/datum/suppression/command) ? 0.5 : 1))
	meltdown = melt_type
	datum_reference.current.MeltdownStart()
	update_icon()
	if(linked_panel)
		linked_panel.console_meltdown()
	playsound(src, 'sound/machines/warning-buzzer.ogg', 75, FALSE, 3)
	return TRUE

/obj/machinery/computer/abnormality/proc/qliphoth_meltdown_effect()
	meltdown = FALSE
	update_icon()
	if(linked_panel)
		linked_panel.console_status(src)
	datum_reference.current.MeltdownEnd()
	datum_reference.qliphoth_change(-999)
	SEND_SIGNAL(src, COMSIG_MELTDOWN_FINISHED, datum_reference, FALSE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MELTDOWN_FINISHED, datum_reference, FALSE)
	return TRUE

// Scrambles work types for this specific console
/obj/machinery/computer/abnormality/proc/Scramble()
	var/list/normal_works = shuffle(list(
		ABNORMALITY_WORK_INSTINCT,
		ABNORMALITY_WORK_INSIGHT,
		ABNORMALITY_WORK_ATTACHMENT,
		ABNORMALITY_WORK_REPRESSION,
	))
	var/list/choose_from = normal_works.Copy()
	for(var/work in normal_works)
		scramble_list[work] = pick(choose_from - work)
		choose_from -= scramble_list[work]

//Links to containment panel
/obj/machinery/computer/abnormality/proc/LinkPanel(obj/machinery/panel)
	linked_panel = panel

//Applies or Removes Extraction Officer Key visuals and whatnot. Still has legacy support for possible future tools.
/obj/machinery/computer/abnormality/proc/ApplyEOTool(modifier = 0, removal = FALSE, obj/item/extraction/key/thetool = null)
	if(removal && modifier == work_bonus)
		if(vfx)
			qdel(vfx)
		work_bonus = 0
		if(EOTool)
			EOTool.Deactivate() //Visually turn off the tool
			EOTool = null
		return TRUE
	if(!datum_reference.current)
		return FALSE
	var/abno_target = datum_reference.current
	if(modifier == EXTRACTION_KEY)
		if(work_bonus != 0) //We can't apply a key while something is already active
			return FALSE
		if(datum_reference.understanding >= (datum_reference.max_understanding / 2)) //Understanding is over 50% - we can't keep giving them free bonuses
			return FALSE
		work_bonus = EXTRACTION_KEY
		var/turf/target_turf = get_ranged_target_turf(abno_target, SOUTHWEST, 1)
		vfx = new/obj/effect/extraction_effect(target_turf)
		vfx.icon_state = "key"
		EOTool = thetool //We store a reference to the key so we can visually turn it off at 50% understanding
		return TRUE
	return FALSE

//Install a work console upgrade
/obj/machinery/computer/abnormality/proc/InstallUpgrade(obj/upgrade_tech, upgrade_slot = "")
	if(!upgrade_tech)
		return
	if(!upgrade_slot)
		return
	upgrade_tech.forceMove(src)
	mechanical_upgrades[upgrade_slot] = upgrade_tech

//special console just for training rabbit
/obj/machinery/computer/abnormality/training_rabbit
	can_meltdown = FALSE
	recorded = FALSE

//special tutorial console: similar to training rabbit but actually give stats and not affected by suppressions
/obj/machinery/computer/abnormality/tutorial
	can_meltdown = FALSE
	recorded = FALSE
	tutorial = TRUE

//Don't add tutorial consoles to global list, prevents them from being affected by Control suppression or other effects
/obj/machinery/computer/abnormality/tutorial/Initialize()
	. = ..()
	GLOB.lobotomy_devices -= src

//don't scramble our poor interns
/obj/machinery/computer/abnormality/tutorial/Scramble()
	return
