/obj/structure/altrefiner/chance
	name = "概率精炼仪"
	desc = "一台仅能由研发部长使用的机器，花费40PE，然后将用抛硬币般的方式来随机决定是否精炼成功."
	icon_state = "dominator-purple"
	extraction_cost = 40
	var/reset_time = 20 SECONDS
	var/ready = TRUE

/obj/structure/altrefiner/chance/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		. += span_notice( "这台机器得到了升级, 将成功概率提升至75%.")

/obj/structure/altrefiner/chance/proc/reset()
	ready = TRUE

/obj/structure/altrefiner/chance/attack_hand(mob/living/carbon/M)
	. = ..()
	if(!.)
		return
	if(!ready)
		to_chat(M, span_warning("精炼进行中. 请稍等."))
		return
	var/success_chance = 50
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		success_chance = 75
	if(prob(success_chance))
		to_chat(M, span_notice("精炼成功."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
		new /obj/item/refinedpe(get_turf(src))
	else
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		to_chat(M, span_warning("精炼失败. 请重试."))
	ready = FALSE

	addtimer(CALLBACK(src, PROC_REF(reset)), reset_time)
