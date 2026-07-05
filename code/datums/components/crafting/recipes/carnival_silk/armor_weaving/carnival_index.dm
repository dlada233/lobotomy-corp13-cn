//Index Recipes
/datum/crafting_recipe/index_proselyte
	name = "Index Proselyte - 食指传教士 Armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/index
	reqs = list(
		/obj/item/stack/sheet/silk/violet_simple = 2,
		/obj/item/stack/sheet/silk/indigo_advanced = 1,
		/obj/item/stack/sheet/silk/human_simple = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR

/datum/crafting_recipe/index_proxy
	name = "Index Proxy - 食指代行者 Armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/index_proxy
	reqs = list(
		/obj/item/stack/sheet/silk/violet_simple = 4,
		/obj/item/stack/sheet/silk/indigo_advanced = 2,
		/obj/item/stack/sheet/silk/human_advanced = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR

/datum/crafting_recipe/index_mess
	name = "Index Messenger-食指传令员 Armor"
	result = /obj/item/clothing/suit/armor/ego_gear/city/index_mess
	reqs = list(
		/obj/item/stack/sheet/silk/violet_simple = 8,
		/obj/item/stack/sheet/silk/indigo_advanced = 4,
		/obj/item/stack/sheet/silk/human_elegant = 1
	)
	tools = list(/obj/item/silkknife = 1)
	time = 15
	always_available = FALSE
	category = CAT_SILK
	subcategory = CAT_ARMOR
