//Shi has 2 different modes. Dash Attacks and Boundary of Death.
//Shi Assassin (Current one being used right now) uses Boundary of death.

/obj/item/ego_weapon/city/shi_knife
	name = "し协会刀"
	desc = "四协二科刺客所用武器."
	special = "用这把武器攻击自己能瞬间杀死自己."
	icon_state = "shi_dagger"
	force = 20
	damtype = RED_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP

	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 60
	)
	var/force_update = 22
	var/static/suicide_used = list()

/obj/item/ego_weapon/city/shi_knife/attack(mob/living/target, mob/living/carbon/human/user)
	force = force_update
	if(target == user)
		if(user.ckey in suicide_used)
			to_chat(user, span_warning("再次自杀将有损你的荣耀."))
			return
		user.death()
		for(var/mob/M in GLOB.player_list)
			to_chat(M, span_userdanger("[uppertext(user.real_name)] 已光荣消散. 灰は灰に "))
		new /obj/effect/temp_visual/BoD(get_turf(target))
		suicide_used |= user.ckey
	if(!CanUseEgo(user))
		return
	..()

//Boundary of death users
//Grade 5
/obj/item/ego_weapon/city/shi_assassin
	name = "し协会手杖"
	desc = "四协二科使用的武器."
	special = "在手中使用此武器使自己停滞1秒，扣除25%的HP，并造成2倍青色伤害."
	icon_state = "shiassassin"
	force = 21
	attack_speed = 1.2
	damtype = RED_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP

	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60
							)
	var/ready = TRUE
	var/multiplier = 2


/obj/item/ego_weapon/city/shi_assassin/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return

	if(!ready)
		return
	ready = FALSE
	user.Immobilize(17)
	to_chat(user, span_userdanger("出."))
	force*=multiplier
	damtype = PALE_DAMAGE
	user.adjustBruteLoss(user.maxHealth*0.25)

	addtimer(CALLBACK(src, PROC_REF(Return), user), 5 SECONDS)

/obj/item/ego_weapon/city/shi_assassin/attack(mob/living/target, mob/living/carbon/human/user)
	..()
	if(force != initial(force))
		to_chat(user, span_userdanger("死亡的边缘."))
		new /obj/effect/temp_visual/BoD(get_turf(target))
		force = initial(force)
	damtype = initial(damtype)

/obj/item/ego_weapon/city/shi_assassin/proc/Return(mob/living/carbon/human/user)
	force = initial(force)
	ready = TRUE
	to_chat(user, span_notice("你的刀刃准备好了."))
	damtype = initial(damtype)

/obj/effect/temp_visual/BoD
	icon_state = "BoD"
	duration = 17 //in deciseconds
	randomdir = FALSE

//Grade 4
/obj/item/ego_weapon/city/shi_assassin/vet
	name = "し协会资深刺客刀"
	desc = "四协二科资深成员使用的武器. 它极其锋利."
	icon_state = "shiassassin_vet"
	force = 25
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 60
							)

//Grade 3
/obj/item/ego_weapon/city/shi_assassin/director
	name = "し协会科长刺客刀"
	desc = "し协会二科科长使用的武器. 它极其锋利."
	icon_state = "shiassassin_director"
	force = 31
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)

//Specialist Shi Blades (I had the sprites.)
/obj/item/ego_weapon/city/shi_assassin/sakura
	name = "し协会樱花刀"
	desc = "专为四协二科设计的特种刺客刀刃，用于刺杀高装甲目标，造成白色伤害."
	icon_state = "shi_sakura"
	damtype = WHITE_DAMAGE


/obj/item/ego_weapon/city/shi_assassin/serpent
	name = "し协会毒蛇刀"
	desc = "专为四协二科设计的特种刺客刀刃，用于刺杀高装甲目标，造成黑色伤害."
	icon_state = "shi_serpent"
	damtype = BLACK_DAMAGE


/obj/item/ego_weapon/city/shi_assassin/yokai
	name = "し协会妖怪刀"
	desc = "专为四协二科设计的特种刺客刀刃，用于刺杀高装甲目标，造成青色伤害."
	force = 9
	icon_state = "shi_yokai"
	damtype = PALE_DAMAGE

	multiplier = 4
