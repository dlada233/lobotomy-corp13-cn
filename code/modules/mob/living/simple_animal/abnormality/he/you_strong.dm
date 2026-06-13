/mob/living/simple_animal/hostile/abnormality/you_strong
	name = "你必须变得更强大"
	desc = "色彩斑斓的工厂闻起来有一股明显的铁味...这东西是塑料做的吗!?"
	icon = 'ModularTegustation/Teguicons/96x64.dmi'
	icon_state = "you_strong_pause"
	icon_living = "you_strong_pause"
	portrait = "grown_strong"
	maxHealth = 400
	health = 400
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0)
	threat_level = HE_LEVEL
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 45,
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = 45,
		ABNORMALITY_WORK_REPRESSION = 0,
		"YES" = 0,
		"NO" = 0,
	)
	work_damage_upper = 6
	work_damage_lower = 3
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/envy
	ego_list = list(
		/datum/ego_datum/weapon/get_strong,
		/datum/ego_datum/armor/get_strong,
	)
	gift_type = /datum/ego_gifts/get_strong
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	max_boxes = 16
	speak_emote = list("beeps", "crackles", "buzzes")
	speech_span = SPAN_ROBOT

	pixel_x = -32
	pixel_y = -8
	layer = OPEN_DOOR_LAYER

	observation_prompt = "我曾是都市中最弱小的人，连鼠辈都瞧不起我。<br>\
		'我生时死后都将一事无成'，我这样想着，直到有天收到一份奇怪的信件——邮箱里的宣传册。<br>\
		\"你变强了吗？为你的都市变强了吗？变强吧！为你的都市变强吧！\"可疑的传单上有个地址，我循迹而去，<br>\
		我憎恶自己的软弱，生死早已置之度外，只要有机会不再弱小，我什么都愿意尝试。<br>地址处有台最奇特的机器，上面写着进入的指示。"
	observation_choices = list(
		"进入机器" = list(TRUE, "我依言进入；现在我变强了，为我的都市而强大。<br>我爱我居住的都市。"),
	)

	var/penalize = FALSE
	var/work_count = 0
	var/question = FALSE

	var/taken_parts = list(
		/obj/item/bodypart/l_leg,
		/obj/item/bodypart/r_leg,
		/obj/item/bodypart/l_arm,
		/obj/item/bodypart/r_arm,
		/obj/item/bodypart/head,
	)
	var/rejected_parts = list(
		/obj/item/bodypart/l_leg/robot,
		/obj/item/bodypart/r_leg/robot,
		/obj/item/bodypart/l_arm/robot,
		/obj/item/bodypart/r_arm/robot,
	)
	var/datum/looping_sound/server/soundloop

	var/operating = FALSE
	var/breaching = FALSE
	var/summon_cooldown
	var/summon_cooldown_time = 120 SECONDS
	var/summon_count = 0

/mob/living/simple_animal/hostile/abnormality/you_strong/Initialize(mapload)
	. = ..()
	soundloop = new(list(src), FALSE)
	soundloop.volume = 75
	soundloop.extra_range = 0

/mob/living/simple_animal/hostile/abnormality/you_strong/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/you_strong/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/you_strong/Life()
	. = ..()
	if(!breaching)
		return
	if((summon_cooldown < world.time) && !(status_flags & GODMODE))
		SummonAdds()

