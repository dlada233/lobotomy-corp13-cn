/obj/structure/altrefiner/weapon
	name = "EGO精炼仪"
	desc = "一台仅能由研发部长使用的机器，能够熔炼EGO并有概率产出PE."
	icon_state = "dominator-green"
	requires_item = TRUE
	var/list/meltable

/obj/structure/altrefiner/weapon/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		. += span_notice( "这台机器得到了升级, 减少了失败概率.")

/obj/structure/altrefiner/weapon/Initialize(mapload)
	var/list/processing = list(/obj/item/ego_weapon, /obj/item/ego_weapon/ranged, /obj/item/clothing/suit/armor/ego_gear)
	var/list/banned = list(/obj/item/ego_weapon/city/ncorp_mark)
	for(var/Y in processing)
		meltable += subtypesof(Y)
	for(var/X in banned)
		meltable -= subtypesof(X)
	return ..()

/obj/structure/altrefiner/weapon/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(!.)
		return

	if(!(I.type in meltable))
		to_chat(user, span_warning("这台机器只接收EGO."))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		return
	var/fail_chance = 50
	if (GetFacilityUpgradeValue(UPGRADE_EXTRACTION_1))
		fail_chance = 30
	qdel(I)
	if(prob(fail_chance))
		playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
		to_chat(user, span_warning("精炼失败. 请重试."))
		return

	to_chat(user, span_notice("精炼成功."))
	playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
	new /obj/item/refinedpe(get_turf(src))
