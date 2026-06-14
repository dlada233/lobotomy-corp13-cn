// Dawn
/datum/ordeal/simplespawn/indigo_dawn
	name = "靛蓝色的黎明"
	flavor_name = "进餐"
	announce_text = "他们来寻找他们迫切需要的东西."
	end_announce_text = "And they search in the dark."
	announce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	reward_percent = 0.1
	level = 1
	spawn_places = 5
	spawn_amount = 2
	spawn_type = list(
		/mob/living/simple_animal/hostile/ordeal/indigo_dawn,
		/mob/living/simple_animal/hostile/ordeal/indigo_dawn/invis,
		/mob/living/simple_animal/hostile/ordeal/indigo_dawn/skirmisher,
		)
	place_player_multiplicator = 0.08
	spawn_player_multiplicator = 0
	color = "#3F00FF"

// Noon
/datum/ordeal/simplespawn/indigo_noon
	name = "靛蓝色的正午"
	flavor_name = "清道夫"
	announce_text = "夜幕降临之际，他们悄悄地来到后巷..."
	announce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	reward_percent = 0.15
	level = 2
	spawn_places = 4
	spawn_amount = 2
	spawn_type = list(/mob/living/simple_animal/hostile/ordeal/indigo_noon)
	place_player_multiplicator = 0.08
	spawn_player_multiplicator = 0.3
	color = "#3F00FF"

// Dusk
/datum/ordeal/specificcommanders/indigo_dusk
	name = "靛蓝色的黄昏"
	flavor_name = "后巷深宵"
	announce_text = "壹贰玖壹伍柒陆贰叁肆捌."
	end_announce_text = "陆捌叁零贰肆壹玖叁."
	announce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 3
	reward_percent = 0.20
	color = "#3F00FF"
	potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/pale,
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/red,
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/black,
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/white
		)
	grunttype = list(/mob/living/simple_animal/hostile/ordeal/indigo_noon)

// Midnight
/*
/datum/ordeal/boss/indigo_midnight
	name = "The Midnight of Indigo"
	flavor_name = "Mother"
	announce_text = "Mother will give you all the assistance you need. We all could safely become a family thanks to her."
	end_announce_text = "For the sake of our families in our village, we cannot stop."
	announce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 4
	reward_percent = 0.25
	color = "#3F00FF"
	bosstype = /mob/living/simple_animal/hostile/ordeal/indigo_midnight
*/