/mob/living/simple_animal/hostile/abnormality/you_strong/WorkComplete(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	. = ..()
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		src.datum_reference.qliphoth_change(-1) // No. Don't.
	work_count++
	icon_state = "you_strong_pause"
	penalize = FALSE
	if(work_count < 3)
		return
	work_count = 0
	say("你喜欢你所居住的都市吗?")
	question = TRUE
	return

/mob/living/simple_animal/hostile/abnormality/you_strong/AttemptWork(mob/living/carbon/human/user, work_type)
	if(src.datum_reference.qliphoth_meter == 0)
		return FALSE
	if(operating)
		to_chat(user, span_notice("请等待当前操作停止."))
		return FALSE
	if(!(work_type in list("YES", "NO")) && !question && ..())
		icon_state = "you_strong_work"
		return TRUE
	if((work_type in list("YES", "NO")) && !question)
		to_chat(user, span_notice("没有提示."))
		return FALSE
	if((work_type in list(ABNORMALITY_WORK_INSTINCT, ABNORMALITY_WORK_INSIGHT, ABNORMALITY_WORK_ATTACHMENT, ABNORMALITY_WORK_REPRESSION) && question))
		say("你喜欢你所居住的都市吗?")
		playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
		return FALSE
	if(work_type == "YES")
		penalize = TRUE
		say("YES. 你会为了都市变得更强.")
		icon_state = "you_strong_yes"
	else
		src.datum_reference.qliphoth_change(-1)
		say("无效输入.")
		icon_state = "you_strong_no"
	question = FALSE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/you_strong/WorkChance(mob/living/carbon/human/user, chance, work_type)
	if(penalize)
		return chance /= 2
	return ..()

/mob/living/simple_animal/hostile/abnormality/you_strong/ZeroQliphoth(mob/living/carbon/human/user)
	SLEEP_CHECK_DEATH(2 SECONDS)
	playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
	manual_emote("发出嗡嗡声.")
	SLEEP_CHECK_DEATH(2 SECONDS)
	soundloop.start()
	icon_state = "you_strong_work"
	SLEEP_CHECK_DEATH(30 SECONDS)
	soundloop.stop()
	if(datum_reference)
		src.datum_reference.qliphoth_change(3)
	icon_state = "you_strong_make"
	SLEEP_CHECK_DEATH(6)
	for(var/i = 1 to 3)
		new /mob/living/simple_animal/hostile/aminion/grown_strong(get_step(src, EAST))
		if(breaching)
			summon_count += 1
	SLEEP_CHECK_DEATH(6)
	icon_state = "you_strong_pause"

/mob/living/simple_animal/hostile/abnormality/you_strong/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_MINING)
		breaching = TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/you_strong/proc/SummonAdds()
	summon_cooldown = world.time + summon_cooldown_time
	if(summon_count > 9)//this list is not subtracted when minions are killed. Limited to 10 per breach
		return
	ZeroQliphoth()

/mob/living/simple_animal/hostile/abnormality/you_strong/attacked_by(obj/item/I, mob/living/user)
	if(!(I.type in taken_parts))
		return ..()
	if(I.type in rejected_parts)
		to_chat(user, span_notice("[src]拒绝了[I]."))
		return
	if(src.datum_reference.qliphoth_meter == 0 || src.datum_reference.working || operating)
		to_chat(user, span_notice("请等待当前操作停止."))
		return
	visible_message(span_notice("[user.first_name()] starts feeding [I] into [src]."))
	playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
	soundloop.start()
	icon_state = "you_strong_work"
	operating = TRUE
	if(!do_after(user, 2 SECONDS, src))
		to_chat(user, span_notice("但你改变了你的想法..."))
		soundloop.stop()
		icon_state = "you_strong_pause"
		operating = FALSE
		return
	soundloop.stop()
	playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
	qdel(I)
	src.datum_reference.stored_boxes += 2
	visible_message(span_nicegreen("[src]产出了 2 PE!"))
	manual_emote("在安静下来之前开始发出旋转的声音.")
	icon_state = "you_strong_pause"
	operating = FALSE
	return

