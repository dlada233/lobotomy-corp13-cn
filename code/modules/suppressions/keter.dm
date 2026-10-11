// A day 46 wannabe - Only triggers white ordeals
/datum/suppression/keter_day46
	name = DAY46_CORE_SUPPRESSION
	desc = "惨白考验将会发生, 每场考验会间隔一次熔毁. <br>\
			在通过黎明、正午和黄昏后, 员工将面对爪牙."
	goal_text = "击败惨白的午夜 —— 爪牙."
	run_text = "惨白考验将会发生, 每场考验会间隔一次熔毁."
	annonce_sound = 'sound/effects/combat_suppression_start.ogg'
	end_sound = 'sound/effects/combat_suppression_end.ogg'
	after_midnight = TRUE

/datum/suppression/keter_day46/Run(run_white = TRUE, silent = FALSE)
	var/blurb_text = pick(
		"经历了这么多曲折, 我们终于见面了.",
		"既然在经过了那么长的时间之后, 你终于到达了这里.",
		"来吧, 放松你的身心吧, 你一定已经精疲力竭了.",
		)
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "center", "CENTER-6,BOTTOM+2")
	return ..()

/* Combined cores go here */
/datum/suppression/combination
	reward_text = "我们将离我们的目标更近一步..."
	goal_text = "击败惨白的午夜 - 爪牙."
	annonce_sound = 'sound/effects/combat_suppression_start.ogg'
	end_sound = 'sound/effects/combat_suppression_end.ogg'
	after_midnight = TRUE
	available = FALSE
	/// List of all cores "inside" of it; On End - ends them, too
	var/list/running_cores = list()
	/// List of core names required for this suppression to be available for selection
	var/list/required_cores = list()

/datum/suppression/combination/New()
	. = ..()
	if(!LAZYLEN(required_cores))
		return
	if(available)
		return

	var/list/all_agents = AllLivingAgents()
	/// Amount of people online that have met the requirements
	var/clear_count = 0
	/// How many people must meet requirements to enable it
	var/clear_requirement = length(all_agents) * 0.5
	for(var/mob/M in all_agents)
		if(!(M.ckey in SSpersistence.cleared_core_suppressions))
			continue
		var/list/diffs = difflist(required_cores, SSpersistence.cleared_core_suppressions[M.ckey])
		if(LAZYLEN(diffs))
			continue
		clear_count += 1

	if(clear_count >= clear_requirement)
		available = TRUE

/datum/suppression/combination/End(silent = FALSE)
	for(var/datum/suppression/S in running_cores)
		S.End(TRUE)
	return ..()

// Day 47 - Control, Information, Safety and Training all combined, while also running white ordeals. HAVE FUN.
/datum/suppression/combination/keter_day47
	name = DAY47_CORE_SUPPRESSION
	desc = "情报部、安保部和培训部的核心抑制效果将在本次考验期间生效. <br>\
			要完成挑战——你必须击败惨白的午夜 —— 爪牙."
	run_text = "情报部、安保部和培训部的核心抑制效果现已生效. 惨白的考验已引入设施中."
	required_cores = list(
		CONTROL_CORE_SUPPRESSION,
		INFORMATION_CORE_SUPPRESSION,
		SAFETY_CORE_SUPPRESSION,
		TRAINING_CORE_SUPPRESSION,
		DAY46_CORE_SUPPRESSION,
		)

/datum/suppression/combination/keter_day47/Run(run_white = TRUE, silent = FALSE)
	. = ..()
	// Ominous blurbs
	var/list/blurb_list = list(
		"看来, 你已经决定要继续前进了.",
		"可你的身心早已被那无情的现实摧残风化了, 你真的有信心继续下去吗?",
		"如果我们连昂首挺胸都做不到, 又怎能继续前进?",
		"也许对所有人最好的结果是回到最初的起点.",
		"如果这么做, 我们那不可饶恕的罪过或许稍微减轻一些.",
		)
	for(var/i = 1 to length(blurb_list))
		var/blurb_text = blurb_list[i]
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "center", "CENTER-6,BOTTOM+2"), i * 11 SECONDS)
	// Create our cores
	running_cores += new /datum/suppression/control
	// Less scuffed words in announcements
	var/datum/suppression/information/I = new
	I.gibberish_value_increase = 10
	running_cores += I
	running_cores += new /datum/suppression/safety
	// More stat reductions at the start, but gets reverted over time
	var/datum/suppression/training/T = new
	T.attribute_debuff_count_starting = -30
	T.attribute_debuff_count = 5
	running_cores += T
	// And then start them all
	for(var/datum/suppression/S in running_cores)
		S.Run(FALSE, TRUE)

	// As running all previous ones would set them as main core, we need to reset it
	SSlobotomy_corp.core_suppression = src

