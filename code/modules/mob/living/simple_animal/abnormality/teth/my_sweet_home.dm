//Brain go brrrr.
/mob/living/simple_animal/hostile/abnormality/my_sweet_home
	name = "甜蜜之家"
	desc = "这个舒适的小房子是专为你建造的安全巢穴，一切都为你准备好了..."
	icon = 'ModularTegustation/Teguicons/96x64.dmi'
	icon_state = "sweet_home"
	icon_living = "sweet_home"
	icon_dead = "sweet_home"
	core_icon = "sweet_home"
	portrait = "my_sweet_home"
	var/can_act = TRUE
	threat_level = TETH_LEVEL
	can_breach = TRUE
	del_on_death = FALSE
	maxHealth = 280
	health = 280
	move_to_delay = 5
	damage_coeff = list(RED_DAMAGE = 0.9, WHITE_DAMAGE = 0.9, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	melee_damage_lower = 6
	melee_damage_upper = 8
	rapid_melee = 0.6//slow
	melee_reach = 3//But has long range
	melee_damage_type = RED_DAMAGE
	melee_queue_distance = 3
	retreat_distance = 0
	minimum_distance = 0
	stat_attack = CONSCIOUS
	attack_verb_continuous = "stomps"
	attack_verb_simple = "stomp"
	death_message = "crumbles."
	faction = list("hostile")

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 40, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = list(40, 40, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(70, 70, 80, 80, 90),
		ABNORMALITY_WORK_REPRESSION = list(60, 60, 50, 40, 40),
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/envy

	ego_list = list(
		/datum/ego_datum/weapon/hearth,
		/datum/ego_datum/armor/hearth,
	)
	gift_type =  /datum/ego_gifts/hearth
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	observation_prompt = "\"我是一个家.\" <br>\
		一个快乐的小家，只为你而存在. <br>\
		一个远离这恐怖房间的完美安全之地. <br>\
		一切都为你准备. <br>\
		你不想进来吗?"
	observation_choices = list(
		"不要进去" = list(TRUE, "有些事情好得令人难以置信.<br>\
			你从门垫下拿走钥匙，离开了."),
		"进去" = list(FALSE, "一把钥匙出现在你手中.<br>\
			你准备开门.<br>\
			但在最后一刻，你被另一名员工拉到安全地带."),
	)

	var/ranged_damage = 10
	var/damage_dealt = 0
	var/list/attach_once = list()
	var/list/attach_twice = list()
	var/slam_cooldown = 10 SECONDS
	var/slam_cooldown_time
	var/mob/living/carbon/human/resident = null //Who's currently living inside my sweet home?
	var/someone_entering = FALSE
	var/list/longhair = list(
		"Floorlength Bedhead",
		"Long Side Part",
		"Long Bedhead",
		"Drill Hair (Extended)",
		"Long Hair 2",
		"Silky",
	)

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/ObservationResult(mob/living/carbon/human/user, success, reply)
	. = ..()
	var/static/gave_weapon = FALSE
	if(success)
		if(!gave_weapon)
			gave_weapon = TRUE
			new /obj/item/ego_weapon/home/(get_turf(user))


/mob/living/simple_animal/hostile/abnormality/my_sweet_home/Moved()
	. = ..()
	if(!(status_flags & GODMODE)) // This thing's big, it should make some noise.
		playsound(get_turf(src), 'sound/abnormalities/sweethome/walk.ogg', 50, 1)

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/FailureEffect(mob/living/carbon/human/user, work_type, pe, canceled)
	. = ..()
	if(canceled)
		return
	to_chat(user, span_danger("它在你的脑海中低语..."))
	user.Stun(1 SECONDS)
	SLEEP_CHECK_DEATH(5)
	if(prob(50))
		to_chat(user, span_danger("...而你接受了."))
		Approach(user)
	else
		to_chat(user, span_danger("...你几乎同意，但在最后一刻拒绝了."))
	return

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/AttemptWork(mob/living/carbon/human/user, work_type)
	if(!someone_entering)
		return ..()

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time) //grabbed from FAN
	if(user.sanity_lost)
		Approach(user)
		return
	if(work_type == ABNORMALITY_WORK_ATTACHMENT)
		if(user in attach_twice)
			Approach(user)
			return
		else if(user in attach_once)
			attach_twice+=user
			attach_once-=user
			to_chat(user, span_danger("它在你的脑海中说话，安抚着你，你感到安全."))
		else
			attach_once+=user
			RegisterSignal(user, COMSIG_WORK_STARTED, PROC_REF(OnAbnoWork))
	return

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/proc/OnAbnoWork(datum/source, datum/abnormality/abno_datum, mob/user, work_type)
	SIGNAL_HANDLER
	if (abno_datum == datum_reference) // They worked on us!
		return FALSE
	if (user in attach_twice)
		attach_twice -= user
		attach_once += user
		return FALSE
	else if (user in attach_once)
		attach_once -= user
		UnregisterSignal(user, COMSIG_WORK_STARTED)
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/proc/Approach(mob/living/carbon/human/user)
	if(IsAgentDead(user))
		return
	someone_entering = TRUE
	if(user.sanity_lost)
		QDEL_NULL(user.ai_controller)
	user.Stun(5 SECONDS)
	sleep(0.5 SECONDS)
	if(IsAgentDead(user))
		someone_entering = FALSE
		return
	to_chat(user, span_danger("你握住钥匙，走向门口."))
	step_towards(user, src)
	sleep(0.5 SECONDS)
	if(IsAgentDead(user))
		someone_entering = FALSE
		return
	step_towards(user, src)
	sleep(0.5 SECONDS)
	if(IsAgentDead(user))
		someone_entering = FALSE
		return
	playsound(get_turf(src), 'sound/machines/door_open.ogg', 50, 1)
	to_chat(user, span_danger("你打开门，然后..."))
	sleep(0.5 SECONDS)
	someone_entering = FALSE
	if(IsAgentDead(user))
		return
	playsound(get_turf(src), 'sound/effects/alertbeep.ogg', 50, FALSE)
	BreachEffect(user)

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/proc/IsAgentDead(mob/living/carbon/human/user)
	if(QDELETED(user))
		return TRUE
	if(user.stat >= SOFT_CRIT)
		if(user.sanity_lost)
			user.adjustSanityLoss(-user.maxSanity)//We restore their sanity so they don't stand there like a dumbass after removing their panic ai
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/proc/AoeAttack()
	damage_dealt = 0
	var/list/hit_turfs = list()
	var/turf/target_turf = get_turf(src)
	for(var/turf/open/T in view(target_turf, 3))
		hit_turfs |= T
		for(var/mob/living/L in HurtInTurf(T, list(), ranged_damage, RED_DAMAGE, hurt_mechs = TRUE))
			if((L.stat < DEAD) && !(L.status_flags & GODMODE))
				damage_dealt += ranged_damage
	if(damage_dealt > 0)
		slam_cooldown_time = world.time + slam_cooldown
		for(var/turf/T in hit_turfs)
			new /obj/effect/temp_visual/smash_effect(T)
		playsound(get_turf(src), 'sound/abnormalities/sweethome/smash.ogg', 50, 1)

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/Move()
	if(slam_cooldown_time < world.time)
		AoeAttack()
	return ..()

/obj/effect/temp_visual/smash1
	icon = 'icons/effects/effects.dmi'
	icon_state = "smash1"
	duration = 3

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/BreachEffect(mob/living/carbon/human/user, breach_type)//code grabbed from scorched_girl
	if(!user && breach_type == BREACH_NORMAL)
		return
	. = ..()
	update_icon_state()
	desc = "一个巨大的、形影绰绰的身影，显然太大了，根本无法进入他们所住的小屋."
	pixel_x = -16
	base_pixel_x = -16
	icon_state = "sweet_home_breach"
	if(user)
		desc = "一个巨大的、形影绰绰的身影，显然太大了，根本无法进入他们所住的小... 等等，那是[user]吗?"
		resident = user
		user.forceMove(src)
		user.death()
		var/hair_icon = "sweet_home_breach_hair"
		if(user.hairstyle in longhair)
			hair_icon = "sweet_home_breach_longhair"
		var/mutable_appearance/skin_overlay = mutable_appearance(icon, "sweet_home_breach_skin", layer + 0.1)
		var/mutable_appearance/eye_overlay = mutable_appearance(icon, "sweet_home_breach_eye", layer + 0.2)
		var/mutable_appearance/hair_overlay = mutable_appearance(icon, hair_icon, layer + 0.3)
		if(user.skin_tone)
			skin_overlay.color = "#[skintone2hex(user.skin_tone)]"
		if(user.eye_color)
			eye_overlay.color = "#[user.eye_color]"
		if(user.hair_color)
			hair_overlay.color = "#[user.hair_color]"
		add_overlay(skin_overlay)
		add_overlay(eye_overlay)
		if(user.hairstyle != "Bald")
			add_overlay(hair_overlay)
	else
		melee_damage_lower = 4
		melee_damage_upper = 6
		ranged_damage = 7
		maxHealth = 230
		health = 230

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/death(gibbed)
	density = FALSE
	cut_overlays()
	icon_state = "sweet_home"
	pixel_x = 0
	base_pixel_x = 0
	animate(src, time = 10 SECONDS, alpha = 0)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/my_sweet_home/Destroy()
	attach_twice = null
	attach_once = null
	if(!resident)
		return ..()
	//I know the body inside home goes back in when it dies in wonderlab, but we should probably just return the guy/girl instead
	resident.forceMove(get_turf(src))
	resident.gib()//Poor fucker got crushed.
	resident = null
	return ..()
