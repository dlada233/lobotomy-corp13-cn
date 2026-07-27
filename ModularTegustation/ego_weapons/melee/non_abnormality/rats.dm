//Rats weapons. This is all throwaway junk.
/obj/item/ego_weapon/city/rats
	name = "耗子 锤子"
	desc = "在耗子身上发现的一把锤子，这把属于一个被清道夫夺走所有的耗子."
	icon_state = "rathammer"
	force = 9
	damtype = RED_DAMAGE

	attack_verb_continuous = list("smacks", "hammers", "beats")
	attack_verb_simple = list("smack", "hammer", "beat")

/obj/item/ego_weapon/city/rats/knife
	name = "耗子 战斗刀"
	desc = "在耗子身上发现的一把战斗刀，这把属于一个曾经梦想着更大东西的耗子."
	icon_state = "ratknife"
	force = 4
	attack_speed = 0.5
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/ego_weapon/city/rats/scalpel
	name = "耗子 解剖刀"
	desc = "在耗子身上发现的一把解剖刀，这把属于一个放弃了更好未来梦想的耗子."
	icon_state = "ratscalpel"
	force = 10
	attack_speed = 1.2
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/ego_weapon/city/rats/brick
	name = "耗子 砖头"
	desc = "在耗子身上发现的一块砖头."
	special = "可以装入 EGO 腰带."
	icon_state = "ratbrick"
	force = 3
	throwforce = 25
	attack_speed = 0.8
	attack_verb_continuous = list("bricks", "smashes", "shatters")
	attack_verb_simple = list("brick", "smash", "shatter")
	hitsound = 'sound/weapons/ego/bricksmash.ogg'

/obj/item/ego_weapon/city/rats/brick/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..())
		playsound(src, 'sound/weapons/ego/bricksmash.ogg', 50, TRUE)
		qdel(src)

/obj/item/ego_weapon/city/rats/pipe
	name = "耗子 铁管"
	desc = "在耗子身上发现的一根铁管，如果你用它敲打别人的头，会很疼."
	icon_state = "ratpipe"
	force = 27
	attack_speed = 3
	damtype = RED_DAMAGE

	attack_verb_continuous = list("pipes", "smashes", "shatters", "nails over the head")
	attack_verb_simple = list("pipe", "smash", "shatter", "nail in the head")
	hitsound = 'sound/weapons/ego/pipesuffering.ogg'

// From CRUELTY SQUAD. It's really, really bad
/obj/item/ego_weapon/ranged/pistol/rats
	name = "XX-公司 Zippy 3000"
	desc = "一把终极武器, 当然是在走火和卡壳方面的终极. 你得非常幸运，才有可能连开两枪而不伤到自己的手指. \
		XX-公司所制造的一把武器. 由于发射次数过多，故障频繁，对底层收尾人来说都难以忍受. \
		XX-公司最终放弃了这个项目，据说他们把数千件该产品全部丢弃到了后巷里. \
		不然很难解释为什么有这么多耗子拥有这些武器."
	icon_state = "zippy"
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	inhand_icon_state = "gun"
	worn_icon_state = "gun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	projectile_path = /obj/projectile/ego_bullet/ego_kcorp
	fire_delay = 5
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	fire_sound_volume = 70

/obj/item/ego_weapon/ranged/pistol/rats/can_shoot()
	..()
	if(prob(33))
		playsound(src, 'sound/weapons/gun/general/dry_fire.ogg', 30, TRUE)
		visible_message(span_notice("这枪卡壳了."))
		return FALSE
	else
		return TRUE

/obj/item/ego_weapon/ranged/pistol/rats/afterattack(atom/target, mob/living/user, flag, params)
	if(flag) // Don't want to take damage when just using melee
		return ..()
	if(prob(50))
		to_chat(user,span_warning("你夹到手指了."))
		user.apply_damage(2, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE))
		return FALSE
	return ..()

