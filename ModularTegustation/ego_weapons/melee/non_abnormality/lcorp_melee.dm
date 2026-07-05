//A file for all melee weapons manufactured at L-corp that is not E.G.O.

//Contains clerk and officer weapons

///////////////////////
///OFFICER EQUIPMENT///
///////////////////////

/obj/item/ego_weapon/officer
	name = "officer weapon"
	desc = "Please contact a coder if you obtain this!"
	icon_state = "officer_blade"
	icon = 'ModularTegustation/Teguicons/lcorp_weapons.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/lcorp_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lcorp_right.dmi'
	force = 6
	var/list/allowed_roles = list("Training Officer","Disciplinary Officer", "Extraction Officer","Records Officer")//we dont want other Roles to wear this!
	var/current_holder = null
	var/current_level = 1
	var/max_level = 5
	var/list/level_to_force = list(6, 12, 18, 26, 35)
	var/extra_text = "这把武器只能由部长使用，击败的考验越多，这把武器的力量也会随之增强."

/obj/item/ego_weapon/officer/examine(mob/user)
	. = ..()
	. += span_notice(extra_text)

/obj/item/ego_weapon/officer/SpecialEgoCheck(mob/living/carbon/human/H)
	if(!H.mind)
		return FALSE
	if(H.mind.assigned_role in allowed_roles)
		return TRUE
	return  FALSE

/obj/item/ego_weapon/officer/Initialize()
	. = ..()
	if(SSlobotomy_corp.next_ordeal)
		current_level = min(max_level, SSlobotomy_corp.next_ordeal.level)
	refresh_stats()
	RegisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END, PROC_REF(update_stats))

/obj/item/ego_weapon/officer/proc/update_stats()
	if(current_level >= max_level)
		return
	current_level++
	if(current_holder)
		to_chat(current_holder, span_nicegreen("[src]的伤害已提升!"))
	refresh_stats()

/obj/item/ego_weapon/officer/proc/refresh_stats()
	force = level_to_force[current_level]

/obj/item/ego_weapon/officer/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user

/obj/item/ego_weapon/officer/dropped(mob/user)
	. = ..()
	current_holder = null

/obj/item/ego_weapon/shield/officer
	name = "officer shield"
	desc = "Please contact a coder if you obtain this!"
	icon_state = "officer_sabre"
	icon = 'ModularTegustation/Teguicons/lcorp_weapons.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/lcorp_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lcorp_right.dmi'
	force = 20
	block_duration = 3 SECONDS
	block_cooldown = 3 SECONDS
	block_sound_volume = 30
	var/list/allowed_roles = list("Training Officer","Disciplinary Officer", "Extraction Officer","Records Officer")//we dont want other Roles to wear this!
	var/current_holder = null
	var/current_level = 1
	var/max_level = 5
	var/list/level_to_force = list(20, 32, 46, 52, 70)
	var/list/initial_reductions = list(20,20,20,20)
	var/extra_text = "这把武器只能由部长使用，击败的考验越多，这把武器的力量也会随之增强."
	var/armor_increase = 10

/obj/item/ego_weapon/shield/officer/examine(mob/user)
	. = ..()
	. += span_notice(extra_text)

/obj/item/ego_weapon/shield/officer/SpecialEgoCheck(mob/living/carbon/human/H)
	if(!H.mind)
		return FALSE
	if(H.mind.assigned_role in allowed_roles)
		return TRUE
	return  FALSE

/obj/item/ego_weapon/shield/officer/Initialize()
	. = ..()
	if(SSlobotomy_corp.next_ordeal)
		current_level = min(max_level, ceil(1 + SSlobotomy_corp.ordeal_stats/5))
	refresh_stats()
	RegisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END, PROC_REF(update_stats))

/obj/item/ego_weapon/shield/officer/proc/update_stats()
	if(current_level >= max_level)
		return
	current_level++
	if(current_holder)
		to_chat(current_holder, span_nicegreen("[src]的伤害已提升!"))
	refresh_stats()

