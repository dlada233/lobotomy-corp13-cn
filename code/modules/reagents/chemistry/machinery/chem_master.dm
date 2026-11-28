/**
 * Machine that allows to identify and separate reagents in fitting container
 * as well as to create new containers with separated reagents in it.
 *
 * Contains logic for both ChemMaster and CondiMaster, switched by "condi".
 */
/obj/machinery/chem_master
	name = "ChemMaster 3000 配药机"
	desc = "用于分离化学品，并将其制成不同剂型分装。"
	density = TRUE
	layer = BELOW_OBJ_LAYER
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"
	use_power = IDLE_POWER_USE
	idle_power_usage = 20
	resistance_flags = FIRE_PROOF | ACID_PROOF
	circuit = /obj/item/circuitboard/machine/chem_master

	/// Input reagents container
	var/obj/item/reagent_containers/beaker
	/// Pill bottle for newly created pills
	var/obj/item/storage/pill_bottle/bottle
	/// Whether separated reagents should be moved back to container or destroyed. 1 - move, 0 - destroy
	var/mode = 1
	/// Decides what UI to show. If TRUE shows UI of CondiMaster, if FALSE - ChemMaster
	var/condi = FALSE
	/// Currently selected pill style
	var/chosen_pill_style = 1
	/// Currently selected condiment bottle style
	var/chosen_condi_style = CONDIMASTER_STYLE_AUTO
	/// Current UI screen. On the moment of writing this comment there were two: 'home' - main screen, and 'analyze' - info about specific reagent
	var/screen = "home"
	/// Info to display on 'analyze' screen
	var/analyze_vars[0]
	/// List of available pill styles for UI
	var/list/pill_styles
	/// List of available condibottle styles for UI
	var/list/condi_styles

/obj/machinery/chem_master/Initialize()
	create_reagents(100)

	//Calculate the span tags and ids fo all the available pill icons
	var/datum/asset/spritesheet/simple/assets = get_asset_datum(/datum/asset/spritesheet/simple/pills)
	pill_styles = list()
	for (var/x in 1 to PILL_STYLE_COUNT)
		var/list/SL = list()
		SL["id"] = x
		SL["className"] = assets.icon_class_name("pill[x]")
		pill_styles += list(SL)

	condi_styles = strip_condi_styles_to_icons(get_condi_styles())

	. = ..()

/obj/machinery/chem_master/Destroy()
	QDEL_NULL(beaker)
	QDEL_NULL(bottle)
	return ..()

/obj/machinery/chem_master/RefreshParts()
	reagents.maximum_volume = 0
	for(var/obj/item/reagent_containers/glass/beaker/B in component_parts)
		reagents.maximum_volume += B.reagents.maximum_volume

/obj/machinery/chem_master/ex_act(severity, target)
	if(severity < 3)
		..()

/obj/machinery/chem_master/contents_explosion(severity, target)
	..()
	if(beaker)
		switch(severity)
			if(EXPLODE_DEVASTATE)
				SSexplosions.high_mov_atom += beaker
			if(EXPLODE_HEAVY)
				SSexplosions.med_mov_atom += beaker
			if(EXPLODE_LIGHT)
				SSexplosions.low_mov_atom += beaker
	if(bottle)
		switch(severity)
			if(EXPLODE_DEVASTATE)
				SSexplosions.high_mov_atom += bottle
			if(EXPLODE_HEAVY)
				SSexplosions.med_mov_atom += bottle
			if(EXPLODE_LIGHT)
				SSexplosions.low_mov_atom += bottle

/obj/machinery/chem_master/handle_atom_del(atom/A)
	..()
	if(A == beaker)
		beaker = null
		reagents.clear_reagents()
		update_icon()
	else if(A == bottle)
		bottle = null

/obj/machinery/chem_master/update_icon_state()
	if(beaker)
		icon_state = "mixer1"
	else
		icon_state = "mixer0"

/obj/machinery/chem_master/update_overlays()
	. = ..()
	if(machine_stat & BROKEN)
		. += "waitlight"

/obj/machinery/chem_master/blob_act(obj/structure/blob/B)
	if (prob(50))
		qdel(src)

