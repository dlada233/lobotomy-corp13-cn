#define STATUS_EFFECT_ROLECALL /datum/status_effect/stacking/rolecall
/obj/structure/toolabnormality/attribute_giver/vivavoce
	name = "心声回响"
	desc = "一部相当老式的电话。"
	icon_state = "vivavoce"

	max_boost = 50
	given_attribute = TEMPERANCE_ATTRIBUTE
	given_status_effect = STATUS_EFFECT_ROLECALL
	feedback_message = "你拿起听筒，里面没有声音。你却觉得背后站着个人。"
	full_boost_message = "听筒里一片寂静。"

	ego_list = list(
		/datum/ego_datum/weapon/ringing,
		/datum/ego_datum/armor/ringing,
	)

/obj/structure/toolabnormality/attribute_giver/vivavoce/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return

	if(used_by[user] == 1) // First use
		if(prob(50))
			playsound(user, 'sound/abnormalities/vivavoce/doorknock.ogg', 100, FALSE, -5)
		return

	user.physiology.black_mod *= 1.10
	var/datum/status_effect/stacking/rolecall/R = user.has_status_effect(/datum/status_effect/stacking/rolecall)
	R.add_stacks(1)

// Status Effect
/datum/status_effect/stacking/rolecall
	id = "call"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	stack_decay = 0
	stacks = 1
	max_stacks = 10
	consumed_on_threshold = FALSE
	var/damage_mod

/datum/status_effect/stacking/rolecall/on_apply()
	RegisterSignal(owner, COMSIG_WORK_STARTED, PROC_REF(UserDebuff))
	RegisterSignal(owner, COMSIG_WORK_COMPLETED, PROC_REF(UserBuff))
	return ..()

/datum/status_effect/stacking/rolecall/on_remove()
	UnregisterSignal(owner, COMSIG_WORK_STARTED)
	UnregisterSignal(owner, COMSIG_WORK_COMPLETED)
	return ..()

/datum/status_effect/stacking/rolecall/proc/UserDebuff()
	SIGNAL_HANDLER
	damage_mod = 1.5 + (stacks / 20)
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	to_chat(H, span_userdanger("要是有人袭击我怎么办？我没法集中精神！"))
	if(prob(5))
		playsound(H, 'sound/abnormalities/vivavoce/doorknock.ogg', 100, FALSE, -5)
		to_chat(H, span_userdanger("刚才那是什么声音？"))
	H.physiology.red_mod *= damage_mod
	H.physiology.white_mod *= damage_mod
	H.physiology.black_mod *= damage_mod
	H.physiology.pale_mod *= damage_mod

/datum/status_effect/stacking/rolecall/proc/UserBuff()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	H.physiology.red_mod /= damage_mod
	H.physiology.white_mod /= damage_mod
	H.physiology.black_mod /= damage_mod
	H.physiology.pale_mod /= damage_mod


#undef STATUS_EFFECT_ROLECALL