/obj/item/ego_weapon/shield/officer/proc/refresh_stats()
	force = level_to_force[current_level]
	for(var/i = 1 to 4)
		reductions[i] = initial_reductions[i] + (armor_increase * current_level)
	if(LAZYLEN(resistances_list)) //update armor tags code
		resistances_list.Cut()
	if(reductions[1] != 0)
		resistances_list += list("RED" = reductions[1])
	if(reductions[2] != 0)
		resistances_list += list("WHITE" = reductions[2])
	if(reductions[3] != 0)
		resistances_list += list("BLACK" = reductions[3])
	if(reductions[4] != 0)
		resistances_list += list("PALE" = reductions[4])

/obj/item/ego_weapon/shield/officer/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user

/obj/item/ego_weapon/shield/officer/dropped(mob/user)
	. = ..()
	current_holder = null

/obj/item/ego_weapon/officer/blade
	name = "部长刃兵"
	desc = "供L-corp部长们使用的武器，以防不时之需，所有的部长都可以使用这把武器. "
	swingstyle = WEAPONSWING_LARGESWEEP
	hitsound = 'sound/weapons/fixer/generic/blade4.ogg'
	special = "在手中使用这把武器可切换不同的挥砍风格，钝击攻击速度极慢，但是伤害更高并伴随击倒，刺击攻击速度较慢但是距离更远.."
	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	var/swing_style = "slash"

/obj/item/ego_weapon/officer/blade/refresh_stats()
	force = level_to_force[current_level]
	if(swing_style == "blunt")
		force = round(force * 1.4)
		knockback = KNOCKBACK_LIGHT
		if(current_level > 2)
			knockback = KNOCKBACK_MEDIUM
		else if(current_level > 4)
			knockback = KNOCKBACK_HEAVY
	else
		knockback = null

/obj/item/ego_weapon/officer/blade/attack_self(mob/user)
	. = ..()
	var/message = ""
	if(swing_style == "slash")
		message = "这把武器现在处于钝击模式，每次攻击造成更多伤害并具有击倒效果，但攻击速度极慢."
		swing_style = "blunt"
		swingstyle = WEAPONSWING_SMALLSWEEP
		attack_speed = 1.6
		attack_verb_continuous = list("bashes", "clubs")
		attack_verb_simple = list("bashes", "clubs")
		hitsound = 'sound/weapons/fixer/generic/club1.ogg'
	else if(swing_style == "blunt")
		message = "这把武器现在处于刺击模式，具有额外的射程，但攻击速度较慢."
		swingstyle = WEAPONSWING_THRUST
		swing_style = "pierce"
		reach = 2
		stuntime = 5
		attack_speed = 1.2
		attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
		attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
		hitsound = 'sound/weapons/ego/spear1.ogg'
	else if(swing_style == "pierce")
		message = "这把武器现在处于挥砍模式，攻击速度更快."
		swing_style = "slash"
		attack_speed = 1
		stuntime = 0
		reach = 1
		swingstyle = WEAPONSWING_LARGESWEEP
		hitsound = 'sound/weapons/fixer/generic/blade4.ogg'
		attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
		attack_verb_simple = list("slash", "slice", "rip", "cut")
	refresh_stats()
	playsound(src, 'sound/items/screwdriver2.ogg', 50, TRUE)
	to_chat(user, span_notice("[message]"))

/obj/item/ego_weapon/officer/discipline
	name = "部长破坏剑"
	icon_state = "officer_buster"
	desc = "一把巨大的剑，能够对大多数物体造成有效破坏，由惩戒部长使用."

	special = "在手中使用以在下次攻击中造成更大伤害."
	force = 18
	attack_speed = 2
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleaves", "cuts")
	hitsound = 'sound/weapons/fixer/generic/finisher1.ogg'
	level_to_force = list(18, 26, 42, 56, 80)
	allowed_roles = list("Disciplinary Officer")
	extra_text = "这把武器只能由惩戒部长使用，击败的考验越多，这把武器的力量也会随之增强."
	swingstyle = WEAPONSWING_LARGESWEEP
	var/charged = FALSE

