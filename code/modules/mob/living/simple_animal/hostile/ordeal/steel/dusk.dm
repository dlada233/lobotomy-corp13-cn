/mob/living/simple_animal/hostile/ordeal/steel_dusk
	name = "G公司主管"
	desc = "一位前G公司主管，G公司希望这位主管能通过强化的声波能力来鼓舞自身士气，同时瓦解敌人的意志。."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "gcorp1"
	icon_living = "gcorp1"
	icon_dead = "gcorp_corpse"
	faction = list("Gene_Corp")
	death_message = "mutters something under their breath before collapsing."
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	ranged_cooldown_time = 15 SECONDS
	a_intent = INTENT_HELP
	maxHealth = 450
	health = 450
	melee_damage_lower = 12
	melee_damage_upper = 14
	vision_range = 12
	move_to_delay = 3
	ranged = TRUE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.4, PALE_DAMAGE = 1)
	can_patrol = TRUE
	wander = FALSE
	patrol_cooldown_time = 1 MINUTES
	footstep_type = FOOTSTEP_MOB_SHOE
	possible_a_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_HARM)
	death_sound = 'sound/voice/hiss5.ogg'
	butcher_results = list(/obj/item/food/meat/slab/buggy = 3)
	silk_results = list(/obj/item/stack/sheet/silk/steel_simple = 4, /obj/item/stack/sheet/silk/steel_advanced = 2, /obj/item/stack/sheet/silk/steel_elegant = 1)
	//Last command issued
	var/last_command = 0
	//Delay on charge command
	var/chargecommand_cooldown = 0
	var/screech_cooldown = 0
	var/screech_windup = 5 SECONDS
	var/chargecommand_delay = 1 MINUTES
	//Delay on general commands
	var/command_cooldown = 0
	var/command_delay = 18 SECONDS
	//If this creature can act.
	var/can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/steel_dusk/Initialize(mapload)
	. = ..()
	var/list/units_to_add = list(
		/mob/living/simple_animal/hostile/ordeal/steel_dawn = 6,
		/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon = 2,
		/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying = 2
		)
	AddComponent(/datum/component/ai_leadership, units_to_add, 8, TRUE, TRUE)

	if(SSmaptype.maptype in SSmaptype.citymaps)
		guaranteed_butcher_results += list(/obj/item/head_trophy/steel_head = 1)

/mob/living/simple_animal/hostile/ordeal/steel_dusk/Life()
	. = ..()
	if(health <= maxHealth*0.5 && stat != DEAD)
		adjustBruteLoss(-1)
		if(!target)
			adjustBruteLoss(-3)

/mob/living/simple_animal/hostile/ordeal/steel_dusk/handle_automated_action()
	. = ..()
	if(command_cooldown < world.time && target && can_act && stat != DEAD)
		switch(last_command)
			if(1)
				Command(2) //always buff defense at start of battle
			else
				Command(pick(2,3))

/mob/living/simple_animal/hostile/ordeal/steel_dusk/patrol_select()
	if(prob(25))
		say("这里什么都没有，转移位置吧.")
	..()

/mob/living/simple_animal/hostile/ordeal/steel_dusk/Aggro()
	. = ..()
	if(chargecommand_cooldown <= world.time)
		Command(1)
		ranged_cooldown = world.time + (10 SECONDS)
		chargecommand_cooldown = world.time + chargecommand_delay
	a_intent_change(INTENT_HARM)

/mob/living/simple_animal/hostile/ordeal/steel_dusk/LoseAggro()
	. = ..()
	a_intent_change(INTENT_HELP)

/mob/living/simple_animal/hostile/ordeal/steel_dusk/OpenFire()
	if(can_act && ranged_cooldown <= world.time)
		ManagerScreech()
		ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/ordeal/steel_dusk/Move()
	if(!can_act)
		return FALSE
	return ..()

//used for attacks and commands. could possibly make this a modular spell or ability.
/mob/living/simple_animal/hostile/ordeal/steel_dusk/proc/Command(manager_order)
	playsound(loc, 'sound/effects/ordeals/steel/gcorp_chitter.ogg', 60, TRUE)
	switch(manager_order)
		if(1)
			if(prob(20))
				say(pick("敌人出现!", "该死，敌方部队发现我们了!", "我警告你，我们绝不会轻易倒下.", "保持冷静，我们都能平安脱身！"))
			for(var/mob/living/simple_animal/hostile/ordeal/G in oview(9, src))
				if(istype(G, /mob/living/simple_animal/hostile/ordeal/steel_dawn) && G.stat != DEAD && (!has_status_effect(/datum/status_effect/all_armor_buff) || !has_status_effect(/datum/status_effect/minor_damage_buff)))
					G.GiveTarget(target)
					G.TemporarySpeedChange(-1, 1 SECONDS)
			last_command = 1
		if(2)
			say("Hold fast!")
			for(var/mob/living/simple_animal/hostile/ordeal/G in oview(9, src))
				if((istype(G, /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon) || istype(G, /mob/living/simple_animal/hostile/ordeal/steel_dawn)) && G.stat != DEAD && !has_status_effect((/datum/status_effect/all_armor_buff || /datum/status_effect/minor_damage_buff)))
					G.apply_status_effect(/datum/status_effect/all_armor_buff)
			last_command = 2
		if(3)
			say("Onslaught!")
			for(var/mob/living/simple_animal/hostile/ordeal/G in oview(9, src))
				if((istype(G, /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon) || istype(G, /mob/living/simple_animal/hostile/ordeal/steel_dawn)) && G.stat != DEAD && !has_status_effect((/datum/status_effect/all_armor_buff || /datum/status_effect/minor_damage_buff)))
					G.apply_status_effect(/datum/status_effect/minor_damage_buff)
			last_command = 3
	command_cooldown = world.time + command_delay

/mob/living/simple_animal/hostile/ordeal/steel_dusk/proc/ManagerScreech()
	var/visual_overlay = mutable_appearance('icons/effects/effects.dmi', "blip")
	add_overlay(visual_overlay)
	can_act = FALSE
	if(!do_after(src, screech_windup, target = src))
		cut_overlay(visual_overlay)
		can_act = TRUE
		return
	can_act = TRUE
	cut_overlay(visual_overlay)
	playsound(loc, 'sound/effects/screech.ogg', 60, TRUE)
	new /obj/effect/temp_visual/screech(get_turf(src))
	for(var/mob/living/L in oview(10, src))
		if(!faction_check_mob(L))
			L.deal_damage(40, WHITE_DAMAGE, src, attack_type = (ATTACK_TYPE_SPECIAL))
