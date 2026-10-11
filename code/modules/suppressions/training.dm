// Right now the only core suppression with a proper reward, which is higher spawning stats.
/datum/suppression/training
	name = TRAINING_CORE_SUPPRESSION
	desc = "在抑制期间，所有员工的所有属性都会受到减益影响，初始为-10，并在每次考验后效果增强."
	reward_text = "在抑制中幸存下来的员工将获得所有属性+20提升和+5增益.\n\
			镇压结束后加入的新员工将有更高的属性."
	run_text = "培训部的核心抑制已经开始。所有人员都将出现工作疲劳的症状."
	/// Mob ref = Current attribute debuff
	var/list/affected_mobs = list()
	// Starting attribute debuff
	var/attribute_debuff_count_starting = -5
	// How much your attributes are debuffed after each ordeal
	var/attribute_debuff_count = -5
	// Used for new arrivals
	var/current_debuff_amount

/datum/suppression/training/Run(run_white = FALSE, silent = FALSE)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED, PROC_REF(OnJoin))
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, PROC_REF(OnMeltdown))
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.ckey)
			continue
		H.adjust_all_attribute_buffs(attribute_debuff_count_starting)
		to_chat(H, "<span class='danger'>你感到更弱了...</span>")
		affected_mobs[H] = attribute_debuff_count
		RegisterSignal(H, COMSIG_PARENT_QDELETING, PROC_REF(RemoveFromAffectedMobs))
	current_debuff_amount = attribute_debuff_count_starting

/datum/suppression/training/End(silent = FALSE)
	UnregisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED)
	for(var/mob/living/carbon/human/H in affected_mobs)
		H.adjust_all_attribute_buffs(-affected_mobs[H] + 5)
		H.adjust_all_attribute_levels(20) // A tiny reward
		to_chat(H, "<span class='notice'>你感到比以往任何时候都更好!</span:notice>")
		UnregisterSignal(H, COMSIG_PARENT_QDELETING)
	affected_mobs = null
	for(var/datum/job/agent/J in SSjob.occupations)
		J.normal_attribute_level += 5 // This allows agents to spawn with 100 in all stats
	return ..()

// When a new employee spawns in
/datum/suppression/training/proc/OnJoin(datum/source, mob/living/L, rank)
	if(!ishuman(L))
		return FALSE
	var/mob/living/carbon/human/H = L
	H.adjust_all_attribute_buffs(current_debuff_amount) // Suffer
	to_chat(H, "<span class='danger'>你感到更弱了...</span:danger>")
	affected_mobs[H] = current_debuff_amount
	RegisterSignal(H, COMSIG_PARENT_QDELETING, PROC_REF(RemoveFromAffectedMobs))
	return TRUE

// Whenever an affected mob gets deleted
/datum/suppression/training/proc/RemoveFromAffectedMobs(mob/M)
	SIGNAL_HANDLER
	affected_mobs -= M

// Update debuff amount with each ordeal
/datum/suppression/training/proc/OnMeltdown(datum/source, ordeal = FALSE)
	SIGNAL_HANDLER
	if(!ordeal)
		return
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.ckey)
			continue
		H.adjust_all_attribute_buffs(attribute_debuff_count)
		affected_mobs[H] += attribute_debuff_count
		to_chat(H, "<span class='danger'>你感到更弱了...</span:danger>")
	current_debuff_amount += attribute_debuff_count
