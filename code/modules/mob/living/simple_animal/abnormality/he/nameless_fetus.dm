/mob/living/simple_animal/hostile/abnormality/fetus
	name = "无名怪婴"//（出自脑叶）
	desc = "一个巨大的，充满脓液的婴儿."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "fetus"
	portrait = "nameless_fetus"
	maxHealth = 800
	health = 800
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 50, 60, 60, 60),
		ABNORMALITY_WORK_INSIGHT = list(20, 30, 30, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(20, 30, 30, 30, 30),
		ABNORMALITY_WORK_REPRESSION = list(20, 30, 30, 30, 30),
	)
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 2)
	start_qliphoth = 1
	pixel_x = -8
	base_pixel_x = -8
	work_damage_upper = 6
	work_damage_lower = 4
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gluttony
	max_boxes = 18
	melee_damage_type = RED_DAMAGE
	stat_attack = DEAD
	melee_damage_lower = 15
	melee_damage_upper = 30
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/abnormalities/mountain/bite.ogg'
	ego_list = list(
		/datum/ego_datum/weapon/syrinx,
		/datum/ego_datum/weapon/trachea,
		/datum/ego_datum/armor/syrinx,
	)
	gift_type =  /datum/ego_gifts/syrinx
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "婴儿从不哭泣。<br>它永远如此。<br>\
		无言未必无感，无泪亦非无欲。<br>\
		自不可知之时起，婴儿便生有一张嘴。<br>这个不理解哭泣的婴儿，表达着饥饿，给他人带来痛苦。<br>你..."
	observation_choices = list(
		"呼唤其名" = list(TRUE, "无人知晓那胎儿的名字。<br>\
			但你知道。<br>你唤出了它的名字。<br>\
			无法遏制的欲望暂时闭上了嘴。<br>即便只有片刻，欲望沉寂了。"),
		"未呼唤其名" = list(FALSE, "胎儿仍在哭泣。<br>\
			你默默捂住耳朵。<br>听不见任何声音。"),
	)

	work_start_lines = list("%ABNO甚至都没有完全成型的器官.",
	"%ABNO吮吸着它的拇指，并不时地抽泣着.", "%ABNO的腹部有一条长长的看起来像疤痕的东西.",
	"如果你听见了它的嚎哭，那意味着我们中的某一位将永远消失.")
	early_work_lines = list("与其他婴儿不同，%ABNO不会找它的妈妈.",
	"%ABN被不明的粘液覆盖着，不像其他婴儿那样被裹在温暖的被子里，做着快乐的梦.",
	"在%ABNO四周，有一些疑似脐带的不明物体散乱地掉在地上。虽然这是个 \"育儿室\"，但在这里没有哭闹，只有可怕的寂静.",
	"%PERSON进入了收容单元，但跟其他婴儿不同，%ABNO对此没有任何反应.")
	middle_work_lines = list("它漆黑的大瞳孔没有看着任何地方，它甚至都不会眨眼.",
	"%ABNO与其他婴儿唯一相同的地方就是它会吮吸手上疑似是拇指的部位，以此来表现它的饥饿以及进食的欲望.",
	"曾经有段时间，%ABNO也会像其他婴儿一样“牙牙学语”。但是所有的员工都知道那不只是单纯的\"牙牙学语\".",
	"%ABNO经常像其他婴儿一样发出声音，但是不用担心，因为它的欲望还没有那么强烈.")
	late_work_lines = list("在进行工作时，%PERSON对%ABNO弄出有节奏的声响，就像是在照顾一个婴儿一样.",
	"%PERSON停止了手头的工作并接近了%ABNO，勉强地保持着微笑，以免惊动\"婴儿\".",
	"%PERSON回头检查着%ABNO. 幸运的是，%ABNO没有哭泣.",
	"因为担心%ABNO，%PERSON在工作中反复检查着是否有出现差错. 我们都知道这名员工在担心着什么.")
	work_end_lines = list("%ABNO张开了它的巨口，舔着嘴唇，漆黑的瞳孔中隐约能看见它本能的欲望.",
	"%ABNO闭上了它的眼睛。当然，这不是睡眠的行为，%ABNO只会想着一件事儿.",
	"突然，%ABNO扭过头来，并注视着几乎已经完成工作的%PERSON。虽然它的眼神里没有什么恶意，但那显然不是盯着\"人类\"的眼神.",
	"%ABNO感到了饥饿，然后在一瞬间，它转头凝视着%PERSON。%ABNO那纯粹的邪念穿透了一切.")

	var/mob/living/carbon/human/calling = null
	var/criesleft
	var/crying = FALSE

	can_buckle = TRUE
	var/satisfied = FALSE
	var/hunger = 0

	var/can_act = TRUE
	var/cry_cooldown
	var/cry_cooldown_time = 20 SECONDS
	var/obj/particle_emitter/fetus_cry/particle_cry
	var/bite_cooldown
	var/bite_cooldown_time = 5 SECONDS