/obj/item/ego_weapon/officer/discipline/attack(mob/living/M, mob/living/user)
	if(charged)
		force *= 1.5
		hitsound = 'sound/abnormalities/nothingthere/goodbye_attack.ogg'
	..()
	if(charged)
		var/obj/effect/temp_visual/dir_setting/slash/s = new(get_turf(M))
		s.dir = 0
		s.layer = M.layer + 0.1
		to_chat(user, "你撕裂了[M]!")
		hitsound = initial(hitsound)
		refresh_stats()
		charged = FALSE

/obj/item/ego_weapon/officer/discipline/attack_self(mob/user)
	. = ..()
	if(!charged)
		if(do_after(user, 12, src))
			charged = TRUE
			to_chat(user,span_warning("你将力量集中在了这次攻击上。"))

/obj/item/ego_weapon/officer/discipline/get_clamped_volume()
	return 50

/obj/item/ego_weapon/officer/extraction //To do Actually do something
	name = "部长戒指"
	icon_state = "officer_ring"
	desc = "一枚黑色的戒指，能够探测到来自前G-Corp的奇点的一小部分能量，由提取官使用."
	force = 5
	attack_speed = 1.2
	damtype = BLACK_DAMAGE
	knockback = KNOCKBACK_MEDIUM
	attack_verb_continuous = list("punts", "bashes")
	attack_verb_simple = list("punts", "bash")
	level_to_force = list(5, 8, 12, 18, 28)
	allowed_roles = list("Extraction Officer")
	special = "这把武器具有远程攻击能力，攻击射线可从一个目标跳转到另一个目标.\n在手中使用时，可释放冲击波，将被击中的任何物体推开."
	extra_text = "这把武器只能由研发部长使用，击败的考验越多，这把武器的力量也会随之增强."
	var/fairy_cooldown
	var/shockwave_cooldown
	var/fairy_cooldown_time = 3 SECONDS
	var/shockwave_cooldown_time = 8 SECONDS
	var/list/fairy_damage = list(15,25,40,60,100)
	var/list/shockwave_damage = list(10,20,35,50,75)
	var/charging_attack = FALSE
	var/shockwave_range = 6

/obj/item/ego_weapon/officer/extraction/attack_self(mob/living/user)
	if(!CanUseEgo(user) || charging_attack)
		return
	if(shockwave_cooldown <= world.time)
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		charging_attack = TRUE
		playsound(user, 'sound/magic/arbiter/pillar_start.ogg', 50, TRUE)
		if(!do_after(user, 5))
			charging_attack = FALSE
			return
		charging_attack = FALSE
		var/list/turfs = circleview(proj_turf, 6)
		playsound(user, 'sound/magic/arbiter/repulse.ogg', 50, TRUE)
		for(var/i = 0 to shockwave_range)
			addtimer(CALLBACK(src, PROC_REF(shockwave), turfs,proj_turf,i, user), i)
		shockwave_cooldown = world.time + shockwave_cooldown_time
		return

/obj/item/ego_weapon/officer/extraction/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	if(!CanUseEgo(user) || charging_attack)
		return
	if(!proximity_flag && fairy_cooldown <= world.time)
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		charging_attack = TRUE
		playsound(user, 'sound/magic/arbiter/pillar_start.ogg', 50, TRUE)
		if(!do_after(user, 3))
			charging_attack = FALSE
			return
		charging_attack = FALSE
		playsound(user, 'sound/magic/arbiter/fairy.ogg', 50, TRUE)
		fairy_cooldown = world.time + fairy_cooldown_time
		var/obj/projectile/beam/officer/F = new(proj_turf)
		F.firer = user
		F.preparePixelProjectile(target, user, clickparams)
		F.damage = fairy_damage[current_level]
		F.damage *= force_multiplier
		F.fire()
		return

