//ZAYIN E.G.O. Support abilities - use this subtype to reduce some copy-paste
/obj/item/ego_weapon/support
	special = "在手中使用该武器将发动特殊技能."
	var/ability_cooldown
	var/ability_cooldown_time = 10 SECONDS
	var/pulse_delay = 1 SECONDS
	var/pulse_enabled = FALSE
	var/pulse_enable_toggle = FALSE
	var/matching_armor
	var/use_message
	var/use_sound

/obj/item/ego_weapon/support/attack_self(mob/user)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	if(ability_cooldown > world.time)
		to_chat(H, span_warning("你刚刚才使用过!"))
		return FALSE
	var/obj/item/clothing/suit/armor/ego_gear/zayin/P = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(P, matching_armor))
		pulse_enabled = TRUE
		ability_cooldown = world.time + ability_cooldown_time
		to_chat(H, span_nicegreen("[use_message]"))
		H.playsound_local(get_turf(H), use_sound, 25, 0)
		Pulse(user, 0)
		return TRUE
	else
		if(pulse_enable_toggle)
			pulse_enabled = FALSE
		to_chat(H, span_warning("你必须装备相应的护甲才能使用技能!"))
		return FALSE

/obj/item/ego_weapon/support/dropped(mob/user)
	. = ..()
	if(pulse_enable_toggle)
		pulse_enabled = FALSE

/obj/item/ego_weapon/support/Destroy(mob/user)
	. = ..()
	if(pulse_enable_toggle)
		pulse_enabled = FALSE

/obj/item/ego_weapon/support/proc/Pulse(mob/living/carbon/human/user, count)
	if(!pulse_enabled && pulse_enable_toggle)
		return
	if(count >= 10)
		return
	addtimer(CALLBACK(src, PROC_REF(Pulse), user, count += 1), pulse_delay)

/obj/item/ego_weapon/support/penitence
	name = "赎罪"
	desc = "A mace meant to purify the evil thoughts."
	special = "装备此武器并穿戴对应护甲时，可为附近角色恢复 SP 值."
	icon_state = "penitence"
	force = 6
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("smacks", "strikes", "beats")
	attack_verb_simple = list("smack", "strike", "beat")
	matching_armor = /obj/item/clothing/suit/armor/ego_gear/zayin/penitence
	pulse_enable_toggle = TRUE
	use_message = "你使用赎罪提供精神治愈!"
	use_sound = "sound/abnormalities/onesin/bless.ogg"
	var/pulse_healing = -0.5

/obj/item/ego_weapon/support/penitence/Pulse(mob/living/carbon/human/user, count)
	..()
	for(var/mob/living/carbon/human/L in livinginview(4, user))
		if(L.stat == DEAD || L == user || L.is_working) //no self-healing
			continue
		L.adjustSanityLoss(pulse_healing)
		to_chat(L, span_nicegreen("[user]发出了让你感到头脑清醒的精神波."))

/obj/item/ego_weapon/support/little_alice
	name = "小爱丽丝"
	desc = "You, now in wonderland!"
	special = "装备此武器并穿戴对应护甲时，可为附近角色创造食物."
	icon_state = "little_alice"
	force = 6
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slices", "slashes", "stabs")
	hitsound = 'sound/weapons/bladeslice.ogg'
	matching_armor = /obj/item/clothing/suit/armor/ego_gear/zayin/little_alice
	use_message = "你使用小爱丽丝分享零食!"
	use_sound = "sound/items/eatfood.ogg"
	ability_cooldown_time = 60 SECONDS

/obj/item/ego_weapon/support/little_alice/Pulse(mob/living/carbon/human/user)
	var/list/foodoptions = list(/obj/item/food/cookie, /obj/item/food/cookie/sugar/pbird)
	for(var/mob/living/carbon/human/L in livinginview(5, user))
		if((!ishuman(L)) || L.stat == DEAD || L == user)
			continue
		if(L.nutrition > NUTRITION_LEVEL_WELL_FED)
			continue
		to_chat(L, span_warning("[user]给了你一点零食!"))
		var/gift = pick(foodoptions)
		new gift(get_turf(L))

/obj/item/ego_weapon/support/wingbeat
	name = "翅振"
	desc = "If NAME can show that they are competent, then they may be able to draw 精灵盛宴’s attention.."
	icon_state = "wingbeat"
	special = "装备此武器并穿戴对应护甲时，可为附近角色恢复生命."
	force = 6
	damtype = RED_DAMAGE
	attack_verb_continuous = list("smacks", "strikes", "beats")
	attack_verb_simple = list("smack", "strike", "beat")
	matching_armor = /obj/item/clothing/suit/armor/ego_gear/zayin/wingbeat
	pulse_enable_toggle = TRUE
	use_message = "You use wingbeat to emit healing pulses!"
	use_sound = "sound/abnormalities/fairyfestival/fairylaugh.ogg"
	var/pulse_healing = -0.5

