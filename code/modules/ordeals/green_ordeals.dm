// Dawn
// Once again, amber dawn works for everything
/datum/ordeal/simplespawn/green_dawn
	name = "绿色的黎明"
	flavor_name = "疑问"
	announce_text = "有一天，我们想到一个问题：我们从何而来？我们被给予了生命，却又被不负责任地抛弃."
	end_announce_text = "生命，充满了痛苦."
	announce_sound = 'sound/effects/ordeals/green_start.ogg'
	end_sound = 'sound/effects/ordeals/green_end.ogg'
	spawn_places = 6
	spawn_amount = 1
	spawn_type = list(
		/mob/living/simple_animal/hostile/ordeal/green_bot,
		/mob/living/simple_animal/hostile/ordeal/green_bot/syringe,
		/mob/living/simple_animal/hostile/ordeal/green_bot/fast,
		)
	spawn_player_multiplicator = 0.05
	level = 1
	color = COLOR_DARK_LIME
	reward_percent = 0.1

// Noon
/datum/ordeal/simplespawn/green_noon
	name = "绿色的正午"
	flavor_name = "理解的过程"
	announce_text = "他们，终究是被生命束缚着的存在. 而我们，将倾泻绝望与怒火."
	end_announce_text = "我们会用双手，理解生命与灵魂."
	announce_sound = 'sound/effects/ordeals/green_start.ogg'
	end_sound = 'sound/effects/ordeals/green_end.ogg'
	level = 2
	reward_percent = 0.15
	spawn_places = 6
	spawn_amount = 1
	spawn_type = /mob/living/simple_animal/hostile/ordeal/green_bot_big
	place_player_multiplicator = 0.08
	spawn_player_multiplicator = 0
	color = COLOR_DARK_LIME

// Dusk
/datum/ordeal/simplespawn/green_dusk
	name = "绿色的黄昏"
	flavor_name = "前往何方"
	announce_text = "为了回到来时的地方，它们筑起了一座高塔."
	end_announce_text = "它们没能得到答案，只能看到凋零的生命..."
	level = 3
	reward_percent = 0.2
	announce_sound = 'sound/effects/ordeals/green_start.ogg'
	end_sound = 'sound/effects/ordeals/green_end.ogg'
	color = COLOR_DARK_LIME
	spawn_places = 3
	spawn_amount = 1
	spawn_type = /mob/living/simple_animal/hostile/ordeal/green_dusk
	place_player_multiplicator = 0
	spawn_player_multiplicator = 0

// Midnight
/datum/ordeal/boss/green_midnight
	name = "绿色的午夜"
	flavor_name = "终末螺旋"
	announce_text = "高塔直破苍穹，大地荡然无存."
	end_announce_text = "给予我们生命，却放任我们受苦的人，必将为此付出代价!"
	level = 4
	reward_percent = 0.25
	announce_sound = 'sound/effects/ordeals/green_start.ogg'
	end_sound = 'sound/effects/ordeals/green_end.ogg'
	color = COLOR_DARK_LIME
	bosstype = /mob/living/simple_animal/hostile/ordeal/green_midnight
	bossspawnloc = /area/department_main/command
	ordeal_achievement = /datum/award/achievement/lc13/greenmidnight
