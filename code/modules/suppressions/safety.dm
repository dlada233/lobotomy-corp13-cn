/datum/suppression/safety
	name = SAFETY_CORE_SUPPRESSION
	desc = "再生器将停止正常运行，取而代之的是每次熔毁后所有人员都会被治疗.\n\
			休眠舱和EMAIS将无法使用.\n\
			医疗笔每次激活时都有概率发生故障并需要延迟."
	reward_text = "所有再生器将获得永久+12的治疗效果提升."
	run_text = "安保部的核心抑制已经开始。再生器和休眠舱将停止正常运行。取而代之的是，每次熔毁后所有人员都会自动被治疗."

/datum/suppression/safety/Run(run_white = FALSE, silent = FALSE)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, PROC_REF(OnMeltdown))
	for(var/obj/machinery/regenerator/R in GLOB.lobotomy_devices)
		R.reset_timer = INFINITY
		R.disabled = TRUE
		R.modified = TRUE
	for(var/obj/machinery/sleeper/S in GLOB.sleepers)
		S.set_machine_stat(S.machine_stat | BROKEN)

/datum/suppression/safety/End(silent = FALSE)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START)
	for(var/obj/machinery/regenerator/R in GLOB.lobotomy_devices) // All regenerators gain permanent buff
		R.reset_timer = 0
		R.regeneration_amount += 12
	for(var/obj/machinery/sleeper/S in GLOB.sleepers)
		S.set_machine_stat(S.machine_stat & (~BROKEN))
	return ..()

// On lobotomy_corp meltdown event
/datum/suppression/safety/proc/OnMeltdown(datum/source, ordeal = FALSE)
	// Everyone gets healed
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.ckey)
			continue
		H.adjustBruteLoss(-250)
		H.adjustSanityLoss(-250)
		to_chat(H, "<span class='notice'>你突然感到恢复健康!</span>")
	return
