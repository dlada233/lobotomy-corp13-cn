//All the goober rifles used by Rcorp Assault troops

/obj/item/gun/energy/e_gun/rabbitdash
	name = "R公司 R-2000 '红色步枪'"
	desc = "R公司为基层部队量产的能量武器。"
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "rabbitk"
	inhand_icon_state = "rabbit"
	fire_delay = 5
	cell_type = /obj/item/stock_parts/cell/infinite
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red,
	)
	can_charge = FALSE
	weapon_weight = WEAPON_HEAVY // No dual wielding
	pin = /obj/item/firing_pin
	//None of these fucking guys can use Rcorp guns
	var/list/banned_roles = list("Reindeer Squad Captain",
		"R-Corp Berserker Reindeer","R-Corp Medical Reindeer","R-Corp Gunner Rhino","R-Corp Hammer Rhino","R-Corp Scout Raven","R-Corp Support Raven",,
		"R-Corp Roadrunner", "Roadrunner Squad Leader")

/obj/item/gun/energy/e_gun/rabbitdash/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	if(user.mind)
		if(user.mind.assigned_role in banned_roles)
			to_chat(user, span_notice("你未接受过R公司枪械训练！"))
			return FALSE
		if(user.mind.has_antag_datum(/datum/antagonist/wizard/arbiter/rcorp))
			to_chat(user, span_notice("你还不屑使用下级部队的武器.")) //You are a arbiter not a super crazed gunman
			return FALSE
	..()

/obj/item/gun/energy/e_gun/rabbitdash/white
	name = "R公司 R-2100 '白色步枪'"
	desc = "R公司为基层部队量产的升级型号，仅能发射白色子弹。"
	icon_state = "rabbitk"
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/white,
		)

/obj/item/gun/energy/e_gun/rabbitdash/small
	name = "R公司 R-2200 '小铁炮'"
	desc = "R公司偶尔使用的手枪型号，射速较慢且伤害略低。"
	icon_state = "rabbitsmall"
	fire_delay = 7
	projectile_damage_multiplier = 0.9
	weapon_weight = WEAPON_LIGHT

/obj/item/gun/energy/e_gun/rabbitdash/shotgun
	name = "R公司 R-2300 '霰弹炮'"
	desc = "R公司为基层部队量产的霰弹型号，可发射散射弹幕。"
	icon_state = "rabbitshotgun"
	fire_delay = 10
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red/shotgun,
		)

/obj/item/gun/energy/e_gun/rabbitdash/black
	name = "R公司 R-2400 '黑色步枪'"
	desc = "R公司为基层部队量产的升级型号，仅能发射黑色子弹。"
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/black,
		)

//the 2800 is an autorifle, and is found in /rcorp
/obj/item/gun/energy/e_gun/rabbitdash/pale
	name = "R公司 R-2900 '终极方案'"
	desc = "R公司为基层部队量产的升级型号，仅能发射青色子弹。"
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/pale,
		)


/obj/item/gun/energy/e_gun/rabbitdash/heavy
	name = "R公司 X-9 重型步枪"
	desc = "R公司为基层部队量产的重型型号，射速极慢但威力巨大。\
			持有时显著减缓移速。"
	icon_state = "rabbitheavy"
	fire_delay = 12
	item_flags = SLOWS_WHILE_IN_HAND
	drag_slowdown = 2
	slowdown = 0.7
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red/heavy,
		)

/obj/item/gun/energy/e_gun/rabbitdash/sniper
	name = "R公司 X-12 神射手"
	desc = "R公司狙击手使用的精准步枪，射速较慢但伤害更高，配备瞄准镜。"
	icon_state = "rabbitsniper"
	fire_delay = 8
	projectile_damage_multiplier = 1.2
	zoom_amt = 5 //Long range, Slightly better range
	zoomable = TRUE
	zoom_out_amt = 0

/obj/item/gun/energy/e_gun/rabbitdash/laser
	name = "R公司 X-13 光束步枪"
	desc = "R公司为基层部队量产的升级型号，可发射光束弹。"
	icon_state = "rabbitlaser"
	fire_delay = 10
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red/beam,
		)

/obj/item/gun/energy/e_gun/rabbitdash/heavysniper
	name = "R公司 X-21 狙击炮"
	desc = "R公司狙击部队使用的重型武器，射速极慢但威力惊人，配备高级瞄准镜及敌我识别系统。"
	icon_state = "rabbitheavysniper"
	fire_delay = 15
	zoomable = TRUE
	zoom_amt = 10 //Long range, enough to see in front of you, but no tiles behind you.
	zoom_out_amt = 5
	projectile_damage_multiplier = 3
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red/iff,
		)