/obj/item/ego_weapon/officer/extraction/proc/shockwave(list/turfs, turf/start, distance, mob/living/user)
	for(var/turf/T in turfs)
		if(get_dist_euclidian(start, T) <= distance + 0.3 && get_dist_euclidian(start, T) >= max(0,distance - 0.5))
			new /obj/effect/temp_visual/small_smoke/halfsecond(T)
			for(var/mob/living/L in T) //knocks enemies away from you
				if(L == user || ishuman(L))
					continue
				L.apply_damage(shockwave_damage[current_level] * force_multiplier, damtype, null, L.run_armor_check(null, damtype), spread_damage = TRUE)
				var/throw_target = get_edge_target_turf(L, get_dir(L, get_step_away(L, start)))
				if(!L.anchored)
					var/whack_speed = 10
					L.throw_at(throw_target, 2, whack_speed, user)

/obj/item/ego_weapon/officer/extraction/refresh_stats()
	force = level_to_force[current_level]
	if(current_level > 3)
		knockback = KNOCKBACK_HEAVY

/obj/effect/projectile/tracer/laser/officer
	icon_state = "sm_arc"
	icon = 'icons/effects/beam.dmi'

/obj/projectile/beam/officer
	name = "energy blast "
	icon_state = "omnilaser"
	color = COLOR_YELLOW
	light_color = COLOR_YELLOW
	tracer_type = /obj/effect/projectile/tracer/laser/officer
	hitscan = TRUE
	speed = 0.1
	hit_stunned_targets = TRUE
	white_healing = FALSE
	damage_type = BLACK_DAMAGE
	projectile_piercing = PASSMOB
	projectile_phasing = (ALL & (~PASSMOB) & (~PASSCLOSEDTURF))
	hitscan_light_color_override = COLOR_YELLOW
	muzzle_flash_color_override = COLOR_YELLOW
	impact_light_color_override = COLOR_YELLOW
	wound_bonus = -100
	bare_wound_bonus = -100
	damage = 10
	range = 10 // Don't want people shooting it through the entire facility
	var/detect_range = 4

/obj/projectile/beam/officer/on_hit(atom/target, blocked = FALSE)
	if(!isliving(target))
		return
	var/mob/living/user = firer
	var/mob/living/enemy = target
	if(user.faction_check_mob(enemy))
		return
	. = ..()
	damage *= 0.8
	if(damage < 1)
		qdel(src)
		return
	for(var/mob/living/L in range(detect_range, src))
		if(user.faction_check_mob(L))
			continue
		if( L == target)
			continue
		if(L in impacted)
			continue
		if(L.stat == DEAD)
			continue
		if(L.status_flags & GODMODE)
			continue
		range = 8
		preparePixelProjectile(L, src, null)
		xo = 16
		yo = 16
		return
	qdel(src)

/obj/item/ego_weapon/shield/officer/records
	name = "部长军刀"
	desc = "一把古老的军刀，也可用作拐杖，由记录部长使用. "
	special = "这把武器拿在手中即可提供额外的速度加成."
	force = 2
	attack_speed = 0.5
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("stabs", "attacks", "slashes")
	attack_verb_simple = list("stab", "attack", "slash")
	hitsound = 'sound/weapons/ego/rapier1.ogg'
	level_to_force = list(2, 4, 6, 9, 14)//Meant to be overall bad for dps since its both a parry weapon and a speed boost
	initial_reductions = list(20,10,10,0)
	projectile_block_duration = 0.75 SECONDS
	block_duration = 1.25 SECONDS
	block_cooldown = 3 SECONDS
	block_message = "你尝试格挡攻击!"
	hit_message = "格挡攻击!"
	block_cooldown_message = "你重整了刀刃."
	slowdown = -0.3//its a walking cane
	item_flags = SLOWS_WHILE_IN_HAND
	allowed_roles = list("Records Officer")
	extra_text = "这把武器只能由记录部长使用. 这把武器在击败的考验越多时，力量也会随之增强."

///////////////////////
////AGENT EQUIPMENT////
///////////////////////

/obj/item/ego_weapon/city/lcorp
	icon = 'ModularTegustation/Teguicons/lcorp_weapons.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/lcorp_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lcorp_right.dmi'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 20,
							PRUDENCE_ATTRIBUTE = 20,
							TEMPERANCE_ATTRIBUTE = 20,
							JUSTICE_ATTRIBUTE = 20
							)
	var/installed_shard
	var/equipped
	custom_price = 100
	is_city_gear = FALSE

