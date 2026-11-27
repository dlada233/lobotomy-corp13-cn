#define ACTIVE_NORMAL 1
#define ACTIVE_DANGEROUS 2

//Coded by InsightfulParasite
/obj/structure/toolabnormality/theresia
	name = "发条音乐盒"
	desc = "一只装饰华丽的老音乐盒，盒顶立着一位芭蕾舞者。盒侧刻着一行字：“还记得这段旋律吗？从前学生们犯困的时候，教授就会弹起这首曲子。生日快乐。”"
	icon_state = "theresia"
	anchored = FALSE
	drag_slowdown = 1.5
	var/icon_active = "theresia_active"
	var/activated = FALSE
	/// While cooldown is above world.time - cannot be toggled
	var/activation_cooldown
	var/activation_cooldown_time = 45 SECONDS
	var/max_winds = 6
	var/current_winds = 1
	var/pulse_heal = 10
	var/pulse_damage = 20

	ego_list = list(
		/datum/ego_datum/weapon/philia,
		/datum/ego_datum/armor/philia,
	)

/obj/structure/toolabnormality/theresia/attack_hand(mob/user) //defines activator as user.
	if(activation_cooldown > world.time)
		to_chat(user, span_warning("现在还不能[activated ? "关掉" : "启动"][src]！"))
		return

	if(activated)
		Deactivate(user)
	else
		Activate(user)
	add_fingerprint(user)

/obj/structure/toolabnormality/theresia/process()
	if(!activated)
		return

	// Dangerous effect
	if(current_winds >= max_winds)
		if(activated == ACTIVE_DANGEROUS)
			Deactivate()
			return
		activation_cooldown = world.time + 90 SECONDS // CAN'T STOP THE MUSIC!!
		activated = ACTIVE_DANGEROUS
		current_winds = 0

	current_winds += 1

	if(activated == ACTIVE_DANGEROUS)
		playsound(get_turf(src), 'sound/machines/clockcult/ark_scream.ogg', 50, 0, 24)
		new /obj/effect/temp_visual/fragment_song(get_turf(src))
		for(var/mob/living/carbon/human/H in livinginrange(32, get_turf(src)))
			H.deal_damage(pulse_damage, WHITE_DAMAGE, source = src, attack_type = (ATTACK_TYPE_SPECIAL | ATTACK_TYPE_ENVIRONMENT))
		return

	// Healing effect
	for(var/mob/living/carbon/human/L in view(8, src))
		if(L.stat == DEAD)
			continue
		L.adjustSanityLoss(-pulse_damage)
		if(prob(10))
			to_chat(L, span_notice("尽管眼前困难重重，你心里却踏实了些：一切都会好起来的。"))

/obj/structure/toolabnormality/theresia/proc/Activate(mob/user)
	activation_cooldown = world.time + 2 SECONDS // Just there to prevent spam
	icon_state = icon_active
	to_chat(user, span_notice("你开始给[src]上发条。"))
	visible_message(span_hear("[src]传来拧发条的声音。"))
	playsound(get_turf(src), 'sound/effects/ordeals/pink_start.ogg', 50, 0, 4)
	current_winds = 0
	activated = ACTIVE_NORMAL
	START_PROCESSING(SSobj, src)

/obj/structure/toolabnormality/theresia/proc/Deactivate(mob/user)
	activation_cooldown = world.time + activation_cooldown_time
	icon_state = initial(icon_state)
	to_chat(user, span_notice("你关掉了[src]。"))
	visible_message(span_hear("[activated == ACTIVE_NORMAL ? "令人安心" : "令人不安"]的乐声停了。"))
	playsound(get_turf(src), 'sound/effects/clock_tick.ogg', 50, 0, 4)
	activated = FALSE
	STOP_PROCESSING(SSobj,src)

#undef ACTIVE_NORMAL
#undef ACTIVE_DANGEROUS
