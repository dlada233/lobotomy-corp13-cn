/datum/ordeal/fixers
	name = "收尾人"
	announce_text = "This isn't supposed to happen, but they have come for you. Might want to report this to central command."
	can_run = FALSE
	delay = 1 // Goes back-to-back
	random_delay = FALSE
	reward_percent = 0.1
	announce_sound = 'sound/effects/ordeals/white_start.ogg'
	end_sound = 'sound/effects/ordeals/white_end.ogg'
	var/mobs_amount = 1
	var/list/potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/black_fixer,
		/mob/living/simple_animal/hostile/ordeal/white_fixer,
		/mob/living/simple_animal/hostile/ordeal/red_fixer
		)

/datum/ordeal/fixers/Run()
	..()
	var/list/available_locs = GLOB.xeno_spawn.Copy()
	for(var/i = 1 to mobs_amount)
		if(!potential_types.len)
			break
		var/turf/T = pick(available_locs)
		if(available_locs.len > 1)
			available_locs -= T
		var/chosen_type = pick(potential_types)
		potential_types -= chosen_type
		var/mob/living/simple_animal/hostile/ordeal/C = new chosen_type(T)
		ordeal_mobs += C
		C.ordeal_reference = src

// Dawn
/datum/ordeal/fixers/white_dawn
	name = "惨白的黎明"
	flavor_name = "委托"
	announce_text = "从烦琐的跑腿，勘察，到雇凶杀人。只要付得起钱，他们就会接下任何工作."
	end_announce_text = "他们受托于“事务所”，“辛迪加”，甚至是“翼”，从微乎其微的琐事，到惨绝人寰的要事，他们，无所不能."
	can_run = TRUE
	level = 6
	reward_percent = 0.1

/datum/ordeal/fixers/white_dawn/Run()
	..()
	var/mob/living/dawn_mob = ordeal_mobs[1]
	var/dawn_type = null
	if(istype(dawn_mob))
		dawn_type = dawn_mob.type
	var/datum/ordeal/fixers/white_noon/N = locate() in SSlobotomy_corp.all_ordeals[7]
	if(N)
		N.potential_types -= dawn_type

/datum/ordeal/fixers/white_noon
	name = "惨白的正午"
	flavor_name = "武器"
	announce_text = "他们无休无止地搜罗着精良的武器，无论是“翼”的科技，还是“后巷”的发明，亦或是“郊区”的战利品，乃至“废墟”的遗物..."
	end_announce_text = "他们的所作所为，无非是紧握手中的武器，一如既往地用暴力解决眼中的一切."
	can_run = TRUE
	level = 7
	reward_percent = 0.15
	mobs_amount = 2

/datum/ordeal/fixers/white_dusk
	name = "惨白的黄昏"
	flavor_name = "收尾人"
	announce_text = "被称作“图书馆”的光之高塔拔地而起，那片承载着生与死的秘境自然会吸引“收尾人”的驻足."
	end_announce_text = "“收尾人”，书籍猎手的前身，终将葬身于“惨白管理者”统治下的“图书馆”中."
	can_run = TRUE
	level = 8
	reward_percent = 0.2
	mobs_amount = 4
	potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/black_fixer,
		/mob/living/simple_animal/hostile/ordeal/white_fixer,
		/mob/living/simple_animal/hostile/ordeal/red_fixer,
		/mob/living/simple_animal/hostile/ordeal/pale_fixer
		)

// Midnight
/datum/ordeal/white_midnight
	name = "惨白的午夜"
	flavor_name = "爪牙"
	announce_text = "将世界的奥秘玩弄于股掌之间，乃是“首脑”，“眼线”与“爪牙”至高无上的特权."
	end_announce_text = "他们无人能挡，“巢”与他们的故事永不落幕."
	level = 9
	delay = 1
	random_delay = FALSE
	reward_percent = 0.25
	announce_sound = 'sound/effects/ordeals/white_start.ogg'
	end_sound = 'sound/effects/ordeals/white_end.ogg'
	ordeal_achievement = /datum/award/achievement/lc13/whitemidnight

/datum/ordeal/white_midnight/Run()
	..()
	var/X = pick(GLOB.xeno_spawn)
	var/turf/T = get_turf(X)
	var/mob/living/simple_animal/hostile/megafauna/claw/C = new(T)
	ordeal_mobs += C
	C.ordeal_reference = src

/datum/ordeal/white_midnight/End()
	if(istype(SSlobotomy_corp.core_suppression)) // If it all was a part of core suppression
		SSlobotomy_corp.core_suppression_state = 3
		SSticker.news_report = max(SSticker.news_report, CORE_SUPPRESSED_CLAW_DEAD)
		addtimer(CALLBACK(SSlobotomy_corp.core_suppression, TYPE_PROC_REF(/datum/suppression, End)), 10 SECONDS)
	return ..()