/mob/living/simple_animal/hostile/abnormality/you_strong/attack_hand(mob/living/carbon/human/M)
	var/selected_part = M.zone_selected
	if(!(selected_part in list(BODY_ZONE_L_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_ARM, BODY_ZONE_R_LEG)))
		return ..()
	if(src.datum_reference.working || src.datum_reference.qliphoth_meter == 0 || operating)
		to_chat(M, span_notice("请等待当前操作停止."))
		return
	var/obj/item/bodypart/old_part = M.get_bodypart(selected_part)
	if(old_part.type in list(/obj/item/bodypart/r_leg/grown_strong, /obj/item/bodypart/l_leg/grown_strong, /obj/item/bodypart/r_arm/grown_strong, /obj/item/bodypart/l_arm/grown_strong))
		to_chat(M, span_notice("只接收原件."))
		return
	playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
	soundloop.start()
	visible_message(span_notice("[M.first_name()]将它们的[old_part.name]插入到[src]..."))
	icon_state = "you_strong_work"
	operating = TRUE
	if(!do_after(M, 5 SECONDS, src))
		visible_message(span_notice("[M.first_name()]在[src]接合之前取出了[old_part.name]!"))
		soundloop.stop()
		playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
		icon_state = "you_strong_pause"
		operating = FALSE
		return
	var/obj/item/bodypart/prosthetic
	switch(selected_part)
		if(BODY_ZONE_L_ARM)
			prosthetic = new/obj/item/bodypart/l_arm/grown_strong(M)
		if(BODY_ZONE_L_LEG)
			prosthetic = new/obj/item/bodypart/l_leg/grown_strong(M)
		if(BODY_ZONE_R_ARM)
			prosthetic = new/obj/item/bodypart/r_arm/grown_strong(M)
		if(BODY_ZONE_R_LEG)
			prosthetic = new/obj/item/bodypart/r_leg/grown_strong(M)
		else
			soundloop.stop()
			say("错误：插入了外部对象，请联系维修人员.")
			playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
			icon_state = "you_strong_pause"
			operating = FALSE
			return
	prosthetic.replace_limb(M)
	manual_emote("发出磨碎的声音.")
	M.emote("scream")
	M.deal_damage(10, BRUTE) // Bro your [X] just got chopped off, no armor's gonna resist that.
	to_chat(M, span_notice("Your [old_part.name] has been replaced!"))
	qdel(old_part)
	M.regenerate_icons()
	src.datum_reference.qliphoth_change(-1)
	soundloop.stop()
	playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
	icon_state = "you_strong_pause"
	operating = FALSE
	return

/mob/living/simple_animal/hostile/aminion/grown_strong
	name = "变得强大"
	desc = "一个浑身是血的人形，由...塑料制成?"
	icon_state = "grown_strong"
	icon_living = "grown_strong"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	maxHealth = 120
	health = 120
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0)

	move_to_delay = 5
	melee_damage_lower = 2
	melee_damage_upper = 4
	melee_damage_type = RED_DAMAGE

	attack_sound = "swing_hit"
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	a_intent = "hostile"
	move_resist = 1500

	can_patrol = TRUE

	del_on_death = FALSE
	score_divider = 1.5//3 of them should equal 1 HE
	threat_level = TETH_LEVEL
	var/gear = 2
	COOLDOWN_DECLARE(gear_shift)
	var/gear_cooldown = 1 MINUTES
	//tracks speed change even if altered by other speed modifiers.
	var/gear_speed = 0
	var/gear_health = 0.35 // This determines the amount of times surgery can activate. If the max HP is lower than this percentage, the creature will gib.
	var/can_act = TRUE//necessary sanity for spin attacks

/mob/living/simple_animal/hostile/aminion/grown_strong/Move(atom/newloc, dir, step_x, step_y)
	if(status_flags & GODMODE)
		return FALSE
	if(can_act == FALSE)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/aminion/grown_strong/AttackingTarget(atom/attacked_target)
	if(status_flags & GODMODE)
		return FALSE
	if(can_act == FALSE)
		return FALSE
	if(gear == 10)
		if(prob(15))
			SpinAttack()
			return
	return ..()

/mob/living/simple_animal/hostile/aminion/grown_strong/proc/UpdateGear()
	manual_emote("切换到第[gear]档!")
	melee_damage_lower = 2 * max(1, gear*0.5)
	melee_damage_upper = 4 * max(1, gear*0.5)
	//Reset the speed. First proc changes this only with 0.
	ChangeMoveToDelayBy(gear_speed)
	//Calculate speed change.
	gear_speed = FLOOR(gear / 3, 1)
	//CRANK UP THE SPEED.
	ChangeMoveToDelayBy(-gear_speed)
	rapid_melee = gear > 7 ? 2 : 1

/mob/living/simple_animal/hostile/aminion/grown_strong/Life()
	. = ..()
	if(!COOLDOWN_FINISHED(src, gear_shift) || (status_flags & GODMODE))
		return
	gear = clamp(gear + rand(-1, 3), 1, 10)
	UpdateGear()
	src.apply_damage(30, BRUTE, null, 0, spread_damage = TRUE)// OOF OUCH MY BONES
	COOLDOWN_START(src, gear_shift, gear_cooldown)

