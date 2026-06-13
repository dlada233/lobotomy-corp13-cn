//ripped off of wall gazer, sorry devs
/mob/living/simple_animal/hostile/abnormality/mailpile
	name = "待回复信件"
	desc = "一堆盖了章的信件，没有一封到达收件人手中."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "mailbox"
	portrait = "pile_of_mail"
	maxHealth = 100
	health = 100
	threat_level = ZAYIN_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = list(70, 60, 50, 40, 30),
		ABNORMALITY_WORK_REPRESSION = 40,
	)

	work_damage_upper = 2
	work_damage_lower = 1
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/pride

	gift_type =  /datum/ego_gifts/mail
	gift_message = "一张邮票被送到了你的手中. 你没多想，就把它贴在了自己的脸颊上."

	max_boxes = 12

	ranged = TRUE
	ranged_cooldown_time = 3 SECONDS
	rapid = 3
	rapid_fire_delay = 8
	check_friendly_fire = FALSE
	projectiletype = /obj/projectile/mailshuriken
	projectilesound = 'sound/items/handling/paper_pickup.ogg'

	ego_list = list(
		/datum/ego_datum/weapon/letter_opener,
		/datum/ego_datum/armor/letter_opener,
	)
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	observation_prompt = "收容单元内散落着寄往各地的信件. <br>\
		偶然有信笺无风自起，好像被无形的气流托起一样. <br>\
		新一批信件从信箱涌出，一封署名予你的信飘落跟前."
	observation_choices = list(
		"拆启信件" = list(TRUE, "你拆开封缄，信纸是空白的. <br>\
			但你瞥见信封标注 \"退回寄件人\" <br>\
			将信封投回信箱时，意外发现了礼物."),
		"置之不理" = list(FALSE, "你知道异想体的把戏，不会上当. <br>你直接离开了收容单元，不会再知道信中的内容了."),
	)

	var/cooldown
	var/cooldown_time = 10 SECONDS
	var/spawned_effects = list()
	var/list/bad_mail_types = list(
		/obj/item/mailpaper/junk,
		/obj/item/mailpaper/pipebomb,
		/obj/item/mailpaper/hatred,
		/obj/item/mailpaper/trapped/flashbang,
	)

/mob/living/simple_animal/hostile/abnormality/mailpile/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/mailpile/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/mailpile/Destroy()
	for(var/obj/effect/VFX in spawned_effects)
		qdel(VFX)
	return ..()

/mob/living/simple_animal/hostile/abnormality/mailpile/Initialize(mapload)
	. = ..()

	for(var/dir in GLOB.alldirs)
		var/turf/dispense_turf = get_step(src, dir)
		var/obj/effect/letters_flow/TMP = new(dispense_turf)
		spawned_effects += TMP

//papercut due to failed work
/mob/living/simple_animal/hostile/abnormality/mailpile/WorktickFailure(mob/living/carbon/human/user)
	if(prob(10))
		to_chat(user, span_warning("哎呦! 我被纸划伤了!"))
		user.deal_damage(1, RED_DAMAGE)
	return ..()

/mob/living/simple_animal/hostile/abnormality/mailpile/proc/Delivery(mob/living/carbon/human/user, work_type, pe, work_time)
	playsound(get_turf(src), 'sound/abnormalities/mailpile/gotmail.ogg', 50, 1)
	to_chat(user, span_notice("那堆信中有一封信在空中慢慢摆动."))
	var/obj/item/mailpaper/MAIL
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			MAIL = new /obj/item/mailpaper/instinct(get_turf(src),user)
		if(ABNORMALITY_WORK_INSIGHT)
			MAIL = new /obj/item/mailpaper/insight(get_turf(src),user)
		if(ABNORMALITY_WORK_ATTACHMENT)
			MAIL = new /obj/item/mailpaper/attachment(get_turf(src),user)
		if(ABNORMALITY_WORK_REPRESSION)
			var/mailtype = pick(bad_mail_types)
			MAIL = new mailtype(get_turf(src))
	MAIL.throw_at(user, 4, 1, src, spin = FALSE, gentle = TRUE, quickstart = FALSE)
	return

