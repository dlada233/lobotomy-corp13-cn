/obj/structure/altrefiner/timed
	name = "自动精炼仪"
	desc = "一台仅能由研发部长使用的机器，每5分钟自动精炼出5个PE-box."
	icon_state = "dominator-blue"
	extraction_cost = 500
	var/ready = TRUE

/obj/structure/altrefiner/timed/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		. += span_notice( "这台机器得到了升级, 减少了2分钟的生产耗时.")

/obj/structure/altrefiner/timed/proc/reset()
	playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
	ready = TRUE

/obj/structure/altrefiner/timed/attack_hand(mob/living/carbon/M)
	var/reset_time = 5 MINUTES
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		reset_time = 3 MINUTES
	if(!ready)
		to_chat(M, span_warning("这台机器尚未准备就绪."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	. = ..()
	if(!.)
		return

	playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
	for(var/i in 1 to 5)
		new /obj/item/refinedpe(get_turf(src))

	ready = FALSE
	addtimer(CALLBACK(src, PROC_REF(reset)), reset_time)
