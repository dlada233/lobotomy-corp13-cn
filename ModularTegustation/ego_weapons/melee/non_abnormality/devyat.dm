/obj/item/ego_weapon/city/devyat_trunk
	name = "九协会 派送箱"
	desc = "一件九协会派送箱."
	special = "这把武器同时具备储物功能. \
	攻击时自动进入作战模式，该模式下连续攻击将对使用者和目标造成递增的伤害. \
	且作战期间无法丢弃武器. 手持使用可关闭作战模式.\
	Alt+左键点击箱体可上锁/解锁."
	worn_icon = 'icons/obj/clothing/ego_gear/devyat_armor.dmi'
	worn_icon_state = "s_polu"
	icon = 'icons/obj/clothing/ego_gear/devyat_icon.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/devyat_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/devyat_right.dmi'
	icon_state = "s_polu"
	inhand_icon_state = "s_polu"
	force = 14
	slot_flags = ITEM_SLOT_BACK
	damtype = BLACK_DAMAGE
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)
	attack_verb_continuous = list("slices", "gashes", "stabs")
	attack_verb_simple = list("slice", "gash", "stab")
	hitsound = 'sound/weapons/ego/devyat_slice.ogg'
	var/component_type = /datum/component/storage/concrete
	var/combat_mode = FALSE
	var/can_attack = TRUE
	var/owner = null
	var/theif_damage = 20

	var/courier_trunk = 0
	var/passive_courier_trunk_add = 3
	var/attacking_courier_trunk_add = 2
	var/attack_courier_trunk_cooldown
	var/attack_courier_trunk_cooldown_time = 4 SECONDS

	var/tier0_icon = "s_polu"
	var/tier1_threshold = 10
	var/tier1_icon = "s_polu_knife"
	var/tier2_threshold = 20
	var/tier2_icon = "s_polu_gadget"
	var/tier3_threshold = 30

	var/tier1_damage_multiplier = 1.3
	var/tier2_damage_multiplier = 1.6
	var/tier3_damage_multiplier = 2

	var/tier1_vc_trigger = FALSE
	var/tier2_vc_trigger = FALSE
	var/tier3_vc_trigger = FALSE

	var/overclock = FALSE
	var/overclock_mult = 1
	var/RR_armor = 0.5

/obj/item/devyat_unlocker
	name = "九协会 派送箱解锁器"
	desc = "一种能解除九协会派送箱DNA锁的小型工具."
	icon = 'ModularTegustation/Teguicons/refiner.dmi'
	icon_state = "green"

/obj/item/devyat_unlocker/attack(mob/living/target, mob/living/user)
	. = ..()
	if(do_after(user, 50, user))
		if(ishuman(target))
			var/mob/living/carbon/human/possible_target = target
			for(var/obj/item/I in possible_target.get_all_gear())
				if(istype(I, /obj/item/ego_weapon/city/devyat_trunk))
					var/obj/item/ego_weapon/city/devyat_trunk/user_trunk = I
					user_trunk.owner = null
					to_chat(user, "<span class='spider'><b>你已禁用 [src]上的DNA锁.</b></span>")

//Storage Stuff
/obj/item/ego_weapon/city/devyat_trunk/equip_to_best_slot(mob/M, check_hand = TRUE)
	if(combat_mode)
		to_chat(M, span_warning("你无法在战斗模式下装备九协会派送箱!"))
		return FALSE
	. = ..()

/obj/item/ego_weapon/city/devyat_trunk/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(combat_mode)
		to_chat(M, span_warning("你无法在战斗模式下装备九协会派送箱!"))
		return FALSE
	. = ..()

/obj/item/ego_weapon/city/devyat_trunk/attack_hand(mob/user)
	if(owner && (user != owner))
		if(ishuman(user))
			var/mob/living/carbon/human/theif = user
			say("你正在触摸一个没有正确权限的九协会派送箱，请后退.")
			playsound(get_turf(src), 'sound/weapons/ego/devyat_overclock.ogg', 25, 0, 4)
			theif.apply_damage(theif_damage, BLACK_DAMAGE)
		return FALSE
	. = ..()

/obj/item/ego_weapon/city/devyat_trunk/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(owner && istype(I, /obj/item/devyat_unlocker))
		owner = null
		to_chat(user, "<span class='spider'><b>你已禁用 [src]上的DNA锁.</b></span>")

/obj/item/ego_weapon/city/devyat_trunk/AltClick(mob/user)
	if(!CanUseEgo(user))
		return
	if(owner)
		if(user == owner)
			owner = null
			to_chat(user, "<span class='spider'><b>你已禁用 [src]上的DNA锁.</b></span>")
	else
		owner = user
		to_chat(user, "<span class='spider'><b>[src]收集你的DNA，现在已经进入DNA锁定状态.</b></span>")
	. = ..()