/obj/machinery/chem_master/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "mixer0_nopower", "mixer0", I))
		return

	else if(default_deconstruction_crowbar(I))
		return

	if(default_unfasten_wrench(user, I))
		return
	if(istype(I, /obj/item/reagent_containers) && !(I.item_flags & ABSTRACT) && I.is_open_container())
		. = TRUE // no afterattack
		if(panel_open)
			to_chat(user, span_warning("[src.name]的检修盖还开着，无法使用！"))
			return
		var/obj/item/reagent_containers/B = I
		. = TRUE // no afterattack
		if(!user.transferItemToLoc(B, src))
			return
		replace_beaker(user, B)
		to_chat(user, span_notice("你把[B]放入[src]。"))
		updateUsrDialog()
		update_icon()
	else if(!condi && istype(I, /obj/item/storage/pill_bottle))
		if(bottle)
			to_chat(user, span_warning("[src]里已经装了一个药瓶！"))
			return
		if(!user.transferItemToLoc(I, src))
			return
		bottle = I
		to_chat(user, span_notice("你把[I]放进了分装口。"))
		updateUsrDialog()
	else
		return ..()

/obj/machinery/chem_master/AltClick(mob/living/user)
	. = ..()
	if(!can_interact(user) || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	replace_beaker(user)

/**
 * Handles process of moving input reagents containers in/from machine
 *
 * When called checks for previously inserted beaker and gives it to user.
 * Then, if new_beaker provided, places it into src.beaker.
 * Returns `boolean`. TRUE if user provided (ignoring whether threre was any beaker change) and FALSE if not.
 *
 * Arguments:
 * * user - Mob that initialized replacement, gets previously inserted beaker if there's any
 * * new_beaker - New beaker to insert. Optional
 */
/obj/machinery/chem_master/proc/replace_beaker(mob/living/user, obj/item/reagent_containers/new_beaker)
	if(!user)
		return FALSE
	if(beaker)
		try_put_in_hand(beaker, user)
		beaker = null
	if(new_beaker)
		beaker = new_beaker
	update_icon()
	return TRUE

/obj/machinery/chem_master/on_deconstruction()
	replace_beaker()
	if(bottle)
		bottle.forceMove(drop_location())
		adjust_item_drop_location(bottle)
		bottle = null
	return ..()

/obj/machinery/chem_master/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/simple/pills),
		get_asset_datum(/datum/asset/spritesheet/simple/condiments),
	)

/obj/machinery/chem_master/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemMaster", name)
		ui.open()

/obj/machinery/chem_master/ui_data(mob/user)
	var/list/data = list()
	data["isBeakerLoaded"] = beaker ? 1 : 0
	data["beakerCurrentVolume"] = beaker ? beaker.reagents.total_volume : null
	data["beakerMaxVolume"] = beaker ? beaker.volume : null
	data["mode"] = mode
	data["condi"] = condi
	data["screen"] = screen
	data["analyzeVars"] = analyze_vars
	data["chosenPillStyle"] = chosen_pill_style
	data["chosenCondiStyle"] = chosen_condi_style
	data["autoCondiStyle"] = CONDIMASTER_STYLE_AUTO
	data["isPillBottleLoaded"] = bottle ? 1 : 0
	if(bottle)
		var/datum/component/storage/STRB = bottle.GetComponent(/datum/component/storage)
		data["pillBottleCurrentAmount"] = bottle.contents.len
		data["pillBottleMaxAmount"] = STRB.max_items

	var/beaker_contents[0]
	if(beaker)
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beaker_contents.Add(list(list("name" = R.DisplayName(), "id" = ckey(R.name), "volume" = R.volume))) // list in a list because Byond merges the first list...
	data["beakerContents"] = beaker_contents

	var/buffer_contents[0]
	if(reagents.total_volume)
		for(var/datum/reagent/N in reagents.reagent_list)
			buffer_contents.Add(list(list("name" = N.DisplayName(), "id" = ckey(N.name), "volume" = N.volume))) // ^
	data["bufferContents"] = buffer_contents

	//Calculated at init time as it never changes
	data["pillStyles"] = pill_styles
	data["condiStyles"] = condi_styles
	return data

