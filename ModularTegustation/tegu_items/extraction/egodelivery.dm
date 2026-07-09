//Extraction tool delivery item
/obj/item/extraction/delivery
	name = "E.G.O.传输设备"
	desc = "进供研发部长使用的便携式提取设备."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "coffin_empty"
	var/selected_level = ZAYIN_LEVEL
	var/obj/stored_item = null
	var/obj/structure/extraction_belt/linked_structure

/obj/item/extraction/delivery/examine(mob/user)
	. = ..()
	if(user.mind.assigned_role == "Extraction Officer")
		if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_2))
			. += span_notice("这件工具看起来已经得到了升级, 减少提取成本的15%.")
	if(linked_structure)
		. += span_nicegreen("这件工具连接到研发部长的送货传送带.")
	else
		. += span_red("这件工具必须与送货传送带连接，才能执行E.G.O.返回.")

/obj/item/extraction/delivery/tool_action(mob/user)
	if(!stored_item)
		ui_interact(user)
		return
	user.playsound_local(user, 'sound/machines/terminal_prompt.ogg', 50, FALSE)
	switch(tgui_alert(user,"你打算发送[stored_item.name]到哪里?","E.G.O.输送程序",list("自己","员工","送货传送带", "取消")))
		if("自己")
			user.playsound_local(user, 'sound/weapons/emitter2.ogg', 25, FALSE)
			new stored_item(get_turf(src))
			var/datum/effect_system/spark_spread/sparks = new
			sparks.set_up(5, 1, get_turf(src))
			sparks.attach(stored_item)
			sparks.start()
			stored_item = null
			if(linked_structure)
				var/obj/structure/return_pad/THEPAD = new(get_turf(src))
				THEPAD.linked_structure = linked_structure
		if("员工")
			user.playsound_local(user, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
			var/M = input(user,"你打算发送E.G.O.到谁那里?","选择某人") as null|anything in AllLivingAgents()
			if(!M)
				user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
				to_chat(user, span_warning("无特定角色."))
				return
			new stored_item(get_turf(M))
			user.playsound_local(user, 'sound/weapons/emitter2.ogg', 25, FALSE)
			playsound(get_turf(M), 'sound/weapons/emitter2.ogg', 25, FALSE)
			to_chat(user, span_notice("[stored_item.name]已经被发送到了[M]!"))
			to_chat(M, span_notice("[stored_item.name]已被研发部长发送到了你的所在地!"))
			var/datum/effect_system/spark_spread/sparks = new
			sparks.set_up(5, 1, get_turf(M))
			sparks.attach(stored_item)
			sparks.start()
			stored_item = null
			if(linked_structure)
				var/obj/structure/return_pad/THEPAD = new(get_turf(M))
				THEPAD.linked_structure = linked_structure
		if("送货传送带")
			if(!linked_structure)
				user.playsound_local(user, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
				to_chat(user, span_warning("ERROR - E.G.O.送货传送带未连接"))
				return
			user.playsound_local(user, 'sound/weapons/emitter2.ogg', 25, FALSE)
			new stored_item(get_turf(linked_structure))
			to_chat(user, span_notice("[stored_item.name]已经被发送到送货传送带!"))
			var/datum/effect_system/spark_spread/sparks = new
			sparks.attach(stored_item)
			sparks.start()
			stored_item = null
		if("取消")
			user.playsound_local(user, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
	update_icon()

/obj/item/extraction/delivery/ui_interact(mob/user)
	. = ..()
	playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat
	for(var/level = ZAYIN_LEVEL to ALEPH_LEVEL)
		dat += "<A href='byond://?src=[REF(src)];set_level=[level]'>[level == selected_level ? "<b><u>[THREAT_TO_NAME[level]]</u></b>" : "[THREAT_TO_NAME[level]]"]</A>"
	dat += "<hr>"
	for(var/datum/abnormality/A in SSlobotomy_corp.all_abnormality_datums)
		if(!LAZYLEN(A.ego_datums))
			continue
		if(A.threat_level != selected_level)
			continue
		dat += "[A.name] ([A.stored_boxes] PE):<br>"
		var/mult = 1
		if(user.mind.assigned_role == "Extraction Officer")
			if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_2))
				mult *= 0.85
		for(var/datum/ego_datum/E in A.ego_datums)
			dat += " <A href='byond://?src=[REF(src)];purchase=[E.name][E.item_category]'>[E.item_category] - [E.name] ([E.cost * mult] PE)</A>"
			var/info = html_encode(E.PrintOutInfo())
			if(info)
				dat += " - <A href='byond://?src=[REF(src)];info=[info]'>Info</A>"
			dat += "<br>"
		dat += "<br>"
	var/datum/browser/popup = new(user, "ego_purchase", "EGO Purchase Console", 440, 640)
	popup.set_content(dat)
	popup.open()
	return

/obj/item/extraction/delivery/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(href_list["set_level"])
		var/level = text2num(href_list["set_level"])
		if(!(level < ZAYIN_LEVEL || level > ALEPH_LEVEL) && level != selected_level)
			selected_level = level
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			ui_interact(usr)
			return TRUE
		return FALSE
	if(href_list["purchase"])
		var/target_datum = href_list["purchase"]
		var/datum/ego_datum/E = GLOB.ego_datums[target_datum]
		var/datum/abnormality/A = E.linked_abno
		if(!E || !A)
			return FALSE
		if(stored_item)
			to_chat(usr, span_warning("将优先分发在[src]中存储的物品."))
			return FALSE
		var/mult = 1
		if(usr.mind.assigned_role == "Extraction Officer")
			if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_2))
				mult *= 0.85 //15% off
		if(A.stored_boxes < (E.cost * mult))
			to_chat(usr, span_warning("此操作所需PE-Box数量不足."))
			playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
			return FALSE
		PrepareItem(E.item_path)
		to_chat(usr, span_notice("[E.name]已经被分发!"))
		log_game("[key_name(usr)] purchased [E.name].")
		message_admins("[key_name(usr)] purchased [E.item_path].")
		A.stored_boxes -= E.cost * mult
		playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
		updateUsrDialog()
		tool_action(usr)
		return TRUE

	if(href_list["info"])
		var/dat = html_decode(href_list["info"])
		var/datum/browser/popup = new(usr, "ego_info", "EGO Purchase Console", 340, 400)
		popup.set_content(dat)
		popup.open()
		return

/obj/item/extraction/delivery/proc/PrepareItem(obj/item/shipped)
	stored_item = shipped
	update_icon()
	return

/obj/item/extraction/delivery/update_icon()
	if(!stored_item)
		icon_state = "coffin_empty"
		return
	icon_state = "coffin"

// Telepad-related code
/obj/item/extraction/delivery/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(!tool_checks(user))
		return FALSE //You can't do any special interactions
	if(istype(A, /obj/structure/extraction_belt))
		linked_structure = A
		to_chat(usr, span_nicegreen("设备连接成功."))
		return FALSE
	return TRUE
