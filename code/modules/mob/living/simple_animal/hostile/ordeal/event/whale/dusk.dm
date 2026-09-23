/mob/living/simple_animal/hostile/ordeal/lcb_pallid
	name = "苍白物体"
	desc = "一名来自公司的行动人员，身上沾满了有机物质."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "pallid_lcb"
	icon_dead = "dead_generic"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	robust_searching = TRUE
	see_in_dark = 7
	vision_range = 12
	aggro_vision_range = 20
	maxHealth = 500
	health = 500
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.2)
	stat_attack = HARD_CRIT
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 10
	melee_damage_upper = 18
	faction = list("whale")
	attack_verb_continuous = "击打"
	attack_verb_simple = "击打"
	attack_sound = 'sound/weapons/fixer/generic/club1.ogg'
	butcher_results = list(/obj/item/food/meat/slab/mermaid = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/pallid = 2)
	var/say_lines = list(
		"--.-.-",
		"-... .-",
		"-.-. ..-",
		".--. .",
	)

/mob/living/simple_animal/hostile/ordeal/lcb_pallid/Aggro()
	..()
	var/line = pick(say_lines)
	say(line)

/mob/living/simple_animal/hostile/ordeal/lcb_pallid/death(gibbed)
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	..()

/mob/living/simple_animal/hostile/ordeal/lcb_pallid/pistol
	desc = "一名公司行动人员，浑身沾满有机物质，这家伙手里还有一把枪!"
	icon_state = "pallid_gunner"
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 0.2)
	melee_damage_lower = 3
	ranged = TRUE
	rapid = 3
	rapid_fire_delay = 2.5
	check_friendly_fire = 1
	projectiletype = /obj/projectile/ego_bullet/fivedamage
	projectilesound = 'sound/weapons/gun/pistol/shot.ogg'
	attack_sound = 'sound/weapons/fixer/generic/gen1.ogg'
