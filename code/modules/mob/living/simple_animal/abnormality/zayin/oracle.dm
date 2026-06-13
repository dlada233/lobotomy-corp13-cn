/mob/living/simple_animal/hostile/abnormality/oracle
	name = "没有未来的神谕"
	desc = "一只古老的冷冻尸体，侧面刻着“玛丽亚”的名字. \
		你往里面看，希望看到那个人的尸体, \
		但你看到的只是底部的粘稠物质."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "oracle"
	icon_living = "oracle"
	portrait = "oracle"
	maxHealth = 100
	health = 100
	damage_coeff = list(RED_DAMAGE = 2, WHITE_DAMAGE = 0, BLACK_DAMAGE = 2, PALE_DAMAGE = 2)
	threat_level = ZAYIN_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 70,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 80,
		"入睡" = 100,
	)
	work_damage_upper = 2
	work_damage_lower = 1
	work_damage_type = WHITE_DAMAGE
	max_boxes = 8
	chem_type = /datum/reagent/abnormality/sin/wrath

	ego_list = list(
		/datum/ego_datum/weapon/dead_dream,
		/datum/ego_datum/armor/dead_dream
	)
	gift_type =  /datum/ego_gifts/oracle
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	observation_prompt = "在鲜活的梦境中，你看见她往昔的模样. \
		<br>她曾被告知：沉睡不过弹指一瞬. \
		<br>静眠之人憧憬着应许的未来. \
		<br>在你眼前，无垠时光流转直至某日."
	observation_choices = list(
		"休眠舱破裂" = list(TRUE, "透过视窗见她于梦中惊颤后归于沉寂. \
			<br>你在静默中屏息, \
			<br>你追忆玛丽亚, \
			<br>她永远陷于永不可及的明日之梦."),
		"她苏醒了" = list(FALSE, "休眠舱开启，你目睹她走了出来. \
			<br>她脸上洋溢难言的欢欣，因为所有的一切都被丢在了身后. \
			<br>但随后她如泡影消散，原来这不过是你的一枕黄粱."),
	)

	var/list/sleeplines = list(
		"你好...",
		"我正穿越帷幕与你对话...",
		"我身不能动，口不能言...",
		"但有些事情想要相告...",
		"请稍候，待我寻找关于你的信息....",
		"啊，我了解了下一场考验....你们如此称呼它...",
		"下一场考验将是...",
	)
	var/list/fakeordeals = list(
		//Some Based off the 7 trumpets
		"火与血之雹..... 倾泻大地.... 焚尽自然...",
		"巨山.....坠入汪洋.....血海滔天.....灭绝生灵...",
		"陨星.....坠入尘寰.....毒染清泉...",
		"天幕晦暗.....群星隐没，日月无光.....",
		"灾厄......降临大地众生.....",
		"陨星坠地.....开启无底深渊...",
		"蝗群....蝎尾....人面....狮齿.....",
		"亿万军阵.....火与烟.....瘟疫灭世...",
		"尘世之国终成弥赛亚之国.....永世长存...",
		//And some I made
		"极寒....永无止境的酷寒.....",
		"千臂之人......",
		"无面之妇....与无数孩童的尖啸....",
		// -IP additions
		"在倾颓的走廊...食腐者啃噬着工人...",
		"百目...无尽巨口...修长肢足...恐惧攫住了我...",
		"转角传来声响...我不敢窥看...不愿目睹彼方之物...",
		"房间角落...有人在微笑...他们的皮肤扭曲错位...",
		"光之羽翼自城市升腾...",
		"怪物...无处不在的怪物...当街噬人...",
		"犬首女子...默然吐着烟圈...",
		"蓝衣之人...折叠遁入书页...",
		)

/mob/living/simple_animal/hostile/abnormality/oracle/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/oracle/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/oracle/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_INSIGHT)
		user.drowsyness += 30
		user.Sleeping(30 SECONDS) //Sleep with her, so that you can get some information
		if(pe == max_boxes && !(RememberVar("SpecialDreamDone")))
			var/list/dream_list
			for(var/datum/oracle_dream/possible_dream as anything in subtypesof(/datum/oracle_dream))
				LAZYADDASSOC(dream_list, possible_dream, possible_dream.weight)
			var/chosen_dream = pickweight(dream_list)
			TransferVar("SpecialDreamDone", TRUE)
			SpecialDreams(chosen_dream, user)
			return
		for(var/line in sleeplines)
			to_chat(user, span_notice(line))
			SLEEP_CHECK_DEATH(40)
			if(!user.IsSleeping())
				return
		if(prob(50))
			var/chosenfake = pick(fakeordeals)
			to_chat(user, span_notice("[chosenfake]"))
			return
		if(!SSlobotomy_corp.next_ordeal)
			to_chat(user, span_notice("所有的考验....都已经通过了..."))
			return
		to_chat(user, span_notice("[SSlobotomy_corp.next_ordeal.name]"))
	..()