/obj/machinery/chem_master/ui_act(action, params)
	. = ..()
	if(.)
		return

	if(action == "eject")
		replace_beaker(usr)
		return TRUE

	if(action == "ejectPillBottle")
		if(!bottle)
			return FALSE
		bottle.forceMove(drop_location())
		adjust_item_drop_location(bottle)
		bottle = null
		return TRUE

	if(action == "transfer")
		var/reagent = GLOB.name2reagent[params["id"]]
		var/amount = text2num(params["amount"])
		var/to_container = params["to"]
		// Custom amount
		if (amount == -1)
			amount = text2num(input(
				"请输入要转移的量：",
				name, ""))
		if (amount == null || amount <= 0)
			return FALSE
		if (to_container == "beaker" && !mode)
			reagents.remove_reagent(reagent, amount)
			return TRUE
		if (!beaker)
			return FALSE
		if (to_container == "buffer")
			beaker.reagents.trans_id_to(src, reagent, amount)
			return TRUE
		if (to_container == "beaker" && mode)
			reagents.trans_id_to(beaker, reagent, amount)
			return TRUE
		return FALSE

	if(action == "toggleMode")
		mode = !mode
		return TRUE

	if(action == "pillStyle")
		var/id = text2num(params["id"])
		chosen_pill_style = id
		return TRUE

	if(action == "condiStyle")
		chosen_condi_style = params["id"]
		return TRUE

	if(action == "create")
		if(reagents.total_volume == 0)
			return FALSE
		var/item_type = params["type"]
		// Get amount of items
		var/amount = text2num(params["amount"])
		if(amount == null)
			amount = text2num(input(usr,
				"最多 10 份，缓冲区内的试剂将均分。",
				"制作几份？", 1))
		amount = clamp(round(amount), 0, 10)
		if (amount <= 0)
			return FALSE
		// Get units per item
		var/vol_each = text2num(params["volume"])
		var/vol_each_text = params["volume"]
		var/vol_each_max = reagents.total_volume / amount
		var/list/style

		if (item_type == "pill")
			vol_each_max = min(50, vol_each_max)
		else if (item_type == "patch")
			vol_each_max = min(40, vol_each_max)
		else if (item_type == "bottle")
			vol_each_max = min(30, vol_each_max)
		else if (item_type == "condimentPack")
			vol_each_max = min(10, vol_each_max)
		else if (item_type == "condimentBottle")
			var/list/styles = get_condi_styles()
			if (chosen_condi_style == CONDIMASTER_STYLE_AUTO || !(chosen_condi_style in styles))
				style = guess_condi_style(reagents)
			else
				style = styles[chosen_condi_style]
			vol_each_max = min(50, vol_each_max)
		else
			return FALSE
		if(vol_each_text == "auto")
			vol_each = vol_each_max
		if(vol_each == null)
			vol_each = text2num(input(usr,
				"每份最多 [vol_each_max] 单位。",
				"每份灌装多少单位？",
				vol_each_max))
		vol_each = clamp(vol_each, 0, vol_each_max)
		if(vol_each <= 0)
			return FALSE
		// Get item name
		var/name = params["name"]
		var/name_has_units = item_type == "pill" || item_type == "patch"
		if(!name)
			var/datum/reagent/main_reagent = reagents.get_master_reagent()
			var/name_default = main_reagent?.DisplayName()
			if (style && style["name"] && !style["generate_name"])
				name_default = style["name"]

			if (name_has_units)
				name_default += "（[vol_each] 单位）"
			name = stripped_input(usr,
				"请输入名称：",
				"命名",
				name_default,
				MAX_NAME_LEN)
		if(!name || !reagents.total_volume || !src || QDELETED(src) || !usr.canUseTopic(src, !issilicon(usr)))
			return FALSE
		// Start filling
		if(item_type == "pill")
			var/obj/item/reagent_containers/pill/P
			var/target_loc = drop_location()
			var/drop_threshold = INFINITY
			if(bottle)
				var/datum/component/storage/STRB = bottle.GetComponent(
					/datum/component/storage)
				if(STRB)
					drop_threshold = STRB.max_items - bottle.contents.len
					target_loc = bottle
			for(var/i = 0; i < amount; i++)
				if(i < drop_threshold)
					P = new/obj/item/reagent_containers/pill(target_loc)
				else
					P = new/obj/item/reagent_containers/pill(drop_location())
				P.name = trim("[name]药片")
				if(chosen_pill_style == RANDOM_PILL_STYLE)
					P.icon_state ="pill[rand(1,21)]"
				else
					P.icon_state = "pill[chosen_pill_style]"
				if(P.icon_state == "pill4")
					P.desc = "一颗红色药丸，留给那些敢于面对知识、自由、未知和残酷真相的人。"
				adjust_item_drop_location(P)
				reagents.trans_to(P, vol_each, transfered_by = usr)
			return TRUE
		if(item_type == "patch")
			var/obj/item/reagent_containers/pill/patch/P
			for(var/i = 0; i < amount; i++)
				P = new/obj/item/reagent_containers/pill/patch(drop_location())
				P.name = trim("[name]贴片")
				adjust_item_drop_location(P)
				reagents.trans_to(P, vol_each, transfered_by = usr)
			return TRUE
		if(item_type == "bottle")
			var/obj/item/reagent_containers/glass/bottle/P
			for(var/i = 0; i < amount; i++)
				P = new/obj/item/reagent_containers/glass/bottle(drop_location())
				P.name = trim("[name]瓶")
				adjust_item_drop_location(P)
				reagents.trans_to(P, vol_each, transfered_by = usr)
			return TRUE
		if(item_type == "condimentPack")
			var/obj/item/reagent_containers/food/condiment/pack/P
			for(var/i = 0; i < amount; i++)
				P = new/obj/item/reagent_containers/food/condiment/pack(drop_location())
				P.originalname = name
				P.name = trim("[name]小包")
				P.desc = "一小包调味料。标签上写着里面装的是[name]。"
				reagents.trans_to(P, vol_each, transfered_by = usr)
			return TRUE
		if(item_type == "condimentBottle")
			var/obj/item/reagent_containers/food/condiment/P
			for(var/i = 0; i < amount; i++)
				P = new/obj/item/reagent_containers/food/condiment(drop_location())
				if (style)
					apply_condi_style(P, style)
				P.renamedByPlayer = TRUE
				P.name = name
				reagents.trans_to(P, vol_each, transfered_by = usr)
			return TRUE
		return FALSE

	if(action == "analyze")
		var/datum/reagent/R = GLOB.name2reagent[params["id"]]
		if(R)
			var/state = "未知"
			if(initial(R.reagent_state) == 1)
				state = "固态"
			else if(initial(R.reagent_state) == 2)
				state = "液态"
			else if(initial(R.reagent_state) == 3)
				state = "气态"
			var/const/P = 3 //The number of seconds between life ticks
			var/T = initial(R.metabolization_rate) * (60 / P)
			analyze_vars = list("name" = ReagentNameForDisplay(initial(R.name)), "state" = state, "color" = initial(R.color), "description" = initial(R.description), "metaRate" = T, "overD" = initial(R.overdose_threshold))
			screen = "analyze"
			return TRUE

	if(action == "goScreen")
		screen = params["screen"]
		return TRUE

	return FALSE

