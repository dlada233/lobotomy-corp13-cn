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

	work_start_lines = list("她当初被告知，时间会一眨眼就过去.")
	early_work_lines = list("如今的静滞技术更加可靠，但事故依然会发生.")
	work_end_lines = list("她是否仍在梦见那个她入睡时等待的世界，还是说，她现在梦见的是自己抛下的一切？")

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
	return ..()

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
		L.deal_damage((50 - get_dist(src, L)), WHITE_DAMAGE, attack_type = (ATTACK_TYPE_SPECIAL))
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
	name = "黑森林之梦"
	desc = "一场关于被永恒黑暗笼罩的森林的梦，以及盘踞其中心的野兽——它用永无止境地游荡来寻找自己."
	dreamt_abnos = list(ABNO_GET(judgement_bird) = 2, ABNO_GET(big_bird) = 2, ABNO_GET(punishing_bird) = 2)
	weight = VERY_LOW_DREAM_WEIGHT

/datum/oracle_dream/magical_girls
	name = "魔法守护者之梦"
	desc = "一场关于四位守护者的梦，她们所守护的王国早已消亡；而造成这一切的原因正是她们心中最初想要成为守护者的心念."
	dreamt_abnos = list(ABNO_GET(hatred_queen) = 1.5, ABNO_GET(despair_knight) = 1.5, ABNO_GET(greed_king) = 1.5, ABNO_GET(wrath_servant) = 1.5)
	weight = LOW_DREAM_WEIGHT

/datum/oracle_dream/fairy_feast
	name = "精灵盛宴之梦"
	desc = "一场关于狡诈的野兽与残酷盛宴的梦，一切皆由它们心碎的女王策划."
	dreamt_abnos = list(ABNO_GET(fairy_festival) = 3, ABNO_GET(fairy_gentleman) = 3, ABNO_GET(fairy_longlegs) = 3, ABNO_GET(titania) = 3, ABNO_GET(nobody_is) = 1.5)

/datum/oracle_dream/emerald_path
	name = "翡翠路之梦"
	desc = "一场关于一群满怀希望的残缺者、以及他们那实现梦想的旅程的梦；一个女孩走过由谎言铺就的翠绿小径，唱着来自遥远国度的歌谣."
	dreamt_abnos = list(ABNO_GET(woodsman) = 2, ABNO_GET(scarecrow) = 2, ABNO_GET(scaredy_cat) = 2, ABNO_GET(road_home) = 2)

/datum/oracle_dream/endless_hunt
	name = "无尽狩猎之梦"
	desc = "一场关于无尽猎杀与冤冤相报的梦。忠诚的狗站在主人身旁，而狼则向猎人龇露獠牙。"
	dreamt_abnos = list(ABNO_GET(red_hood) = 1.5, ABNO_GET(big_wolf) = 1.5, ABNO_GET(blue_shepherd) = 1.5, ABNO_GET(red_buddy) = 1.5)
	weight = VERY_LOW_DREAM_WEIGHT

/datum/oracle_dream/human_form
	name = "人形之梦"
	desc = "一场关于人类面孔、人类肢体、人类皮肤、人类骨骼、人类器官、人类血液、人类欢笑与人类悲伤的梦. 一切使你成为人、却使它们非人的东西. "
	dreamt_abnos = list(ABNO_GET(nothing_there) = 1.5, ABNO_GET(nobody_is) = 1.5, ABNO_GET(kqe) = 1.5, ABNO_GET(pinocchio) = 1.5)

/datum/oracle_dream/suffocating_obsession
	name = "窒息执念之梦"
	desc = "一场关于深渊的梦，无数眼睛凝视着你，紧随你的一举一动." // Honestly out of ideas.
	dreamt_abnos = list(ABNO_GET(dreaming_current) = 2, ABNO_GET(pisc_mermaid) = 2, ABNO_GET(siltcurrent) = 2)

/datum/oracle_dream/forgotten_memorial
	name = "遗忘纪念碑之梦"
	desc = "一场梦，梦中有战火席卷过后留下的遍地荒原，以及那座孤独的纪念碑——它守望着那些至今仍无法逃离战场的人."
	dreamt_abnos = list(ABNO_GET(quiet_day) = 2, ABNO_GET(mhz) = 2, ABNO_GET(khz) = 2, ABNO_GET(army) = 2)

/datum/oracle_dream/shrimp_boat
	name = "最虾之梦"
	desc = "一场关于你的虾朋友、你的虾船，以及为虾公司在虾气腾腾的大海里捕虾的梦，生活真是虾妙无比."
	dreamt_abnos = list(ABNO_GET(shrimp_exec) = 10, ABNO_GET(wellcheers) = 10)

/datum/oracle_dream/lost_orchard
	name = "失落果园之梦"
	desc = "一场关于被遗忘的苹果园的梦，园中散落着腐烂的果实与被埋葬的故事. 其中那些腐坏的苹果与其中的蛆虫，拒绝彻底腐朽、化为虚无。"
	dreamt_abnos = list(ABNO_GET(golden_apple) = 5, ABNO_GET(snow_whites_apple) = 5, ABNO_GET(ebony_queen) = 5)

