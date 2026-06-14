// Dawn
/datum/ordeal/gold_dawn
	name = "金色的黎明"
	flavor_name = "天空、晨风、星光、诗歌"
	announce_text = "当太阳升起，我们可能选择了希望，也可能是绝望."
	end_announce_text = "只有现在你才能明白黎明的光辉."
	level = 1
	reward_percent = 0.1
	announce_sound = 'sound/effects/ordeals/gold_start.ogg'
	end_sound = 'sound/effects/ordeals/gold_end.ogg'
	color = "#FFD700"

	// Sort of a combination of specific commanders and random spawns
	var/list/boss_type = list(/mob/living/simple_animal/hostile/ordeal/fallen_amurdad_corrosion)
	// Randomly picked from these.
	var/list/grunt_type = list(/mob/living/simple_animal/hostile/ordeal/beanstalk_corrosion)
	var/list/roamer_type = list(/mob/living/simple_animal/hostile/ordeal/beanstalk_corrosion) // Randomly spawned around the map
	var/boss_amount = 2
	var/grunt_amount = 3
	var/roamer_amount = 3
	var/boss_player_multiplicator = 0.05
	var/grunt_player_multiplicator = 0.1

/datum/ordeal/gold_dawn/Run() // We want our own variant that spawns both groups of mobs and roamers
	..()
	if(!LAZYLEN(GLOB.xeno_spawn))
		message_admins("No xeno spawns found when spawning in ordeal!")
		return
	var/boss_player_mod = round(length(AllLivingAgents(TRUE)) * boss_player_multiplicator)
	var/grunt_player_mod = round(length(AllLivingAgents(TRUE)) * grunt_player_multiplicator)
	var/list/available_locs = GLOB.xeno_spawn.Copy()

	for(var/i = 1 to round(boss_amount + boss_player_mod)) // Run the usual simplecommander code
		var/turf/T = pick(available_locs)
		if(available_locs.len > 1)
			available_locs -= T
		for(var/Y in boss_type)
			var/mob/living/simple_animal/hostile/ordeal/C = new Y(T)
			ordeal_mobs += C
			C.ordeal_reference = src
		spawngrunts(T, grunt_type, (grunt_amount + grunt_player_mod))

	for(var/i = 1 to round(roamer_amount + boss_player_mod)) // we spawn groups of roamers using boss slots as a base
		var/turf/T = pick(available_locs)
		if(available_locs.len > 1)
			available_locs -= T
		for(var/Y in roamer_type)
			var/mob/living/simple_animal/hostile/ordeal/C = new Y(T)
			ordeal_mobs += C
			C.ordeal_reference = src

//Noon
/datum/ordeal/boss/gold_noon
	name = "金色的正午"
	flavor_name = "蜡炬成灰"
	announce_text = "我们的光芒在天空中闪耀，那些标记着我们起点的星星逐渐消逝."
	end_announce_text = "正午过去，梦想破灭了，那座塔轰然倒塌."
	level = 2
	reward_percent = 0.15
	announce_sound = 'sound/effects/ordeals/gold_start.ogg'
	end_sound = 'sound/effects/ordeals/gold_end.ogg'
	color = "#FFD700"
	bosstype = /mob/living/simple_animal/hostile/ordeal/white_lake_corrosion
	var/roamer_type = list(/mob/living/simple_animal/hostile/ordeal/silentgirl_corrosion)
	var/roamer_amount = 1
	var/boss_player_multiplicator = 0.05
	var/grunt_player_multiplicator = 0.1

/datum/ordeal/boss/gold_noon/Run() // We need to spawn roamers, still.
	..()
	if(!LAZYLEN(GLOB.xeno_spawn))
		message_admins("No xeno spawns found when spawning in ordeal!")
		return
	var/boss_player_mod = round(length(AllLivingAgents(TRUE)) * boss_player_multiplicator)
	var/grunt_player_mod = round(length(AllLivingAgents(TRUE)) * grunt_player_multiplicator)
	var/list/available_locs = GLOB.xeno_spawn.Copy()
	for(var/i = 1 to round(roamer_amount + boss_player_mod)) // we spawn single roamers using boss slots as a base
		var/turf/T = pick(available_locs)
		if(available_locs.len > 1)
			available_locs -= T
		spawngrunts(T, roamer_type, (roamer_amount + grunt_player_mod))


