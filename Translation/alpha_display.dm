// Alpha DMM 实例覆写的名称与描述。常规类型的译文在各自的 DM 定义中。
/proc/TranslateAlphaMapFields(atom_type, list/fields)
	var/static/list/names = list(
		/obj/docking_port/stationary = list(
			"Alphacorp emergency evac bay" = "Alpha 设施紧急疏散区",
			"facility floor" = "设施楼层",
		),
		/obj/item/clothing/suit/armor/ego_gear/limbus_labs/chem = list(
			"chemist labcoat" = "化学师白大褂",
		),
		/obj/machinery/button/door = list(
			"Cell One Lock button" = "一号囚室门锁按钮",
			"Cell Three Lock button" = "三号囚室门锁按钮",
			"Cell Two Lock button" = "二号囚室门锁按钮",
		),
		/obj/machinery/button/door/indestructible = list(
			"Extraction Access Shutters" = "研发部入口卷帘门",
		),
		/obj/machinery/computer/shuttle/mining = list(
			"elevator console" = "电梯控制台",
		),
		/obj/machinery/conveyor_switch/oneway = list(
			"disposal conveyor" = "废物输送带",
		),
		/obj/machinery/door/airlock/glass = list(
			"chemistry" = "化学室",
		),
		/obj/machinery/door/airlock/highsecurity = list(
			"Central Command Department" = "中央本部",
			"Control Department" = "控制部",
			"Extraction Office" = "研发部办公室",
			"Information Department" = "情报部",
			"Records Office Secure Area" = "记录部办公室管制区",
			"Records Office" = "记录部办公室",
			"Safety Department" = "安保部",
			"Training Department" = "培训部",
		),
		/obj/machinery/door/airlock/vault = list(
			"Backwards Clock containment zone" = "逆行时钟收容区",
			"Shelter From The 27th Of March containment zone" = "3 月 27 日的防空洞收容区",
			"Wishing Well containment zone" = "许愿井收容区",
		),
		/obj/machinery/door/airlock/wood = list(
			"Manager's Office" = "主管办公室",
		),
		/obj/machinery/door/airlock/wood/glass = list(
			"Manager's Office" = "主管办公室",
		),
		/obj/machinery/door/poddoor = list(
			"Facility Lockdown Blast Door" = "设施封锁防爆门",
		),
		/obj/machinery/door/poddoor/preopen = list(
			"Manager's Office Lockdown Blast Door" = "主管办公室封锁防爆门",
		),
		/obj/machinery/modular_computer/console/preset/research = list(
			"information department console" = "情报部终端",
		),
		/obj/machinery/telecomms/server/presets/engineering = list(
			"Training Server" = "培训部服务器",
		),
		/obj/machinery/telecomms/server/presets/medical = list(
			"Safety Server" = "安保部服务器",
		),
		/obj/machinery/telecomms/server/presets/supply = list(
			"Control Server" = "控制部服务器",
		),
		/obj/structure/showcase/machinery = list(
			"Information Server" = "情报部服务器",
		),
	)
	var/list/type_names = names[atom_type]
	var/translated_name = type_names?[fields["name"]]
	if(translated_name)
		fields["name"] = translated_name
	if(atom_type == /obj/structure/showcase/machinery && fields["desc"] == "A server for the information department. Stores information.")
		fields["desc"] = "情报部用来存储资料的服务器。"
	if(atom_type == /obj/machinery/reagentgrinder && fields["desc"] == "Used to grind things up into raw materials and liquids.")
		fields["desc"] = "用于将物品研磨成原材料和液体。"
