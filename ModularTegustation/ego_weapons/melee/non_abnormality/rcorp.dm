/obj/item/ego_weapon/city/rabbit_blade
	name = "高频振动匕首"
	desc = "专为对抗脑叶公司以及外围地区的异想体威胁而设计的高频战斗匕首."
	icon_state = "rabbitblade"
	inhand_icon_state = "rabbit_katana"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 17
	throwforce = 12
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("stabs", "slices")
	attack_verb_simple = list("stab", "slice")
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 55,
		PRUDENCE_ATTRIBUTE = 55,
		TEMPERANCE_ATTRIBUTE = 55,
		JUSTICE_ATTRIBUTE = 55,
	)
	var/rcorp_buff = 0

/obj/item/ego_weapon/city/rabbit_blade/Initialize()
	if(SSmaptype.maptype == "rcorp")
		rcorp_buff = 10
		force += rcorp_buff
	return ..()

/obj/item/ego_weapon/city/rabbit_blade/attack(mob/living/target, mob/living/user)
	if(user.mind)
		if(user.mind.has_antag_datum(/datum/antagonist/wizard/arbiter/rcorp))
			to_chat(user, span_notice("你还不屑使用下级部队的武器.")) //You are a arbiter not a homeless man with a knife
			return FALSE
	..()

/obj/item/ego_weapon/city/rabbit_blade/attack_obj(obj/target, mob/living/user)
	if(user.mind)
		if(user.mind.has_antag_datum(/datum/antagonist/wizard/arbiter/rcorp))
			to_chat(user, span_notice("你还不屑使用下级部队的武器.")) //You are a arbiter not a homeless man with a knife
			return FALSE
	..()

/obj/item/ego_weapon/city/rabbit_blade/attack_self(mob/living/user)
	switch(damtype)
		if(RED_DAMAGE)
			damtype = WHITE_DAMAGE
		if(WHITE_DAMAGE)
			damtype = BLACK_DAMAGE
			force = rcorp_buff + 15
		if(BLACK_DAMAGE)
			damtype = PALE_DAMAGE
			force = rcorp_buff + 12
		if(PALE_DAMAGE)
			damtype = RED_DAMAGE
			force = rcorp_buff + 17
	to_chat(user, span_notice("\The [src] will now deal [damtype] damage."))
	playsound(src, 'sound/items/screwdriver2.ogg', 50, TRUE)

//Command Sabre
/obj/item/ego_weapon/city/rabbit_blade/command
	name = "R-公司军刀"
	desc = "为地面指挥官设计的更强力的R-公司军刀."
	icon_state = "rcorp_sabre"
	inhand_icon_state = "multiverse"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 25
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 0,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/ego_weapon/city/rabbit_blade/command/attack_self(mob/living/user)
	switch(damtype)
		if(RED_DAMAGE)
			damtype = WHITE_DAMAGE
		if(WHITE_DAMAGE)
			damtype = BLACK_DAMAGE
		if(BLACK_DAMAGE)
			damtype = PALE_DAMAGE
		if(PALE_DAMAGE)
			damtype = RED_DAMAGE
	to_chat(user, span_notice("[src] 现在将造成 [damtype] 伤害."))
	playsound(src, 'sound/items/screwdriver2.ogg', 50, TRUE)


//Reindeer staves
/obj/item/ego_weapon/city/reindeer
	name = "R-公司驯鹿杖"
	desc = "R-公司驯鹿小队使用的法杖, 远程攻击造成黑色伤害."
	icon_state = "rcorp_staff"
	inhand_icon_state = "staffofstorms"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	force = 20
	damtype = WHITE_DAMAGE

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	var/ranged_cooldown
	var/ranged_cooldown_time = 1.3 SECONDS

/obj/item/ego_weapon/city/reindeer/attack(mob/living/target, mob/living/user)
	if(user.mind)
		if(user.mind.has_antag_datum(/datum/antagonist/wizard/arbiter/rcorp)) //You are a arbiter not a mentally unstable supersoldier
			return FALSE
	..()

/obj/item/ego_weapon/city/reindeer/attack_obj(obj/target, mob/living/user)
	if(user.mind)
		if(user.mind.has_antag_datum(/datum/antagonist/wizard/arbiter/rcorp)) //You are a arbiter not a mentally unstable supersoldier
			return FALSE
	..()

