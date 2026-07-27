/obj/item/ego_weapon/ranged/correctional
	name = "教化"
	desc = "在这里，你与我们永远同在."
	icon_state = "correctional"
	inhand_icon_state = "correctional"
	force = 24
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_correctional
	weapon_weight = WEAPON_HEAVY
	pellets = 8
	variance = 15
	randomspread = FALSE
	fire_delay = 7
	max_shots = 12
	ammo_on_reload = 1
	reloadtime = 0.6 SECONDS
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'
	round_text = "你开始填装弹丸."
	reload_success_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/hornet
	name = "黄蜂"
	desc = "蜂之王国需要有更多的工蜂才能发展壮大，成就自己的江山. 尽管王国会在历史上备受瞩目，可又有谁会记得为它做出奉献与牺牲的工蜂呢? \
	这杆枪不需要瞄准就可以击中它的目标，唯一需要的就是持有者的意念. 它射出的子弹可以击中目不所及的敌人，甚至连历史都能够跨越."
	icon_state = "hornet"
	inhand_icon_state = "hornet"
	force = 24
	projectile_path = /obj/projectile/ego_bullet/ego_hornet
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/weapons/gun/rifle/leveraction.ogg'
	fire_delay = 4
	max_shots = 10
	ammo_on_reload = 1
	reloadtime = 0.3 SECONDS
	reload_success_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)


/obj/item/ego_weapon/ranged/hatred
	name = "以爱与恨之名"
	desc = "这根闪闪发光的魔法棒散发着魔法少女的爱之能量. 坏蛋将会被神圣的光辉净化，然后重生. \
	他们将会被烈焰灼烧，失去醒来的意志. 想要守护每个人的情感很快就变成腐蚀心灵的痴迷. 当她试图做出补救时，一切都为时已晚. "
	icon_state = "hatred"
	inhand_icon_state = "hatred"
	special = "这把武器将会治疗所击中的人类."
	force = 18
	attack_speed = 1
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_hatred
	weapon_weight = WEAPON_MEDIUM
	fire_delay = 10
	max_shots = 15
	ammo_on_reload = 1
	passive_reload = 2 SECONDS
	reloadtime = 0.2 SECONDS
	reload_start_sound = 'sound/abnormalities/hatredqueen/gun.ogg'
	reload_text = "The weapon starts to recharge its mana."
	fire_sound = 'sound/abnormalities/hatredqueen/attack.ogg'

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/hatred/GunAttackInfo(mob/user)
	return span_notice("魔杖的魔法造成 [last_projectile_damage] 随机类型伤害.[force_multiplier != 1 ? " (+ [(force_multiplier - 1) * 100]%)" : ""]")

/obj/item/ego_weapon/ranged/hatred/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/nihil/heart))
		return
	new /obj/item/ego_weapon/ranged/hatred_nihil(get_turf(src))
	to_chat(user,span_warning("当 [I] 被 [src] 吞噬时，它似乎将周围的光芒尽数抽干!"))
	playsound(user, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)
	qdel(I)
	qdel(src)

// Magic Bullet armour increases attack speed from 30 to 15
// Big Iron armour on the other hand increases damage by a factor of 2.5x80, which will give it 40 more damage than the magic bullet armour
/obj/item/ego_weapon/ranged/magicbullet
	name = "魔弹"
	desc = "尽管无法完全提取该异想体核心中那股深奥的力量，但利用那神奇力量所研制出来的武器仍然无比强大. \
	这把枪射出的子弹甚至能达到人们目不可及之处."
	icon_state = "magic_bullet"
	inhand_icon_state = "magic_bullet"
	special = "这把武器能穿透所有目标. \
		穿着对应护甲使用这把武器会获得30%的伤害加成."
	force = 24
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_magicbullet
	weapon_weight = WEAPON_HEAVY
	fire_delay = 15
	max_shots = 7
	ammo_on_reload = 1
	reloadtime = 0.3 SECONDS
	fire_sound = 'sound/abnormalities/freischutz/shoot.ogg'

	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/ranged/magicbullet/before_firing(atom/target, mob/user)
	projectile_damage_multiplier = 1
	var/mob/living/carbon/human/myman = user
	var/obj/item/clothing/suit/armor/ego_gear/he/magicbullet/Y = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	var/obj/item/clothing/suit/armor/ego_gear/realization/bigiron/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Y))
		projectile_damage_multiplier *= 1.3
	if(istype(Z))
		projectile_damage_multiplier *= 2
	..()

/obj/item/ego_weapon/ranged/magicbullet/melee_attack_chain(mob/user, atom/target, params)
	if (!istype(user,/mob/living/carbon/human))
		return
	var/mob/living/carbon/human/myman = user
	var/obj/item/clothing/suit/armor/ego_gear/realization/bigiron/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if (istype(Z))
		force = 48
	else
		force = 24
	. = ..()

//Funeral guns have two different names;
//Solemn Lament is the white gun, Solemn Vow is the black gun.
//Likewise, they emit butterflies of those respective colors.
//When together they should be on par with a 2 handed waw gun.
/obj/item/ego_weapon/ranged/pistol/solemnlament
	name = "圣哀"
	desc = "一把带着对生者哀叹的手枪. \
	飘零的羽毛是否能够找到它自己的翼?"
	icon_state = "solemnlament"
	inhand_icon_state = "solemnlament"
	special = "拥有第二把圣哀或者圣宣时将会减少射击散布，并允许两把枪同时换弹.\n同时发射圣哀与圣宣，将使伤害增加30%."
	force = 9
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_solemnlament
	fire_delay = 5
	max_shots = 18
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/abnormalities/funeral/spiritgunwhite.ogg'
	fire_sound_volume = 30
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/pistol/solemnlament/afterattack(atom/target, mob/living/user, flag, params)
	dual_wield_spread = initial(dual_wield_spread)
	if(!user.get_inactive_held_item())
		return ..()
	if(!(istype(user.get_inactive_held_item(), /obj/item/ego_weapon/ranged/pistol/solemnlament) || istype(user.get_inactive_held_item(), /obj/item/ego_weapon/ranged/pistol/solemnvow)))
		return ..()
	SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, target, user, flag, params)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_AFTERATTACK, target, user, flag, params)
	//Is it stupid as hell that we're doing this? yes, But the guns were used together in lcorp and I wanted the same functionality here.
	dual_wield_spread = 0
	if(QDELETED(target))
		return

	if(!can_shoot(user)) //Just because you can pull the trigger doesn't mean it can shoot.
		return

	if(flag) //It's adjacent, is the user, or is on the user's person
		if(target in user.contents) //can't shoot stuff inside us.
			return
		if(!ismob(target)) //melee attack
			return
		if(target == user && user.zone_selected != BODY_ZONE_PRECISE_MOUTH) //so we can't shoot ourselves (unless mouth selected)
			return
		if(ismob(target) && user.a_intent == INTENT_GRAB)
			if(user.GetComponent(/datum/component/gunpoint))
				to_chat(user, span_warning("你已经在持有某物了!"))
				return
			user.AddComponent(/datum/component/gunpoint, target, src)
			return
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			for(var/i in C.all_wounds)
				var/datum/wound/W = i
				if(W.try_treating(src, user))
					return // another coward cured!

	if(istype(user))//Check if the user can use the gun, if the user isn't alive(turrets) assume it can.
		var/mob/living/L = user
		if(!can_trigger_gun(L))
			return

	if(flag)
		if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
			handle_suicide(user, target, params)
			return

	if(check_botched(user))
		return

	//DUAL (or more!) WIELDING
	var/bonus_spread = 0
	var/loop_counter = 0
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		for(var/obj/item/ego_weapon/ranged/G in H.held_items)
			if(G == src)
				continue
			else if(G.can_trigger_gun(user) && G.can_shoot(user))
				bonus_spread += dual_wield_spread
				loop_counter++
				addtimer(CALLBACK(G, TYPE_PROC_REF(/obj/item/ego_weapon/ranged, process_fire), target, user, TRUE, params, null, bonus_spread), loop_counter)

	return process_fire(target, user, TRUE, params, null, bonus_spread)