/datum/suppression/combination/keter_day47/End(silent = FALSE)
	var/blurb_text = "只要你醒来, 闻一闻玫瑰的芬芳, 就能战胜这种绝望.你还有机会."
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "center", "CENTER-6,BOTTOM+2")
	return ..()

// Day 48 - Central Command, Welfare, Disciplinary
/datum/suppression/combination/keter_day48
	name = DAY48_CORE_SUPPRESSION
	desc = "中央本部、福利部与惩戒部的核心压制效果将在本次考验期间生效. <br>\
			要完成挑战——你必须击败惨白的午夜 —— 爪牙."
	run_text = "中央本部、福利部与惩戒部的核心压制效果将在本次考验期间生效. 惨白的考验已引入设施中."
	required_cores = list(
		CONTROL_CORE_SUPPRESSION,
		INFORMATION_CORE_SUPPRESSION,
		SAFETY_CORE_SUPPRESSION,
		TRAINING_CORE_SUPPRESSION,
		COMMAND_CORE_SUPPRESSION,
		WELFARE_CORE_SUPPRESSION,
		DISCIPLINARY_CORE_SUPPRESSION,
		DAY46_CORE_SUPPRESSION,
		DAY47_CORE_SUPPRESSION,
		)

/datum/suppression/combination/keter_day48/Run(run_white = TRUE, silent = FALSE)
	. = ..()
	// Ominous blurbs
	var/list/blurb_list = list(
		"你还记得我们仍然能感受到阳光的温暖的那些日子吗?",
		"现在的我们已经变得如此冷酷.",
		"面对无数的牺牲, 我们只是在假装心痛?",
		"我们从一开始就错了.你和我所剩下的, 只有赎罪了.",
		)
	for(var/i = 1 to length(blurb_list))
		var/blurb_text = blurb_list[i]
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "center", "CENTER-6,BOTTOM+2"), i * 11 SECONDS)
	// Create our cores
	// Less scuffed words in announcements
	var/datum/suppression/command/C = new
	C.meltdown_count_increase = 4
	C.meltdown_time_multiplier = 0.5
	C.meltdown_time_reduction = 0.1
	running_cores += C
	// More stat reductions
	var/datum/suppression/welfare/W = new
	running_cores += W
	// TODO: Red mist spawn
	// --------------------
	// And then start them all
	for(var/datum/suppression/S in running_cores)
		S.Run(FALSE, TRUE)

	// As running all previous ones would set them as main core, we need to reset it
	SSlobotomy_corp.core_suppression = src

/datum/suppression/combination/keter_day48/End(silent = FALSE)
	var/blurb_text = "你想就此走向明天和未来?！你想就此逃避你的悔恨和罪孽吗?既然如此...推开那扇门吧."
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "center", "CENTER-6,BOTTOM+2")
	return ..()

// Day 49 - Records and Extraction
/datum/suppression/combination/keter_day49
	name = DAY49_CORE_SUPPRESSION
	desc = "记录部核心抑制效果将在整个挑战期间持续存在. <br>\
			调律者将在正午考验后出现.<br>\
			要完成挑战——你必须击败惨白的午夜 —— 爪牙."
	run_text = "记录部核心抑制效果现已生效, 调律者将在正午考验后到来, 惨白考验已引入设施中."
	required_cores = list(
		CONTROL_CORE_SUPPRESSION,
		INFORMATION_CORE_SUPPRESSION,
		SAFETY_CORE_SUPPRESSION,
		TRAINING_CORE_SUPPRESSION,
		COMMAND_CORE_SUPPRESSION,
		WELFARE_CORE_SUPPRESSION,
		DISCIPLINARY_CORE_SUPPRESSION,
		RECORDS_CORE_SUPPRESSION,
		EXTRACTION_CORE_SUPPRESSION,
		DAY46_CORE_SUPPRESSION,
		DAY47_CORE_SUPPRESSION,
		DAY48_CORE_SUPPRESSION,
		)

