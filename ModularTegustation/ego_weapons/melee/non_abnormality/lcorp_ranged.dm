//A file for all ranged weapons manufactured at L-corp that is not E.G.O.

//Contains ERA, clerk. and officer (?) weapons

/obj/projectile/ego_bullet/lcorp
	name = "子弹"
	damage = 1.5
	damage_type = RED_DAMAGE
	var/list/damage_tier = list(2,4,6,9,18) //These numbers are just for reference

/obj/projectile/ego_bullet/lcorp/fire(angle, atom/direct_target)
	if(fired_from)
		if(istype(fired_from, /obj/item/ego_weapon/ranged/city/lcorp))
			var/obj/item/ego_weapon/ranged/city/lcorp/our_weapon = fired_from
			if(our_weapon.tier > 0)
				damage_type = our_weapon.damtype
				damage = damage_tier[max(1, our_weapon.tier)]
				if(damage_type == PALE_DAMAGE) //pale deals 15% less damage before rounding down
					damage = floor(damage * 0.85)
	return ..()

/obj/projectile/ego_bullet/lcorp/pistol
	name = "子弹"
	damage = 5
	damage_tier = list(8,12,17,24,35)

/obj/projectile/ego_bullet/lcorp/automatic
	name = "子弹"
	damage = 2
	damage_tier = list(3,5,8,12,18)

///////////////////////
////AGENT EQUIPMENT////
///////////////////////

/obj/item/ego_weapon/ranged/city/lcorp
	icon = 'ModularTegustation/Teguicons/lcorp_weapons.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/lcorp_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lcorp_right.dmi'
	projectile_path = /obj/projectile/ego_bullet/ego_clerk
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 20,
							PRUDENCE_ATTRIBUTE = 20,
							TEMPERANCE_ATTRIBUTE = 20,
							JUSTICE_ATTRIBUTE = 20
							)
	is_city_gear = FALSE
	var/installed_shard
	var/equipped
	var/tier = 0

/obj/item/ego_weapon/ranged/city/lcorp/update_projectile_examine()
	if(isnull(projectile_path))
		message_admins("[src] has an invalid projectile path.")
		return
	var/obj/projectile/ego_bullet/lcorp/projectile = new projectile_path(src, src)
	last_projectile_damage = projectile.damage_tier[max(1, tier)]
	last_projectile_type = damtype
	qdel(projectile)


/obj/item/ego_weapon/ranged/city/lcorp/examine(mob/user)
	update_projectile_examine()
	. = ..()
	if(!installed_shard)
		. += span_warning("这把武器可以通过EGO碎片强化.")
	else
		. += span_nicegreen("它已有 [installed_shard] 安装.")

/obj/item/ego_weapon/ranged/city/lcorp/equipped(mob/user, slot, initial = FALSE)
	..()
	equipped = TRUE

/obj/item/ego_weapon/ranged/city/lcorp/dropped(mob/user)
	..()
	equipped = FALSE

/obj/item/ego_weapon/ranged/city/lcorp/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/egoshard))
		return
	if(equipped)
		to_chat(user, span_warning("你必须先放下 [src] 再尝试这个操作!"))
		return
	if(installed_shard)
		to_chat(user, span_warning("[src] 已经安装了EGO碎片!"))
		return
	installed_shard = I.name
	IncreaseAttributes(user, I)
	playsound(get_turf(src), 'sound/effects/light_flicker.ogg', 50, TRUE)
	qdel(I)

/obj/item/ego_weapon/ranged/city/lcorp/proc/IncreaseAttributes(mob/living/user, obj/item/egoshard/egoshard)
	damtype = egoshard.damage_type
	force = floor(egoshard.base_damage * 0.7) //70% of base damage which is to be expected of guns. Currently all guns override this with their own values.
	tier = egoshard.tier
	for(var/atr in attribute_requirements)
		attribute_requirements[atr] = egoshard.stat_requirement
	to_chat(user, span_warning("[src]的装备需求已经提升了!"))
	to_chat(user, span_nicegreen("[src]成功的强化了!"))
	icon_state = "[initial(icon_state)]_[egoshard.damage_type]"

