//Leaflet
/obj/item/ego_weapon/city/leaflet
	name = "传单工坊基型"
	desc = "传单工坊的制式模板。"
	icon_state = "leaflet"
	force = 10
	damtype = RED_DAMAGE

	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)
	var/durability = 25
	var/max_durability = 25
	var/broken = FALSE

/obj/item/ego_weapon/city/leaflet/examine(mob/user)
	. = ..()
	. +="耐久耗尽时伤害大幅降低。手持使用可修复耐久。"
	. += "耐久度: [durability]/[initial(durability)]"

/obj/item/ego_weapon/city/leaflet/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return
	if(broken)
		to_chat(user, span_notice("你开始修复武器..."))
		if(!do_after(user, 12 SECONDS, src))
			return
		to_chat(user, span_notice("武器修复完成"))
		durability = max_durability
		force = initial(force)

/obj/item/ego_weapon/city/leaflet/attack(mob/living/target, mob/living/carbon/human/user)
	..()
	if(durability > 0)
		durability -= 1
	else if(durability == 0 && !broken)
		broken = TRUE
		to_chat(user, span_userdanger("你的武器已损坏！"))
		force = force*0.5
		playsound(src, 'sound/weapons/ego/shield1.ogg', 100, FALSE, 4)

//Grade 6 with grade 5 damage This shit breaks
/obj/item/ego_weapon/city/leaflet/round
	name = "传单工坊圆头锤"
	desc = "传单工坊生产的实用圆头锤，收尾人可用适中价格购入。"
	icon_state = "leaflet_round"
	force = 22

//The Knockback version
/obj/item/ego_weapon/city/leaflet/wide
	name = "传单工坊宽面锤"
	desc = "传单工坊生产的实用宽面锤，收尾人可用适中价格购入。"
	special = "This weapon knocks the enemy back on hit."
	icon_state = "leaflet_wide"
	force = 22
	attack_speed = 1.2

/obj/item/ego_weapon/city/leaflet/wide/attack(mob/living/target, mob/living/carbon/human/user)
	. = ..()
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

//Grade 5 with grade 4 damage
/obj/item/ego_weapon/city/leaflet/square
	name = "传单工坊方头锤"
	desc = "传单工坊生产的精良方头锤，传闻中集团可以高价购入。"
	icon_state = "leaflet_hammer"
	force = 27
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

