GLOBAL_LIST_EMPTY(meat_list)

/mob/living/simple_animal/hostile/abnormality/last_shot
	name = "直到最后一枪"
	desc = "一个巨大的肉球，慢慢地跳动着."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "last_shot"
	core_icon = "last_shot"
	portrait = "last_shot"
	pixel_x = -8
	base_pixel_x = -8
	maxHealth = 2200
	health = 2200
	threat_level = ALEPH_LEVEL

	work_chances = list( //Calculated later
		ABNORMALITY_WORK_INSTINCT = 55,
		ABNORMALITY_WORK_INSIGHT = 15,
		ABNORMALITY_WORK_ATTACHMENT = list(50, 40, 0, 0, 0),
		ABNORMALITY_WORK_REPRESSION = 40,
	)

	work_damage_upper = 9
	work_damage_lower = 7
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/last_shot
	harvest_phrase = span_notice("你从%ABNO 周围的地板上剥下一些腐烂的肉，然后把它们收集在%VESSEL 里.")
	harvest_phrase_third = "%PERSON 收集了%ABNO 产生的腐烂血肉."
	max_boxes = 27
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	start_qliphoth = 2
	can_breach = TRUE	//can't move so you know

	ego_list = list(
		/datum/ego_datum/weapon/willing,
		/datum/ego_datum/armor/willing,
	)
	gift_type = /datum/ego_gifts/willing

	observation_prompt = "房间里弥漫这糜烂与血的气味. <br>在这里的每一刻都让你头痛欲裂. <br>\
		\"注意!\" <br>房间中央的肉团在呼唤你. <br>\
		\"你活不下来的. <br>在这里每天都是一场无休止的战斗.\" <br>\
		\"你唯一活下来的方法就是加入我. <br>为L公司奉献至最后一口气.\" <br>\
		一根腐烂的卷须向你伸出，招手要你加入它."
	observation_choices = list(
		"握住它" = list(TRUE, "你握住卷须. 你感到手上刺痛. <br>\
			\"明智的选择.\" <br>\
			\"别担心. <br>你不会后悔的, 你知道吗? <br>这是你唯一可走的路.\" <br>\
			\"你在那里将会是一块死肉. <br>还是接受真实的自己吧.\""),
		"拒绝它" = list(FALSE, "你拍开卷须. <br>\
			\"好吧. <br>这样是吧. <br>你在那里活不下去的, 你知道的吧?\" <br>\
			\"所有的员工迟早只会变成一具腐烂的尸体, 只有像我一样才能维系自身. <br>你明白自己放弃了什么吧?\" <br>\
			当你离开收容单元，禁不住厌恶地打了个寒颤. <br>这样做真的对吗? 你永远也不会知道了."),
	)

	var/list/gremlins = list()	//For the meatballs
	var/list/meat = list()		//For the floors

	var/spawn_cooldown
	var/spawn_cooldown_time = 30 SECONDS	//Spawns 2 goobers every 30 seconds and spreads vines
	var/spawn_number = 2
	var/meat_reach = 3


/mob/living/simple_animal/hostile/abnormality/last_shot/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/last_shot/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_MINING)
		return ..()
	var/turf/T = pick(GLOB.department_centers)
	forceMove(T)
	..()

/mob/living/simple_animal/hostile/abnormality/last_shot/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/last_shot/PostSpawn()
	..()
	for(var/turf/open/O in range(1, src))
		new /obj/structure/meatfloor (O)

/mob/living/simple_animal/hostile/abnormality/last_shot/WorkChance(mob/living/carbon/human/user, chance)
	//Sorry bucko, give into the pleasures of flesh. Bonuses for low temp
	var/newchance = chance
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) <= 80)
		newchance += 20
	else if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) >= 100)
		newchance -= 10

	work_damage_lower = initial(work_damage_lower)
	work_damage_upper = initial(work_damage_upper)

	//Fort or justice too low? take more damage.
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) < 100)
		work_damage_lower += 3
		work_damage_upper += 3
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 100)
		work_damage_lower += 3
		work_damage_upper += 3
	return newchance

