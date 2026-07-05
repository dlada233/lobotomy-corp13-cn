//Jeong's Office - Grade 5, use in hand to cut your HP by 10%. Next attack deals 5x damage
//The brightest stars last half as long
/obj/item/ego_weapon/city/jeong
	name = "正事务所胁差"
	desc = "便于随身携带的短刀，赌场斗殴时能派上用场。"
	special = "手持使用消耗20%生命值，5秒内下次攻击造成3倍伤害。此武器可收纳于EGO腰带。"
	icon_state = "jeong_fixer"
	force = 15
	attack_speed = 0.7
	damtype = BLACK_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP

	attack_verb_continuous = list("slices", "stabs")
	attack_verb_simple = list("slice", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 60,
	)
	var/ready = TRUE


/obj/item/ego_weapon/city/jeong/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return

	if(!ready)
		return
	ready = FALSE
	to_chat(user, span_userdanger("夜之低徊."))
	force*=3
	user.adjustBruteLoss(user.maxHealth*0.2)
	addtimer(CALLBACK(src, PROC_REF(Return), user), 5 SECONDS)

/obj/item/ego_weapon/city/jeong/attack(mob/living/target, mob/living/carbon/human/user)
	..()
	if(force != initial(force))
		to_chat(user, span_userdanger("昼之高昂."))
		force = initial(force)

/obj/item/ego_weapon/city/jeong/proc/Return(mob/living/carbon/human/user)
	ready = TRUE
	force = initial(force)
	to_chat(user, span_notice("刀刃已就绪."))

//Grade 4
/obj/item/ego_weapon/city/jeong/large
	name = "正事务所武士刀"
	desc = "轻盈易挥的长刀，平息纷争的利器。"
	icon_state = "jeong_long"
	force = 35
	attack_speed = 1.5
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)