/mob/living/simple_animal/hostile/aminion/grown_strong/death(gibbed)
	if(maxHealth > initial(maxHealth) * gear_health)
		INVOKE_ASYNC(src, PROC_REF(Undie))
		return FALSE
	visible_message(span_notice("[src]爆炸成一团塑料和血!"))
	. = ..()
	gib(TRUE, TRUE, TRUE)
	return

/mob/living/simple_animal/hostile/aminion/grown_strong/proc/Undie()
	manual_emote("颤抖得厉害，内心旋转...")
	src.maxHealth = min(maxHealth - initial(maxHealth) * 0.2, initial(maxHealth))
	src.adjustBruteLoss(-9999)
	status_flags |= GODMODE
	SLEEP_CHECK_DEATH(3 SECONDS)
	status_flags &= ~GODMODE
	src.adjustBruteLoss(-9999)
	gear = clamp(gear + 2, 1, 10)
	manual_emote("颤抖着恢复了生命!")
	switch(gear)
		if(0 to 6)//gear is set to 2 at initialize, would need to be varedited to go under that
			playsound(src, 'sound/weapons/ego/strong_uncharged.ogg', 60)
		if(6 to 8)
			playsound(src, 'sound/weapons/ego/strong_charged1.ogg', 60)
		else
			playsound(src, 'sound/weapons/ego/strong_charged2.ogg', 60)
	UpdateGear()

