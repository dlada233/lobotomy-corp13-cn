//This is a massive file and all the liu weapons kill humans while insane
/obj/item/ego_weapon/city/liu
	name = "Liu template"
	damtype = WHITE_DAMAGE


/obj/item/ego_weapon/city/liu/examine(mob/user)
	. = ..()
	. += span_notice("此武器可击杀精神崩溃者。")

/obj/item/ego_weapon/city/liu/attack(mob/living/target, mob/living/user)
	//Happens before the attack so you need to do another attack.
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.sanity_lost)
			H.death()
	..()

//Section 1&2, 6-5-4-2 as the grades
/obj/item/ego_weapon/city/liu/fire
	name = "六协会制式刀"
	desc = "六协会1科和2科的初级收尾人成员使用的武器."
	icon_state = "liublade"
	force = 14
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)
	swingstyle = WEAPONSWING_LARGESWEEP

/obj/item/ego_weapon/city/liu/fire/examine(mob/user)
	. = ..()
	. +="视野内每多一人伤害提升10%。"

/obj/item/ego_weapon/city/liu/fire/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	for(var/mob/living/carbon/human/friend in oview(user, 10))
		//Minor bonus for having multiple people around you
		if(friend.ckey && friend.stat != DEAD && friend != user)
			force += force*0.1	//+10% for each person around you
	..()
	force = initial(force)


/obj/item/ego_weapon/city/liu/fire/fist
	name = "六协会炎拳套"
	desc = "六协会1科和2科的资深收尾人成员使用的武器."
	icon_state = "liuglove"
	force = 17
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	swingstyle = WEAPONSWING_SMALLSWEEP

/obj/item/ego_weapon/city/liu/fire/spear
	name = "六协会长矛"
	desc = "六协会1科和2科的资深收尾人成员使用的武器，也被六协会2科的科长使用。"
	icon_state = "liuspear"
	force = 30
	reach = 2
	stuntime = 5
	attack_speed = 1
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)
	swingstyle = WEAPONSWING_THRUST


/obj/item/ego_weapon/city/liu/fire/sword
	name = "六协会科长佩剑"
	desc = "六协会1科的科长所使用的个人佩剑。"
	icon_state = "liusword"
	force = 33
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)
	swingstyle = WEAPONSWING_LARGESWEEP



//Section 4/5/6, 6-4
/obj/item/ego_weapon/city/liu/fist
	name = "六协会格斗拳套"
	icon_state = "liufist"
	desc = "六协会4、5、6科成员使用的拳套，需要武术训练才能有效使用。"
	force = 10
	attack_speed = 0.7
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)
	var/chain = 0
	var/activated
	hitsound = 'sound/weapons/fixer/generic/fist1.ogg'

	var/combo_time
	var/combo_wait = 10


/obj/item/ego_weapon/city/liu/fist/examine(mob/user)
	. = ..()
	. += span_notice("此武器具备轻攻击与重攻击。手持使用激活重攻击。连招如下：")
	. += span_notice("LLLLL - 5段速攻连击，以击退攻击收尾。")
	. += span_notice("H 	 - 蓄力拳击造成1.5倍伤害，对人类造成巨额耐力伤害。")
	. += span_notice("LH 	 - 范围火焰拳击。此攻击不击杀精神崩溃者。")
	. += span_notice("LLH 	 - 高伤连段，末段蓄力造成2倍伤害。")
	. += span_notice("LLLH  - 造成可观伤害。末段后撤2格。")
	. += span_notice("LLLLH - 高伤连段，末段无蓄力造成2倍伤害。")

/obj/item/ego_weapon/city/liu/fist/attack_self(mob/living/carbon/user)
	if(activated)
		activated = FALSE
		to_chat(user, span_danger("你取消了重攻击准备。"))
	else
		activated = TRUE
		to_chat(user, span_danger("你预备发动重攻击！"))


/obj/item/ego_weapon/city/liu/fist/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return

	if(world.time > combo_time)
		chain = 0
	combo_time = world.time + combo_wait

	var/during_windup //can't attack during windup
	if(during_windup)
		return

	//Setting chain and attack speed to 0
	chain+=1
	attack_speed = initial(attack_speed)

	//Teh Chain of attacks. See the examine for what each chain does.

	switch(chain)
		if(1)
			if(activated) //H - Solar Plexus attack
				to_chat(user, span_danger("你准备好猛击对手的腹腔神经丛."))
				during_windup = TRUE
				if(do_after(user, 5, target))
					during_windup = FALSE
					force *= 1.5
					hitsound = 'sound/weapons/fixer/generic/gen2.ogg'
					if(ishuman(target))
						target.Paralyze(20)
				else
					during_windup = FALSE
					return

		if(2)
			if(activated) //LH - Fire AOE
				to_chat(user, span_danger("你释放出一阵火焰."))
				hitsound = 'sound/weapons/fixer/generic/gen2.ogg'
				aoe(target, user)

		if(3)
			if(activated) //LLH - Higher damage windup attack
				to_chat(user, span_danger("你准备强力拳击."))
				during_windup = TRUE
				if(do_after(user, 5, target))
					during_windup = FALSE
					force *= 2
					hitsound = 'sound/weapons/fixer/generic/gen2.ogg'
				else
					during_windup = FALSE
					return

		if(4)
			if(activated) //LLLH - Fast hit and jump back
				to_chat(user, span_danger("你击中目标并后跳。"))
				force *= 1.5
				hitsound = 'sound/weapons/fixer/generic/gen2.ogg'
				hopback(user)

		if(5)
			if(!activated)
				knockback(target, user)
				hitsound = 'sound/weapons/fixer/generic/finisher2.ogg'
			else
				force*=2
				to_chat(user, span_danger("你全力击中目标！"))
				hitsound = 'sound/weapons/fixer/generic/finisher2.ogg'
			chain=0

	//Special attacks are slower.
	if(attack_speed == initial(attack_speed) && activated)
		attack_speed = 2
	. = ..()

	//Reset Everything
	if(activated)
		chain=0
		to_chat(user, span_danger("连段已重置。"))
		activated = FALSE
	force = initial(force)
	hitsound = initial(hitsound)


/obj/item/ego_weapon/city/liu/fist/proc/knockback(mob/living/target, mob/living/user)
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 3), whack_speed, user)

/obj/item/ego_weapon/city/liu/fist/proc/aoe(mob/living/target, mob/living/user)
	for(var/turf/T in view(force/5, target))
		if(prob(30))
			new /obj/effect/temp_visual/fire/fast(T)
		for(var/mob/living/L in T)
			if(L == user)
				continue
			L.deal_damage(force*0.5, damtype, user, attack_type = (ATTACK_TYPE_SPECIAL))

/obj/item/ego_weapon/city/liu/fist/proc/hopback(mob/living/carbon/user)
	var/dodgelanding
	if(user.dir == 1)
		dodgelanding = locate(user.x, user.y - 2, user.z)
	if(user.dir == 2)
		dodgelanding = locate(user.x, user.y + 2, user.z)
	if(user.dir == 4)
		dodgelanding = locate(user.x - 2, user.y, user.z)
	if(user.dir == 8)
		dodgelanding = locate(user.x + 2, user.y, user.z)
	user.throw_at(dodgelanding, 3, 2, spin = FALSE)


/obj/item/ego_weapon/city/liu/fist/vet
	name = "六协会资深格斗拳套"
	icon_state = "liufist_vet"
	force = 16
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)