/obj/item/ego_weapon/ranged/pistol/solemnlament/OnReload(mob/user)
	var/mob/living/carbon/human/myman = user
	for(var/obj/item/ego_weapon/ranged/pistol/solemnvow/Vow in myman.held_items)
		to_chat(user,span_notice("你同时为[Vow]换弹."))
		Vow.shotsleft = Vow.max_shots
		break
	for(var/obj/item/ego_weapon/ranged/pistol/solemnlament/Lament in myman.held_items)
		if(Lament != src)
			to_chat(user,span_notice("你同时为另一把[Lament]换弹."))
			Lament.shotsleft = Lament.max_shots
			break

/obj/item/ego_weapon/ranged/pistol/solemnlament/before_firing(atom/target, mob/user)
	projectile_damage_multiplier = 1
	dual_wield_spread = initial(dual_wield_spread)
	var/mob/living/carbon/human/myman = user
	for(var/obj/item/ego_weapon/ranged/pistol/solemnvow/Vow in myman.held_items)
		projectile_damage_multiplier *= 1.3
		break
	var/obj/item/clothing/suit/armor/ego_gear/realization/eulogy/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Z))
		projectile_damage_multiplier *= 2

/obj/item/ego_weapon/ranged/pistol/solemnlament/melee_attack_chain(mob/user, atom/target, params)
	if (!istype(user,/mob/living/carbon/human))
		return
	var/mob/living/carbon/human/myman = user
	var/obj/item/clothing/suit/armor/ego_gear/realization/eulogy/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if (istype(Z))
		force = 18
	else
		force = 9
	. = ..()

/obj/item/ego_weapon/ranged/pistol/solemnvow
	name = "圣宣"
	desc = "一把带着对逝者悲痛的手枪. \
	即便是翼，也没有一片羽毛能逃离此地."
	icon_state = "solemnvow"
	inhand_icon_state = "solemnvow"
	special = "拥有第二把圣宣或者圣哀时将会减少射击散布，并允许两把枪同时换弹.\n同时发射圣哀与圣宣，将使伤害增加30%"
	force = 9
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_solemnvow
	fire_delay = 5
	max_shots = 18
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/abnormalities/funeral/spiritgunblack.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/pistol/solemnvow/afterattack(atom/target, mob/living/user, flag, params)
	dual_wield_spread = initial(dual_wield_spread)
	if(!user.get_inactive_held_item())
		return ..()
	if(!(istype(user.get_inactive_held_item(), /obj/item/ego_weapon/ranged/pistol/solemnlament) || istype(user.get_inactive_held_item(), /obj/item/ego_weapon/ranged/pistol/solemnvow)))
		return ..()
	SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, target, user, flag, params)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_AFTERATTACK, target, user, flag, params)
	//Is it stupid as hell that we're doing this? yes, But the guns were used together in lcorp and I wanted the same functionality here.
	dual_wield_spread = 0
	if(QDELETED(target))
		return

	if(!can_shoot(user)) //Just because you can pull the trigger doesn't mean it can shoot.
		return

	if(flag) //It's adjacent, is the user, or is on the user's person
		if(target in user.contents) //can't shoot stuff inside us.
			return
		if(!ismob(target)) //melee attack
			return
		if(target == user && user.zone_selected != BODY_ZONE_PRECISE_MOUTH) //so we can't shoot ourselves (unless mouth selected)
			return
		if(ismob(target) && user.a_intent == INTENT_GRAB)
			if(user.GetComponent(/datum/component/gunpoint))
				to_chat(user, span_warning("你已经在持有某物了!"))
				return
			user.AddComponent(/datum/component/gunpoint, target, src)
			return
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			for(var/i in C.all_wounds)
				var/datum/wound/W = i
				if(W.try_treating(src, user))
					return // another coward cured!

	if(istype(user))//Check if the user can use the gun, if the user isn't alive(turrets) assume it can.
		var/mob/living/L = user
		if(!can_trigger_gun(L))
			return

	if(flag)
		if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
			handle_suicide(user, target, params)
			return

	if(check_botched(user))
		return

	//DUAL (or more!) WIELDING
	var/bonus_spread = 0
	var/loop_counter = 0
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		for(var/obj/item/ego_weapon/ranged/G in H.held_items)
			if(G == src)
				continue
			else if(G.can_trigger_gun(user) && G.can_shoot(user))
				bonus_spread += dual_wield_spread
				loop_counter++
				addtimer(CALLBACK(G, TYPE_PROC_REF(/obj/item/ego_weapon/ranged, process_fire), target, user, TRUE, params, null, bonus_spread), loop_counter)

	return process_fire(target, user, TRUE, params, null, bonus_spread)

/obj/item/ego_weapon/ranged/pistol/solemnvow/OnReload(mob/user)
	var/mob/living/carbon/human/myman = user
	for(var/obj/item/ego_weapon/ranged/pistol/solemnlament/Lament in myman.held_items)
		to_chat(user,span_notice("你同时为[Lament]换弹."))
		Lament.shotsleft = Lament.max_shots
		break
	for(var/obj/item/ego_weapon/ranged/pistol/solemnvow/Vow in myman.held_items)
		if(Vow != src)
			to_chat(user,span_notice("你同时为另一个把[Vow]换弹."))
			Vow.shotsleft = Vow.max_shots
			break

/obj/item/ego_weapon/ranged/pistol/solemnvow/before_firing(atom/target, mob/user)
	projectile_damage_multiplier = 1
	dual_wield_spread = initial(dual_wield_spread)
	var/mob/living/carbon/human/myman = user
	for(var/obj/item/ego_weapon/ranged/pistol/solemnlament/Lament in myman.held_items)
		projectile_damage_multiplier *= 1.3
		break
	var/obj/item/clothing/suit/armor/ego_gear/realization/eulogy/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Z))
		projectile_damage_multiplier *= 2

