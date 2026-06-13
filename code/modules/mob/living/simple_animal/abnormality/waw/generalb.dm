/mob/living/simple_animal/hostile/abnormality/general_b
	name = "将军蜂"
	desc = "蜜蜂类人生物."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "generalbee"
	icon_living = "generalbee"
	core_icon = "gbee_egg"
	speak_emote = list("buzzes")
	pixel_x = -8
	base_pixel_x = -8
	threat_level = WAW_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 55, 55, 60),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 45, 45, 50),
		ABNORMALITY_WORK_ATTACHMENT = 0,						//DO NOT FUCK THE BEEGIRL
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 40, 40, 40),
	)
	work_damage_upper = 6
	work_damage_lower = 4
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/pride
	ego_list = list(
		/datum/ego_datum/weapon/loyalty,
		/datum/ego_datum/weapon/praetorian,
		/datum/ego_datum/armor/loyalty,
	)
	gift_type =  /datum/ego_gifts/loyalty
	loot = list(/obj/item/clothing/suit/armor/ego_gear/aleph/praetorian) // Don't think it was dropping before, this should make it do so
	health = 1400
	maxHealth = 1400
	damage_coeff = list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)
	melee_damage_lower = 12
	melee_damage_upper = 16
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/queen_bee = 5,
	)
	//She has a Quad Artillery Cannon

	observation_prompt = "我为女王不知疲倦地劳作. <br>\
		摧毁一切威胁蜂巢的事物. <br>\
		射杀任何会动但不是蜜蜂的东西. <br>\
		毫无质疑地忠诚，我严格遵从我的命令. <br>\
		甚至每次接到新命令时我都会感到兴奋. <br>\
		我做这一切又是为了什么?"
	observation_choices = list(
		"我为生存而战" = list(TRUE, "蜜蜂有为蜂后而战的天性. <br>\
			这并不像人类情感那样复杂. <br>\
			更确切地说，这是蜂后分泌的一种激素. <br>\
			离开蜂群的那一刻我就会死去.<br>\
			除了保持毫无质疑的忠诚之外别无选择."),
		"我为忠诚而战" = list(TRUE, "蜜蜂有为蜂后而战的天性. <br>\
			这并不像人类情感那样复杂. <br>\
			更确切地说，这是蜂后分泌的一种激素. <br>\
			离开蜂群的那一刻我就会死去.<br>\
			除了保持毫无质疑的忠诚之外别无选择."),
	)

	var/fire_cooldown_time = 3 SECONDS	//She has 4 cannons, fires 4 times faster than the artillery bees
	var/fire_cooldown
	var/fireball_range = 30
	var/volley_count
	//If the general has her post breach icon.
	var/static/true_breached = FALSE

	// Playables Vars
	var/combat_map = FALSE
	var/datum/action/innate/toggle_artillery_sight/sight_ability

	var/list/beespawn = list()

/mob/living/simple_animal/hostile/abnormality/general_b/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	sight_ability.original_sight = src.sight

/mob/living/simple_animal/hostile/abnormality/general_b/Initialize()
	. = ..()
	var/obj/effect/proc_holder/ability/aimed/artillery_shell/general/shell_ability = new
	src.AddSpell(shell_ability)
	var/datum/action/spell_action/ability/item/A = shell_ability.action
	A.set_item = src //it wants an /obj/item though so its kinda bad but i dont really feel like figuring it out
	sight_ability = new
	sight_ability.Grant(src)
	if(IsCombatMap())
		combat_map = TRUE
		sight_ability.new_sight = SEE_TURFS
	else
		sight_ability.new_sight = SEE_TURFS | SEE_THRU

/mob/living/simple_animal/hostile/abnormality/general_b/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/general_b/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/general_b/ZeroQliphoth(mob/living/carbon/human/user)
	if(!(status_flags & GODMODE)) // If it's breaching right now
		return	//Yeah don't increase Qliphoth
	var/artillerbee_count = 0
	for(var/mob/living/simple_animal/hostile/aminion/artillery_bee/artillerbee in GLOB.mob_living_list)
		artillerbee_count++
	if(artillerbee_count < 4)
		SpawnBees()
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/general_b/update_icon_state()
	icon = initial(icon)
	if(status_flags & GODMODE)
		// Not breaching
		//Normal bee or one eyed bee.
		if(true_breached)
			icon_living = "punished_bee"
		else
			icon_living = "generalbee"

	else if(stat == DEAD)
		icon_state = icon_dead
		return
	else
		icon = 'ModularTegustation/Teguicons/48x96.dmi'
		icon_living = "general_breach"
	icon_state = icon_living

