/// How many seconds between each fuel depletion tick ("use" proc)
#define WELDER_FUEL_BURN_INTERVAL 26
/obj/item/weldingtool
	name = "焊接器"
	desc = "纳米传讯提供的标准型焊接器。"
	icon = 'icons/obj/tools.dmi'
	icon_state = "welder"
	inhand_icon_state = "welder"
	worn_icon_state = "welder"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 1
	throwforce = 1
	hitsound = "swing_hit"
	usesound = list('sound/items/welder.ogg', 'sound/items/welder2.ogg')
	drop_sound = 'sound/items/handling/weldingtool_drop.ogg'
	pickup_sound =  'sound/items/handling/weldingtool_pickup.ogg'
	light_system = MOVABLE_LIGHT
	light_range = 2
	light_power = 0.75
	light_color = LIGHT_COLOR_FIRE
	light_on = FALSE
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 30)
	resistance_flags = FIRE_PROOF
	heat = 3800
	tool_behaviour = TOOL_WELDER
	toolspeed = 1
	wound_bonus = 10
	bare_wound_bonus = 15
	custom_materials = list(/datum/material/iron=70, /datum/material/glass=30)
	///Whether the welding tool is on or off.
	var/welding = FALSE
	var/status = TRUE 		//Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/max_fuel = 20 	//The max amount of fuel the welder can hold
	var/change_icons = 1
	var/can_off_process = 0
	var/burned_fuel_for = 0	//when fuel was last removed
	var/acti_sound = 'sound/items/welderactivate.ogg'
	var/deac_sound = 'sound/items/welderdeactivate.ogg'

/obj/item/weldingtool/Initialize()
	. = ..()
	create_reagents(max_fuel)
	reagents.add_reagent(/datum/reagent/fuel, max_fuel)
	update_icon()

/obj/item/weldingtool/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	AddElement(/datum/element/tool_flash, light_range)

/obj/item/weldingtool/update_icon_state()
	if(welding)
		inhand_icon_state = "[initial(inhand_icon_state)]1"
	else
		inhand_icon_state = "[initial(inhand_icon_state)]"


/obj/item/weldingtool/update_overlays()
	. = ..()
	if(change_icons)
		var/ratio = get_fuel() / max_fuel
		ratio = CEILING(ratio*4, 1) * 25
		. += "[initial(icon_state)][ratio]"
	if(welding)
		. += "[initial(icon_state)]-on"


/obj/item/weldingtool/process(delta_time)
	switch(welding)
		if(0)
			force = 1
			damtype = BRUTE
			update_icon()
			if(!can_off_process)
				STOP_PROCESSING(SSobj, src)
			return
	//Welders left on now use up fuel, but lets not have them run out quite that fast
		if(1)
			force = 2
			damtype = FIRE
			burned_fuel_for += delta_time
			if(burned_fuel_for >= WELDER_FUEL_BURN_INTERVAL)
				use(1)
			update_icon()

	//This is to start fires. process() is only called if the welder is on.
	open_flame()


/obj/item/weldingtool/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user]把自己身上的孔窍全焊死了！看来是想自杀！</span>")
	return (FIRELOSS)


/obj/item/weldingtool/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		flamethrower_screwdriver(I, user)
	else if(istype(I, /obj/item/stack/rods))
		flamethrower_rods(I, user)
	else
		. = ..()
	update_icon()

/obj/item/weldingtool/proc/explode()
	var/turf/T = get_turf(loc)
	var/plasmaAmount = reagents.get_reagent_amount(/datum/reagent/toxin/plasma)
	dyn_explosion(T, plasmaAmount/5)//20 plasma in a standard welder has a 4 power explosion. no breaches, but enough to kill/dismember holder
	qdel(src)

/obj/item/weldingtool/afterattack(atom/O, mob/user, proximity)
	. = ..()
	if(!proximity)
		return

	if(isOn())
		handle_fuel_and_temps(1, user)

		if(!QDELETED(O) && isliving(O)) // can't ignite something that doesn't exist
			var/mob/living/L = O
			if(L.IgniteMob())
				message_admins("[ADMIN_LOOKUPFLW(user)] 在 [AREACOORD(user)] 用[src]点燃了[key_name_admin(L)]。")
				log_game("[key_name(user)] 在 [AREACOORD(user)] 用[src]点燃了[key_name(L)]。")

	if(!status && O.is_refillable())
		reagents.trans_to(O, reagents.total_volume, transfered_by = user)
		to_chat(user, "<span class='notice'>你把[src]里的燃料全部倒入了[O]。</span>")
		update_icon()