/obj/item/ego_weapon/city/lcorp/equipped(mob/user, slot, initial = FALSE)
	..()
	equipped = TRUE

/obj/item/ego_weapon/city/lcorp/dropped(mob/user)
	..()
	equipped = FALSE

/obj/item/ego_weapon/city/lcorp/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/egoshard))
		return
	if(equipped)
		to_chat(user, span_warning("需放下[src]才能执行此操作!"))
		return
	if(installed_shard)
		to_chat(user, span_warning("[src]已安装ego碎片!"))
		return
	installed_shard = I.name
	IncreaseAttributes(user, I)
	playsound(get_turf(src), 'sound/effects/light_flicker.ogg', 50, TRUE)
	qdel(I)

/obj/item/ego_weapon/city/lcorp/proc/IncreaseAttributes(mob/living/user, obj/item/egoshard/egoshard)
	damtype = egoshard.damage_type
	force = egoshard.base_damage //base damage
	for(var/atr in attribute_requirements)
		attribute_requirements[atr] = egoshard.stat_requirement
	to_chat(user, span_warning("装备[src]所需属性已提升!"))
	to_chat(user, span_nicegreen("[src]强化成功!"))
	icon_state = "[initial(icon_state)]_[egoshard.damage_type]"

/obj/item/ego_weapon/city/lcorp/examine(mob/user)
	. = ..()
	if(!installed_shard)
		. += span_warning("此武器可通过ego碎片强化.")
	else
		. += span_nicegreen("已安装[installed_shard].")

/obj/item/ego_weapon/city/lcorp/baton
	name = "L公司战术警棍"
	icon_state = "baton"
	desc = "L公司配发给无法使用E.G.O.人员的战斗警棍。"
	swingstyle = WEAPONSWING_LARGESWEEP
	hitsound = 'sound/weapons/fixer/generic/baton1.ogg'
	force = 10
	custom_price = 100


/obj/item/ego_weapon/city/lcorp/machete
	name = "L公司砍刀"
	icon_state = "machete"
	desc = "L公司配发给无法使用E.G.O.人员的开山砍刀。"
	hitsound = 'sound/weapons/fixer/generic/sword2.ogg'
	force = 6
	attack_speed = 0.5
	custom_price = 100


/obj/item/ego_weapon/city/lcorp/machete/IncreaseAttributes(mob/living/user, obj/item/egoshard/egoshard)
	..()
	force = floor(egoshard.base_damage * 0.6)

/obj/item/ego_weapon/city/lcorp/club
	name = "L公司重棍"
	icon_state = "club"
	desc = "L公司配发给无法使用E.G.O.人员的重型棍棒。"
	swingstyle = WEAPONSWING_LARGESWEEP
	hitsound = 'sound/weapons/fixer/generic/club2.ogg'
	force = 14 //Still less DPS, replaces baseball bat
	attack_speed = 1.6
	knockback = KNOCKBACK_LIGHT
	custom_price = 100


/obj/item/ego_weapon/city/lcorp/club/IncreaseAttributes(mob/living/user, obj/item/egoshard/egoshard)
	..()
	force = floor(egoshard.base_damage * 1.4)
	if(egoshard.tier >= 3)
		knockback = KNOCKBACK_MEDIUM
	if(egoshard.tier >= 5)
		knockback = KNOCKBACK_HEAVY