/obj/item/ego_weapon/city/reindeer/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(ranged_cooldown > world.time)
		return
	if(!CanUseEgo(user))
		return
	if(user.mind)
		if(user.mind.has_antag_datum(/datum/antagonist/wizard/arbiter/rcorp))
			to_chat(user, span_notice("你还不屑使用下级部队的武器.")) //You are a arbiter not a mentally unstable supersoldier
			return FALSE
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf))
		return
	if((get_dist(user, target_turf) < 2) || (get_dist(user, target_turf) > 5))
		return
	..()
	ranged_cooldown = world.time + ranged_cooldown_time
	playsound(target_turf, 'sound/weapons/pulse.ogg', 50, TRUE)
	for(var/turf/open/T in range(target_turf, 0))
		new /obj/effect/temp_visual/smash1(T)
		user.HurtInTurf(T, list(), force, BLACK_DAMAGE, attack_type = (ATTACK_TYPE_SPECIAL))

/obj/item/ego_weapon/city/reindeer/captain
	name = "R-公司驯鹿队长杖"
	icon_state = "rcorp_captainstaff"
	force = 30
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)


//Shitty Raven Dagger
/obj/item/ego_weapon/city/rabbit_blade/raven
	name = "R-公司鸦匕首"
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)


//Rcorp Guns

/obj/item/gun/energy/e_gun/rabbit
	name = "R-公司 R-3000 'Mark 2'"
	desc = "专为抑制脑叶公司内部威胁而设计的能量枪，它有四种射击模式可供切换."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "rabbit"
	inhand_icon_state = "rabbit4"
	cell_type = /obj/item/stock_parts/cell/infinite
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red,
		/obj/item/ammo_casing/energy/laser/white,
		/obj/item/ammo_casing/energy/laser/black,
		/obj/item/ammo_casing/energy/laser/pale
		)
	can_charge = FALSE
	weapon_weight = WEAPON_HEAVY // No dual wielding
	pin = /obj/item/firing_pin/implant/mindshield
	//None of these fucking guys can use Rcorp guns
	var/list/banned_roles = list("Rhino Squad Captain-乌鸦队队长", "Reindeer Squad Captain-驯鹿队队长","Rhino Squad Captain-犀牛队队长",
		"R-Corp Berserker Reindeer - R-公司狂战士驯鹿","R-Corp Medical Reindeer - R-公司医疗驯鹿","R-Corp Gunner Rhino - R-公司机枪手犀牛","R-Corp Hammer Rhino - R-公司重锤犀牛","R-Corp Scout Raven - R-公司侦查渡鸦","R-Corp Support Raven - R-公司支援渡鸦",
		"R-Corp Roadrunner - R-公司走鹃", "Roadrunner Squad Leader-走鹃队队长")

/obj/item/gun/energy/e_gun/rabbit/Initialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.16 SECONDS)


/obj/item/gun/energy/e_gun/rabbit/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	if(user.mind)
		if(user.mind.assigned_role in banned_roles)
			to_chat(user, span_notice("你没有接受过使用R-公司武器的训练!"))
			return FALSE
		if(user.mind.has_antag_datum(/datum/antagonist/wizard/arbiter/rcorp))
			to_chat(user, span_notice("你还不屑使用下级部队的武器.")) //You are a arbiter not a crazed gunman
			return FALSE
	..()

/obj/item/gun/energy/e_gun/rabbit/captain
	name = "R-公司 R-4000 'Mark 3'"
	desc = "为驯鹿队长特别生产的能量枪，这把武器可以用一只手射击."
	icon_state = "rabbitcaptain"
	inhand_icon_state = "rabbith1"
	weapon_weight = WEAPON_LIGHT
	pin = /obj/item/firing_pin

//you really shouldn't be having this as a spawned in rabbit
/obj/item/gun/energy/e_gun/rabbit/nopin
	name = "R-公司 R-2800 'Mark 1'"
	desc = "专为抑制威胁而设计的能量枪，它有多种伤害类型可供选择. 这是较旧的型号，只有3种模式."
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red,
		/obj/item/ammo_casing/energy/laser/white,
		/obj/item/ammo_casing/energy/laser/black
		)
	pin = /obj/item/firing_pin