/datum/suppression/combination/keter_day49/Run(run_white = TRUE, silent = FALSE)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END, PROC_REF(OnOrdealEnd))
	// Ominous blurbs
	var/list/blurb_list = list(
		"吾已在此苦苦等候多时.",
		"这种等待实在是无聊至极.",
		"吾观望着早已预见的堕落, 心中的枯燥自是无以言表.",
		"也正因如此, 吾得以一览真相.",
		"异想体并非虚幻的存在, 它们即是从封闭的心中抽出的光芒.",
		"它们, 才是人类最真实的形态.",
		)
	for(var/i = 1 to length(blurb_list))
		var/blurb_text = blurb_list[i]
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "center", "CENTER-6,BOTTOM+2"), i * 11 SECONDS)
	// More fucked up chaos
	var/datum/suppression/records/R = new
	R.teleport_interval = 30 SECONDS
	R.teleport_min_distance = 1
	R.teleport_max_distance = 3
	R.teleport_min_mob_count = 0.5
	R.teleport_max_mob_count = 0.8
	running_cores += R
	R.Run(FALSE, TRUE)

	SSlobotomy_corp.core_suppression = src

/datum/suppression/combination/keter_day49/End(silent = FALSE)
	UnregisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END)
	var/blurb_text = "你胆敢拒绝吾的邀请, 面向另一个不可预知的未来!?"
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "center", "CENTER-6,BOTTOM+2")
	return ..()

/datum/suppression/combination/keter_day49/proc/OnOrdealEnd(datum/source, datum/ordeal/O)
	SIGNAL_HANDLER
	if(!istype(O, /datum/ordeal/fixers/white_noon))
		return
	// Spawn the arbiter
	addtimer(CALLBACK(src, PROC_REF(SpawnArbiter)), 10 SECONDS)

/datum/suppression/combination/keter_day49/proc/SpawnArbiter()
	// Make records less AIDS
	var/datum/suppression/records/R = GetCoreSuppression(/datum/suppression/records)
	R.teleport_interval = 20 SECONDS
	var/turf/T = pick(GLOB.department_centers)
	sound_to_playing_players_on_level('sound/magic/arbiter/repulse.ogg', 100, zlevel = T.z)
	var/blurb_text = pick(
		"你无法逃离首脑.",
		"如果你无法击败我, 你将被首脑以及爪牙无情地撕碎.",
		"即使从这座监牢中逃出, 你又能做什么呢?",
		)
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, blurb_text, 1 SECONDS, "black", "yellow", "center", "CENTER-6,BOTTOM+2")
	var/mob/living/simple_animal/hostile/megafauna/arbiter/A = new(T)
	// A bit nerfed, so you don't suffer like you are in hell, okay?
	A.maxHealth = round(A.maxHealth * 0.6)
	A.health = A.maxHealth
	// While nerfed in health, its attacks are more rapid
	A.spikes_cooldown_time = round(A.spikes_cooldown_time * 0.5)
	A.fairy_cooldown_time = round(A.fairy_cooldown_time * 0.5)
	A.key_cooldown_time = round(A.key_cooldown_time * 0.5)

// Day 50 - Tree of Light
/datum/suppression/combination/keter_day50
	name = DAY50_CORE_SUPPRESSION
	desc = "设施将经历异常情况, 并会出现未知子集的考验.<br>\
			为了完成挑战, 你必须击败惨败的日蚀."// Eclipse of white
	run_text = "这份工作的最后一天, 已经到来."
	required_cores = list(
		CONTROL_CORE_SUPPRESSION,
		INFORMATION_CORE_SUPPRESSION,
		SAFETY_CORE_SUPPRESSION,
		TRAINING_CORE_SUPPRESSION,
		COMMAND_CORE_SUPPRESSION,
		WELFARE_CORE_SUPPRESSION,
		DISCIPLINARY_CORE_SUPPRESSION,
		RECORDS_CORE_SUPPRESSION,
		EXTRACTION_CORE_SUPPRESSION,
		DAY46_CORE_SUPPRESSION,
		DAY47_CORE_SUPPRESSION,
		DAY48_CORE_SUPPRESSION,
		DAY49_CORE_SUPPRESSION,
		)

/datum/suppression/combination/keter_day50/Run(run_white = TRUE, silent = FALSE)
	. = ..()
	// Ominous blurbs
	var/list/blurb_list = list(
		"我们终于到达了这一天.",
		"看你毫不犹豫地走到了这一步, 想必你已经意识到了.",
		"我们都失去了自己的'心'.",
		"我们已经和别的“翼”一样, 犯下了相同的暴行.",
		"在这里, 员工们重复着成千上万的死亡, 无休无止.",
		"我早已死去的朋友们, 深陷在痛苦的循环之中.",
		"这份罪孽, 永远不可饶恕.",
		"尽管如此...我们也必须完成这一切.",
		"直面恐惧, 创造未来, 这是你最后一份工作.",
		)
	for(var/i = 1 to length(blurb_list))
		var/blurb_text = blurb_list[i]
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "center", "CENTER-6,BOTTOM+2"), i * 11 SECONDS)
