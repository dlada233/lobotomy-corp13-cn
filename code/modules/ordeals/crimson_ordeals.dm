// Dawn
/datum/ordeal/crimson_dawn
	name = "血色的黎明"
	flavor_name = "开始欢呼吧!"
	announce_text = "让我们在这宛如风中残烛的生命里，纵情放一把大火吧!"
	end_announce_text = "活着，就是为了满足肉欲."
	level = 1
	reward_percent = 0.1
	announce_sound = 'sound/effects/ordeals/crimson_start.ogg'
	end_sound = 'sound/effects/ordeals/crimson_end.ogg'
	color = "#DC143C"

/datum/ordeal/crimson_dawn/Run()
	..()
	var/abno_amount = length(SSlobotomy_corp.all_abnormality_datums)
	var/spawn_amount = clamp((abno_amount * 0.5), 1, 7)
	for(var/y = 1 to spawn_amount) // They get spawned and then instantly teleport
		var/X = pick(GLOB.xeno_spawn)
		var/turf/T = get_turf(X)
		var/mob/living/simple_animal/hostile/ordeal/crimson_clown/M = new(T)
		ordeal_mobs += M
		M.ordeal_reference = src
		M.TeleportAway()
		sleep(7) // That's so the clowns don't instantly teleport to the same console

/datum/ordeal/simplespawn/crimson_noon
	name = "血色的正午"
	flavor_name = "汁水大合唱"
	announce_text = "我们每时都在游行，每刻都在分享喜悦."
	end_announce_text = "我们绘出了生命的碰撞...肉体的交融...更美丽的外表..."
	announce_sound = 'sound/effects/ordeals/crimson_start.ogg'
	end_sound = 'sound/effects/ordeals/crimson_end.ogg'
	level = 2
	reward_percent = 0.15
	spawn_places = 4
	spawn_amount = 1
	spawn_type = /mob/living/simple_animal/hostile/ordeal/crimson_noon
	place_player_multiplicator = 0.07
	spawn_player_multiplicator = 0.02
	color = "#DC143C"

/datum/ordeal/simplespawn/crimson_dusk
	name = "血色的黄昏"
	flavor_name = "绝顶之战"
	announce_text = "快扔掉那些破烂的躯干，来和我们融为一体，继续永不落幕的血色狂欢吧!!!"
	end_announce_text = "迟早有一天所有人都会明白. 我们，终将一同狂欢."
	announce_sound = 'sound/effects/ordeals/crimson_start.ogg'
	end_sound = 'sound/effects/ordeals/crimson_end.ogg'
	level = 3
	reward_percent = 0.2
	spawn_places = 3
	spawn_amount = 1
	spawn_type = /mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_dusk
	place_player_multiplicator = 0.05
	spawn_player_multiplicator = 0
	color = "#DC143C"

/datum/ordeal/simplecommander/crimson_midnight
	name = "血色的午夜"
	flavor_name = "A Chorus of Saliva"
	announce_text = "Let us make a performance about what has already come true, and march further on from whence we came."
	end_announce_text = "Abandon all expectation and march on. Laugh no matter what you see!"
	level = 4
	reward_percent = 0.25
	announce_sound = 'sound/effects/ordeals/crimson_start.ogg'
	end_sound = 'sound/effects/ordeals/crimson_end.ogg'
	color = "#DC143C"
	boss_type = list(/mob/living/simple_animal/hostile/ordeal/crimson_tent)
	grunt_type = list(/mob/living/simple_animal/hostile/ordeal/crimson_noon/crimson_midnight)
	boss_amount = 2
	grunt_amount = 1
