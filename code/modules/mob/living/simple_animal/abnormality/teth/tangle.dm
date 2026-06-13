/mob/living/simple_animal/hostile/abnormality/tangle
	name = "长发缠节"
	desc = "一堆头发里好像有一颗被砍下来的头."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "tangle"
	icon_living = "tangle"
	portrait = "tangle"
	maxHealth = 400
	health = 400
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 0		//Doesn't attack
	melee_damage_upper = 0
	rapid_melee = 2
	melee_damage_type = WHITE_DAMAGE
	stat_attack = HARD_CRIT
	faction = list("hostile")
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 80,
		ABNORMALITY_WORK_INSIGHT = list(50, 50, 40, 40, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 40, 40, 40),
		ABNORMALITY_WORK_REPRESSION = list(50, 50, 40, 40, 40),
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/sloth
	ego_list = list(
		/datum/ego_datum/weapon/rapunzel,
		/datum/ego_datum/armor/rapunzel,
	)
	gift_type =  /datum/ego_gifts/rapunzel
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	observation_prompt = "四千九百五十一……<br>\
		四千九百五十二……<br>\
		你我之间的时光……<br>\
		你放下了那么多头发，你是如此爱我……<br>\
		把头发放下来。好让我逃离这地狱。<br>\
		头发，放下来吧。<br>\
		把头发放下来。"
	observation_choices = list(
		"压制异想体" = list(FALSE, "我们不该靠近异想体。<br>\
			但异想体对你的回复并不满意。<br>\
			环绕你的头发开始悄悄向你袭来，发动攻击！<br>\
			那间缠满头发的牢房变成了一摊血泊。"),
		"顺从其意" = list(TRUE, "四千九百九十七……<br>\
			四千九百九十八……<br>\
			四千九百九十九……"),
	)

	var/chosen
	var/instinct_count
	var/list/hair_list = list()

/mob/living/simple_animal/hostile/abnormality/tangle/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/tangle/CanAttack(atom/the_target)
	return FALSE

//Grab a list of all agents and picks one
/mob/living/simple_animal/hostile/abnormality/tangle/Initialize()
	. = ..()
	var/list/potentialmarked = list()
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		if(HAS_TRAIT(usr, TRAIT_WORK_FORBIDDEN)) //Don't get non agents
			continue
		potentialmarked += L

	if(length(potentialmarked) <= 1) //If there's only one or none of you, then don't do it. I'm not that evil.
		return
	chosen = pick(potentialmarked)



/mob/living/simple_animal/hostile/abnormality/tangle/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	// If your'e the chosen, lower
	if(user == chosen)
		datum_reference.qliphoth_change(-1)
		icon_state = "tangleawake"
		return

	if(work_type == ABNORMALITY_WORK_INSTINCT)
		instinct_count+=1
		if((instinct_count==3) || (instinct_count == 6))
			datum_reference.qliphoth_change(-1)
			icon_state = "tangleawake"

/mob/living/simple_animal/hostile/abnormality/tangle/BreachEffect()
	..()
	icon_state = "tangle"
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	new /obj/structure/spreading/tangle_hair (src)


/mob/living/simple_animal/hostile/abnormality/tangle/death()
	for(var/V in hair_list)
		qdel(V)
		hair_list-=V
	..()


// Hair turf
/obj/structure/spreading/tangle_hair
	gender = PLURAL
	name = "金发"
	desc = "一撮金发."
	icon = 'icons/effects/effects.dmi'
	icon_state = "tanglehair"
	anchored = TRUE
	density = FALSE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	max_integrity = 20
	base_icon_state = "tanglehair"
	var/mob/living/simple_animal/hostile/abnormality/tangle/connected_abno

/obj/structure/spreading/tangle_hair/Initialize()
	. = ..()

	//Stolen from Snow White's. Thanks Para!
	if(!connected_abno)
		connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/tangle) in GLOB.abnormality_mob_list
	if(connected_abno)
		connected_abno.hair_list += src
	expand()


/obj/structure/spreading/tangle_hair/expand()
	addtimer(CALLBACK(src, PROC_REF(expand)), 5 SECONDS)
//	if(connected_abno.hair_list.len>=150)
// 		return
	..()

/obj/structure/spreading/tangle_hair/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.apply_damage(1, WHITE_DAMAGE, null, H.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		if(prob(10))
			H.Immobilize(5)
			to_chat(H, span_warning("你陷进了头发中!"))
