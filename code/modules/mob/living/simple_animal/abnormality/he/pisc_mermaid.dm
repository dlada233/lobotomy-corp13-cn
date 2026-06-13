//Piscine mermaid is literally an incel and you can't convince me otherwise.
//Their theme is unrequited love, but unlike melting love they want to be loved back more than they want to love others.
//They are somehow more high maintenance than both melting love and rose, but is way easier to work with, assuming you remember to work on them.
//You wouldn't forget about them would you Anon? - Caluan
/mob/living/simple_animal/hostile/abnormality/pisc_mermaid
	name = "池中人鱼"
	desc = "像美人鱼的无肢畸形物他们心形的眼睛带着爱和嫉妒看着你."
	icon = 'ModularTegustation/Teguicons/48x32.dmi'
	icon_state = "pmermaid_standing"
	icon_living = "pmermaid_standing"
	icon_dead = "pmermaid_laying" //she shouldn't die while contained so this is more of a placeholder death icon
	portrait = "piscine"
	death_sound = 'sound/abnormalities/piscinemermaid/waterjump.ogg'
	attack_sound = 'sound/abnormalities/piscinemermaid/splashattack.ogg'
	del_on_death = FALSE
	maxHealth = 420
	health = 420
	pixel_x = -12
	base_pixel_x = -12
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2) //not that bad without a lover
	rapid_melee = 2
	melee_damage_lower = 3
	melee_damage_upper = 4 //really subpar damage and speed but most of her damage is oxyloss anyway
	stat_attack = HARD_CRIT
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 3
	move_to_delay = 2.8
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(20, 20, 25, 30, 30),
		ABNORMALITY_WORK_INSIGHT = list(30, 30, 35, 35, 35),
		ABNORMALITY_WORK_ATTACHMENT = list(40, 45, 55, 55, 55),
		ABNORMALITY_WORK_REPRESSION = list(40, 50, 60, 60, 60),
	)
	work_damage_upper = 6
	work_damage_lower = 2
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/lust
	melee_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/unrequited,
		/datum/ego_datum/armor/unrequited,
	)
	gift_type =  /datum/ego_gifts/unrequited_love
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/siltcurrent = 1.5//check siltcurrent.dm for my reasoning
	)

	observation_prompt = "\"你说过爱我，那是真心的吗？<br>我为你斩断四肢，<br>若你说不必看见，我连双眼也能挖出。\"<br>她拍打海蓝色鱼尾，泡沫、海水和别的东西溅向你。<br>\
		\"我为你做了礼物，戴上它并说你爱我吧。\"<br>\
		海水将梳子带到你脚边，你拾起它，而她期待地望着你。"
	observation_choices = list(
		"将梳子抛入海中" = list(TRUE, "\"我不明白，难道你不爱我？<br>你难道听不见、看不见、也不理解我的爱？<br>\
			若我将双眼、双耳和大脑都给你，你能否感知并学会爱我？<br>求求你把心给我来填补我胸口的空洞...\"<br>\
			你任由人鱼胡言乱语，爱从不是如此交易之物。"),
		"接受梳子" = list(FALSE, "你将梳子别在发间，人鱼笑了，她的瞳孔如小心脏般跳动，你发现自己随着她的拥抱走向深海。<br>\
			\"真高兴你把心给了我...\"<br>她低语着吻住你，将你越拉越深，海水漫过胸膛又没过头顶，她却不肯松开怀抱。<br>\
			盐水灌入你的肺，你失去了意识。"),
	)

	response_help_continuous = "pets" //You sick fuck
	response_help_simple = "pet"
	pet_bonus = TRUE
	pet_bonus_emote = "smiles!"
	var/suffocation_range = 10
	var/workingflag = FALSE
	var/pet_count = 0
	var/mob/living/carbon/human/petter

	var/obj/item/clothing/head/unrequited_crown/crown
	var/mob/living/carbon/human/love_target

/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(!crown)
		GiveGift(user)
		return
	if(crown?.loved == user)
		if(crown.loved)
			datum_reference.qliphoth_change(2)
			crown.love_cooldown = (world.time + crown.love_cooldown_time) //Reset the qliphoth reduction timer
		return

/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/AttemptWork(mob/living/carbon/human/user, work_type)
	if(status_flags & GODMODE)
		icon_living = "pmermaid_laying"
		icon_state = "pmermaid_laying"
		workingflag = TRUE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(status_flags & GODMODE)
		icon_living = "pmermaid_standing"
		icon_state = "pmermaid_standing"
		workingflag = FALSE
	return

