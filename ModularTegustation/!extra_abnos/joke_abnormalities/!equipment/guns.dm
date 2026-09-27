//Zayin
//The Mcrib
/obj/item/ego_weapon/ranged/pistol/mcrib
	name = "mcrib"
	desc = "Try a mcrib at your nearest McDonalds!"
	special = "穿戴对应护甲时，手中使用这把武器可以为附近的人制造食物."
	icon = 'ModularTegustation/Teguicons/joke_abnos/joke_weapons.dmi'
	icon_state = "mcrib"
	force = 3
	projectile_path = /obj/projectile/ego_bullet/ego_mcrib
	burst_size = 1
	fire_delay = 10
	fire_sound = 'sound/effects/meatslap.ogg'
	var/ability_cooldown_time = 60 SECONDS
	var/ability_cooldown

/obj/item/ego_weapon/ranged/pistol/mcrib/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(ability_cooldown > world.time)
		to_chat(H, "<span class='warning'>你最近使用过这个能力了!</span>")
		return
	var/obj/item/clothing/suit/armor/ego_gear/zayin/mcrib/T = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(T))
		to_chat(H, "<span class='warning'>你必须穿戴对应护甲才能使用这个能力</span>")
		return
	to_chat(H, "<span class='warning'>你使用MCrib分享美食!</span>")
	H.playsound_local(get_turf(H), 'sound/abnormalities/mcrib/mcrib.ogg', 25, 0)
	SpawnItem(user)
	ability_cooldown = world.time + ability_cooldown_time

/obj/item/ego_weapon/ranged/pistol/mcrib/proc/SpawnItem(mob/user)
	var/foodoption = /obj/item/food/mcrib
	for(var/mob/living/carbon/human/L in livinginview(5, user))
		if((!ishuman(L)) || L.stat == DEAD || L == user)
			continue
		to_chat(L, "<span class='warning'>那不是...正宗堪萨斯城烧烤酱？ [user]给予了你一份美食!</span>")
		new foodoption(get_turf(L))
	new foodoption(get_turf(user))

/obj/projectile/ego_bullet/ego_mcrib
	name = "mcrib"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "patty"
	damage = 4
	damage_type = RED_DAMAGE

// HE
/obj/item/ego_weapon/ranged/squeak
	name = "吱吱玩具"
	desc = "Soft to the touch, as if it's made of rubber"
	icon = 'ModularTegustation/Teguicons/joke_abnos/joke_weapons.dmi'
	icon_state = "squeak"
	inhand_icon_state = "squeak"
	force = 9
	projectile_path = /obj/projectile/ego_bullet/ego_squeak
	weapon_weight = WEAPON_MEDIUM
	spread = 10
	max_shots = 30
	reloadtime = 1.3 SECONDS
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'
	autofire = 0.14 SECONDS

// WAW
/obj/item/ego_weapon/ranged/anti_skub
	name = "anti-skub"
	desc = "A weapon easily created from schematics posted on illicit internet forums."
	icon = 'ModularTegustation/Teguicons/joke_abnos/joke_weapons.dmi'
	icon_state = "anti_skub"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	inhand_icon_state = "beer"
	special = "This weapon deals AOE damage."
	force = 15
	attack_speed = 1.2
	damtype = RED_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/skub
	weapon_weight = WEAPON_HEAVY
	fire_delay = 15
	fire_sound = 'sound/weapons/fixer/generic/dodge.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)

/obj/projectile/ego_bullet/skub
	name = "skub鸡尾酒"
	icon = 'ModularTegustation/Teguicons/joke_abnos/joke_weapons.dmi'
	icon_state = "anti_skub2"
	damage = 20
	damage_type = RED_DAMAGE
	hitsound = "shatter"

/obj/projectile/ego_bullet/skub/on_hit(atom/target, blocked = FALSE)
	..()
	for(var/mob/living/L in view(1, target))
		new /obj/effect/temp_visual/fire/fast(get_turf(L))
		L.deal_damage(20, RED_DAMAGE, firer, attack_type = (ATTACK_TYPE_RANGED))
	return BULLET_ACT_HIT