/obj/machinery/chem_master/adjust_item_drop_location(atom/movable/AM) // Special version for chemmasters and condimasters
	if (AM == beaker)
		AM.pixel_x = AM.base_pixel_x - 8
		AM.pixel_y = AM.base_pixel_y + 8
		return null
	else if (AM == bottle)
		if (length(bottle.contents))
			AM.pixel_x = AM.base_pixel_x - 13
		else
			AM.pixel_x = AM.base_pixel_x - 7
		AM.pixel_y = AM.base_pixel_y - 8
		return null
	else
		var/md5 = md5(AM.name)
		for (var/i in 1 to 32)
			. += hex2num(md5[i])
		. = . % 9
		AM.pixel_x = AM.base_pixel_x + ((.%3)*6)
		AM.pixel_y = AM.base_pixel_y - 8 + (round( . / 3)*8)

/**
 * Translates styles data into UI compatible format
 *
 * Expects to receive list of availables condiment styles in its complete format, and transforms them in simplified form with enough data to get UI going.
 * Returns list(list("id" = <key>, "className" = <icon class>, "title" = <name and desc>),..).
 *
 * Arguments:
 * * styles - List of styles for condiment bottles in internal format: [/obj/machinery/chem_master/proc/get_condi_styles]
 */
/obj/machinery/chem_master/proc/strip_condi_styles_to_icons(list/styles)
	var/list/icons = list()
	for (var/s in styles)
		if (styles[s] && styles[s]["class_name"])
			var/list/icon = list()
			var/list/style = styles[s]
			icon["id"] = s
			icon["className"] = style["class_name"]
			icon["title"] = "[style["name"]]\n[style["desc"]]"
			icons += list(icon)

	return icons