/obj/item/ego_weapon/support/wingbeat/Pulse(mob/living/carbon/human/user, count)
	..()
	for(var/mob/living/carbon/human/L in livinginview(4, user))
		if(L.stat == DEAD || L == user || L.is_working) //no self-healing
			continue
		L.adjustBruteLoss(pulse_healing)
		to_chat(L, span_nicegreen("来自[user]身上小精灵在治愈你的伤口."))

/obj/item/ego_weapon/support/wingbeat/suicide_act(mob/living/carbon/user)
	. = ..()
	user.visible_message(span_suicide("[user]对周围精灵大喊大叫，表示自己再也不会和精灵玩了! 这是自杀行为!"))
	playsound(user, 'sound/abnormalities/fairyfestival/fairy_festival_bite.ogg', 50, TRUE, -1)
	user.unequip_everything()
	user.dust()
	return MANUAL_SUICIDE

/obj/item/ego_weapon/change
	name = "改变"
	desc = "A hammer made with the desire to change anything"
	special = "装备此武器并穿戴对应护甲时，攻击其他角色可以恢复对方HP."
	icon_state = "change"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 6
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")

/obj/item/ego_weapon/change/attack(mob/living/M, mob/living/user)
	if(!ishuman(M) || M == user || !user.faction_check_mob(M) || (user.a_intent != INTENT_HELP))
		..()
		return
	var/obj/item/clothing/suit/armor/ego_gear/zayin/change/C = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(C))
		..()
		return
	var/mob/living/carbon/human/HT = M
	if(HT.is_working)
		to_chat(user,span_notice("你不能帮助别人应付工作!"))
		return
	playsound(get_turf(user), 'sound/abnormalities/change/change_end.ogg', 25, 0, -9)
	HT.visible_message(span_nicegreen("[HT] is patched up with [src] by [user]!"))
	HT.adjustBruteLoss(-10)
	user.changeNext_move(CLICK_CD_MELEE * 3)

/obj/item/ego_weapon/support/doze
	name = "瞌睡"
	desc = "Knock the daylights out of 'em!"
	special = "装备此武器并穿戴对应护甲时，使用可以自己短暂沉睡为代价为附近的角色恢复HP和SP."
	icon_state = "doze"
	force = 6
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	hitsound = 'sound/abnormalities/happyteddy/teddy_guard.ogg'
	matching_armor = /obj/item/clothing/suit/armor/ego_gear/zayin/doze
	use_message = "你使用瞌睡发出治愈能量! 但同时也让你倒下了!"
	use_sound = "sound/abnormalities/happyteddy/teddy_lullaby.ogg"
	var/pulse_healing = -2

/obj/item/ego_weapon/support/doze/attack_self(mob/user) //using it puts you to sleep
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = user
	H.Stun(10 SECONDS)
	H.Knockdown(1)

/obj/item/ego_weapon/support/doze/Pulse(mob/living/carbon/human/user, count)
	..()
	for(var/mob/living/carbon/human/L in livinginview(4, user))
		if(L.stat == DEAD || L == user || L.is_working) //no self-healing
			continue
		L.adjustSanityLoss(pulse_healing)
		L.adjustBruteLoss(pulse_healing)
		to_chat(L, span_nicegreen("你感到来自[user]的一阵暖意!"))

/obj/item/ego_weapon/support/evening
	name = "暮光"
	desc = "I accepted the offer and paid the price."
	special = "当你穿着与之匹配的盔甲时，在你的手上使用这个武器，为附近的其他人产生微弱的青色护盾."
	icon_state = "evening"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 5
	damtype = PALE_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	matching_armor = /obj/item/clothing/suit/armor/ego_gear/zayin/evening
	use_message = "你使用暮光产生青色护盾!"
	use_sound = "sound/abnormalities/lighthammer/chain.ogg"

/obj/item/ego_weapon/support/evening/Pulse(mob/living/carbon/human/user, count)
	..()
	for(var/mob/living/carbon/human/L in livinginview(4, user))
		if(L.stat == DEAD || L == user || L.is_working) //no self-healing
			continue
		L.apply_status_effect(/datum/status_effect/evening)

/datum/status_effect/evening
	id = "evening twilight"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 3 SECONDS
	alert_type = null

/datum/status_effect/evening/on_apply()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	to_chat(H, span_nicegreen("一道护盾增强了你对青色伤害的抗性!"))
	H.physiology.pale_mod /= 1.1
	return ..()

