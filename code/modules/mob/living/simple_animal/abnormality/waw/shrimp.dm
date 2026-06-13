//A tribute to, and Designed mostly by InsightfulParasite, our lovely spriter. Coded by Kirie Saito.
/mob/living/simple_animal/hostile/abnormality/shrimp_exec
	name = "虾业协会经理"
	desc = "一只穿着时髦西装的虾."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "executive"
	icon_living = "executive"
	core_icon = "shrimpexec_egg"
	portrait = "shrimp_executive"
	faction = list("neutral")
	speak_emote = list("burbles")
	maxHealth = 1000
	health = 1000

	threat_level = WAW_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 30,
		ABNORMALITY_WORK_INSIGHT = 30,
		ABNORMALITY_WORK_ATTACHMENT = 30,
		ABNORMALITY_WORK_REPRESSION = -100,	//He's a snobby shrimp dude.
	)
	work_damage_upper = 6
	work_damage_lower = 4
	work_damage_type = WHITE_DAMAGE	//He insults you
	chem_type = /datum/reagent/abnormality/sin/pride

	ego_list = list(
		/datum/ego_datum/armor/executive,
		/datum/ego_datum/executive_gun,
	)
	gift_type =  /datum/ego_gifts/executive

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/wellcheers = 1.5, // I... if you ever get a zayin this far in, good luck.
	)

	observation_prompt = "你坐在一间装饰着虾类纪念品的办公室里。<br>\
		各种奖杯、勋章和带有虾图案的小摆设。<br>一张用打印纸印着的虾学博士学位证书醒目地挂在墙上。<br>\
		\"喜欢我的收藏吗？<br>我可是在虾公司的巢打过大学联赛的。\"<br>\
		一只穿着时髦西装的虾坐在你面前的豪华办公椅上。<br>\
		\"容我失礼...<br>何不尝尝我们本地特产的顶级香槟？\"<br>\
		虾递给你一杯装满...某种东西的香槟杯。<br>\
		看起来闻起来都像韦尔奇乐葡萄汽水，实际上这就是汽水。<br>\
		你甚至能看到撕下来的易拉罐标签粘在杯侧。<br>你要喝吗？"
	observation_choices = list(
		"喝汽水" = list(TRUE, "未及选择，两名全副武装的巨虾守卫破门而入。<br>\
			他们按着你强灌汽水，随后你陷入昏迷...<br>...<br>遥远某处传来海鸥声。"),
		"拒绝" = list(TRUE, "未及选择，两名全副武装的巨虾守卫破门而入。<br>\
			他们按着你强灌汽水，随后你陷入昏迷...<br>...<br>遥远某处传来海鸥声。"),
	)

	var/liked
	var/happy = TRUE
	var/happy_works = 0
	pet_bonus = "blurbles" //saves a few lines of code by allowing funpet() to be called by attack_hand()
	var/hint_cooldown
	var/hint_cooldown_time = 30 SECONDS
	var/list/cooldown = list(
		"别闲逛了快去工作！",
		"我有时相当有耐心，但你正在挑战我的极限！",
		"这里的服务真够糟糕。你就不能做点有用的事？",
	)

	var/list/instinct = list(
		"我年事已高，背部疼痛，立即派个脊椎按摩师来我办公室。",
		"有点饿了，送个冷肉拼盘过来？",
		"麻烦来杯黑皮诺红酒？",
		"给我弄碗虾仁炒饭？想尝尝你们顶级虾厨的手艺。",
		"啊，忘了吃每日药片，能帮我拿来吗？",
	)

	var/list/insight = list(
		"拿我的留声机来，想听《月光奏鸣曲》第一乐章。",
		"办公室植物快枯死了，浇个水行吗？",
		"最近谈判太无趣，把早报字谜版拿来。",
		"书架积灰了，派人打扫下。",
		"糟了酒洒了，清理下。",
		"我的西装需要干洗。拿走。",

	)

	var/list/attachment = list(
		"知道吗，我刚谈成个新买卖。有兴趣听听？",
		"不知你有什么好项目？很乐意听取智者的建议。有空来找我聊聊。",
		"来，老朋友，满上这杯！为我们的好买卖干杯！",
		"正考虑买些股票，推荐投资什么？",
		"有空聊要事吗？一起喝杯咖啡探讨商业动向，你的见解总是很有价值。",
		"不知你能否抽空来喝杯茶小叙？方便时过来吧。",
	)
	var/list/shrimps = list()
	var/shrimp_cap = 24

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/WorkChance(mob/living/carbon/human/user, chance)
	if(happy)
		chance+=30
	return chance

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(happy_works >= 3)
		happy_works = 0
		var/turf/dispense_turf = get_step(src, pick(1,2,4,5,6,8,9,10))
		var/obj/structure/closet/supplypod/extractionpod/shrimppod/pod = new()
		pod.explosionSize = list(0,0,0,0)
		new/obj/structure/lootcrate/s_corp(pod)
		new /obj/effect/pod_landingzone(dispense_turf, pod)
		say("给你，我亲爱的朋友，由虾公司提供的高质量的火力.")
		return

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/ZeroQliphoth(mob/living/carbon/human/user)
	pissed()
	happy_works = 0
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_MINING)
		pissed()
		addtimer(CALLBACK(src, PROC_REF(pissed)), 20 SECONDS)

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type == liked || !liked)
		happy = TRUE
		happy_works++
	else
		happy_works = 0
		happy = FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	liked = pick(ABNORMALITY_WORK_INSTINCT, ABNORMALITY_WORK_INSIGHT, ABNORMALITY_WORK_ATTACHMENT)
	switch(liked)
		if(ABNORMALITY_WORK_INSTINCT)
			say(pick(instinct))
		if(ABNORMALITY_WORK_INSIGHT)
			say(pick(insight))
		if(ABNORMALITY_WORK_ATTACHMENT)
			say(pick(attachment))