/mob/living/simple_animal/hostile/abnormality/mailpile/proc/BadDelivery(mob/living/carbon/human/user, work_type, pe, work_time)
	if(cooldown > world.time)
		to_chat(user, span_warning("当信封开始从邮箱飞向你时，你意识到自己犯了一个严重的错误."))
		user.Stun(10 SECONDS)
		var/letterssave = list()
		for(var/i = 1 to 4)
			var/obj/item/mailpaper/hatred/MAIL = new(get_turf(src))
			MAIL.throw_at(user, 4, 1, src, spin = FALSE, gentle = TRUE, quickstart = FALSE)
			letterssave += MAIL
			sleep(1 SECONDS)
		user.gib()
		sleep(5 SECONDS)
		for(var/obj/item/mailpaper/MAIL in letterssave)
			qdel(MAIL)
		return
	cooldown = world.time + cooldown_time
	playsound(get_turf(src), 'sound/abnormalities/mailpile/gotmail.ogg', 50, 1)
	if(prob(25))
		var/obj/item/parcelself/PARCEL = new(get_turf(src),user)
		PARCEL.throw_at(user, 4, 1, src, spin = FALSE, gentle = TRUE, quickstart = FALSE)
	else
		var/obj/item/mailpaper/junk/MAIL = new(get_turf(src))
		MAIL.throw_at(user, 4, 1, src, spin = FALSE, gentle = TRUE, quickstart = FALSE)
	return

//players get a parcel / letters for completing works
/mob/living/simple_animal/hostile/abnormality/mailpile/FailureEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	. = ..()
	BadDelivery(user,work_type,pe)

/mob/living/simple_animal/hostile/abnormality/mailpile/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	Delivery(user,work_type,pe)
	return

/mob/living/simple_animal/hostile/abnormality/mailpile/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	Delivery(user,work_type,pe)
	return

// Pink Midnight
/mob/living/simple_animal/hostile/abnormality/mailpile/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_PINK)
		SendDeathThreat()
		return TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/mailpile/proc/SendDeathThreat()
	var/chance = 20
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		var/role = H.mind?.assigned_role
		var/weaken = FALSE
		if(isnull(role))
			continue
		if(H.stat == DEAD)
			continue
		if(!prob(chance))
			chance *= 2
			continue
		chance = 20
		if(role in list("Manager","Training Officer","Disciplinary Officer", "Extraction Officer", "Records Officer", "Sephirah"))
			weaken = TRUE
		var/threat_type = pickweight(list(
			/obj/item/mailpaper/trapped/fairies = 10,
			/obj/item/mailpaper/trapped/acid = 10,
			/obj/item/mailpaper/trapped/urgent = 6,
			/obj/item/mailpaper/trapped/flashbang = 3,
			/obj/item/mailpaper/coupon = 1,
		))
		switch(threat_type)
			if(/obj/item/mailpaper/trapped/fairies)
				var/obj/item/mailpaper/trapped/fairies/MF = new threat_type(get_turf(H))
				MF.weaken_fairy = weaken
			else
				new threat_type(get_turf(H))

// kinda bad visual effect. Someone PLEASE update this.
/obj/effect/letters_flow
	name = "storm of letters"
	desc = "The storm rages on."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "letters"
	layer = ABOVE_MOB_LAYER

// x2 workspeed buff pro 2022 free hack free robux
/datum/status_effect/workspeed_buff
	id = "workspeed_buff"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/workspeed_buff
	duration = 30 SECONDS

/datum/status_effect/workspeed_buff/on_apply()
	. = ..()
	var/mob/living/carbon/human/user = owner
	user.physiology.work_speed_mod *= 1.5

/datum/status_effect/workspeed_buff/on_remove()
	. = ..()
	var/mob/living/carbon/human/user = owner
	user.physiology.work_speed_mod /= 1.5

/atom/movable/screen/alert/status_effect/workspeed_buff
	name = "来自过去的信"
	desc = "读了这封信，你想为你过去的朋友付出更多的努力."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "mail"

/datum/status_effect/nofear_buff
	id = "nofear_buff"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/nofear_buff
	duration = 3 MINUTES

/datum/status_effect/nofear_buff/on_apply()
	. = ..()
	var/mob/living/carbon/human/user = owner
	ADD_TRAIT(user, TRAIT_WORKFEAR_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_COMBATFEAR_IMMUNE, TRAIT_GENERIC)

