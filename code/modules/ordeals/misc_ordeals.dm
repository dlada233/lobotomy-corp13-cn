// A Party Everlasting
/datum/ordeal/boss/pink_midnight
	name = "粉色的午夜"
	flavor_name = "永恒派对"
	announce_text = "让我们来个持续到永远的派对."
	end_announce_text = "因此，现在，我们相聚，奇妙而永恒."
	level = 4
	reward_percent = 0.25
	announce_sound = 'sound/effects/ordeals/pink_start.ogg'
	end_sound = 'sound/effects/ordeals/pink_end.ogg'
	color = COLOR_PINK
	bosstype = /mob/living/simple_animal/hostile/ordeal/pink_midnight

/datum/ordeal/boss/pink_midnight/Run()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(MobDeathWrapper))
	addtimer(CALLBACK(src, PROC_REF(OnMobDeath)), 2.5 MINUTES, TIMER_LOOP) // Some abnos qdel, if the last one does then this is the failsafe.

/datum/ordeal/boss/pink_midnight/End()
	. = ..()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)

/datum/ordeal/boss/pink_midnight/proc/MobDeathWrapper(datum/source, mob/living/deadMob)
	OnMobDeath(deadMob)
