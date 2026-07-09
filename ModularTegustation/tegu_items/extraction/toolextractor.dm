//Tool E.G.O extractor
/obj/item/extraction/tool_extractor
	name = "脑啡肽共振单元"
	desc = "一种专门的工具，允许从工具异常体中提取E.G.O."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "tool_extractor_empty"
	var/energy = 0
	var/maximum_energy = 20
	var/ego_selection
	var/ego_array

/obj/item/extraction/tool_extractor/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		. += span_notice( "这件工具看起来已经得到了升级, 减少20%的提取成本.")

/obj/item/extraction/tool_extractor/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_WORK_COMPLETED, PROC_REF(WorkCharge))
	RegisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END, PROC_REF(OrdealCharge))
	CalculateMaxNE(SSlobotomy_corp.next_ordeal_level - 2) //The math is weird on this - next_ordeal_level is the ordeal AFTER the one about to spawn, so 2 higher.

/obj/item/extraction/tool_extractor/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_WORK_COMPLETED)
	UnregisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END)
	return ..()

/obj/item/extraction/tool_extractor/proc/WorkCharge(SSdcs, datum_reference, user, work_type)
	SIGNAL_HANDLER
	if(datum_reference)
		if(istype(datum_reference, /datum/abnormality))
			var/datum/abnormality/theref = datum_reference
			AdjustNE(theref.threat_level)
			return
	AdjustNE(1) //Somehow there wasn't a datum

/obj/item/extraction/tool_extractor/proc/OrdealCharge(datum/source, datum/ordeal/O = null)
	SIGNAL_HANDLER
	if(!istype(O))
		return
	CalculateMaxNE(O.level)
	AdjustNE(round(maximum_energy / 2))

/obj/item/extraction/tool_extractor/proc/CalculateMaxNE(num)
	switch(num)
		if(-INFINITY to 0)
			maximum_energy = 20
		if(1)
			maximum_energy = 35
		if(2)
			maximum_energy = 50
		if(3)
			maximum_energy = 100
		if(4 to INFINITY)
			maximum_energy = ((num + 2) * 20)

/obj/item/extraction/tool_extractor/proc/AdjustNE(addition)
	energy = clamp(energy + addition, 0, maximum_energy)
	update_icon()

/obj/item/extraction/tool_extractor/examine(mob/user)
	. = ..()
	. += span_notice("这件工具的最大充能上限会随着考验完成而增加.")
	. += "当前已存储[energy]/[maximum_energy]的负性脑啡肽."
	. += "这件将在员工们完成工作或击败考验后重新充能一次.."

/obj/item/extraction/tool_extractor/attack_obj(obj/O, mob/living/carbon/user)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(!tool_checks(user))
		return ..() //You can't do any special interactions
	if(!istype(O, /obj/structure/toolabnormality))//E.G.O stuff below here
		return
	var/obj/structure/toolabnormality/P = O
	ego_selection = input(user, "Which E.G.O will you extract?") as null|anything in P.ego_list
	if(!ego_selection)
		return
	var/cost_multi = 1
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		cost_multi = 0.8 // 20% cheaper
	var/datum/ego_datum/D = ego_selection
	var/enkephalin_cost = initial(D.cost) * cost_multi
	var/loot = initial(D.item_path)
	switch(alert("这件E.G.O.需要[D.cost]负性脑啡肽来提取. 确认提取?",,"Yes","No"))
		if("Yes")
			if(enkephalin_cost > energy)
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				to_chat(usr, span_warning("设备中没有足够的负性脑啡肽来完成此操作."))
				return
			new loot(get_turf(src))
			AdjustNE(-enkephalin_cost)
			to_chat(usr, span_notice("E.G.O成功提取!"))
		if("No")
			to_chat(usr, span_notice("你觉得不提取E.G.O."))
	return

/obj/item/extraction/tool_extractor/update_icon()
	if(energy >= 12) //Able to extract at least ZAYINS
		icon_state = "tool_extractor"
		return
	icon_state = "tool_extractor_empty"
