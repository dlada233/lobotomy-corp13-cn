// Dawn
//Simplespawn but with very slight changes
/datum/ordeal/brown_dawn
	name = "褐色的黎明"
	flavor_name = "大罪"
	announce_text = "每个人的心中都种着一颗种子，它始终蕴含着绽放的潜力."
	end_announce_text = "这些不过是一无所有之人灵魂的扭曲倒影."
	level = 1
	reward_percent = 0.1
	announce_sound = 'sound/effects/ordeals/brown_start.ogg'
	end_sound = 'sound/effects/ordeals/brown_end.ogg'
	color = "#69350b"
	var/spawn_places = 6
	var/spawn_amount = 2
	var/list/mob_spawn_type = list(
		/mob/living/simple_animal/hostile/ordeal/sin_gluttony,
		/mob/living/simple_animal/hostile/ordeal/sin_sloth,
		/mob/living/simple_animal/hostile/ordeal/sin_gloom,
		/mob/living/simple_animal/hostile/ordeal/sin_pride,
		/mob/living/simple_animal/hostile/ordeal/sin_lust,
		/mob/living/simple_animal/hostile/ordeal/sin_wrath,
		)
	var/place_player_multiplicator = 0.1
	var/spawn_player_multiplicator = 0.1

/datum/ordeal/brown_dawn/Run() // So basically we want to spawn a crap ton of enemies - Identical to simplespawn, but one type per group
	..()
	var/place_player_mod = round(length(AllLivingAgents(TRUE)) * place_player_multiplicator) // Ten players add a new spot
	var/spawn_player_mod = round(length(AllLivingAgents(TRUE)) * spawn_player_multiplicator)
	if(!LAZYLEN(GLOB.xeno_spawn))
		message_admins("No xeno spawns found when spawning in ordeal!")
		return
	var/list/spawn_turfs = GLOB.xeno_spawn.Copy()

	var/list/type_temporary_list = mob_spawn_type.Copy()

	for(var/i = 1 to (spawn_places + place_player_mod))
		if(!LAZYLEN(spawn_turfs)) //if list empty, recopy xeno spawns
			spawn_turfs = GLOB.xeno_spawn.Copy()
		var/X = pick_n_take(spawn_turfs)
		var/turf/T = get_turf(X)
		var/list/deployment_area = list()
		if((spawn_amount + spawn_player_mod) > 1)
			deployment_area = DeploymentZone(T) //deployable areas for groups

		if(!LAZYLEN(type_temporary_list))
			type_temporary_list = mob_spawn_type.Copy()
		var/spawning = pick_n_take(type_temporary_list)
		for(var/y = 1 to (spawn_amount + spawn_player_mod))
			var/turf/deploy_spot = T //spot you are being deployed
			if(LAZYLEN(deployment_area)) //if deployment zone is empty just spawn at xeno spawn
				deploy_spot = pick_n_take(deployment_area)
			var/mob/living/simple_animal/hostile/ordeal/M = new spawning(deploy_spot)
			ordeal_mobs += M
			M.ordeal_reference = src

/datum/ordeal/specificcommanders/brown_noon
	name = "褐色的正午"
	flavor_name = "大罪"
	announce_text = "梦想只会唤醒那些定义了自己命运的人."
	end_announce_text = "将时间浪费在已经走到尽头的人身上是毫无意义的."
	level = 2
	reward_percent = 0.15
	announce_sound = 'sound/effects/ordeals/brown_start.ogg'
	end_sound = 'sound/effects/ordeals/brown_end.ogg'
	color = "#69350b"
	potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/sin_gluttony/noon,
		/mob/living/simple_animal/hostile/ordeal/sin_sloth/noon,
		/mob/living/simple_animal/hostile/ordeal/sin_gloom/noon,
		/mob/living/simple_animal/hostile/ordeal/sin_pride/noon,
		/mob/living/simple_animal/hostile/ordeal/sin_lust/noon,
		/mob/living/simple_animal/hostile/ordeal/sin_wrath/noon,
	)

	grunttype = list(
		/mob/living/simple_animal/hostile/ordeal/sin_gluttony,
		/mob/living/simple_animal/hostile/ordeal/sin_sloth,
		/mob/living/simple_animal/hostile/ordeal/sin_gloom,
		/mob/living/simple_animal/hostile/ordeal/sin_pride,
		/mob/living/simple_animal/hostile/ordeal/sin_lust,
		/mob/living/simple_animal/hostile/ordeal/sin_wrath,
	)

/datum/ordeal/specificcommanders/brown_noon/spawngrunts(turf/T, list/grunttype, spawn_amount = 7)
	..() // Just changing spawn_amount
