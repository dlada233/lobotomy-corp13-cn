//Egoshards - used to upgrade the armor and weapons in the lcorp files.
/obj/item/egoshard
	name = "裂开的红色EGO碎片"
	desc = "一个状态堪忧但仍然可用的EGO碎片."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "egoshard_r"
	var/stat_requirement = 40 //Stat requirements should match the E.G.O. tier
	//Weapon stats
	var/damage_type = RED_DAMAGE
	var/base_damage = 14 //Base damage of the tier
	var/tier = 1 //used to figure out gun damage
	//Armor stats
	var/red_bonus = 20 //40 from the base of 20 in red, so 60
	var/white_bonus = 10
	var/black_bonus = 0
	var/pale_bonus = 10

/obj/item/egoshard/examine(mob/user)
	. = ..()
	if(stat_requirement)
		. += span_warning("用该EGO碎片强化后的武器在使用时全部属性均需要达到[stat_requirement].")
	switch(damage_type)
		if(RED_DAMAGE)
			. += span_notice("这一块看起来是红色.")
		if(WHITE_DAMAGE)
			. += span_notice("这一块看起来是白色.")
		if(BLACK_DAMAGE)
			. += span_notice("这一块看起来是黑色.")
		if(PALE_DAMAGE)
			. += span_notice("这一块看起来是青色.")


/obj/item/egoshard/white
	name = "裂开的白色EGO碎片"
	icon_state = "egoshard_w"
	damage_type = WHITE_DAMAGE
	red_bonus = -10
	white_bonus = 40
	black_bonus = 10
	pale_bonus = 0

/obj/item/egoshard/black
	name = "裂开的黑色EGO碎片"
	icon_state = "egoshard_b"
	damage_type = BLACK_DAMAGE
	red_bonus = -20
	white_bonus = 10
	black_bonus = 40
	pale_bonus = 10

/obj/item/egoshard/bad
	name = "碎裂的红色EGO碎片"
	desc = "A smallEGO碎片."
	tier = 2
	base_damage = 18
	stat_requirement = 60
	red_bonus = 30 //80 from the base of 20 in red, so 100
	white_bonus = 20
	black_bonus = 10
	pale_bonus = 20
	custom_price = 750

/obj/item/egoshard/bad/white
	name = "碎裂的白色EGO碎片"
	icon_state = "egoshard_w"
	damage_type = WHITE_DAMAGE
	red_bonus = 0 //80 from the base of 20 in red, so 100
	white_bonus = 50
	black_bonus = 20
	pale_bonus = 10
	custom_price = 750

/obj/item/egoshard/bad/black
	name = "碎裂的黑色EGO碎片"
	icon_state = "egoshard_b"
	damage_type = BLACK_DAMAGE
	red_bonus = -10 //80 from the base of 20 in red, so 100
	white_bonus = 20
	black_bonus = 50
	pale_bonus = 20
	custom_price = 750

/obj/item/egoshard/good
	name = "红色EGO碎片"
	desc = "A decently sizedEGO碎片."
	tier = 3
	base_damage = 25
	stat_requirement = 80
	red_bonus = 40 //140 from the base of 20 in red, so 160
	white_bonus = 30
	black_bonus = 30
	pale_bonus = 40
	custom_price = 2000

/obj/item/egoshard/good/white
	name = "白色EGO碎片"
	icon_state = "egoshard_w"
	damage_type = WHITE_DAMAGE
	red_bonus = 10 //140 from the base of 20 in red, so 160
	white_bonus = 60
	black_bonus = 40
	pale_bonus = 30
	custom_price = 2000

/obj/item/egoshard/good/black
	name = "黑色EGO碎片"
	icon_state = "egoshard_b"
	damage_type = BLACK_DAMAGE
	red_bonus = 10 //140 from the base of 20 in red, so 160
	white_bonus = 40
	black_bonus = 60
	pale_bonus = 30
	custom_price = 2000

/obj/item/egoshard/good/pale
	name = "青色EGO碎片"
	icon_state = "egoshard_p"
	damage_type = PALE_DAMAGE
	base_damage = 20
	red_bonus = 20 //140 from the base of 20 in red, so 160
	white_bonus = 30
	black_bonus = 30
	pale_bonus = 60
	custom_price = 2000

/obj/item/egoshard/great
	name = "无暇的红色EGO碎片"
	desc = "A prettyEGO碎片."
	tier = 4
	base_damage = 35
	stat_requirement = 100
	red_bonus = 60 //200 from the base of 20 in red, so 220
	white_bonus = 50
	black_bonus = 40
	pale_bonus = 50
	custom_price = 4000

/obj/item/egoshard/great/white
	name = "无暇的白色EGO碎片"
	icon_state = "egoshard_w"
	damage_type = WHITE_DAMAGE
	red_bonus = 30 //200 from the base of 20 in red, so 220
	white_bonus = 80
	black_bonus = 50
	pale_bonus = 40
	custom_price = 4000

/obj/item/egoshard/great/black
	name = "无暇的黑色EGO碎片"
	icon_state = "egoshard_b"
	damage_type = BLACK_DAMAGE
	red_bonus = 20 //200 from the base of 20 in red, so 220
	white_bonus = 50
	black_bonus = 80
	pale_bonus = 50
	custom_price = 4000

/obj/item/egoshard/great/pale
	name = "无暇的青色EGO碎片"
	icon_state = "egoshard_p"
	damage_type = PALE_DAMAGE
	base_damage = 30
	red_bonus = 30 //200 from the base of 20 in red, so 220
	white_bonus = 40
	black_bonus = 30
	pale_bonus = 70
	custom_price = 4000

//These exist, but I'm not sure where I would put ALEPH++ tierEGO碎片s in terms of loot
/obj/item/egoshard/excellent
	name = "完美的红色EGO碎片"
	desc = "An expensive-lookingEGO碎片."
	tier = 5
	base_damage = 50
	stat_requirement = 120
	red_bonus = 60 //280 from the base of 20 in red, so 300
	white_bonus = 70
	black_bonus = 70
	pale_bonus = 80

/obj/item/egoshard/excellent/white
	name = "完美的白色EGO碎片"
	icon_state = "egoshard_w"
	damage_type = WHITE_DAMAGE
	red_bonus = 50 //280 from the base of 20 in red, so 300
	white_bonus = 80
	black_bonus = 70
	pale_bonus = 80

/obj/item/egoshard/excellent/black
	name = "完美的黑色EGO碎片"
	icon_state = "egoshard_b"
	damage_type = BLACK_DAMAGE
	red_bonus = 60 //280 from the base of 20 in red, so 300
	white_bonus = 70
	black_bonus = 80
	pale_bonus = 70

/obj/item/egoshard/excellent/pale
	name = "完美的青色EGO碎片"
	icon_state = "egoshard_p"
	damage_type = PALE_DAMAGE
	base_damage = 40
	red_bonus = 50 //280 from the base of 20 in red, so 300
	white_bonus = 80
	black_bonus = 70
	pale_bonus = 80