/**
 * Defines and provides list of available condiment bottle styles
 *
 * Uses typelist() for styles storage after initialization.
 * For fallback style must provide style with key (const) CONDIMASTER_STYLE_FALLBACK
 * Returns list(
 * 	<key> = list(
 * 		"icon_state" = <bottle icon_state>,
 * 		"name" = <bottle name>,
 * 		"desc" = <bottle desc>,
 * 		?"generate_name" = <if truthy, autogenerates default name from reagents instead of using "name">,
 * 		?"icon_empty" = <icon_state when empty>,
 * 		?"fill_icon_thresholds" = <list of thresholds for reagentfillings, no tresholds if not provided or falsy>,
 * 		?"inhand_icon_state" = <inhand icon_state, falsy - no icon, not provided - whatever is initial (currently "beer")>,
 * 		?"lefthand_file" = <file for inhand icon for left hand, ignored if "inhand_icon_state" not provided>,
 * 		?"righthand_file" = <same as "lefthand_file" but for right hand>,
 * 	),
 * 	..
 * )
 *
 */
/obj/machinery/chem_master/proc/get_condi_styles()
	var/list/styles = typelist("condi_styles")
	if (!styles.len)
		//Possible_states has the reagent type as key and a list of, in order, the icon_state, the name and the desc as values. Was used in the condiment/on_reagent_change(changetype) to change names, descs and sprites.
		styles += list(
			CONDIMASTER_STYLE_FALLBACK = list("icon_state" = "emptycondiment", "icon_empty" = "", "name" = "调味瓶", "desc" = "普通的调味瓶。", "fill_icon_thresholds" = list(0, 10, 25, 50, 75, 100), "generate_name" = TRUE),
			"enzyme" = list("icon_state" = "enzyme", "icon_empty" = "", "name" = "通用酶瓶", "desc" = "烹饪多种菜肴时都能用到。"),
			"flour" = list("icon_state" = "flour", "icon_empty" = "", "name" = "面粉袋", "desc" = "一大袋面粉，烘焙的好材料！"),
			"mayonnaise" = list("icon_state" = "mayonnaise", "icon_empty" = "", "name" = "蛋黄酱罐", "desc" = "用蛋黄制成的油润调味酱。"),
			"milk" = list("icon_state" = "milk", "icon_empty" = "", "name" = "牛奶", "desc" = "洁白又有营养的牛奶！"),
			"blackpepper" = list("icon_state" = "peppermillsmall", "inhand_icon_state" = "", "icon_empty" = "emptyshaker", "name" = "胡椒研磨器", "desc" = "既能给食物调味，也能让人打喷嚏。"),
			"rice" = list("icon_state" = "rice", "icon_empty" = "", "name" = "米袋", "desc" = "一大袋大米，正好下锅！"),
			"sodiumchloride" = list("icon_state" = "saltshakersmall", "icon_empty" = "emptyshaker", "name" = "盐罐", "desc" = "食盐。大概是从死去的船员身上弄来的。"),
			"soymilk" = list("icon_state" = "soymilk", "icon_empty" = "", "name" = "豆奶", "desc" = "洁白又有营养的豆奶！"),
			"soysauce" = list("icon_state" = "soysauce", "icon_empty" = "", "name" = "酱油瓶", "desc" = "用大豆制成的咸味调料。"),
			"sugar" = list("icon_state" = "sugar", "icon_empty" = "", "name" = "糖袋", "desc" = "好吃的太空砂糖！"),
			"ketchup" = list("icon_state" = "ketchup", "icon_empty" = "", "name" = "番茄酱瓶", "desc" = "顿时觉得更有美式风味了。"),
			"capsaicin" = list("icon_state" = "hotsauce", "icon_empty" = "", "name" = "辣酱瓶", "desc" = "辣得仿佛已经尝到了胃溃疡的滋味！"),
			"frostoil" = list("icon_state" = "coldsauce", "icon_empty" = "", "name" = "冷酱瓶", "desc" = "入口便冻得舌头发麻。"),
			"cornoil" = list("icon_state" = "oliveoil", "icon_empty" = "", "name" = "玉米油瓶", "desc" = "用玉米制成的食用油。"),
			"bbqsauce" = list("icon_state" = "bbqsauce", "icon_empty" = "", "name" = "烧烤酱瓶", "desc" = "不附擦手巾。")
		)
		var/list/carton_in_hand = list(
			"inhand_icon_state" = "carton",
			"lefthand_file" = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi',
			"righthand_file" = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
		)
		for (var/style_reagent in list("flour", "milk", "rice", "soymilk", "sugar"))
			if (style_reagent in styles)
				styles[style_reagent] += carton_in_hand
		var/datum/asset/spritesheet/simple/assets = get_asset_datum(/datum/asset/spritesheet/simple/condiments)
		for (var/reagent in styles)
			styles[reagent]["class_name"] = assets.icon_class_name(reagent)
	return styles