/obj/item/ego_weapon/ranged/pistol/solemnvow/melee_attack_chain(mob/user, atom/target, params)
	if (!istype(user,/mob/living/carbon/human))
		return
	var/mob/living/carbon/human/myman = user
	var/obj/item/clothing/suit/armor/ego_gear/realization/eulogy/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if (istype(Z))
		force = 18
	else
		force = 9
	. = ..()

/obj/item/ego_weapon/ranged/loyalty
	name = "忠诚心"
	desc = "由第16EGO步枪旅提供."
	icon_state = "loyalty"
	inhand_icon_state = "loyalty"
	force = 24
	projectile_path = /obj/projectile/ego_bullet/ego_loyalty
	weapon_weight = WEAPON_HEAVY
	spread = 26
	max_shots = 75
	reloadtime = 3 SECONDS
	special = "这把武器的子弹具有敌我识别功能."
	fire_sound = 'sound/weapons/gun/smg/vp70.ogg'
	autofire = 0.08 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
	)
	alternate_fire_name = "下挂榴弹发射器"
	alternate_info = "这把武器配备了下挂式榴弹发射器，发射的黄蜂手榴弹能造成大范围的高伤害与击退. \n 在下挂榴弹发射后，会自动切换回常规射击模式."
	alternate_shotsleft = 1
	alternate_pellets = 1
	alternate_reload_type = RELOADTYPE_SHARED_RELOAD
	alternate_projectile_path = /obj/projectile/ego_bullet/loyalty_ugl
	alternate_fire_sound = 'sound/weapons/gun/general/grenade_launch.ogg'
	alternate_fire_sound_volume = 70
	alternate_toggle_sound = 'sound/machines/click.ogg'
	alternate_toggle_sound_volume = 65
	alternate_toggle_enabled_message = span_notice("你准备好使用下挂榴弹发射器.")
	alternate_toggle_disabled_message = span_notice("你不再使用下挂榴弹发射器.")
	// Need to store this to modify the autofire after firing UGL
	var/datum/component/automatic_fire/autofire_component
	var/firing_ugl_extra_shot_delay_coeff = 10

/obj/item/ego_weapon/ranged/loyalty/Initialize(mapload)
	. = ..()
	autofire_component = GetComponent(/datum/component/automatic_fire)

/obj/item/ego_weapon/ranged/loyalty/process_chamber(mob/living/user)
	. = ..()
	if(alternate_selected)
		DisableAltfire(user, TRUE)

/obj/item/ego_weapon/ranged/loyalty/EnableAltfire(mob/user, silent = TRUE)
	. = ..()
	spread = 0
	autofire_component.autofire_shot_delay = (autofire * firing_ugl_extra_shot_delay_coeff)

/obj/item/ego_weapon/ranged/loyalty/DisableAltfire(mob/user, silent = TRUE)
	. = ..()
	spread = initial(spread)
	autofire_component.autofire_shot_delay = autofire

/obj/item/ego_weapon/ranged/pistol/soda_premium
	name = "高端苏打枪"
	desc = "由虾公司设计的经典苏打手枪的高端升级版本. 其子弹采用虾的专利技术，可将灵魂从身体中剥离."
	icon_state = "soda_premium"
	inhand_icon_state = "soda_premium"
	special = "This weapon has pinpoint accuracy."
	force = 8
	damtype = PALE_DAMAGE
	burst_size = 1
	fire_delay = 5
	max_shots = 12
	reloadtime = 0.8 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	spread = 0
	variance = 0
	dual_wield_spread = 0
	projectile_path = /obj/projectile/ego_bullet/ego_soda_premium
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
	)

/obj/item/ego_weapon/ranged/pistol/crimson
	name = "猩红创痕"
	desc = "如果我左手紧握着钢铁制成的刀刃，右手紧握着填满火药的短铳，那么这里又有什么好令我畏惧的？因为狂怒而盲目，失去理智，对杀戮果断而坚决，那也总比因为懦弱而恐惧要好太多！让我们期望这篇幼稚的童话早日结束吧."
	icon_state = "crimsonscar"
	inhand_icon_state = "crimsonscar"
	force = 9
	projectile_path = /obj/projectile/ego_bullet/ego_crimson
	weapon_weight = WEAPON_MEDIUM
	pellets = 3
	variance = 9
	randomspread = FALSE
	fire_delay = 7
	max_shots = 9
	reloadtime = 1 SECONDS
	fire_sound = 'sound/abnormalities/redhood/fire.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
	)

/obj/item/ego_weapon/ranged/ecstasy
	name = "沉醉"
	desc = "告诉那个孩子今天的小零食是他最爱的葡萄味糖果."
	icon_state = "ecstasy"
	inhand_icon_state = "ecstasy"
	special = "这把武器发射能够穿透目标的短距离气泡，但击中的目标越多，造成的伤害就越低."
	force = 16
	damtype = RED_DAMAGE
	attack_speed = 0.7
	projectile_path = /obj/projectile/ego_bullet/ego_ecstasy
	weapon_weight = WEAPON_MEDIUM
	spread = 30
	autofire = 0.08 SECONDS
	fire_sound = 'sound/weapons/ego/ecstasy.ogg'
	max_shots = 40
	ammo_on_reload = 1
	ammo_on_melee = 4
	passive_reload = 1.6 SECONDS
	reloadtime = 0.16 SECONDS
	reload_start_sound = 'sound/effects/bubbles.ogg'
	reload_text = "沉醉的口中喷吐出泡沫."
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
	)

/obj/item/ego_weapon/ranged/pistol/praetorian
	name = "禁卫军"
	desc = "她以坚定的意志，征服了一切."
	icon_state = "praetorian"
	inhand_icon_state = "praetorian"
	special = "这把武器发射敌我识别子弹，能够自动追踪最近的敌人."
	force = 9
	projectile_path = /obj/projectile/ego_bullet/ego_praetorian
	fire_sound = 'sound/weapons/gun/pistol/tp17.ogg'
	fire_delay = 5
	max_shots = 12
	reloadtime = 1 SECONDS
	fire_sound_volume = 30
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
	)

/obj/item/ego_weapon/ranged/pistol/magic_pistol
	name = "魔铳"
	desc = "魔弹的全部威力，现在聚集于更小的发射器内."
	icon_state = "magic_pistol"
	inhand_icon_state = "magic_pistol"
	special = "这把武器能穿透所有的目标，但击中的目标越多，造成的伤害就越低."
	force = 9
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_magicpistol
	fire_delay = 7
	max_shots = 7
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/abnormalities/freischutz/shoot.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/pistol/magic_pistol/before_firing(atom/target, mob/user)
	projectile_damage_multiplier = 1
	var/mob/living/carbon/human/myman = user
	var/obj/item/clothing/suit/armor/ego_gear/realization/bigiron/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Z))
		projectile_damage_multiplier *= 2
	..()