/obj/item/ego_weapon/shield/lcorp_shield
	name = "L公司防暴盾"
	desc = "L公司配发给无法使用E.G.O.人员的重型盾牌。"
	special = "此武器伤害极低。"
	icon_state = "shield"
	icon = 'ModularTegustation/Teguicons/lcorp_weapons.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/lcorp_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lcorp_right.dmi'
	force = 20
	damtype = RED_DAMAGE
	attack_verb_continuous = list("shoves", "bashes")
	attack_verb_simple = list("shove", "bash")
	hitsound = 'sound/weapons/genhit2.ogg'
	reductions = list(30, 0, 0, 0) // 30
	projectile_block_duration = 3 SECONDS
	block_duration = 3 SECONDS
	block_cooldown = 3 SECONDS
	block_sound_volume = 30
	custom_price = 300
	var/installed_shard
	var/equipped
	attribute_requirements = list( //They need to be listed for the attributes to increase
							FORTITUDE_ATTRIBUTE = 0,
							PRUDENCE_ATTRIBUTE = 0,
							TEMPERANCE_ATTRIBUTE = 0,
							JUSTICE_ATTRIBUTE = 0
							)

/obj/item/ego_weapon/shield/lcorp_shield/equipped(mob/user, slot, initial = FALSE)
	..()
	equipped = TRUE

/obj/item/ego_weapon/shield/lcorp_shield/dropped(mob/user)
	..()
	equipped = FALSE

/obj/item/ego_weapon/shield/lcorp_shield/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/egoshard))
		return
	if(equipped)
		to_chat(user, span_warning("需放下[src]才能执行此操作!"))
		return
	if(installed_shard)
		to_chat(user, span_warning("[src]已安装ego碎片！"))
		return
	installed_shard = I.name
	IncreaseAttributes(user, I)
	playsound(get_turf(src), 'sound/effects/light_flicker.ogg', 50, TRUE)
	qdel(I)

/obj/item/ego_weapon/shield/lcorp_shield/proc/IncreaseAttributes(mob/living/user, obj/item/egoshard/egoshard)
	damtype = egoshard.damage_type
	force = floor(egoshard.base_damage * 2) //2* base damage, 3 attack speed for shields
	for(var/atr in attribute_requirements)
		attribute_requirements[atr] = egoshard.stat_requirement
	to_chat(user, span_warning("[src]的装备需求已经提升!"))
	var/list/new_armor_values = list( //Same as armor, +20 from armor's base 2 in red
		egoshard.red_bonus + 20,
		egoshard.white_bonus,
		egoshard.black_bonus,
		egoshard.pale_bonus
	)
	reductions =  new_armor_values.Copy()
	if(LAZYLEN(resistances_list)) //armor tags code
		resistances_list.Cut()
	if(reductions[1] != 0)
		resistances_list += list("RED" = reductions[1])
	if(reductions[2] != 0)
		resistances_list += list("WHITE" = reductions[2])
	if(reductions[3] != 0)
		resistances_list += list("BLACK" = reductions[3])
	if(reductions[4] != 0)
		resistances_list += list("PALE" = reductions[4])
	to_chat(user, span_nicegreen("[src]成功的强化了!"))
	icon_state = "shield_[egoshard.damage_type]"

/obj/item/ego_weapon/shield/lcorp_shield/examine(mob/user)
	. = ..()
	if(!installed_shard)
		. += span_warning("这把武器可以通过EGO碎片强化.")
	else
		. += span_nicegreen("它已有 [installed_shard] 安装.")

/obj/item/ego_weapon/shield/lcorp_shield/Topic(href, href_list) //An override to make the attribute tag only show up when upgraded
	. = ..()
	if(!installed_shard)
		to_chat(usr, span_nicegreen("这把武器可以被任何人使用."))

/////////////////////
//OFFICER EQUIPMENT//
/////////////////////

//Nothing here at the moment

///////////////////
//CLERK EQUIPMENT//
///////////////////

