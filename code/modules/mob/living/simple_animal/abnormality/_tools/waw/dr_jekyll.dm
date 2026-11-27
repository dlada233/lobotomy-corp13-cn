#define STATUS_EFFECT_HYDE /datum/status_effect/display/hyde
#define STATUS_EFFECT_DR_JEKYLL /datum/status_effect/display/dr_jekyll
/obj/structure/toolabnormality/dr_jekyll
	name = "杰基尔博士药剂"
	desc = "一瓶看起来人畜无害的药剂。"
	icon_state = "dr_jekyll"

	ego_list = list(
		/datum/ego_datum/weapon/hyde,
		/datum/ego_datum/armor/hyde,
	)

/obj/structure/toolabnormality/dr_jekyll/attack_hand(mob/living/carbon/human/user)
	..()
	if(get_user_level(user) <= 2)
		to_chat(user, span_notice("你还看不懂药剂的配制说明。"))
		return
	if(!do_after(user, 10, user))
		return

	var/datum/status_effect/display/dr_jekyll/J = user.has_status_effect(STATUS_EFFECT_DR_JEKYLL)
	if(!J)
		to_chat(user, span_userdanger("你按说明配出了一种液体。"))
		user.apply_status_effect(STATUS_EFFECT_DR_JEKYLL)
		playsound(user.loc, 'sound/effects/bubbles.ogg', rand(10,50), TRUE)
		return
	var/datum/status_effect/display/hyde/H = user.has_status_effect(STATUS_EFFECT_HYDE)
	if(!H)
		to_chat(user, span_notice("你归还了药剂。"))
		user.remove_status_effect(STATUS_EFFECT_DR_JEKYLL)
		return //You don't need any more.
	else //They messed up
		to_chat(user, span_userdanger("哈！想甩掉我可没那么容易！"))
		playsound(get_turf(user), 'sound/abnormalities/someonesportrait/panic.ogg', 40, FALSE, -5)
		user.deal_damage(999, WHITE_DAMAGE, attack_type = (ATTACK_TYPE_SPECIAL | ATTACK_TYPE_ENVIRONMENT))//DIE!
		return

// Status Effects
/datum/status_effect/display/dr_jekyll
	id = "dr_jekyll"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	tick_interval = 30 //Check sanity every 3 seconds
	alert_type = null
	display_name = "jekyll"
	var/datum/action/cooldown/dr_jekyll/ability = new /datum/action/cooldown/dr_jekyll()

/datum/status_effect/display/dr_jekyll/on_apply()
	. = ..()
	ability.Grant(owner)

/datum/status_effect/display/dr_jekyll/on_remove()
	. = ..()
	ability.Remove(owner)

/datum/status_effect/display/dr_jekyll/tick()
	SanityCheck()

/datum/status_effect/display/dr_jekyll/proc/SanityCheck()
	var/mob/living/carbon/human/status_holder = owner
	if(status_holder.sanity_lost)
		QDEL_NULL(status_holder.ai_controller)
		status_holder.ai_controller = /datum/ai_controller/insane/murder/hyde
		status_holder.InitializeAIController()
		status_holder.apply_status_effect(/datum/status_effect/panicked_type/hyde)

/datum/status_effect/display/hyde
	id = "hyde"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/hyde
	examine_text = span_warning("此人看起来像是变了个人。")
	var/message_cooldown
	var/message_cooldown_time = 30 SECONDS
	var/current_boost = 0
	var/list/message_list = list(
		"准备好了吗？",
		"人的本性一分为二。",
		"血在沸腾，灵魂在腐朽。",
		"如今我是你的一部分，正如你是我的一部分。",
		"何必在意善恶。",
		"我会让你见识一些可怕又美丽的东西。",
		"你大可以凌驾于那群苟延残喘的伪君子之上。",
		"夺回他们从你手里抢走的一切。从他们的尸体上踏过去。",
	)

/atom/movable/screen/alert/status_effect/hyde
	name = "海德先生"
	desc = "一股神秘的力量正支配着你的行动。"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "hyde"

/datum/status_effect/display/hyde/on_apply()
	to_chat(owner, span_notice("你感觉再也没有什么能约束自己了。"))
	var/mob/living/carbon/human/status_holder = owner
	ADD_TRAIT(status_holder, TRAIT_COMBATFEAR_IMMUNE, "Jekyll")
	return ..()