/mob/living/simple_animal/hostile/abnormality/last_shot/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return


/mob/living/simple_animal/hostile/abnormality/last_shot/Life()
	. = ..()
	if(!.)
		return FALSE
	if((spawn_cooldown < world.time) && !(status_flags & GODMODE))
		spawn_cooldown = world.time + spawn_cooldown_time
		MeatSpawn()
		MeatSpread() //Deliberately called after meatspawn(), so that barriers don't instantly appear

/mob/living/simple_animal/hostile/abnormality/last_shot/proc/MeatSpawn()
	var/gunnerchance = (100 / meat_reach) //Less likely to get gunners later on
	for(var/i=spawn_number, i>=1, i--)	//This counts down. - Spawn meat guards
		if(prob(gunnerchance))
			var/mob/living/simple_animal/hostile/aminion/meatblob/gunner/G = new(get_turf(src))
			gremlins+=G
			continue
		if(prob(gunnerchance))
			var/mob/living/simple_animal/hostile/aminion/meatblob/gunner/sniper/S = new(get_turf(src))
			gremlins+=S
			continue
		if(prob(gunnerchance))
			var/mob/living/simple_animal/hostile/aminion/meatblob/gunner/shotgun/SG = new(get_turf(src))
			gremlins+=SG
			continue
		else
			var/mob/living/simple_animal/hostile/aminion/meatblob/V = new(get_turf(src))
			gremlins+=V

	for(var/turf/open/L in view(7, src)) //Spawn barricades on meat
		if((get_dist(src, L) % 2 != 1))
			continue
		if(!IsSafeTurf(L))
			continue
		if(!locate(/obj/structure/meatfloor) in L) //No floor for the barricade
			continue
		if(locate(/obj/structure/barricade/meatbags) in L) //There's already a barricade there
			continue
		if(prob(100 - (10 * get_dist(src, L)))) //Less likely to spawn the further away it is
			new /obj/structure/barricade/meatbags(L)

	var/guards_count = 0 //How many armed blobs do we have nearby?
	for(var/mob/living/simple_animal/hostile/aminion/meatblob/theblob in range(meat_reach, src))
		if(!is_type_in_list(theblob, subtypesof(/mob/living/simple_animal/hostile/aminion/meatblob))) //It's unarmed
			continue
		if(theblob.can_patrol)
			continue
		guards_count += 1
		if(guards_count > 2) //We have enough guards
			theblob.can_patrol = TRUE //Send the rest out
	return

/mob/living/simple_animal/hostile/abnormality/last_shot/proc/MeatSpread() //THE ROT CONSUMES ALL
	for(var/turf/L in range(meat_reach, src)) //Spread out meat like a blob does
		if(!isturf(L) || isspaceturf(L))
			continue
		if(locate(/obj/structure/meatfloor) in L)
			continue
		new /obj/structure/meatfloor(L)
	meat_reach = clamp(meat_reach + 1, 0, 10) //MEAT!!!!!

/mob/living/simple_animal/hostile/abnormality/last_shot/death()
	for(var/V in gremlins)
		QDEL_NULL(V)
		gremlins-=V

	for(var/Y in GLOB.meat_list)
		QDEL_NULL(Y)
		GLOB.meat_list-=Y
	..()

//////////////
//STRUCTURES//
//////////////

// The MEAT FLOOR
/obj/structure/meatfloor
	gender = PLURAL
	name = "血肉"
	desc = "some seemingly rotten meat."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "meatvine"
	anchored = TRUE
	density = FALSE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	base_icon_state = "meatvine"

/obj/structure/meatfloor/Initialize()
	. = ..()
	GLOB.meat_list += src

/obj/structure/meatfloor/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(prob(25))
			H.Immobilize(5)
			to_chat(H, span_warning("你的脚被肉须缠住了!"))

