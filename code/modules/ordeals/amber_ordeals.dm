// Dawn
/datum/ordeal/simplespawn/amber_dawn
	name = "琥珀色的黎明"
	flavor_name = "新鲜的食物"
	announce_text = "食物—新鲜，替代品—很好."
	end_announce_text = "我们—生存，我们—吃，我们—腐烂，成为—食物..."
	level = 1
	reward_percent = 0.1
	announce_sound = 'sound/effects/ordeals/amber_start.ogg'
	end_sound = 'sound/effects/ordeals/amber_end.ogg'
	color = "#FFBF00"
	spawn_places = 4
	spawn_amount = 3
	spawn_type = /mob/living/simple_animal/hostile/ordeal/amber_bug

/datum/ordeal/simplespawn/amber_dawn/DeploymentZone(turf/T, no_center = FALSE)
	return T //deployment zone unnecessary since amber dawns burrow out of a 5x5 zone

// Dusk
/datum/ordeal/simplespawn/amber_dusk
	name = "琥珀色的黄昏"
	flavor_name = "食物链"
	announce_text = "品尝—味道，避免—不能."
	end_announce_text = "我们—生存. 我们—吃—吃—吃—吃..."
	level = 3
	reward_percent = 0.2
	announce_sound = 'sound/effects/ordeals/amber_start.ogg'
	end_sound = 'sound/effects/ordeals/amber_end.ogg'
	color = "#FFBF00"
	spawn_places = 3
	spawn_amount = 1
	spawn_type = /mob/living/simple_animal/hostile/ordeal/amber_dusk
	place_player_multiplicator = 0.05
	spawn_player_multiplicator = 0

// Midnight
/datum/ordeal/amber_midnight
	name = "琥珀色的午夜"
	flavor_name = "永恒的盛宴"
	announce_text = "你—撕扯—我, 我—吃掉—你."
	end_announce_text = "弱者—被吃, 永远—不变."
	level = 4
	reward_percent = 0.25
	announce_sound = 'sound/effects/ordeals/amber_start.ogg'
	end_sound = 'sound/effects/ordeals/amber_end.ogg'
	color = "#FFBF00"
	ordeal_achievement = /datum/award/achievement/lc13/ambermidnight
	/// How many mobs to spawn
	var/spawn_amount = 1

/datum/ordeal/amber_midnight/Run()
	..()
	var/list/potential_locs = GLOB.department_centers.Copy()
	if(GLOB.player_list.len >= 15)
		spawn_amount += round(GLOB.player_list.len / 15)
	for(var/i = 1 to spawn_amount)
		var/turf/T = pick(potential_locs)
		var/mob/living/simple_animal/hostile/ordeal/amber_midnight/M = new(T)
		ordeal_mobs += M
		M.ordeal_reference = src
		potential_locs -= T