/mob/living/simple_animal/hostile/abnormality/shrimp_exec/proc/pissed()
	set waitfor = FALSE
	if(length(shrimps) >= shrimp_cap)
		return
	var/turf/Start = pick(GLOB.department_centers)
	var/list/turfs = list()
	for(var/turf/T in circlerange(center = Start, radius = 3))
		turfs += T
	var/amount = rand(4,8)
	for(var/i = 1 to amount)
		var/turf/W = pick(turfs)
		var/obj/structure/shrimp_rope/R = new(W)
		R.exec = src
		turfs -= W

//repeat lines
/mob/living/simple_animal/hostile/abnormality/shrimp_exec/funpet()
	if(!liked)
		return
	if(hint_cooldown > world.time)
		say(pick(cooldown))
		return
	hint_cooldown = world.time + hint_cooldown_time
	switch(liked)
		if(ABNORMALITY_WORK_INSTINCT)
			say(pick(instinct))
		if(ABNORMALITY_WORK_INSIGHT)
			say(pick(insight))
		if(ABNORMALITY_WORK_ATTACHMENT)
			say(pick(attachment))
	return

/* Rope */
/obj/structure/shrimp_rope
	name = "绳子"
	desc = "一根长长的绳子，系在天花板上一个新发现的洞口处."
	icon = 'icons/effects/32x96.dmi'
	icon_state = "rope"
	layer = MOB_LAYER
	anchored = TRUE
	density = FALSE
	max_integrity = 1
	resistance_flags = INDESTRUCTIBLE
	alpha = 0
	pixel_z = 96
	var/mob/living/simple_animal/hostile/abnormality/shrimp_exec/exec = null

/obj/structure/shrimp_rope/Initialize()
	. = ..()
	pixel_x = rand(-4,4)
	addtimer(CALLBACK(src, PROC_REF(SpawnShrimp)), rand(0,20)) //A bit of randomness

/obj/structure/shrimp_rope/proc/SpawnShrimp()
	animate(src, pixel_z = 0, alpha = 255, time = 20,  easing = SINE_EASING | EASE_IN)
	sleep(3 SECONDS)
	var/list/turfs = list()
	var/should_spawn = TRUE
	for(var/turf/T in orange(1, get_turf(src)))
		turfs += T
	if(exec)
		if(length(exec.shrimps) >= exec.shrimp_cap)
			should_spawn = FALSE
	if(should_spawn)
		addtimer(CALLBACK(src, PROC_REF(BeBreakable)), 3 SECONDS)
		var/mob/living/simple_animal/hostile/aminion/shrimp/S
		if(prob(30))
			S = new/mob/living/simple_animal/hostile/aminion/shrimp/soldier(pick(turfs))
		else
			S = new(pick(turfs))
		if(exec)
			S.exec = exec
			exec.shrimps += S
		S.dir = get_dir(S, src)
		S.SpawnAnimation()
	else
		resistance_flags &= ~INDESTRUCTIBLE

/obj/structure/shrimp_rope/proc/BeBreakable()
	resistance_flags &= ~INDESTRUCTIBLE

/obj/structure/shrimp_rope/Destroy()
	if(exec)
		exec = null
	. = ..()