/obj/item/ego_weapon/ranged/pistol/magic_pistol/melee_attack_chain(mob/user, atom/target, params)
	if (!istype(user,/mob/living/carbon/human))
		return
	var/mob/living/carbon/human/myman = user
	var/obj/item/clothing/suit/armor/ego_gear/realization/bigiron/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if (istype(Z))
		force = 18
	else
		force = 9
	. = ..()

/obj/item/ego_weapon/ranged/pistol/laststop
	name = "最后一站"
	desc = "当列车真正到站时是不会有钟声响起的."
	icon_state = "laststop"
	inhand_icon_state = "laststop"
	force = 12
	attack_speed = 0.7
	projectile_path = /obj/projectile/ego_bullet/ego_laststop
	fire_delay = 5 SECONDS
	max_shots = 6
	ammo_on_reload = 1
	reloadtime = 1 SECONDS
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'
	reload_success_sound = 'sound/weapons/gun/revolver/load_bullet.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/ranged/intentions
	name = "好意"
	desc = "来吧，小伙子们，让他们见识见识."
	special = "这把武器侧面的灯光会随着时间推移逐渐亮起，射程、射速以及伤害也会随之增加. \n\
	但是，随着时间进一步推移，灯光也会随之暗淡下去. \n\
	没有人知道这些变化确切的到来时间."
	icon_state = "intentions"
	inhand_icon_state = "intentions"
	force = 24
	projectile_path = /obj/projectile/ego_bullet/ego_intention
	weapon_weight = WEAPON_MEDIUM
	spread = 18
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'
	autofire = 0.12 SECONDS
	max_shots = 50
	reloadtime = 2.1 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)
	/// Reference to our autofire component so we can modify the firerate.
	var/datum/component/automatic_fire/autofire_component
	/// Holds a timer until the next light change.
	var/light_progress_timer
	/// How long each light should last...
	var/light_duration = 1 MINUTES
	/// ...however, the duration of the light may be up to [this value] shorter or longer.
	var/light_duration_variance = 20 SECONDS

	var/current_light = 0
	/// Associate current light to corresponding firerate, projectile damage multiplier and spread.
	var/alist/lights_to_stats = alist(
		0 = list("autofire" = 0.12 SECONDS, "multiplier" = 1, spread = 18),
		1 = list("autofire" = 0.11 SECONDS, "multiplier" = 1, spread = 20),
		2 = list("autofire" = 0.10 SECONDS, "multiplier" = 1.1, spread = 24),
		3 = list("autofire" = 0.09 SECONDS, "multiplier" = 1.3, spread = 30),
		4 = list("autofire" = 0.08 SECONDS, "multiplier" = 1.6, spread = 38),
		)

/obj/item/ego_weapon/ranged/intentions/Initialize(mapload)
	. = ..()
	autofire_component = GetComponent(/datum/component/automatic_fire)
	// Prepare the next light switch
	var/next_lights = current_light == 4 ? (0) : (current_light + 1)
	var/next_light_time = light_duration + (rand(-light_duration_variance, light_duration_variance))
	light_progress_timer = addtimer(CALLBACK(src, PROC_REF(LightProgress), (next_lights)), next_light_time, TIMER_STOPPABLE)

/obj/item/ego_weapon/ranged/intentions/examine(mob/user)
	. = ..()
	. += span_warning("武器的侧面有<b>[current_light]盏灯</b>亮起.")

/obj/item/ego_weapon/ranged/intentions/proc/LightProgress(lights)
	if(!istype(autofire_component))
		return
	deltimer(light_progress_timer)
	if(!LAZYLEN(lights_to_stats))
		lights_to_stats = initial(lights_to_stats)

	// Remove whatever projectile damage multiplier we currently have on the gun, that is related to lights and not any external source
	projectile_damage_multiplier = 1

	// This is our new light value
	current_light = lights

	// Apply the new projectile damage multiplier on top of whatever we might have from EO upgrades/Faith&Promise
	projectile_damage_multiplier *= lights_to_stats[current_light]["multiplier"]

	// Set the firerate & spread to whatever is appropiate now
	autofire = lights_to_stats[current_light]["autofire"] // This shouldn't be needed but keeps things consistent
	autofire_component.autofire_shot_delay = lights_to_stats[current_light]["autofire"]
	spread = lights_to_stats[current_light]["spread"]

	// Update object sprite
	var/new_icon_state = initial(icon_state)
	if(current_light > 0)
		new_icon_state += "_[current_light]"
	icon_state = new_icon_state
	inhand_icon_state = new_icon_state

	if(istype(src.loc, /mob/living/carbon/human)) // I know this is horrifying but I sadly don't know any procs that let us pull the holder of an item.
		var/mob/living/carbon/human/holder = src.loc
		holder.regenerate_icons()

	// Play a SFX and alert people that this thing changed
	if(current_light == 0)
		playsound(src, 'sound/abnormalities/clock/end.ogg', 50, 0)
		audible_message(span_notice("[src]上的灯光熄灭了."))
	else
		playsound(src, 'sound/abnormalities/clock/turn_on.ogg', 50, 0)
		audible_message(span_notice("[src]上亮起了一盏新的灯."))

	// Prepare the next light switch
	var/next_lights = current_light == 4 ? (0) : (current_light + 1)
	var/next_light_time = light_duration + (rand(-light_duration_variance, light_duration_variance))
	light_progress_timer = addtimer(CALLBACK(src, PROC_REF(LightProgress), (next_lights)), next_light_time, TIMER_STOPPABLE)

/obj/item/ego_weapon/ranged/crossbow/aroma
	name = "余香"
	desc = "尽管已经对这把E.G.O武器的原型进行了数次处理，却依然不能掩盖它原有的香气. 仅仅只是抱着它，你便会感觉自己像是站立在一片未知的森林中一般 \
			箭头并不锋利，它所触及之处皆会有灿烂纷繁的花朵绽放. 或许，当每个人内心的欲望都被花朵取代后，就不再需要这把武器了吧？"
	icon_state = "aroma"
	inhand_icon_state = "aroma"
	force = 24
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_aroma
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)

/obj/item/ego_weapon/ranged/accord
	name = "相和"
	desc = "然而，存在于这世界上的不只是温暖与光明. 天穹依傍土地存在，黑暗依傍光明，生命依傍死亡，希望也与绝望共存."
	icon_state = "accord"
	inhand_icon_state = "accord"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	special = "这把武器命中敌人时会治疗附近‘不和’EGO武器使用者的HP."
	force = 24
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/accord
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	chargetime = 10
	spread = 0
	fire_sound = 'sound/weapons/bowfire.ogg'
	charge_sound = 'sound/weapons/bowdraw.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)

/obj/item/ego_weapon/ranged/accord/OnDischarge(mob/living/user)
	icon_state = "accord"