/**
 * Provides condiment bottle style based on reagents.
 *
 * Gets style from available by key, using last part of main reagent type (eg. "rice" for /datum/reagent/consumable/rice) as key.
 * If not available returns fallback style, or null if no such thing.
 * Returns list that is one of condibottle styles from [/obj/machinery/chem_master/proc/get_condi_styles]
 */
/obj/machinery/chem_master/proc/guess_condi_style(datum/reagents/reagents)
	var/list/styles = get_condi_styles()
	if (reagents.reagent_list.len > 0)
		var/main_reagent = reagents.get_master_reagent_id()
		if (main_reagent)
			var/list/path = splittext("[main_reagent]", "/")
			main_reagent = path[path.len]
		if(main_reagent in styles)
			return styles[main_reagent]
	return styles[CONDIMASTER_STYLE_FALLBACK]

/**
 * Applies style to condiment bottle.
 *
 * Applies props provided in "style" assuming that "container" is freshly created with no styles applied before.
 * User specified name for bottle applied after this method during bottle creation,
 * so container.name overwritten here for consistency rather than with some purpose in mind.
 *
 * Arguments:
 * * container - condiment bottle that gets style applied to it
 * * style - assoc list, must probably one from [/obj/machinery/chem_master/proc/get_condi_styles]
 */
/obj/machinery/chem_master/proc/apply_condi_style(obj/item/reagent_containers/food/condiment/container, list/style)
	container.name = style["name"]
	container.desc = style["desc"]
	container.icon_state = style["icon_state"]
	container.icon_empty = style["icon_empty"]
	container.fill_icon_thresholds = style["fill_icon_thresholds"]
	if ("inhand_icon_state" in style)
		container.inhand_icon_state = style["inhand_icon_state"]
		if (style["lefthand_file"] || style["righthand_file"])
			container.lefthand_file = style["lefthand_file"]
			container.righthand_file = style["righthand_file"]

/**
 * Machine that allows to identify and separate reagents in fitting container
 * as well as to create new containers with separated reagents in it.
 *
 * All logic related to this is in [/obj/machinery/chem_master] and condimaster specific UI enabled by "condi = TRUE"
 */
/obj/machinery/chem_master/condimaster
	name = "CondiMaster 3000 调味料分装机"
	desc = "用于制作调味料和其他烹饪用品。"
	condi = TRUE
