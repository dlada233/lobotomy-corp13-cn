/datum/suppression/command
	name = COMMAND_CORE_SUPPRESSION
	desc = "在抑制期间，某些异想体的熔毁免疫将被取消，熔毁发生的数量更多，熔毁的倒计时更短，如果未能处理熔毁会导致其他异想体也发生熔毁。"
	reward_text = "主管的子弹将在目标周围小范围生效. \
			在熔毁单元内的工作会提供更多属性成长."
	run_text = "中央本部的核心抑制已经开始. \n\
			熔毁免疫特性被取消，逆卡巴拉熔毁倒计时缩短. \n\
			未能处理熔毁将导致其他异想体也发生熔毁."

	/// Amount of additional abnormalities melting each qliphoth event
	var/meltdown_count_increase = 2
	/// Multiplier to the duration of abnormality meltdowns
	var/meltdown_time_multiplier = 0.8
	/// By how much meltdown timer is reduced each ordeal
	var/meltdown_time_reduction = 0.2

/datum/suppression/command/Run(run_white = FALSE, silent = FALSE)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, PROC_REF(OnQlipMeltdown))
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_FINISHED, PROC_REF(OnAbnoMeltdown))

/datum/suppression/command/End(silent = FALSE)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_FINISHED)
	SSlobotomy_corp.melt_work_multiplier += 1
	SSlobotomy_corp.manager_bullet_area = 1 // Bullets will activate in a 3x3 AOE
	return ..()

/datum/suppression/command/proc/OnQlipMeltdown(datum/source, ordeal = FALSE)
	SIGNAL_HANDLER
	if(ordeal)
		meltdown_count_increase += 1
		meltdown_time_multiplier = max(0.1, meltdown_time_multiplier - meltdown_time_reduction)

/datum/suppression/command/proc/OnAbnoMeltdown(datum/dcs, datum/abnormality/source, melt_removed = TRUE)
	SIGNAL_HANDLER
	if(!istype(source))
		return
	var/obj/machinery/computer/abnormality/console = source.console
	if(!istype(console))
		return
	if(melt_removed)
		return
	var/list/potential_consoles = list()
	for(var/obj/machinery/computer/abnormality/A in GLOB.lobotomy_devices)
		if(A == console)
			continue
		if(!A.can_meltdown)
			continue
		if(!A.datum_reference || !A.datum_reference.current)
			continue
		if(A.meltdown || A.datum_reference.working)
			continue
		if(!A.datum_reference.current.IsContained()) // Does what the old check did, but allows it to be redefined by abnormalities that do so.
			continue
		potential_consoles |= A

	if(!LAZYLEN(potential_consoles))
		return
	var/obj/machinery/computer/abnormality/A = pick(potential_consoles)
	console.Beam(A, icon_state = "volt_ray", time = 5 SECONDS)
	playsound(console, 'sound/weapons/zapbang.ogg', 50, TRUE)
	playsound(A, 'sound/weapons/zapbang.ogg', 50, TRUE)
	A.start_meltdown(MELTDOWN_NORMAL, round(40 * meltdown_time_multiplier), round(60 * meltdown_time_multiplier))
