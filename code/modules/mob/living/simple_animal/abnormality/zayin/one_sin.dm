/mob/living/simple_animal/hostile/abnormality/onesin
	name = "一罪与百善"
	desc = "它是一个巨大的头骨，挂在十字架上，戴着荆棘王冠."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "onesin_halo_normal"
	icon_living = "onesin_halo_normal"
	portrait = "one_sin"
	maxHealth = 77
	health = 77
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 2
	melee_damage_upper = 4
	melee_damage_type = WHITE_DAMAGE
	attack_sound = 'sound/abnormalities/onesin/onesin_attack.ogg'
	attack_verb_continuous = "smites"
	attack_verb_simple = "smite"
	is_flying_animal = TRUE
	threat_level = ZAYIN_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_INSIGHT = list(70, 70, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = 70,
		ABNORMALITY_WORK_REPRESSION = list(50, 40, 30, 30, 30),
		"忏悔" = 50,
	)
	work_damage_upper = 2
	work_damage_lower = 1
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/penitence,
		/datum/ego_datum/armor/penitence
	)
	gift_type = /datum/ego_gifts/penitence
	gift_message = "从今天起，你将永远不会忘记它的话."
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/white_night = 5,
	)

	chem_type = /datum/reagent/abnormality/onesin
	harvest_phrase = span_notice("当你将其高举于 %ABNO 面前, 圣光充盈 %VESSEL.")
	harvest_phrase_third = "%PERSON 高举 %VESSEL, 任其浸沐圣光."

	observation_prompt = "它执掌伟力。既是审判众生的救主，亦是降下终末的行刑者. <br>\
		在双眼眼中，你窥见... <br>(确切而言，它并无双目，一切都在漆黑空洞中映现...)"
	observation_choices = list(
		"空无一物" = list(TRUE, "黑暗. <br>\
			虚空寂寥. 你可寻得所求之解?"),
		"窥见己身" = list(FALSE, "你已被洞见. <br>\
			你亦执掌伟力. <br>为至善之故，你甘愿高举裁决之斧."),
	)

	var/halo_status = "onesin_halo_normal" //used for changing the halo overlays

	var/wn_work = FALSE

//Overlay stuff
/mob/living/simple_animal/hostile/abnormality/onesin/PostSpawn()
	..()
	update_icon()

/mob/living/simple_animal/hostile/abnormality/onesin/update_overlays()
	. = ..()
	. += "onesin" //by the nine this is too cursed

/mob/living/simple_animal/hostile/abnormality/onesin/WorkChance(mob/living/carbon/human/user, chance)
	if(istype(user.ego_gift_list[HAT], gift_type))
		return chance + 10
	if(GetWN())
		return 100
	return chance

/mob/living/simple_animal/hostile/abnormality/onesin/AttemptWork(mob/living/carbon/human/user, work_type)
	if(GetWN())
		if(work_type == "忏悔")
			wn_work = TRUE
			user.status_flags |= GODMODE//We really don't want them to die mid work
			user.SetImmobilized(40, ignore_canstun = TRUE)
			for(var/mob/M in GLOB.player_list)
				if(M.client)
					M.playsound_local(get_turf(M), 'sound/abnormalities/onesin/confession_start.ogg', 25, 0)
		else
			to_chat(user, span_warning("异想体似乎忽略了你，也许试试忏悔"))
			return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/onesin/SpeedWorktickOverride(mob/living/carbon/human/user, work_speed, init_work_speed, work_type) //THE RIDE NEVER ENDS
	if(wn_work)
		return 10
	return ..()

/mob/living/simple_animal/hostile/abnormality/onesin/Worktick(mob/living/carbon/human/user)
	if(wn_work)
		user.SetImmobilized(40, ignore_canstun = TRUE)
	return ..()