//mermaid will immensely slow down their lover and slowly kill them by cutting off their oxygen supply
//dying by oxydeath actually takes a while, but it puts them on a clear timer to actually get shit done instead of just hoping someone else takes care of it.
/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/BreachEffect()
	. = ..()
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_living = "pmermaid_breach"
	icon_dead = "pmermaid_slain"
	icon_state = icon_living
	pixel_y = -16
	base_pixel_y = -16
	if(!isnull(crown?.loved))
		ChangeResistances(list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.3)) //others can still help but it's going to take a lot of damage
		love_target = crown.loved
		qdel(crown)
		love_target.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/unrequited_slowdown)
		var/turf/orgin = get_turf(love_target)
		var/list/all_turfs = RANGE_TURFS(1, orgin) //if the target is somehow surrounded by nothing but walls it might fuck up her teleport but you're still drowning
		for(var/turf/T in all_turfs)
			if(T.is_blocked_turf(exclude_mobs = TRUE) || T == orgin)
				all_turfs -= T
		var/turf/T = pick(all_turfs)
		if(T)
			forceMove(T)
			GiveTarget(love_target) //ANON YOU HAVEN'T REPLIED TO MY TEXTS IN THE PAST 15 MINUTES DON'T YOU LOVE ME ANYMORE?
			playsound(get_turf(src), 'sound/abnormalities/piscinemermaid/waterjump.ogg', 50, 1)
		to_chat(love_target, span_userdanger("你不能呼吸!"))
	if(crown)
		qdel(crown)

/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/death(gibbed)
	if(love_target)
		love_target.remove_movespeed_modifier(/datum/movespeed_modifier/unrequited_slowdown)
		say("[love_target.name]... 你曾答应我们的...")
		love_target = null
	if(crown)
		qdel(crown) //this shouldn't be possible for a crown to exist after her breach but we might as well
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	if(!.)
		return
	if(!love_target)
		for(var/mob/living/carbon/human/H in oview(src, suffocation_range))
			if(IsCombatMap())
				if(faction_check(src.faction, H.faction)) // I LOVE NESTING IF STATEMENTS
					continue
			//if there's no love target, they suffocate everyone they can see but you can just get out of her view to stop it
			H.adjustOxyLoss(2, updating_health=TRUE, forced=TRUE)
			new /obj/effect/temp_visual/mermaid_drowning(get_turf(H))
		return

	if(love_target.stat == DEAD)
		say("[love_target.name]? 你没事吧？对不起，是我错了吗？如果我足够爱你，你会回来吗？至少在死后，你会爱我吗?")
		ChangeResistances(list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)) //back to being a pushover
		love_target = null
		return
	//Not having a cooldown on the oxyloss sounds bad, but people's breathing is dictated by Life(), so it's actually the perfect pace of oxyloss
	love_target.adjustOxyLoss(1.5, updating_health=TRUE, forced=TRUE)
	new /obj/effect/temp_visual/mermaid_drowning(get_turf(love_target))

/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(.) //fun fact, the attack chain STOPS when it returns TRUE. This isn't confusing at all.
		return
	if(love_target == user)
		adjustHealth(W.force * 1.25)

/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/PostSpawn()
	..()
	for(var/turf/open/T in range(1, src)) // fill her cell with safe water
		T.TerraformTurf(/turf/open/water/deep/saltwater/safe, flags = CHANGETURF_INHERIT_AIR)

/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/bullet_act(obj/projectile/P)
	. = ..()
	if(!crown?.loved)
		return
	if(P.firer == crown.loved)
		adjustHealth(P.damage * 1.25)

//We adjust the crown wearer success mod according to the counter.
/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/OnQliphothChange(mob/living/carbon/human/user, amount)
	..()
	if(crown?.loved)
		var/crown_mod = crown.success_mod
		crown.loved.physiology.work_success_mod /= crown_mod //We take the mod off temporarily so we don't accidentally add or take off too much.
		if(amount)
			crown_mod += amount*0.05 // If it increases, amount should be positive, if it decreases it should be negative.
		crown_mod = clamp(crown_mod, 1, 1.15)
		crown.success_mod = crown_mod
		crown.loved.physiology.work_success_mod *= crown_mod

//Gives a crown thing when you get good work on her. Anyone can wear the crown, even those that didn't work on her and there can only be one gift at a time.
/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/proc/GiveGift(mob/living/carbon/human/user)
	FluffSpeak("喜欢吗？你肯定喜欢吧？我费了好大功夫做的...")
	addtimer(CALLBACK(src, PROC_REF(FluffSpeak), "如果不喜欢的话...能帮我找个喜欢的人来吗？"), 3 SECONDS)
	var/obj/item/clothing/head/unrequited_crown/UC = new(get_turf(src))
	crown = UC
	crown.throw_at(user, 4, 1, src, spin = FALSE, gentle = TRUE, quickstart = FALSE)
	playsound(get_turf(src), 'sound/abnormalities/piscinemermaid/bigsplash.ogg', 50, 1)
	UC.mermaid = src

