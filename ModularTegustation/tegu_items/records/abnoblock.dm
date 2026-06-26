//RO meltdown watch
//Gives by default 5 additional minutes before the next abnormality spawns
/obj/item/records/abnodelay
	name = "记录部青铜怀表"
	desc = "青铜怀表，记录部长可以使用来使下一个异想体延迟抵达."
	icon_state = "watch_bronze"
	watch_cooldown_time = 30 MINUTES
	var/next_abno_spawn_offset = 5 MINUTES
	var/upgraded = FALSE

/obj/item/records/abnodelay/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_RECORDS_1))
		. += span_notice("这块怀表得到了升级，现在冷却时间减少了15分钟.")

/obj/item/records/abnodelay/WatchAction(mob/user)
	to_chat(user, span_notice("你检查了怀表，为延缓异想体到来而回拨了指针."))
	// We grab the SubSystem for abnormality spawning and go to the spawn timer, and add the offset time to it directly.
	SSabnormality_queue.next_abno_spawn += next_abno_spawn_offset
	if(GetFacilityUpgradeValue(UPGRADE_RECORDS_1) && !upgraded)
		watch_cooldown_time /= 2
		upgraded = TRUE
	..()
