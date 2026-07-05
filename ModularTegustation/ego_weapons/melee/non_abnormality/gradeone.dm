//Dong-hwan's weapon. He's got a grade 2 weapon, he's a Grade 1 fixer.
//His weapon has 3 different attacks that you can perform, Shoving stab, Critical Moment, and Toughness.
//Which one is available depends on how close you are to an enemy.
/obj/item/ego_weapon/city/donghwan
	name = "伤残雕刻家"
	desc = "一把抛光、保养良好的长剑，拥有残酷但有效的刃口，属于一阶收尾人东焕，锯齿状设计用于咬住伤口并放血。"
	icon_state = "donghwan"
	force = 30
	attack_speed = 0.8
	damtype = RED_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP

	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 120,
		PRUDENCE_ATTRIBUTE = 100,
		TEMPERANCE_ATTRIBUTE = 100,
		JUSTICE_ATTRIBUTE = 100,
	)
	var/active
	var/attackchoice

/obj/item/ego_weapon/city/donghwan/examine(mob/user)
	. = ..()
	. += "这把武器有3种独立功能."
	. += "在准备好后，攻击目标可触发推击."
	. += "在准备好了，在手中使用可再下次攻击触发暴击."
	. += "攻击自己时，若SP较高则会降低SP，若SP较低则会轻微恢复SP."
	. += "暴击伤害与你的SP成反比."

/obj/item/ego_weapon/city/donghwan/attack_self(mob/living/carbon/human/user)
	active = TRUE
	if(attackchoice == 1)
		to_chat(user, span_notice("现在，我的机会来了."))
		attackchoice = 2

/obj/item/ego_weapon/city/donghwan/attack(mob/living/target, mob/living/carbon/human/user)
	force = initial(force)
	if(!CanUseEgo(user))
		return

	if(active)
		if(user == target)
			force = force*=0.3
			attackchoice = 3

	switch(attackchoice)
		if(1)
			Shove(target, user)
		if(2)
			CriticalMoment(target, user)
		if(3)
			Toughness(target, user)

	..()
	switch(attackchoice)
		if(5)
			attackchoice = 4
		if(4)
			attackchoice = 0
		else
			attackchoice = 1
			to_chat(user, span_notice("准备好了推击."))

/obj/item/ego_weapon/city/donghwan/proc/Shove(mob/living/target, mob/living/carbon/human/user)
	to_chat(user, span_notice("滚开."))

	playsound(src, 'sound/weapons/fixer/generic/nail2.ogg', 100, FALSE, 4)
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(2, 5), whack_speed, user)
	attackchoice = 5

/obj/item/ego_weapon/city/donghwan/proc/CriticalMoment(mob/living/target, mob/living/carbon/human/user)
	to_chat(user, span_notice("得手了."))
	playsound(src, 'sound/weapons/fixer/generic/nail1.ogg', 100, FALSE, 4)
	//Deals half of % of your sanity, inverted.
	force += force*((user.sanityhealth/user.maxSanity)-1)*-0.5
	attackchoice = 5

/obj/item/ego_weapon/city/donghwan/proc/Toughness(mob/living/target, mob/living/carbon/human/user)
	if(user.sanityhealth>= user.maxSanity*0.3)
		user.adjustSanityLoss(user.sanityhealth*0.71)
		to_chat(user, span_notice("感觉不赖."))
	else
		to_chat(user, span_notice("不该这么做的."))
		user.adjustSanityLoss(-user.sanityhealth*0.2)
	attackchoice = 0

