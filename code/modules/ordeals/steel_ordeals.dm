/datum/ordeal/simplespawn/steel_dawn
	name = "钢铁的黎明"
	flavor_name = "虫化"
	announce_text = "虫化...我对此毫不后悔. 即便再也没法作为常人."
	end_announce_text = "这...这就是战争，我完全不够格."
	announce_sound = 'sound/effects/ordeals/steel_start.ogg'
	end_sound = 'sound/effects/ordeals/steel_end.ogg'
	level = 1
	reward_percent = 0.1
	spawn_places = 4
	spawn_amount = 2
	spawn_type = /mob/living/simple_animal/hostile/ordeal/steel_dawn
	//For every 30 players there is one additional group and one additional grunt for every 20 players.
	//So 40 players would make 5 groups of 4 troops which is 20 grunts, and for 10 players it would be 4 groups of 3 which is 12.
	place_player_multiplicator = 0.03
	spawn_player_multiplicator = 0.05
	color = "#71797E"


/datum/ordeal/simplecommander/steel_noon
	name = "钢铁的正午"
	flavor_name = "战争之虫"
	announce_text = "我将毫不犹豫地与敌人战斗. 在我光荣地得到虫化手术那天起就已下定决心."
	end_announce_text = "你为什么在逃跑? 你应该抗起G公司的旗帜，在前线冲锋陷阵!"
	announce_sound = 'sound/effects/ordeals/steel_start.ogg'
	end_sound = 'sound/effects/ordeals/steel_end.ogg'
	level = 2
	reward_percent = 0.2
	color = "#71797E"
	boss_type = list(/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon)
	grunt_type = list(/mob/living/simple_animal/hostile/ordeal/steel_dawn)
	boss_amount = 3
	grunt_amount = 2
	boss_player_multiplicator = 0.03
	grunt_player_multiplicator = 0.05


/datum/ordeal/simplecommander/steel_dusk
	name = "钢铁的黄昏"
	flavor_name = "虫之战争"
	announce_text = "如果我们输掉了这场战争，就被会扔到街上，被视为连老鼠都不如的非人."
	end_announce_text = "最后...我们还是变成了讨人厌的害虫."
	announce_sound = 'sound/effects/ordeals/steel_start.ogg'
	end_sound = 'sound/effects/ordeals/steel_end.ogg'
	level = 3
	reward_percent = 0.2
	color = "#71797E"
	boss_type = list(/mob/living/simple_animal/hostile/ordeal/steel_dusk, /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon, /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying)
	grunt_type = list(/mob/living/simple_animal/hostile/ordeal/steel_dawn)
	boss_amount = 3
	grunt_amount = 4
	//Setting player multiplier to 0 since this is already a army of 7.
	//Fourth Group appears if there is 23 players.
	boss_player_multiplicator = 0.045
	grunt_player_multiplicator = 0
