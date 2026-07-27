/obj/structure/altrefiner/blood
	name = "鲜血精炼仪"
	desc = "一台仅能由研发部长使用的机器，会将使用者的HP消耗至只剩1点，然后机器将有概率产出PE-box."
	icon_state = "dominator-red"
	extraction_cost = 75

/obj/structure/altrefiner/blood/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		. += span_notice( "这台机器得到了升级, 对使用者造成的伤害降低了.")


/obj/structure/altrefiner/blood/attack_hand(mob/living/carbon/M)
	if(M.health <= 20)
		to_chat(M, span_warning("你的血已不足以完成运行."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return

	. = ..()
	if(!.)
		return

	//Gamble it
	var/gambling_number = (M.health - 1)
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		gambling_number = gambling_number/2
	M.adjustBruteLoss(gambling_number-1)	//Just in case we get weird rounding shit

	//So you can't actually use it repeatedly, have a min health of 20
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		gambling_number *= 2
	if(prob(gambling_number - 20))
		to_chat(M, span_notice("精炼成功."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
		new /obj/item/refinedpe(get_turf(src))
	else
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		to_chat(M, span_warning("精炼失败. 请再试一次."))