/* Shrimpo boys */
/mob/living/simple_animal/hostile/aminion/shrimp
	name = "韦尔奇乐清算实习员工"
	desc = "一只对你极具敌意的虾."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wellcheers"
	icon_living = "wellcheers"
	icon_dead = "wellcheers_dead"
	faction = list("shrimp")
	health = 220
	maxHealth = 220
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	melee_damage_lower = 6
	melee_damage_upper = 8
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "punches"
	attack_verb_simple = "punches"
	attack_sound = 'sound/weapons/bite.ogg'
	speak_emote = list("burbles")
	butcher_results = list(/obj/item/stack/spacecash/c50 = 1)
	guaranteed_butcher_results = list(/obj/item/stack/spacecash/c10 = 1)
	silk_results = list(/obj/item/stack/sheet/silk/shrimple_simple = 4)
	threat_level = TETH_LEVEL
	score_divider = 2
	var/mob/living/simple_animal/hostile/abnormality/shrimp_exec/exec = null
	var/can_act = TRUE

/mob/living/simple_animal/hostile/aminion/shrimp/Initialize()
	. = ..()
	if(SSmaptype.maptype in SSmaptype.citymaps)
		can_affect_emergency = FALSE
		del_on_death = FALSE

/mob/living/simple_animal/hostile/aminion/shrimp/proc/SpawnAnimation()
	can_act = FALSE
	docile_confinement = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	status_flags |= GODMODE
	pixel_z = 96
	alpha = 0
	density = FALSE
	animate(src, pixel_z = 0, alpha = 255, time = 30,  easing = CUBIC_EASING | EASE_IN)
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	playsound(get_turf(src), 'sound/items/zip.ogg', 50, TRUE, frequency = 0.7)
	SLEEP_CHECK_DEATH(1.4 SECONDS)
	status_flags &= ~GODMODE
	density = TRUE
	mouse_opacity = MOUSE_OPACITY_ICON
	SLEEP_CHECK_DEATH(0.1 SECONDS)
	can_act = TRUE
	docile_confinement = FALSE

/mob/living/simple_animal/hostile/aminion/shrimp/Destroy()
	if(exec)
		exec.shrimps -= src
		exec = null
	. = ..()

/mob/living/simple_animal/hostile/aminion/shrimp/OpenFire()
	if(!can_act)
		return
	return ..()

/mob/living/simple_animal/hostile/aminion/shrimp/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return
	return ..()

/mob/living/simple_animal/hostile/aminion/shrimp/Move()
	if(!can_act)
		return
	return ..()

/mob/living/simple_animal/hostile/aminion/shrimp/PickTarget(list/Targets)
	if(!can_act)
		return
	return ..()

//You can put these guys about to guard an area.
/mob/living/simple_animal/hostile/aminion/shrimp/soldier
	name = "韦尔奇乐公司清算长官"
	desc = "守卫一个区域的虾."
	icon_state = "wellcheers_bad"
	icon_living = "wellcheers_bad"
	icon_dead = "wellcheers_bad_dead"
	health = 300 //They're here to help
	maxHealth = 300
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	melee_damage_lower = 3
	melee_damage_upper = 5
	ranged = 1
	retreat_distance = 2
	minimum_distance = 3
	casingtype = /obj/item/ammo_casing/caseless/ego_shrimpsoldier
	projectilesound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	guaranteed_butcher_results = list(/obj/item/stack/spacecash/c20 = 1, /obj/item/stack/spacecash/c1 = 5)
	silk_results = list(/obj/item/stack/sheet/silk/shrimple_simple = 8, /obj/item/stack/sheet/silk/shrimple_advanced = 4)
	threat_level = HE_LEVEL
	/// When at 0 - it will start "reloading"
	var/ammo = 6

/mob/living/simple_animal/hostile/aminion/shrimp/soldier/Life()
	. = ..()
	if(!.)
		return
	if(ammo <= 0)
		retreat_distance = 4
		minimum_distance = 6
	else
		retreat_distance = 2
		minimum_distance = 3

/mob/living/simple_animal/hostile/aminion/shrimp/soldier/OpenFire(atom/A)
	if(!can_act)
		return FALSE
	if(ammo <= 0)
		StartReloading()
		return FALSE
	ammo -= 1
	return ..()

/mob/living/simple_animal/hostile/aminion/shrimp/soldier/proc/StartReloading()
	can_act = FALSE
	playsound(get_turf(src), 'sound/weapons/gun/general/slide_lock_1.ogg', 50, FALSE)
	for(var/i = 1 to 6)
		SLEEP_CHECK_DEATH(4)
		playsound(get_turf(src), 'sound/weapons/gun/general/bolt_rack.ogg', 50, FALSE)
	ammo = 6
	can_act = TRUE