/datum/status_effect/evening/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	to_chat(H, span_warning("你的护盾失效了."))
	H.physiology.pale_mod *= 1.1
	return ..()


/obj/item/ego_weapon/cavernous_wailing
	name = "低泣"
	desc = "Cry with me..."
	special = "装备此武器并穿戴对应护甲时，攻击其他角色可以恢复对方HP和SP."
	icon_state = "cavernous_wailing"
	force = 6
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	hitsound = 'sound/abnormalities/blubbering_toad/attack.ogg'

/obj/item/ego_weapon/cavernous_wailing/attack(mob/living/M, mob/living/user)
	if(!ishuman(M) || M == user || !user.faction_check_mob(M) || (user.a_intent != INTENT_HELP))
		..()
		return
	var/obj/item/clothing/suit/armor/ego_gear/zayin/cavernous_wailing/C = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(C))
		..()
		return
	var/mob/living/carbon/human/HT = M
	if(HT.is_working)
		to_chat(user,span_notice("你不能帮助别人应付工作!"))
		return
	playsound(get_turf(user), 'sound/abnormalities/blubbering_toad/blurble3.ogg', 25, 0, -9) //change to blubber sfx when toad is merged
	HT.visible_message(span_nicegreen("[HT]被[user]用[src]上的树脂治愈了!"))
	HT.adjustSanityLoss(-5)
	HT.adjustBruteLoss(-5)
	user.changeNext_move(CLICK_CD_MELEE * 3)

/obj/item/ego_weapon/support/letter_opener
	name = "开信刀"
	desc = "Trusty aid of a mailman."
	special = "装备此武器并穿戴对应护甲时，使用来给你指定的角色发送一封秘密邮件."
	icon_state = "letteropener"
	force = 6
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slices", "slashes", "stabs")
	hitsound = 'sound/weapons/bladeslice.ogg'
	ability_cooldown_time = 30 SECONDS
	matching_armor = /obj/item/clothing/suit/armor/ego_gear/zayin/letter_opener
	use_message = "你用开信刀发出信息!"
	use_sound = 'sound/items/handling/paper_drop.ogg'

/obj/item/ego_weapon/support/letter_opener/Pulse(mob/user)
	var/M = input(user,"你要给谁发信息?","选择某人") as null|anything in GetPlayers(user)
	if(!M)
		return
	var/msg = stripped_input(usr, "你想发送什么消息给[M]?", null, "")
	if(!msg)
		return
	to_chat(M, span_warning("[user]发给你消息!"))
	var/obj/item/paper/P = new(get_turf(M))
	P.setText(msg)
	P.icon_state = "mail"
	var/mob/living/carbon/human/H = M
	var/datum/attribute/highest_attribute = null
	for(var/datum/attribute/A in H.attributes)
		if(isnull(highest_attribute))
			highest_attribute = A
			continue
		if(A.get_level() > highest_attribute.get_level())
			highest_attribute = A
	switch(highest_attribute)
		if(/datum/attribute/fortitude)
			new /obj/item/mailpaper/instinct(get_turf(H), H)
		if(/datum/attribute/prudence)
			new /obj/item/mailpaper/insight(get_turf(H), H)
		if(/datum/attribute/temperance)
			new /obj/item/mailpaper/coupon(get_turf(H))
		if(/datum/attribute/justice) // "These two seem to be backwards?" Yes. Justice is the one stat that does basically nothing for grinding, this buffs those who want to be able to do damage AND work.
			new /obj/item/mailpaper/attachment(get_turf(H), H)
	QDEL_IN(P, 30 SECONDS)
	to_chat(user, span_boldnotice("你传递到[M]:</span> <span class='notice'>[msg]"))
	for(var/ded in GLOB.dead_mob_list)
		if(!isobserver(ded))
			continue
		var/follow_rev = FOLLOW_LINK(ded, user)
		var/follow_whispee = FOLLOW_LINK(ded, M)
		to_chat(ded, "[follow_rev] <span class='boldnotice'>[user] [name]:</span> <span class='notice'>\"[msg]\" to</span> [follow_whispee] <span class='name'>[M]</span>")

/obj/item/ego_weapon/support/letter_opener/proc/GetPlayers(mob/living/carbon/human/user)
	. = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(user == H)
			continue
		if(!isliving(H))
			continue
		. += H
	sortList(.)
	return

