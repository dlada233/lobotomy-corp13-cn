#define STATUS_EFFECT_WAR_STORY /datum/status_effect/quiet/warstory
#define STATUS_EFFECT_PARABLE /datum/status_effect/quiet/parable
#define STATUS_EFFECT_WIFE_STORY /datum/status_effect/quiet/wife
#define STATUS_EFFECT_DEMENTIA_RAMBLINGS /datum/status_effect/quiet/dementia

/mob/living/simple_animal/hostile/abnormality/quiet_day
	name = "寂寥一日"
	desc = "一张被风吹雨打过的旧长凳，让你产生一种奇怪的怀旧感，就像湖边的春日."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "quiet_day"
	core_icon = "quiet_day"
	portrait = "quiet_day"
	maxHealth = 75
	health = 75
	blood_volume = 0
	threat_level = ZAYIN_LEVEL
	faction = list("hostile", "neutral")
	//Bad for stat gain, but the damage is negligable and there's a nice bonus at the end
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 60,
		ABNORMALITY_WORK_REPRESSION = 60,
	)
	work_damage_upper = 2
	work_damage_lower = 1
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gloom

	ego_list = list(
		/datum/ego_datum/weapon/nostalgia,
		/datum/ego_datum/armor/nostalgia,
	)
	gift_type =  /datum/ego_gifts/nostalgia

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/mhz = 1.5,
		/mob/living/simple_animal/hostile/abnormality/khz = 1.5,
		/mob/living/simple_animal/hostile/abnormality/army = 1.5,
	)

	chem_type = /datum/reagent/abnormality/quiet_day
	harvest_phrase = span_notice("%ABNO 好奇地看了 %VESSEL 一会儿. 你眨了眨眼，它里面似乎突然多了一种阴影般的物质.")
	harvest_phrase_third = "%ABNO 瞥了 %PERSON 一眼. 突然，%VESSEL 似乎变得更满了."

	observation_prompt = "一个老人的影子似乎在沉思着什么. <br>\
		\"你有没有想过回到那些美好的时光? 去尽情享受生活? <br>\
		去重温生命中最精彩的时刻? <br>\
		去记起她的面容? 去记起那个年轻人的名字? <br>\
		也许我这样问很傻. 我想听听你的看法，年轻人. <br>\
		追寻那些古老、熟悉的记忆，值得吗?\""
	observation_choices = list(
		"也许向前看更好." = list(TRUE, "\"我想你说得对.\" <br>\
			\"如果我连他们的名字和面容都记不清，那些记忆还有什么价值呢?\" <br>\
			\"走吧. 趁你还没忘记太多，离开吧.\""),
		"这没有错." = list(FALSE, "\"确实. 这没什么坏处，对吧?\" <br>\
			\"...可为什么我就是想不起她的脸?\" <br>\
			就在你准备离开时，你听到老人沙哑地问了一句. \"你又是谁来着?\""),
	)

	var/performed_work
	var/datum/looping_sound/quietday_ambience/soundloop

	var/list/war_story = list(
		"啊，看来你对我在‘烟霾战争’中的经历感兴趣，我很乐意告诉你.",
		"战争期间，我在L公司担任医疗兵. 那真是一段令人心力交瘁、心碎的经历，看着那么多年轻人在前线受伤或牺牲.",
		"那是个雾蒙蒙的早晨，我们小队奉命在‘巢’的一条走廊里阻击敌人的进攻.",
		"枪炮和爆炸产生的烟雾让我们几乎看不清几英尺外的东西，但我们知道敌人就在外面，某个地方.",
		"我们损失惨重. 我记得我尽可能快地给伤员包扎，试图让他们撑到被送往战地医院.",
		"有一次，当我拖着一个受伤的女人后撤时，我发现自己落了单，我能听到脚步声越来越近，我做好了战斗的准备.",
		"但当那个身影从拐角出现时，我看到那只是个年轻的Zwei协会收尾人，几乎还是个孩子.",
		"他捂着侧腹，鲜血浸透了他的制服. 从他脸上的表情我能看出他吓坏了，我一边处理他的伤口，一边尽力安抚他.",
		"当我处理完伤口，准备帮他撤到安全地带时，他含着泪抬头看着我说，\"谢谢您，先生，您是个真正的绅士.\"",
		"那是我最后一次听到他的消息，我在把那个女人拖回安全地带的路上被击中了后背.",
	)

	var/list/parable = list(
		"当然，我很乐意分享一个寓言故事. ",
		"从前，在一个山谷中的小村庄里，住着一位智慧的老人. 一天，一位年轻的旅行者来到村子，找到了这位老人，希望能从他那里学到智慧. ",
		"年轻的旅行者问老人：\"幸福而充实生活的秘诀是什么？\" 老人回答：\"我会示范给你看. \"",
		"他把年轻的旅行者带到附近的一条河边，领着他走进水里. 当他们涉入浅滩时，老人突然抓住年轻人的头，把他按进水里. ",
		"起初，年轻的旅行者挣扎着反抗老人的钳制，拼命想要呼吸. 但当他开始失去意识时，老人松开了手，把他拉回了水面. ",
		"年轻的旅行者喘着粗气，咳嗽着，呛着水，质问老人为什么要这样做. 老人回答：\"当你在水下时，你最想要这世上的什么东西？\"",
		"年轻的旅行者想了一下，然后回答：\"空气. 我最想要空气. \"",
		"老人微笑着说：\"没错. 幸福而充实生活的秘诀，就是像你在水下渴望空气那样去渴望某样东西. 那种动力和决心会帮助你实现你决心要做成的任何事. \"",
	)

	var/list/wife = list(
		"当然，我很乐意分享一个关于我亲爱的妻子的故事. ",
		"我和我的妻子都来自L公司，我们在同一个办公室共事了很多年. 我们之间有一种特殊的纽带，不仅是夫妻，也是拥有共同职业热情的同事. ",
		"有一天，她看起来压力极大. ",
		"我问她是否一切都好，她向我倾诉说她担心自己在一份报告中犯了个错误. ",
		"我是个非常冷静的人，我向她保证我们会一起修正错误，确保一切无误. 我们熬了一整夜仔细检查报告，反复核对确保所有数据准确. ",
		"当我们完成时，早已过了午夜. 我们都筋疲力尽，但也感到如释重负，并为我们完成的工作感到自豪. 我们拥抱了彼此，我告诉妻子我有多么欣赏她的奉献和努力. ",
		"她是个相当热情似火的女人，但我非常非常爱她. 时至今日我依然想念她，希望她平安离开了那个‘巢’. ”",
	)

	var/list/dementia = list(
		"抱歉，你叫什么名字来着？我的记性不如从前了. ",
		"我记得有段时间我们常常……哦，等等，我刚刚说到哪了？",
		"有时，我感觉我的记忆正在溜走. 但我心里仍装着所有这些想要分享的故事和经历. ",
		"我很难找到合适的词来表达自己. 请多包涵. ",
		"抱歉，我的头脑不像以前那么灵光了. 你能再说一遍刚才的话吗？",
		"哎呀，我把眼镜放哪儿了？好像哪儿都找不着了. ",
		"嗯，我刚才想说什么来着？就在嘴边...",
		"我觉得我以前在哪儿见过你，是吧？还是我记错了？",
		"有时我的脑子感觉像一团乱麻. 真希望能把它们都理顺. ",
	)

	var/list/catt = list(
		"从前，有一只小猫咪和它的一群伙伴们生活在一起...",
		"小猫咪仰望着它的伙伴们，而伙伴们也引领它走上正途. ",
		"然而有一天，小猫咪的伙伴们惹上了麻烦，而这只小小的、只会跟随它们脚步的小猫咪，什么也做不了. ",
		"于是伙伴们死了，只留下小猫咪孤零零一个. 心碎之下，小猫咪发誓，只要它活着，就再也不会在乎任何人了. ",
		"多年过去，小猫咪长大了，成为了一头强大的狮子. 强大而冷漠，它撕碎了一头又一头野兽，却很少享用猎物. ",
		"一天，这头强大的狮子发现了两只小猫. 狮子像对待其他许多弱者一样无视了它们，认为它们太过弱小脆弱，便让它们自生自灭. ",
		"然而，一点一滴地，那两只小猫跟上了狮子，狮子发现自己正放慢脚步让它们能够跟上. ",
		"随着时间的流逝，狮子发现自己开始关心起这两只小猫，而在这种关心中，它感到了恐惧. ",
		"小猫们向狮子保证永远不会离开它，长久以来第一次，狮子相信了别人. ",
		"然而，那是狮子犯下的最大错误. 不久之后，其中一只小猫病倒了. 小猫奄奄一息，无药可救. ",
		"于是狮子，内心仍是那只小猫咪，逃跑了. 它逃到天涯海角，试图躲避失去朋友的痛苦，躲避孤独的痛苦. ",
		"但是，站在世界尽头的，是另一只小猫；而这一次，狮子——内心仍是那只小猫咪——终于看清了对方的真面目：一只也在寻找朋友的狮子. ",
		"可最终，狮子内心仍是那只小猫咪，无法接受这份友谊；于是它再次逃跑了. ",
	)

	var/pink_speaktimer = null

	can_buckle = TRUE
	var/currently_talking = FALSE

