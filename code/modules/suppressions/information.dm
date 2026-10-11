// Most of its effects are applied elsewhere
/datum/suppression/information
	name = INFORMATION_CORE_SUPPRESSION
	desc = "异想体工作终端上的任务将随机分布.\n\
			公告系统和服装传感器将受到负面干扰."
	reward_text = "异想体工作获得的对应PE将提升25%."
	run_text = "情报部核心核心抑制已经开始，抑制期间情报和传感器将会收到干扰."
	/// Used in Gibberish() proc as third argument in relevant places.
	var/gibberish_value = 10
	/// By how much the value is increased on each ordeal
	var/gibberish_value_increase = 30

/datum/suppression/information/Run(run_white = FALSE, silent = FALSE)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, PROC_REF(OnMeltdown))

/datum/suppression/information/End(silent = FALSE)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START)
	SSlobotomy_corp.box_work_multiplier *= 1.25
	return ..()

// Increase gibberish value every time an ordeal occurs
/datum/suppression/information/proc/OnMeltdown(datum/source, ordeal = FALSE)
	SIGNAL_HANDLER
	if(ordeal)
		gibberish_value = min(80, gibberish_value + gibberish_value_increase)