/obj/item/ego_weapon/city/devyat_trunk/get_dumping_location(obj/item/storage/source,mob/user)
	return src

/obj/item/ego_weapon/city/devyat_trunk/Initialize()
	. = ..()
	PopulateContents()

/obj/item/ego_weapon/city/devyat_trunk/ComponentInitialize()
	AddComponent(component_type)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 60
	STR.max_items = 14

/obj/item/ego_weapon/city/devyat_trunk/AllowDrop()
	return FALSE

/obj/item/ego_weapon/city/devyat_trunk/contents_explosion(severity, target)
	for(var/thing in contents)
		switch(severity)
			if(EXPLODE_DEVASTATE)
				SSexplosions.high_mov_atom += thing
			if(EXPLODE_HEAVY)
				SSexplosions.med_mov_atom += thing
			if(EXPLODE_LIGHT)
				SSexplosions.low_mov_atom += thing

/obj/item/ego_weapon/city/devyat_trunk/canStrip(mob/who)
	. = ..()
	if(!.)
		return TRUE

/obj/item/ego_weapon/city/devyat_trunk/doStrip(mob/who)
	if(owner && (who != owner))
		if(ishuman(who))
			var/mob/living/carbon/human/theif = who
			say("你正在触摸一个没有正确权限的九协会派送箱，请后退.")
			playsound(get_turf(src), 'sound/weapons/ego/devyat_overclock.ogg', 25, 0, 4)
			theif.apply_damage(theif_damage, BLACK_DAMAGE)
		return FALSE
	return ..()

/obj/item/ego_weapon/city/devyat_trunk/proc/PopulateContents()

/obj/item/ego_weapon/city/devyat_trunk/proc/emptyStorage()
	var/datum/component/storage/ST = GetComponent(/datum/component/storage)
	ST.do_quick_empty()

/obj/item/ego_weapon/city/devyat_trunk/Destroy()
	for(var/obj/important_thing in contents)
		if(!(important_thing.resistance_flags & INDESTRUCTIBLE))
			continue
		important_thing.forceMove(drop_location())
	return ..()

//Combat Stuff
/obj/item/ego_weapon/city/devyat_trunk/examine(mob/user)
	. = ..()
	. += span_notice("该武器目前有 [courier_trunk] 个堆叠.")

/obj/item/ego_weapon/city/devyat_trunk/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return
	update_icon_state()
	if(combat_mode)
		to_chat(user, span_nicegreen("激活战略R&R模式..."))
		can_attack = FALSE
		user.physiology.red_mod -= RR_armor
		user.physiology.white_mod -= RR_armor
		user.physiology.black_mod -= RR_armor
		user.physiology.pale_mod -= RR_armor
		if(do_after(user, 50, user))
			end_combat()
			to_chat(user, "<span class='spider'><b>战斗模式关闭!</b></span>")
		else
			to_chat(user, "<span class='spider'><b>战略R&R模式被中断!</b></span>")
		user.physiology.red_mod += RR_armor
		user.physiology.white_mod += RR_armor
		user.physiology.black_mod += RR_armor
		user.physiology.pale_mod += RR_armor
		can_attack = TRUE
	else
		start_combat(user)

/obj/item/ego_weapon/city/devyat_trunk/attack(mob/living/target, mob/living/user)
	if(!can_attack)
		return FALSE
	. = ..()
	update_icon_state()
	update_icon()
	if(!combat_mode)
		start_combat(user)
	else
		if(attack_courier_trunk_cooldown < world.time - attack_courier_trunk_cooldown_time)
			attack_courier_trunk_cooldown = world.time
			gain_courier_trunk(attacking_courier_trunk_add, user)

/obj/item/ego_weapon/city/devyat_trunk/proc/end_combat()
	combat_mode = FALSE
	overclock = FALSE
	tier1_vc_trigger = FALSE
	tier2_vc_trigger = FALSE
	tier3_vc_trigger = FALSE
	courier_trunk = 0
	force_multiplier = 1
	REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
	icon_state = tier0_icon
	inhand_icon_state = tier0_icon
	update_icon_state()

/obj/item/ego_weapon/city/devyat_trunk/proc/start_combat(mob/living/user)
	combat_mode = TRUE
	ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
	addtimer(CALLBACK(src, PROC_REF(passive_courier_trunk), user), 5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(entering_combat), user), 1)
	icon_state = tier1_icon
	inhand_icon_state = tier1_icon
	to_chat(user, "<span class='spider'><b>战斗模式已激活!</b></span>")
	update_icon_state()

