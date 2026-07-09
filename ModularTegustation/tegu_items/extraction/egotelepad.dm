/obj/structure/return_pad
	name = "E.G.O.返回面板"
	desc = "与W-公司合作开发的设备，用于快速安全地将E.G.O.运输至研发部门."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "qpad-idle"
	var/obj/structure/extraction_belt/linked_structure
	var/available_teleports = 3
	var/ready = FALSE

/obj/structure/return_pad/Initialize()
	. = ..()
	QDEL_IN(src, 45 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(Warmup)), 1 SECONDS)

/obj/structure/return_pad/Destroy()
	linked_structure = null
	return ..()

/obj/structure/return_pad/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/clothing/suit/armor/ego_gear) || is_ego_weapon(I))
		TryTeleport(I)
		return
	return ..()

/obj/structure/return_pad/proc/Warmup() // This proc basically exists so that people don't accidently toss items in it the instant it spawns
	ready = TRUE

/obj/structure/return_pad/proc/TryTeleport(obj/item/I)
	if(!linked_structure)
		visible_message(span_warning("ERROR - 未连接结构!"))
		qdel(src)
		return
	if(!ready)
		visible_message(span_warning("ERROR - 准备中. 请等待一秒."))
		return
	flick("qpad-beam", src)
	playsound(get_turf(src), 'sound/weapons/emitter2.ogg', 25, TRUE)
	playsound(get_turf(linked_structure), 'sound/weapons/emitter2.ogg', 25, TRUE)
	do_teleport(I, get_turf(linked_structure),null,TRUE,null,null,null,null,TRUE, channel = TELEPORT_CHANNEL_FREE) // Don't want anything interrupting it
	available_teleports -= 1
	if(!available_teleports)
		visible_message(span_warning("[src] 突然消失!"))
		qdel(src)
