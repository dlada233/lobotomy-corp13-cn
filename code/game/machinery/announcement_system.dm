GLOBAL_LIST_EMPTY(announcement_systems)

/obj/machinery/announcement_system
	density = TRUE
	name = "自动公告系统"
	desc = "通过无线电自动播报日常通知的系统。"
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "AAS_On"

	verb_say = "冷冷地宣告"
	verb_ask = "询问"
	verb_exclaim = "发出警报"

	idle_power_usage = 20
	active_power_usage = 50

	circuit = /obj/item/circuitboard/machine/announcement_system

	var/obj/item/radio/headset/radio
	var/arrival = "%PERSON 已经注册为 %RANK"
	var/arrivalToggle = 1
	var/newhead = "%RANK %PERSON 现任部门主管。"
	var/newheadToggle = 1
	var/newabno = "异想体“%PERSON”已被送至%RANK。"
	var/newabnoToggle = 1

	var/greenlight = "Light_Green"
	var/pinklight = "Light_Pink"
	var/errorlight = "Error_Red"

/obj/machinery/announcement_system/Initialize()
	. = ..()
	GLOB.announcement_systems += src
	radio = new /obj/item/radio/headset/silicon/ai(src)
	update_icon()

/obj/machinery/announcement_system/update_icon_state()
	if(is_operational)
		icon_state = (panel_open ? "AAS_On_Open" : "AAS_On")
	else
		icon_state = (panel_open ? "AAS_Off_Open" : "AAS_Off")

/obj/machinery/announcement_system/update_overlays()
	. = ..()
	if(arrivalToggle)
		. += greenlight

	if(newheadToggle)
		. += pinklight

	if(machine_stat & BROKEN)
		. += errorlight

/obj/machinery/announcement_system/Destroy()
	QDEL_NULL(radio)
	GLOB.announcement_systems -= src //"OH GOD WHY ARE THERE 100,000 LISTED ANNOUNCEMENT SYSTEMS?!!"
	return ..()

/obj/machinery/announcement_system/attackby(obj/item/P, mob/user, params)
	if(P.tool_behaviour == TOOL_SCREWDRIVER)
		P.play_tool_sound(src)
		panel_open = !panel_open
		to_chat(user, "<span class='notice'>你[panel_open ? "打开" : "关上"]了[src]的检修盖。</span>")
		update_icon()
	else if(default_deconstruction_crowbar(P))
		return
	else if(P.tool_behaviour == TOOL_MULTITOOL && panel_open && (machine_stat & BROKEN))
		to_chat(user, "<span class='notice'>你重置了[src]的固件。</span>")
		set_machine_stat(machine_stat & ~BROKEN)
		update_icon()
	else
		return ..()

/obj/machinery/announcement_system/proc/CompileText(str, user, rank) //replaces user-given variables with actual thingies.
	str = replacetext(str, "%PERSON", "[user]")
	str = replacetext(str, "%RANK", "[rank]")
	return str

/obj/machinery/announcement_system/proc/announce(message_type, user, rank, list/channels)
	if(!is_operational)
		return

	var/message

	if(message_type == "ARRIVAL" && arrivalToggle)
		message = CompileText(arrival, user, FacilityJobName(rank))
	else if(message_type == "NEWHEAD" && newheadToggle)
		message = CompileText(newhead, user, FacilityJobName(rank))
	else if(message_type == "NEWABNO" && newabnoToggle)
		message = CompileText(newabno, user, FacilityChannelName(rank))
	else if(message_type == "CRYOSTORAGE")
		message = "[user][rank ? "（[FacilityJobName(rank)]）" : ""]已被转入低温休眠舱。"
	else if(message_type == "ARRIVALS_BROKEN")
		message = "抵达穿梭机受损，正在靠泊维修……"

	if(channels.len == 0)
		radio.talk_into(src, message, null)
	else
		for(var/channel in channels)
			radio.talk_into(src, message, channel)

/obj/machinery/announcement_system/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AutomatedAnnouncement")
		ui.open()

/obj/machinery/announcement_system/ui_data()
	var/list/data = list()
	data["arrival"] = arrival
	data["arrivalToggle"] = arrivalToggle
	data["newhead"] = newhead
	data["newheadToggle"] = newheadToggle
	return data

/obj/machinery/announcement_system/ui_act(action, param)
	. = ..()
	if(.)
		return
	if(!usr.canUseTopic(src, !issilicon(usr)))
		return
	if(machine_stat & BROKEN)
		visible_message("<span class='warning'>[src]发出蜂鸣声。</span>", "<span class='hear'>你听到一声微弱的蜂鸣。</span>")
		playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, TRUE)
		return
	switch(action)
		if("ArrivalText")
			var/NewMessage = trim(html_encode(param["newText"]), MAX_MESSAGE_LEN)
			if(!usr.canUseTopic(src, !issilicon(usr)))
				return
			if(NewMessage)
				arrival = NewMessage
				log_game("[key_name(usr)] 将抵达公告更新为：[NewMessage]")
		if("NewheadText")
			var/NewMessage = trim(html_encode(param["newText"]), MAX_MESSAGE_LEN)
			if(!usr.canUseTopic(src, !issilicon(usr)))
				return
			if(NewMessage)
				newhead = NewMessage
				log_game("[key_name(usr)] 将主管公告更新为：[NewMessage]")
		if("NewAbnoText")
			var/NewMessage = trim(html_encode(param["newText"]), MAX_MESSAGE_LEN)
			if(!usr.canUseTopic(src, !issilicon(usr)))
				return
			if(NewMessage)
				newabno = NewMessage
				log_game("[key_name(usr)] 将异想体送达公告更新为：[NewMessage]")
		if("NewheadToggle")
			newheadToggle = !newheadToggle
			update_icon()
		if("ArrivalToggle")
			arrivalToggle = !arrivalToggle
			update_icon()
		if("NewAbnoToggle")
			newabnoToggle = !arrivalToggle
			update_icon()
	add_fingerprint(usr)

/obj/machinery/announcement_system/attack_robot(mob/living/silicon/user)
	. = attack_ai(user)

/obj/machinery/announcement_system/attack_ai(mob/user)
	if(!user.canUseTopic(src, !issilicon(user)))
		return
	if(machine_stat & BROKEN)
		to_chat(user, "<span class='warning'>[src]的固件似乎出了故障！</span>")
		return
	interact(user)

/obj/machinery/announcement_system/proc/act_up() //does funny breakage stuff
	if(!obj_break()) // if badmins flag this unbreakable or its already broken
		return

	arrival = pick("#!@%错误-34%2 无法定@#位职务文*件！", "严重错误 99。", "错)#: 找不@#到数(*据库！")
	newhead = pick("过#载()：检*#测到\[未知??\]！", "错)#误：发现损*@坏文*本！", "AAS.exe 未响应。NanoOS 正在查找解决方案。")

/obj/machinery/announcement_system/emp_act(severity)
	. = ..()
	if(!(machine_stat & (NOPOWER|BROKEN)) && !(. & EMP_PROTECT_SELF))
		act_up()

/obj/machinery/announcement_system/emag_act()
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	act_up()
