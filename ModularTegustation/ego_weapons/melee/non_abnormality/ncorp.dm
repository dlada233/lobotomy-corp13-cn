//Marks - These augment the hammers.
/obj/item/ego_weapon/city/ncorp_mark
	name = "N公司红印"
	desc = "N公司使用的红色印记。"
	special = "用于N公司锤类武器可改变其伤害类型。\
		此物品为一次性使用。"
	icon_state = "mark"
	force = 20
	damtype = RED_DAMAGE

	attack_verb_continuous = list("marks")
	attack_verb_simple = list("mark")

/obj/item/ego_weapon/city/ncorp_mark/attack(mob/living/target, mob/living/user)
	..()
	qdel(src)

/obj/item/ego_weapon/city/ncorp_mark/white
	name = "N公司白印"
	icon_state = "wmark"
	damtype = WHITE_DAMAGE


/obj/item/ego_weapon/city/ncorp_mark/black
	name = "N公司黑印"
	icon_state = "bmark"
	damtype = BLACK_DAMAGE


/obj/item/ego_weapon/city/ncorp_mark/pale
	name = "N公司青印"
	icon_state = "pmark"
	damtype = PALE_DAMAGE


//Nails - These mark enemies to enable the hammer
/obj/item/ego_weapon/city/ncorp_nail
	name = "克莱因尖钉"
	desc = "N公司初级审判官使用的小型钉子。"
	special = "击中敌人可施加标记。\
		用N公司锤攻击此武器可伤害所有被标记敌人。"
	icon_state = "kleinnagel"
	force = 9
	damtype = RED_DAMAGE

	attack_verb_continuous = list("jabs", "stabs")
	attack_verb_simple = list("jab", "stab")
	hitsound = 'sound/weapons/fixer/generic/nail1.ogg'
	var/list/marked = list()

/obj/item/ego_weapon/city/ncorp_nail/attack(mob/living/target, mob/living/user)
	..()
	if(!(target in marked))
		marked+=target

/obj/item/ego_weapon/city/ncorp_nail/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/ego_weapon/city/ncorp_hammer))
		return

	for(var/mob/living/M in marked)
		playsound(M, 'sound/weapons/fixer/generic/nail2.ogg', 100, FALSE, 4)
		M.deal_damage(I.force, I.damtype, user, flags = (DAMAGE_WHITE_HEALABLE), attack_type = (ATTACK_TYPE_SPECIAL))
		new /obj/effect/temp_visual/remorse(get_turf(M))
		marked -= M

/obj/item/ego_weapon/city/ncorp_nail/big
	name = "米特尔尖钉"
	desc = "N公司高级审判官使用的大型钉子。"
	icon_state = "mittlenagel"
	force = 18
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/city/ncorp_nail/huge
	name = "格罗斯尖钉"
	desc = "N公司队长级使用的巨型钉子。"
	icon_state = "grossnagel"
	force = 25
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/ego_weapon/city/ncorp_nail/grip
	name = "正义之钉"
	desc = "执柄者使用的巨型钉子。"
	icon_state = "gripnagel"
	force = 25
	damtype = WHITE_DAMAGE

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)


//Hammers - This is your bread and butter attacking weapon.
/obj/item/ego_weapon/city/ncorp_hammer
	name = "克莱因锤"
	desc = "N公司初级审判官使用的小型锤。"
	special = "使用印记可改变伤害类型。\
		此武器同时具备N公司锤特性"
	icon_state = "kleinhammer"
	force = 15
	attack_speed = 1.5
	damtype = RED_DAMAGE

	attack_verb_continuous = list("marks")
	attack_verb_simple = list("mark")
	hitsound = 'sound/weapons/fixer/generic/club2.ogg'
	var/charges
	var/charged		//so you don't get the message every time

/obj/item/ego_weapon/city/ncorp_hammer/attack(mob/living/target, mob/living/user)
	..()
	if(charges > 0)
		charges-=1
	if(charges <= 0 && charged)
		damtype = initial(damtype)
		to_chat(user, span_notice("锤击充能耗尽。"))
		charged = FALSE
	force = initial(force)

/obj/item/ego_weapon/city/ncorp_hammer/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/ego_weapon/city/ncorp_mark))
		return
	to_chat(user, span_notice("印记生效，伤害类型已变更。"))
	damtype = I.damtype
	charges = 10
	charged = TRUE
	qdel(I)

//Big hammer
/obj/item/ego_weapon/city/ncorp_hammer/big
	name = "米特尔锤"
	desc = "N公司高级审判官使用的大型锤。"
	icon_state = "mittlehammer"
	force = 30
	hitsound = 'sound/weapons/ego/shield1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/city/ncorp_hammer/hand
	name = "格罗斯拳甲"
	desc = "N公司队长级使用的金属拳套。"
	icon_state = "grosshand"
	force = 30
	attack_speed = 1
	hitsound = 'sound/weapons/fixer/generic/fist2.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)

//SHE WHO GRIPS
/obj/item/ego_weapon/city/ncorp_hammer/grippy
	name = "正义之手"
	desc = "N公司队长级使用的钢拳，为异端带去正义之光。"
	icon_state = "grip"
	force = 30
	attack_speed = 1
	damtype = WHITE_DAMAGE

	hitsound = 'sound/weapons/fixer/generic/fist2.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)


//Brass Nail set
/obj/item/ego_weapon/city/ncorp_brassnail
	name = "梅辛尖钉"
	desc = "N公司初级审判官使用的黄铜钉。"
	special = "击中敌人可积累钉子。\
		用N公司锤攻击此武器可使下次攻击伤害每钉提升10%。"
	icon_state = "messingnagel"
	force = 9
	damtype = RED_DAMAGE
	swingstyle = WEAPONSWING_THRUST

	attack_verb_continuous = list("jabs", "stabs")
	attack_verb_simple = list("jab", "stab")
	hitsound = 'sound/weapons/fixer/generic/nail1.ogg'
	var/nails
	var/nail_limit = 50

/obj/item/ego_weapon/city/ncorp_brassnail/attack(mob/living/target, mob/living/user)
	..()
	nails++
	if(nails>=5)
		nails = 5

/obj/item/ego_weapon/city/ncorp_brassnail/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/ego_weapon/city/ncorp_hammer))
		return
	if(I.force >= nail_limit)
		to_chat(user, span_warning("你无法再添加更多尖钉了!"))
		return

	I.force += I.force* nails *0.1
	if(I.force > nail_limit)
		I.force = nail_limit
	to_chat(user, span_notice("转移[nails]根钉子，锤击伤害提升至[I.force]。"))
	nails = 0

/obj/item/ego_weapon/city/ncorp_brassnail/big
	name = "埃列克特姆尖钉"
	desc = "N公司高级审判官使用的尖钉。"
	icon_state = "elektrumnagel"
	force = 18
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/city/ncorp_brassnail/huge
	name = "黄金尖钉"
	desc = "N公司队长级使用的巨钉。"
	icon_state = "goldnagel"
	force = 25
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)


/obj/item/ego_weapon/city/ncorp_brassnail/rose
	name = "玫瑰尖钉"
	desc = "N公司大审判官使用的巨钉。"
	icon_state = "rosenagel"
	force = 25
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)
	damtype = WHITE_DAMAGE