/datum/status_effect/nofear_buff/on_remove()
	. = ..()
	var/mob/living/carbon/human/user = owner
	REMOVE_TRAIT(user,TRAIT_WORKFEAR_IMMUNE,TRAIT_GENERIC)
	REMOVE_TRAIT(user,TRAIT_COMBATFEAR_IMMUNE,TRAIT_GENERIC)

/atom/movable/screen/alert/status_effect/nofear_buff
	name = "来自当下的信"
	desc = "读这封信使你无所畏惧."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "mail"

//yes this is ripped off of paper and mermaid gift but fuck you.
/obj/item/parcelself
	name = "从另一个自己处寄来的包裹"
	desc = "You should not see this."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "parcel"
	inhand_icon_state = "parcel"
	worn_icon_state = "parcel"
	drop_sound = 'sound/items/handling/paper_drop.ogg'
	pickup_sound =  'sound/items/handling/paper_pickup.ogg'
	gender = NEUTER
	color = "white"
	var/mob/living/carbon/receiver = null

//this is using the parcel. you either go insane or get special ego
/obj/item/parcelself/attack_self(mob/living/carbon/human/user)
	if(receiver != user)
		to_chat(user, span_notice("私自拆开他人包裹是不对的."))
		return
	if(prob(50))
		new /obj/item/ego_weapon/mail_satchel(get_turf(user))
		to_chat(user, span_nicegreen("拆解包裹时，一个邮差挎包滑落而出."))
	else
		new /obj/item/clothing/suit/armor/ego_gear/zayin/letter_opener(get_turf(user))
		to_chat(user, span_nicegreen("拆解包裹时，一套制服飘然落下."))
	qdel(src)
	return

/obj/item/parcelself/Initialize(mapload, mob/living/carbon/human/user)
	. = ..()
	desc = "这个包裹似乎寄给[user]. 它究竟从何而来..?"
	receiver = user

/obj/item/mailpaper
	name = "信件"
	desc = "那堆信中有一封信在空中慢慢摆动."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "mail"
	inhand_icon_state = "mail"
	worn_icon_state = "mail"
	drop_sound = 'sound/items/handling/paper_drop.ogg'
	pickup_sound =  'sound/items/handling/paper_pickup.ogg'
	gender = NEUTER
	color = "white"

/obj/item/mailpaper/pipebomb
	name = "可疑的信件"
	desc = "A letter with all identifying features scratched off. Sketchy."
	icon = 'icons/obj/grenade.dmi'
	icon_state = "pipebomb_gift"

/obj/item/mailpaper/pipebomb/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_warning("What is this... Is this a pipebomb!?"))
	sleep(10)
	playsound(get_turf(user), 'sound/weapons/flashbang.ogg', 30, TRUE, 8, 0.9)
	for(var/direction in GLOB.alldirs)
		var/turf/dispense_turf = get_step(src, direction)
		new /obj/effect/decal/cleanable/glitter(dispense_turf)
	qdel(src)

/obj/item/mailpaper/junk
	var/JUNKMAIL = list(
		list(
			"RobustCO来信",
			"信封标注：\"今日立享强健提升！立即拆阅！\"",
		),
		list(
			"可疑讯息",
			"渴望突破自我？今日即刻蜕变强壮！",
		),
		list(
			"虾业集团函件",
			"贵司工作场所是否完全缺乏虾类？立即致电获取免费虾咨询！",
		),
		list(
			"主管催缴通知",
			"致：Ayin<br>截至-月--日--年，经多次催告仍未收到逾期税款。<br>请于-月--日--年前结清欠款，否则将启动财产征缴（扣押）程序。",
		),
	)

/obj/item/mailpaper/junk/Initialize()
	. = ..()
	var/temp = pick(JUNKMAIL)
	name = temp[1]
	desc = temp[2]

/obj/item/mailpaper/junk/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_notice("这就是浪费时间..."))
	user.adjustSanityLoss(5)
	qdel(src)

/obj/item/mailpaper/hatred
	name = "一封匆忙写的愤怒的信"
	desc = "讨厌你讨厌你讨厌你讨厌你讨厌你讨厌你讨厌你讨厌你讨厌你讨厌你讨厌你."