/mob/living/simple_animal/hostile/abnormality/general_b/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if ((!combat_map) && (!client))
		if((fire_cooldown < world.time))
			AimShell()

//Prevents special armor drop if not breached.
/mob/living/simple_animal/hostile/abnormality/general_b/drop_loot()
	if(status_flags & GODMODE)
		return
	..()

/mob/living/simple_animal/hostile/abnormality/general_b/PostSpawn()
	..()
	update_icon()
/*
* General Bee Breach Sequence
* General Bee blurbs then puts her icon file to 48x96 before flicking her breach animation.
* Sleeps for 8 seconds so that her animation ends. Then she picks a department.
* Moves to the department, lists herself as true_breached, and spawns minions.
* Root code is called so that she is taken out of godmode. Then update_icon() is called.
*/
/mob/living/simple_animal/hostile/abnormality/general_b/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type != BREACH_PINK)
		if(!combat_map)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, "我的女王? 我听到您在哭泣...", 25))
		icon = 'ModularTegustation/Teguicons/48x96.dmi'
		flick("generalbee_", src)
		SLEEP_CHECK_DEATH(80)
	else
		//This is placed here so that her soldiers know its a party.
		faction += "pink_midnight"
	if(!combat_map)
		var/turf/T = pick(GLOB.department_centers)
		forceMove(T)
	//Call root code but with normal breach
	. = ..(null, BREACH_NORMAL)
	true_breached = TRUE
	if(!combat_map && breach_type != BREACH_MINING)
		var/turf/orgin = get_turf(src)
		var/list/all_turfs = RANGE_TURFS(2, orgin)
		SpawnMinions(all_turfs, TRUE)
		datum_reference.qliphoth_change(-1)
	update_icon()

/mob/living/simple_animal/hostile/abnormality/general_b/proc/SpawnMinions(list/spawn_turfs, copy_faction = FALSE)
	var/mob/living/simple_animal/spawn_minion
	for(var/turf/Y in spawn_turfs)
		if(prob(60))
			spawn_minion = new /mob/living/simple_animal/hostile/aminion/soldier_bee(Y)
		else if(prob(20))
			spawn_minion = new /mob/living/simple_animal/hostile/aminion/artillery_bee(Y)
		if(spawn_minion && copy_faction)
			spawn_minion.faction = faction.Copy()

/mob/living/simple_animal/hostile/abnormality/general_b/proc/AimShell()
	fire_cooldown = world.time + fire_cooldown_time
	var/list/targets = list()
	for(var/mob/living/L in livinginrange(fireball_range, src))
		if(L.z != z)
			continue
		if(L.status_flags & GODMODE)
			continue
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		targets += L
	if(!(targets.len > 0))
		return
	FireShell(pick(targets), FALSE)
	volley_count+=1
	if(volley_count>=4)
		volley_count=0
		fire_cooldown = world.time + fire_cooldown_time*3	//Triple cooldown every 4 shells

/mob/living/simple_animal/hostile/abnormality/general_b/proc/FireShell(target, called_by_ability)
	var/turf/target_turf = get_turf(target)
	if(target_turf.density)
		to_chat(src, span_notice("Can't fire at that location!"))
		if(called_by_ability)// Used so that Perform() can return on the targeted ability.
			return TRUE
		return
	to_chat(src, span_notice("You fire at the target!"))
	new /obj/effect/beeshell(target_turf, faction)

/mob/living/simple_animal/hostile/abnormality/general_b/proc/SpawnBees()
	var/X = pick(GLOB.xeno_spawn)
	var/turf/T = get_turf(X)
	new /mob/living/simple_animal/hostile/aminion/artillery_bee(T)
	for(var/y = 1 to 5)
		new /mob/living/simple_animal/hostile/aminion/soldier_bee(T)

