//Like this so we can add a charge mechanic to one of them and have it carry down.
/obj/item/ego_weapon/city/wcorp
	name = "W-公司警棍"
	desc = "W-公司员工所使用的蓝色发光警棍."
	icon_state = "wbatong"
	inhand_icon_state = "wbatong"
	force = 9
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")

	charge = TRUE
	charge_cost = 2
	charge_effect = "造成额外一次攻击伤害."
	successfull_activation = "你释放了你的充能，对对手造成伤害!"

/obj/item/ego_weapon/city/wcorp/ChargeAttack(mob/living/target, mob/living/user)
	. = ..()
	target.apply_damage(force, damtype, null, target.run_armor_check(null, damtype), spread_damage = TRUE)

//Non-baton Wcorp is Grade 5
/obj/item/ego_weapon/city/wcorp/fist
	name = "W-公司拳套"
	desc = "W-公司高级员工使用的蓝色发光拳套."
	icon_state = "wcorp_fist"
	inhand_icon_state = "wcorp_fist"
	force = 20
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)

	charge_cost = 3
	charge_effect = "将对手打倒在地."
	successfull_activation = "你释放了你的充能，用尽全力撞击你的对手!"

/obj/item/ego_weapon/city/wcorp/fist/ChargeAttack(mob/living/target, mob/living/user)
	. = ..()
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(2, 5), whack_speed, user)

/obj/item/ego_weapon/city/wcorp/axe
	name = "W-公司战斧"
	desc = "W-公司高级员工使用的蓝色发光战斧."
	icon_state = "wcorp_axe"
	inhand_icon_state = "wcorp_axe"
	force = 33
	attack_speed = 2
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleave", "cut")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

	charge_cost = 4
	charge_effect = "造成3倍伤害，但减缓你下一次的攻击."
	successfull_activation = "你释放了你的充能，试图处决你的对手!"
	swingstyle = WEAPONSWING_LARGESWEEP

/obj/item/ego_weapon/city/wcorp/axe/ChargeAttack(mob/living/target, mob/living/user)
	. = ..()
	sleep(0.5 SECONDS)
	target.apply_damage(force*3, damtype, null, target.run_armor_check(null, damtype), spread_damage = TRUE)
	user.changeNext_move(CLICK_CD_MELEE * 6)

/obj/item/ego_weapon/city/wcorp/spear
	name = "W-公司长矛"
	desc = "W-公司高级员工使用的蓝色发光长矛."
	icon_state = "wcorp_spear"
	inhand_icon_state = "wcorp_spear"
	force = 30
	reach = 2
	attack_speed = 1
	stuntime = 5
	attack_verb_continuous = list("slashes", "pokes")
	attack_verb_simple = list("slash", "poke")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

	charge_cost = 3
	charge_effect = "造成范围伤害."
	successfull_activation = "你释放了你的充能，导致大范围伤害!"

/obj/item/ego_weapon/city/wcorp/spear/ChargeAttack(mob/living/target, mob/living/user)
	. = ..()
	sleep(0.2 SECONDS)
	for(var/mob/living/L in range(1, src))
		var/aoe = 25
		var/justicemod = get_attack_multiplier(user)
		aoe*=justicemod
		if(L == user || ishuman(L))
			continue
		L.apply_damage(force, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))

	user.changeNext_move(CLICK_CD_MELEE * 3)

/obj/item/ego_weapon/city/wcorp/dagger
	name = "W-公司匕首"
	desc = "W-公司高级员工使用的蓝色发光匕首."
	icon_state = "wcorp_dagger"
	inhand_icon_state = "wcorp_dagger"
	force = 11
	attack_speed = 0.5

	attack_verb_continuous = list("slices", "stabs")
	attack_verb_simple = list("slice", "stab")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60
							)
	swingstyle = WEAPONSWING_LARGESWEEP

	charge_cost = 8
	charge_effect = "撕裂空间本身!"
	successfull_activation = "你释放了你的充能，引发了一连串的打击!"

/obj/item/ego_weapon/city/wcorp/dagger/ChargeAttack(mob/living/target, mob/living/user)
	. = ..()
	sleep(0.2 SECONDS)
	for(var/i = 1 to 3)
		sleep(0.2 SECONDS)
		target.apply_damage(force, damtype, null, target.run_armor_check(null, damtype), spread_damage = TRUE)
		playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)
		var/turf/T = get_turf(target)
		new /obj/effect/temp_visual/justitia_effect(T)

//Modified W-Corp weapons are above Grade 5, usually stopping at the higher end of Grade 3.
//Alongside the burst damage, they usually include a minor side-effect. Custom-made by ValerieSteel!

