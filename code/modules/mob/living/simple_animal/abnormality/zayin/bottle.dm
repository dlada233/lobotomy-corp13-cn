#define STATUS_EFFECT_TEARS /datum/status_effect/stacking/tears
#define STATUS_EFFECT_TEARS_LESS /datum/status_effect/stacking/tears/less
/mob/living/simple_animal/hostile/abnormality/bottle
	name = "瓶中泪"
	desc = "A bottle filled with water with a cake on top"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "bottle1"
	icon_living = "bottle1"
	portrait = "bottle"
	maxHealth = 60
	health = 60
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	threat_level = ZAYIN_LEVEL
	work_chances = list( //In the comic they work on it. They say you can do any work as long as you don't eat the cake
		ABNORMALITY_WORK_INSTINCT = list(60, 50, 40, 30, 30),
		ABNORMALITY_WORK_INSIGHT = list(60, 50, 40, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(60, 50, 40, 30, 30),
		ABNORMALITY_WORK_REPRESSION = list(60, 50, 40, 30, 30), //How the fuck do you beat up a cake?
		"用餐" = 100, //You can instead decide to eat the cake.
		"喝水" = 100, //Or Drink the water
	)
	work_damage_upper = 2
	work_damage_lower = 1
	work_damage_type = BLACK_DAMAGE
	max_boxes = 10 // Must be defined here for later code to work.

	ego_list = list(
		/datum/ego_datum/weapon/little_alice,
		/datum/ego_datum/armor/little_alice,
	)
	gift_type = /datum/ego_gifts/alice
	gift_message = "Welcome to your very own Wonderland~"
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	verb_say = "begs"
	move_to_delay = 5

	melee_damage_lower = 2
	melee_damage_upper = 4
	melee_damage_type = WHITE_DAMAGE

	attack_verb_continuous = "begs"
	attack_verb_simple = "beg"

	var/cake = 3 //How many cake charges are there (2)
	var/speak_cooldown_time = 5 SECONDS
	var/speak_damage = 8
	var/eating = FALSE
	var/scooped = FALSE // There can only be one eye scooper
	var/cake_regen = FALSE
	COOLDOWN_DECLARE(speak_damage_aura)

	chem_type = /datum/reagent/abnormality/bottle
	harvest_phrase = span_notice("你从 %ABNO 周围扫起碎屑装入 %VESSEL .")
	harvest_phrase_third = "%PERSON将 %ABNO 周围的碎屑扫入 %VESSEL ."

	observation_prompt = "虽然\"喝掉我\"的标签极具诱惑，但理智告诫你切莫匆忙行事. <br>\
		瓶身没有任何毒性标识，但你无法确定，它迟早会与你产生致命冲突..."
	observation_choices = list(
		"离开" = list(TRUE, "可疑之物终归可疑，常识至今未曾辜负于你."),
		"吃掉蛋糕" = list(TRUE, "抛弃理性方能于仙境求生. <br>\
			你狼吞虎咽地塞满蛋糕，糖霜与碎屑沾满双手、脸颊及地板. <br>\
			甜中带酸，唯余淡淡咸涩. <br>\
			当触及蛋糕底层时，瓶口猛然迸裂，咸涩洪流喷涌而出，顷刻淹没房间. <br>\
			濒死之际你却面露安详微笑. <br>\
			朦胧视野中，你瞥见收容门外皱眉凝视的——另一个自己."),
		"喝掉液体" = list(FALSE, "纵使瓶身未标剧毒，浅尝仍令你作呕, \
			咸涩液体黏着舌根久久不散. <br>怎会有人将这种标为饮品?"),
	)

// Work Mechanics
/mob/living/simple_animal/hostile/abnormality/bottle/AttemptWork(mob/living/carbon/human/user, work_type)
	if(!cake)
		if(work_type == "用餐")
			return FALSE
	if(work_type != "用餐" && work_type != "喝水")
		if(datum_reference.console.meltdown)
			cake_regen = TRUE
		return TRUE
	if(work_type == "喝水")
		//it's just work speed
		var/consume_speed = 2 SECONDS / (1 + ((get_attribute_level(user, TEMPERANCE_ATTRIBUTE) + datum_reference.understanding) / 100))
		to_chat(user, span_warning("你开始喝这些水..."))
		datum_reference.working = TRUE
		if(!do_after(user, consume_speed * max_boxes, target = user))
			to_chat(user, span_warning("你决定不喝这些水。"))
			datum_reference.working = FALSE
			return null
		playsound(get_turf(user), 'sound/machines/synth_yes.ogg', 25, FALSE, -4)
		user.apply_status_effect(STATUS_EFFECT_TEARS)
		datum_reference.working = FALSE
		return null

	return TRUE

/mob/living/simple_animal/hostile/abnormality/bottle/update_icon_state()
	if(cake == 3)
		icon_state = "bottle1"
	else if (cake > 1) // Chowin down
		icon_state = "bottle2"
	else if (cake == 1) // This serves as the warning sprite to stop eating the freakin' cake, man!
		icon_state = "bottle3"
	else
		icon_state = "bottle4"

// Special protagonist spoon-related code
/mob/living/simple_animal/hostile/abnormality/bottle/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(canceled)
		cake_regen = FALSE
		return
	if(work_type != "用餐")
		if(cake_regen)
			cake = 3
			update_icon_state() // Cake is back because we  melted
			cake_regen = FALSE
		return
	cake -= 1 //Eat some cake
	if(cake > 0)
		user.adjustBruteLoss(-500) // It heals you to full if you eat it
		to_chat(user, span_nicegreen("你吃掉了蛋糕。美味！"))
		update_icon_state() //cake looks eaten
		return

	//Drowns you like Wellcheers does, so I mean the code checks out
	for(var/turf/open/T in view(7, src))
		new /obj/effect/temp_visual/water_waves(T)

	playsound(get_turf(user), 'sound/abnormalities/bottle/bottledrown.ogg', 80, 0)
	update_icon_state() //cake all gone

	/**
	 * "I get it now. There's no reason to have any emotions or a heart."
	 * "Abandon reason and protect Catt! That's how you survive in this wonderland!"
	 * Catt was a low level agent with temperance and fortitude. She sought to abandon that temperance in exchange for justice.
	 * Thus, bottle will check for those. Overall low level, high temperance, high fortitude.
	 * Keep in mind that this event can happen ONCE PER ROUND. The spoon is already jokingly called the protagonist weapon, so it can bend the rules a bit, right?
	 */

	if(!scooped)
		new /obj/item/ego_weapon/eyeball(get_turf(user)) // We can only ever spawn one eye scooper
		scooped = TRUE

	var/fortitude = get_attribute_level(user, FORTITUDE_ATTRIBUTE)
	var/prudence = get_attribute_level(user, PRUDENCE_ATTRIBUTE)
	var/temperance = get_attribute_level(user, TEMPERANCE_ATTRIBUTE)
	var/justice = get_attribute_level(user, JUSTICE_ATTRIBUTE)

	if(temperance >= (fortitude + prudence + justice) / 1.5) // If your temperance is at least twice your average stat, you aren't hurt, but lose temperance.
		var/raw_temperance = get_raw_level(user, TEMPERANCE_ATTRIBUTE)
		to_chat(user, span_userdanger("房间正在被水填满...但你感到奇怪的无动于衷。"))
		user.adjust_attribute_level(TEMPERANCE_ATTRIBUTE, 20 - floor(raw_temperance))
		// This is a PERMANENT stat change, VERY significant. But it can happen only once per round. You're The Protagonist, after all.
		var/stat_change = floor(raw_temperance - 20)
		user.adjust_attribute_buff(JUSTICE_ATTRIBUTE, stat_change) // Gain benefit from what you lost.
		addtimer(CALLBACK(src, PROC_REF(DecayProtagonistBuff), user, stat_change), 20 SECONDS) // Short grace period. 10s of this happens while you're asleep.

	else
		to_chat(user, span_userdanger("房间正在被水填满! 你打算被淹死吗?!"))
		user.adjustBruteLoss(user.maxHealth - (fortitude / 2)) // Hurt bad, but never lethally.
		if(fortitude < (prudence + justice)) // Like the temperance calculation, but high temperance doesn't actively hurt your odds.
			user.adjustBruteLoss(999) // okay, now you've done it

	user.AdjustSleeping(10 SECONDS)
	if(user.stat == DEAD)
		animate(user, alpha = 0, time = 2 SECONDS)
		QDEL_IN(user, 3.5 SECONDS)
		return

	user.adjustBruteLoss(-((user.maxHealth - fortitude) * 0.25)) // If you didn't die instantly, heal up some.

/mob/living/simple_animal/hostile/abnormality/bottle/proc/DecayProtagonistBuff(mob/living/carbon/human/buffed, given_justice = 0)
	// Goes faster when the buff is higher, so you don't have an overwhelming buff for an overwhelming length of time.
	if(!buffed || given_justice == 0)
		return FALSE
	var/factor = given_justice / 10
	var/timing = 10 + max(0, (100 - factor * factor))
	buffed.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -1)
	if(prob(10))
		buffed.adjust_attribute_level(JUSTICE_ATTRIBUTE, 1) // 10% chance for justice buff to become real justice as it decays.
	addtimer(CALLBACK(src, PROC_REF(DecayProtagonistBuff), buffed, given_justice - 1), timing)

