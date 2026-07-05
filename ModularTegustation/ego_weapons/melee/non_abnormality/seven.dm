//Seven Association; the information gathering fixer office.
//They deal 25% less damage, on average.
//Hit something 7 times (3 with the cane) to store a target, and get its information stored
//You can examine the weapon to see the HP of the stored abno on last hit
//If a target is stored, deal 50% more damage to it

//Normal is grade 5, Vet is Grade 4, director equipment is grade 2.

/obj/item/ego_weapon/city/seven
	name = "七协会战刀"
	desc = "七名协会成员使用的带护手的刀具 ."
	special = "对已储存信息的目标造成额外50%伤害. \
				在手中使用以查看目标及其当前生命状态."
	icon_state = "sevenassociation"
	inhand_icon_state = "sevenassociation"
	force = 18
	damtype = BLACK_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP

	var/stored_target
	var/stored_target_hp
	var/hit_number
	var/hit_target = 7
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 60,
	)


/obj/item/ego_weapon/city/seven/examine(mob/user)
	. = ..()
	. += span_notice("攻击敌人 [hit_target] 次以储存目标信息.")

/obj/item/ego_weapon/city/seven/attack_self(mob/living/carbon/human/user)
	..()
	if(!stored_target)
		to_chat(user, span_notice("你没有储存任何目标信息."))
		return

	//not enough info for vitals
	var/mob/living/Y = stored_target
	if(hit_number <= hit_target-1)
		to_chat(user, span_notice("当前目标是 [Y.name]. 生命体征信息不足."))
		return

	//Reset if they died, don't reset if you don't have info on them.
	if(Y.stat == DEAD)
		to_chat(user, span_notice("目标已经过期，清除信息中."))
		stored_target = null
		return

	//Get a very accurate % of their HP
	var/printhealth = stored_target_hp/Y.maxHealth*100
	to_chat(user, span_notice("当前目标是 [Y.name]. 他最后的健康状况是 [printhealth]%"))


/obj/item/ego_weapon/city/seven/attack(mob/living/target, mob/living/user)
	if(hit_number >= hit_target && target == stored_target)
		force*=1.5

	..()

	force = initial(force)
	if(target != stored_target)
		stored_target = target
		to_chat(user, span_notice("你追寻一个新的目标."))
		hit_number = 0
		return
	else
		hit_number++
		stored_target_hp = target.health

	if(hit_number == hit_target-1)
		to_chat(user, span_danger("目标信息已分析，战斗效率提升50%."))


/obj/item/ego_weapon/city/seven/vet
	name = "七协会资深战刀"
	desc = "七协会资深收尾人所使用的武器."
	icon_state = "sevenassociation_vet"
	inhand_icon_state = "sevenassociation_vet"
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	force = 22
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)

//Director weapons. If you use both; you can actually get info on two targets at once, but it requires
/obj/item/ego_weapon/city/seven/director
	name = "七协会科长刀"
	desc = "七协会分支科长使用的刀."
	icon_state = "sevenassociation_director"
	inhand_icon_state = "sevenassociation_director"
	hitsound = 'sound/weapons/rapierhit.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	force = 31
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/ego_weapon/city/seven/cane
	name = "七协会科长手杖"
	desc = "七协会分支科长使用的手杖，能够显著加快信息收集速度."
	special = "攻击敌人3次以储存其信息. \
				对已储存信息的目标造成50%额外伤害. \
				在手中使用以查看储存的目标及其当前生命状态."
	icon_state = "sevenassociation_cane"
	inhand_icon_state = "sevenassociation_cane"
	force = 28	//Faster info gain,
	hit_target = 3
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 100
							)

//Seven Fencing - Lack the Health gaining ability, and gain an ability similar to Capo, where they do bonus damage when attacking the same person.
/obj/item/ego_weapon/city/seven_fencing
	name = "七协会决斗剑"
	desc = "七协会使用的决斗剑，用于摧毁单一目标."
	special = "该武器在对同一目标进行多次攻击时，造成的伤害会增加35%."
	icon_state = "sevenfencing"
	hitsound = 'sound/weapons/rapierhit.ogg'
	force = 19
	damtype = BLACK_DAMAGE
	swingstyle = WEAPONSWING_THRUST

	var/fencing_target
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60
							)


/obj/item/ego_weapon/city/seven_fencing/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(!fencing_target || fencing_target != M)
		fencing_target = M
		to_chat(user, span_notice("目标已获取."))
	else
		force *= 1.35
	..()
	force = initial(force)

/obj/item/ego_weapon/city/seven_fencing/vet
	name = "七协会资深决斗剑"
	desc = "七协会资深成员使用的决斗剑，用于摧毁单一目标."
	icon_state = "sevenfencing_vet"
	force = 22
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/city/seven_fencing/dagger
	name = "七协会决斗匕首"
	desc = "七协会资深成员使用的决斗匕首，用于摧毁单一目标."
	special = "该武器在对同一目标进行多次攻击时，造成的伤害会增加35%."
	icon_state = "sevenfencing_dagger"
	force = 16
	attack_speed = 0.5
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 100
							)