//Agent baton
/obj/item/melee/classic_baton
	name = "镇暴棍"
	desc = "一根廉价的武器，用于攻击异想体或者文职."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "classic_baton"
	inhand_icon_state = "classic_baton"
	worn_icon_state = "classic_baton"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 4
	w_class = WEIGHT_CLASS_NORMAL

	var/cooldown_check = 0 // Used interally, you don't want to modify

	var/cooldown = 30 // Default wait time until can stun again.
	var/knockdown_time_carbon = (2 SECONDS) // Knockdown length for carbons. Only used when targeting legs.
	var/stun_time_silicon = (5 SECONDS) // If enabled, how long do we stun silicons.
	var/stamina_damage = 25 // Do we deal stamina damage.
	var/stunarmor_penetration = 1 // A modifier from 0 to 1. How much armor we can ignore. Less = Ignores more armor.
	var/affect_silicon = FALSE // Does it stun silicons.
	var/on_sound // "On" sound, played when switching between able to stun or not.
	var/on_stun_sound = 'sound/effects/woodhit.ogg' // Default path to sound for when we stun.
	var/stun_animation = TRUE // Do we animate the "hit" when stunning.
	var/on = TRUE // Are we on or off.

	var/on_icon_state // What is our sprite when turned on
	var/off_icon_state // What is our sprite when turned off
	var/on_inhand_icon_state // What is our in-hand sprite when turned on
	var/force_on // Damage when on - not stunning
	var/force_off // Damage when off - not stunning
	var/weight_class_on // What is the new size class when turned on

	wound_bonus = 15

//Examine text
/obj/item/melee/classic_baton/examine(mob/user)
	. = ..()

	. += span_notice("此武器运作方式与多数武器不同，可用于解除其他玩家的武装.")

	. += span_notice("其附有<a href='byond://?src=[REF(src)];'>说明标签</a>解释[src]的使用方法.")

/obj/item/melee/classic_baton/Topic(href, href_list)
	. = ..()
	var/list/readout = list("<u><b>非伤害意图的攻击将造成非致命耐力伤害，最终使目标因力竭倒地.</u></b>")
	readout += "\n瞄准腿部攻击可尝试绊倒目标."
	readout += "\n瞄准手臂攻击可迫使目标掉落该手持物。"
	to_chat(usr, "[span_notice(readout.Join())]")

// Description for trying to stun when still on cooldown.
/obj/item/melee/classic_baton/proc/get_wait_description()
	return

// Description for when turning their baton "on"
/obj/item/melee/classic_baton/proc/get_on_description()
	. = list()

	.["local_on"] = "<span class ='warning'>你展开了警棍。</span>"
	.["local_off"] = "<span class ='notice'>你收起了警棍。</span>"

	return .

// Default message for stunning mob.
/obj/item/melee/classic_baton/proc/get_stun_description(mob/living/target, mob/living/user)
	. = list()

	.["visibletrip"] =  "<span class ='danger'>[user]用[src]扫倒了[target]的双腿！</span>"
	.["localtrip"] = "<span class ='danger'>[user]用[src]扫倒了你的双腿！</span>"
	.["visibledisarm"] =  "<span class ='danger'>[user]用[src]解除了[target]的武装！</span>"
	.["localdisarm"] = "<span class ='danger'>[user]用[src]重击你的手臂，引发剧痛！</span>"
	.["visiblestun"] =  "<span class ='danger'>[user]用[src]痛击[target]！</span>"
	.["localstun"] = "<span class ='danger'>[user]用[src]痛击了你！</span>"

	return .

// Default message for stunning a silicon.
/obj/item/melee/classic_baton/proc/get_silicon_stun_description(mob/living/target, mob/living/user)
	. = list()

	.["visible"] = "<span class='danger'>[user]用警棍脉冲冲击了[target]的传感器！</span>"
	.["local"] = "<span class='danger'>你用警棍脉冲冲击了[target]的传感器！</span>"

	return .

// Are we applying any special effects when we stun to carbon
/obj/item/melee/classic_baton/proc/additional_effects_carbon(mob/living/target, mob/living/user)
	return

// Are we applying any special effects when we stun to silicon
/obj/item/melee/classic_baton/proc/additional_effects_silicon(mob/living/target, mob/living/user)
	return

