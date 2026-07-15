/obj/item/assoc_skill_granter/liu
	name = "六协会 Skill Book"
	icon_state = "liu_book"

/obj/item/assoc_skill_granter/liu/attack_self(mob/living/carbon/human/user)
	if(!(user?.mind?.assigned_role in allowedjob))
		to_chat(user, span_notice("Only association members of authorized ranking are allowed to read this book!"))
		return ..()

	to_chat(user, span_greenannounce("You finish reading the book having learned three 六协会 skills. <br>Flamekissed which allows you to thrive in the heat <br>Ember which allows you to set those around you alight. <br>Burn Swap which allows you to swap burn and white damage on those close to you"))

	var/datum/action/G = new /datum/action/innate/flamekiss
	G.Grant(user)
	G = new /datum/action/cooldown/ember
	G.Grant(user)
	G = new /datum/action/cooldown/doubleburn
	G.Grant(user)

	qdel(src)

/obj/item/assoc_skill_granter/liu/veteran
	name = "六协会 Veteran - 协会资深收尾人 Skill Book"
	allowedjob = list("Association Veteran - 协会资深收尾人")

/obj/item/assoc_skill_granter/liu/veteran/attack_self(mob/living/carbon/human/user)
	if(!(user?.mind?.assigned_role in allowedjob))
		to_chat(user, span_notice("Only association members of authorized ranking are allowed to read this book!"))
		return ..()

	to_chat(user, span_greenannounce("You finish reading the book having learned five 六协会 skills. <br>Flamekissed which allows you to thrive in the heat <br>Ember which allows you to set those around you alight. <br>Burn Swap which allows you to swap burn and white damage on those close to you. <br> Blast Spear which increases your speed for each person around you. <br> Flare which sets everything around you ablaze."))

	var/datum/action/G = new /datum/action/innate/flamekiss
	G.Grant(user)
	G = new /datum/action/cooldown/ember
	G.Grant(user)
	G = new /datum/action/cooldown/doubleburn
	G.Grant(user)
	G = new /datum/action/cooldown/bspear
	G.Grant(user)
	G = new /datum/action/cooldown/flare
	G.Grant(user)

	qdel(src)

/obj/item/assoc_skill_granter/liu/director
	name = "六协会 Director Skill Book"
	allowedjob = list("Association Section Director-协会科室主管")

/obj/item/assoc_skill_granter/liu/director/attack_self(mob/living/carbon/human/user)
	if(!(user?.mind?.assigned_role in allowedjob))
		to_chat(user, span_notice("Only association members of authorized ranking are allowed to read this book!"))
		return ..()

	to_chat(user, span_greenannounce("You finish reading the book having learned six 六协会 skills. <br>Flamekissed which allows you to thrive in the heat <br>Ember which allows you to set those around you alight. <br>Burn Swap which allows you to swap burn and white damage on those close to you. <br> Blast Spear which increases your speed for each person around you. <br> Flare which sets everything around you ablaze. <br> Final Burn which allows you to double the burn on anyone standing atop the blazes"))

	var/datum/action/G = new /datum/action/innate/flamekiss
	G.Grant(user)
	G = new /datum/action/cooldown/ember
	G.Grant(user)
	G = new /datum/action/cooldown/doubleburn
	G.Grant(user)
	G = new /datum/action/cooldown/bspear
	G.Grant(user)
	G = new /datum/action/cooldown/flare
	G.Grant(user)
	G = new /datum/action/cooldown/finalburn
	G.Grant(user)

	qdel(src)
