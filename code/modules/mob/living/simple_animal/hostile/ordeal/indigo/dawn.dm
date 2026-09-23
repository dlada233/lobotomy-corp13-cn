//Indigo dawns.
/mob/living/simple_animal/hostile/ordeal/indigo_dawn
	name = "未知侦察兵"
	desc = "拄着拐杖额高个子类人生物，穿着靛蓝色铠甲."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "indigo_dawn"
	icon_living = "indigo_dawn"
	icon_dead = "indigo_dawn_dead"
	faction = list("indigo_ordeal")
	maxHealth = 35
	health = 35
	move_to_delay = 1.3	//Super fast, but squishy and weak.
	stat_attack = DEAD
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 3
	melee_damage_upper = 4
	butcher_results = list(/obj/item/food/meat/slab/sweeper = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sweeper = 1)
	attack_verb_continuous = "刺"
	attack_verb_simple = "刺"
	attack_sound = 'sound/effects/ordeals/indigo/stab_1.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.8)
	blood_volume = BLOOD_VOLUME_NORMAL
	silk_results = list(/obj/item/stack/sheet/silk/indigo_simple = 1)

/mob/living/simple_animal/hostile/ordeal/indigo_dawn/AttackingTarget(atom/attacked_target)
	. = ..()
	if(. && isliving(attacked_target))
		var/mob/living/L = attacked_target
		if(L.stat != DEAD)
			if(L.health <= HEALTH_THRESHOLD_DEAD && HAS_TRAIT(L, TRAIT_NODEATH))
				devour(L)
		else
			devour(L)

/mob/living/simple_animal/hostile/ordeal/indigo_dawn/proc/devour(mob/living/L)
	if(!L)
		return FALSE
	if(SSmaptype.maptype in SSmaptype.citymaps)
		return FALSE
	visible_message(
		span_danger("[src]吞食[L]!"),
		span_userdanger("你吞食了[L], 恢复自身生命!"))
	if(istype(L, SWEEPER_TYPES))
		//Would have made it based on biotypes but that has its own issues.
		adjustBruteLoss(-20)
	else
		adjustBruteLoss(-(maxHealth/2))
	L.gib()
	return TRUE

/mob/living/simple_animal/hostile/ordeal/indigo_dawn/invis
	move_to_delay = 3	//These ones are slower because they're invisible
	alpha = 15

/mob/living/simple_animal/hostile/ordeal/indigo_dawn/skirmisher
	move_to_delay = 2	//These ones are slower because they move a little eratically
	ranged = 1
	retreat_distance = 3
	minimum_distance = 1

/mob/living/simple_animal/hostile/ordeal/indigo_dawn/OpenFire(atom/A)
	visible_message(span_danger("<b>[src]</b> 威胁地盯着 [A]!"))
	ranged_cooldown = world.time + ranged_cooldown_time
