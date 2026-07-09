/obj/item/combat_page/level1
	name = "战斗书页-L1"
	desc = "一份等级1的战斗书页"
	reward_pe = 500
	spawn_enemies = list(/mob/living/simple_animal/hostile/kcorp/drone)
	spawn_type = "random"
	spawn_number = 2
	var/list/combat_weights = list(
		"KDrones" = 10,
		"lovetown1" = 10,
		"rat1" = 10,
		)

/obj/item/combat_page/level1/Initialize()
	. = ..()
	var/chosen = pickweight(combat_weights)
	switch(chosen)
		if("KDrones")
			spawn_number = 2
			spawn_enemies = list(/mob/living/simple_animal/hostile/kcorp/drone)

		if("lovetown1")
			spawn_number = 10
			spawn_enemies = list(/mob/living/simple_animal/hostile/lovetown/slasher,
				/mob/living/simple_animal/hostile/lovetown/stabber)

		if("rat1")
			spawn_number = 6
			spawn_enemies = list(
					/mob/living/simple_animal/hostile/humanoid/rat/knife,
					/mob/living/simple_animal/hostile/humanoid/rat,
					/mob/living/simple_animal/hostile/humanoid/rat/pipe,
					/mob/living/simple_animal/hostile/humanoid/rat/hammer,
					/mob/living/simple_animal/hostile/humanoid/rat/zippy)
