/mob/living/simple_animal/hostile/abnormality/sunset_wayfarer
	name = "日落旅者"
	desc = "一个黄色的生物，周围漂浮着橙色的蝴蝶."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "sunset"
	portrait = "sunset_wayfarer"
	maxHealth = 80
	health = 80
	threat_level = ZAYIN_LEVEL

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 70,
		ABNORMALITY_WORK_INSIGHT = 65,
		ABNORMALITY_WORK_ATTACHMENT = 80,
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	max_boxes = 8
	work_damage_upper = 2
	work_damage_lower = 1
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/lust
	light_color = COLOR_ORANGE
	light_range = 1
	light_power = 1
	environment_smash = FALSE

	ego_list = list(
		/datum/ego_datum/weapon/sunset,
		/datum/ego_datum/armor/sunset,
	)

	gift_type =  /datum/ego_gifts/eclipse
	var/list/saylines = list(
		"大老远跑来这里很累吧？",
		"真的，看看那些蝴蝶	",
		"光是看着它们就会让心里暖洋洋的. ",
	)

	observation_prompt = "\"看看那些蝴蝶！它们多美啊？<br>再看看那日落！真让人想散散步. \"<br>\
		\"何不停下来喘口气？\"<br>\
		某个黄色的存在朝你热情地招手. "
	observation_choices = list(
		"稍作休息" = list(TRUE, "\"大老远跑来这里很累吧？真的，看看那些蝴蝶. <br>\
			光是看着它们就会让心里暖洋洋的. \"<br>\
			你按声音的建议看向蝴蝶，心中确实涌起暖意. <br>\
			\"看来有几只想跟着你呢！\"<br>\
			一群斑斓的蝴蝶开始追随你，即使你离开那片美景后仍在跟随. "),
		"无视并离开" = list(FALSE, "\"你一定很忙吧！\"<br>它重复了初见时的招手动作. <br>\
			或许这动作自始至终都是告别. <br>\
			\"下次再说吧！\""),
	)

	light_color = COLOR_ORANGE
	light_range = 5
	light_power = 7
	var/healing = FALSE

/mob/living/simple_animal/hostile/abnormality/sunset_wayfarer/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(healing)
		return
	new /mob/living/simple_animal/hostile/scarlet_moths(src)
	new /mob/living/simple_animal/hostile/scarlet_moths(src)

/mob/living/simple_animal/hostile/abnormality/sunset_wayfarer/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(pe == 0)
		return
	if(healing)
		return
	Heal(user)

/mob/living/simple_animal/hostile/abnormality/sunset_wayfarer/proc/Heal(mob/living/carbon/human/user)
	set waitfor = FALSE
	healing = TRUE
	say("看看这些蝴蝶！它们真漂亮不是吗?")
	SLEEP_CHECK_DEATH(15)
	say("再看看那夕阳！真的让你想去散步.")
	SLEEP_CHECK_DEATH(15)
	say("你为什么不停下来歇一会呢?")
	while(PlayerCheck(user))
		for(var/mob/living/carbon/human/H in view(3, src))
			//Heal 5% for every 1.5 seconds you're here
			H.adjustBruteLoss(-(H.maxHealth*0.05))
			H.adjustSanityLoss(-(H.maxSanity*0.05))
			new /obj/effect/temp_visual/heal(get_turf(H), "#E2ED4A")
		if(prob(5))
			say(pick(saylines))
		SLEEP_CHECK_DEATH(15)
	healing = FALSE

/mob/living/simple_animal/hostile/abnormality/sunset_wayfarer/proc/PlayerCheck(mob/living/carbon/human/user)
	if(user in view(5, src))
		return TRUE
	else
		say("我想你一定很忙，改天吧!")
		return FALSE

// Pink Midnight

/mob/living/simple_animal/hostile/abnormality/sunset_wayfarer/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_PINK)
		can_breach = TRUE
		for(var/mob/living/simple_animal/hostile/ordeal/pink_midnight/pm in GLOB.ordeal_list)
			var/count = 1
			for(var/turf/target_turf in view(4, pm))
				if(DT_PROB(10, count))
					forceMove(target_turf)
					break
				count++
			break
		. = ..()
		HealAlt()
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/sunset_wayfarer/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/sunset_wayfarer/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/sunset_wayfarer/CanBeAttacked()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/sunset_wayfarer/proc/HealAlt()
	set waitfor = FALSE
	while (stat != DEAD)
		for(var/mob/living/L in view(5, src))
			L.adjustBruteLoss(-L.maxHealth*0.02)
		if(prob(5))
			say(pick(saylines))
		SLEEP_CHECK_DEATH(10)


//The moths that heal you
/mob/living/simple_animal/hostile/scarlet_moths
	name = "红焰蛾"
	desc = "一群漂浮的飞蛾."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "fireflies"
	icon_living = "fireflies"
	maxHealth = 8
	health = 8
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	melee_damage_lower = 0
	melee_damage_upper = 0
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	can_patrol = TRUE
	del_on_death = TRUE
	faction = list("neutral")
	light_color = COLOR_ORANGE
	light_range = 5
	light_power = 7
	density = FALSE
	area_index = MOB_SIMPLEANIMAL_INDEX // Don't trip regenerator threat mode

/mob/living/simple_animal/hostile/scarlet_moths/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(Explode)), 120 SECONDS)

/mob/living/simple_animal/hostile/scarlet_moths/Life()
	..()
	for(var/mob/living/carbon/human/H in view(5, get_turf(src)))
		H.adjustBruteLoss(-(H.maxHealth*0.03))
		H.adjustSanityLoss(-(H.maxSanity*0.03))
		new /obj/effect/temp_visual/heal(get_turf(H), "#E2ED4A")

/mob/living/simple_animal/hostile/scarlet_moths/proc/Explode()
	qdel(src)