/obj/item/mailpaper/hatred/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_warning("纸页上写满了涂鸦和威胁..."))
	user.adjustSanityLoss(5)
	qdel(src)

/obj/item/mailpaper/instinct

/obj/item/mailpaper/instinct/Initialize(mapload, mob/living/carbon/human/user)
	. = ..()
	desc = "一封过去的朋友写给[user]的信. 这样的行为让你感到五味杂陈，但你仍会感到欣慰."

/obj/item/mailpaper/instinct/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("读这封友好的信可以帮助你在时间的流逝中找到平静."))
	user.adjustSanityLoss(-10)
	qdel(src)

/obj/item/mailpaper/insight

/obj/item/mailpaper/insight/Initialize(mapload, mob/living/carbon/human/user)
	. = ..()
	desc = "同事给[user]的信. 让人有点怀念."

/obj/item/mailpaper/insight/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("阅读同事的来信会坚定你的决心."))
	if(!HAS_TRAIT(user,TRAIT_WORKFEAR_IMMUNE) && !HAS_TRAIT(user,TRAIT_COMBATFEAR_IMMUNE))
		user.apply_status_effect(/datum/status_effect/nofear_buff)
	qdel(src)

/obj/item/mailpaper/attachment

/obj/item/mailpaper/attachment/Initialize(mapload, mob/living/carbon/human/user)
	. = ..()
	desc = "一封写给[user]的晋升信. 公司的新主管!?!? 哦 等等, 这是来自未来的."

/obj/item/mailpaper/attachment/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("读了晋升信，你就会有更加努力工作的决心"))
	var/datum/status_effect/workspeed_buff/TMPEFF = user.has_status_effect(/datum/status_effect/workspeed_buff)
	if (!TMPEFF)
		user.apply_status_effect(/datum/status_effect/workspeed_buff)
	qdel(src)

/obj/item/mailpaper/trapped
	name = "来自异想体"
	desc = "某个时间点到来时会自动打开."
	var/datum/timedevent/effect_timer
	var/effect_min_time = 6 SECONDS
	var/effect_max_time = 12 SECONDS

/obj/item/mailpaper/trapped/Initialize()
	. = ..()
	effect_timer = new(CALLBACK(src, PROC_REF(Trap)), rand(effect_min_time, effect_max_time))
	playsound(get_turf(src), 'sound/abnormalities/mailpile/gotmail.ogg', 50, 1)

/obj/item/mailpaper/trapped/attack_self(mob/user)
	to_chat(user, span_warning("What the-"))
	Trap()

/obj/item/mailpaper/trapped/proc/Trap()
	set waitfor = FALSE
	if(effect_timer)
		deltimer(effect_timer)
	qdel(src)
	return

/obj/item/mailpaper/trapped/fairies
	desc = "为什么这张纸有一股小精灵的味道?"
	var/fairy_count = 4
	var/weaken_fairy = FALSE

/obj/item/mailpaper/trapped/fairies/Trap()
	var/turf/T = get_turf(src)
	T.visible_message(span_warning("[fairy_count > 1 ? "贪婪的精灵" : "贪婪的精灵"]从信件里爆了出来!"))
	for(var/i = 1 to fairy_count)
		var/mob/living/simple_animal/hostile/mini_fairy/MF =  new(T)
		MF.faction += "pink"
		if(weaken_fairy)
			MF.adjustBruteLoss(43)
			break
	return ..()

/obj/item/mailpaper/trapped/acid
	desc = "为什么这张纸有一股电池酸的味道?"

/obj/item/mailpaper/trapped/acid/Trap()
	var/turf/T = get_turf(src)
	T.visible_message(span_warning("从信里喷出来了酸液!"))
	for(var/i = 1 to 8)
		var/angle = rand(0, 360)
		var/obj/effect/decal/cleanable/wrath_acid/bad/AB = new(get_turf(src))
		MoveAcidAngle(AB, angle)
	return ..()

/obj/item/mailpaper/trapped/acid/proc/MoveAcidAngle(obj/effect/decal/cleanable/wrath_acid/bad/bad_acid, angle)
	set waitfor = FALSE
	var/turf/target_turf = get_turf_in_angle(angle, get_turf(src), pick(1, 2, 4))
	while(step_towards(bad_acid, target_turf, 0))
		stoplag(2)
	return

