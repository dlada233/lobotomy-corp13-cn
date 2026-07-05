//Night Awl - Grade 4 with crits.
/obj/item/ego_weapon/city/awl
	name = "夜阑华彩" // 原文 night awl stilleto
	desc = "一种细长的刺刀，由夜锥组使用."
	special = "这把武器有10%概率造成双倍伤害. 这把武器可以放进EGO腰带里."
	icon_state = "nightawl"
	force = 20
	attack_speed = 1.2
	damtype = BLACK_DAMAGE

	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 100,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 80,
	)


/obj/item/ego_weapon/city/awl/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	if(prob(10))
		force*=2
		to_chat(user, span_userdanger("Critical!"))
	..()
	force = initial(force)

//Kurokumo - Grade 4 with poise crits.
/obj/item/ego_weapon/city/kurokumo
	name = "黑云之刃"
	desc = "黑云会使用的极为锋利的刀，让它沾满鲜血吧."
	special = "该武器每发动一次攻击积累1点暴击值，1点暴击值可使你有2%的概率造成3倍伤害，线性叠加. 暴击命中会将暴击值减少至0."
	icon_state = "kurokumo_sheathed"
	inhand_icon_state = "kurokumo_sheathed"
	force = 26
	attack_speed = 1.2
	damtype = RED_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP

	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)
	var/poise = 0

/obj/item/ego_weapon/city/kurokumo/examine(mob/user)
	. = ..()
	. += "当前暴击值: [poise]/20."

/obj/item/ego_weapon/city/kurokumo/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	poise+=1
	if(poise>=10)
		icon_state = "kurokumo"
		inhand_icon_state = "kurokumo"
	else if(poise>= 20)
		poise = 20

	//Crit itself.
	if(prob(poise*2))
		force*=3
		to_chat(user, span_userdanger("Critical!"))
		poise = 0
		icon_state = "kurokumo_sheathed"
		inhand_icon_state = "kurokumo_sheathed"
	..()
	force = initial(force)

//Blade Lineage - Grade 4, use in hand to immobilize and give you a massive damage boost
/obj/item/ego_weapon/city/bladelineage
	name = "剑契太刀"
	desc = "剑契组的标准武器."
	special = "手中使用武器，使自己被禁锢3秒，并在接下来5秒内造成5倍伤害. \
	这把武器若配合上对应护甲，在使用主动技能时还可以抵御不同等级的致命伤害."
	icon_state = "blade_lineage"
	inhand_icon_state = "blade_lineage"
	force = 23
	attack_speed = 1.2
	damtype = RED_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP

	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)
	var/ready = TRUE
	var/multiplier = 5


/obj/item/ego_weapon/city/bladelineage/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return

	if(!ready)
		return
	ready = FALSE
	user.Immobilize(3 SECONDS)
	to_chat(user, span_userdanger("舍吾皮肉."))
	force*=multiplier
	force*=(1 + (user.health/user.maxHealth)*2)

	var/obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_salsu/S = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	var/obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_cutthroat/C = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	var/obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_admin/R = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)

	if(istype(S))
		ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "unrelenting")

	if(istype(C))
		ADD_TRAIT(user, TRAIT_NOHARDCRIT, "unrelenting")
		ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "unrelenting")

	if(istype(R))
		ADD_TRAIT(user, TRAIT_NODEATH, "unrelenting")
		ADD_TRAIT(user, TRAIT_NOHARDCRIT, "unrelenting")
		ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "unrelenting")

	addtimer(CALLBACK(src, PROC_REF(Return), user), 5 SECONDS)

/obj/item/ego_weapon/city/bladelineage/attack(mob/living/target, mob/living/carbon/human/user)
	REMOVE_TRAIT(user, TRAIT_NODEATH, "unrelenting")
	REMOVE_TRAIT(user, TRAIT_NOHARDCRIT, "unrelenting")
	REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "unrelenting")
	..()
	if(force != initial(force))
		to_chat(user, span_userdanger("断汝筋骨."))
		force = initial(force)

/obj/item/ego_weapon/city/bladelineage/proc/Return(mob/living/carbon/human/user)
	force = initial(force)
	ready = TRUE
	to_chat(user, span_notice("你的剑尚未准备好."))
	REMOVE_TRAIT(user, TRAIT_NODEATH, "unrelenting")
	REMOVE_TRAIT(user, TRAIT_NOHARDCRIT, "unrelenting")
	REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "unrelenting")


/obj/item/ego_weapon/city/bladelineage/Initialize()
	..()
	if(SSmaptype.maptype == "city")

		attribute_requirements = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
