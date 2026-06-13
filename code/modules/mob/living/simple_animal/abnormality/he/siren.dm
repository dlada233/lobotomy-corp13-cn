//Code by Coxswain sprites by Sky
/mob/living/simple_animal/hostile/abnormality/siren
	name = "塞壬"
	desc = "唱着过去的海妖."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	pixel_x = -16
	base_pixel_x = -16
	icon_state = "siren"
	portrait = "siren"
	maxHealth = 400
	health = 400
	speak_emote = list("plays")
	threat_level = HE_LEVEL
	start_qliphoth = 5
	minimum_distance = 3 //runs away during pink midnight
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 25,
		ABNORMALITY_WORK_INSIGHT = 80,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/sloth

	ego_list = list(
		/datum/ego_datum/weapon/song,
		/datum/ego_datum/weapon/songmini,
		/datum/ego_datum/armor/song,
	)
	gift_type = /datum/ego_gifts/song

	observation_prompt = "祖父曾深爱这首歌，他说这是和祖母第一次共舞和初吻时的曲子。<br>\
		祖母去世后他不停播放这首歌，直到唱片变形。<br>\
		久别后我去探望他，发现歌曲没有播放。<br>\
		\"不是那首歌了，\"他下巴抵着紧握的双手低语，握得指节发白。<br>\
		\"为什么不是同一首歌了？\""
	observation_choices = list(
		"再次播放" = list(TRUE, "唱片开始转动，扭曲的慢歌在空气中回荡。<br>\
			\"没有她在这里，这首歌就不一样了...\""),
		"扔掉唱片" = list(FALSE, "你把旧唱片扔进垃圾桶，用旧的唱片摔得粉碎。<br>\
			\"不！现在我怎么记住她？\"祖父哀嚎着冲向你，眼中充满愤怒，却在半途停下。<br>\
			\"...你又是谁？\""),
	)

//meltdown effects
	var/meltdown_cooldown_time = 144 SECONDS
	var/meltdown_cooldown
	var/song_cooldown_time = 60 SECONDS
	var/song_cooldown
	var/meltdown_imminent = FALSE
	pet_bonus = "beeps" //saves a few lines of code by allowing funpet() to be called by attack_hand()
	var/meltdown = FALSE
//Post-work effect
	var/musictimer
//SFX
	var/datum/looping_sound/siren_musictime/musictime
	var/playstatus = FALSE
	var/playrange = 40

//Spawn/music stuff
/mob/living/simple_animal/hostile/abnormality/siren/Initialize()
	. = ..()
	musictime = new(list(src), FALSE)

/mob/living/simple_animal/hostile/abnormality/siren/Life() //todo : rewrite this is a more concise way
	. = ..()
	if(meltdown_cooldown < world.time && !datum_reference.working && !playstatus) // Doesn't decrease while working or playing music but will afterwards
		meltdown_cooldown = world.time + meltdown_cooldown_time
		datum_reference.qliphoth_change(-1)
		meltdown_imminent = FALSE

	if(datum_reference.qliphoth_meter == 1 && !meltdown_imminent) // Is qliphoth 1? Have we not run this yet? If true, play warning sound
		meltdown_imminent = TRUE
		playsound(src, 'sound/abnormalities/siren/burningmemory.ogg', 100, FALSE, 40, falloff_distance = 20, channel = CHANNEL_SIREN)
		playstatus = TRUE
		musictimer = addtimer(CALLBACK(src, PROC_REF(stopPlaying)), 55 SECONDS, TIMER_STOPPABLE)
		icon_state = "siren_breach"
		warning()

	if(song_cooldown < world.time && !datum_reference.qliphoth_meter) // 0 Qliphoth, time to start waking up the abnormalities
		musictime.start()
		SSlobotomy_corp.InitiateMeltdown(round(SSlobotomy_corp.qliphoth_meltdown_amount/3)+1, TRUE)
		song_cooldown = world.time + song_cooldown_time
		playstatus = TRUE

	if(playstatus && !datum_reference.qliphoth_meter) // Abnormality wake-up on cooldown? Play a warning instead.
		warning()

	else if(playstatus && datum_reference.qliphoth_meter >= 2) //O h, we're at a high qliphoth and still playing music for some reason? let's heal people instead
		blessing()

