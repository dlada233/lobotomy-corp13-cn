//Like this so we can add a charge mechanic to one of them and have it carry down.
//All of these weapons are grade 4.
/obj/item/ego_weapon/city/cane
	name = "拐杖事务所 template"
	desc = "This is a template and should not be seen."
	force = 9
	damtype = WHITE_DAMAGE

	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")

	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 100,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 80,
	)

	charge = TRUE
	ability_type = ABILITY_ON_ACTIVATION
	charge_cost = 2
	charge_effect = "额外造成一次攻击伤害."
	successfull_activation = "你释放充能，对对手造成伤害!"

//Actual weapons
/obj/item/ego_weapon/city/cane/cane
	name = "拐杖事务所 - 拐杖"
	desc = "涌动能量的白色拐杖."
	icon_state = "cane_cane"
	inhand_icon_state = "cane_cane"
	force = 25
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")

	charge_cost = 8
	charge_effect = "治疗自己."
	successfull_activation = "你释放充能，治疗自己!"

/obj/item/ego_weapon/city/cane/cane/ChargeAttack(target, mob/living/carbon/human/user)
	..()
	user.adjustBruteLoss(-user.maxHealth*0.07)
	user.adjustSanityLoss(-user.maxSanity*0.07)
	addtimer(CALLBACK(src, PROC_REF(Return), user), 5 SECONDS)

/obj/item/ego_weapon/city/cane/cane/proc/Return(mob/living/carbon/human/user)
	to_chat(user, span_notice("You heal once more."))
	user.adjustBruteLoss(-user.maxHealth*0.07)
	user.adjustSanityLoss(-user.maxSanity*0.07)
	playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)
	var/turf/T = get_turf(src)
	new /obj/effect/temp_visual/justitia_effect(T)

/obj/item/ego_weapon/city/cane/claw
	name = "拐杖事务所 - 爪"
	desc = "涌动能量的白色爪子."
	icon_state = "cane_claw"
	inhand_icon_state = "cane_claw"
	force = 10
	attack_speed = 0.3
	attack_verb_continuous = list("cuts", "slices")
	attack_verb_simple = list("cut", "slice")

	charge_cost = 3
	charge_effect = "短距离冲刺."
	successfull_activation = "你释放充能，向前冲刺!"

	var/dodgelanding

/obj/item/ego_weapon/city/cane/claw/ChargeAttack(target, mob/living/user)
	..()
	if(user.dir == NORTH)
		dodgelanding = locate(user.x, user.y + 5, user.z)
	if(user.dir == SOUTH)
		dodgelanding = locate(user.x, user.y - 5, user.z)
	if(user.dir == EAST)
		dodgelanding = locate(user.x + 5, user.y, user.z)
	if(user.dir == WEST)
		dodgelanding = locate(user.x - 5, user.y, user.z)
	user.throw_at(dodgelanding, 3, 2, spin = FALSE)


/obj/item/ego_weapon/city/cane/fist
	name = "拐杖事务所 - 手甲"
	desc = "涌动能量的白色手甲."
	icon_state = "cane_gauntlet"
	inhand_icon_state = "cane_gauntlet"
	force = 25
	attack_verb_continuous = list("smashes", "bashes")
	attack_verb_simple = list("smash", "bash")

	charge_cost = 8
	charge_effect = "增强此武器的攻击."
	successfull_activation = "你释放能量，为你的手甲提供动力!"

/obj/item/ego_weapon/city/cane/fist/ChargeAttack(target, mob/living/carbon/human/user)
	..()
	force = force*2
	addtimer(CALLBACK(src, PROC_REF(Return), user), 2 SECONDS)

/obj/item/ego_weapon/city/cane/fist/proc/Return(mob/living/user)
	force = initial(force)

/obj/item/ego_weapon/city/cane/briefcase
	name = "拐杖事务所 - 公文包"
	desc = "被拐杖事务所所使用的公文包."
	icon_state = "cane_briefcase"
	inhand_icon_state = "cane_briefcase"
	force = 15
	attack_verb_continuous = list("smashes", "bashes")
	attack_verb_simple = list("smash", "bash")

	charge_cost = 4
	charge_effect = "击退敌人!"
	successfull_activation = "你释放能量，将附近的所有敌人击退!"

/obj/item/ego_weapon/city/cane/briefcase/ChargeAttack(target, mob/living/user)
	..()
	goonchem_vortex(get_turf(src), 1, 4)

	for(var/turf/T in orange(2, user))
		new /obj/effect/temp_visual/smash_effect(T)

	for(var/mob/living/L in range(2, user))
		if(L == user)
			continue
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(!H.sanity_lost)
				continue
		L.deal_damage(10, WHITE_DAMAGE, user, attack_type = (ATTACK_TYPE_SPECIAL))