// Pink Midnight Breach
/mob/living/simple_animal/hostile/abnormality/bottle/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_PINK || breach_type == BREACH_MINING)
		ADD_TRAIT(src, TRAIT_MOVE_FLYING, INNATE_TRAIT)
		COOLDOWN_START(src, speak_damage_aura, speak_cooldown_time)
		icon_state = "bottle_breach"
		desc = "A floating bottle, leaking tears.\nYou can use an empty hand to drink from it."
		can_breach = TRUE
	if(breach_type == BREACH_MINING)
		speak_damage = 0
		speak_cooldown_time = 15 SECONDS
	return ..()

/mob/living/simple_animal/hostile/abnormality/bottle/attack_hand(mob/living/carbon/human/M)
	if(M.a_intent != "help" || (status_flags & GODMODE))
		return ..()
	if(eating)
		to_chat(M, span_notice("Someone else is already drinking from [src], it'd be kinda weird to join them..."))
		return
	eating = TRUE
	to_chat(M, span_notice("You start drinking from the bottle.</span>"))
	if(do_after(M, 2 SECONDS, src, IGNORE_HELD_ITEM, interaction_key = src, max_interact_count = 1))
		M.adjustSanityLoss(speak_damage*4) // Heals the mind
		speak_damage = initial(speak_damage)
		to_chat(M, span_nicegreen("Isn't it wonderful? Your very own Wonderland!"))
		M.apply_status_effect(STATUS_EFFECT_TEARS_LESS)
	else
		to_chat(M, span_notice("You decide against drinking from the bottle..."))
		M.deal_damage(speak_damage, WHITE_DAMAGE)
	eating = FALSE