/obj/item/ego_weapon/sunset
	name = "猩红蛾月食"
	desc = "It's beautiful."
	icon_state = "eclipse"
	force = 6
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/ego_weapon/plastic
	name = "假笑"
	desc = "A mysterious worn-out tool used for operations."
	special = "装备此武器并穿戴对应护甲时，攻击友方人类会根据你的伤害来增加他们的正义."
	icon_state = "plastic"
	force = 6
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("smacks", "strikes", "beats")
	attack_verb_simple = list("smack", "strike", "beat")
	hitsound = 'sound/abnormalities/kqe/hitsound1.ogg'

/obj/item/ego_weapon/plastic/attack(mob/living/M, mob/living/user)
	if(!ishuman(M) || M == user || !user.faction_check_mob(M) || user.a_intent != INTENT_HELP)
		..()
		return
	var/obj/item/clothing/suit/armor/ego_gear/tools/plastic/P = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(P))
		..()
		return
	var/mob/living/carbon/human/HT = M
	if(HT.has_status_effect(/datum/status_effect/you_happy_buff))
		if(user.a_intent == INTENT_HELP)
			return
		..()
		return
	var/justicemod = get_attack_multiplier(user)
	HT.apply_status_effect(/datum/status_effect/you_happy_buff)
	var/datum/status_effect/you_happy_buff/Y = HT.has_status_effect(/datum/status_effect/you_happy_buff)
	Y.EnableBuff((force * justicemod) * force_multiplier)
	playsound(get_turf(user), 'sound/effects/light_flicker.ogg', 25, TRUE, -9)
	HT.visible_message(span_nicegreen("[HT]的正义被[user]用[src]增强了!"))
	user.changeNext_move(CLICK_CD_MELEE * 5)

/datum/status_effect/you_happy_buff
	id = "you must be happy ego buff"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 12 SECONDS
	alert_type = null
	var/buff_amount = 0

/datum/status_effect/you_happy_buff/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -buff_amount)
	return ..()

/datum/status_effect/you_happy_buff/proc/EnableBuff(amount)
	if(!ishuman(owner))
		return
	if(!amount)
		return
	buff_amount = amount
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, amount)

/*
* Ironically this shield reveals to you all the dangerous
* things around you.
*/
/obj/item/ego_weapon/shield/dead_dream
	name = "永眠梦境"
	desc = "The last thing Maria saw before entering the dream. She felt... safe."
	special = "偏转攻击后，能显示附近所有生物位置一秒."
	icon_state = "dead_dream"
	damtype = WHITE_DAMAGE
	var/glimpse_cooldown = 0
	var/glimpse_cooldown_delay = 3 SECONDS

/obj/item/ego_weapon/shield/dead_dream/attack_self(mob/user)
	. = ..()
	if(glimpse_cooldown < world.time)
		Glimpse()

//Experimental Feature, Most likely too costly for its own good.
/obj/item/ego_weapon/shield/dead_dream/proc/Glimpse()
	for(var/mob/living/carbon/human/H in view(6, get_turf(src)))
		H.apply_status_effect(/datum/status_effect/display/glimpse_thermal)
		to_chat(H, span_info("你瞥见了她的梦."))
	glimpse_cooldown = world.time + glimpse_cooldown_delay

/obj/item/ego_weapon/prohibited
	name = "不要按!!!"
	desc = "You've pressed it numerous times and you still have something you want to know about it?"
	special = "装备此武器并穿戴对应护甲时，攻击敌人可能让他们对你失去战意，但也可能激怒他们."
	icon_state = "touch"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 6
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")

/obj/item/ego_weapon/prohibited/attack(mob/living/M, mob/living/user)
	. = ..()
	if(prob(75)) //75% chance of just not working at all - this ability has the potential to be OP
		return
	if(user.faction_check_mob(M) || (!istype(M, /mob/living/simple_animal/hostile)))
		return
	var/obj/item/clothing/suit/armor/ego_gear/tools/prohibited/P = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(P))
		return
	var/mob/living/simple_animal/hostile/T = M
	if(T.target == user)
		T.LoseTarget()
		T.visible_message(span_nicegreen("[T]失去了对[user]的战意!"))

/obj/item/ego_weapon/promise
	name = "信念与承诺"
	desc = "If you make an attempt with an austere heart devoid of desire or expectation, you may receive an unexpected reward."
	icon_state = "promise"
	force = 6
	throwforce = 10
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/ego_weapon/promise/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
	if(thrownby && !caught)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, throw_at), thrownby, throw_range+2, throw_speed, null, TRUE), 1)
	if(caught)
		return
	else
		return ..()

/obj/item/ego_weapon/mirror
	name = "镜子"
	desc = "Those who face themselves in the mirror may appear the same, but in actuality, they have become completely different people."
	icon_state = "mirror"
	force = 6
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/fixer/generic/wcorp4.ogg'