/obj/structure/barricade/meatbags
	name = "肉路障"
	desc = "Bags of meat. Weird, but self explanatory."
	icon = 'icons/obj/smooth_structures/sandbags.dmi'
	icon_state = "meatbags-0"
	base_icon_state = "meatbags"
	max_integrity = 300
	density = FALSE //non-human mobs can pass through
	proj_pass_rate = 50
	pass_flags_self = LETPASSTHROW
	bar_material = 3 //Didnt want to make a meat bar_material, thankfully this one does nothing
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_SANDBAGS)
	canSmoothWith = list(SMOOTH_GROUP_SANDBAGS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_SECURITY_BARRICADE)
	can_buckle = TRUE //For climbing code
	max_buckled_mobs = 1
	color = COLOR_DARK_RED
	var/list/punchthrough = list(
	/obj/projectile/bonebullet,
	/obj/projectile/bonebullet/bonebullet_piercing
	)

/obj/structure/barricade/meatbags/Initialize()
	. = ..()
	GLOB.meat_list += src

/obj/structure/barricade/meatbags/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(ishuman(mover))
		return FALSE
	if(ismecha(mover))
		return FALSE
	if(is_type_in_list(mover, punchthrough))
		return TRUE
	return ..()

//I didn't want to rewrite the entire climbable datum so now climbing is hardcoded
/obj/structure/barricade/meatbags/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if (!istype(M, /mob/living/carbon/human))
		to_chat(usr, span_warning("你不需要这个."))
		return
	if(M != user)
		to_chat(user, span_warning("你开始把[M]拉过墙."))
		if(do_after(user, 1.5 SECONDS)) //If you're going to throw someone else, they have to be dead first.
			M.forceMove(get_turf(src))
		return

	to_chat(user, span_warning("你开始翻墙."))
	if(!do_after(user, 1.5 SECONDS))
		to_chat(user, span_notice("你决定不翻了."))
		return
	M.forceMove(get_turf(src))
	return

////////
//MOBS//
////////

//They mostly are supposed to be slow goobers
/mob/living/simple_animal/hostile/aminion/meatblob
	name = "肉球"
	desc = "扭动的肉球，形状有点像人. 这只没有武器."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "meatboi"
	icon_living = "meatboi"
	faction = list("hostile")
	health = 340
	maxHealth = 340
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	melee_damage_lower = 5
	melee_damage_upper = 10
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	attack_verb_continuous = "glomps"
	attack_verb_simple = "glomps"
	attack_sound = 'sound/effects/attackblob.ogg'
	speak_emote = list("gargles")
	move_to_delay = 4.5
	can_patrol = TRUE //The stronger blobs use commander AI, these will wander if alone.
	threat_level = HE_LEVEL // A neat reference to how Ttls was a he at one point
	score_divider = 16//Worth fuck all since its an aleph

/mob/living/simple_animal/hostile/aminion/meatblob/Move()
	..()
	if(!isturf(loc) || isspaceturf(loc))
		return
	if(locate(/obj/structure/meatfloor) in get_turf(src))
		return
	new /obj/structure/meatfloor(loc)

/mob/living/simple_animal/hostile/aminion/meatblob/gunner
	name = "抑制肉球"
	desc = "扭动的肉球，形状有点像人. 这只有把步枪."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "meatboi_rifle"
	icon_living = "meatboi_rifle"
	health = 150
	maxHealth = 150
	melee_damage_lower = 7
	melee_damage_upper = 9
	ranged = 1
	retreat_distance = 3
	minimum_distance = 4
	projectiletype = /obj/projectile/bonebullet
	rapid = 4
	rapid_fire_delay = 0.8
	projectilesound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	can_patrol = FALSE //They're sent out in waves
	var/guntimer //takes time to reload after 20 shots
	var/can_act = TRUE
	var/reload_time = 15
	var/remaining_bullets = 20
	var/maximum_bullets = 20
	var/reload_sound = 'sound/weapons/gun/general/bolt_rack.ogg'