/mob/living/simple_animal/hostile/abnormality/oracle/Initialize(mob/living/carbon/human/user)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, PROC_REF(OnAbnoBreach))

/mob/living/simple_animal/hostile/abnormality/oracle/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH)
	return ..()


/mob/living/simple_animal/hostile/abnormality/oracle/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type == "入睡")
		user.drowsyness += 30
		user.Sleeping(30 SECONDS) // Won't get any info, but you can listen for any breaches for 30 seconds
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/oracle/proc/OnAbnoBreach(datum/source, mob/living/simple_animal/hostile/abnormality/abno)
	SIGNAL_HANDLER
	if(z != abno.z)
		return
	addtimer(CALLBACK(src, PROC_REF(NotifyEscape), loc, abno), rand(1 SECONDS, 3 SECONDS))

/mob/living/simple_animal/hostile/abnormality/oracle/proc/NotifyEscape(mob/living/carbon/human/user, mob/living/simple_animal/hostile/abnormality/abno)
	if(QDELETED(abno) || abno.stat == DEAD)
		return
	for(var/mob/living/carbon/human/H in GLOB.clients)
		if(H.IsSleeping())
			continue //You need to be sleeping to get notified
		to_chat(H, span_notice("啊.... [abno]... 它突破了收容..."))

//ER stuff
/mob/living/simple_animal/hostile/abnormality/oracle/BreachEffect(mob/living/carbon/human/user, breach_type)//finish this shit
	if(breach_type == BREACH_MINING)
		var/chosenfake = pick(fakeordeals)
		for(var/mob/living/L in livinginrange(48, src))
			if(L.z != z)
				continue
			if(faction_check_mob(L))
				continue
			to_chat(L, span_userdanger("[chosenfake]"))
		addtimer(CALLBACK(src, PROC_REF(NukeAttack)), 90 SECONDS)
	return ..()

/mob/living/simple_animal/hostile/abnormality/oracle/proc/NukeAttack()
	if(stat == DEAD)
		return
	playsound(src, 'sound/magic/wandodeath.ogg', 100, FALSE, 40, falloff_distance = 10)
	for(var/mob/living/L in livinginrange(48, src))
		if(L.z != z)
			continue
		if(faction_check_mob(L))
			continue
		to_chat(L, span_userdanger("可怕的未来在你眼前闪过!"))
		L.deal_damage((50 - get_dist(src, L)), WHITE_DAMAGE)
	qdel(src)

/mob/living/simple_animal/hostile/abnormality/oracle/proc/SpecialDreams(datum/oracle_dream/chosen_dream, mob/living/carbon/human/dreamer)
	if(!chosen_dream.dreamt_abnos)
		return
	if(!dreamer.IsSleeping())
		return
	var/datum/oracle_dream/dream = new chosen_dream
	to_chat(dreamer, span_notice("神谕向你揭示了 [dream.desc]"))

#define ABNO_GET(X) /mob/living/simple_animal/hostile/abnormality/##X // This will make our life SO much easier.
#define VERY_LOW_DREAM_WEIGHT 0.25
#define LOW_DREAM_WEIGHT 0.5

// Base datum type for oracle set dreams.
/datum/oracle_dream
	var/name = "Dream of...nothing?"
	var/desc = "a dream of absolute nothingness. (Contact a developer.)"
	var/dreamlines = "If you see this, something has gone terribly wrong. (Contact a developer pretty please.)"
	var/dreamt_abnos = list()
	var/weight = 1

/datum/oracle_dream/New()
	var/forced_abno = FALSE
	for(var/mob/living/simple_animal/hostile/abnormality/foresighted_abno as anything in dreamt_abnos)
		var/dream_weight = dreamt_abnos[foresighted_abno]
		var/index = foresighted_abno.threat_level
		if(index == ZAYIN_LEVEL && !forced_abno) // Teehee
			forced_abno = TRUE
			log_game("[usr] has locked the queued abnormality to [initial(foresighted_abno.name)] due to the influence of Oracle.")
			SSabnormality_queue.queued_abnormality = foresighted_abno
			SSabnormality_queue.AnnounceLock()
			SSabnormality_queue.ClearChoices()
			minor_announce("Unknown anomalies have caused all extraction attempts to yield the same ZAYIN abnormality. \
			Extraction Headquarters is currently searching for a solution, and it apologizes for the inconvenience.", "Extraction Alert:", TRUE)
		SSabnormality_queue.possible_abnormalities[index][foresighted_abno] *= dream_weight
	qdel(src)