/obj/item/mailpaper/trapped/urgent
	desc = "被印上了'紧急'邮戳."
	effect_min_time = 10 SECONDS
	effect_max_time = 10 SECONDS

/obj/item/mailpaper/trapped/urgent/attack_self(mob/user)
	to_chat(user, span_notice("如果你不在10秒内读完我们就杀了你."))
	to_chat(user, span_nicegreen("你读得够快，这很好!"))
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.adjustSanityLoss(-20)
	deltimer(effect_timer)
	qdel(src)
	return

/obj/item/mailpaper/trapped/urgent/Trap()
	audible_message(span_warning("杀了你."))
	for(var/mob/living/carbon/human/H in hearers(7, src))
		H.deal_damage(50, WHITE_DAMAGE)
	return ..()

/obj/item/mailpaper/trapped/flashbang
	desc = "这张纸的中间有一个大的圆柱形肿块..."
	effect_min_time = 10 SECONDS
	effect_max_time = 20 SECONDS

/obj/item/mailpaper/trapped/flashbang/Trap()
	var/turf/T = get_turf(src)
	var/obj/item/grenade/flashbang/F = new(T)
	T.visible_message(span_notice("一颗闪光弹从邮件里掉了出来."))
	T.visible_message(span_userdanger("等等, 什么!?"))
	F.det_time = isnull(timeleft(effect_timer)) ? 0 : timeleft(effect_timer)
	F.arm_grenade()
	return ..()

/obj/item/mailpaper/coupon
	name = "来自异想体"
	desc = "'内含一 (1) 张免费优惠券!' *内容可能有所不同，请用户自行决定"
	var/obj/item/coupon_lc13/C

/obj/item/mailpaper/coupon/Initialize()
	. = ..()
	C = new(src)
	playsound(get_turf(src), 'sound/abnormalities/mailpile/gotmail.ogg', 50, 1)

/obj/item/mailpaper/coupon/attack_self(mob/user)
	user.visible_message(
		span_notice("[user]从信件中撕下优惠券."),\
		span_notice("你从信件中撕下了优惠券."),\
		span_notice("你听到了撕纸的声音.")
		)
	playsound(user, 'sound/items/poster_ripped.ogg', 100)
	C.forceMove(get_turf(user))
	qdel(src)

/obj/item/coupon_lc13
	name = "优惠券"
	desc = "欧耶，免费物品!"
	icon_state = "data_1"
	icon = 'icons/obj/card.dmi'
	var/obj/item/item_type = null
	var/list/potential_items = list()

/obj/item/coupon_lc13/Initialize()
	. = ..()
	if(!isnull(item_type))
		return
	if(potential_items.len <= 0)
		potential_items += subtypesof(/obj/item/food/pizza)
		potential_items -= /obj/item/food/pizza/arnold
		potential_items -= /obj/item/food/pizza/margherita/robo
		potential_items += subtypesof(/obj/item/reagent_containers/food/drinks/soda_cans)
		potential_items += subtypesof(/obj/item/toy)
		potential_items -= /obj/item/toy/talking
		potential_items -= /obj/item/toy/cards/cardhand
		potential_items -= /obj/item/toy/cards/singlecard
		potential_items -= /obj/item/toy/figure
		potential_items -= /obj/item/toy/plush
	item_type = pick(potential_items)

/obj/item/coupon_lc13/examine(mob/user)
	. = ..()
	. += span_notice("在手中使用有[initial(item_type?.name)]发送给您!")

/obj/item/coupon_lc13/attack_self(mob/user)
	var/obj/structure/closet/supplypod/centcompod/pod = new()
	pod.explosionSize = list(0,0,0,0)
	for(var/i = 1 to (istype(item_type, /obj/item/reagent_containers/food/drinks/soda_cans) ? 6 : 1))
		new item_type(pod)
	new /obj/effect/pod_landingzone(get_turf(user), pod)
	to_chat(user, span_notice("您的[initial(item_type?.name)]正在路上!"))
	qdel(src)

/obj/projectile/mailshuriken
	name = "paper shuriken"
	desc = "a shuriken made from paper."
	icon_state = "shuriken_paper"
	damage_type = RED_DAMAGE
	damage = 1
