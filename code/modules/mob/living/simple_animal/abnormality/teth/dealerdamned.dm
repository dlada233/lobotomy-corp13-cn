/mob/living/simple_animal/hostile/abnormality/dealerdamned
	name = "亡命赌徒"
	desc = "一个拿着左轮手枪指着头的高大人物，它就在一张牌桌前面."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "dealerdamned"
	portrait = "dealer"
	maxHealth = 230
	health = 230
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 35,
		ABNORMALITY_WORK_INSIGHT = 55,
		ABNORMALITY_WORK_ATTACHMENT = 35,
		ABNORMALITY_WORK_REPRESSION = 25,
		"Gamble" = 100
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gluttony
	speak_emote = list("states")
	pet_bonus = "waves"

	ego_list = list(
		/datum/ego_datum/weapon/luckdraw,
		/datum/ego_datum/armor/luckdraw,
	)
	gift_type =  /datum/ego_gifts/luckdraw
	pixel_x = -16
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL
	can_spawn = FALSE // Normally doesn't appear
	var/coin_status
	var/has_flipped
	var/static/gambled_prior = list()
	var/work_count = 0

	observation_prompt = "你在喧嚣洪流中苏醒——整栋建筑沸腾着刺激感，宾客们举杯交际，老虎机轰鸣着淹没输光一切者的哀嚎. <br>\
		赌桌前你已经入局，庄家转向你，焦灼等待你的下一步. "
	observation_choices = list(
		"跟注" = list(TRUE, "你自信跟注，认定胜券在握. 然而皇家同花顺碾碎希望。虽遭此败，你仍继续下注，坚信运气终将逆转..."),
		"弃牌" = list(FALSE, "你选择弃牌，紧攥所剩无几的筹码. 纵使庄家没有五官，你仍能感受到那无声的失望..."),
	)

//Coinflip V1; Expect Jank
/mob/living/simple_animal/hostile/abnormality/dealerdamned/funpet(mob/petter)
	..()
	if(!isliving(petter))
		return
	if(has_flipped)
		say("哇，好样的,我们最近已经赌过一场了!")
		return
	var/flip_modifier = 0
	has_flipped = TRUE
	var/mob/living/user = petter
	user.deal_damage(user.maxHealth*0.2, RED_DAMAGE)
	icon_state = "dealerflip"
	manual_emote("投掷一枚金币.")
	SLEEP_CHECK_DEATH(10)
	icon_state = "dealerdamned"
	for(var/upgradecheck in GLOB.jcorp_upgrades)
		if(upgradecheck == "Abno Luck")
			flip_modifier = 10
	if(prob(35)+flip_modifier)
		say("头像，嗯？看来你赢了.")
		coin_status = TRUE
		user.adjustBruteLoss(-user.maxHealth*0.2)
	else
		say("反面，抱歉了豪赌客，愿赌服输.")
	return

/mob/living/simple_animal/hostile/abnormality/dealerdamned/AttemptWork(mob/living/carbon/human/user, work_type)
	..()
	if((work_type == "赌博") && (user.ckey in gambled_prior))
		say("我知道这是我喜欢的刺激体验，但你已经冒过一次险了，我也有自己的原则.")
		return FALSE
	else
		return TRUE

//TODO: Add the revolver open sprite, replace gibbing with "death" sprite
/mob/living/simple_animal/hostile/abnormality/dealerdamned/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	..()
	if(work_type == "赌博")
		say("想要冒点生命危险，是吧？听起来不错！")
		user.Immobilize(15)
		SLEEP_CHECK_DEATH(10)
		playsound(user, "revolver_spin", 70, FALSE)
		gambled_prior |= user.ckey

		//We need to set if the game is going on, who's being shot, and then spent chambers
		var/russian_roulette = TRUE
		var/player_shot = TRUE
		var/spent_chambers = 0
		var/roulette_modifier = 0

		while(russian_roulette)
			user.Immobilize(spent_chambers*5)
			SLEEP_CHECK_DEATH(spent_chambers*5)
			spent_chambers+=1
			for(var/upgradecheck in GLOB.jcorp_upgrades)
				if(upgradecheck == "Abno Luck")
					if(player_shot)
						roulette_modifier = -3
					else
						roulette_modifier = 3
			if(prob((16.666+roulette_modifier)*spent_chambers) || spent_chambers == 6) //Failsafe thanks to J corp RNG
				playsound(user, 'sound/weapons/gun/revolver/shot_alt.ogg', 100, FALSE)
				russian_roulette = FALSE
				if(player_shot)
					user.gib()
					say("真丢人. 你在这里还挺有趣的, 你知道的.")
				else
					new /obj/item/ego_weapon/ranged/pistol/deathdealer(get_turf(user))
					new /obj/effect/gibspawner/generic/silent(get_turf(src))
					gib()
			else
				playsound(user, 'sound/weapons/gun/revolver/dry_fire.ogg', 100, FALSE)
				if(player_shot)
					player_shot = FALSE
				else
					player_shot = TRUE

/mob/living/simple_animal/hostile/abnormality/dealerdamned/WorkChance(mob/living/carbon/human/user, chance)
	var/newchance
	if(coin_status)
		newchance = 20
	coin_status = FALSE
	has_flipped = FALSE
	return chance + newchance