/mob/living/simple_animal/hostile/abnormality/quiet_day/examine()
	. = ..()
	if(currently_talking)
		. += span_notice("你可以推[src]来阻止他说话...但那样就太粗鲁了.")

/mob/living/simple_animal/hostile/abnormality/quiet_day/post_buckle_mob(mob/living/M)
	M.layer = layer + 0.1
	M.pixel_x += 14
	M.setDir(SOUTH)

/mob/living/simple_animal/hostile/abnormality/quiet_day/post_unbuckle_mob(mob/living/M)
	M.layer = initial(M.layer)
	M.pixel_x -= 14

/mob/living/simple_animal/hostile/abnormality/quiet_day/attack_hand(mob/living/carbon/human/M)
	if(M.a_intent == "help" || !currently_talking)
		return ..()

	visible_message(span_notice("[M]要求[src]停止讲述这个故事."), \
					span_notice("[M]要求你停止讲述这个故事."), null, null, M)
	to_chat(M, span_notice("你要求[src]停止讲述这个故事."))
	playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
	currently_talking = FALSE

/mob/living/simple_animal/hostile/abnormality/quiet_day/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(pe == 0)
		return
	performed_work = work_type
	TalkStart(user)

/mob/living/simple_animal/hostile/abnormality/quiet_day/proc/TalkStart(mob/living/carbon/human/user)
	flick("quiet_fadein", src)
	icon_state = "quiet_ghost"
	currently_talking = TRUE
	switch(performed_work)
		if(ABNORMALITY_WORK_INSTINCT)
			for(var/line in war_story)
				say(line)
				SLEEP_CHECK_DEATH(5 SECONDS)
				if(!PlayerInView(user))
					ResetIcon()
					return

		if(ABNORMALITY_WORK_INSIGHT)
			for(var/line in parable)
				say(line)
				SLEEP_CHECK_DEATH(5 SECONDS)
				if(!PlayerInView(user))
					ResetIcon()
					return

		if(ABNORMALITY_WORK_ATTACHMENT)
			for(var/line in wife)
				say(line)
				SLEEP_CHECK_DEATH(5 SECONDS)
				if(!PlayerInView(user))
					ResetIcon()
					return

		if(ABNORMALITY_WORK_REPRESSION)
			var/list/dementia_clone = dementia.Copy()
			for(var/i in 1 to 7)
				say(length(dementia_clone) > 1 ? pick_n_take(dementia_clone) : pick(dementia_clone)) // if the list has 1 object, dont remove it
				SLEEP_CHECK_DEATH(5 SECONDS)
				if(!PlayerInView(user))
					ResetIcon()
					return

	TalkEnd(user)

