/mob/living/simple_animal/hostile/abnormality/clayman
	name = "通用品牌造型黏土"
	desc = "黏土制成的小而粗糙的人形雕像."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "bluro"
	icon_living = "bluro"
	icon_dead = "bluro"
	portrait = "clayman"
	del_on_death = TRUE
	maxHealth = 250
	health = 250
	ranged = TRUE
	rapid_melee = 1
	melee_queue_distance = 2
	move_to_delay = 3
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	melee_damage_lower = 3
	melee_damage_upper = 4
	melee_damage_type = RED_DAMAGE
	attack_sound = 'sound/effects/hit_kick.ogg'
	attack_verb_continuous = "smashes"
	attack_verb_simple = "smash"
	friendly_verb_continuous = "bonks"
	friendly_verb_simple = "bonk"
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 50,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 50,
		ABNORMALITY_WORK_REPRESSION = 50
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gluttony
	death_message = "失去形体."
	ego_list = list(
		/datum/ego_datum/weapon/clayman,
		/datum/ego_datum/armor/clayman,
	)
	var/reforming = FALSE
	gift_message = "The clay clings to you, a constant reminder."
	gift_type =  /datum/ego_gifts/clayman
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	observation_prompt = "一种柔软的、类似黏土的物质。<br>\
		被揉捏、塑造，是一种最高级的艺术形式。<br>\
		它现在看着你，眼中充满期待。<br>这件作品还没有完成。它..."
	observation_choices = list(
		"它应该被摧毁" = list(FALSE, "这是一个邪恶的亵渎。<br>这样的东西不应该存在。<br>它违反了这个世界和都市的原则。"),
		"它仍然需要一个灵魂" = list(TRUE, "需要付出的代价无法用时间和金钱来衡量。<br>结果会为自己说话。"),
	)

	var/dashready = TRUE

/mob/living/simple_animal/hostile/abnormality/clayman/WorktickFailure(mob/living/carbon/human/user)
	var/dtype = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	work_damage_type = pick(dtype)
	..()

/mob/living/simple_animal/hostile/abnormality/clayman/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	var/og_reforming = reforming
	for(var/work in work_chances)
		if(work_chances[work] >= 100)
			reforming = TRUE
			work_chances[work] = 20 //For some reason setting it like this doesn't bug the work rate but setting the entire list at once does.
			continue
		else if(work_chances[work] >= 50)
			reforming = FALSE

		if(work != work_type)
			work_chances[work] -= 5
		else
			work_chances[work] += 10

	if(reforming != og_reforming)
		if(reforming)
			manual_emote("看起来不成形状!")
		else
			manual_emote("正在重新塑型.")

/mob/living/simple_animal/hostile/abnormality/clayman/examine(mob/user)
	. = ..()
	for(var/work in work_chances)
		if(work_chances[work] >= 90)
			. += "<span class='warning'>它即将散架，你应该避免对它进行更多的[work]工作。</span>"

/mob/living/simple_animal/hostile/abnormality/clayman/CanAttack(atom/the_target)
	melee_damage_type = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	return ..()

/mob/living/simple_animal/hostile/abnormality/clayman/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(!reforming)
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/clayman/proc/Skitter()
	visible_message(span_warning("[src]飞掠地更快了!"), span_notice("你听到几百只泥脚的啪嗒声"))
	var/duration = 3 SECONDS
	TemporarySpeedChange(-2, duration)
	dashready = FALSE
	addtimer(CALLBACK(src, PROC_REF(dashreset)), 15 SECONDS)

/mob/living/simple_animal/hostile/abnormality/clayman/OpenFire(atom/A)
	if(get_dist(src, target) >= 3 && dashready)
		Skitter()

/mob/living/simple_animal/hostile/abnormality/clayman/proc/dashreset()
	dashready = TRUE
