GLOBAL_LIST_EMPTY(cached_abno_work_rates)
GLOBAL_LIST_EMPTY(cached_abno_resistances)

/*
All descriptions of damage/resistances are in _HELPERS/abnormalities.dm

For escape damage you will have to get creative and figure out how dangerous it is
*/

/obj/item/paper/fluff/info
	show_written_words = FALSE
	slot_flags = null // No books on head, sorry
	/// Will not show up in Lobotomy Corp Archive Computer if true
	var/no_archive = FALSE
	var/mob/living/simple_animal/hostile/abnormality/abno_type = null
	var/abno_code = null
	/// List of random info about abnormality
	var/list/abno_info = list()
	// If null and has an abno_type, will append the end of the content with auto-generated info
	var/abno_work_damage_type = null
	var/abno_work_damage_count = null
	/// Associative list; Work type = Rate(text). If text is null - will generate its own.
	var/list/abno_work_rates = list(
		ABNORMALITY_WORK_INSTINCT = null,
		ABNORMALITY_WORK_INSIGHT = null,
		ABNORMALITY_WORK_ATTACHMENT = null,
		ABNORMALITY_WORK_REPRESSION = null)
	/// If FALSE - will not add breach info part to the paper; When null, will set itself depending on abno's var
	var/abno_can_breach = null
	var/abno_breach_damage_type = null
	var/abno_breach_damage_count = null
	/// Associative list similar to the above: Type = text; If text is null - generate it.
	var/list/abno_resistances = list(
		RED_DAMAGE = null,
		WHITE_DAMAGE = null,
		BLACK_DAMAGE = null,
		PALE_DAMAGE = null)

/obj/item/paper/fluff/info/Initialize()
	. = ..()
	if(info) // Someone wanted to fill it in manually, let's not touch it
		return
	if(!ispath(abno_type))
		return

	// Yes, we have to create the mob, it is that sad
	var/mob/living/simple_animal/hostile/abnormality/abno
	if(!(abno_type in GLOB.cached_abno_work_rates) || !(abno_type in GLOB.cached_abno_resistances))
		abno = new abno_type(src)
		abno.core_enabled = FALSE
		QDEL_NULL(abno)

	if(isnull(abno_can_breach))
		abno_can_breach = initial(abno_type.can_breach)

	// Code/Name/Title
	name = initial(abno_type.name)
	if(isnull(abno_code))
		abno_code = initial(abno_type.name)
	else
		name += " - [abno_code]" // For RO enthusiasts
	info += "<h1><center>[abno_code]</center></h1><br>"

	// Basic information
	info += "名称: [initial(abno_type.name)]<br>\
			风险等级: [THREAT_TO_NAME[initial(abno_type.threat_level)]]<br>\
			最大PE-Box产量: [isnull(initial(abno_type.max_boxes)) ? initial(abno_type.threat_level) * 6 : initial(abno_type.max_boxes)]<br>\
			逆卡巴拉计数器: [initial(abno_type.start_qliphoth)]<br>"

	// Work damage
	var/initial_work_damage_type = initial(abno_type.work_damage_type)
	if(isnull(abno_work_damage_type))
		abno_work_damage_type = uppertext(initial_work_damage_type)
	if(GLOB.damage_type_shuffler?.is_enabled && IsColorDamageType(initial_work_damage_type))
		abno_work_damage_type = uppertext(GLOB.damage_type_shuffler.mapping_offense[initial_work_damage_type])
	// We need to get the average work damage, and it only accepts whole numbers. So we get the average and round.
	if(isnull(abno_work_damage_count))
		var/avgworkdamage = round((initial(abno_type.work_damage_upper) + initial(abno_type.work_damage_lower)) * 0.5)
		abno_work_damage_count = SimpleWorkDamageToText(avgworkdamage)
	info += "工作伤害类型: [abno_work_damage_type]<br>"
	info += "工作伤害等级: [abno_work_damage_count]<br><br>"

	// All minor info
	for(var/line in abno_info)
		info += "- [line]<br>"
	if(LAZYLEN(abno_info))
		info += "<br>"

	// Work chances
	info += "<h3><center>工作成功率</center></h3><br>"
	for(var/line in abno_work_rates)
		var/rate = abno_work_rates[line]
		if(!rate)
			var/num_rate = GLOB.cached_abno_work_rates[abno_type][line]
			if(islist(num_rate))
				num_rate = num_rate[initial(abno_type.threat_level)] // This is quite silly
			rate = SimpleSuccessRateToText(num_rate)
		info += "<h4>[line]:</h4> [rate]<br>"
	info += "<br>"

	// Breach info
	if(!abno_can_breach)
		return

	info += "<h3><center>收容突破信息</center></h3><br>"
	if(isnull(abno_breach_damage_type))
		var/damage_type = initial(abno_type.melee_damage_type)
		if(GLOB.damage_type_shuffler?.is_enabled && IsColorDamageType(damage_type))
			damage_type = GLOB.damage_type_shuffler.mapping_offense[damage_type]
		abno_breach_damage_type = uppertext(damage_type)
	if(isnull(abno_breach_damage_count))
		abno_breach_damage_count = SimpleDamageToText(initial(abno_type.melee_damage_upper) * initial(abno_type.rapid_melee))
	info += "<h4>出逃伤害类型:</h4> [abno_breach_damage_type]<br>"
	info += "<h4>出逃伤害等级:</h4> [abno_breach_damage_count]<br>"

	// Resistances
	for(var/line in abno_resistances)
		var/damage_type = line
		if(GLOB.damage_type_shuffler?.is_enabled && IsColorDamageType(line))
			damage_type = GLOB.damage_type_shuffler.mapping_defense[line]
		var/resist = abno_resistances[damage_type]
		if(!resist)
			resist = SimpleResistanceToText(GLOB.cached_abno_resistances[abno_type][damage_type])
		info += "<h4>[capitalize(line)] 抗性:</h4> [resist]<br>"