/mob/living/simple_animal/hostile/abnormality/quiet_day/proc/TalkEnd(mob/living/carbon/human/user)
	ResetIcon()
	var/given_status_effect = STATUS_EFFECT_DEMENTIA_RAMBLINGS
	var/list/affected_list = list()
	switch(performed_work)
		if(ABNORMALITY_WORK_INSTINCT)
			given_status_effect = STATUS_EFFECT_WAR_STORY

		if(ABNORMALITY_WORK_INSIGHT)
			given_status_effect = STATUS_EFFECT_PARABLE

		if(ABNORMALITY_WORK_ATTACHMENT)
			given_status_effect = STATUS_EFFECT_WIFE_STORY

	if(user) // In theory the user can be added twice to the list, thankfully that doesn't matter.
		affected_list += user
	for(var/mob/living/sitter in buckled_mobs)
		affected_list += sitter
	for(var/mob/living/carbon/human/person in affected_list) // Buff the worker and anyone sitting in the bench
		person.apply_status_effect(given_status_effect)

/mob/living/simple_animal/hostile/abnormality/quiet_day/proc/ResetIcon()
	flick("quiet_fadeout", src)
	icon_state = "quiet_day"
	currently_talking = FALSE

/mob/living/simple_animal/hostile/abnormality/quiet_day/proc/PlayerInView(mob/living/carbon/human/user)
	if(currently_talking && (user in view(5, src)))
		return TRUE

	say("啊，我想我们可以下次再聊.")
	return FALSE