/obj/item/ego_weapon/ranged/accord/ChargeUp(mob/living/user)
	is_charging = TRUE
	projectile_path = initial(projectile_path)
	fire_sound = initial(fire_sound)
	charge_hold_time = initial(charge_hold_time)
	playsound(user, charge_sound, charge_sound_volume, vary_fire_sound)
	if(do_after(user, chargetime, src))
		icon_state = "accord_drawn"
		to_chat(user,span_notice("你竭尽全力拉动[src]."))
		is_charging = FALSE
		charged = TRUE
		OnCharged(user)
		charge_timer = addtimer(CALLBACK(src, PROC_REF(Uncharge), user), charge_hold_time, TIMER_STOPPABLE)
		return
	is_charging = FALSE
	to_chat(user, span_warning("你需要站立不动才能拉动[src]!"))


/obj/item/ego_weapon/ranged/cannon/exuviae
	name = "脱落之皮"
	desc = "这把武器的湿滑表面可能会使员工们感到恶心."
	icon_state = "exuviae"
	inhand_icon_state = "exuviae"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 36
	projectile_path = /obj/projectile/ego_bullet/ego_exuviae
	special = "命中目标时，为其添加20%的RED易伤."
	damtype = RED_DAMAGE
	chargetime = 10
	fire_delay = 40 //5 less than the Rend Armor status effect
	max_shots = 6
	reloadtime = 0.3 SECONDS
	fire_sound = 'sound/misc/moist_impact.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
	)

//Full manual bow-type E.G.O, must be loaded before firing.
/obj/item/ego_weapon/ranged/warring
	name = "英勇之羽"
	desc = "一把饰有雕花木纹的熠熠长弓，弓身电弧缭绕，噼啪作响."
	icon_state = "warring"
	inhand_icon_state = "warring"
	force = 24
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_warring
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	chargetime = 10
	spread = 0
	fire_sound = 'sound/weapons/bowfire.ogg'
	charge_sound = 'sound/weapons/bowdraw.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
	)
	charge = TRUE
	attack_charge_gain = FALSE
	charge_cost = 3
	ability_type = ABILITY_UNIQUE
	charge_effect = "释放一道闪电，命中时会击晕人类单位并恢复他们的SP，效果随着蓄力充能时间而增加."
	visible_activation = "你将释放闪电."
	cancel_activation = "你将不再释放闪电."
	failed_activation = "你试图给箭矢充能，但你的武器没有反应!"
	var/ammo_2 = /obj/projectile/ego_bullet/ego_warring2

/obj/item/ego_weapon/ranged/warring/OnDischarge(mob/living/user)
	icon_state = "warring"

/obj/item/ego_weapon/ranged/warring/ChargeUp(mob/living/user)
	is_charging = TRUE
	projectile_path = initial(projectile_path)
	fire_sound = initial(fire_sound)
	charge_hold_time = initial(charge_hold_time)
	playsound(user, charge_sound, charge_sound_volume, vary_fire_sound)
	if(do_after(user, chargetime, src))
		icon_state = "warring_drawn"
		to_chat(user,span_notice("你竭尽全力拉动[src]."))
		if(currently_charging)
			if(charge_amount < charge_cost)
				CancelCharge(user)
			charge_hold_time = 20
			charge_amount -= charge_cost
			fire_sound = 'sound/abnormalities/thunderbird/tbird_beam.ogg'
			projectile_path = ammo_2
			icon_state = "warring_firey"
			playsound(src, 'sound/magic/lightningshock.ogg', 50, TRUE)
		is_charging = FALSE
		charged = TRUE
		OnCharged(user)
		charge_timer = addtimer(CALLBACK(src, PROC_REF(Uncharge), user), charge_hold_time, TIMER_STOPPABLE)
		return
	is_charging = FALSE
	to_chat(user, span_warning("你需要站定不动才能拉动[src]!"))


/obj/item/ego_weapon/ranged/cannon/banquet
	name = "夜宴"
	desc = "是时候大快朵颐了！尽情享受这充满疯狂的血红色夜晚吧！"
	icon_state = "banquet"
	inhand_icon_state = "banquet"
	special = "这把武器进行近战攻击可以吸取血液， \
		内部储存的血液可以使武器在不装弹情况下射击."
	force = 36
	damtype = BLACK_DAMAGE
	attack_speed = 1.8
	projectile_path = /obj/projectile/ego_bullet/ego_banquet
	fire_delay = 20
	max_shots = 7
	reloadtime = 0.25 SECONDS
	fire_sound = 'sound/weapons/ego/cannon.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
	)
	var/bloodshot_ready = TRUE

//A slightly different version to show Bloodfeast
/obj/item/ego_weapon/ranged/cannon/banquet/UpdateAmmoCounter()
	if(!(item_flags & IN_INVENTORY))
		maptext = ""
		return
	var/datum/component/bloodfeast/bloodfeast = GetComponent(/datum/component/bloodfeast)
	var/main_color = "white"
	if(charged)
		main_color = "blue"
	if(!shotsleft)
		main_color = "red"
	var/style = "font-family: 'Better VCR'; font-size: [text_size]px; -dm-text-outline: 1px black; color: [main_color];"
	var/blood_color = "#880000"
	if(!shotsleft && charged)
		blood_color = "red"
	if(bloodfeast.blood_amount < 150)
		blood_color = "gray"
	var/blood_style = "font-family: 'Better VCR'; font-size: [text_size]px; -dm-text-outline: 1px black; color: [blood_color];"
	maptext = MAPTEXT("<span style=\"[style]\">[shotsleft]/[max_shots]</span>\n<span style=\"[blood_style]\">B:[floor((bloodfeast.blood_amount/bloodfeast.blood_cap) * 100)]%</span>")

/obj/item/ego_weapon/ranged/cannon/banquet/Initialize()
	. = ..()
	AddComponent(/datum/component/bloodfeast, siphon = TRUE, range = 2, starting = 150, threshold = 1500, max_amount = 1500)

/obj/item/ego_weapon/ranged/cannon/banquet/examine(mob/user)
	. = ..()
	var/datum/component/bloodfeast/bloodfeast = GetComponent(/datum/component/bloodfeast)
	if(bloodfeast) // dont want to succ blood while contained
		. += "它储存有 [bloodfeast.blood_amount] 单位血液."

/obj/item/ego_weapon/ranged/cannon/banquet/proc/AdjustThirst(blood_amount)
	var/datum/component/bloodfeast/bloodfeast = GetComponent(/datum/component/bloodfeast)
	bloodfeast.AdjustBlood(blood_amount)
	if(bloodfeast.blood_amount >= 150)
		bloodshot_ready = TRUE
		return
	bloodshot_ready = FALSE