//Dusk
/datum/ordeal/gold_dawn/gold_dusk
	name = "金色的黄昏"
	flavor_name = "生存还是死亡"
	announce_text = "保持警惕，保持决心，让我们的心灵在黄昏时坚强起来."
	end_announce_text = "他们没时间在日落之前去想那些恐怖的事."
	level = 3
	reward_percent = 0.2
	boss_type = list(/mob/living/simple_animal/hostile/ordeal/centipede_corrosion)
	grunt_type  = list(/mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion)
	roamer_type = list(/mob/living/simple_animal/hostile/ordeal/KHz_corrosion)
	boss_amount = 1
	grunt_amount = 2
	roamer_amount = 4
	var/bigbosstype = /mob/living/simple_animal/hostile/ordeal/thunderbird_corrosion_boss
	var/bossspawnloc = null

/datum/ordeal/gold_dawn/gold_dusk/Run()
	..()
	var/turf/T
	if(bossspawnloc)
		for(var/turf/D in GLOB.department_centers)
			if(istype(get_area(D), bossspawnloc))
				T = D
				break
		if(!T)
			var/X = pick(GLOB.department_centers)
			T = get_turf(X)
			log_game("Failed to spawn [src] in [bossspawnloc]")
	else
		var/X = pick(GLOB.department_centers)
		T = get_turf(X)
	spawngrunts(T, grunt_type, roamer_amount)
	var/mob/living/simple_animal/hostile/ordeal/C = new bigbosstype(T)
	ordeal_mobs += C
	C.ordeal_reference = src

//Midnight TODO: Finish and add the new mobs - Currently uses "old" version
/datum/ordeal/gold_dawn/gold_midnight
	name = "金色的午夜"
	flavor_name = "数星星"
	announce_text = "夜幕降临，无知是其根源，无人能在它的终末得到救赎"
	end_announce_text = "我试着把每颗星星都成为美丽之物."
	level = 4
	reward_percent = 0.25
	end_sound = 'sound/effects/ordeals/gold_end_special.ogg' // I had 3 sound effects so I guess i'll use one here.

	can_run = FALSE // Currently reworking this

	// 3 different simplespawns in one ordeal. Similar to simplecommanders but each commander has its own set of grunts
	boss_type = /mob/living/simple_animal/hostile/ordeal/NT_corrosion
	grunt_type = list(/mob/living/simple_animal/hostile/ordeal/NT_corrosion)
	// 2 other pools of simplespawns.
	var/boss_2 = /mob/living/simple_animal/hostile/ordeal/snake_corrosion/strong
	var/list/group_2_grunts = list(/mob/living/simple_animal/hostile/ordeal/snake_corrosion)
	var/boss_3 = /mob/living/simple_animal/hostile/ordeal/dog_corrosion/strong
	var/list/group_3_grunts = list(/mob/living/simple_animal/hostile/ordeal/dog_corrosion)
	roamer_type = list(/mob/living/simple_animal/hostile/ordeal/dog_corrosion)
	boss_amount = 1
	grunt_amount = 2
	roamer_amount = 3
	boss_player_multiplicator = 0.025
	grunt_player_multiplicator = 0.05

/datum/ordeal/gold_dawn/gold_midnight/Run() // Icky copypaste code but the important part is it works
	..()
	if(!LAZYLEN(GLOB.xeno_spawn))
		message_admins("No xeno spawns found when spawning in ordeal!")
		return
	var/boss_player_mod = round(length(AllLivingAgents(TRUE)) * boss_player_multiplicator)
	var/grunt_player_mod = round(length(AllLivingAgents(TRUE)) * grunt_player_multiplicator)
	var/list/available_locs = GLOB.xeno_spawn.Copy()

	for(var/i = 1 to round(boss_amount + boss_player_mod))
		var/turf/T = pick(available_locs)
		if(available_locs.len > 1)
			available_locs -= T
		var/mob/living/simple_animal/hostile/ordeal/A = new boss_type(T)
		ordeal_mobs += A
		A.ordeal_reference = src
		spawngrunts(T, grunt_type, (grunt_amount + grunt_player_mod))

		T = pick(available_locs)
		if(available_locs.len > 1)
			available_locs -= T
		var/mob/living/simple_animal/hostile/ordeal/B = new boss_2(T)
		ordeal_mobs += B
		B.ordeal_reference = src
		spawngrunts(T, group_2_grunts, (grunt_amount + grunt_player_mod))

		T = pick(available_locs)
		if(available_locs.len > 1)
			available_locs -= T
		var/mob/living/simple_animal/hostile/ordeal/C = new boss_3(T)
		ordeal_mobs += C
		C.ordeal_reference = src
		spawngrunts(T, group_3_grunts, (grunt_amount + grunt_player_mod))

	for(var/i = 1 to round(roamer_amount + boss_player_mod)) // we spawn groups of roamers using boss slots as a base
		var/turf/T = pick(available_locs)
		if(available_locs.len > 1)
			available_locs -= T
		for(var/Y in roamer_type)
			var/mob/living/simple_animal/hostile/ordeal/C = new Y(T)
			ordeal_mobs += C
			C.ordeal_reference = src
