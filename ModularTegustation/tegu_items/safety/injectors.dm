/// Instant use injectors/ampoules. Uses modified autoinjector code.

/obj/item/reagent_containers/hypospray/medipen/safety/kcorp
	name = "治疗安瓿"
	icon_state = "ampoule_kcorp"
	desc = "由K公司研发的一种药物，快速回复HP."
	special = "可治愈全身，包括器官在内的大量物理伤害，同时能修复少量烧伤伤害，过量使用将导致轻微毒素损伤."
	list_reagents = list(/datum/reagent/medicine/helapoeisis = 5)

/obj/item/reagent_containers/hypospray/medipen/safety/lcorp
	name = "脑啡肽注射器"
	icon_state = "ampoule_lcorp"
	desc = "L公司生产的一种神奇物质，可作为清洁能源使用，尽管有些人已经发现了它的致幻特性."
	special = "恢复SP理智，过量使用会导致幻觉."
	list_reagents = list(/datum/reagent/medicine/enkephalin = 5)

/obj/item/reagent_containers/hypospray/medipen/safety/rcorp
	name = "肾上腺素注射器"
	icon_state = "ampoule_rcorp"
	desc = "无论是由于库存过剩还是过期，这些由R公司生产的安瓿几乎可以在城市的任何地方找到。"
	special = "唤醒并治疗那些昏迷或处于危重状态的人，还有减缓尸体腐烂的功能."
	list_reagents = list(/datum/reagent/medicine/epinephrine = 10, /datum/reagent/toxin/formaldehyde = 3, /datum/reagent/medicine/coagulant = 2)
