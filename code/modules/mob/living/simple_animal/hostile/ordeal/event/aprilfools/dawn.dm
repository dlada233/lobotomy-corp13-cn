// An LC13 Original. Totally.
/mob/living/simple_animal/hostile/shrimp_rifleman
	name = "韦尔奇乐步枪兵"
	desc = "渔网里最好的射手."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers_bad"
	icon_living = "wellcheers_bad"
	icon_dead = "wellcheers_bad_dead"
	faction = list("shrimp")
	health = 60	//They're here to help
	maxHealth = 60
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	melee_damage_lower = 2
	melee_damage_upper = 4
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "punches"
	attack_verb_simple = "punches"
	attack_sound = 'sound/weapons/punch2.ogg'
	speak_emote = list("burbles")
	ranged = 1
	retreat_distance = 2
	minimum_distance = 3
	casingtype = /obj/item/ammo_casing/caseless/ego_shrimprifle
	projectilesound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	butcher_results = list(/obj/item/stack/spacecash/c100 = 1)
	silk_results = list(/obj/item/stack/sheet/silk/shrimple_simple = 10, /obj/item/stack/sheet/silk/shrimple_advanced = 5)

/mob/living/simple_animal/hostile/shrimp_rifleman/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		del_on_death = FALSE

//friendly spawned shrimp from soda E.G.O.'s passive
/mob/living/simple_animal/hostile/aminion/shrimp/grieving
	name = "韦尔奇乐殡仪师"
	desc = "一只看起来在哀悼的虾，请保持庄严肃穆。"
	icon_state = "wellcheers_funeral"
	icon_living = "wellcheers_funeral"
	faction = list("neutral", "shrimp")
	fear_level = 0
	can_affect_emergency = FALSE

// extra buff shrimp i guess
/mob/living/simple_animal/hostile/senior_shrimp
	name = "韦尔奇乐高级管理"
	desc = "一个异常强壮的虾。"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers_ripped"
	icon_living = "wellcheers_ripped"
	icon_dead = "wellcheers_ripped_dead"
	faction = list("shrimp")
	health = 130
	maxHealth = 130
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	move_to_delay = 4
	melee_damage_lower = 3
	melee_damage_upper = 5
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "击打"
	attack_verb_simple = "击打"
	attack_sound = 'sound/effects/meteorimpact.ogg'
	speak_emote = list("burbles")
	butcher_results = list(/obj/item/stack/spacecash/c100 = 1, /obj/item/stack/spacecash/c50 = 1)
	silk_results = list(/obj/item/stack/sheet/silk/shrimple_simple = 12, /obj/item/stack/sheet/silk/shrimple_advanced = 6)

/mob/living/simple_animal/hostile/senior_shrimp/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		del_on_death = FALSE

/mob/living/simple_animal/hostile/senior_shrimp/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/knockback, 3, FALSE, FALSE)

//April Fools Ordeal
/mob/living/simple_animal/hostile/ordeal/shrimp
	name = "韦尔奇乐清算实习生"
	desc = "一只对您极度敌对的虾。"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers"
	icon_living = "wellcheers"
	icon_dead = "wellcheers_dead"
	faction = list("shrimp")
	health = 70
	maxHealth = 70
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	melee_damage_lower = 2
	melee_damage_upper = 4
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "拳击"
	attack_verb_simple = "拳击"
	attack_sound = 'sound/weapons/punch1.ogg'
	speak_emote = list("burbles")
	butcher_results = list(/obj/item/stack/spacecash/c50 = 1)
	guaranteed_butcher_results = list(/obj/item/stack/spacecash/c10 = 1)
	silk_results = list(/obj/item/stack/sheet/silk/shrimple_simple = 4)

/mob/living/simple_animal/hostile/ordeal/shrimp/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		del_on_death = FALSE

/mob/living/simple_animal/hostile/ordeal/shrimp_rifleman
	name = "韦尔奇乐步枪兵"
	desc = "他在这里是为了处理公务。"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers_bad"
	icon_living = "wellcheers_bad"
	icon_dead = "wellcheers_bad_dead"
	faction = list("shrimp")
	health = 80	//They're here to help
	maxHealth = 80
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	melee_damage_lower = 2
	melee_damage_upper = 4
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "拳击"
	attack_verb_simple = "拳击"
	attack_sound = 'sound/weapons/punch2.ogg'
	speak_emote = list("burbles")
	ranged = 1
	retreat_distance = 2
	minimum_distance = 3
	casingtype = /obj/item/ammo_casing/caseless/ego_shrimprifle
	projectilesound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	butcher_results = list(/obj/item/stack/spacecash/c100 = 1)
	silk_results = list(/obj/item/stack/sheet/silk/shrimple_simple = 10, /obj/item/stack/sheet/silk/shrimple_advanced = 5)

/mob/living/simple_animal/hostile/ordeal/shrimp_rifleman/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		del_on_death = FALSE
