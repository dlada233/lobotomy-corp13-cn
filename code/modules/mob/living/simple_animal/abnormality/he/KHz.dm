//This is an abnormality where you get a callsign in and have to give the correct output
/mob/living/simple_animal/hostile/abnormality/khz
	name = "680 KHz"
	desc = "桌上放着一台业余无线电."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "radio"
	portrait = "khz"
	maxHealth = 300
	health = 300
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 40,
		"输入一" = 0,		//These should never be used, but it's here for brevity
		"输入零" = 0,
	)
	work_damage_upper = 4
	work_damage_lower = 3
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/envy

	can_spawn = FALSE // Does Nothing.
	ego_list = list(
		/datum/ego_datum/weapon/transmission,
		/datum/ego_datum/armor/transmission,
	)
	gift_type = /datum/ego_gifts/transmission

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/quiet_day = 1.5,
		/mob/living/simple_animal/hostile/abnormality/mhz = 1.5,
		/mob/living/simple_animal/hostile/abnormality/army = 1.5,
	)

	observation_prompt = "一阵微弱的嗡鸣从你的收音机传入耳中。<br>\
		枪声。<br>战斗的声响。<br>\
		\"Sierra... Oscar... Sierra...\"<br>\
		这个呼号可能意味着什么？<br>\
		身处险境的是你，还是别人？<br>你要怎么做？"
	observation_choices = list(
		"将收音机调至680千赫" = list(TRUE, "突然间，你清晰地听到收音机传来声音。<br>\
			\"我们听得很清楚。\"<br>\
			\"你立了大功。\"<br>\
			另一端的操作员继续说着什么，但声音完全被重新出现的静电噪音淹没。<br>\
			不过看起来你似乎阴差阳错地解决了他们的问题。"),
		"不予理会" = list(FALSE, "你关掉收音机离开了房间。<br>\
			所有异常存在都是危险的，对吧？<br>\
			这求救声可能只是诱你放松警惕的陷阱。<br>\
			若真有人身陷险境，他们也只能靠自己了。"),
	)

	var/input
	var/bitposition = 4	//You write in bits. You need to successfully write a string of 5 to sucessfully work
	var/bitcalculator = 0
	var/isopen
	var/list/worked = list()

//This is related to setting inputs
/mob/living/simple_animal/hostile/abnormality/khz/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type == "输入一" && isopen)
		active()
		InputOne(user)
		return FALSE
	else if(work_type == "输入零" && isopen)
		active()
		InputZero(user)
		return FALSE
	else if(work_type == "输入零" || work_type == "输入零" && !isopen)
		to_chat(user, span_notice("你没有收到输入."))
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/khz/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(!isopen)	//Can't input the first time
		isopen = TRUE

	//Heal everyone and reset the bit calculator
	if(bitcalculator == input && isopen)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			H.adjustSanityLoss(-5)
			to_chat(H, span_notice("你感觉到一种悦耳的声音."))

	//If you fuck it up
	else if(bitcalculator != input && bitcalculator != 0 && isopen)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(z != H.z)
				continue
			H.adjustSanityLoss(20)
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(H), pick(GLOB.alldirs))
			to_chat(H, span_notice("你感到脑袋里有噼里啪啦的声音."))
	bitcalculator = 0

	//If you're new, grab a callsign paper. Also set new input
	if(!(user in worked))
		worked+=user
		new /obj/item/paper/fluff/radio_call(get_turf(user))
	SetInput()

/mob/living/simple_animal/hostile/abnormality/khz/proc/SetInput()
	var/output = rand(1, 7)
	bitposition = 4
	active()
	//Selecting input and playing sound effect
	switch(output)
		if(1)
			playsound(get_turf(src), 'sound/abnormalities/khz/Clip1.ogg', 300, 8)
			input = 8	//01000
		if(2)
			playsound(get_turf(src), 'sound/abnormalities/khz/Clip2.ogg', 300, 8)
			input = 25	//11001
		if(3)
			playsound(get_turf(src), 'sound/abnormalities/khz/Clip3.ogg', 300, 8)
			input = 24	//11000
		if(4)
			playsound(get_turf(src), 'sound/abnormalities/khz/Clip4.ogg', 300, 8)
			input = 13	//01101
		if(5)
			playsound(get_turf(src), 'sound/abnormalities/khz/Clip5.ogg', 300, 8)
			input = 26	//11010
		if(6)
			playsound(get_turf(src), 'sound/abnormalities/khz/Clip6.ogg', 300, 8)
			input = 16	//10000
		if(7)
			playsound(get_turf(src), 'sound/abnormalities/khz/Clip7.ogg', 300, 8)
			input = 28	//11100

//This is for sending messages back
/mob/living/simple_animal/hostile/abnormality/khz/proc/InputOne(mob/living/carbon/human/user)
	if (bitposition>=0)
		bitcalculator += 1*2**bitposition
		bitposition -=1
		to_chat(user, span_notice("你输入一."))
	else
		to_chat(user, span_notice("只能输入5位数字."))

/mob/living/simple_animal/hostile/abnormality/khz/proc/InputZero(mob/living/carbon/human/user)
	if (bitposition>=0)
		bitcalculator += 0*2**bitposition
		bitposition -=1
		to_chat(user, span_notice("你输入零."))
	else
		to_chat(user, span_notice("只能输入5位数字."))

//What happens if the stars align
/mob/living/simple_animal/hostile/abnormality/khz/WorkChance(mob/living/carbon/human/user, chance)
	if(bitcalculator == input)
		var/newchance = chance+20 //Great Work son
		return newchance
	if(bitcalculator > 0 && bitcalculator != input)
		var/newchance = chance-20 //Go fuck yourself.
		return newchance
	return chance

/mob/living/simple_animal/hostile/abnormality/khz/proc/active()
	icon_state = "radio-on"
	addtimer(CALLBACK(src, PROC_REF(deactive)), 3 SECONDS)

/mob/living/simple_animal/hostile/abnormality/khz/proc/deactive()
	icon_state = "radio"


/obj/item/paper/fluff/radio_call
	name = "无线电呼叫"
	info = {"输入并发回. <br>
	Delta - Oscar - Lima 	> 01000	<br>
	Charlie - Echo - Papa	> 11001	<br>
	Yankee - Echo - Oscar	> 11000	<br>
	Hotel - Oscar - Charlie	> 01101	<br>
	Whiskey - Echo- Whiskey	> 11010	<br>
	Delta - Alpha - Xray	> 10000	<br>
	Lima - Alpha - Delta	> 11100	<br>
	"}

