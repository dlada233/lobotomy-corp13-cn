// Silly christmass/new year
/mob/living/simple_animal/hostile/abnormality/rudolta_buff
	name = "雪橇上的鲁道夫"
	desc = "鲁道夫受够了，现在所有坏孩子都会直接收到从雪橇上送来的煤块."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "rudolta_buff"
	icon_living = "rudolta_buff"
	icon_dead = "rudolta_buff_dead"
	maxHealth = 1200
	health = 1200
	del_on_death = FALSE
	pixel_x = -16
	base_pixel_x = -16
	damage_coeff = list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.8)
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 20
	melee_damage_upper = 25
	rapid_melee = 2
	ranged = TRUE
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/abnormalities/rudolta_buff/melee.ogg'
	stat_attack = HARD_CRIT
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 2
	move_to_delay = 4
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(100, 90, 80, 75, 50),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 45, 40, 35),
		ABNORMALITY_WORK_ATTACHMENT = list(70, 60, 50, 40, 30),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 10, 20, 30),
	)
	work_damage_upper = 15
	work_damage_lower = 8
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/buff_christmas,
		/datum/ego_datum/armor/buff_christmas,
	)
	gift_type = /datum/ego_gifts/christmas/buff
	abnormality_origin = ABNORMALITY_ORIGIN_JOKE

	attack_action_types = list(
		/datum/action/innate/abnormality_attack/rudolta_buff_onrush,
		/datum/action/innate/abnormality_attack/rudolta_buff_slam,
	)

		// I just copied these over from rudolta. I don't know who made buffdolta, or if it is even funny anymore. - Coxswain
	observation_prompt = "传说有个每年都会实现他人愿望的男人。<br>好孩子才可能见到他。<br>\
		背着巨大麻袋的男人。<br>乘驯鹿雪橇周游世界的男人。<br>\
		Alex收到了礼物。<br>但他是个顽劣的孩子。<br>这不公平。<br>我无法接受。<br>于是次年圣诞我去了Alex家。<br>\
		如果那个男人仍然为Alex而来，我一定要质问他为何从不眷顾我。<br>\
		那夜万籁俱寂。<br>我守在沉睡的Alex身旁等待着。<br>\
		有时荒诞童话恰是绝望中仅存的微光。<br>当我见到圣诞老人时，脑中浮现出肢解他的画面。<br>...<br>\
		此刻他就在眼前。<br>我梦想中的存在。<br>人们不再称其为圣诞老人。<br>麻袋中有物蠕动。我......"
	observation_choices = list(
		"未打开麻袋" = list(TRUE, "麻袋里承载着欲望。<br>\
			那是我自幼期盼的希望。<br>我始终未曾开启。<br>你的愿望可曾实现？"),
		"打开了麻袋" = list(FALSE, "里面盛着我毕生渴求之物。<br>\
			如潘多拉魔盒，一旦打开便永无归袋之日。"),
	)

	work_start_lines = list("锈钟鸣响，悲惨的圣诞开始了.",
	"错位的下巴，松软的舌头，诉说着断断续续的话语，没有人能理解它的意图.", "那位象征着不幸的老头，如今在哪里?")
	early_work_lines = list("形形色色的彩灯如同圣诞一般明朗，亦如每个孩子的生命一般黯淡.",
	"缝纫的手法很是糟糕，但你不难看出制作者那病态的痴迷.")
	middle_work_lines = list("嚯，圣诞节，可怕的狂欢节。真想把每个人的舌头都给拔下来，看你们还拿什么唱颂歌.",
	"我向你送出了礼物，充斥着无尽憎恨的礼物.")
	late_work_lines = list("我们无法确定%ABNO是否具有生命，它的一切动作可能是由它本身就有的能源所驱使着的.",
	"%ABNO漫无目的地游荡着，它想把自己的礼物送给大家.")

	var/can_act = TRUE
	// Onrush vars
	var/onrush_cooldown
	var/onrush_cooldown_time = 10 SECONDS
	var/onrush_damage = 30
	var/onrush_max_iterations = 6
	var/onrush_min_delay = 3
	var/onrush_max_delay = 6
	var/onrush_double_hit = FALSE
	var/list/onrush_hit = list()
	var/list/onrush_sounds = list(
		'sound/abnormalities/rudolta_buff/onrush1.ogg',
		'sound/abnormalities/rudolta_buff/onrush2.ogg',
		'sound/abnormalities/rudolta_buff/onrush3.ogg',
	)
	// Sleigh slam vars
	var/slam_cooldown
	var/slam_cooldown_time = 20 SECONDS
	var/slam_damage = 50

/datum/action/innate/abnormality_attack/rudolta_buff_onrush
	name = "冲锋"
	button_icon_state = "generic_toggle0"
	chosen_attack_num = 1
	chosen_message = span_colossus("你现在将对活着的敌人发动冲锋攻击.")

/datum/action/innate/abnormality_attack/rudolta_buff_slam
	name = "雪橇猛击"
	button_icon_state = "generic_slam"
	chosen_attack_num = 2
	chosen_message = span_colossus("你现在将用雪橇猛击目标区域.")

