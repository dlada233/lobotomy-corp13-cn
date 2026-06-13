/mob/living/simple_animal/hostile/abnormality/sirocco
	name = "热风"
	desc = "一场有感知的沙尘暴，你可以看到里面一个孩子般的身影."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "sirocco_chill"
	icon_living = "sirocco_chill"
	icon_dead = "sirocco_dead"
	var/breach_icon = "sirocco"
	core_icon = "sirocco"
	portrait = "sirocco"
	del_on_death = TRUE
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 300
	health = 300
	blood_volume = 0
	density = FALSE
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	stat_attack = HARD_CRIT
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 3
	del_on_death = FALSE
	move_to_delay = 6
	can_affect_min = FALSE // She should be able to subside normally
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 50, 40, 30, 30),
		ABNORMALITY_WORK_INSIGHT = list(30, 15, -50, -50, -50),
		ABNORMALITY_WORK_ATTACHMENT = 60,
		ABNORMALITY_WORK_REPRESSION = list(40, 20, -20, -20, -20),
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/desert,
		/datum/ego_datum/armor/desert,
	)
	gift_type = /datum/ego_gifts/desert
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	chem_type = /datum/reagent/abnormality/sirocco
	harvest_phrase = span_notice("当%ABNO分心时，你用它的沙子填满了%VESSEL。即使与%ABNO分离后，沙子仍持续移动.")
	harvest_phrase_third = "当%ABNO分心时，%PERSON用沙暴的沙子填满了%VESSEL."

	observation_prompt = "为什么这里每个人都这么无聊？<br>为什么没人想和我玩？<br>\
		风暴中某处传来一个小女孩的哭喊声。<br>\
		\"每个人都盯着地板，好像生活是件苦差事...当大人真的那么糟糕吗？\" <br>\
		\"如果大人就是那样，我才不想长大！\" <br>\
		你该对它说什么?"

	observation_choices = list(
		"你最终还是会长大" = list(TRUE, "风暴开始减缓. <br>\
			\"但这里所有的大人，他们不后悔长大吗?\" <br>\
			也许后悔，也许不后悔. <br>\
			成长和改变总比停滞不前、逃避现实世界要好. <br>\
			风暴渐渐停止. <br>\
			\"...也许你是对的，如果没人想玩，也许我也该停止玩耍了.\" <br>\
			你只能希望即使它再次突破收容，也不会那么惹麻烦. <br>\
			你留下风暴独自思考你的话."),
		"别担心" = list(FALSE, "\"是啊！才不用为那些无聊的大人操心呢!\" <br>\
			\"嘿嘿! 等我再出来，你可得看我扔你那个无趣的朋友有多快!\" <br>\
			看来鼓励它只会让以后的情况更糟. <br>\
			算了，也许有一天它会自己玩累的. <br>现在最好别管它."),
	)

	// Work Variables
	var/work_timer
	var/time_to_lower = 2 MINUTES // Time to lower qliphoth

	// Breach variables
	var/cooldown_time = 3 // Cooldown between grab attempts
	var/list/grabbed_list = list()
	var/list_refresh_time = 30
	var/breached_time = 4 MINUTES
	var/lowered_breached_time = 15 SECONDS
	var/current_level = 0
	var/grab_range = 3

/mob/living/simple_animal/hostile/abnormality/sirocco/Initialize()
	. = ..()
	current_level = GLOB.emergency_level
	RegisterSignal(SSdcs, COMSIG_TRUMPET_CHANGED, PROC_REF(on_trumpet_change))

/mob/living/simple_animal/hostile/abnormality/sirocco/proc/on_trumpet_change(datum/source, level)
	SIGNAL_HANDLER
	if(!IsContained())
		return
	if(level > current_level)
		datum_reference.qliphoth_change(level - current_level)
	current_level = level

/mob/living/simple_animal/hostile/abnormality/sirocco/proc/Grabber()
	if(stat == DEAD)
		return
	for(var/atom/movable/A in oview(grab_range, src)) // Grab anything in our range
		if(isliving(A) && faction_check_mob(A))
			continue
		if(A && !A.anchored && !isobserver(A) && A != src)
			A.throw_at(src, 1, 1, src, FALSE)
	addtimer(CALLBACK(src, PROC_REF(Grabber)), cooldown_time)
	addtimer(CALLBACK(src, PROC_REF(ThrowAround)), 2)

/mob/living/simple_animal/hostile/abnormality/sirocco/proc/ThrowAround()
	if(stat == DEAD)
		return
	var/turf/turf_underneath = get_turf(src)
	for(var/atom/movable/A in turf_underneath)
		if(A && !A.anchored && !isobserver(A) && A != src && !(A in grabbed_list))
			if(isliving(A))
				grabbed_list += A
			var/randomdir = rand(0, 10)
			A.throw_at(get_edge_target_turf(src,randomdir), rand(4,7), 3, src, TRUE)

/mob/living/simple_animal/hostile/abnormality/sirocco/proc/RefreshList()
	grabbed_list = list()
	if(stat == DEAD)
		return
	addtimer(CALLBACK(src, PROC_REF(RefreshList)), list_refresh_time)

/mob/living/simple_animal/hostile/abnormality/sirocco/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/sirocco/PickTarget(list/Targets)
	return

/* Qliphoth/Breach effects */
/mob/living/simple_animal/hostile/abnormality/sirocco/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	UnregisterSignal(SSdcs, COMSIG_TRUMPET_CHANGED)
	addtimer(CALLBACK(src, PROC_REF(Grabber)), cooldown_time)
	addtimer(CALLBACK(src, PROC_REF(RefreshList)), list_refresh_time)
	icon_state = breach_icon
	addtimer(CALLBACK(src, PROC_REF(EndStorm)), breached_time)
	if(breach_type == BREACH_PINK)
		move_to_delay = 2
		ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.4))

/mob/living/simple_animal/hostile/abnormality/sirocco/proc/EndStorm()
	if(GLOB.emergency_level != TRUMPET_0)
		addtimer(CALLBACK(src, PROC_REF(EndStorm)), lowered_breached_time)
		return
	grabbed_list = list()
	death()

/mob/living/simple_animal/hostile/abnormality/sirocco/death(gibbed)
	icon_state = icon_dead
	density = FALSE
	grabbed_list = list()
	QDEL_IN(src, 3 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/sirocco/SuccessEffect(mob/living/carbon/human/user, work_type, pe, canceled)
	. = ..()
	datum_reference.qliphoth_change(1)

/mob/living/simple_animal/hostile/abnormality/sirocco/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

/* Death cleanup */
/mob/living/simple_animal/hostile/abnormality/sirocco/Destroy()
	grabbed_list = list()
	. = ..()

/datum/reagent/abnormality/sirocco
	name = "不安分的沙子"
	description = "看起来像普通的老沙子，尝起来很甜."
	color = "#FDEE73"
	stat_changes = list(0, 3, 3, 5) //increases justice, prudence and temperance
	damage_mods = list(1.5, 1, 1, 1) //but makes you weaker to red.

