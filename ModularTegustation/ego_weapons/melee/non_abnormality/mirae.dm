//Grade 3. They're pretty strong
/obj/item/ego_weapon/city/mirae
	name = "未来拐杖"
	desc = "一根优雅的拐杖，顶部印有未来人寿保险的标志."
	special = "击杀敌人，然后治疗自己，并获得一笔收入. 该武器20%的伤害是青色伤害."
	icon_state = "miraecane"
	force = 25
	damtype = WHITE_DAMAGE	//Also does a small bit of pale, because lawyers hurt your mind and soul.

	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 100,
		TEMPERANCE_ATTRIBUTE = 100,
		JUSTICE_ATTRIBUTE = 80,
	)
	var/ahn_amount = 300
	var/boxchance = 10

/obj/item/ego_weapon/city/mirae/attack(mob/living/target, mob/living/carbon/human/user)
	var/living = FALSE
	if(!CanUseEgo(user))
		return
	if(target.stat != DEAD)
		living = TRUE
	target.deal_damage(force*0.2, PALE_DAMAGE, user, attack_type = (ATTACK_TYPE_MELEE))
	..()

	if(target.stat == DEAD && living)
		to_chat(user, span_minorannounce("Payday!!!"))
		var/obj/item/holochip/C = new (get_turf(src))
		C.credits = rand(ahn_amount/4,ahn_amount)
		//10% chance for this
		if(prob(boxchance))
			new /obj/item/rawpe(get_turf(src))
		user.adjustBruteLoss(-25)


//Grade 3, but does less damage with a way better payout
/obj/item/ego_weapon/city/mirae/page
	name = "未来人寿保险文件"
	desc = "人寿保险文件，非常昂贵，应该能给你带来不错的回报。"
	icon_state = "insurance"
	force = 22
	damtype = WHITE_DAMAGE	//Also does a small bit of pale, because lawyers eat your soul.

	ahn_amount = 700
	boxchance = 30
