// Dawn
// So, it works practically the same as amber dawn, so here we go
/datum/ordeal/simplespawn/violet_dawn
	name = "紫罗兰的黎明"
	flavor_name = "理解的果实"
	announce_text = "有朝一日，我们必将理解那些不能理解的东西."
	end_announce_text = "为了理解，我们只能这么做."
	announce_sound = 'sound/effects/ordeals/violet_start.ogg'
	end_sound = 'sound/effects/ordeals/violet_end.ogg'
	spawn_places = 4
	spawn_amount = 2
	spawn_type = /mob/living/simple_animal/hostile/ordeal/violet_fruit
	place_player_multiplicator = 0.05
	spawn_player_multiplicator = 0.025
	level = 1
	reward_percent = 0.1
	color = "#B642F5"

// Noon
/datum/ordeal/violet_noon
	name = "紫罗兰的正午"
	flavor_name = "请给我们爱！！！"
	announce_text = "我们听见了弱者的挣扎与悲鸣，向它们乞求爱与慈悲吧."
	end_announce_text = "我们不能理解它们，它们更不会理解我们."
	announce_sound = 'sound/effects/ordeals/violet_start.ogg'
	end_sound = 'sound/effects/ordeals/violet_end.ogg'
	level = 2
	reward_percent = 0.15
	color = "#B642F5"
	var/spawn_amount = 4

/datum/ordeal/violet_noon/Run()
	..()
	var/spawned_in = 0
	for(var/turf/T in shuffle(GLOB.department_centers))
		if(spawned_in >= spawn_amount)
			return
		var/mob/living/simple_animal/hostile/ordeal/violet_monolith/M = new(T)
		ordeal_mobs += M
		M.ordeal_reference = src
		spawned_in += 1

/datum/ordeal/simplespawn/violet_dusk
	name = "紫罗兰的午夜"
	flavor_name = "神明的迷思"
	announce_text = "我们一次又一次地试图接纳它们，无论这要付出何等的代价，我们必须理解！！！"
	end_announce_text = "为了避免自我的崩溃，它们绝不容忍那些不可理解，不可触及的存在..."
	announce_sound = 'sound/effects/ordeals/violet_start.ogg'
	end_sound = 'sound/effects/ordeals/violet_end.ogg'
	level = 3
	reward_percent = 0.2
	color = "#B642F5"
	spawn_places = 2
	spawn_amount = 1
	place_player_multiplicator = 0.1
	spawn_player_multiplicator = 0
	spawn_type = /mob/living/simple_animal/hostile/ordeal/violet_dusk

// Noon
/datum/ordeal/violet_midnight
	name = "The Midnight of Violet"
	flavor_name = "The God Delusion"
	announce_text = "We incessantly tried to accept it. We wanted to understand them in our heads by any means, regardless of the consequences."
	end_announce_text = "For the sake of not crumbling in on oneself. The idea that they may impossibly exist, or that they are unreachable and forever enigmatic no matter the path. Unacceptable…"
	announce_sound = 'sound/effects/ordeals/violet_start.ogg'
	end_sound = 'sound/effects/ordeals/violet_end.ogg'
	level = 4
	reward_percent = 0.25
	color = "#B642F5"
	ordeal_achievement = /datum/award/achievement/lc13/violetmidnight

/datum/ordeal/violet_midnight/Run()
	..()
	var/list/available_spots = GLOB.xeno_spawn.Copy()
	for(var/spawn_type in subtypesof(/mob/living/simple_animal/hostile/ordeal/violet_midnight))
		var/turf/T = pick(available_spots)
		available_spots -= T
		var/mob/living/simple_animal/hostile/ordeal/M = new spawn_type(T)
		ordeal_mobs += M
		M.ordeal_reference = src