// Dreamlines not added, only descriptions. Therefore descriptions are used to notify players which dream was chosen.
// Obviously, TODO: Dreamlines but dont hold your breath, I am no writer.
/datum/oracle_dream/black_forest
	name = "Dream of a Black Forest"
	desc = "a dream of the forest covered by an eternal darkness and the Beast at the heart of it, wandering endlessly in search of itself."
	dreamt_abnos = list(ABNO_GET(judgement_bird) = 2, ABNO_GET(big_bird) = 2, ABNO_GET(punishing_bird) = 2)
	weight = VERY_LOW_DREAM_WEIGHT

/datum/oracle_dream/magical_girls
	name = "Dream of the Magical Defenders"
	desc = "a dream of the four protectors of realms now long dead, doomed from the very start by the same drives that pushed them into their roles."
	dreamt_abnos = list(ABNO_GET(hatred_queen) = 1.5, ABNO_GET(despair_knight) = 1.5, ABNO_GET(greed_king) = 1.5, ABNO_GET(wrath_servant) = 1.5)
	weight = LOW_DREAM_WEIGHT

/datum/oracle_dream/fairy_feast
	name = "Dream of a Fairy Feast"
	desc = "a dream of deceiving beasts and a brutal feast, all orchestrated by their heartbroken queen."
	dreamt_abnos = list(ABNO_GET(fairy_festival) = 3, ABNO_GET(fairy_gentleman) = 3, ABNO_GET(fairy_longlegs) = 3, ABNO_GET(titania) = 3, ABNO_GET(nobody_is) = 1.5)

/datum/oracle_dream/emerald_path
	name = "Dream of an Emerald Path"
	desc = "a dream of a hopeful group of rejects and their journey to make their dreams come true, a girl sings a tune from distant lands as she walks through a verdant path made of lies."
	dreamt_abnos = list(ABNO_GET(woodsman) = 2, ABNO_GET(scarecrow) = 2, ABNO_GET(scaredy_cat) = 2, ABNO_GET(road_home) = 2)

/datum/oracle_dream/endless_hunt
	name = "Dream of the Endless Hunt"
	desc = "a dream of endless hunts and cyclical hatred. A dog stands besides its master, and a wolf bares its fangs against the hunter."
	dreamt_abnos = list(ABNO_GET(red_hood) = 1.5, ABNO_GET(big_wolf) = 1.5, ABNO_GET(blue_shepherd) = 1.5, ABNO_GET(red_buddy) = 1.5)
	weight = VERY_LOW_DREAM_WEIGHT

/datum/oracle_dream/human_form
	name = "Dream of the Human Form"
	desc = "a dream of human faces and human limbs, human skin and human bones, human organs and human blood, human laughter and human sadness. Everything that makes you human, and makes them not."
	dreamt_abnos = list(ABNO_GET(nothing_there) = 1.5, ABNO_GET(nobody_is) = 1.5, ABNO_GET(kqe) = 1.5, ABNO_GET(pinocchio) = 1.5)

/datum/oracle_dream/suffocating_obsession
	name = "Dream of Suffocating Obsession"
	desc = "a dream of the abyssal depths where countless eyes gaze upon you intently, following your every move." // Honestly out of ideas.
	dreamt_abnos = list(ABNO_GET(dreaming_current) = 2, ABNO_GET(pisc_mermaid) = 2, ABNO_GET(siltcurrent) = 2)

/datum/oracle_dream/forgotten_memorial
	name = "Dream of a Forgotten Memorial"
	desc = "a dream of all the wastelands left behind by the winds of war, and the lonely memorial that watches over those who, even now, cannot escape the battlefield."
	dreamt_abnos = list(ABNO_GET(quiet_day) = 2, ABNO_GET(mhz) = 2, ABNO_GET(khz) = 2, ABNO_GET(army) = 2)

/datum/oracle_dream/shrimp_boat
	name = "Dream of the Shrimpiest Boat"
	desc = "a dream of your shrimp friends in your shrimp boat, fishing shrimps in the shrimpy sea for the shrimp corporation. Life is shrimply awesome."
	dreamt_abnos = list(ABNO_GET(shrimp_exec) = 10, ABNO_GET(wellcheers) = 10)

/datum/oracle_dream/lost_orchard
	name = "Dream of an Lost Orchard"
	desc = "a dream of a forgotten apple orchard, littered with rotting fruit and buried tales. Nevertheless, the decaying apples and the maggots within refuse to decay into non-existence."
	dreamt_abnos = list(ABNO_GET(golden_apple) = 5, ABNO_GET(snow_whites_apple) = 5, ABNO_GET(ebony_queen) = 5)

/datum/oracle_dream/bustling_hive
	name = "Dream of a Bustling Hive"
	desc = "a dream of labyrinthine passages inside a titanic beehive, where workers toil endlessly and soldiers stand in everlasting vigil. All for the Queen."
	dreamt_abnos = list(ABNO_GET(queen_bee) = 5, ABNO_GET(general_b) = 5)

