/// Instant use injectors/ampoules. Uses modified autoinjector code.

/obj/item/reagent_containers/hypospray/medipen/safety/kcorp
	name = "治疗安瓿"
	icon_state = "ampoule_kcorp"
	desc = "K 公司研发的药物，可快速恢复生命值。"
	special = "可治疗全身及器官受到的大量物理伤害，也能治疗少量烧伤。过量使用会造成轻微毒素伤害。"
	list_reagents = list(/datum/reagent/medicine/helapoeisis = 5)

/obj/item/reagent_containers/hypospray/medipen/safety/lcorp
	name = "脑啡肽注射器"
	icon_state = "ampoule_lcorp"
	desc = "L 公司生产的一种神奇物质，可用作清洁能源。有人发现它还有致幻作用。"
	special = "恢复理智值，过量使用会导致幻觉。"
	list_reagents = list(/datum/reagent/medicine/enkephalin = 5)

/obj/item/reagent_containers/hypospray/medipen/safety/rcorp
	name = "肾上腺素注射器"
	icon_state = "ampoule_rcorp"
	desc = "无论是由于库存过剩还是过期，这些由R公司生产的安瓿几乎可以在城市的任何地方找到。"
	special = "唤醒并治疗那些昏迷或处于危重状态的人，还有减缓尸体腐烂的功能."
	list_reagents = list(/datum/reagent/medicine/epinephrine = 10, /datum/reagent/toxin/formaldehyde = 3, /datum/reagent/medicine/coagulant = 2)
