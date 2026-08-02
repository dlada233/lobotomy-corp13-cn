
/obj/item/ego_weapon/officer/discipline
	name = "部长破坏剑"
	icon_state = "officer_buster"
	desc = "一把巨大的剑，能够对大多数物体造成有效破坏，由惩戒部长使用 "
	special = "在手中使用以在下次攻击中造成更大伤害."
	force = 15
	attack_speed = 1.8
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleaves", "cuts")
	hitsound = 'sound/weapons/fixer/generic/finisher1.ogg'
	level_to_force = list(15, 22, 35, 47, 68)
	allowed_roles = list("Disciplinary Officer")
	extra_text = "这把武器只能由惩戒部长使用，击败的考验越多，这把武器的力量也会随之增强."
	swingstyle = WEAPONSWING_LARGESWEEP
	var/charged = FALSE

/obj/item/ego_weapon/officer/discipline/attack(mob/living/M, mob/living/user)
	if(charged)
		force *= 1.5
		hitsound = 'sound/abnormalities/nothingthere/goodbye_attack.ogg'
	..()
	if(charged)
		var/obj/effect/temp_visual/dir_setting/slash/s = new(get_turf(M))
		s.dir = 0
		s.layer = M.layer + 0.1
		to_chat(user, "你撕裂了[M]!")
		hitsound = initial(hitsound)
		refresh_stats()
		charged = FALSE

/obj/item/ego_weapon/officer/discipline/attack_self(mob/user)
	. = ..()
	if(!charged)
		if(do_after(user, 10, src))
			charged = TRUE
			to_chat(user,span_warning("你将力量集中在了这次攻击上."))

/obj/item/ego_weapon/officer/discipline/get_clamped_volume()
	return 50

/obj/item/ego_weapon/officer/discipline_baton
	name = "惩戒部长镇暴棍"
	desc = "一把可伸缩的镇暴棍，非常强健，对失去理智的员工造成三倍的白色伤害."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "telebaton_0"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	worn_icon_state = "tele_baton"
	var/on_icon_state = "telebaton_1"
	var/off_icon_state = "telebaton_0"
	var/on_inhand_icon_state = "nullrod"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	damtype = RED_DAMAGE
	force = 7
	attack_speed = 1.5
	level_to_force = list(7, 12, 17, 23, 34)
	allowed_roles = list("Disciplinary Officer")
	extra_text = "这把武器只能由惩戒部长使用，击败的考验越多，这把武器的力量也会随之增强."
	var/on = FALSE

/obj/item/ego_weapon/officer/discipline_baton/proc/ToolChecks(mob/user)
	if(user?.mind?.assigned_role != "Disciplinary Officer")
		return FALSE
	return TRUE

/obj/item/ego_weapon/officer/discipline_baton/proc/get_on_description()
	. = list()

	.["local_on"] = "<span class ='warning'>你伸出镇暴棍.</span>"
	.["local_off"] = "<span class ='notice'>你收起镇暴棍.</span>"

	return .

/obj/item/ego_weapon/officer/discipline_baton/attack_self(mob/user)
	if(!ToolChecks(user))
		to_chat(user, span_warning("你不能使用这把武器!."))
		return
	on = !on
	var/list/desc = get_on_description()

	if(on)
		to_chat(user, desc["local_on"])
		icon_state = on_icon_state
		inhand_icon_state = on_inhand_icon_state
		w_class = WEIGHT_CLASS_BULKY
		attack_verb_continuous = list("smacks", "strikes", "cracks", "beats")
		attack_verb_simple = list("smack", "strike", "crack", "beat")
	else
		to_chat(user, desc["local_off"])
		icon_state = off_icon_state
		inhand_icon_state = null //no sprite for concealment even when in hand
		slot_flags = ITEM_SLOT_BELT
		w_class = WEIGHT_CLASS_SMALL
		attack_verb_continuous = list("hits", "pokes")
		attack_verb_simple = list("hit", "poke")
	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, TRUE)

/obj/item/ego_weapon/officer/discipline_baton/examine(mob/user)
	. = ..()
	. += span_notice("在伤害意图下对失去理智的员工造成极高的白色伤害.")
	if(!ToolChecks(user))
		. += span_warning("仅供惩戒部长使用.")
	else
		. += span_nicegreen("只有你能使用这把武器.")


/obj/item/ego_weapon/officer/discipline_baton/attack(mob/living/target, mob/living/user)
	if(!ToolChecks(user))
		to_chat(user, span_warning("你不能使用这把武器!."))
		return
	if(!on)
		force = 0
	else if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.sanity_lost)
			damtype = WHITE_DAMAGE
			force *= 2
	..()
	damtype = initial(damtype)
	force = level_to_force[current_level]

/obj/item/ego_weapon/officer/butcher
	name = "惩戒部长屠夫刀"
	desc = "一把用于屠宰的刀."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "pierre"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right.dmi'
	force = 3
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED
	toolspeed = 0.25
	allowed_roles = list("Disciplinary Officer")
	level_to_force = list(3, 6, 9, 12, 15)
	var/list/level_to_speed = list(40, 30, 20, 10, 0) // 4-0 second(s) butcher time depending on level. Instant butchering is comparable to the smile E.G.O.
	extra_text = "这把工具只能由惩戒部长使用."

/obj/item/ego_weapon/officer/butcher/refresh_stats() // Overridden this to increase the butcher speed.
	force = level_to_force[current_level]
	var/datum/component/butchering/butchering = src.GetComponent(/datum/component/butchering)
	if(!butchering)
		AddComponent(/datum/component/butchering, 50,100, 0)
		refresh_stats()
		return
	butchering.speed = level_to_speed[current_level]
