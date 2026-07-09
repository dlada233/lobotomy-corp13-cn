//EO Lock -- Making it a subtype saves on copypaste
/obj/item/extraction/lock
	name = "逆卡巴拉锁定机"
	desc = "对工作终端使用可以提升收容单元的逆卡巴拉抑制场."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "lock_active"
	w_class = WEIGHT_CLASS_SMALL
	var/howtouse = "这件工具只能在异想体达到100%理解度时使用. <br>这件工具会强制提升目标异想体的逆卡巴拉计数器. <br>\
	WARNING : 这件工具可能无法在有特殊需求的异想体上工作. <br>此外, 这个设备在用于更强大的异想体时会有更长的冷却时间."
	var/recharging = FALSE
	var/cooldown_time

/obj/item/extraction/lock/update_icon()
	if(recharging)
		icon_state = "lock"
		return
	icon_state = "lock_active"

/obj/item/extraction/lock/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		. += span_notice("这件工具看起来已经得到了升级, 减少20%的冷却时间.")
	if(recharging)
		var/time_left = round(timeleft(cooldown_time))
		. +=  span_redtext("设备冷却中. 将在 [DisplayTimeText(time_left)] 后准备好.")
	. += howtouse

/obj/item/extraction/lock/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(!tool_checks(user))
		return FALSE // You can't do any special interactions
	if(istype(A, /obj/machinery/computer/abnormality))
		var/obj/machinery/computer/abnormality/target = A
		if(!target.datum_reference) // Probably bugged if this happens
			to_chat(user, span_warning("如果看到这条消息，说明这个终端没有连接到任何异常体。这很可能是bug，请报告！"))
			return TRUE
		if(!target.datum_reference.current) // Not a contained abno
			to_chat(user, span_warning("这个异想体当前不在或正在重新生成. 请稍后重试."))
			user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
			return TRUE
		if(!target.datum_reference.current.IsContained()) // Already breached
			to_chat(user, span_warning("太晚了！这个异想体已经突破收容了！"))
			user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
			return TRUE
		if(target.datum_reference.understanding < (target.datum_reference.max_understanding)) // Understanding under 100%
			to_chat(user, span_warning("设备无法运行在理解度未满的异想体上."))
			user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
			return TRUE
		if(target.datum_reference.qliphoth_meter >= (target.datum_reference.qliphoth_meter_max)) // Not missing any Qliphoth
			to_chat(user, span_warning("这个异想体已经达到了其逆卡巴拉计数器最大上限."))
			user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
			return TRUE
		if(recharging) // Device is on cooldown
			to_chat(user, span_warning("设备充能中!"))
			user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
			return FALSE
		if(istype(target.datum_reference.current, /mob/living/simple_animal/hostile/abnormality/black_swan)) // Stops certain abnos from bricking themselves.
			to_chat(user, span_warning("ERROR : 设备不兼容这个异想体!"))
			user.playsound_local(user, 'sound/machines/terminal_error.ogg', 50, FALSE)
			return TRUE
		var/multiplier = target.datum_reference.current.threat_level
		var/recharge_time = (multiplier * multiplier * 30) SECONDS
		if(GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
			recharge_time *= 0.8
		cooldown_time = addtimer(CALLBACK(src, PROC_REF(Recharge)), recharge_time, TIMER_STOPPABLE)
		target.datum_reference.qliphoth_change(1)
		recharging = TRUE
		user.playsound_local(user, 'sound/magic/arbiter/pin.ogg', 35, FALSE)
		to_chat(user, span_nicegreen("逆卡巴拉计数器已成功提升!"))
		update_icon()
		return TRUE
	to_chat(user, span_warning("ERROR : 设备应用失败 - 无效目标!"))
	return FALSE  // Not a console - just hit the thing

/obj/item/extraction/lock/proc/Recharge()
	playsound(src, 'sound/machines/twobeep.ogg', 25, FALSE)
	recharging = FALSE
	visible_message(span_notice("The [src] lights up!"))
	update_icon()