/obj/item/gun/energy/e_gun/rabbit/minigun
	name = "R-公司 X-15 机枪"
	desc = "一把极为沉重的能量机枪，能以极快的速度发射子弹."
	icon_state = "rabbitmachinegun"
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red,
		)
	pin = /obj/item/firing_pin
	projectile_damage_multiplier = 0.4
	item_flags = SLOWS_WHILE_IN_HAND
	fire_delay = 0
	drag_slowdown = 3
	slowdown = 2

/obj/item/gun/energy/e_gun/rabbit/minigun/Initialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.05 SECONDS)

/obj/item/gun/energy/e_gun/rabbit/minigun/tricolor
	name = "R-公司 R-3500 机枪"
	desc = "一把极为沉重的能量机枪，能以极快的速度发射子弹."
	icon_state = "rabbitmachinegun"
	projectile_damage_multiplier = 0.7
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red/iff,
		/obj/item/ammo_casing/energy/laser/white/iff,
		/obj/item/ammo_casing/energy/laser/black/iff
		)

/obj/item/ego_weapon/city/rabbit_rush
	name = "突击匕首"
	desc = "专为对抗脑叶公司以及外围地区的异想体威胁而设计的高频战斗匕首. 这把仅有一种模式."
	special = "手中使用开启传送模式，然后点击目标进行传送."
	icon_state = "rabbitdash"
	inhand_icon_state = "rabbit_katana"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 10
	throwforce = 12
	damtype = PALE_DAMAGE

	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("stabs", "slices")
	attack_verb_simple = list("stab", "slice")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 55,
							PRUDENCE_ATTRIBUTE = 55,
							TEMPERANCE_ATTRIBUTE = 55,
							JUSTICE_ATTRIBUTE = 55
							)
	var/teleporting
	var/rcorp_buff = 0

/obj/item/ego_weapon/city/rabbit_rush/Initialize()
	if(SSmaptype.maptype == "rcorp")
		rcorp_buff = 10
		force += rcorp_buff
	return ..()

/obj/item/ego_weapon/city/rabbit_rush/attack(mob/living/target, mob/living/user)
	if(user.mind)
		if(user.mind.has_antag_datum(/datum/antagonist/wizard/arbiter/rcorp)) //You are a arbiter not a homeless man with a knife
			return FALSE
	..()

/obj/item/ego_weapon/city/rabbit_rush/attack_obj(obj/target, mob/living/user)
	if(user.mind)
		if(user.mind.has_antag_datum(/datum/antagonist/wizard/arbiter/rcorp)) //You are a arbiter not a homeless man with a knife
			return FALSE
	..()

/obj/item/ego_weapon/city/rabbit_rush/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(!do_after(user, 10, src))
		return
	if(teleporting)
		teleporting = FALSE
		to_chat(user,span_warning("你关闭了传送."))
	else
		teleporting = TRUE
		to_chat(user,span_warning("你开启了传送."))

/obj/item/ego_weapon/city/rabbit_rush/afterattack(atom/A, mob/living/user, proximity_flag, params)
	var/turf/target_turf = get_turf(A)
	if(user.mind)
		if(user.mind.has_antag_datum(/datum/antagonist/wizard/arbiter/rcorp))
			to_chat(user, span_notice("你还不屑使用下级部队的武器.")) //You are a arbiter not a methed up knife freak
			return FALSE
	if(!istype(target_turf))
		return
	if(get_dist(user, target_turf) < 2)
		return
	..()

	//Are you currently trying to teleport?
	if(!teleporting)
		return

	var/targetfound
	playsound(target_turf, 'sound/weapons/rapierhit.ogg', 100, TRUE)
	if(LAZYLEN(user.HurtInTurf(target_turf, list(), force*2, PALE_DAMAGE, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))))
		targetfound = TRUE
	//So you can't fucking teleport into a place where you are immune to all damage
	if(!targetfound)
		to_chat(user,span_warning("没有找到目标!"))
		return

	new /obj/effect/temp_visual/kinetic_blast(target_turf)

	//actually teleport
	var/list/teleport_targets = list()
	for(var/turf/open/Y in orange(1, target_turf))
		teleport_targets+=Y
	if(!LAZYLEN(teleport_targets))
		to_chat(user,span_warning("传送失败!"))
		return

	new /obj/effect/temp_visual/guardian/phase (get_turf(user))
	user.forceMove(pick(teleport_targets))

	//set all to 0
	teleporting = FALSE