//this is basically just teddy bear hugging but you're NOT buckled and the death is much much slower, you can technically survive it if a clerk is giving CPR... maybe
/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/proc/ExcessiveLove()
	if(!petter) // safety check
		pet_count = 0
		return
	// here, we talk to them whilst they are dying, just a tiny bit
	to_chat(petter, span_userdanger("有什么东西正把你拖入水中！"))
	FluffSpeak("真的很抱歉，但没关系对吗？被爱着不是很美好吗？")
	addtimer(CALLBACK(src, PROC_REF(FluffSpeak), "我不过是陷入爱河，不过是渴求救赎。"), 5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(FluffSpeak), "你在水下也能呼吸对吧？"), 30 SECONDS)
	// here, we murder them whilst we are talking
	petter.Stun(2 MINUTES)
	petter.move_resist = MOVE_FORCE_VERY_STRONG
	petter.pull_force = MOVE_FORCE_VERY_STRONG
	var/time_strangled = 0
	while(petter.stat != DEAD)
		if(time_strangled > 2 MINUTES) // if they live for 2 minutes, make sure they are not alive and reset them
			petter.losebreath += 500
			petter.move_resist = MOVE_RESIST_DEFAULT
			petter.pull_force = PULL_FORCE_DEFAULT
			break
		if(petter.stat == DEAD)
			petter.move_resist = MOVE_RESIST_DEFAULT
			petter.pull_force = PULL_FORCE_DEFAULT
			break
		petter.adjustOxyLoss(3, updating_health=TRUE, forced=TRUE)
		time_strangled++
		SLEEP_CHECK_DEATH(1 SECONDS)

//This is a dating sim now fuck you
/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/funpet(mob/living/carbon/human/current_petter)
	..()
	if(!(status_flags & GODMODE))
		return
	if(current_petter != petter)
		response_help_continuous = "pets"
		response_help_simple = "pet"
		pet_count = 0
	pet_count++
	petter = current_petter
	switch(pet_count)
		if(5)
			FluffSpeak("你不会离开的对吧？你爱我对吧?")
		if(10)
			response_help_continuous = "拥抱"
			response_help_simple = "拥抱"
		if(12)
			FluffSpeak("我发誓会变得温柔，你可以永远陪着我...即使我是怪物...")
		if(15)
			response_help_continuous = "十指相扣"
			response_help_simple = "十指相扣"
		if(17)
			FluffSpeak("你确定要留下吗？我如此爱你，我不能——我不想看你离开。")
		if(20)
			ExcessiveLove()

//just so I don't have to handle timers and her saying stuff she shouldn't say while breached
/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/proc/FluffSpeak(sentence)
	if(status_flags & GODMODE)
		say(sentence)

//The crown gives 15% bonus work chance but you need to babysit mermaid constantly, you'll also get absolutely fucked by their breach if it happens at a bad time.
//The work chance is also affected by mermaid's counter, so +10% chance at 2 counter, +5% at 1.
//The crown destroys itself whenever it's taken off the headslot and automatically triggers mermaid's breach
/obj/item/clothing/head/unrequited_crown
	name = "无果之礼"
	desc = "爱我，请爱我。我愿卸下双臂，斩断双足。只求你回以同等的爱。"
	icon_state = "unrequited_gift"
	icon = 'icons/obj/clothing/ego_gear/head.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/head.dmi'
	var/success_mod = 1.15
	var/love_cooldown
	var/love_cooldown_time = 3.3 MINUTES //It takes around 10 minutes for mermaid to breach if left unchecked
	var/mob/living/simple_animal/hostile/abnormality/pisc_mermaid/mermaid
	var/mob/living/carbon/human/loved //What's wrong anon? Unconditional love is what you wanted right?

/obj/item/clothing/head/unrequited_crown/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_HEAD)
		if(loved)
			STOP_PROCESSING(SSobj, src)
			mermaid.datum_reference.qliphoth_change(-3)
			mermaid.BreachEffect()
			qdel(src)
		return
	if(ishuman(user))
		START_PROCESSING(SSobj, src)
		mermaid.datum_reference.qliphoth_change(3)
		user.physiology.work_success_mod *= success_mod
		loved = user //Because, you know? You know? I'm doing it for you after all~
		love_cooldown = world.time + love_cooldown_time

/obj/item/clothing/head/unrequited_crown/process()
	if((love_cooldown < world.time) && loved && mermaid.workingflag != TRUE)
		mermaid.datum_reference.qliphoth_change(-1)
		new /obj/effect/temp_visual/heart(get_turf(loved))
		to_chat(loved, span_warning("你似乎遗忘了某个重要的人..."))
		love_cooldown = world.time + love_cooldown_time

/obj/item/clothing/head/unrequited_crown/Destroy()
	if(loved)
		loved.physiology.work_success_mod /= success_mod
	return ..()

//Mermaid bath water
/obj/effect/mermaid_water
	name = "爱恋之水"
	desc = "这水体承载着与居住者同等的、对爱的绝望渴求"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "mermaid_water"
	layer = BELOW_OBJ_LAYER
	anchored = TRUE

/obj/effect/mermaid_water/unbuckle_mob(mob/living/carbon/human/buckled_mob, force)
	if(buckled_mob.stat == DEAD || buckled_mob.losebreath <= 0) //you can only unbuckle yourself if you somehow survive the oxyloss long enough, or you're dead
		return ..()

///the loved's movespeed is nerfed by a LOT while she's out, meaning if you're in the process of being chased by big bird, I have bad news for you.
/datum/movespeed_modifier/unrequited_slowdown
	variable = TRUE
	multiplicative_slowdown = 2
