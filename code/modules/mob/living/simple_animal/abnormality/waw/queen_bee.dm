/mob/living/simple_animal/hostile/abnormality/queen_bee
	name = "女王蜂"
	desc = "形似蜂后的扭曲生物."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "queen_bee"
	icon_living = "queen_bee"
	portrait = "queen_bee"
	faction = list("hostile")
	speak_emote = list("buzzes")
	maxHealth = 1200
	health = 1200

	pixel_x = -8
	base_pixel_x = -8

	threat_level = WAW_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 45, 45, 45),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 55, 55, 60),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 40, 40, 40),
		ABNORMALITY_WORK_REPRESSION = 0,
	)
	work_damage_upper = 6
	work_damage_lower = 4
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/pride

	ego_list = list(
		/datum/ego_datum/weapon/hornet,
		/datum/ego_datum/weapon/tattered_kingdom,
		/datum/ego_datum/armor/hornet,
	)
	gift_type =  /datum/ego_gifts/hornet
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/general_b = 5,
	)

	observation_prompt = "那是个无比炎热难耐的夏天。<br>蜜蜂在蜂巢周围忙碌地飞舞。<br>\
		它们只为唯一的女王而活。<br>'它们快乐吗？活着只为了工作' 我问自己。<br>这时有人答道。"
	observation_choices = list(
		"它们工作是为了生存" = list(TRUE, "它们除了服从别无选择。<br>\
			因为它们深知，离开蜂群的那一刻，等待它们的只有死亡。<br>\
			多年后我才发现，它们那不可动摇的忠诚源于只有女王才能分泌的特殊信息素。<br>\
			一切始于我开始研究那种信息素时。"),
		"它们工作是出于忠诚" = list(TRUE, "蜜蜂所拥有的忠诚是种天性本能。<br>\
			若能找到控制这种本能的方法，<br>\
			局面必将改变。<br>\
			多年后我才发现，它们那不可动摇的忠诚源于只有女王才能分泌的特殊信息素。<br>\
			一切始于我开始研究那种信息素时。"),
	)

	var/datum/looping_sound/queenbee/soundloop
	var/breached_others = FALSE

/mob/living/simple_animal/hostile/abnormality/queen_bee/Initialize()
	. = ..()
	soundloop = new(list(src), TRUE)

/mob/living/simple_animal/hostile/abnormality/queen_bee/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/mob/living/simple_animal/hostile/abnormality/queen_bee/proc/emit_spores()
	var/turf/target_c = get_turf(src)
	var/list/turf_list = list()
	turf_list = spiral_range_turfs(36, target_c)
	playsound(target_c, 'sound/abnormalities/bee/spores.ogg', 50, 1, 5)
	for(var/turf/open/T in turf_list)
		if(prob(25))
			new /obj/effect/temp_visual/bee_gas(T)
		for(var/mob/living/carbon/human/H in T.contents)
			if(prob(90))			//TODO: Make this based off armor
				var/datum/disease/bee_spawn/D = new()
				H.ForceContractDisease(D, FALSE, TRUE)
		for(var/mob/living/simple_animal/hostile/abnormality/general_b/Y in T.contents)
			if(breached_others == FALSE)
				Y.BreachEffect()
				breached_others = TRUE

/mob/living/simple_animal/hostile/abnormality/queen_bee/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(10))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/queen_bee/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/queen_bee/ZeroQliphoth(mob/living/carbon/human/user)
	emit_spores()
	datum_reference.qliphoth_change(1)
	return


/* Worker bees */
/mob/living/simple_animal/hostile/aminion/worker_bee
	name = "工蜂"
	desc = "一种长着毒牙的畸形生物."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "worker_bee"
	icon_living = "worker_bee"
	base_pixel_x = -8
	health = 360 // More hp due to them spawning less often than in LC
	maxHealth = 360
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	melee_damage_lower = 6
	melee_damage_upper = 10
	rapid_melee = 2
	obj_damage = 200
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	death_sound = 'sound/abnormalities/bee/death.ogg'
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	speak_emote = list("buzzes")
	threat_level = HE_LEVEL
	score_divider = 2// Someones going to die to spawn this so it should probably be worth less

/mob/living/simple_animal/hostile/aminion/worker_bee/Initialize()
	. = ..()
	playsound(get_turf(src), 'sound/abnormalities/bee/birth.ogg', 50, 1)
	var/matrix/init_transform = transform
	transform *= 0.1
	alpha = 25
	animate(src, alpha = 255, transform = init_transform, time = 5)

/mob/living/simple_animal/hostile/aminion/worker_bee/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!ishuman(attacked_target))
		return
	var/mob/living/carbon/human/H = attacked_target
	if(H.health <= 0)
		var/turf/T = get_turf(H)
		visible_message(span_danger("伴随着另一只蜜蜂的出现，[src]猛烈撕咬[H]!"))
		H.emote("scream")
		H.gib()
		new /mob/living/simple_animal/hostile/aminion/worker_bee(T)