/obj/item/weldingtool/attack_qdeleted(atom/O, mob/user, proximity)
	. = ..()
	if(!proximity)
		return

	if(isOn())
		handle_fuel_and_temps(1, user)

		if(!QDELETED(O) && isliving(O)) // can't ignite something that doesn't exist
			var/mob/living/L = O
			if(L.IgniteMob())
				message_admins("[ADMIN_LOOKUPFLW(user)] 在 [AREACOORD(user)] 用[src]点燃了[key_name_admin(L)]。")
				log_game("[key_name(user)] 在 [AREACOORD(user)] 用[src]点燃了[key_name(L)]。")


/obj/item/weldingtool/attack_self(mob/user)
	if(src.reagents.has_reagent(/datum/reagent/toxin/plasma))
		message_admins("[ADMIN_LOOKUPFLW(user)] 在 [AREACOORD(user)] 启动了被动过手脚的焊接器。")
		explode()
	switched_on(user)

	update_icon()


// Ah fuck, I can't believe you've done this
/obj/item/weldingtool/proc/handle_fuel_and_temps(used = 0, mob/living/user)
	use(used)
	var/turf/location = get_turf(user)
	location.hotspot_expose(700, 50, 1)

// Returns the amount of fuel in the welder
/obj/item/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount(/datum/reagent/fuel)


// Uses fuel from the welding tool.
/obj/item/weldingtool/use(used = 0)
	if(!isOn() || !check_fuel())
		return FALSE

	if(used > 0)
		burned_fuel_for = 0

	if(get_fuel() >= used)
		reagents.remove_reagent(/datum/reagent/fuel, used)
		check_fuel()
		return TRUE
	else
		return FALSE


//Toggles the welding value.
/obj/item/weldingtool/proc/set_welding(new_value)
	if(welding == new_value)
		return
	. = welding
	welding = new_value
	set_light_on(welding)


//Turns off the welder if there is no more fuel (does this really need to be its own proc?)
/obj/item/weldingtool/proc/check_fuel(mob/user)
	if(get_fuel() <= 0 && welding)
		set_light_on(FALSE)
		switched_on(user)
		update_icon()
		return FALSE
	return TRUE

//Switches the welder on
/obj/item/weldingtool/proc/switched_on(mob/user)
	if(!status)
		to_chat(user, "<span class='warning'>[src]还没固定好，无法点火！</span>")
		return
	set_welding(!welding)
	if(welding)
		if(get_fuel() >= 1)
			to_chat(user, "<span class='notice'>你点燃了[src]。</span>")
			playsound(loc, acti_sound, 50, TRUE)
			force = 2
			damtype = FIRE
			hitsound = 'sound/items/welder.ogg'
			update_icon()
			START_PROCESSING(SSobj, src)
		else
			to_chat(user, "<span class='warning'>燃料不足！</span>")
			switched_off(user)
	else
		to_chat(user, "<span class='notice'>你关闭了[src]。</span>")
		playsound(loc, deac_sound, 50, TRUE)
		switched_off(user)

//Switches the welder off
/obj/item/weldingtool/proc/switched_off(mob/user)
	set_welding(FALSE)

	force = 1
	damtype = BRUTE
	hitsound = "swing_hit"
	update_icon()


/obj/item/weldingtool/examine(mob/user)
	. = ..()
	. += "剩余燃料：[get_fuel()]/[max_fuel] 单位。"

/obj/item/weldingtool/get_temperature()
	return welding * heat

//Returns whether or not the welding tool is currently on.
/obj/item/weldingtool/proc/isOn()
	return welding

// If welding tool ran out of fuel during a construction task, construction fails.
/obj/item/weldingtool/tool_use_check(mob/living/user, amount)
	if(!isOn() || !check_fuel())
		to_chat(user, "<span class='warning'>先点燃[src]才能继续操作！</span>")
		return FALSE

	if(get_fuel() >= amount)
		return TRUE
	else
		to_chat(user, "<span class='warning'>剩余焊接燃料不足以完成这项操作！</span>")
		return FALSE


