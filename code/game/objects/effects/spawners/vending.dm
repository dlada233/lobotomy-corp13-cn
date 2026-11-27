/obj/effect/spawner/randomsnackvend
	icon = 'icons/obj/vending.dmi'
	icon_state = "random_snack"
	name = "随机零食售货机生成点"
	desc = "会自动变成一台随机款式的零食售货机。如果上班时还看得到这个生成点，请提交错误报告。"
	///whether it hacks the vendor on spawn currently used only by stinky mapedits
	var/hacked = FALSE

/obj/effect/spawner/randomsnackvend/Initialize(mapload)
	..()

	var/random_vendor = pick(subtypesof(/obj/machinery/vending/snack))
	var/obj/machinery/vending/snack/vend = new random_vendor(loc)
	vend.extended_inventory = hacked

	return INITIALIZE_HINT_QDEL


/obj/effect/spawner/randomcolavend
	icon = 'icons/obj/vending.dmi'
	icon_state = "random_cola"
	name = "随机可乐售货机生成点"
	desc = "会自动变成一台随机款式的可乐售货机。如果上班时还看得到这个生成点，请提交错误报告。"
	///whether it hacks the vendor on spawn currently used only by stinky mapedits
	var/hacked = FALSE

/obj/effect/spawner/randomcolavend/Initialize(mapload)
	..()

	var/random_vendor = pick(subtypesof(/obj/machinery/vending/cola))
	var/obj/machinery/vending/cola/vend = new random_vendor(loc)
	vend.extended_inventory = hacked

	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/weaving_vending
	icon = 'icons/obj/vending.dmi'
	icon_state = "random_cola"
	name = "spawn silk vending machine"
	desc = "Automagically transforms into a silk vending machine if the map is CF"


/obj/effect/spawner/weaving_vending/Initialize(mapload)
	..()

	if (SSmaptype.maptype == "fixers")
		new /obj/machinery/vending/weaving/cheap(loc)

	return INITIALIZE_HINT_QDEL