/mob/living/simple_animal/hostile/aminion/grown_strong/proc/SpinAttack()
	can_act = FALSE
	manual_emote("伸展双臂，上半身开始旋转!")
	playsound(src, 'sound/weapons/ego/strong_uncharged.ogg', 60)
	SLEEP_CHECK_DEATH(20)
	for(var/i = 0, i <=4, ++i)
		for(var/turf/T in oview(2, src))
			new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in oview(2, src))
			if(faction_check_mob(L))
				continue
			L.apply_damage(melee_damage_lower, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		playsound(src, 'sound/weapons/ego/strong_charged2.ogg', 60)
		emote("spin")
		SLEEP_CHECK_DEATH(5)
	playsound(src, 'sound/weapons/ego/strong_gauntlet.ogg', 60)
	can_act = TRUE
	UpdateGear()


////// Parts! //////

/obj/item/bodypart/r_leg/grown_strong
	name = "强大的右腿"
	desc = "用塑料包裹的肉质肢体"
	icon = 'icons/mob/human_parts_greyscale.dmi'
	icon_state = "human_r_leg"
	var/buff_type

/obj/item/bodypart/r_leg/grown_strong/Initialize(mapload)
	. = ..()
	color = pick(
		COLOR_ASSEMBLY_RED,
		COLOR_ASSEMBLY_GREEN,
		COLOR_ASSEMBLY_BLUE,
		COLOR_ASSEMBLY_YELLOW,
		COLOR_ASSEMBLY_BGRAY,
		COLOR_ASSEMBLY_PURPLE,
	)
	buff_type = pick(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)

/obj/item/bodypart/r_leg/grown_strong/drop_limb(special)
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(buff_type, -2)
	..()

/obj/item/bodypart/r_leg/grown_strong/attach_limb(mob/living/carbon/C, special)
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(buff_type, 2)

/obj/item/bodypart/r_leg/grown_strong/get_limb_icon(dropped)
	icon_state = ""
	. = list()
	var/image_dir = 0
	if(dropped)
		image_dir = SOUTH
	var/image/limb = image(layer = -BODYPARTS_LAYER, dir = image_dir)
	. += limb
	limb.icon = 'icons/mob/human_parts_greyscale.dmi'
	limb.icon_state = "human_r_leg"
	limb.color = src.color // Is this VIOLENTLY incompatible with other races? Yeah. Does that matter for us? No... Right?

/obj/item/bodypart/l_leg/grown_strong
	name = "强大的左腿"
	desc = "用塑料包裹的肉质肢体"
	icon = 'icons/mob/human_parts_greyscale.dmi'
	icon_state = "human_l_leg"
	var/buff_type

/obj/item/bodypart/l_leg/grown_strong/Initialize(mapload)
	. = ..()
	color = pick(
		COLOR_ASSEMBLY_RED,
		COLOR_ASSEMBLY_GREEN,
		COLOR_ASSEMBLY_BLUE,
		COLOR_ASSEMBLY_YELLOW,
		COLOR_ASSEMBLY_BGRAY,
		COLOR_ASSEMBLY_PURPLE,
	)
	buff_type = pick(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)

/obj/item/bodypart/l_leg/grown_strong/drop_limb(special)
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(buff_type, -2)
	..()

/obj/item/bodypart/l_leg/grown_strong/attach_limb(mob/living/carbon/C, special)
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(buff_type, 2)

/obj/item/bodypart/l_leg/grown_strong/get_limb_icon(dropped)
	icon_state = ""
	. = list()
	var/image_dir = 0
	if(dropped)
		image_dir = SOUTH
	var/image/limb = image(layer = -BODYPARTS_LAYER, dir = image_dir)
	. += limb
	limb.icon = 'icons/mob/human_parts_greyscale.dmi'
	limb.icon_state = "human_l_leg"
	limb.color = src.color // Is this VIOLENTLY incompatible with other races? Yeah. Does that matter for us? No... Right?

/obj/item/bodypart/r_arm/grown_strong
	name = "强大的右臂"
	desc = "用塑料包裹的肉质肢体"
	icon = 'icons/mob/human_parts_greyscale.dmi'
	icon_state = "human_r_arm"
	var/buff_type

/obj/item/bodypart/r_arm/grown_strong/Initialize(mapload)
	. = ..()
	color = pick(
		COLOR_ASSEMBLY_RED,
		COLOR_ASSEMBLY_GREEN,
		COLOR_ASSEMBLY_BLUE,
		COLOR_ASSEMBLY_YELLOW,
		COLOR_ASSEMBLY_BGRAY,
		COLOR_ASSEMBLY_PURPLE,
	)
	buff_type = pick(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)

/obj/item/bodypart/r_arm/grown_strong/drop_limb(special)
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(buff_type, -2)
	..()

/obj/item/bodypart/r_arm/grown_strong/attach_limb(mob/living/carbon/C, special)
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(buff_type, 2)

/obj/item/bodypart/r_arm/grown_strong/get_limb_icon(dropped)
	icon_state = ""
	. = list()
	var/image_dir = 0
	if(dropped)
		image_dir = SOUTH
	var/image/limb = image(layer = -BODYPARTS_LAYER, dir = image_dir)
	var/image/aux
	. += limb
	limb.icon = 'icons/mob/human_parts_greyscale.dmi'
	limb.icon_state = "human_r_arm"
	limb.color = src.color // Is this VIOLENTLY incompatible with other races? Yeah. Does that matter for us? No... Right?
	if(aux_zone)
		aux = image(limb.icon, "human_r_hand", -aux_layer, image_dir)
		aux.color = limb.color
		. += aux

/obj/item/bodypart/l_arm/grown_strong
	name = "强大的左臂"
	desc = "用塑料包裹的肉质肢体"
	icon = 'icons/mob/human_parts_greyscale.dmi'
	icon_state = "human_l_arm"
	var/buff_type

/obj/item/bodypart/l_arm/grown_strong/Initialize(mapload)
	. = ..()
	color = pick(
		COLOR_ASSEMBLY_RED,
		COLOR_ASSEMBLY_GREEN,
		COLOR_ASSEMBLY_BLUE,
		COLOR_ASSEMBLY_YELLOW,
		COLOR_ASSEMBLY_BGRAY,
		COLOR_ASSEMBLY_PURPLE,
	)
	buff_type = pick(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)

/obj/item/bodypart/l_arm/grown_strong/drop_limb(special)
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(buff_type, -2)
	..()

/obj/item/bodypart/l_arm/grown_strong/attach_limb(mob/living/carbon/C, special)
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(buff_type, 2)

/obj/item/bodypart/l_arm/grown_strong/get_limb_icon(dropped)
	icon_state = ""
	. = list()
	var/image_dir = 0
	if(dropped)
		image_dir = SOUTH
	var/image/limb = image(layer = -BODYPARTS_LAYER, dir = image_dir)
	var/image/aux
	. += limb
	limb.icon = 'icons/mob/human_parts_greyscale.dmi'
	limb.icon_state = "human_l_arm"
	limb.color = src.color // Is this VIOLENTLY incompatible with other races? Yeah. Does that matter for us? No... Right?
	if(aux_zone)
		aux = image(limb.icon, "human_l_hand", -aux_layer, image_dir)
		aux.color = limb.color
		. += aux
