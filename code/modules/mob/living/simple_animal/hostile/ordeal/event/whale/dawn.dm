/mob/living/simple_animal/hostile/ordeal/mermaid_porous
	name = "穴掌鲸人鱼" // 游戏内贴图为‘鲸人鱼’
	desc = "来自浑浊而腥臭的旋转着的蓝色湖域深处的生物."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "merm"
	icon_living = "merm"
	icon_dead = "merm_dead"
	faction = list("whale")
	pixel_x = -16
	pixel_y = -8
	health = 40//TODO: increase HP but make nearby mermaids lose health on death
	maxHealth = 40
	melee_damage_type = BLACK_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	melee_damage_lower = 3
	melee_damage_upper = 4
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	attack_verb_continuous = "抓挠"
	attack_verb_simple = "抓挠"
	attack_sound = 'sound/creatures/lc13/lake_entity/mermaid_slash.ogg'
	speak_emote = list("burbles")
	ranged = 1
	check_friendly_fire = 1
	projectiletype = /obj/projectile/water_ball
	projectilesound = 'sound/creatures/lc13/lake_entity/shot_2.ogg'
	butcher_results = list(/obj/item/food/meat/slab/mermaid = 1)//placeholder, make mermaid ice cream/oil later
	var/aiming

/mob/living/simple_animal/hostile/ordeal/mermaid_porous/OpenFire()
	if(aiming)
		return
	AimAttack(target)
	..()
	if(aiming)
		aiming = FALSE

/mob/living/simple_animal/hostile/ordeal/mermaid_porous/proc/AimAttack(target)
	playsound(src, 'sound/creatures/lc13/lake_entity/shot_1.ogg', 100)
	aiming = TRUE
	flick("merm_open", src)
	sleep(5)

/mob/living/simple_animal/hostile/ordeal/mermaid_porous/soldier
	name = "穴掌鲸士兵人鱼"
	desc = "来自浑浊而腥臭的旋转着的蓝色湖域深处的生物. 这个家伙有四只眼睛!"
	health = 80
	maxHealth = 80
	melee_damage_lower = 5
	melee_damage_upper = 6
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/mermaid = 2)