//Kirie Note: don't really want to you know, add a very rare part to the Wcorp banner, so I'm gonna keep these at Grade 5.
/obj/item/ego_weapon/city/wcorp/hatchet
	name = "W-公司单手斧"
	desc = "W-公司高级员工使用的蓝色发光战斧. 这把经过了一些后期改装."
	special = "这把武器可以放进EGO腰带里."
	icon_state = "wcorp_hatchet"
	inhand_icon_state = "wcorp_hatchet"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left_64x64.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right_64x64.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 17	//Slowing is massive.
	attack_speed = 1
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_verb_continuous = list("cleaves", "slashes", "carves")
	attack_verb_simple = list("cleave", "slash", "carve")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60
							)

	charge_cost = 5
	charge_effect = "造成致残打击，减缓你的目标."
	successfull_activation = "你释放了你的充能，试图致残你的敌人!"

/obj/item/ego_weapon/city/wcorp/hatchet/ChargeAttack(mob/living/target, mob/living/user)
	. = ..()
	sleep(0.2 SECONDS)
	target.apply_damage(force*2, damtype, null, target.run_armor_check(null, damtype), spread_damage = TRUE)
	target.apply_status_effect(/datum/status_effect/qliphothoverload)

/obj/item/ego_weapon/city/wcorp/hammer
	name = "W-公司战锤"
	desc = "W-公司高级员工使用的蓝色发光战锤. 这把经过了一些后期改装."
	icon_state = "wcorp_hammer"
	inhand_icon_state = "wcorp_hammer"
	force = 40
	attack_speed = 2
	attack_verb_continuous = list("smashes", "crushes", "shatters")
	attack_verb_simple = list("smash", "crush", "shatter")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60
							)

	charge_cost = 8
	charge_effect = "短时间内增加目标受到的黑色伤害."
	successfull_activation = "你释放了你的充能，粉碎了你的敌人的意志!"

/obj/item/ego_weapon/city/wcorp/hammer/ChargeAttack(mob/living/target, mob/living/user)
	. = ..()
	sleep(0.5 SECONDS)
	target.apply_damage(force*2, damtype, null, target.run_armor_check(null, damtype), spread_damage = TRUE)
	target.apply_status_effect(/datum/status_effect/display/rend/black/w_corp)
	playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)
	new /obj/effect/temp_visual/justitia_effect(get_turf(target))

/datum/status_effect/display/rend/black/w_corp // Duplicate of "rend_black", giving it a unique id so it can stack.
	id = "w-corp rend black armor"

//Type C weapons

/datum/status_effect/interventionshield/wcorp
	vis_shield = icon('ModularTegustation/Teguicons/tegu_effects.dmi', "wcorp_shield")
	damtype = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)

/obj/item/ego_weapon/city/wcorp/shield
	name = "W-公司Type-C护盾刀"
	desc = "W-公司使用的蓝色发光刀刃，用于投射护盾。发光的末端很危险，可以切穿任何东西"
	icon_state = "wcorp_sword"
	inhand_icon_state = "wcorp_sword"
	force = 17 //Meant originally as a support device, used as a mace in a pinch.
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleave", "cut")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60
							)

	charge_cost = 16
	charge_effect = "在攻击中向周围盟友投射护盾."
	successfull_activation = "你释放了你的充能，向你的盟友投射护盾!"
	var/shield_time = 15 SECONDS

/obj/item/ego_weapon/city/wcorp/shield/ChargeAttack(mob/living/target, mob/living/user)
	. = ..()
	sleep(0.2 SECONDS)
	for(var/mob/living/carbon/human/L in range(7, user))
		if(!ishuman(L))
			continue
		L.apply_shield(/datum/status_effect/interventionshield/wcorp, shield_duration = shield_time)
		new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))

//Type C Spear
/obj/item/ego_weapon/city/wcorp/shield/spear
	name = "W-公司Type-C护盾长矛"
	desc = "W-公司使用的蓝色发光长矛，用于投射护盾."
	icon_state = "wcorp_glaive"
	inhand_icon_state = "wcorp_glaive"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left_64x64.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right_64x64.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 25
	reach = 2
	stuntime = 5

//Type C club
/obj/item/ego_weapon/city/wcorp/shield/club
	name = "W-公司Type-C护盾棍"
	desc = "W-公司使用的蓝色发光棍棒，用于投射护盾."
	icon_state = "wcorp_club"
	inhand_icon_state = "wcorp_club"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left_64x64.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right_64x64.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	attack_speed = 1.5

/obj/item/ego_weapon/city/wcorp/shield/club/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

//Type C axe
/obj/item/ego_weapon/city/wcorp/shield/axe
	name = "W-公司Type-C护盾斧"
	desc = "W-公司使用的蓝色发光战斧，用于投射护盾."
	icon_state = "wcorp_battleaxe"
	inhand_icon_state = "wcorp_battleaxe"
	force = 22
	attack_speed = 1.5