/obj/item/ego_weapon/city/devyat_trunk/proc/passive_courier_trunk(mob/living/user)
	if(combat_mode)
		gain_courier_trunk(passive_courier_trunk_add, user)
		if(overclock)
			playsound(get_turf(user), 'sound/weapons/ego/devyat_alarm.ogg', 25, 0, 4)
		addtimer(CALLBACK(src, PROC_REF(passive_courier_trunk), user), 5 SECONDS)

/obj/item/ego_weapon/city/devyat_trunk/proc/gain_courier_trunk(amount, mob/living/user)
	if(overclock)
		user.apply_damage(courier_trunk * overclock_mult, BLACK_DAMAGE)
		if(user.stat == DEAD)
			playsound(get_turf(user), 'sound/weapons/ego/devyat_overclock_death.ogg', 50, 0, 4)
			end_combat()
			return
		else
			playsound(get_turf(user), 'sound/weapons/ego/devyat_overclock.ogg', 25, 0, 4)

	courier_trunk += amount
	to_chat(user, span_nicegreen("[src]获得[amount]个堆叠!"))
	if(courier_trunk >= tier3_threshold)
		force_multiplier = tier3_damage_multiplier
		if(!tier3_vc_trigger)
			tier3_vc_trigger = TRUE
			playsound(get_turf(user), 'sound/weapons/ego/devyat_stage_up.ogg', 25, 0, 4)
			addtimer(CALLBACK(src, PROC_REF(entering_stage_3), user), 1)

		if(!overclock)
			overclock = TRUE
			playsound(get_turf(user), 'sound/weapons/ego/devyat_alarm.ogg', 25, 0, 4)

	else if(courier_trunk >= tier2_threshold)
		force_multiplier = tier2_damage_multiplier
		icon_state = tier2_icon
		inhand_icon_state = tier2_icon
		update_icon_state()
		if(!tier2_vc_trigger)
			tier2_vc_trigger = TRUE
			playsound(get_turf(user), 'sound/weapons/ego/devyat_stage_up.ogg', 25, 0, 4)
			addtimer(CALLBACK(src, PROC_REF(entering_stage_2), user), 1)

	else if(courier_trunk >= tier1_threshold)
		force_multiplier = tier1_damage_multiplier
		if(!tier1_vc_trigger)
			tier1_vc_trigger = TRUE
			playsound(get_turf(user), 'sound/weapons/ego/devyat_stage_up.ogg', 25, 0, 4)
			addtimer(CALLBACK(src, PROC_REF(entering_stage_1), user), 1)

	else
		force_multiplier = 1
		icon_state = tier1_icon
		inhand_icon_state = tier1_icon
		update_icon_state()

/obj/item/ego_weapon/city/devyat_trunk/proc/entering_combat(mob/living/user)
	playsound(get_turf(user), 'sound/weapons/ego/devyat_combat_start.ogg', 50, 0, 4)
	say("检测到敌对势力.")
	sleep(20)
	say("波鲁德尼察，强力派送模式启动.")

/obj/item/ego_weapon/city/devyat_trunk/proc/entering_stage_1(mob/living/user)
	playsound(get_turf(user), 'sound/weapons/ego/devyat_stage_1.ogg', 50, 0, 4)
	say("阶段1，开始派送辅助及管理流程.")
	sleep(30)
	say("请沉着地开拓生路.")

/obj/item/ego_weapon/city/devyat_trunk/proc/entering_stage_2(mob/living/user)
	playsound(get_turf(user), 'sound/weapons/ego/devyat_stage_2.ogg', 50, 0, 4)
	say("阶段2，派送单元功率提升.")
	sleep(30)
	say("建议迅速开拓.")

/obj/item/ego_weapon/city/devyat_trunk/proc/entering_stage_3(mob/living/user)
	playsound(get_turf(user), 'sound/weapons/ego/devyat_stage_3.ogg', 50, 0, 4)
	say("阶段3，警告，任务超时，进入派送加速最终阶段.")
	sleep(30)
	say("进一步的时间延误将无法保障您的安全.")

/obj/item/ego_weapon/city/devyat_trunk/demo
	name = "重型九协会派送箱"
	desc = "一件非常重的九协会派送箱."
	worn_icon_state = "b_polu"
	icon_state = "b_polu"
	inhand_icon_state = "b_polu"
	force = 21
	slot_flags = ITEM_SLOT_BACK
	attack_speed = 1.5
	attack_verb_continuous = list("bludgeons", "smacks")
	attack_verb_simple = list("bludgeon", "smack")
	hitsound = 'sound/weapons/ego/devyat_slam.ogg'
	tier0_icon = "b_polu"
	tier1_icon = "b_polu_demo"
	tier2_icon = "b_polu_hammer"
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
