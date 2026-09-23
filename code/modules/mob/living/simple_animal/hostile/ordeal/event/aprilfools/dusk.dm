/mob/living/simple_animal/hostile/ordeal/salmon_dusk
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	faction = list("shrimp")
	health = 420
	maxHealth = 420
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 7
	melee_damage_upper = 9
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "拳击"
	attack_verb_simple = "拳击"
	attack_sound = 'sound/weapons/punch4.ogg'
	speak_emote = list("burbles")
	can_patrol = TRUE

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/Initialize(mapload)
	. = ..()
	var/units_to_add = list(
		/mob/living/simple_animal/hostile/ordeal/shrimp_soldier = 1,
		/mob/living/simple_animal/hostile/ordeal/shrimp_rifleman = 1,
		/mob/living/simple_animal/hostile/ordeal/shrimp = 1,
		)
	AddComponent(/datum/component/ai_leadership, units_to_add)

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/red
	name = "机枪虾"
	desc = "一只看了太多《壮志凌云》的虾."
	icon_state = "wellcheers_bad"
	icon_living = "wellcheers_bad"
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1)
	ranged = 5
	rapid = 20
	rapid_fire_delay = 0.4
	move_to_delay = 5
	retreat_distance = 2
	minimum_distance = 3
	casingtype = /obj/item/ammo_casing/caseless/red_minigun
	projectilesound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	var/shooting = FALSE

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/red/Move()
	if(shooting)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/red/Goto(target, delay, minimum_distance)
	if(shooting)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/red/DestroySurroundings()
	if(shooting)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/red/OpenFire(atom/A)
	shooting = TRUE
	return ..()

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/red/Initialize()
	. = ..()
	color = COLOR_RED

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/red/Life()
	. = ..()
	if(shooting)
		SLEEP_CHECK_DEATH(0.4)
		shooting = FALSE

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/white
	name = "狙击虾"
	desc = "被同伴们称之为 \"白色捕虾神\"."
	icon_state = "wellcheers_bad"
	icon_living = "wellcheers_bad"
	melee_damage_type = WHITE_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	ranged = 2.5
	move_to_delay = 5
	vision_range = 27 //three screens away
	retreat_distance = 8
	minimum_distance = 3
	casingtype = /obj/item/ammo_casing/caseless/white_sniper
	projectilesound = 'sound/weapons/gun/pistol/shot_alt.ogg'

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/white/Initialize()
	. = ..()
	var/white_icon //To actually make it white I gotta do this sadly
	var/icon/modified_icon = icon("[src.icon]", src.icon_state)
	modified_icon.MapColors(0.8,0.8,0.8, 0.2,0.2,0.2, 0.8,0.8,0.8, 0,0,0)
	white_icon = modified_icon
	icon = white_icon

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/black
	name = "虾捅者" //shrimp shanker 此处可能隐晦梗，shanker可以指自制刀捅人的人，但也可以是一种同性性行为，下方描述佐证了后者含义
	desc = "请问你喜欢'鱼条'嘛?" //Do you like fish sticks 出自南方公园，谐音性笑话，fish sticks → fish dick
	icon_state = "wellcheers_bad"
	icon_living = "wellcheers_bad"
	melee_damage_type = BLACK_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.8)
	rapid_melee = 4
	move_to_delay = 2.4
	melee_damage_lower = 5
	melee_damage_upper = 6
	attack_verb_continuous = "捅"
	attack_verb_simple = "捅"
	attack_sound = 'sound/weapons/purple_tear/stab2.ogg'
	var/fast_mode = FALSE

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/black/Initialize()
	. = ..()
	color = COLOR_PURPLE

// Modified patrolling
/mob/living/simple_animal/hostile/ordeal/salmon_dusk/black/patrol_select()
	fast_mode = TRUE
	var/list/target_turfs = list()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.z != z) // Not on our level
			continue
		if(get_dist(src, H) < 4 || H.stat != DEAD)
			continue
		target_turfs += get_turf(H)

	var/turf/target_turf = get_closest_atom(/turf/open, target_turfs, src)
	if(istype(target_turf))
		patrol_path = get_path_to(src, target_turf, /turf/proc/Distance_cardinal, 0, 200)
		return
	return ..()

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/black/MoveToTarget(list/possible_targets)
	if(get_dist(src, target) >= 3)
		fast_mode = TRUE
	if(get_dist(src, target) <= 1)
		fast_mode = FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/black/Life()
	. = ..()
	if(fast_mode)
		move_to_delay = 0.6//fast as fuck boi!
	if(!fast_mode)
		move_to_delay = 2.4

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/pale
	name = "灵魂老虾" //shrimp soulshot 双关pale-灵魂伤害和soulfood
	desc = "一口热煎锅，配上一份玉米糊，就是灵魂料理."
	icon_state = "wellcheers_bad"
	icon_living = "wellcheers_bad"
	melee_damage_type = PALE_DAMAGE
	melee_damage_lower = 8
	melee_damage_upper = 12
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.2)
	ranged = 1
	retreat_distance = 2
	minimum_distance = 3
	casingtype = /obj/item/ammo_casing/caseless/pale_shotgun
	projectilesound = 'sound/weapons/gun/pistol/shot_alt.ogg'

/mob/living/simple_animal/hostile/ordeal/salmon_dusk/pale/Initialize()
	. = ..()
	color = COLOR_CYAN