/mob/living/simple_animal/hostile/abnormality/bottle/ListTargets()
	. = ..()
	for(var/mob/living/carbon/human/H in .)
		if(H.sanity_lost)
			. -= H
			continue

/mob/living/simple_animal/hostile/abnormality/bottle/Move()
	if(!eating)
		return ..()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/bottle/AttackingTarget(atom/attacked_target)
	if(eating)
		return
	if(isliving(attacked_target))
		var/mob/living/L = attacked_target
		if(faction_check_mob(L))
			L.visible_message(span_danger("[src]喂食[L]... [L] 看起来精神更饱满了!"), span_nicegreen("[src]喂食了你，你感到精神更饱满了!"))
			L.adjustBruteLoss(-speak_damage/2)
			return
	return ..()

/mob/living/simple_animal/hostile/abnormality/bottle/Life()
	. = ..()
	if(!.)
		return
	if(COOLDOWN_FINISHED(src, speak_damage_aura) && !eating)
		COOLDOWN_START(src, speak_damage_aura, speak_cooldown_time)
		if(!client)
			say("喝掉我.")
		for(var/mob/living/L in view(vision_range, src))
			if(L == src)
				continue
			if(faction_check_mob(L, FALSE))
				continue
			L.deal_damage(speak_damage, BLACK_DAMAGE)
		adjustBruteLoss(-speak_damage) // It falls further into desperation
		if(speak_damage < 40)
			speak_damage += 4

// Special Status Effect
/datum/status_effect/stacking/tears
	id = "tears"
	stacks = 1
	max_stacks = INFINITY

	// we use refresh as a signal that another stack should be added
	status_type = STATUS_EFFECT_REFRESH
	consumed_on_threshold = FALSE

	tick_interval = 5 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/tears
	var/scaling = 20

/atom/movable/screen/alert/status_effect/tears
	name = "含泪"
	desc = "你的属性将短暂受到削弱."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "tearful"

/datum/status_effect/stacking/tears/refresh()
	add_stacks(stack_decay)

/datum/status_effect/stacking/tears/fadeout_effect()
	stack_decay_effect()

/datum/status_effect/stacking/tears/add_stacks(stacks_added)
	. = ..()
	if(!ishuman(owner) || stacks_added < 0)
		return

	var/mob/living/carbon/human/status_holder = owner

	to_chat(owner, span_danger("曾经对你重要的东西现在不见了，你感觉想哭."))
	status_holder.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -scaling)
	status_holder.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -scaling)
	status_holder.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -scaling)
	status_holder.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -scaling)

/datum/status_effect/stacking/tears/stack_decay_effect()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/status_holder = owner

	to_chat(owner, span_nicegreen("你感觉自己的力量重新回来了."))
	status_holder.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, scaling)
	status_holder.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, scaling)
	status_holder.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, scaling)
	status_holder.adjust_attribute_buff(JUSTICE_ATTRIBUTE, scaling)

/datum/status_effect/stacking/tears/less
	tick_interval = 2 MINUTES
	scaling = 10

#undef STATUS_EFFECT_TEARS
#undef STATUS_EFFECT_TEARS_LESS

/datum/reagent/abnormality/bottle
	name = "Crumbs"
	description = "A small pile of slightly soggy crumbs."
	reagent_state = SOLID
	color = "#ad8978"
	health_restore = 2
	stat_changes = list(-4, -4, -4, -4)