/obj/item/ego_weapon/ranged/cannon/banquet/attack(mob/living/target, mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		var/justicemod = get_attack_multiplier(user)
		AdjustThirst(force * justicemod)
		UpdateAmmoCounter()

/obj/item/ego_weapon/ranged/cannon/banquet/can_shoot(mob/living/user)
	if(bloodshot_ready)
		return TRUE
	..()

/obj/item/ego_weapon/ranged/cannon/banquet/process_chamber(mob/living/user)
	if(bloodshot_ready && !shotsleft)
		AdjustThirst(-150)
	..()

/obj/item/ego_weapon/ranged/blind_rage
	name = "盲射"
	desc = "因一时冲动和恶语相向而带来的伤痛，远比人们想象中更为持久."
	icon_state = "blind_gun"
	special = "This weapon fires burning bullets. Watch out for friendly fire!"
	projectile_path = /obj/projectile/ego_bullet/ego_blind_rage
	force = 24
	damtype = BLACK_DAMAGE
	weapon_weight = WEAPON_HEAVY
	pellets = 4
	variance = 20
	randomspread = FALSE
	fire_delay = 8
	max_shots = 8
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/ranged/my_own_bride
	name = "我的挚爱"
	desc = "仅仅携带它，便恍若立于森林深处. \
			箭头虽钝，可凡其所触之处，皆会萌发出姹紫嫣红的繁花."
	icon_state = "wife"
	inhand_icon_state = "wife"
	force = 24
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_bride
	weapon_weight = WEAPON_MEDIUM
	fire_delay = 5
	max_shots = 10
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/weapons/gun/rifle/leveraction.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
	)


/obj/item/ego_weapon/ranged/pistol/innocence
	name = "童年的回忆"
	desc = "如果没有人来接我，我会一直待在那个房间里，甚至不会察觉时间的流逝."
	icon_state = "innocence_gun"
	inhand_icon_state = "innocence_gun"
	force = 9
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_innocence
	fire_sound = 'sound/abnormalities/orangetree/ding.ogg'
	vary_fire_sound = TRUE
	autofire = 0.2 SECONDS
	max_shots = 32
	reloadtime = 2.1 SECONDS
	fire_sound_volume = 20
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)

/obj/item/ego_weapon/ranged/crossbow/hypocrisy
	name = "伪善"
	desc = "这棵树原来充斥着虚伪和欺骗；那些佩戴其祝福的人，无不以勇敢和信仰之名行事."
	icon_state = "hypocrisy"
	inhand_icon_state = "hypocrisy"
	worn_icon_state = "hypocrisy"
	special = "鼠标中键或Alt单击来放置一个陷阱，该陷阱会造成红色伤害，并在触发时提醒使用者."
	force = 24
	damtype = RED_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_hypocrisy
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
	)
	var/trap_cooldown = 0

/obj/item/ego_weapon/ranged/crossbow/hypocrisy/AltClick(mob/living/carbon/user)
	if(locate(/obj/structure/liars_trap) in range(1, get_turf(src)))
		to_chat(user,span_notice("距离另一个陷阱太近了."))
		return
	to_chat(user,span_notice("你拔出一支箭，将其刺入地面."))
	playsound(src, 'sound/items/crowbar.ogg', 50, TRUE)
	if(do_after(user, 3 SECONDS, src))
		if(trap_cooldown >= world.time)
			to_chat(user,span_notice("你目前还无法放置幼苗陷阱."))
			return
		playsound(get_turf(user), 'sound/creatures/venus_trap_hurt.ogg', 50, TRUE)
		var/obj/structure/liars_trap/c = new(get_turf(user))
		c.multiplier = get_attack_multiplier(user) * force_multiplier * projectile_damage_multiplier
		c.creator = user
		c.faction = user.faction.Copy()
		trap_cooldown = world.time + (10 SECONDS)

//Parasite Tree Ego Weapon Trap
/obj/structure/liars_trap
	gender = PLURAL
	name = "幼苗陷阱"
	desc = "一颗看起来无害的小树苗，它的叶子似乎永远不会枯萎."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "liars_trap"
	anchored = TRUE
	density = FALSE
	resistance_flags = FLAMMABLE
	max_integrity = 15
	var/mob/living/carbon/human/creator
	var/list/faction = list()
	var/damage = 30
	var/multiplier = 1

/obj/structure/liars_trap/Initialize()
	. = ..()
	if(creator)
		faction = creator.faction.Copy()

/obj/structure/liars_trap/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		var/mob/living/L = AM
		if(!faction_check(faction, L.faction))
			playsound(get_turf(src), 'sound/machines/clockcult/steam_whoosh.ogg', 10, 1)
			L.apply_damage(damage * multiplier, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = FALSE)
			new /obj/effect/temp_visual/cloud_swirl(get_turf(L)) //placeholder
			to_chat(creator, span_warning("你朝向[get_area(L)]的身体有瘙痒感."))
			qdel(src)

/obj/item/ego_weapon/ranged/fellbullet
	name = "凶弹"
	desc = "一把由李-艾因菲尔德制造的栓动步枪，发射诅咒子弹."
	icon_state = "fell_bullet"
	inhand_icon_state = "fell_bullet"
	special = "这把武器会穿透所有目标. \
		使用鼠标中键或ALT单击以创建传送门，向传送门内射击可造成双倍伤害，但代价是射速降低."
	force = 24
	damtype = RED_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_fellbullet
	weapon_weight = WEAPON_HEAVY
	fire_delay = 15
	max_shots = 10
	reloadtime = 2 SECONDS
	fire_sound = 'sound/abnormalities/fluchschutze/fell_bullet.ogg'
	reload_success_sound = 'sound/abnormalities/fluchschutze/fell_aim.ogg'
	var/portaling = FALSE
	var/shooting = FALSE
	var/portal_cooldown
	var/portal_cooldown_time = 15 SECONDS
	var/obj/effect/portal/myportal
	var/obj/effect/portal/targetportal

	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/ranged/fellbullet/afterattack(atom/target, mob/living/user, flag, params)
	if(!CanUseEgo(user))
		return
	if(semicd)//stops firing speed anomalies
		return
	if(portaling)
		portaling = FALSE
		if(!LAZYLEN(get_path_to(src,target, TYPE_PROC_REF(/turf, Distance), 0, 24)))
			to_chat(user, span_notice("目标不可达."))
			return
		var/obj/effect/portal/fellbullet/P1 = new(user)
		var/obj/effect/portal/fellbullet/P2 = new(get_turf(target))
		P1.link_portal(P2)
		P2.link_portal(P1)
		playsound(src, 'sound/abnormalities/fluchschutze/fell_magic.ogg', 50, TRUE)
		portal_cooldown = world.time + portal_cooldown_time
		myportal = P1
		targetportal = P2
		AdjustCircle(user, P1, target)
		AdjustCircle(user, P2, target)
		return
	if(!myportal)//If myportal hasn't initialized yet, this prevents it from runtiming.
		return ..()
	if(myportal in user)//is it not qdeleted?
		if(shooting)
			return
		AdjustCircle(user, myportal, target)
		myportal.forceMove(get_turf(user))//move the portal to your turf, line 733 removes it later.
		playsound(src, 'sound/abnormalities/fluchschutze/fell_portal.ogg', 50, FALSE)
		shooting = TRUE
		if(do_after(user, 5, src)) //gotta wait
			. = ..()
		if(myportal.loc && !is_reloading)//hide the portal
			AdjustCircle(user, targetportal, target)
			myportal.forceMove(user)
		shooting = FALSE
		return
	. = ..()