/obj/item/weldingtool/proc/flamethrower_screwdriver(obj/item/I, mob/user)
	if(welding)
		to_chat(user, "<span class='warning'>请先关闭焊接器！</span>")
		return
	status = !status
	if(status)
		to_chat(user, "<span class='notice'>你重新固定好[src]，关上了燃料箱。</span>")
		reagents.flags &= ~(OPENCONTAINER)
	else
		to_chat(user, "<span class='notice'>现在可以给[src]加装部件、改装或补充燃料了。</span>")
		reagents.flags |= OPENCONTAINER
	add_fingerprint(user)

/obj/item/weldingtool/proc/flamethrower_rods(obj/item/I, mob/user)
	if(!status)
		var/obj/item/stack/rods/R = I
		if (R.use(1))
			var/obj/item/flamethrower/F = new /obj/item/flamethrower(user.loc)
			if(!remove_item_from_storage(F))
				user.transferItemToLoc(src, F, TRUE)
			F.weldtool = src
			add_fingerprint(user)
			to_chat(user, "<span class='notice'>你将一根金属棒装到了焊接器上，开始组装火焰喷射器。</span>")
			user.put_in_hands(F)
		else
			to_chat(user, "<span class='warning'>你需要一根金属棒才能开始组装火焰喷射器！</span>")

/obj/item/weldingtool/ignition_effect(atom/A, mob/user)
	if(use_tool(A, user, 0, amount=1))
		return "<span class='notice'>[user]随手用[src]点着了[A]，真有派头。</span>"
	else
		return ""

/obj/item/weldingtool/largetank
	name = "工业焊接器"
	desc = "稍大一些的焊接器，配有更大的燃料箱。"
	icon_state = "indwelder"
	max_fuel = 40
	custom_materials = list(/datum/material/glass=60)

/obj/item/weldingtool/largetank/flamethrower_screwdriver()
	return

/obj/item/weldingtool/largetank/cyborg
	name = "集成焊接器"
	desc = "专为机器人系统设计的先进焊接器，定制框架使焊接速度翻倍。"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "indwelder_cyborg"
	toolspeed = 0.5

/obj/item/weldingtool/largetank/cyborg/cyborg_unequip(mob/user)
	if(!isOn())
		return
	switched_on(user)


/obj/item/weldingtool/mini
	name = "应急焊接器"
	desc = "紧急情况用的微型焊接器。"
	icon_state = "miniwelder"
	max_fuel = 10
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/iron=30, /datum/material/glass=10)
	change_icons = FALSE

/obj/item/weldingtool/mini/flamethrower_screwdriver()
	return

/obj/item/weldingtool/abductor
	name = "外星焊接器"
	desc = "外星制造的焊接器。没人知道它用的是什么燃料，只知道永远用不完。"
	icon = 'icons/obj/abductor.dmi'
	icon_state = "welder"
	toolspeed = 0.1
	light_system = NO_LIGHT_SUPPORT
	light_range = 0
	change_icons = FALSE

/obj/item/weldingtool/abductor/process()
	if(get_fuel() <= max_fuel)
		reagents.add_reagent(/datum/reagent/fuel, 1)
	..()

/obj/item/weldingtool/hugetank
	name = "改良型工业焊接器"
	desc = "在工业焊接器上改良而来的型号。"
	icon_state = "upindwelder"
	inhand_icon_state = "upindwelder"
	max_fuel = 80
	custom_materials = list(/datum/material/iron=70, /datum/material/glass=120)

/obj/item/weldingtool/experimental
	name = "实验型焊接器"
	desc = "能自行生成燃料的实验型焊接器，对眼睛的伤害也较小。"
	icon_state = "exwelder"
	inhand_icon_state = "exwelder"
	max_fuel = 40
	custom_materials = list(/datum/material/iron=70, /datum/material/glass=120)
	change_icons = 0
	can_off_process = 1
	light_range = 1
	toolspeed = 0.5
	var/last_gen = 0
	var/nextrefueltick = 0

/obj/item/weldingtool/experimental/process()
	..()
	if(get_fuel() < max_fuel && nextrefueltick < world.time)
		nextrefueltick = world.time + 10
		reagents.add_reagent(/datum/reagent/fuel, 1)

#undef WELDER_FUEL_BURN_INTERVAL