/mob/living/simple_animal/hostile/abnormality/rudolta_buff/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/rudolta_buff/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE

	if(onrush_cooldown <= world.time)
		OnRush(attacked_target)
		return

	return ..()

/mob/living/simple_animal/hostile/abnormality/rudolta_buff/OpenFire()
	if(!can_act)
		return FALSE

	if(client)
		switch(chosen_attack)
			if(1)
				OnRush(target)
			if(2)
				SleighSlam(target)
		return

	if(onrush_cooldown <= world.time)
		OnRush(target)
		return

	if((slam_cooldown <= world.time))
		SleighSlam(target)
		return

	return

/mob/living/simple_animal/hostile/abnormality/rudolta_buff/death()
	animate(src, alpha = 0, time = (10 SECONDS))
	QDEL_IN(src, (10 SECONDS))
	return ..()

// Turns Rudolta into red mist by punching everyone one-by-one until he runs out of targets in range
/mob/living/simple_animal/hostile/abnormality/rudolta_buff/proc/OnRush(mob/living/target, iteration = 0)
	if(!can_act && !iteration)
		return

	if(!iteration && onrush_cooldown > world.time)
		return

	if(iteration >= onrush_max_iterations)
		can_act = TRUE
		return

	can_act = FALSE
	onrush_cooldown = world.time + onrush_cooldown_time
	face_atom(target)
	if(!iteration)
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
		animate(D, alpha = 0, transform = matrix()*1.5, time = 3)
		visible_message(span_danger("[src]准备惩罚所有人!"))
		onrush_hit = list()
		SLEEP_CHECK_DEATH(5)

	if(!istype(target))
		can_act = TRUE
		return

	var/turf/target_turf = get_step(target, get_dir(target, src))
	var/list/line_list = getline(src, target_turf)
	for(var/i = 1 to length(line_list))
		var/turf/TT = line_list[i]
		var/obj/effect/temp_visual/decoy/D = new (TT, src)
		D.alpha = min(150 + i*15, 255)
		animate(D, alpha = 0, time = 4 + i*2)

	forceMove(target_turf)
	// PUNCH!!!!
	playsound(src, pick(onrush_sounds), rand(50, 100), TRUE, 7)
	to_chat(target, span_userdanger("[src]狠狠揍了你一拳!"))
	if(!onrush_double_hit)
		onrush_hit |= target
	var/turf/thrownat = get_ranged_target_turf_direct(src, target, 15, rand(-30, 30))
	target.throw_at(thrownat, 8, 2, src, TRUE, force = MOVE_FORCE_OVERPOWERING, gentle = FALSE)
	target.deal_damage(onrush_damage, RED_DAMAGE, src, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
	new /obj/effect/temp_visual/smash_effect(get_turf(target))
	shake_camera(target, 2, 5)

	if(iteration >= onrush_max_iterations)
		can_act = TRUE
		onrush_hit = list()
		return

	// Pick new target
	var/list/valid_targets = list()
	for(var/mob/living/L in view(9, src))
		if(L.stat == DEAD)
			continue
		if(faction_check_mob(L))
			continue
		if((L in onrush_hit) && !onrush_double_hit)
			continue
		if(L == target)
			continue
		valid_targets += L

	if(!LAZYLEN(valid_targets))
		can_act = TRUE
		onrush_hit = list()
		return

	var/mob/living/L = pick(valid_targets)
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(L), L)
	animate(D, alpha = 0, transform = matrix()*1.2, time = 3)
	face_atom(L)
	addtimer(CALLBACK(src, PROC_REF(OnRush), L, iteration + 1), rand(onrush_min_delay, onrush_max_delay))

// Slams the area with the sleigh, doing heavy damage
/mob/living/simple_animal/hostile/abnormality/rudolta_buff/proc/SleighSlam(atom/target)
	if(!can_act || slam_cooldown > world.time)
		return

	can_act = FALSE
	slam_cooldown = world.time + slam_cooldown_time

	var/turf/T = get_turf(target)
	playsound(src, 'sound/abnormalities/apocalypse/swing.ogg', 75, TRUE)
	var/obj/effect/sled/S = new (T)
	S.alpha = 0
	S.pixel_y = 128
	animate(S, alpha = 255, pixel_y = 0, time = 3)
	var/datum/beam/B = src.Beam(S, "sled", time = 10)
	animate(B.visuals, alpha = 0, time = 10)

	SLEEP_CHECK_DEATH(5)

	var/list/been_hit = list()
	playsound(get_turf(src), 'sound/abnormalities/mountain/slam.ogg', 75, TRUE, 7)
	for(var/turf/TF in range(3, T))
		if(TF.density)
			continue
		new /obj/effect/temp_visual/small_smoke/halfsecond(TF)
		been_hit = HurtInTurf(TF, been_hit, slam_damage, RED_DAMAGE, null, TRUE, FALSE, TRUE, TRUE, src, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
	for(var/mob/living/L in been_hit)
		if(L.health < 0)
			L.gib()

	SLEEP_CHECK_DEATH(3)

	can_act = TRUE

/* Work stuff */
/mob/living/simple_animal/hostile/abnormality/rudolta_buff/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return
