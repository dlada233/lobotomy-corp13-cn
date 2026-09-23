/mob/living/simple_animal/hostile/ordeal/indigo_dusk
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_dead = "sweeper_dead"
	faction = list("indigo_ordeal")
	maxHealth = 600
	health = 600
	stat_attack = DEAD
	melee_damage_type = RED_DAMAGE
	rapid_melee = 1
	melee_damage_lower = 5
	melee_damage_upper = 7
	butcher_results = list(/obj/item/food/meat/slab/sweeper = 2)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sweeper = 1)
	silk_results = list(/obj/item/stack/sheet/silk/indigo_elegant = 1,
						/obj/item/stack/sheet/silk/indigo_advanced = 2,
						/obj/item/stack/sheet/silk/indigo_simple = 4)
	attack_verb_continuous = "刺"
	attack_verb_simple = "刺"
	attack_sound = 'sound/effects/ordeals/indigo/stab_1.ogg'
	blood_volume = BLOOD_VOLUME_NORMAL
	can_patrol = TRUE

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/white
	name = "\proper 指挥官 阿黛尔海德" //Commander Adelheide
	maxHealth = 700
	health = 700
	desc = "手持白色大剑的瘦高人形."
	icon_state = "adelheide"
	icon_living = "adelheide"
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 16
	melee_damage_upper = 18
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0.7)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sweeper = 1)

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/white/Initialize(mapload)
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		guaranteed_butcher_results += list(/obj/item/head_trophy/indigo_head/white = 1)

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/white/CanAttack(atom/the_target)
	if(ishuman(the_target))
		var/mob/living/carbon/human/L = the_target
		if(L.sanity_lost && L.stat != DEAD)
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/black
	name = "\proper 指挥官 玛利亚" //Commander Maria
	desc = "手持黑色大锤的瘦高人形."
	icon_state = "maria"
	icon_living = "maria"
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 16
	melee_damage_upper = 18
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sweeper = 1)

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/black/Initialize(mapload)
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		guaranteed_butcher_results += list(/obj/item/head_trophy/indigo_head/black = 1)

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/red
	name = "\proper 指挥官 雅克" //Commander Jacques
	desc = "带着红色利爪的瘦高人形."
	icon_state = "jacques"
	icon_living = "jacques"
	rapid_melee = 4
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 0.7)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sweeper = 1)

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/red/Initialize(mapload)
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		guaranteed_butcher_results += list(/obj/item/head_trophy/indigo_head = 1)


/mob/living/simple_animal/hostile/ordeal/indigo_dusk/pale
	name = "\proper 指挥官 西尔维那" //Commander Silvina
	desc = "带着发光蓝色拳头的瘦高人形."
	icon_state = "silvina"
	icon_living = "silvina"
	rapid_melee = 2
	melee_damage_type = PALE_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 0.5)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sweeper = 1)

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/pale/Initialize(mapload)
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		guaranteed_butcher_results += list(/obj/item/head_trophy/indigo_head/pale = 1)

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/Initialize(mapload)
	. = ..()
	var/units_to_add = list(
		/mob/living/simple_animal/hostile/ordeal/indigo_noon = 1,
		)
	AddComponent(/datum/component/ai_leadership, units_to_add)

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/Aggro()
	. = ..()
	a_intent_change(INTENT_HARM)

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/LoseAggro()
	. = ..()
	a_intent_change(INTENT_HELP) //so that they dont get body blocked by their kin outside of combat

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/AttackingTarget(atom/attacked_target)
	. = ..()
	if(. && isliving(attacked_target))
		var/mob/living/L = attacked_target
		if(L.stat != DEAD)
			if(L.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(L, TRAIT_NODEATH))
				devour(L)
		else
			devour(L)

/mob/living/simple_animal/hostile/ordeal/indigo_dusk/proc/devour(mob/living/L)
	if(!L)
		return FALSE
	visible_message(
		span_danger("[src]吞食了[L]!"),
		span_userdanger("你吞食了[L]，恢复了自己!"))
	if(istype(L, SWEEPER_TYPES))
		adjustBruteLoss(-20)
	else
		adjustBruteLoss(-(maxHealth/2))
	L.gib()
	return TRUE