/mob/living/simple_animal/hostile/abnormality/fetus/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/fetus/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	if(cry_cooldown <= world.time && !satisfied)
		cry_cooldown = world.time + cry_cooldown_time
		Cry()

/mob/living/simple_animal/hostile/abnormality/fetus/PickTarget(list/Targets) // We attack corpses first if there are any
	var/list/highest_priority = list()
	var/list/lower_priority = list()
	for(var/mob/living/L in Targets)
		if(!CanAttack(L))
			continue
		if(L.health < 0 || L.stat == DEAD)
			if(ishuman(L))
				highest_priority += L
		else
			lower_priority += L
	if(LAZYLEN(highest_priority))
		return pick(highest_priority)
	if(LAZYLEN(lower_priority))
		return pick(lower_priority)
	return ..()

/mob/living/simple_animal/hostile/abnormality/fetus/CanAttack(atom/the_target)
	if(ishuman(the_target))
		if(bite_cooldown > world.time || satisfied)
			return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/fetus/AttackingTarget(atom/attacked_target)
	if(bite_cooldown > world.time || satisfied || !can_act)
		return FALSE
	. =  ..()
	if(isliving(attacked_target))
		var/mob/living/L = attacked_target
		if((L.health < 0 || L.stat == DEAD))
			L.gib()
			if(ishuman(L))
				satisfied = TRUE
				for(var/mob/living/carbon/human/H in GLOB.player_list)
					to_chat(H, span_userdanger("生物满足了."))
		bite_cooldown = world.time + bite_cooldown_time

/mob/living/simple_animal/hostile/abnormality/fetus/Destroy()
	if(!particle_cry)
		return ..()
	particle_cry.fadeout()
	return ..()

//Work-related
/mob/living/simple_animal/hostile/abnormality/fetus/WorkChance(mob/living/carbon/human/user, chance, work_type)
	return chance + (satisfied * 20)

/mob/living/simple_animal/hostile/abnormality/fetus/ZeroQliphoth(mob/living/carbon/human/user)
	if(satisfied)
		satisfied = FALSE
		hunger = 0
		datum_reference.qliphoth_change(1)
		visible_message(span_userdanger("怪婴开始抽动，但只是短暂的一瞬间..."))
	else
		criesleft = 5
		for(var/mob/living/carbon/human/H in GLOB.player_list)	//Way harder to get a list of living humans.
			if(H.stat != DEAD)
				criesleft+=1		//Get a max of 1 additional cry per person.
		crying = TRUE
		check_players()
		check_range()

/mob/living/simple_animal/hostile/abnormality/fetus/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(satisfied)
		hunger--
		if(hunger <= 0)
			satisfied = FALSE
			visible_message(span_userdanger("怪婴看起来有些饥饿!"))

/mob/living/simple_animal/hostile/abnormality/fetus/user_buckle_mob(mob/living/M, mob/user, check_loc)
	if(crying || user == src || !ishuman(M) || (GODMODE in M.status_flags) || M.stat != DEAD)
		to_chat(user, span_warning("[src]拒绝了你的提供!"))
		return FALSE
	. = ..()
	to_chat(user, span_userdanger("怪婴张开了嘴..."))
	SLEEP_CHECK_DEATH(2 SECONDS)
	if(M in view(1,src))
		M.gib()
		to_chat(user, span_nicegreen("[src]很满意你的提供!"))
		satisfied = TRUE
		hunger += 4
		playsound(get_turf(src),'sound/effects/limbus_death.ogg', 50, 1)