/datum/oracle_dream/new_purpose
	name = "Dream of a New Purpose"
	desc = "a dream of a massive queue of purposeless people waiting in front of a colossal construct of machinery and flesh. On the other side, a conveyor belt transports a neverending procession of smiling automata."
	dreamt_abnos = list(ABNO_GET(we_can_change_anything) = 2, ABNO_GET(cleaner) = 2, ABNO_GET(helper) = 2, ABNO_GET(you_strong) = 2, ABNO_GET(steam) = 2, ABNO_GET(kqe) = 2, ABNO_GET(singing_machine) = 2)

/datum/oracle_dream/fated_harmony
	name = "Dream of Fated Harmony"
	desc = "a dream of the festering proliferation of all that is and the desolate silence of all that isn't, lacking in the harmony that can only be restored when the angel and the demon reunite once more."
	dreamt_abnos = list(ABNO_GET(yin) = 5, ABNO_GET(yang) = 5)

/datum/oracle_dream/one_sin // yes, its just the name of the abno. One Sin is dapper like that.
	name = "Dream of the One Sin"
	desc = "a dream of yourself facing a floating skull, while overwhelming light surrounds you on all sides. A booming voice announces its presence, but it's just you and the skull, awaiting your sins. The voice demands your worship, but it's just you and the skull, listening to your confession. The voice declares you a heretic, but it's just you and the skull, judging yet forgiving. As the voice finally grows silent, the skull gently asks: \"Have you found the answers you were looking for?\""
	dreamt_abnos = list(ABNO_GET(onesin) = 5, ABNO_GET(white_night) = 5)

/datum/oracle_dream/soft_hugs
	name = "Dream of Soft Hugs"
	desc = "a dream of factories and production lines churning out soft hugs and shining smiles. The affection that powers these machines will run out someday but, for now, this place is where happiness is born."
	dreamt_abnos = list(ABNO_GET(hurting_teddy) = 5, ABNO_GET(happyteddybear) = 5)

/datum/oracle_dream/possesive_chains // Do you think agents will celebrate when getting this dream?
	name = "Dream of Possesive Chains"
	desc = "a dream of a treacherous swamp filled with wraiths of all forms and sizes. A hermit traverses the area, yet for each mile they cross more and more wraiths chain themselves to their body, starving for attention. The wraith's many boons protect the hermit from the dangers of predators and sickness, yet one forgotten ritual is all that it takes for all wraiths to turn on them. Nothing remained afterwards but a deafening silence."
	dreamt_abnos = list(ABNO_GET(hurting_teddy) = 1.5, ABNO_GET(whitelake) = 1.5, ABNO_GET(pisc_mermaid) = 1.5, ABNO_GET(galaxy_child) = 1.5, ABNO_GET(despair_knight) = 1.5, ABNO_GET(wrath_servant) = 1.5, ABNO_GET(pygmalion) = 1.5, ABNO_GET(titania) = 1.5, ABNO_GET(melting_love) = 1.5, ABNO_GET(staining_rose) = 1.5)
	weight = VERY_LOW_DREAM_WEIGHT

/datum/oracle_dream/melting_clocks // Do you think agents will despair when getting this dream?
	name = "Dream of Melting Clocks"
	desc = "a dream of a field of clockwork pieces, melting under a searing sun. Time drips down slowly from the melting contraptions, like a drop of tar yearning to be one with the soil, yet it is always scooped up and put back into the clocks to begin the cycle anew."
	dreamt_abnos = list(ABNO_GET(sirocco) = 3, ABNO_GET(siren) = 3, ABNO_GET(express_train) = 3, ABNO_GET(silence) = 3, ABNO_GET(nosferatu) = 3, ABNO_GET(seasons) = 3, ABNO_GET(black_sun) = 3, ABNO_GET(staining_rose) = 3)

/datum/oracle_dream/overgrown_forest
	name = "Dream of an Overgrown Forest"
	desc = "a dream of an endlessly growing forest, consuming anything in its path. The ground is wet and mushy with the remains of plants long dead, fertilizing the soil to let their brethren thrive."
	dreamt_abnos = list(ABNO_GET(fallen_amurdad) = 2, ABNO_GET(cherry_blossoms) = 2, ABNO_GET(golden_apple) = 2, ABNO_GET(snow_whites_apple) = 2, ABNO_GET(ebony_queen) = 2, ABNO_GET(alriune) = 2, ABNO_GET(rose_sign) = 2, ABNO_GET(parasite_tree) = 2, ABNO_GET(orange_tree) = 2, ABNO_GET(staining_rose) = 2)

#undef VERY_LOW_DREAM_WEIGHT
#undef LOW_DREAM_WEIGHT
#undef ABNO_GET // Do we want this for general use? Who knows but better safe than sorry.
