//EO Key
/obj/item/extraction/key
	name = "抑制等级控制匙"
	desc = "对工作终端使用可以降低收容单元的逆卡巴拉抑制场，从而加快工作速度."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "key"
	w_class = WEIGHT_CLASS_SMALL
	var/obj/machinery/computer/abnormality/archived_console = null
	var/stored_user
	var/passed_variable = EXTRACTION_KEY
	var/itemname = "Key"
	var/howtouse = "这件工具只能在异想体未达到50%理解度时使用，当理解度达到50%时会失效. 这不会影响逆卡巴拉计数器."

/obj/item/extraction/key/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		. += span_notice("这件工具看起来已经得到了升级, 能提升更多的工作效率.")

/obj/item/extraction/key/proc/UserDeath()
	if(archived_console)
		archived_console.ApplyEOTool(passed_variable, TRUE, src)
	UnregisterSignal(stored_user, COMSIG_LIVING_DEATH)

/obj/item/extraction/key/Destroy()
	if(archived_console)
		archived_console.ApplyEOTool(passed_variable, TRUE)
	if(stored_user)
		UnregisterSignal(stored_user, COMSIG_LIVING_DEATH)
	return ..()

/obj/item/extraction/key/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(!tool_checks(user))
		return FALSE //You can't do any special interactions
	if(istype(A, /obj/machinery/computer/abnormality))
		if(archived_console)
			user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
			to_chat(user, span_warning("需要先移除当前连接!"))
			return TRUE
		var/obj/machinery/computer/abnormality/target = A
		if(target.ApplyEOTool(passed_variable, FALSE, src))
			archived_console = A
			user.playsound_local(user, 'sound/machines/terminal_processing.ogg', 50, FALSE)
			to_chat(user, span_nicegreen("[itemname] 成功应用!"))
			if(!stored_user)
				RegisterSignal(user, COMSIG_LIVING_DEATH, PROC_REF(UserDeath))
				stored_user = user
			update_icon()
			return TRUE
		user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
		to_chat(user, span_warning("ERROR : [itemname] 应用失败!"))
		return TRUE
	return FALSE  //Not a console - just hit the thing

/obj/item/extraction/key/tool_action(mob/user)
	if(archived_console)
		user.playsound_local(user, 'sound/machines/terminal_prompt.ogg', 50, FALSE)
		switch(tgui_alert(user,"移除[itemname]从当前收容单元?","研发部长 [itemname] 程序",list("Yes", "No")))
			if("Yes")
				user.playsound_local(user, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
				archived_console.ApplyEOTool(passed_variable, TRUE, src)
			if("No")
				user.playsound_local(user, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
		return
	user.playsound_local(user, 'sound/machines/terminal_prompt.ogg', 50, FALSE)
	to_chat(user, span_warning("未检测到连接的工作终端!"))
	return

/obj/item/extraction/key/proc/Deactivate()
	playsound(src, 'sound/machines/twobeep.ogg', 25, FALSE)
	archived_console = null
	visible_message(span_notice("[src]低声嗡鸣, 金色的指示灯逐渐熄灭."))
	update_icon()

/obj/item/extraction/key/update_icon()
	if(!archived_console)
		icon_state = "key"
		return
	icon_state = "key_active"

/obj/item/extraction/key/examine(mob/user)
	. = ..()
	if(archived_console)
		. += "正在一个收容单元内发挥作用."
	. += howtouse