/datum/oracle_dream/bustling_hive
	name = "熙攘蜂巢之梦"
	desc = "一场关于巨型蜂巢内迷宫般通道的梦；工蜂无尽劳作，兵蜂永恒守望。一切皆为了女王。"
	dreamt_abnos = list(ABNO_GET(queen_bee) = 5, ABNO_GET(general_b) = 5)

/datum/oracle_dream/new_purpose
	name = "新目标之梦"
	desc = "一场关于失去目的的人们排着长队，等候在一座由机械与血肉构成的庞然巨物前的梦。在巨物另一侧，传送带正运送着一列列永无止境、面带微笑的自动人偶。"
	dreamt_abnos = list(ABNO_GET(we_can_change_anything) = 2, ABNO_GET(cleaner) = 2, ABNO_GET(helper) = 2, ABNO_GET(you_strong) = 2, ABNO_GET(steam) = 2, ABNO_GET(kqe) = 2, ABNO_GET(singing_machine) = 2)

/datum/oracle_dream/fated_harmony
	name = "命定和谐之梦"
	desc = "一场梦，梦中“有”的一切在腐坏中滋蔓，“无”的一切只剩荒芜死寂；二者失去了和谐，唯有天使与恶魔再度重聚，这份和谐才能恢复。"
	dreamt_abnos = list(ABNO_GET(yin) = 5, ABNO_GET(yang) = 5)

/datum/oracle_dream/one_sin // yes, its just the name of the abno. One Sin is dapper like that.
	name = "一罪之梦"
	desc = "一场关于你自己的梦：你面对着一个漂浮的骷髅，压倒性的光芒从四面八方包围着你。一个洪亮的声音宣告它的存在，但这里只有你和那骷髅，等待着你的罪孽。那声音要求你崇拜，但这里只有你和那骷髅，聆听你的告解。那声音宣判你为异端，但这里只有你和那骷髅，审判着，却又宽恕着。当那声音终于沉寂，骷髅温和地问道: \"你找到一直在寻找的答案了吗?\""
	dreamt_abnos = list(ABNO_GET(onesin) = 5, ABNO_GET(white_night) = 5)

/datum/oracle_dream/soft_hugs
	name = "柔软抱抱之梦"
	desc = "一场关于工厂与生产线的梦，它们源源不断地制造出柔软的拥抱与闪亮的笑容。虽然驱动这些机器的爱意终有一日会耗尽，但至少现在，这里是幸福诞生之地。"
	dreamt_abnos = list(ABNO_GET(hurting_teddy) = 5, ABNO_GET(happyteddybear) = 5)

/datum/oracle_dream/possesive_chains // Do you think agents will celebrate when getting this dream?
	name = "渴望占有之梦"
	desc = "一场梦，梦中有一片险恶的沼泽，其中满是形形色色、大小不一的怨灵。有位隐士想要穿行其间，可他每走一步，就会有许多怨灵缠上身体，怨灵们如饥似渴地索求关注。怨灵带来的诸多恩惠保护着隐士免受掠食者与疾病之害，然而只要关于遗忘的仪式开始进行，怨灵们就会回头袭来，最终只剩一片死寂。"
	dreamt_abnos = list(ABNO_GET(hurting_teddy) = 1.5, ABNO_GET(whitelake) = 1.5, ABNO_GET(pisc_mermaid) = 1.5, ABNO_GET(galaxy_child) = 1.5, ABNO_GET(despair_knight) = 1.5, ABNO_GET(wrath_servant) = 1.5, ABNO_GET(pygmalion) = 1.5, ABNO_GET(titania) = 1.5, ABNO_GET(melting_love) = 1.5, ABNO_GET(staining_rose) = 1.5)
	weight = VERY_LOW_DREAM_WEIGHT

/datum/oracle_dream/melting_clocks // Do you think agents will despair when getting this dream?
	name = "融化钟表之梦"
	desc = "一场关于遍地钟表零件的梦，它们在灼热烈日下融化。时间从融化的机械装置中缓缓滴落，像一滴渴望与泥土融为一体的焦油，却总会被重新舀起、装回钟表，使得循环再度开始."
	dreamt_abnos = list(ABNO_GET(sirocco) = 3, ABNO_GET(siren) = 3, ABNO_GET(express_train) = 3, ABNO_GET(silence) = 3, ABNO_GET(nosferatu) = 3, ABNO_GET(seasons) = 3, ABNO_GET(black_sun) = 3, ABNO_GET(staining_rose) = 3)

/datum/oracle_dream/overgrown_forest
	name = "蔓生森林之梦"
	desc = "一场关于无尽生长的森林的梦，它吞噬沿途的一切。地面因植物残骸而湿软泥泞，这些残骸肥沃了土壤，让它们的同类得以繁茂生长。"
	dreamt_abnos = list(ABNO_GET(fallen_amurdad) = 2, ABNO_GET(cherry_blossoms) = 2, ABNO_GET(golden_apple) = 2, ABNO_GET(snow_whites_apple) = 2, ABNO_GET(ebony_queen) = 2, ABNO_GET(alriune) = 2, ABNO_GET(rose_sign) = 2, ABNO_GET(parasite_tree) = 2, ABNO_GET(orange_tree) = 2, ABNO_GET(staining_rose) = 2)

#undef VERY_LOW_DREAM_WEIGHT
#undef LOW_DREAM_WEIGHT
#undef ABNO_GET // Do we want this for general use? Who knows but better safe than sorry.