/mob/living/simple_animal/hostile/aminion/shrimp/soldier/friendly
	name = "韦尔奇乐公司突击员工"
	icon_state = "wellcheers_soldier"
	icon_living = "wellcheers_soldier"
	icon_dead = "wellcheers_soldier_dead"
	faction = list("neutral", "shrimp")
	can_affect_emergency = FALSE
	trigger_lights = FALSE
	fear_level = 0
	area_index = MOB_SIMPLEANIMAL_INDEX // Don't trip regenerator threat mode

/obj/item/grenade/spawnergrenade/shrimp
	name = "虾特遣部队召唤手榴弹"
	desc = "用来召集虾特遣部队的手榴弹."
	icon_state = "shrimpnade"
	spawner_type = /mob/living/simple_animal/hostile/aminion/shrimp/soldier/friendly
	deliveryamt = 3

/obj/item/grenade/spawnergrenade/shrimp/super
	deliveryamt = 7	//Just randomly get double money.

/obj/item/grenade/spawnergrenade/shrimp/hostile
	spawner_type = list(/mob/living/simple_animal/hostile/aminion/shrimp, /mob/living/simple_animal/hostile/aminion/shrimp/soldier) //Gacha Only, just put it here with the other shrimp grenades.

//Crates
//S Corporation
/obj/structure/lootcrate/s_corp
	name = "虾公司战利品箱"
	desc = "一个包含神秘虾公司物品的箱子。用撬棍或用手打开。"
	icon_state = "crate_shrimp"
	veryrarechance = 10
	cosmeticchance = 10
	lootlist =	list(
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_red,
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_white,
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_purple,
		/obj/item/grenade/spawnergrenade/shrimp,
	)

	rareloot = list(
		/obj/item/grenade/spawnergrenade/shrimp/super,
		/obj/item/trait_injector/shrimp_injector,
		/obj/item/fishing_rod/wellcheers,
		/obj/item/clothing/suit/armor/ego_gear/zayin/soda,
		/obj/item/ego_weapon/ranged/pistol/soda
	)

	veryrareloot = list(
		/obj/item/grenade/spawnergrenade/shrimp/super,
		/obj/item/grenade/spawnergrenade/shrimp/hostile,
		/obj/item/ego_weapon/ranged/sodarifle,
		/obj/item/reagent_containers/pill/shrimptoxin,
	)

	cosmeticloot = list(
		/mob/living/simple_animal/hostile/aminion/shrimp,
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_red,
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_white,
	)

/obj/structure/lootcrate/s_corp/attack_hand(mob/living/carbon/human/user)
	. = ..()
	var/loot
	var/cloot

	rarechance += repmodifier
	if(veryrarechance)
		veryrarechance += (repmodifier/crate_multiplier)

	if((SSmaptype.maptype in SSmaptype.citymaps) && (user?.mind?.assigned_role != "Extraction Officer"))	//Fuckers shouldn't loot like this, unless for some reason the EO exists.
		SEND_GLOBAL_SIGNAL(COMSIG_CRATE_LOOTING_STARTED, user, src)
		if(!do_after(user, 7 SECONDS, src))
			return

	//Mimic this
	user.do_attack_animation(src)
	playsound(src, 'sound/weapons/smash.ogg', 50, TRUE)

	if(veryrarechance && prob(veryrarechance))
		loot = pick(veryrareloot)

	else if(prob(rarechance))
		loot = pick(rareloot)

	else
		loot = pick(lootlist)

	if(cosmeticchance && prob(cosmeticchance))
		cloot = pick(cosmeticloot)
		new cloot(get_turf(src))

	to_chat(user, span_notice("你打开了箱子!"))
	if(SSmaptype.maptype in SSmaptype.citymaps)
		SEND_GLOBAL_SIGNAL(COMSIG_CRATE_LOOTING_ENDED, user, src)

	new loot(get_turf(src))
	qdel(src)

/obj/structure/lootcrate/s_corp/gun
	name = "虾公司武器箱"
	desc = "一个包含神秘虾公司武器的箱子。用撬棍或用手打开。"
	icon_state = "crate_weapon_shrimp"
	rarechance = 80
	veryrarechance = 15
	cosmeticchance = 0
	lootlist =	list(
		/obj/item/ego_weapon/ranged/sodarifle,
	)

	rareloot = list(
		/obj/item/ego_weapon/ranged/pistol/soda_premium,
		/obj/item/ego_weapon/ranged/sodaminigun,
		/obj/item/ego_weapon/ranged/sodasmg,
		/obj/item/ego_weapon/ranged/sodashotty,
		/obj/item/ego_weapon/ranged/sodaassault,
	)

	veryrareloot = list(
		/obj/item/ego_weapon/ranged/pistol/executive
	)
	cosmeticloot = list()

/obj/structure/closet/supplypod/extractionpod/shrimppod
	name = "虾登陆舱"
	desc = "A purple pod."
	style = STYLE_SHRIMP
