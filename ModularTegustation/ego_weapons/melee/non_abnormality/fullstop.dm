//Guns that gotta be reloaded.
/obj/item/ego_weapon/ranged/city/fullstop
	name = "fullstop template"
	desc = "a template for fullstop."
	icon_state = "fullstop"
	inhand_icon_state = "fullstop"
	force = 7
	projectile_path = /obj/projectile/ego_bullet/fivedamage	//Does 10 damage
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	special = "Use in hand to reload"
	max_shots = 10
	reloadtime = 2 SECONDS

//The actual weapons
/obj/item/ego_weapon/ranged/city/fullstop/assault
	name = "句点突击步枪"
	desc = "一把重型步枪，在都市里，这种枪的价格很贵，而购买子弹的费用，完全足够你买下另一件优质武器."
	icon_state = "fullstop"
	inhand_icon_state = "fullstop"
	force = 10
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	max_shots = 30
	autofire = 0.12 SECONDS
	spread = 10
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/city/fullstop/pistol
	name = "句点手枪"
	desc = "一把句点手枪，看起来很熟悉。"
	icon_state = "fullstoppistol"
	inhand_icon_state = "fullstopsniper"
	force = 6
	attack_speed = 0.5
	max_shots = 17
	fire_delay = 5
	reloadtime = 1.3 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/city/fullstop/sniper
	name = "句点狙击枪"
	desc = "一把狙击步枪，尽管价格昂贵且受到严格管制，你仍然可以利用它从较远的距离隐蔽地击杀目标."
	icon_state = "fullstopsniper"
	inhand_icon_state = "fullstopsniper"
	force = 10
	fire_sound = 'sound/weapons/gun/sniper/shot.ogg'
	zoom_amt = 10 //Long range, enough to see in front of you, but no tiles behind you.
	zoomable = TRUE
	zoom_out_amt = 5
	projectile_damage_multiplier = 4
	max_shots = 5
	fire_delay = 30
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/city/fullstop/deagle
	name = "句点马格南"
	desc = "一把昂贵的手枪，保持手部稳定，游戏还未结束."
	icon_state = "fullstopdeagle"
	inhand_icon_state = "fullstopdeagle"
	force = 8
	attack_speed = 0.5
	weapon_weight = WEAPON_LIGHT
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	projectile_damage_multiplier = 4
	max_shots = 9
	reloadtime = 1 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
