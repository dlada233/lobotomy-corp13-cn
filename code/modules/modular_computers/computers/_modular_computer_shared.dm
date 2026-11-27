
/obj/proc/is_modular_computer()
	return

/obj/proc/get_modular_computer_part(part_type)
	return null

/obj/item/modular_computer/is_modular_computer()
	return TRUE

/obj/item/modular_computer/get_modular_computer_part(part_type)
	if(!part_type)
		stack_trace("get_modular_computer_part() called without a valid part_type")
		return null
	return all_components[part_type]


/obj/machinery/modular_computer/is_modular_computer()
	return TRUE

/obj/machinery/modular_computer/get_modular_computer_part(part_type)
	if(!part_type)
		stack_trace("get_modular_computer_part() called without a valid part_type")
		return null
	return cpu?.all_components[part_type]


/obj/proc/get_modular_computer_parts_examine(mob/user)
	. = list()
	if(!is_modular_computer())
		return

	var/user_is_adjacent = Adjacent(user) //don't reveal full details unless they're close enough to see it on the screen anyway.

	var/obj/item/computer_hardware/ai_slot/ai_slot = get_modular_computer_part(MC_AI)
	if(ai_slot)
		if(ai_slot.stored_card)
			if(user_is_adjacent)
				. += "智能卡插槽中插着[ai_slot.stored_card.name]。"
			else
				. += "智能卡插槽里似乎插着一张卡。"
			. += span_info("按住 Alt 单击可弹出智能卡。")
		else
			. += "终端配有一个智能卡插槽。"

	var/obj/item/computer_hardware/card_slot/card_slot = get_modular_computer_part(MC_CARD)
	var/obj/item/computer_hardware/card_slot/card_slot2 = get_modular_computer_part(MC_CARD2)
	var/multiple_slots = istype(card_slot) && istype(card_slot2)
	if(card_slot)
		if(card_slot?.stored_card || card_slot2?.stored_card)
			var/obj/item/card/id/first_ID = card_slot?.stored_card
			var/obj/item/card/id/second_ID = card_slot2?.stored_card
			var/multiple_cards = istype(first_ID) && istype(second_ID)
			if(user_is_adjacent)
				. += "终端配有[multiple_slots ? "两个" : "一个"]身份卡插槽，已插入[multiple_cards ? "[first_ID]和[second_ID]" : "[first_ID ? first_ID : second_ID]"]。"
			else
				. += "终端配有[multiple_slots ? "两个" : "一个"]身份卡插槽，看起来插着[multiple_cards ? "两张" : "一张"]卡。"
			. += span_info("按住 Alt 单击[src]可弹出身份卡。")
		else
			. += "终端配有[multiple_slots ? "两个" : "一个"]身份卡插槽。"

	var/obj/item/computer_hardware/printer/printer_slot = get_modular_computer_part(MC_PRINT)
	if(printer_slot)
		. += "终端装有打印机。"
		if(user_is_adjacent)
			. += "打印机剩余纸张：[printer_slot.stored_paper]/[printer_slot.max_paper]。"