/mob/living/simple_animal/hostile/abnormality/siren/proc/stopPlaying() // This does exactly what it says on the tin.
	for(var/mob/living/carbon/human/H in livinginrange(playrange, src))
		H.stop_sound_channel(CHANNEL_SIREN)
	if(!datum_reference.qliphoth_meter)
		musictime.stop()
		for(var/mob/living/carbon/human/H in livinginrange(playrange, src))
			to_chat(H, span_warning("音乐声开始减弱.")) // This is specifically to let players know that abnormalities are no longer breaching
	playstatus = 0
	icon_state = "siren"

//Work-related
/mob/living/simple_animal/hostile/abnormality/siren/WorkChance(mob/living/carbon/human/user, chance, work_type) //Insight work has a qliphoth-based success rate
	if(work_type != ABNORMALITY_WORK_INSIGHT)
		return chance
	var/chance_modifier = (datum_reference.qliphoth_meter * 20)
	return chance - chance_modifier

/mob/living/simple_animal/hostile/abnormality/siren/proc/turnBackTime(mob/living/carbon/human/user) //Insight work does a bunch of whacky stuff
	var/mob/living/carbon/human/H = user
	var/currentage = H.age
	var/message
	if(datum_reference.qliphoth_meter >= 5) //If we're at max qliphoth, die!
		to_chat(user, span_danger("你记得的最后一件事就是你的心脏停止跳动."))
		playsound(loc, 'sound/magic/clockwork/ratvar_attack.ogg', 50, TRUE, channel = CHANNEL_SIREN)
		user.dust(TRUE, TRUE)
		return
	H.age = rand(17 , 85) //minimum age is 17, max is 85. We do a funny and change the user's age to something random.
	if (H.age > currentage)
		message += "你觉得自己变老了，头脑清醒了."
		user.adjustSanityLoss(-user.maxSanity * 0.3) // It's healing
	else if (H.age < currentage)
		message += "你觉得自己更年轻、更有活力."
		user.adjustBruteLoss(-user.maxHealth * 0.3)
	else
		message += "这次好像没起什么作用."

	to_chat(H, span_warning("[message]"))

	if(!playstatus && datum_reference.qliphoth_meter <= 1) //Qlihphoth is at or below 1 and insight work was performed? play the healing song!
		playsound(loc, 'sound/abnormalities/siren/backtherebenjamin.ogg', 50, FALSE,40, falloff_distance = 20, channel = CHANNEL_SIREN)
		playstatus = TRUE //prevents song overlap
		if(musictimer)
			deltimer(musictimer)
		musictimer = addtimer(CALLBACK(src, PROC_REF(stopPlaying)), 60 SECONDS, TIMER_STOPPABLE)
		icon_state = "siren_breach"

//Breach
/mob/living/simple_animal/hostile/abnormality/siren/funpet() //All it takes is someone to turn it off, either manually
	if(playstatus && !datum_reference.qliphoth_meter)
		stopPlaying()
		datum_reference.qliphoth_change(3)
		return

/mob/living/simple_animal/hostile/abnormality/siren/PostWorkEffect(mob/living/carbon/human/user, work_type, pe) //Or by working
	if(datum_reference.qliphoth_meter <= 1)
		stopPlaying()
	if(work_type == ABNORMALITY_WORK_INSIGHT)
		turnBackTime(user)
	datum_reference.qliphoth_change(5)
	return

/mob/living/simple_animal/hostile/abnormality/siren/proc/warning() //A bunch of messages for various occasions
	if(datum_reference.qliphoth_meter > 0)
		for(var/mob/living/carbon/human/H in livinginrange(playrange, src))
			to_chat(H, span_warning("异常似乎不安分..."))
		return

	for(var/mob/living/carbon/human/H in livinginrange(playrange, src))
		to_chat(H, span_warning("随着音乐的播放，这些异想体也随之共鸣..."))
	icon_state = "siren_breach"

/mob/living/simple_animal/hostile/abnormality/siren/proc/blessing()
	for(var/mob/living/carbon/human/H in livinginrange(playrange, src))
		to_chat(H, span_nicegreen("随着音乐的播放，这些异想体也随之共鸣."))
		H.adjustSanityLoss(-3) // It's healing
	return
