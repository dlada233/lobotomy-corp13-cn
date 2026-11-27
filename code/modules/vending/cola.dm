
/obj/machinery/vending/cola
	name = "\improper “吸一口能量”饮料机"
	desc = "S 公司供应的软饮料和能量饮料售货机。"
	icon_state = "Cola_Machine"
	product_slogans = "SUCK IT!"
	product_ads = "Refreshing!;Hope you're thirsty!;Over 1 million drinks sold!;Please, have a drink!;Drink up!"
	products = list(/obj/item/reagent_containers/food/drinks/soda_cans/monkey_energy = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/grey_bull = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/shamblers = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/cola = 10,
		            /obj/item/reagent_containers/food/drinks/soda_cans/outskirts_wind = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/dr_gibb = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/starkist = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/space_up = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pwr_game = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/lemon_lime = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/sol_dry = 10,
					/obj/item/reagent_containers/food/drinks/waterbottle = 10)
	refill_canister = /obj/item/vending_refill/cola
	default_price = PAYCHECK_ASSISTANT * 0.5
	extra_price = PAYCHECK_MEDIUM
	payment_department = ACCOUNT_SRV
	light_color = COLOR_MOSTLY_PURE_PINK


/obj/item/vending_refill/cola
	machine_name = "Robust Softdrinks"
	icon_state = "refill_cola"
	light_color = COLOR_WHITE

/obj/machinery/vending/cola/blue
	icon_state = "Cola_Machine"
	light_mask = "cola-light-mask"
	light_color = COLOR_MODERATE_BLUE

/obj/machinery/vending/cola/black
	icon_state = "cola_black"
	light_mask = "cola-light-mask"
	light_color = COLOR_WHITE

/obj/machinery/vending/cola/red
	icon_state = "red_cola"
	name = "\improper 都市可乐售货机"
	desc = "它出售可乐，却从来没人见过有谁给它补货。"
	product_slogans = "Your favorite by default!"
	light_mask = "red_cola-light-mask"
	light_color = COLOR_DARK_RED

/obj/machinery/vending/cola/space_up
	icon_state = "space_up"
	name = "\improper Super-up! 饮料机"
	desc = "想提提神，胃又受不了咖啡？来这儿。"
	product_slogans = "Super-up! Marginally better than our competition!"
	light_mask = "space_up-light-mask"
	light_color = COLOR_DARK_MODERATE_LIME_GREEN

/obj/machinery/vending/cola/starkist
	icon_state = "starkist"
	name = "\improper Star-kist 饮料机"
	desc = "把星辰的滋味装进饮料里。"
	product_slogans = "Drink the stars! Star-kist!"
	light_mask = "starkist-light-mask"
	light_color = COLOR_LIGHT_ORANGE

/obj/machinery/vending/cola/sodie
	icon_state = "soda"
	light_mask = "soda-light-mask"
	light_color = COLOR_WHITE

/obj/machinery/vending/cola/pwr_game
	icon_state = "pwr_game"
	name = "\improper Pwr Game 饮料机"
	desc = "你想要的，我们都有。与弗拉德沙拉店联合推出。"
	product_slogans = "The POWER that gamers crave! PWR GAME!"
	light_mask = "pwr_game-light-mask"
	light_color = COLOR_STRONG_VIOLET

/obj/machinery/vending/cola/shamblers
	name = "\improper Shambler 饮料售货机"
	desc = "～给我摇一杯 Shambler 果汁！～"
	icon_state = "shamblers_juice"
	products = list(/obj/item/reagent_containers/food/drinks/soda_cans/cola = 10,
		            /obj/item/reagent_containers/food/drinks/soda_cans/outskirts_wind = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/dr_gibb = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/starkist = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/space_up = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pwr_game = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/lemon_lime = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/sol_dry = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/shamblers = 10)
	product_slogans = "~Shake me up some of that Shambler's Juice!~"
	product_ads = "Refreshing!;Jyrbv dv lg jfdv fw kyrk Jyrdscvi'j Alztv!;Over 1 trillion souls drank!;Thirsty? Nyp efk uizeb kyv uribevjj?;Kyv Jyrdscvi uizebj kyv ezxyk!;Drink up!;Krjkp."
	light_mask = "shamblers-light-mask"
	light_color = COLOR_MOSTLY_PURE_PINK
