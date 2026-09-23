// Gold Dawn - Commander that heals its minions
/mob/living/simple_animal/hostile/ordeal/fallen_amurdad_corrosion
	name = "堕落捕蝇草"
	desc = "一名脑叶公司一级员工，不知为何遭到了异想体腐蚀."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "amurdad_corrosion"
	icon_living = "amurdad_corrosion"
	icon_dead = "amurdad_corrosion_dead"
	faction = list("gold_ordeal")
	maxHealth = 120
	health = 120
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 5
	melee_damage_upper = 7
	pixel_x = -8
	base_pixel_x = -8
	attack_verb_continuous = "击打"
	attack_verb_simple = "击打"
	attack_sound = 'sound/abnormalities/ebonyqueen/attack.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/corroded = 1)
	speed = 1 //slow as balls
	move_to_delay = 20
	ranged = TRUE
	rapid = 2
	rapid_fire_delay = 10
	projectiletype = /obj/projectile/ego_bullet/ego_nightshade/healing //no friendly fire, baby!
	projectilesound = 'sound/weapons/bowfire.ogg'

/mob/living/simple_animal/hostile/ordeal/fallen_amurdad_corrosion/Initialize(mapload)
	. = ..()
	var/list/units_to_add = list(
		/mob/living/simple_animal/hostile/ordeal/beanstalk_corrosion = 3
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 8, TRUE)

/mob/living/simple_animal/hostile/ordeal/beanstalk_corrosion
	name = "寻找杰克的豆茎"
	desc = "一名被异想体腐化的脑叶公司员工."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "beanstalk"
	icon_living = "beanstalk"
	icon_dead = "beanstalk_dead"
	faction = list("gold_ordeal")
	maxHealth = 60
	health = 60
	melee_reach = 2 //Spear = long range
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 3
	melee_damage_upper = 5
	attack_sound = 'sound/weapons/ego/spear1.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	attack_verb_continuous = "刺捅"
	attack_verb_simple = "刺捅"
	damage_coeff = list(RED_DAMAGE = 0.9, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/food/meat/slab/corroded = 1)