/obj/item/ego_weapon/ranged/fellbullet/MiddleClickAction(atom/target, mob/user)
	if(portaling)
		portaling = FALSE
		to_chat(user,span_notice("你不再创建传送门."))
		return
	if(portal_cooldown > world.time)
		to_chat(user,span_warning("你暂时无法创建传送门!"))
		return
	portaling = TRUE
	to_chat(user,span_notice("你将在目标位置创建传送门."))
	return ..()

/obj/item/ego_weapon/ranged/fellbullet/proc/AdjustCircle(mob/living/user, atom/theportal, atom/target)
	theportal.transform = initial(theportal.transform)
	theportal.layer = initial(theportal.layer)
	var/matrix/M = matrix(theportal.transform)
	var/turf/T = get_turf(user)
	var/rot_angle = Get_Angle(T, get_turf(target))
	M.Turn(rot_angle)
	switch(user.dir)
		if(EAST)
			M.Scale(0.5, 1)
			M.Translate(12, 0)
		if(WEST)
			M.Scale(0.5, 1)
			M.Translate(-16, 0)
		if(NORTH)
			M.Translate(0, 8)
			myportal.layer -= 0.2
	theportal.transform = M

/obj/effect/portal/fellbullet
	name = "魔法传送门"
	desc = "带有六芒星的红色魔法阵 "
	icon = 'icons/effects/effects.dmi'
	icon_state = "fellcircle"
	teleport_channel = TELEPORT_CHANNEL_FREE
	layer = ABOVE_MOB_LAYER

/obj/effect/portal/fellbullet/teleport(atom/movable/M, force = FALSE)
	if(!istype(M, /obj/projectile/ego_bullet/ego_fellbullet))
		return
	var/obj/projectile/ego_bullet/ego_fellbullet/B = M
	if(B.damage > 36)
		return
	B.damage *= 2
	B.ff_multiplier *= 0.5
	var/turf/real_target = get_link_target_turf()
	for(var/obj/effect/portal/fellbullet/P in real_target)
		playsound(P, 'sound/abnormalities/fluchschutze/fell_portal.ogg', 50, TRUE)
		playsound(P, 'sound/abnormalities/fluchschutze/fell_bullet2.ogg', 50, TRUE)
	..()

/obj/effect/portal/fellbullet/attack_hand(mob/user)
//the parent behavior will pull you towards it

/obj/effect/portal/fellbullet/Initialize()
	INVOKE_ASYNC(src, PROC_REF(DoAnimation))//60% uptime
	return ..()

/obj/effect/portal/fellbullet/proc/DoAnimation()
	sleep(10 SECONDS)
	animate(src, alpha = 0, time = 1 SECONDS)
	QDEL_IN(src, 1 SECONDS)

/obj/item/ego_weapon/ranged/fellscatter
	name = "凶铳"
	desc = "装有加宽枪管的栓动步枪，发射诅咒子弹."
	icon_state = "fell_scatter"
	inhand_icon_state = "fell_scatter"
	force = 24
	damtype = RED_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_fellscatter
	weapon_weight = WEAPON_HEAVY
	pellets = 7
	variance = 30
	randomspread = FALSE
	fire_delay = 15
	max_shots = 4
	ammo_on_reload = 1
	reloadtime = 0.5 SECONDS
	fire_sound = 'sound/abnormalities/fluchschutze/fell_scatter.ogg'
	reload_success_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'
	round_text = "你开始填装弹药."
	alternate_reload_time = 2 SECONDS
	alternate_fire_name = "目标凶杀"
	alternate_projectile_path = /obj/projectile/ego_bullet/special_fellbullet
	alternate_info = "这把武器将发射魔法弹丸. \
	弹丸能穿透大多数目标，命中人类只会造成一半伤害并产生特殊效果."
	alternate_fire_sound = 'sound/abnormalities/fluchschutze/fell_bullet.ogg'
	alternate_pellets = 1
	alternate_variance  = 0
	alternate_toggle_sound = 'sound/abnormalities/fluchschutze/fell_aim.ogg'
	alternate_toggle_sound_volume = 50
	alternate_toggle_enabled_message = span_notice("你现在将发射魔法弹丸.")
	alternate_toggle_disabled_message = span_notice("你将不再发射魔法弹丸.")
	alternate_reload_type = RELOADTYPE_EMPTY_MAG
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/ranged/fellscatter/EnableAltfire(mob/user, silent = TRUE)
	. = ..()
	max_shots = 1
	round_text = "你开始填装弹丸."
	variance = 0
	UpdateAmmoCounter()

/obj/item/ego_weapon/ranged/fellscatter/DisableAltfire(mob/user, silent = TRUE)
	. = ..()
	max_shots = initial(max_shots)
	round_text = initial(round_text)
	variance = initial(variance)
	UpdateAmmoCounter()

/obj/item/ego_weapon/ranged/sodashotty
	name = "苏打霰弹"
	desc = "显然是虾公司使用的枪."
	special = "这把武器发射固定范围的子弹."
	icon_state = "sodashotgun"
	inhand_icon_state = "sodashotgun"
	force = 24
	projectile_path = /obj/projectile/ego_bullet/soda_shotty
	pellets = 8
	variance = 16
	randomspread = FALSE
	pellets = 6
	max_shots = 12
	reloadtime = 0.3 SECONDS
	ammo_on_reload = 1
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10
	fire_sound = 'sound/weapons/gun/shotgun/shot.ogg'
	round_text = "You start loading a shell."
	reload_success_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							)

/obj/item/ego_weapon/ranged/sodasmg
	name = "苏打自动机关枪"
	desc = "显然是虾公司使用的枪."
	icon_state = "sodasmg"
	inhand_icon_state = "sodasmg"
	force = 24
	projectile_path = /obj/projectile/ego_bullet/soda_smg
	weapon_weight = WEAPON_MEDIUM
	spread = 8
	max_shots = 40
	reloadtime = 1.7 SECONDS
	fire_sound = 'sound/weapons/gun/smg/shot.ogg'
	autofire = 0.15 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							)

/obj/item/ego_weapon/ranged/sodaminigun
	name = "苏打机枪"
	desc = "显然是虾公司使用的枪."
	icon_state = "sodaminigun"
	inhand_icon_state = "sodaminigun"
	force = 34
	attack_speed = 1.8
	projectile_path = /obj/projectile/ego_bullet/soda_mini
	weapon_weight = WEAPON_HEAVY
	drag_slowdown = 3
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							)
	slowdown = 2
	spread = 24
	max_shots = 800
	reloadtime = 6 SECONDS
	item_flags = SLOWS_WHILE_IN_HAND
	fire_sound = 'sound/weapons/gun/smg/shot.ogg'
	burst_size = 4
	autofire = 0.05 SECONDS

