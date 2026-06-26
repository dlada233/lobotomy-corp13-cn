//Meltdown Exstender Watch
// For more documentation and information see code/game/machinery/computer/abnormality_work.dm
/obj/item/records/meltdown_extend
	name = "记录部木制怀表"
	desc = "一种供记录部长使用的木头怀表，用于为附近正在熔毁的异想体工作终端提供额外的时间."
	icon_state = "watch_wood"
	watch_cooldown_time = 5 MINUTES
	var/meltdowntimer_increase = 30

/obj/item/records/meltdown_extend/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_RECORDS_1))
		. += span_notice("这块手表已经升级了，能延长更多的熔毁时限.")

/obj/item/records/meltdown_extend/WatchAction(mob/user)
	var/checks = 0
	watch_cooldown_time = initial(watch_cooldown_time)
	for(var/obj/machinery/computer/abnormality/CA in oview(1))
		if(CA.datum_reference)
			/*
			Checking the following :
			1: If the console can meltdown
			2: If console *is* melting down currently
			3: If the meltdown time is greater then 0
			*/
			if(CA.can_meltdown && CA.meltdown && CA.meltdown_time > 0)
				//The watch itself has the time increase, we grab it and add that (in seconds)
				var/fake_meltdowntimer_increase = meltdowntimer_increase
				if (GetFacilityUpgradeValue(UPGRADE_RECORDS_1))
					fake_meltdowntimer_increase *= 2
				CA.meltdown_time += fake_meltdowntimer_increase
				//Give feedback and tell the user how much time left
				to_chat(user, span_warning("你增加了熔毁时限: [CA.meltdown_time] 到 [CA.datum_reference.name]的工作终端."))
				//This was a successful use of the watch, add it to the console counter
				checks++
			else
				to_chat(user, span_warning("这个异想体没有在熔毁."))

	if(checks > 0)
		watch_cooldown_time = watch_cooldown_time * checks // we'll reset the time at the beginning of thus proc
		..()
	else
		to_chat(user, span_warning("附近没有有效的工作终端，怀表无法发挥效果."))
