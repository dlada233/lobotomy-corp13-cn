/mob/living/simple_animal/hostile/abnormality/schadenfreude
	name = "幸灾乐祸"
	desc = "有锁眼的盒子，你不会想知道里面是什么."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "schadenfreude"
	icon_living = "schadenfreude"
	portrait = "schadenfreude"
	pixel_x = -16
	base_pixel_x = -16
	del_on_death = TRUE
	maxHealth = 800 //It's fucking slow as hell, and you can beat it to death if you're alone for free
	health = 800
	move_to_delay = 5
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.0, PALE_DAMAGE = 1.5)
	melee_damage_lower = 8		//Yeah it's super slow, and you're not gonna get hit by it too often
	melee_damage_upper = 12
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/scarecrow/attack.ogg'
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 4
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(30, 40, 40, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(40, 40, 40, 30, 20),
		ABNORMALITY_WORK_REPRESSION = list(40, 45, 50, 55, 60),
	)
	work_damage_upper = 6
	work_damage_lower = 3
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/wrath
	max_boxes = 18

	ego_list = list(
		/datum/ego_datum/weapon/gaze,
		/datum/ego_datum/armor/gaze,
	)
	gift_type =  /datum/ego_gifts/gaze
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "你戴上眼罩步入收容单元。<br>隔着厚重织物仍能感受到金属盒的凝视。"
	observation_choices = list(
		"摸索墙壁" = list(TRUE, "你转身沿墙摸索，最终寻路返回门口。<br>\
			金属盒终究只是容器，唯有他人注视才能赋予其真实存在。<br>或许你们比想象中更为相似。"),
		"摘下眼罩" = list(FALSE, "你扯下眼罩待视线适应光线，与锁孔中的瞳孔四目相对。<br>\
			盒子骤然化作旋转的锯刃刀丛，而这一切——只为攫取你的注视。"),
	)

	var/seen //Are you being looked at right now?
	var/solo_punish	//Is an agent alone on the Z level, but not overall?
	var/total_players

//Sight Check
/mob/living/simple_animal/hostile/abnormality/schadenfreude/Life()
	. = ..()
	//Make sure there actually are two players on the Z level
	var/living_players
	total_players = 0
	solo_punish = FALSE
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		total_players +=1
		if(H.z == z && H.stat != DEAD)
			living_players +=1
		else if(H.stat != DEAD) //Someone else is alive, just not on the Z level. Probably a manager. Thus, someone else COULD see you...
			solo_punish = TRUE
	if(living_players == 1)
		seen = TRUE
		ChangeResistances(list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.0, PALE_DAMAGE = 1.5))
		return
	solo_punish = FALSE //Reset to normal if the amount of living players on your z-level is something other than 1, to allow normal behavior.

	//Who is watching us
	var/people_watching
	for(var/mob/living/carbon/human/L in viewers(world.view + 1, src))
		if(L.client && CanAttack(L) && L.stat != DEAD)
			if(!L.is_blind())
				people_watching+=1

	//Only gets mad if there are two people looking at you. If there are 3 or more the counter decreases.
	if(people_watching >= 3)
		datum_reference.qliphoth_change(-1)
	if(people_watching == 1)
		seen = FALSE
	else	//any amount of people that's not 1.
		seen = TRUE

//Stuff that needs sight check
/mob/living/simple_animal/hostile/abnormality/schadenfreude/Move()
	if(!seen)
		if(client)
			to_chat(src, span_warning("You cannot move, there are not enough eyes on you!"))
		return FALSE
	..()

/mob/living/simple_animal/hostile/abnormality/schadenfreude/AttackingTarget()
	if(!seen)
		if(client)
			to_chat(src, span_warning("You cannot attack, there are not enough eyes on you!"))
		return FALSE
	..()

//Work stuff
//Too many people looking? Reduce final work success rate to 0.
/mob/living/simple_animal/hostile/abnormality/schadenfreude/ChanceWorktickOverride(mob/living/carbon/human/user, work_chance, init_work_chance, work_type)
	if(seen && !solo_punish && total_players > 1) //If you're only considered "seen" because the other living player(s) are all on another Z level, or there are no other players online at the time, disregard it during work specifically.
		to_chat(user, span_warning("你被[src]伤害了!")) // Keeping it clear that the bad work is from being seen and not just luck.
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(user), pick(GLOB.alldirs))
		return 0
	return init_work_chance

//For when only one person is on the server. The person who works it takes 90 damage minimum per work.
/mob/living/simple_animal/hostile/abnormality/schadenfreude/Worktick(mob/living/carbon/human/user)
	. = ..()
	if(total_players == 1)
		user.apply_damage(1, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)

/mob/living/simple_animal/hostile/abnormality/schadenfreude/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon_living = "schadenfreude_breach"
	icon_state = icon_living
	GiveTarget(user)
