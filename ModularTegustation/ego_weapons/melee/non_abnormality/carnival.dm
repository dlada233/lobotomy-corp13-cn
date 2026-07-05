/obj/item/ego_weapon/city/carnival_spear
	name = "狂欢之矛"
	desc = "嘉年华用来追捕猎物的长矛."
	icon_state = "carnival_spear"
	inhand_icon_state = "carnival_spear"
	special = "对后巷生物造成双倍伤害. 如果使用者和目标人类单独在一起，则该武器能击晕人类."
	force = 17
	reach = 2
	attack_speed = 1
	stuntime = 5
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("whacks", "slashes")
	attack_verb_simple = list("whack", "slash")
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 60,
	)

	var/list/empowered_targets = list(
		/mob/living/simple_animal/hostile/aminion/shrimp,
		/mob/living/simple_animal/hostile/aminion/shrimp/soldier,
		/mob/living/simple_animal/hostile/ordeal,
		/mob/living/simple_animal/hostile/kcorp/drone,
		/mob/living/simple_animal/hostile/humanoid/blood,
	)

/obj/item/ego_weapon/city/carnival_spear/Initialize()
	. = ..()
	empowered_targets = typecacheof(empowered_targets)

/obj/item/ego_weapon/city/carnival_spear/attack(mob/living/target, mob/living/user)
	if(target.stat == DEAD)
		return
	var/initial_force = force
	if(is_type_in_typecache(target, empowered_targets))
		to_chat(user, span_nicegreen("你对[target.name]的攻击得到了增强!"))
		force *= 2
	..()
	force = initial_force
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/alone = TRUE
		for(var/mob/living/carbon/human/O in range(7, target))
			if(O == user || O == H)
				continue
			if(O.stat == DEAD || !O.client)
				continue
			else
				alone = FALSE
		if(alone)
			H.Knockdown(20)
			to_chat(user, span_nicegreen("你背刺了 [H.name]，将其击倒在地!"))
			to_chat(H, span_danger("你被 [user.name] 背刺了，被击倒!"))

/obj/item/ego_weapon/city/carnival_spear/weak
	name = "磨损的狂欢之矛"
	force = 11
	attribute_requirements = list()
