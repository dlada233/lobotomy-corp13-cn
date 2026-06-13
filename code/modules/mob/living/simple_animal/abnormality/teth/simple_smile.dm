//Very simple, funny little guy.
/mob/living/simple_animal/hostile/abnormality/smile
	name = "一个简单的微笑"
	desc = "一种似乎构成漂浮猫脸的畸形物."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "smile"
	icon_living = "smile"
	portrait = "simple_smile"
	del_on_death = TRUE
	maxHealth = 100
	health = 100
	rapid_melee = 2
	move_to_delay = 2
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	melee_damage_lower = 2
	melee_damage_upper = 3
	is_flying_animal = TRUE
	melee_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/lust
	stat_attack = HARD_CRIT
	attack_verb_continuous = "bumps"
	attack_verb_simple = "bumps"
	faction = list("hostile")
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 2

	ranged = 1
	retreat_distance = 3
	minimum_distance = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 85,
		ABNORMALITY_WORK_INSIGHT = 85,
		ABNORMALITY_WORK_ATTACHMENT = 85,
		ABNORMALITY_WORK_REPRESSION = 85,
	)
	work_damage_upper = 3
	work_damage_lower = 2
	work_damage_type = BLACK_DAMAGE
	can_spawn = FALSE // Normally doesn't appear

	ego_list = list(
		/datum/ego_datum/weapon/trick,
		/datum/ego_datum/armor/trick,
	)
	gift_type =  /datum/ego_gifts/trick
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	observation_prompt = "异常存在凭空出现在你面前，并夺走了你的武器."
	observation_choices = list(
		"追赶它" = list(TRUE, "你带着简单的微笑在设施内追逐目标 <br>\
			你被设施地板绊倒并擦伤了腿 <br>\
			\"这可不太礼貌！你该为粗鲁地解除我的武装、还让我这样跑来跑去的行径道歉！\" <br>\
			话语未经思考便脱口而出 <br>\
			仿佛回应般，一个简单的微笑将武器递还给你 <br>\
			随后它带着笑容消失了。"),
	)

	var/list/stats = list(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
		)

	var/lucky_counter



/mob/living/simple_animal/hostile/abnormality/smile/AttackingTarget(atom/attacked_target)
	. = ..()
	if(ishuman(attacked_target))
		var/mob/living/carbon/human/L = attacked_target
		L.Knockdown(20)
		var/obj/item/held = L.get_active_held_item()
		L.dropItemToGround(held) //Drop weapon


	var/list/pullable = list()
	for (var/obj/item/ego_weapon/Y in range(1, src))
		pullable += Y

	for (var/obj/item/ego_weapon/ranged/Z in range(1, src))
		pullable += Z

	if(!LAZYLEN(pullable))
		return

	src.pulled(pick(pullable))

/mob/living/simple_animal/hostile/abnormality/smile/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(lucky_counter > 3)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/smile/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/smile/WorkChance(mob/living/carbon/human/user, chance)
	var/chance_modifier = 1
	lucky_counter = 0	//Counts how many stats are above 40

	for(var/attribute in stats)
		if(get_attribute_level(user, attribute)>= 40)
			chance_modifier *= 0.8
			lucky_counter += 1

	return chance * chance_modifier




