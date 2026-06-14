#define CAT_GADGET 1
#define CAT_EQUIP 2
#define CAT_MEDICAL 3
#define CAT_RESOURCE 4
#define CAT_OTHER 5
//CONSOLE CODE uses a altered form of mining_vendor

/obj/machinery/computer/extraction_cargo
	name = "公司交易终端"
	desc = "Used to purchase supplies at the expense of energy."
	icon_screen = "extraction_cargo"
	resistance_flags = INDESTRUCTIBLE
	var/selected_level = CAT_GADGET

	var/list/order_list = list( //if you add something to this, please, for the love of god, sort it by price/type. use tabs and not spaces.
		//Gadgets - More Technical Equipment, Usually active
		new /datum/data/extraction_cargo("追踪植入物套件 ", 		/obj/item/storage/box/minertracker,									150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("命令投影仪 ",			/obj/item/commandprojector,											150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("'DEEPSCAN'套件 ",				/obj/item/deepscanner,												150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("逆卡巴拉抑制场生成器 ",	/obj/item/powered_gadget/slowingtrapmk1,							150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("再生仪扩增器 ",		/obj/item/safety_kit,												150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Drain 检测仪 ",				/obj/item/powered_gadget/detector_gadget/abnormality,				200, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Keen-Sense 测距仪 ",		/obj/item/powered_gadget/detector_gadget/ordeal,					200, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("EMAIS容量扩增 ",		/obj/item/hypo_upgrade/cap_increase,								200, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("原型脑啡肽注射器 ",/obj/item/powered_gadget/enkephalin_injector,						200, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("文职机器人部署器 ",/obj/item/clerkbot_gadget,											250, CAT_GADGET) = 1,
		//new /datum/data/extraction_cargo("C-Fear Protection Injector ",	/obj/item/trait_injector/clerk_fear_immunity_injector,			300, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("手持电击器 ",				/obj/item/powered_gadget/handheld_taser,							300, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("状态投影仪 ",			/obj/item/powered_gadget/vitals_projector,							300, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("虾注射器 ",			/obj/item/trait_injector/shrimp_injector,							300, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("EMAIS自动注射器 ",			/obj/item/reagent_containers/hypospray/emais,						300, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("介子扫描镜 ",		/obj/item/clothing/glasses/meson,									500, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("螺旋介子扫描镜 ",	/obj/item/clothing/glasses/meson/gar,								600, CAT_GADGET) = 1,

		//Equipment - Passive equipment, or less technical stuff.
		new /datum/data/extraction_cargo("'安保' 手电筒 ",		/obj/item/flashlight/seclite,										30, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("猎刀 ",				/obj/item/kitchen/knife/hunting,									30, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("投掷流星锤 ",				/obj/item/restraints/legcuffs/bola,									50, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("EGO小型武装带 ",		/obj/item/storage/belt/ego,											50, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("丁腈手套 ",				/obj/item/clothing/gloves/color/latex/nitrile,						50, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("战术胸挂 ",				/obj/item/storage/belt/military,									60, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("EZ灯光更换器 ",			/obj/item/lightreplacer,											60, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("工具箱 ",					/obj/item/storage/toolbox/mechanical,								60, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("扫帚 ",					/obj/item/pushbroom,												60, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("灭火器 ",			/obj/item/extinguisher,												60, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("便携式灭火器 ",	/obj/item/extinguisher/mini,										100, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("超级电池 ",			/obj/item/stock_parts/cell/super,									150, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("扩音器 ",					/obj/item/megaphone,												150, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("双筒望远镜 ",					/obj/item/binoculars,												200, CAT_EQUIP) = 1,

		//Medical
		new /datum/data/extraction_cargo("肾上腺素注射笔 ",			/obj/item/reagent_containers/hypospray/medipen/safety/rcorp,		40, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("HP安瓿 ",				/obj/item/reagent_containers/hypospray/medipen/safety/kcorp,		50, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("SP安瓿 ",				/obj/item/reagent_containers/hypospray/medipen/safety/lcorp,		50, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("HP绷带 ",				/obj/item/safety_bandage/kcorp,										150, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("SP月长石 ",			/obj/item/safety_bandage/mcorp,										150, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("H公司绷带 ",		/obj/item/safety_bandage/hcorp,										150, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("标准急救包 ",		/obj/item/storage/firstaid/regular,									250, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("裸巢治愈血清 ",		/obj/item/serpentspoison,											400, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("橙子树喷火器 ",			/obj/item/ego_weapon/ranged/flammenwerfer,							500, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("假肢箱 ",		/obj/structure/closet/crate/freezer/surplus_limbs,					500, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("综合医疗笔组合 ",		/obj/item/storage/firstaid/revival,									500, CAT_MEDICAL) = 1,

		//Resources - Raw PE, ETC. Abnochem stuff goes here too. This is one use items to further LC13 systems
		new /datum/data/extraction_cargo("蓝色过滤器 ",				/obj/item/refiner_filter/blue,										5, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("绿色过滤器 ",				/obj/item/refiner_filter/green,										5, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("红色过滤器 ",					/obj/item/refiner_filter/red,										5, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("黄色过滤器 ",					/obj/item/refiner_filter/yellow,									5, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("未精炼PE-Box ",					/obj/item/rawpe,													50, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("化学提取升级 ",/obj/item/work_console_upgrade/chemical_extraction_attachment,		150, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("异想体化学启动包 ",		/obj/structure/closet/crate/science/abnochem_startercrate,			250, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("神秘邀请函 ",		/obj/item/invitation,												1500, CAT_RESOURCE) = 1,

		//Random stuff
		new /datum/data/extraction_cargo("口香糖 ",		/obj/item/storage/box/gum/bubblegum,								15, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("雪茄 ",						/obj/item/clothing/mask/cigarette/cigar/havana,						25, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("啤酒 ",						/obj/item/reagent_containers/food/drinks/beer,						25, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Spraycan ",					/obj/item/toy/crayon/spraycan,										40, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("魔法8号球 ",				/obj/item/toy/eightball,											70, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Six-Pack ",					/obj/item/storage/cans,												70, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("钓鱼装备 ",			/obj/item/storage/box/fishing,										70, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("威士忌 ",					/obj/item/reagent_containers/food/drinks/bottle/whiskey,			100, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("苦艾酒 ",					/obj/item/reagent_containers/food/drinks/bottle/absinthe/premium,	100, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("滑板 ",					/obj/item/melee/skateboard,											100, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("螺旋眼镜 ",				/obj/item/clothing/glasses/sunglasses/gar,							100, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Skub ",						/obj/item/skub,														200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("人体模型 ",					/obj/structure/mannequin,											200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("金鱼钩 ",			/obj/item/fishing_component/hook/shiny,								200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("强化鱼线 ",	/obj/item/fishing_component/line/reinforced,						200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("1000眼 ",					/obj/item/stack/spacecash/c1000,									200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("宠物哨子 ",					/obj/item/pet_whistle,												200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("玛格丽特披萨 ",			/obj/item/food/pizza/margherita,									300, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("超螺旋眼睛 ",			/obj/item/clothing/glasses/sunglasses/gar/supergar,					500, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("员工队长披风 ",		/obj/item/clothing/neck/cloak/hos/agent,							500, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("员工队长帽子 ",		/obj/item/clothing/head/hos/agent,									500, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("玩偶盒 ",				/obj/item/plushgacha,												1000, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Binah玩偶 ",					/obj/item/toy/plush/binah,											1000, CAT_OTHER) = 1,


	)

//Everything below this you should test before finalizing -IP
/datum/data/extraction_cargo
	var/equipment_name = "ERROR"
	var/equipment_path = null
	var/cost = 0
	var/catagory = CAT_OTHER

/datum/data/extraction_cargo/New(name, path, cost, catagory) //This is the weirdest code. Instantly create a datum by defining it in the above list.
	src.equipment_name = name
	src.equipment_path = path
	src.cost = cost
	src.catagory = catagory

/obj/machinery/computer/extraction_cargo/ui_interact(mob/user) //Unsure if this can stand on its own as a structure, later on we may fiddle with that to break out of computer variables. -IP
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat
	dat += "可用 PE: [SSlobotomy_corp.available_box] <br>"
	if(SSlobotomy_corp.box_goal != 0)
		if(SSlobotomy_corp.goal_reached)
			dat += "PE指标已经达成，做得好!<br>"
		else
			dat += "目标进度: [max(SSlobotomy_corp.available_box+SSlobotomy_corp.goal_boxes, 0)]/[SSlobotomy_corp.box_goal] <br>"
	else
		dat += "今日PE指标仍然在分配中，请稍等. <br>"
	for(var/level = CAT_GADGET to CAT_OTHER) //IF YOU ADD A NEW CATAGORY GO FROM FIRST DEFINED CATAGORY TO LAST TO AVOID BREAKAGE  -IP
		dat += "<A href='byond://?src=[REF(src)];set_level=[level]'>[level == selected_level ? "<b><u>[name_catagory(level)]</u></b>" : "[name_catagory(level)]"]</A>"
	dat += "<br>"
	for(var/datum/data/extraction_cargo/A in order_list)
		if(A.catagory != selected_level)
			continue
		dat += " <A href='byond://?src=[REF(src)];purchase=[REF(A)]'>[A.equipment_name]([A.cost] PE)</A><br>"
	var/datum/browser/popup = new(user, "extraction_cargo", "L公司能源交易", 440, 640)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/computer/extraction_cargo/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		usr.set_machine(src)
		add_fingerprint(usr)
		if(href_list["set_level"])
			var/level = text2num(href_list["set_level"])
			if(!(level < CAT_GADGET || level > CAT_OTHER) && level != selected_level)
				selected_level = level
				playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
				updateUsrDialog()
				return TRUE
			return FALSE
		if(href_list["purchase"])
			var/datum/data/extraction_cargo/product_datum = locate(href_list["purchase"]) in order_list //The href_list returns the individual number code and only works if we have it in the first column. -IP
			if(!product_datum)
				to_chat(usr, "<span class='warning'>ERROR.</span>")
				return FALSE
			if(SSlobotomy_corp.available_box < product_datum.cost)
				to_chat(usr, "<span class='warning'>所需PE不足.</span>")
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				return FALSE
			new product_datum.equipment_path(get_turf(src))

			//So we have to adjust the available boxes down but adjust the goal boxes up. Why?
			//Adjusting the available boxes adjusts the goal. This is just the best way to do it
			SSlobotomy_corp.AdjustAvailableBoxes(-1 * product_datum.cost)
			if(!SSlobotomy_corp.goal_reached)	//Okay, funny bug, if you have your goal eached and add goal boxes, then it adds to available boxes.
				SSlobotomy_corp.AdjustGoalBoxes(product_datum.cost)		//Normal
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

/obj/machinery/computer/extraction_cargo/proc/name_catagory(cat) //for each catagory please place the number its defined as -IP
	switch(cat)
		if(1)
			return "小工具"
		if(2)
			return "装备"
		if(3)
			return "医疗"
		if(4)
			return "资源"
		if(5)
			return "杂项"


#undef CAT_GADGET
#undef CAT_EQUIP
#undef CAT_MEDICAL
#undef CAT_RESOURCE
#undef CAT_OTHER