/mob/living/simple_animal/hostile/abnormality/quiet_day/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_PINK || breach_type == BREACH_MINING)
		AbnoRadio()
		Ramble()
		can_breach = TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/quiet_day/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/quiet_day/proc/Ramble(pink_story = TRUE)
	var/story_time = 1
	if(pink_story)
		for(var/line in catt)
			addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, say), ";"+line), (2 SECONDS)*story_time)
			story_time++
		pink_speaktimer = addtimer(CALLBACK(src, PROC_REF(Ramble), FALSE), (3 SECONDS)*(story_time + 1))
		return
	var/list/gibberish = list()
	gibberish += dementia
	gibberish += war_story
	gibberish += parable
	gibberish += wife
	gibberish = shuffle(gibberish)
	while(gibberish.len > 0 && story_time < 10)
		var/line = pick(gibberish)
		gibberish -= line
		story_time++
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, say), ";"+line), (4 SECONDS)*story_time)
	pink_speaktimer = addtimer(CALLBACK(src, PROC_REF(Ramble), FALSE), (4 SECONDS)*story_time*2)

/mob/living/simple_animal/hostile/abnormality/quiet_day/say(message, bubble_type, list/spans, sanitize, datum/language/language, ignore_spam, forced)
	if(stat == DEAD)
		return
	. = ..()

/atom/movable/screen/alert/status_effect/quiet
	name = "寂寥一日"
	desc = "你听了老人的故事."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "quiet"

//A Quiet day
//A simple 5 minute stat buff
/datum/status_effect/quiet
	id = "quiet_day"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 5 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/quiet
	var/attribute_buff = FORTITUDE_ATTRIBUTE

/datum/status_effect/quiet/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_buff(attribute_buff, 15)

/datum/status_effect/quiet/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_buff(attribute_buff, -15)


//Here so that the defines work
/datum/status_effect/quiet/warstory

//Parable
/datum/status_effect/quiet/parable
	attribute_buff = PRUDENCE_ATTRIBUTE

//Wife Story
/datum/status_effect/quiet/wife
	attribute_buff = TEMPERANCE_ATTRIBUTE

//Dementia
/datum/status_effect/quiet/dementia
	attribute_buff = JUSTICE_ATTRIBUTE


#undef STATUS_EFFECT_WAR_STORY
#undef STATUS_EFFECT_PARABLE
#undef STATUS_EFFECT_WIFE_STORY
#undef STATUS_EFFECT_DEMENTIA_RAMBLINGS

/datum/reagent/abnormality/quiet_day
	name = "液化的怀念"
	description = "粘稠，一种深色粘稠物，你几乎确信你看到了更多的东西."
	color = "#110320"
	sanity_restore = -2
	stat_changes = list(2, 2, 2, 2) // Sort of reverse bottle. Stat gain for ongoing sanity loss. Not a huge stat gain since it's split into four, but something.

//Audiovisual stuff
/mob/living/simple_animal/hostile/abnormality/quiet_day/Initialize()
	. = ..()
	soundloop = new(list(src), TRUE)

/mob/living/simple_animal/hostile/abnormality/quiet_day/Destroy()
	QDEL_NULL(soundloop)
	return ..()