/obj/item/melee/classic_baton/attack(mob/living/target, mob/living/user)
	if(!on)
		return ..()

	add_fingerprint(user)
	if((HAS_TRAIT(user, TRAIT_CLUMSY)) && prob(50))
		to_chat(user, "<span class ='userdanger'>你打中了自己的头！</span>")

		user.Paralyze(knockdown_time_carbon * force)
		user.apply_damage(stamina_damage, STAMINA, BODY_ZONE_HEAD)

		additional_effects_carbon(user) // user is the target here
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, BODY_ZONE_HEAD)
		else
			user.take_bodypart_damage(2*force)
		return
	if(iscyborg(target))
		// We don't stun if we're on harm.
		if (user.a_intent != INTENT_HARM)
			if (affect_silicon)
				var/list/desc = get_silicon_stun_description(target, user)

				target.flash_act(affect_silicon = TRUE)
				target.Paralyze(stun_time_silicon)
				additional_effects_silicon(target, user)

				user.visible_message(desc["visible"], desc["local"])
				playsound(get_turf(src), on_stun_sound, 100, TRUE, -1)

				if (stun_animation)
					user.do_attack_animation(target)
			else
				..()
		else
			..()
		return
	if(!isliving(target))
		return
	if (user.a_intent == INTENT_HARM || !ishuman(target))
		if(!..())
			return
		if(!iscyborg(target))
			return
	else
		if(cooldown_check <= world.time)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				if (H.check_shields(src, 0, "[user]'s [name]", MELEE_ATTACK))
					return
				if(check_martial_counter(H, user))
					return

			var/list/desc = get_stun_description(target, user)

			if (stun_animation)
				user.do_attack_animation(target)

			playsound(get_turf(src), on_stun_sound, 75, TRUE, -1)
			additional_effects_carbon(target, user)

			var/selected_bodypart_area = check_zone(user.zone_selected)
			var/target_limb = target.get_bodypart(selected_bodypart_area)
			var/def_check = (target.getarmor(target_limb, type = "melee") * stunarmor_penetration)
			switch(selected_bodypart_area)
				if(BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
					if(target.stat || target.IsKnockdown() || (target == user) || def_check < 41) // Can't knock down someone with shit-load of armor.
						var/armor_effect = 1 - (def_check / 100)
						target.Knockdown(knockdown_time_carbon * armor_effect)
						log_combat(user, target, "tripped", src)
						target.visible_message(desc["visibletrip"], desc["localtrip"])
						target.apply_damage(stamina_damage*0.25, STAMINA, selected_bodypart_area, def_check)
					else
						log_combat(user, target, "stunned", src)
						target.visible_message(desc["visiblestun"], desc["localstun"])
						target.apply_damage(stamina_damage, STAMINA, selected_bodypart_area, def_check)

				if(BODY_ZONE_L_ARM)
					baton_disarm(user, target, LEFT_HANDS, selected_bodypart_area, def_check)

				if(BODY_ZONE_R_ARM)
					baton_disarm(user, target, RIGHT_HANDS, selected_bodypart_area, def_check)

				else // Normal effect.
					target.apply_damage(stamina_damage, STAMINA, selected_bodypart_area, def_check)
					log_combat(user, target, "stunned", src)
					target.visible_message(desc["visiblestun"], desc["localstun"])

			add_fingerprint(user)

			if(!iscarbon(user))
				target.LAssailant = null
			else
				target.LAssailant = user
			cooldown_check = world.time + cooldown
		else
			var/wait_desc = get_wait_description()
			if (wait_desc)
				to_chat(user, wait_desc)

/obj/item/melee/classic_baton/proc/baton_disarm(mob/living/carbon/user, mob/living/carbon/target, side, bodypart_target, def_check)
	var/obj/item/I = target.get_held_items_for_side(side)
	var/list/desc = get_stun_description(target, user)
	if(I && target.dropItemToGround(I)) // There is an item in this hand. Drop it and deal slightly less stamina damage.
		log_combat(user, target, "disarmed", src)
		target.visible_message(desc["visibledisarm"], desc["localdisarm"])
		target.apply_damage(stamina_damage*0.5, STAMINA, bodypart_target, def_check)
	else // No item in that hand. Deal normal stamina damage.
		log_combat(user, target, "stunned", src)
		target.visible_message(desc["visiblestun"], desc["localstun"])
		target.apply_damage(stamina_damage, STAMINA, bodypart_target, def_check)
