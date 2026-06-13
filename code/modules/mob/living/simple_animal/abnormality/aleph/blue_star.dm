/mob/living/simple_animal/hostile/abnormality/bluestar
	name = "碧蓝新星"
	desc = "漂浮的心形物体. 它是活的, 而你很快就会和它融为一体."
	health = 2200
	maxHealth = 2200
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -16
	base_pixel_y = -16
	offsets_pixel_x = list("south" = -32, "north" = -32, "west" = -32, "east" = -32)
	offsets_pixel_y = list("south" = -16, "north" = -16, "west" = -16, "east" = -16)
	occupied_tiles_up = 1
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "blue_star"
	icon_living = "blue_star"
	icon_dead = "blue_star_dead"
	portrait = "blue_star"
	damage_coeff = list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.2)
	is_flying_animal = TRUE
	del_on_death = FALSE
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 30,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = 40,
	)
	work_damage_upper = 9
	work_damage_lower = 6
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gloom
	max_boxes = 33
	can_patrol = FALSE

	wander = FALSE
	light_color = COLOR_BLUE_LIGHT
	light_range = 36
	light_power = 20

	del_on_death = FALSE

	ego_list = list(
		/datum/ego_datum/weapon/star_sound,
		/datum/ego_datum/armor/star_sound,
	)
	gift_type =  /datum/ego_gifts/star
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "一群员工崇拜着这个异想体，尽管此地不可能存在神圣之物。<br>\
		你回忆起过去曾将一名员工从它身边拖走，即使她尖叫哭喊说你将她束缚在了这个世界。<br>你以为自己是在救她。<br>\
		你能听到碧蓝之心中心传来遥远的嚎叫声。<br>那是星星的声音。<br>它们正在欢迎你，邀请你成为一颗星星加入它们。"
	observation_choices = list(
		"被吸入" = list(TRUE, "你毫不犹豫地接近虚空中心。<br>手脚的感觉最先消失，逐渐蔓延全身直到完全失去所有身体感知。<br>\
			尽管本应感到恐惧，你却觉得平静，<br>这不是结束而是新的开始——你是一名殉道者。<br>\
			让我们以星星的形式再次相见。"),
		"抱紧自己" = list(FALSE, "你双臂紧抱自己并闭上眼睛，将感官向内收敛直到诱惑过去，声音重新变成遥远的嚎叫。<br>\
			你睁开眼睛再次看向心脏。<br>它仍然悬在空中，向着新的开始漂浮。"),
	)

	var/pulse_cooldown
	var/pulse_cooldown_time = 8 SECONDS
	var/pulse_damage = 30 // Scales with distance; Ideally, you shouldn't be able to outheal it with white V armor or less

	var/datum/looping_sound/bluestar/soundloop

/mob/living/simple_animal/hostile/abnormality/bluestar/Initialize()
	. = ..()
	soundloop = new(list(src), FALSE)

/mob/living/simple_animal/hostile/abnormality/bluestar/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/mob/living/simple_animal/hostile/abnormality/bluestar/death(gibbed)
	QDEL_NULL(soundloop)
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/bluestar/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/bluestar/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((pulse_cooldown < world.time) && !(status_flags & GODMODE))
		BluePulse()

/mob/living/simple_animal/hostile/abnormality/bluestar/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/bluestar/proc/BluePulse()
	pulse_cooldown = world.time + pulse_cooldown_time
	playsound(src, 'sound/abnormalities/bluestar/pulse.ogg', 100, FALSE, 40, falloff_distance = 10)
	var/matrix/init_transform = transform
	animate(src, transform = transform*1.5, time = 3, easing = BACK_EASING|EASE_OUT)
	for(var/mob/living/L in livinginrange(48, src))
		if(L.z != z)
			continue
		if(faction_check_mob(L))
			continue
		var/falloff = (0.3 * (get_dist(src, L)))//1 damage for every 3 tiles
		L.deal_damage(pulse_damage - falloff, WHITE_DAMAGE)
		flash_color(L, flash_color = COLOR_BLUE_LIGHT, flash_time = 70)
		if(!ishuman(L))
			continue
		var/mob/living/carbon/human/H = L
		if(H.sanity_lost) // TODO: TEMPORARY AS HELL
			H.death(TRUE)
			animate(H, transform = H.transform*0.01, time = 5)
			QDEL_IN(H, 5)
	SLEEP_CHECK_DEATH(3)
	animate(src, transform = init_transform, time = 5)

/mob/living/simple_animal/hostile/abnormality/bluestar/AttemptWork(mob/living/carbon/human/user, work_type)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 80)
		datum_reference.qliphoth_change(-1)
		playsound(src, 'sound/abnormalities/bluestar/pulse.ogg', 25, FALSE, 28)
		user.death()
		animate(user, transform = user.transform*0.01, time = 5)
		QDEL_IN(user, 5)
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/bluestar/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 100)
		datum_reference.qliphoth_change(-1)
	if(user.sanity_lost)
		datum_reference.qliphoth_change(-1)
	if(work_time > 40 SECONDS)
		datum_reference.qliphoth_change(-1)
		playsound(src, 'sound/abnormalities/bluestar/pulse.ogg', 25, FALSE, 28)
		user.death()
		animate(user, transform = user.transform*0.01, time = 5)
		QDEL_IN(user, 5)
	return

/mob/living/simple_animal/hostile/abnormality/bluestar/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	var/turf/T = pick(GLOB.department_centers)
	soundloop.start()
	if(breach_type != BREACH_MINING)
		forceMove(T)
	BluePulse()
	return