//Are they nearby?
/mob/living/simple_animal/hostile/abnormality/fetus/proc/check_range()
	var/list/corpses = list()
	var/satisfied = FALSE
	for(var/mob/living/carbon/human/H in view(1,src))
		if(!Adjacent(H))
			continue
		if(H.stat == DEAD)
			corpses += H
	if(LAZYLEN(corpses))
		var/mob/living/carbon/human/corpse = pick(corpses)
		if(corpse)
			calling = null
			corpse.gib()
			corpse = null
			hunger += 4 //Not as much compared to fresh meat
			satisfied = TRUE
	if(!satisfied)
		if(calling && Adjacent(calling))
			calling.gib()
			calling = null
			hunger += 12 //Ehh might as well triple the effectiveness of it being fed if you have to die.
			satisfied = TRUE
	if(satisfied)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			to_chat(H, span_userdanger("生物满足了."))

		notify_ghosts("无名怪婴满足了.", source = src, action = NOTIFY_ORBIT, header="有趣的事情!") // bless this mess
		datum_reference.qliphoth_change(1)
		return

	addtimer(CALLBACK(src, PROC_REF(check_range)), 2 SECONDS)


/mob/living/simple_animal/hostile/abnormality/fetus/proc/check_players()
	crying = FALSE
	if(datum_reference.qliphoth_meter == 1)
		return
	if(!(status_flags & GODMODE))
		return
	if(criesleft<=0)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			to_chat(H, span_warning("哭声停止了。终于，安静了."))
			datum_reference.qliphoth_change(1)
		return

	crying = TRUE
	criesleft--

	//Find a living player, they're the new target.
	var/list/checking = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.z == z && H.stat != DEAD)
			checking +=H
	if(LAZYLEN(checking))
		calling = pick(checking)

		//and make a global announce
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			to_chat(H, span_userdanger("怪婴呼唤着 [calling.real_name]."))

		notify_ghosts("怪婴呼唤着 [calling.real_name].", source = src, action = NOTIFY_ORBIT, header="有趣的事情!") // bless this mess
	Cry()
	addtimer(CALLBACK(src, PROC_REF(check_players)), 10 SECONDS)

/mob/living/simple_animal/hostile/abnormality/fetus/proc/Cry()
	set waitfor = 0
	can_act = FALSE
	var/list/qliphoth_abnos = list()
	var/list/hearers = list()
	for(var/mob/living/simple_animal/hostile/abnormality/V in urange(15, src))
		if(V.IsContained())
			qliphoth_abnos += V
	if(src in qliphoth_abnos)
		qliphoth_abnos -= src
	if(LAZYLEN(qliphoth_abnos))
		var/mob/living/simple_animal/hostile/abnormality/meltem = pick(qliphoth_abnos)
		meltem.datum_reference.qliphoth_change(-1)
	particle_cry = new(get_turf(src))
	particle_cry.pixel_y = 4
	//Babies crying hurts your head
	playsound(src, 'sound/abnormalities/fetus/crying.ogg', 100, FALSE, 7, 5)
	SLEEP_CHECK_DEATH(3)
	for(var/i = 1 to 8)
		for(var/mob/living/L in urange(15, src))
			if(faction_check_mob(L, FALSE))
				continue
			if(L.stat == DEAD)
				continue
			if(!(L in hearers))
				hearers += L
				to_chat(L, span_warning("哭声让你的头感到疼痛..."))
			L.deal_damage(pick(1,1.5), WHITE_DAMAGE, attack_type = (ATTACK_TYPE_SPECIAL))
		SLEEP_CHECK_DEATH(4)
	SLEEP_CHECK_DEATH(3)
	can_act = TRUE
	if(!particle_cry)
		return
	particle_cry.fadeout()


/* Work effects */
/mob/living/simple_animal/hostile/abnormality/fetus/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(20))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/fetus/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return