/* Soldier bees */
/mob/living/simple_animal/hostile/aminion/soldier_bee
	name = "士兵蜂"
	desc = "一个毁容的生物，长着讨厌的尖牙，戴着时髦的帽子."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "soldier_bee"
	icon_living = "soldier_bee"
	base_pixel_x = -8
	pixel_x = -8
	health = 200
	maxHealth = 200
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	melee_damage_lower = 5
	melee_damage_upper = 7
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
	score_divider = 5//Worth 8 points

/* Artillery bees */
/mob/living/simple_animal/hostile/aminion/artillery_bee
	name = "炮兵蜂"
	desc = "一个毁容的生物，长着讨厌的尖牙，还有一个超大的胸腔."
	icon = 'ModularTegustation/Teguicons/48x96.dmi'
	icon_state = "artillerysergeant"
	icon_living = "artillerysergeant"
	friendly_verb_continuous = "scorns"
	friendly_verb_simple = "scorns"
	pixel_x = -8
	base_pixel_x = -8
	pixel_y = -8
	base_pixel_y = -8
	health = 400
	maxHealth = 400
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1) // Just so it's declared.
	del_on_death = TRUE
	death_sound = 'sound/abnormalities/bee/death.ogg'
	speak_emote = list("buzzes")
	threat_level = HE_LEVEL
	score_divider = 2//Worth 20 points

	var/fire_cooldown_time = 10 SECONDS
	var/fire_cooldown
	var/fireball_range = 30

	var/combat_map = FALSE
	var/datum/action/innate/toggle_artillery_sight/sight_ability

/mob/living/simple_animal/hostile/aminion/artillery_bee/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	sight_ability.original_sight = src.sight
	if(IsCombatMap())
		sight_ability.new_sight = SEE_TURFS
	else
		sight_ability.new_sight = SEE_TURFS | SEE_THRU

/mob/living/simple_animal/hostile/aminion/artillery_bee/Initialize()
	. = ..()
	var/obj/effect/proc_holder/ability/aimed/artillery_shell/shell_ability = new
	src.AddSpell(shell_ability)
	sight_ability = new
	sight_ability.Grant(src)
	if (IsCombatMap())
		combat_map = TRUE

/mob/living/simple_animal/hostile/aminion/artillery_bee/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if ((!combat_map) && (!client))
		if((fire_cooldown < world.time))
			AimShell()

/mob/living/simple_animal/hostile/aminion/artillery_bee/proc/AimShell()
	fire_cooldown = world.time + fire_cooldown_time
	var/list/targets = list()
	for(var/mob/living/L in livinginrange(fireball_range, src))
		if(L.z != z)
			continue
		if(L.status_flags & GODMODE)
			continue
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		targets += L
	if(targets.len > 0)
		FireShell(pick(targets), FALSE)

/mob/living/simple_animal/hostile/aminion/artillery_bee/proc/FireShell(target, called_by_ability)
	var/turf/target_turf = get_turf(target)
	if(target_turf.density)
		to_chat(src, span_notice("Can't fire at that location!"))
		if(called_by_ability) // Used so that Perform() can return on the targeted ability.
			return TRUE
		return
	to_chat(src, span_notice("You fire at the target!"))
	new /obj/effect/beeshell(target_turf, faction)

/datum/action/innate/toggle_artillery_sight
	name = "Toggle Artillery Sight"
	desc = "Toggle your ability to see extremely far away and through walls (but not see whats behind them)."
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "zoom_toggle0"
	background_icon_state = "bg_abnormality"
	var/toggle_on_message = span_warning("You increase your vision range!")
	var/button_icon_toggle_activated = "zoom_toggle1"
	var/toggle_off_message = span_warning("You deactivate your artillery sight.")
	var/button_icon_toggle_deactivated = "zoom_toggle0"
	var/zoom_level = 0
	var/zoom_out_amt_level1 = 5
	var/zoom_out_amt_level2 = 15
	var/zoom_out_amt
	var/zoom_amt = 10
	var/original_sight
	var/new_sight = SEE_TURFS

