//Coded by Coxswain
/mob/living/simple_animal/hostile/abnormality/cinderella
	name = "灰姑娘的南瓜马车"
	desc = "一辆装饰着金色装饰的漂亮南瓜马车."
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "cinderella_1"
	icon_living = "cinderella_1"
	portrait = "cinderella"
	maxHealth = 200
	health = 200
	start_qliphoth = 1
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 35,
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 35,
		ABNORMALITY_WORK_REPRESSION = 20
	)
	pixel_x = -16
	base_pixel_x = -16
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/lust
	ego_list = list(
			/datum/ego_datum/weapon/curfew,
			/datum/ego_datum/armor/curfew
	)
	gift_type = /datum/ego_gifts/curfew
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	observation_prompt = "(你坐着等待。)<br>\
		地面坚实稳固。<br>\
		(你坐着等待。)<br>\
		美丽的金发女孩正亲吻她的王子。<br>\
		(你坐着等待。)<br>\
		王子与他未来的王妃正离你而去，连仙女教母也已抛弃你。<br>\
		(你坐着等待。)<br>\
		腐朽已侵蚀你曾经鲜活的橙黄身躯，车轮在风雨侵蚀下扭曲变形。<br>\
		(你坐着等待。)<br>\
		你不再需要我了吗？难道不是我带你度过生命中最幸福的夜晚吗？<br>\
		(你坐着...)"
	observation_choices = list(
		"回想起那个夜晚" = list(TRUE, "是啊，那曾是我们生命中最幸福的夜晚...<br>\
			(你的躯体重焕光彩，车轮开始自我修复。)<br>\
			让我们回到那个奇妙而魔幻的夜晚吧..."),
		"你坐着等待" = list(FALSE, "她可能还需要我，我要等到被召唤为止。<br>\
			(你的身躯化为灰暗，没人会需要如此可憎的马车。)"),
	)

	var/freshness = 0
	//Breach stuff
	var/maxSegments = 1
	var/list/segments = list()
	var/list/damaged = list()
	var/already_breached

/mob/living/simple_animal/hostile/abnormality/cinderella/examine(mob/user)
	. = ..()
	var/freshness_state = "腐烂"
	switch(freshness)
		if(4 to 6)
			freshness_state = "破旧"
		if(7  to 10)
			freshness_state = "崭新"
	. += "它看起来是[freshness_state]的"

//Work mechanics
/mob/living/simple_animal/hostile/abnormality/cinderella/AttemptWork(mob/living/carbon/human/user, work_type)
	if(already_breached)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/cinderella/WorkChance(mob/living/carbon/human/user, chance)
	chance += freshness * 2.5
	return chance

/mob/living/simple_animal/hostile/abnormality/cinderella/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_INSIGHT)
		freshness = clamp(freshness + 3, 0, 10)
		if(freshness >= 10)
			datum_reference.qliphoth_change(-1)
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		freshness = clamp(freshness - 1, 0, 10)
	update_icon_state()

/mob/living/simple_animal/hostile/abnormality/cinderella/update_icon_state()
	if(!freshness)
		icon_state = "cinderella_1"
	else
		icon_state = "cinderella_[clamp(max(1, ceil(freshness / 3)), 1,3)]" //gets a number from 1-3 from the freshness
	icon_living = icon_state

//Breach code. Warning: Compliated
/mob/living/simple_animal/hostile/abnormality/cinderella/ZeroQliphoth(mob/living/carbon/human/user)
	if(already_breached)
		return
	if(freshness < 10)
		freshness = clamp(freshness + 3, 0, 10)
		datum_reference.qliphoth_change(1)
		update_icon_state()
		return
	already_breached = TRUE
	GoToTheBall()
	animate(src, alpha = 0, time = 3 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(death)), 45 SECONDS)

/mob/living/simple_animal/hostile/abnormality/cinderella/proc/GoToTheBall()
	for(var/mob/living/M in damaged)
		damaged -= M
	var/turf/aimTurf = pick(GLOB.department_centers)
	FireCarriage(aimTurf.y, pick(EAST, WEST), aimTurf.z)

//Yeah, I just copied this from express train; even these slight modifications were a real headache.
/mob/living/simple_animal/hostile/abnormality/cinderella/proc/FireCarriage(aimpoint, direction = pick(EAST, WEST), aimZ = src.z)
	var/spawnX
	if(direction == EAST)
		spawnX = 42
	else
		spawnX = 214
	var/spawnPoint = locate(spawnX, aimpoint, aimZ)
	var/obj/effect/cinderella/seg = new(spawnPoint)
	seg.dir = direction
	seg.icon_state = "cinderella_1"
	notify_ghosts("[seg]正准备启程!", source = seg, action = NOTIFY_ORBIT, header="有趣的事情!") // bless this mess
	segments += seg
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(sound_to_playing_players), 'sound/abnormalities/cinderella/bell.ogg', 50), 1)
	addtimer(CALLBACK(src, PROC_REF(MoveCarriage)), 10 SECONDS)

/mob/living/simple_animal/hostile/abnormality/cinderella/proc/MoveCarriage()
	if(LAZYLEN(src.segments))
		addtimer(CALLBACK(src, PROC_REF(MoveCarriage)), 0.5)
		for(var/obj/effect/cinderella/seg in segments)
			if((seg.x < 10 && seg.dir == WEST) || (seg.x > 245 && seg.dir == EAST))
				QDEL_IN(seg, 1)
				src.segments -= seg
			else
				seg.forceMove(get_step(seg, seg.dir))
		DamageTiles()

/mob/living/simple_animal/hostile/abnormality/cinderella/proc/DamageTiles()
	for(var/obj/effect/cinderella/seg in segments)
		var/list/coveredTurfs = list()
		for(var/i = -1, i < 4, i++)
			for(var/j = -1, j < 3, j++)
				var/turf/T = locate(seg.x + i, seg.y + j, seg.z)
				coveredTurfs |= T
		for(var/turf/T in coveredTurfs)
			for(var/mob/living/M in T.contents)
				if(M in src.damaged)
					continue
				src.damaged += M
				if(!seg.noise)
					if(rand())
						playsound(get_turf(seg), 'sound/abnormalities/cinderella/horse1.ogg', 100, 0, 40)
					else
						playsound(get_turf(seg), 'sound/abnormalities/cinderella/horse2.ogg', 100, 0, 40)
					seg.noise = 1
				M.deal_damage(20, WHITE_DAMAGE)
				if(ishuman(M))
					var/mob/living/carbon/human/C = M
					if(C.sanity_lost)
						QDEL_NULL(C.ai_controller)
						C.ai_controller = /datum/ai_controller/insane/wander/penitence //Yeah, we're just copying penitent girl's panic. I'm sure no one will notice.
						C.InitializeAIController()
						C.apply_status_effect(/datum/status_effect/panicked_type/wander/penitence)