/datum/status_effect/display/hyde/on_remove()
	var/mob/living/carbon/human/status_holder = owner
	REMOVE_TRAIT(status_holder, TRAIT_COMBATFEAR_IMMUNE, "Jekyll")
	ReturnToNormal()
	return ..()

/datum/status_effect/display/hyde/tick()
	var/mob/living/carbon/human/status_holder = owner
	var/sanitytolose = clamp(status_holder.maxSanity * 0.025, 0, status_holder.sanityhealth - 1)
	status_holder.adjustSanityLoss(sanitytolose) // hopefully keeps them at at least 1 sanity
	status_holder.OtherDamageEffect(sanitytolose, "sinking")
	var/new_boost = (status_holder.maxSanity - status_holder.sanityhealth) * 0.5
	var/boost_difference = new_boost - current_boost
	status_holder.adjust_attribute_buff(JUSTICE_ATTRIBUTE, boost_difference)
	current_boost = new_boost
	SanityCheck()
	if(message_cooldown > world.time)
		return
	to_chat(owner, span_unconscious("<font color='red'>[pick(message_list)]</font>"))
	message_cooldown = (message_cooldown_time + rand(0, 1200)) + world.time

/datum/status_effect/display/hyde/proc/SanityCheck()
	var/mob/living/carbon/human/status_holder = owner
	if(status_holder.sanityhealth <= 1 || status_holder.sanity_lost)
		qdel(src)

/datum/status_effect/display/hyde/proc/ReturnToNormal()
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_nicegreen("那股异样的感觉消退了。"))
	status_holder.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -current_boost)

//Action
/datum/action/cooldown/dr_jekyll
	icon_icon = 'ModularTegustation/Teguicons/toolabnormalities.dmi'
	button_icon_state = "dr_jekyll"
	name = "切换人格"
	cooldown_time = 300

/datum/action/cooldown/dr_jekyll/Trigger()
	if(!..())
		return FALSE
	if (owner.stat == DEAD)
		return FALSE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/status_effect/display/hyde/effect = H.has_status_effect(STATUS_EFFECT_HYDE)
	if(!effect)
		to_chat(H, span_userdanger("你喝下了一些药剂。"))
		H.playsound_local(get_turf(H), 'sound/abnormalities/someonesportrait/panic.ogg', 40, FALSE)
		H.adjustSanityLoss(H.maxSanity * 0.25) // lose a quarter your sanity insantly
		H.OtherDamageEffect(H.maxSanity * 0.25, "sinking")
		H.apply_status_effect(STATUS_EFFECT_HYDE)
		StartCooldown()
		return
	to_chat(H, span_notice("能力已经生效，等你的理智值降到 1 点，效果才会消退。"))

//AI
/datum/ai_controller/insane/murder/hyde
	lines_type = /datum/ai_behavior/say_line/insanity_hyde

/datum/ai_behavior/say_line/insanity_hyde
	lines = list(
		"你这只胆敢放肆的可怜蝼蚁！",
		"什么事都得我亲自动手吗？",
		"你终于屈服了！这具身体归我了！",
		"来，看看这具身体有多少能耐。",
		"我这就让你闭上那张哀嚎的嘴！",
		"听啊！魔鬼来了！",
		"你不值得我浪费时间！"
	)

// The panic loses regained sanity over time, and is tougher to deal with by other players.
/datum/status_effect/panicked_type/hyde
	icon = "hyde"

/datum/status_effect/panicked_type/hyde/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	ADD_TRAIT(status_holder, TRAIT_STUNIMMUNE, type)
	ADD_TRAIT(status_holder, TRAIT_PUSHIMMUNE, type)

/datum/status_effect/panicked_type/hyde/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	REMOVE_TRAIT(status_holder, TRAIT_STUNIMMUNE, type)
	REMOVE_TRAIT(status_holder, TRAIT_PUSHIMMUNE, type)

/datum/status_effect/panicked_type/hyde/tick()
	var/mob/living/carbon/human/status_holder = owner
	var/sanitytolose = (status_holder.maxSanity * 0.05)
	status_holder.adjustSanityLoss(sanitytolose) // hopefully keeps them at at least 1 sanity
	status_holder.OtherDamageEffect(sanitytolose, "sinking")

#undef STATUS_EFFECT_DR_JEKYLL
#undef STATUS_EFFECT_HYDE