/datum/action/innate/toggle_artillery_sight/Activate()
	to_chat(owner, toggle_on_message)
	zoom_level ++
	switch(zoom_level)
		if(1)
			zoom_out_amt = zoom_out_amt_level1
			ActivateSignals()
		if(2)
			zoom_out_amt = zoom_out_amt_level2
			button_icon_state = button_icon_toggle_activated
			UpdateButtonIcon()
			active = TRUE

	owner.sight |= new_sight
	owner.regenerate_icons()
	owner.client.view_size.zoomOut(zoom_out_amt, zoom_amt, owner.dir)
	return ..()

/datum/action/innate/toggle_artillery_sight/proc/ActivateSignals()
	SIGNAL_HANDLER

	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(Deactivate))
	RegisterSignal(owner, COMSIG_ATOM_DIR_CHANGE, PROC_REF(Rotate))

/datum/action/innate/toggle_artillery_sight/Deactivate()
	to_chat(owner, toggle_off_message)
	DeactivateSignals()
	button_icon_state = button_icon_toggle_deactivated
	UpdateButtonIcon()

	owner.sight = original_sight
	owner.regenerate_icons()
	zoom_level = 0
	active = FALSE
	owner.client.view_size.zoomIn()
	return ..()

/datum/action/innate/toggle_artillery_sight/proc/DeactivateSignals()
	SIGNAL_HANDLER

	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(owner, COMSIG_ATOM_DIR_CHANGE)

/datum/action/innate/toggle_artillery_sight/proc/Rotate(old_dir, new_dir)
	SIGNAL_HANDLER

	owner.regenerate_icons()
	owner.client.view_size.zoomOut(zoom_out_amt, zoom_amt, new_dir)

/obj/effect/proc_holder/ability/aimed/artillery_shell
	name = "Fire Artillery Shell"
	desc = "An ability that allows the user to fire a shell from their artillery cannon."
	action_icon = 'icons/mob/actions/actions_abnormality.dmi'
	action_background_icon_state = "bg_abnormality"
	action_icon_state = "artillery0"
	base_icon_state = "artillery"
	cooldown_time = 10 SECONDS

	var/artillery_range = 30

/obj/effect/proc_holder/ability/aimed/artillery_shell/Perform(target, mob/living/simple_animal/hostile/abnormality/general_b/user)
	if(get_dist(user, target) > artillery_range)
		to_chat(user, span_notice("Too far from our cannon's range!"))
		return
	if(user.FireShell((target), TRUE))
		return
	return ..()

/obj/effect/proc_holder/ability/aimed/artillery_shell/general
	name = "Fire Artillery Shell Barrage"
	desc = "An ability that allows the user to fire a shell from it's artillery cannons. Quick to fire, but will need a reload after 4 shots."
	cooldown_time = 3 SECONDS

	var/volley_count = 0
	//TODO: make sprites

/obj/effect/proc_holder/ability/aimed/artillery_shell/general/Perform(target, mob/living/simple_animal/hostile/abnormality/general_b/user)
	. = ..()
	volley_count += 1
	if(volley_count >= 4)
		volley_count = 0
		cooldown += cooldown_time * 2 //Triple cooldown every 4 shots
	return

/obj/effect/beeshell
	name = "bee shell"
	desc = "A target warning you of incoming pain"
	icon = 'icons/effects/effects.dmi'
	icon_state = "beetillery"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	var/boom_damage = 50 //Half Red, Half Black
	var/list/faction = list("hostile")
	layer = POINT_LAYER	//We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what is about to hit you.

/obj/effect/beeshell/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(explode)), 3.5 SECONDS)

/obj/effect/beeshell/New(loc, ...)
	. = ..()
	if(args[2])
		faction = args[2]

//Smaller Scorched Girl bomb
/obj/effect/beeshell/proc/explode()
	playsound(get_turf(src), 'sound/effects/explosion2.ogg', 50, 0, 8)
	for(var/mob/living/L in view(2, src))
		if(faction_check(faction, L.faction, FALSE))
			continue
		L.deal_damage(boom_damage, list(RED_DAMAGE, BLACK_DAMAGE))
		if(L.health < 0)
			L.gib()
	new /obj/effect/temp_visual/explosion(get_turf(src))
	var/datum/effect_system/smoke_spread/S = new
	S.set_up(4, get_turf(src))	//Make the smoke bigger
	S.start()
	qdel(src)