/mob/living/simple_animal/hostile/abnormality/onesin/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	wn_work = FALSE
	if(work_type == "忏悔")
		var/mob/living/simple_animal/hostile/abnormality/white_night/WN = GetWN()
		if(WN)
			to_chat(WN, span_colossus("第十二个背叛了我们..."))
			sound_to_playing_players('sound/abnormalities/whitenight/apostle_bell.ogg')
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 20, "我不是拣选了你们十二个人吗？可你们中间却有一个是魔鬼.", 25))
			WN.loot = list() // No loot for you!
			WN.devil = user
			user.status_flags &= ~GODMODE
			sleep(1 SECONDS)
			for(var/i = 1 to 20)
				if(!WN || WN.stat == DEAD)
					break
				sleep(0.8 SECONDS)
				user.SetImmobilized(30, ignore_canstun = TRUE)
				playsound(get_turf(WN), 'sound/machines/clockcult/ark_damage.ogg', 75, TRUE, -1)
				var/obj/effect/temp_visual/onesin_blessing/OB = new(get_turf(WN))
				OB.layer = WN.layer + 0.1
				OB.pixel_x += rand(-6,6)
				WN.deal_damage(3330, PALE_DAMAGE)//Does 666 damage to WN
			sleep(5 SECONDS)
			for(var/mob/M in GLOB.player_list)
				if(M.client)
					M.playsound_local(get_turf(M), 'sound/abnormalities/onesin/confession_end.ogg', 50, 0)
			return

		else
			var/heal_chance = rand(2,pe)

			if(heal_chance > 1)
				flick("onesin_halo_good", src)
				new /obj/effect/temp_visual/onesin_blessing(get_turf(user))
				user.adjustBruteLoss(-user.maxHealth)
				user.adjustSanityLoss(-user.maxSanity)
			else
				flick("onesin_halo_bad", src)
				new /obj/effect/temp_visual/onesin_punishment(get_turf(user))
				user.adjustSanityLoss(user.maxSanity/2)
				playsound(get_turf(user), 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 33, 1)

			playsound(get_turf(user), 'sound/abnormalities/onesin/confession_end.ogg', 50, 0)
	return ..()

/mob/living/simple_animal/hostile/abnormality/onesin/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(work_type != "忏悔")
		new /obj/effect/temp_visual/onesin_blessing(get_turf(user))
		user.adjustSanityLoss(-user.maxSanity * 0.5) // It's healing
	if(pe >= datum_reference.max_boxes)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H.z != z)
				continue
			if(H == user)
				continue
			new /obj/effect/temp_visual/onesin_blessing(get_turf(H))
			var/heal_factor = 0.5
			if(H.sanity_lost)
				heal_factor = 0.25
			H.adjustSanityLoss(-H.maxSanity * heal_factor)

/mob/living/simple_animal/hostile/abnormality/onesin/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_MINING)
		update_icon()
		return ..()
	return FALSE // If someone wants him to breach for SOME REASON in the future, then exclude breach_type == BREACH_PINK

/mob/living/simple_animal/hostile/abnormality/onesin/AttackingTarget(atom/attacked_target)
	..()
	new /obj/effect/temp_visual/onesin_punishment(get_turf(attacked_target))

/mob/living/simple_animal/hostile/abnormality/onesin/proc/GetWN()
	var/mob/living/simple_animal/hostile/abnormality/white_night/WN = locate() in GLOB.abnormality_mob_list
	if(WN)
		if(WN.status_flags & GODMODE)
			return
		return WN
	return

/datum/reagent/abnormality/onesin
	name = "圣光"
	description = "它能让你平静下来，即使你无法直视它."
	color = "#eff16d"
	sanity_restore = -2
	special_properties = list("可能会改变受试者周围人的神志")

/datum/reagent/abnormality/onesin/on_mob_life(mob/living/L)
	for(var/mob/living/carbon/human/nearby in livinginview(9, get_turf(L)))
		nearby.adjustSanityLoss(-1)
	return ..()