/obj/item/ego_weapon/ranged/sodaassault
	name = "苏打突击步枪"
	desc = "显然是虾公司使用的枪."
	icon_state = "sodaassault"
	inhand_icon_state = "sodaassault"
	force = 24
	projectile_path = /obj/projectile/ego_bullet/soda_assault
	weapon_weight = WEAPON_HEAVY
	burst_size = 3
	burst_delay = 6
	autofire = 0.8 SECONDS
	max_shots = 51
	reloadtime = 1.5 SECONDS
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							)

/obj/item/ego_weapon/ranged/ebony_stem
	name = "黑檀枝干"
	desc = "苹果的圆满不在红透枝头之际， \
	而在皱缩干枯、引来虫蚁低微之物时."
	special = "这把武器会在指定区域生成带刺的根茎，而不是直接射击."
	icon_state = "ebony_stem"
	force = 18
	attack_speed = 1
	projectile_path = /obj/projectile/ego_bullet // We need something to avoid runtimes
	damtype = BLACK_DAMAGE
	swingstyle = WEAPONSWING_THRUST
	attack_verb_continuous = list("admonishes", "rectifies", "conquers")
	attack_verb_simple = list("admonish", "rectify", "conquer")
	hitsound = 'sound/weapons/ego/rapier2.ogg'
	weapon_weight = WEAPON_MEDIUM
	fire_delay = 12
	max_shots = 12
	ammo_on_reload = 1
	passive_reload = 2.5 SECONDS
	reloadtime = 0.2 SECONDS
	chargetime = 5
	charge_sound = 'sound/creatures/venus_trap_hurt.ogg'
	reload_start_sound = 'sound/creatures/venus_trap_hit.ogg'
	reload_text = "The weapon starts to recharge its mana."
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	alternate_fire_name = "蔓生根"
	alternate_info = "这把武器会从使用者处发出一道贴地生长的蔓生根，多次击中同一目标会逐渐降低伤害. "
	alternate_reload_type = RELOADTYPE_SHARED_MAGAZINE
	alternate_toggle_sound = 'sound/creatures/venus_trap_hurt.ogg'
	alternate_toggle_sound_volume = 65
	alternate_toggle_enabled_message = span_notice("你集中能量，现在将释放蔓生根.")
	alternate_toggle_disabled_message = span_notice("你释放能量，现在将不再释放蔓生根.")
	var/ranged_damage = 50

/obj/item/ego_weapon/ranged/ebony_stem/GunAttackInfo()
	var/damage_type = damtype
	var/base_damage = ranged_damage
	if(alternate_selected)
		base_damage = 40
	var/damage = round(base_damage * force_multiplier * projectile_damage_multiplier, 0.1)
	if(GLOB.damage_type_shuffler?.is_enabled && IsColorDamageType(damage_type))
		var/datum/damage_type_shuffler/shuffler = GLOB.damage_type_shuffler
		var/new_damage_type = shuffler.mapping_offense[damage_type]
		damage_type = new_damage_type
	return span_notice("它的根造成 [damage] [damage_type] 伤害.[force_multiplier != 1 ? " (+ [(force_multiplier - 1) * 100]%)" : ""]")

/obj/item/ego_weapon/ranged/ebony_stem/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
	if(!CanUseEgo(user))
		return

	if(HAS_TRAIT(user, TRAIT_PACIFISM) && lethal) // If the user has the pacifist trait, then they won't be able to fire [src] if the [lethal] var is TRUE.
		to_chat(user, span_warning("[src]是致命性的! 你不想伤害任何人..."))
		return

	if(user)
		SEND_SIGNAL(user, COMSIG_MOB_FIRED_GUN, src, target, params, zone_override)

	SEND_SIGNAL(src, COMSIG_GUN_FIRED, user, target, params, zone_override)

	add_fingerprint(user)

	if(semicd)
		return
	if(!alternate_selected)
		DoAOE(user, target)
	else
		var/obj/effect/rootline/R = new(get_step_towards(user, target), user.faction)
		R.damage *= force_multiplier * get_attack_multiplier(user)
		R.rootBarrage(target)
	process_chamber(user)
	semicd = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset_semicd)), fire_delay)

	if(user)
		user.update_inv_hands()
	SSblackbox.record_feedback("tally", "gun_fired", 1, type)

	if(click_cooldown_override)
		user.changeNext_move(click_cooldown_override)
	else
		user.changeNext_move(CLICK_CD_RANGE)
	user.newtonian_move(get_dir(target, user))

	return TRUE

/obj/item/ego_weapon/ranged/ebony_stem/proc/DoAOE(mob/living/user, mob/living/target)
	var/turf/target_turf = get_turf(target)
	var/damage_dealt = ranged_damage * force_multiplier * get_attack_multiplier(user)
	playsound(target_turf, 'sound/abnormalities/ebonyqueen/attack.ogg', 50, TRUE)
	for(var/turf/open/T in RANGE_TURFS(1, target_turf))
		new /obj/effect/temp_visual/thornspike(T)
		user.HurtInTurf(T, list(), damage_dealt, BLACK_DAMAGE, hurt_mechs = TRUE, check_faction = TRUE)


/obj/effect/rootline
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	var/damage = 40
	var/list/faction = list()
	var/barrage_range = 12
	var/broken = 0
	var/hit_list = list()
	layer = POINT_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/rootline/New(loc, ...)
	. = ..()
	if(args[2])
		faction = args[2]

/obj/effect/rootline/Destroy()
	. = ..()
	QDEL_NULL(hit_list)
	QDEL_NULL(hit_list)

/obj/effect/rootline/proc/rootBarrage(atom/attack_target) //line attack
	var/turf/target_turf = get_ranged_target_turf_direct(src, attack_target, barrage_range)
	var/count = 0
	for(var/turf/T in getline(get_turf(src), target_turf))
		if(T.density)
			broken = count
			break
		count = count + 1
		addtimer(CALLBACK(src, PROC_REF(stabHit), T, count), (3 * (((count-1)*0.50)+1)) + 0.25 SECONDS)

/obj/effect/rootline/proc/stabHit(turf/T, count)
	if(QDELETED(src))
		return
	playsound(T, 'sound/abnormalities/ebonyqueen/attack.ogg', 50, TRUE)
	new /obj/effect/temp_visual/thornspike(T)
	for(var/mob/living/L in T)
		if(faction_check(faction, L.faction, FALSE))
			continue
		if(!(L in hit_list))
			hit_list[L] = 1
		else
			hit_list[L] = min(4, hit_list[L] + 0.5) // 66% damage then 50% ect to 25%
		var/damage_done = damage/hit_list[L]
		L.deal_damage(damage_done, BLACK_DAMAGE)
	if(count == barrage_range || count == broken)
		qdel(src)