/obj/item/paper/fluff/info/AltClick(mob/living/user, obj/item/I)
	return

/obj/item/paper/fluff/info/attackby(obj/item/P, mob/living/user, params)
	ui_interact(user)	// only reading, sorry

/obj/item/paper/fluff/info/zayin
	icon_state = "zayin"

/obj/item/paper/fluff/info/teth
	icon_state = "teth"

/obj/item/paper/fluff/info/he
	icon_state = "he"

/obj/item/paper/fluff/info/waw
	icon_state = "waw"

/obj/item/paper/fluff/info/aleph
	icon_state = "aleph"

/obj/item/paper/fluff/info/tool/archive_guide
	name = "档案指南"
	info = {"<h1><center>档案指南</center></h1>	<br>
	欢迎来到脑叶公司数字档案馆！<br>
	为了高效地查阅档案，请先了解异想体分类代码的实际含义。<br>
	异想体分类代码的第一个字母代表其系列或类别。<br>
	F 类：具有虚构故事或都市传说特征的异想体。<br>
	T 类：由创伤经历形成或体现某种特定恐惧症的异想体。<br>
	O 类：既不属于创伤也不属于童话故事的异想体。<br>
	D 和 C 类：被标记为对我们达成总目标非必要的异想体。<br>
	M 类：具有旧世界神话特征的异想体。<br>
	-<br>
	分类代码的第二个字母代表其物理形态，如果你见过该异想体会更容易理解。<br>
	01 为人形，<br>
	02 为动物，<br>
	03 为异界生物，<br>
	04 为无生命物体，<br>
	05 为机械或无机体生物，<br>
	06 为抽象实体或多种实体的聚合体，<br>
	07 为惰性状态下是可使用的物品，但可以变形（当前用于 O-O7-103），<br>
	08 当前未使用，<br>
	09 为需要互动才能表现效果的装置。<br>
	- <br>
	代码中最后的数字为每个异想体的唯一编号。<br>
	脑叶公司祝愿您不辜负期望地完成工作。<br>"}
