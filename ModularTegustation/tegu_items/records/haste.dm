// Golden Watch
//
// It's the golden time ability from limbus company. Not creative, I know, but cool!
/obj/item/records/haste
	name = "记录部金怀表"
	desc = "一块金色怀表，记录部长可以使用它，来为自己和员工们借一些额外的时间."
	icon_state = "watch_gold"
	watch_cooldown_time = 2 MINUTES
	var/debuff_timer = 10 SECONDS
	var/upgraded = FALSE

/obj/item/records/haste/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_RECORDS_1))
		. += span_notice("这块表得到了升级, 根据A公司标准时间尺度，其冷却时间减少了20秒.")

/obj/item/records/haste/WatchAction(mob/user)
	if(GetFacilityUpgradeValue(UPGRADE_RECORDS_1) && !upgraded)
		watch_cooldown_time /= 1.5
		upgraded = TRUE
	for(var/mob/living/carbon/human/H in range(4, get_turf(src)))
		H.apply_status_effect(/datum/status_effect/borrowed_time)
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living, apply_status_effect), /datum/status_effect/time_debt), debuff_timer)
	..()

/datum/status_effect/borrowed_time
	id = "borrowed_time"
	status_type = STATUS_EFFECT_REFRESH
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/borrowed_time

/atom/movable/screen/alert/status_effect/borrowed_time
	name = "借来的时间"
	desc = "短时间内获得25%的攻击速度和50%的移动速度."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "haste"

/datum/status_effect/borrowed_time/on_apply()
	owner.next_move_modifier *= 0.75 // this should affect attack speed. It could also be horrible and brick the game. We'll find out today!
	owner.add_movespeed_modifier(/datum/movespeed_modifier/borrowed_time)
	owner.playsound_local(owner, 'sound/items/lc13/recordshaste.ogg', 50, FALSE)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(MoveVFX))

	return TRUE

/datum/status_effect/borrowed_time/on_remove()
	owner.next_move_modifier /= 0.75
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/borrowed_time)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	..()

/datum/status_effect/borrowed_time/proc/MoveVFX() // Makes a red,blue,or green afterimage randomly.
	set waitfor = FALSE
	var/obj/viscon_filtereffect/distortedform_trail/trail = new(owner.loc,themob = owner, waittime = 5) // reuse DF code here
	trail.vis_contents += owner
	trail.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=2, color=rgb(0, 250, 229))
	trail.filters += filter(type = "blur", size = 3)
	trail.color = pick(COLOR_RED,COLOR_BLUE,COLOR_YELLOW,COLOR_VERY_SOFT_YELLOW,COLOR_OLIVE,COLOR_LIME,COLOR_DARK_LIME) // mostly yellows/greens
	animate(trail, alpha=120)
	animate(alpha = 0, time = 10)

/datum/movespeed_modifier/borrowed_time
	multiplicative_slowdown = -0.5

/datum/status_effect/time_debt
	id = "time_debt"
	status_type = STATUS_EFFECT_REFRESH
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/time_debt

/atom/movable/screen/alert/status_effect/time_debt
	name = "时间倒流逆作用"
	desc = "短时间内降低25%的攻击速度和25%的移动速度."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "slowdown"

/datum/status_effect/time_debt/on_apply()
	owner.next_move_modifier *= 1.25 // this should affect attack speed. It could also be horrible and brick the game. We'll find out today!
	owner.add_movespeed_modifier(/datum/movespeed_modifier/time_debt)
	owner.playsound_local(owner, 'sound/items/lc13/recordsslow.ogg', 50, FALSE)
	return TRUE

/datum/status_effect/time_debt/on_remove()
	owner.next_move_modifier /= 1.25
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/time_debt)
	..()

/datum/movespeed_modifier/time_debt
	multiplicative_slowdown = 1.25
