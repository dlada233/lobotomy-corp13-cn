/obj/structure/altrefiner/quick
	name = "快速精炼仪"
	desc = "一台仅能由研发部长使用的机器，通过将未精炼PE发送到其他地方来精炼."
	icon_state = "dominator-yellow"
	requires_item = TRUE

/obj/structure/altrefiner/quick/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		. += span_notice( "这台机器得到了升级, 将精炼时间缩短了12秒.")

/obj/structure/altrefiner/quick/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(!.)
		return
	var/time_mult = 1
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		time_mult = 2/3
	if(I.type != /obj/item/rawpe)
		to_chat(user, span_warning("这台机器仅接收未精炼PE"))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	if(!do_after(user, (10 * time_mult) SECONDS, src))
		to_chat(user, span_warning("插入失败. 请确保box完全插入"))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	to_chat(user, span_notice("请求已被接收. PE即将发射."))
	playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
	qdel(I)
	addtimer(CALLBACK(src, PROC_REF(launch)), (30 * time_mult) SECONDS)


/obj/structure/altrefiner/quick/proc/launch()
	//Pick a landmark
	var/landmark = pick(GLOB.xeno_spawn)
	//Ship it down
	var/obj/structure/closet/supplypod/centcompod/pod = new()
	new /obj/item/refinedpe(pod)
	pod.explosionSize = list(0,0,0,0)
	new /obj/effect/pod_landingzone(get_turf(landmark), pod)