/obj/item/ego_weapon/ranged/city/lcorp/pistol
	name = "L公司 镇压手枪"
	desc = "L公司为无法使用E.G.O的人员特制的手枪."
	icon_state = "pistol"
	inhand_icon_state = "pistol"
	special = "这把武器在双持时具有极高的精准度."
	projectile_path = /obj/projectile/ego_bullet/lcorp/pistol
	attack_speed = 0.5
	force = 3
	fire_delay = 5
	shotsleft = 12
	reloadtime = 2.1 SECONDS
	fire_sound = 'sound/weapons/gun/revolver/shot_alt.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	dual_wield_spread = 0

/obj/item/ego_weapon/ranged/city/lcorp/pistol/IncreaseAttributes(mob/living/user, obj/item/egoshard/egoshard)
	..()
	force = floor(egoshard.base_damage * 0.35) // 2 attacks per attack cycle due to being a pistol

/obj/item/ego_weapon/ranged/city/lcorp/automatic_pistol
	name = "L公司 自动手枪"
	desc = "L公司为无法使用E.G.O的人员特制的自动手枪."
	icon_state = "automatic"
	inhand_icon_state = "automatic"
	w_class = WEIGHT_CLASS_NORMAL
	projectile_path = /obj/projectile/ego_bullet/lcorp/automatic
	attack_speed = 0.5
	force = 3
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	shotsleft = 30
	reloadtime = 1.2 SECONDS
	autofire = 0.2 SECONDS

/obj/item/ego_weapon/ranged/city/lcorp/automatic_pistol/IncreaseAttributes(mob/living/user, obj/item/egoshard/egoshard)
	..()
	force = floor(egoshard.base_damage * 0.35) // 2 attacks per attack cycle due to being a pistol

///////////////////
//CLERK EQUIPMENT//
///////////////////

//Standard clerk pistol
/obj/item/ego_weapon/ranged/clerk
	name = "文职手枪"
	desc = "一把小手枪, 上面写着 '将枪口指向敌人然后扣动扳机'."
	icon_state = "clerk"
	inhand_icon_state = "gun"
	worn_icon_state = "gun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	attack_speed = 0.5
	force = 3
	w_class = WEIGHT_CLASS_NORMAL
	projectile_path = /obj/projectile/ego_bullet/ego_clerk
	burst_size = 1
	fire_delay = 3
	shotsleft = 10
	reloadtime = 0.5 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70

/obj/item/ego_weapon/ranged/clerk/handle_suicide(mob/living/carbon/human/user, mob/living/carbon/human/target, params, bypass_timer)
	if(!ishuman(user) || !ishuman(target))
		return
	if(semicd)
		return
	var/user_target = FALSE
	if(user == target)
		target.visible_message("<span class='warning'>[user] 将 [src] 塞入自己的嘴里, 准备扣动扳机...</span>", \
			"<span class='userdanger'>你将 [src] 塞入自己的嘴里, 准备扣动扳机...</span>")
		user_target = TRUE
	else
		target.visible_message("<span class='warning'>[user] 将 [src] 对准 [target] 的头部, 准备扣动扳机...</span>", \
			"<span class='userdanger'>[user] 将 [src] 对准你的头部, 准备扣动扳机...</span>")
	semicd = TRUE
	if(!bypass_timer && (!do_mob(user, target, (user_target ? 3 SECONDS : 12 SECONDS)) || user.zone_selected != BODY_ZONE_PRECISE_MOUTH))
		if(user)
			if(user == target)
				user.visible_message("<span class='notice'>[user] 决定不射击.</span>")
			else if(target?.Adjacent(user))
				target.visible_message("<span class='notice'>[user] 决定留下 [target] 的性命.</span>", "<span class='notice'>[user] 决定留下你的性命!</span>")
		semicd = FALSE
		return
	semicd = FALSE
	target.visible_message("<span class='warning'>[user] 扣动了扳机!</span>", "<span class='userdanger'>[(user == target) ? "你扣动" : "[user] 扣动"]了扳机!</span>")

	process_fire(target, user, TRUE, params, BODY_ZONE_HEAD, temporary_damage_multiplier = (user_target ? 100 : 5))
