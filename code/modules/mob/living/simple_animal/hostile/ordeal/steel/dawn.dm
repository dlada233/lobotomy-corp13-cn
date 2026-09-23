//G corp remenants, Survivors of the Smoke War
//Their function is as common cannon fodder. Manager buffs make them much more effective in battle.
/mob/living/simple_animal/hostile/ordeal/steel_dawn
	name = "G公司残兵"
	desc = "一名来自前G公司的虫化员工，据说这些人在烟霾战争后组成了一个街头帮派。"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "gcorp1"
	icon_living = "gcorp1"
	icon_dead = "gcorp_corpse"
	faction = list("Gene_Corp")
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	maxHealth = 70
	health = 70
	melee_damage_type = RED_DAMAGE
	vision_range = 8
	move_to_delay = 2.2
	melee_damage_lower = 4
	melee_damage_upper = 6
	wander = FALSE
	attack_verb_continuous = "捅刺"
	attack_verb_simple = "捅刺"
	footstep_type = FOOTSTEP_MOB_SHOE
	a_intent = INTENT_HELP
	possible_a_intents = list(INTENT_HELP, INTENT_HARM)
	//similar to a human
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/buggy = 2)
	silk_results = list(/obj/item/stack/sheet/silk/steel_simple = 1)

/mob/living/simple_animal/hostile/ordeal/steel_dawn/Initialize()
	. = ..()
	attack_sound = "sound/effects/ordeals/steel/gcorp_attack[pick(1,2,3)].ogg"
	if(!istype(src, /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon)) //due to being a root of noon
		icon_living = "gcorp[pick(1,2,3,4)]"
		icon_state = icon_living

/mob/living/simple_animal/hostile/ordeal/steel_dawn/Life()
	. = ..()
	//Passive regen when below 50% health.
	if(health <= maxHealth*0.5 && stat != DEAD)
		adjustBruteLoss(-1)
		if(!target)
			adjustBruteLoss(-3)

	//Soldiers when off duty will let eachother move around.
/mob/living/simple_animal/hostile/ordeal/steel_dawn/Aggro()
	. = ..()
	a_intent_change(INTENT_HARM)

/mob/living/simple_animal/hostile/ordeal/steel_dawn/LoseAggro()
	. = ..()
	a_intent_change(INTENT_HELP)
