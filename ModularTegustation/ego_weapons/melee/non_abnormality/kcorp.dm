/obj/item/ego_weapon/city/kcorp
	name = "K公司警棍"
	desc = "K公司员工使用的绿色警棍。"
	icon_state = "kbatong"
	inhand_icon_state = "kbatong"
	force = 11
	damtype = RED_DAMAGE
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")

/obj/item/ego_weapon/city/kcorp/axe
	name = "K公司战斧"
	desc = "K公司员工使用的绿色战斧。"
	icon_state = "kaxe"
	inhand_icon_state = "kaxe"
	force = 17
	attack_speed = 1.7
	attack_verb_continuous = list("bashes", "crushes", "cleaves")
	attack_verb_simple = list("bash", "crush", "cleave")

//High level Kcorp weapons are grade 5
/obj/item/ego_weapon/city/kcorp/spear
	name = "K公司长矛"
	desc = "K公司三级员工使用的绿色长矛。"
	icon_state = "kspear"
	inhand_icon_state = "kspear"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left_64x64.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right_64x64.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 31
	reach = 2
	stuntime = 5
	attack_speed = 1
	damtype = RED_DAMAGE
	hitsound = 'sound/weapons/fixer/generic/kcorp1.ogg'
	attack_verb_continuous = list("whacks", "slashes")
	attack_verb_simple = list("whack", "slash")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/city/kcorp/dspear
	name = "K公司爆破矛"
	desc = "K公司三级员工使用的双头矛。"
	icon_state = "kdualspear"
	inhand_icon_state = "kdualspear"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left_64x64.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right_64x64.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 16
	reach = 2
	attack_speed = 0.6
	stuntime = 5
	damtype = RED_DAMAGE
	hitsound = 'sound/weapons/fixer/generic/kcorp1.ogg'
	attack_verb_continuous = list("whacks", "slashes")
	attack_verb_simple = list("whack", "slash")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

//Slows you to half but has really good defenses. This is Kcorp Bread and butter, because it's really good
/obj/item/ego_weapon/shield/kcorp
	name = "K公司防暴盾"
	desc = "K公司员工使用的防暴盾。"
	special = "Slows down the user significantly."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "kshield"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right.dmi'
	force = 7
	slowdown = 0.7
	damtype = RED_DAMAGE
	attack_verb_continuous = list("shoves", "bashes")
	attack_verb_simple = list("shove", "bash")
	hitsound = 'sound/weapons/genhit2.ogg'
	reductions = list(50, 40, 40, 20) // 150, WAW?
	projectile_block_duration = 5 SECONDS
	block_cooldown = 4 SECONDS
	block_duration = 2 SECONDS
	item_flags = SLOWS_WHILE_IN_HAND
	is_city_gear = TRUE

// Guns below
/obj/item/ego_weapon/ranged/pistol/kcorp
	name = "K公司手枪"
	desc = "K公司使用的青绿色手枪。"
	icon_state = "kpistol"
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	inhand_icon_state = "kpistol"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right.dmi'
	force = 4
	projectile_path = /obj/projectile/ego_bullet/ego_kcorp
	fire_delay = 5
	max_shots = 12
	reloadtime = 0.8 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	fire_sound_volume = 70
	is_city_gear = TRUE

// Guns below
/obj/item/ego_weapon/ranged/pistol/kcorp/smg
	name = "K公司冲锋手枪"
	desc = "K公司使用的青绿色冲锋手枪。"
	icon_state = "ksmg"
	inhand_icon_state = "ksmg"
	force = 8
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'
	autofire = 0.08 SECONDS
	fire_delay = 1
	max_shots = 40
	reloadtime = 1.2 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)


/obj/item/ego_weapon/ranged/pistol/kcorp/nade
	name = "K公司榴弹发射器"
	desc = "K公司使用的短管榴弹发射器。"
	icon_state = "kgrenade"
	inhand_icon_state = "kgrenade"
	force = 8
	projectile_path = /obj/projectile/ego_bullet/ego_knade
	fire_delay = 7
	max_shots = 6
	reloadtime = 1.8 SECONDS
	fire_sound = 'sound/weapons/gun/general/grenade_launch.ogg'
	fire_sound_volume = 70
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