/mob/living/simple_animal/hostile/aminion/meatblob/gunner/Initialize(mapload)
	..()
	var/units_to_add = list(
		/mob/living/simple_animal/hostile/aminion/meatblob = 1,
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 3, TRUE, TRUE)

/mob/living/simple_animal/hostile/aminion/meatblob/gunner/OpenFire(atom/A)
	if(!can_act)
		return FALSE
	if(get_dist(src, A) < 2) // We can't fire normal ranged attack if we're too busy trying to run away
		return FALSE
	. = ..()
	if(remaining_bullets >= 0)
		can_act = FALSE
		guntimer = addtimer(CALLBACK(src, PROC_REF(FinishReload)), (reload_time), TIMER_STOPPABLE)
		remaining_bullets = maximum_bullets
		playsound(get_turf(src), "[reload_sound]", 50, FALSE)

/mob/living/simple_animal/hostile/aminion/meatblob/gunner/Shoot()
	. = ..()
	remaining_bullets -= 1

/mob/living/simple_animal/hostile/aminion/meatblob/gunner/proc/FinishReload()
	can_act = TRUE
	deltimer(guntimer)

/mob/living/simple_animal/hostile/aminion/meatblob/gunner/Move()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/aminion/meatblob/gunner/AttackingTarget()
	if(!can_act)
		return FALSE
	..()


/mob/living/simple_animal/hostile/aminion/meatblob/gunner/shotgun
	name = "开拓肉球"
	desc = "扭动的肉球，形状有点像人. 这只有把霰弹枪."
	icon_state = "meatboi_shotgun"
	icon_living = "meatboi_shotgun"
	health = 300
	maxHealth = 300
	melee_damage_lower = 10
	melee_damage_upper = 15
	projectiletype = null
	casingtype = /obj/item/ammo_casing/caseless/last_shot
	rapid = 1
	projectilesound = 'sound/weapons/gun/shotgun/shot_auto.ogg'
	remaining_bullets = 1
	maximum_bullets = 1
	reload_time = 5
	reload_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'

/mob/living/simple_animal/hostile/aminion/meatblob/gunner/sniper
	name = "畏缩肉球"
	desc = "扭动的肉球，形状有点像人. 这只有把狙击步枪."
	icon_state = "meatboi_sniper"
	icon_living = "meatboi_sniper"
	health = 100
	maxHealth = 100
	retreat_distance = 5
	minimum_distance = 4
	projectiletype = /obj/projectile/bonebullet/bonebullet_piercing
	rapid = 1
	projectilesound = 'sound/weapons/gun/sniper/shot.ogg'
	remaining_bullets = 1
	maximum_bullets = 1
	reload_time = 30
	var/datum/beam/current_beam = null

/mob/living/simple_animal/hostile/aminion/meatblob/gunner/sniper/OpenFire(atom/A)
	if(!can_act)
		return
	if(PrepareToFire(A))
		return ..()
	return FALSE

/mob/living/simple_animal/hostile/aminion/meatblob/gunner/sniper/proc/PrepareToFire(atom/A)
	current_beam = Beam(A, icon_state="blood", time = 3 SECONDS)
	can_act = FALSE
	SLEEP_CHECK_DEATH(30)
	if(!(A in view(9, src)))
		can_act = TRUE
		return FALSE
	can_act = TRUE
	return TRUE

/datum/reagent/abnormality/last_shot
	name = "肉苔藓"
	description = "It reeks to high hell. Protects your body and emboldens your Fortitude."
	metabolization_rate = 0.8 * REAGENTS_METABOLISM
	color = "#3D0004"
	stat_changes = list(10, 0, 0, 0)
	damage_mods = list(0.8, 1, 1, 1) //Improves your fort and red resistance. It's an ALEPH so I feel like its chem being strong is fair.

