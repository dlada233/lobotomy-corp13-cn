// Rest of the Midnight Ordeal EGO weapons will be added in a future PR

// FOR ADMIN USE ONLY, SHOULD NEVER BE OBTAINED IN GAME
// Weapon dps is 142.9 at 0 just, 220.9 at 130.
/obj/item/ego_weapon/the_claw
	name = "爪牙之爪"
	desc = "A large metal arm with a claw for a hand. Used by the Executioners of the Claw."
	special = "这种武器一旦装备，就不能以任何正常方式移除，在手中使用以注射选定的血清，冷却时间为30秒. \
	\n每种血清都会改变武器的伤害类型."
	icon_state = "claw"
	force = 60
	attack_speed = 0.6
	damtype = RED_DAMAGE
	slot_flags = null
	attack_verb_continuous = list("slashes", "eviscerates", "tears")
	attack_verb_simple = list("slash", "eviscerate", "tear")
	hitsound = 'ModularTegustation/Tegusounds/claw/attack.ogg'
	actions_types = list(/datum/action/item_action/switch_serum)
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 130,
		PRUDENCE_ATTRIBUTE = 130,
		TEMPERANCE_ATTRIBUTE = 130,
		JUSTICE_ATTRIBUTE = 130,
	)
	var/serum = "K"
	var/special_attack = FALSE
	var/special_cooldown
	var/special_cooldown_time = 30 SECONDS
	var/dash_charges = 3
	var/dash_limit = 3
	var/dash_range = 8
	var/justicemod
	var/dash_ignore_walls = FALSE
	var/serum_desc = "这个血清在注射2秒后治疗你25%的最大生命值."

/obj/item/ego_weapon/the_claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP) //You may not drop this, it is your arm, do you think baral can take off his claw?

/obj/item/ego_weapon/the_claw/examine(mob/user)
	. = ..()
	. += span_notice("当前血清: 血清[serum]")
	. += span_notice("[serum_desc]")

/obj/item/ego_weapon/the_claw/equipped(mob/living/user)
	. = ..()
	to_chat(user, span_warning("[src]附着在你的身体上!"))
	justicemod = get_attack_multiplier(user)

/obj/item/ego_weapon/the_claw/dropped()
	src.visible_message(span_warning("爪牙之爪不见了, 你简直违反了物理定律."))
	playsound(src, 'ModularTegustation/Tegusounds/claw/death.ogg', 50, TRUE)
	qdel(src)
	return ..()

/datum/action/item_action/switch_serum
	name = "切换血清"
	desc = "Swaps your currently selected serum."
	icon_icon = 'icons/obj/ego_weapons.dmi'
	button_icon_state = "claw"

/datum/action/item_action/switch_serum/Trigger()
	var/obj/item/ego_weapon/the_claw/H = target
	if(istype(H))
		H.SwitchSerum(owner)

/obj/item/ego_weapon/the_claw/proc/SwitchSerum(mob/living/user)
	switch(serum)
		if("K")
			serum = "R"
			serum_desc = "这个血清启用[dash_charges]次致命的冲刺到你选择的位置，对所有挡在你路上的人造成巨大的红色伤害. 这种血清的充能时间只有一半."
			damtype = RED_DAMAGE
		if("R")
			serum = "W"
			serum_desc = "这个血清锁定你选择的一个目标，并传送他们通过多个位置，最后造成巨大的黑色伤害."
			damtype = BLACK_DAMAGE
			dash_charges = dash_limit
		if("W")
			serum = "Tri"
			serum_desc = "将同时注射所有3种血清，提供你最大生命值的15%的治疗，并准备对半径12地块内的所有敌人进行大规模砍杀攻击，然而，这会使注射系统超频并使冷却时间加倍。"
			damtype = PALE_DAMAGE
			force = 40
		if("Tri")
			serum = "K"
			serum_desc = "这个血清在注射2秒后治疗你最大生命值的50%."
			damtype = WHITE_DAMAGE
			force = initial(force)
	special_attack = FALSE
	to_chat(user, span_notice("你准备好了血清[serum]."))
	playsound(src, 'ModularTegustation/Tegusounds/claw/error.ogg', 50, TRUE)

/obj/item/ego_weapon/the_claw/attack_self(mob/living/user)
	..()
	if(!CanUseEgo(user))
		return
	if(special_cooldown > world.time)
		to_chat(user, span_warning("你的血清还没有准备好!"))
		return
	switch(serum)
		if("K")
			to_chat(user, span_notice("你注射血清K."))
			playsound(src, 'ModularTegustation/Tegusounds/claw/prepare.ogg', 50, TRUE)
			var/obj/effect/serum_energy/heals = new /obj/effect/serum_energy(user.loc)
			heals.color = "#51e715"
			if(!do_after(user, 2 SECONDS, src))
				qdel(heals)
				return
			animate(heals, alpha = 0, transform = matrix()*2, time = 5)
			to_chat(user, span_notice("注射完毕，你感觉好多了."))
			user.adjustBruteLoss(-user.maxHealth*0.50) // Heals 50% of max HP, powerful because its admin only.
			special_cooldown = world.time + special_cooldown_time
			QDEL_IN(heals, 5)
		if("R")
			to_chat(user, span_notice("你准备好了血清R."))
			playsound(src, 'ModularTegustation/Tegusounds/claw/r_prep.ogg', 50, TRUE)
			special_attack = TRUE
			var/obj/effect/serum_energy/dash = new /obj/effect/serum_energy(user.loc)
			dash.color = "#c8720c"
			dash.orbit(user, 0)
			QDEL_IN(dash, 10)
		if("W")
			to_chat(user, span_notice("你准备好了血清W."))
			playsound(src, 'ModularTegustation/Tegusounds/claw/prepare.ogg', 50, TRUE)
			special_attack = TRUE
			var/obj/effect/serum_energy/death = new /obj/effect/serum_energy(user.loc)
			death.color = "#288ad3"
			death.orbit(user, 0)
			QDEL_IN(death, 10)
		if("Tri")
			to_chat(user, span_notice("你准备好了3种血清"))
			playsound(src, 'ModularTegustation/Tegusounds/claw/prepare.ogg', 50, TRUE)
			var/obj/effect/serum_energy/omega_death = new /obj/effect/serum_energy(user.loc)
			omega_death.orbit(user, 0)
			QDEL_IN(omega_death, 10)
			if(!do_after(user, 2 SECONDS, src))
				to_chat(user, span_notice("你脱离注射程序."))
				return
			special_cooldown = world.time + special_cooldown_time
			TriSerum(user)

/obj/item/ego_weapon/the_claw/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(!special_attack)
		return
	switch(serum)
		if("R") // Thanks helper
			var/turf/target_turf = get_turf(user)
			var/list/line_turfs = list(target_turf)
			var/list/mobs_to_hit = list()
			for(var/turf/T in getline(user, get_ranged_target_turf_direct(user, A , dash_range)))
				if(!dash_ignore_walls && T.density)
					break
				target_turf = T
				line_turfs += T
			user.forceMove(target_turf)
			// "Movement" effect
			for(var/i = 1 to line_turfs.len)
				var/turf/T = line_turfs[i]
				if(!istype(T))
					continue
				for(var/mob/living/L in view(1, T))
					mobs_to_hit |= L
				var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(T, user)
				D.alpha = min(150 + i*15, 255)
				animate(D, alpha = 0, time = 2 + i*2)
				for(var/turf/TT in range(T, 1))
					new /obj/effect/temp_visual/small_smoke/halfsecond(TT)
				playsound(user, 'ModularTegustation/Tegusounds/claw/move.ogg', 50, 1)
				for(var/obj/machinery/door/MD in T.contents) // Hiding behind a door mortal?
					if(MD.density)
						addtimer(CALLBACK (MD, TYPE_PROC_REF(/obj/machinery/door, open)))
			// Damage
			for(var/mob/living/L in mobs_to_hit)
				if(user.faction_check_mob(L))
					continue
				if(L.status_flags & GODMODE)
					continue
				visible_message(span_boldwarning("[user]掠过[L]!"))
				playsound(L, 'ModularTegustation/Tegusounds/claw/stab.ogg', 25, 1)
				new /obj/effect/temp_visual/cleave(get_turf(L))
				L.apply_damage(justicemod*60, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
			dash_charges--
			if(dash_charges == 0)
				special_attack = FALSE
				special_cooldown = world.time + (special_cooldown_time * 0.5)
				dash_charges = dash_limit
				to_chat(user, span_warning("你的突袭用完了."))
		if("W")
			if(!isliving(A))
				return
			var/obj/effect/temp_visual/target_field/uhoh = new /obj/effect/temp_visual/target_field(A.loc)
			uhoh.orbit(A, 0)
			playsound(A, 'ModularTegustation/Tegusounds/claw/eviscerate1.ogg', 100, 1)
			to_chat(A, span_warning("[user]锁定你了，跑也没有用."))
			if(!do_after(user, 1 SECONDS, src))
				to_chat(user, span_notice("这是什么, 神迹?"))
				qdel(uhoh)
				return
			special_attack = FALSE
			special_cooldown = world.time + special_cooldown_time
			qdel(uhoh)
			SerumW(user, A)

/obj/item/ego_weapon/the_claw/proc/SerumW(mob/living/user, mob/living/target) // It wasn't nice meeting you, farewell.
	var/turf/tp_loc = get_step(target, pick(GLOB.alldirs))
	user.forceMove(tp_loc)
	user.face_atom(target)
	new /obj/effect/temp_visual/emp/pulse(tp_loc)
	playsound(tp_loc, 'ModularTegustation/Tegusounds/claw/move.ogg', 100, 1)
	user.Stun(60 SECONDS, ignore_canstun = TRUE) // Here we go.
	target.Stun(60 SECONDS, ignore_canstun = TRUE)
	to_chat(user, span_notice("你抓住[target]的脖子."))
	to_chat(target, span_warning("你的脖子被[user]抓住了!."))
	playsound(user, 'ModularTegustation/Tegusounds/claw/w_portal.ogg', 50, 1)
	new /obj/effect/temp_visual/serum_w(target.loc)
	target.face_atom(user)
	animate(target, pixel_x = 0, pixel_z = 8, time = 5) // The gripping
	sleep(10) // Dramatic effect
	target.visible_message(
		span_warning("[user]消失, 将[target]带走了!"),
		span_userdanger("[user]将你带走了!")
	)
	animate(target, pixel_x = 0, pixel_z = 0, time = 1)
	var/list/teleport_turfs = list()
	var/list/alt = list("rcorp", "wcorp", "city")
	if(SSmaptype.maptype in alt)
		for(var/turf/T in range(12, user))
			if(!IsSafeTurf(T))
				continue
			teleport_turfs += T
	else
		for(var/turf/T in shuffle(GLOB.department_centers))
			if(T in range(12, user))
				continue
			teleport_turfs += T
	for(var/i = 1 to 5) // Thanks egor
		if(!LAZYLEN(teleport_turfs))
			break
		var/turf/target_turf = pick(teleport_turfs)
		playsound(tp_loc, 'ModularTegustation/Tegusounds/claw/eviscerate2.ogg', 100, 1)
		tp_loc.Beam(target_turf, "nzcrentrs_power", time=15)
		playsound(target_turf, 'ModularTegustation/Tegusounds/claw/eviscerate2.ogg', 100, 1)
		user.forceMove(target_turf)
		new /obj/effect/temp_visual/emp/pulse(target_turf)
		for(var/mob/living/AA in range(1, target_turf))
			if(faction_check(user.faction, AA.faction))
				continue
			if(AA == target)
				continue
			to_chat(AA, span_userdanger("[user]劈砍你!"))
			AA.apply_damage(justicemod*50, BLACK_DAMAGE, null, AA.run_armor_check(null, BLACK_DAMAGE))
			new /obj/effect/temp_visual/cleave(get_turf(AA))
		for(var/obj/item/I in get_turf(target))
			if(I.anchored)
				continue
			I.forceMove(tp_loc)
		tp_loc= get_step(user.loc, pick(GetSafeDir(get_turf(user))))
		target.forceMove(tp_loc)
		new /obj/effect/temp_visual/emp/pulse(tp_loc)
		user.face_atom(target)
		sleep(4)
	playsound(user, 'ModularTegustation/Tegusounds/claw/w_slashes.ogg', 75, 1)
	user.face_atom(target)
	target.visible_message(
		span_warning("[target]周围出现劈砍痕迹, 在这里逗留并不明智.")
	)
	for(var/turf/T in range(2, target))
		if(prob(25))
			new /obj/effect/temp_visual/justitia_effect(T)
	sleep(20)
	for(var/mob/living/AA in range(2, target))
		if(faction_check(user.faction, AA.faction))
			continue
		if(AA == target)
			continue
		to_chat(AA, span_userdanger("你开始流血!"))
		AA.apply_damage(justicemod*60, BLACK_DAMAGE, null, AA.run_armor_check(null, BLACK_DAMAGE)) // Shouldn't have gotten close.
		new /obj/effect/temp_visual/cleave(get_turf(AA))
	user.AdjustStun(-60 SECONDS, ignore_canstun = TRUE)
	target.AdjustStun(-60 SECONDS, ignore_canstun = TRUE)
	playsound(user, 'ModularTegustation/Tegusounds/claw/w_fin.ogg', 75, 1)
	target.visible_message(
		span_warning("[target]突然流血!"),
		span_userdanger("当[user]离开, 你开始流血!")
	)
	target.apply_damage(justicemod*150, BLACK_DAMAGE, null, target.run_armor_check(null, BLACK_DAMAGE)) // 150 so that it can scale form justice to about 300
	for(var/turf/T in range(1, target))
		if(prob(35))
			var/obj/effect/decal/cleanable/blood/B = new /obj/effect/decal/cleanable/blood(get_turf(target))
			B.bloodiness = 100
	if(target.health <= 0)
		target.gib()

/obj/item/ego_weapon/the_claw/proc/TriSerum(mob/living/user) // from PT, which was from Blue reverb
	var/list/targets = list()
	for(var/mob/living/L in range(12, user))
		if(L == src)
			continue
		if(faction_check(user.faction, L.faction))
			continue
		if(L.status_flags & GODMODE)
			continue
		if(L.stat == DEAD)
			continue
		targets += L
		var/obj/effect/temp_visual/target_field/blue/oh_dear = new /obj/effect/temp_visual/target_field/blue(L.loc)
		oh_dear.orbit(L, 0)
		playsound(L, 'ModularTegustation/Tegusounds/claw/eviscerate1.ogg', 25, 1)
		to_chat(L, span_warning("你被[user]盯上了!."))
		QDEL_IN(oh_dear, 10)
	if(!LAZYLEN(targets))
		to_chat(user, span_warning("附近没有敌人!"))
		return
	new /obj/effect/temp_visual/serum_w(user.loc)
	playsound(user, 'ModularTegustation/Tegusounds/claw/w_portal.ogg', 50, 1)
	sleep(1 SECONDS) // Dramatic effect
	for(var/mob/living/L in targets)
		var/turf/prev_loc = get_turf(user)
		var/turf/tp_loc= get_step(L.loc, pick(GetSafeDir(get_turf(L))))
		user.forceMove(tp_loc)
		to_chat(L, span_userdanger("[user]屠杀你!"))
		playsound(L, 'ModularTegustation/Tegusounds/claw/eviscerate2.ogg', 100, 1)
		L.apply_damage(justicemod*60, PALE_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
		prev_loc.Beam(tp_loc, "bsa_beam", time=25)
		new /obj/effect/temp_visual/cleave(get_turf(L))
		sleep(3)

/obj/effect/serum_energy
	name = "血清能量"
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "white_shield"
	layer = BYOND_LIGHTING_LAYER
	plane = BYOND_LIGHTING_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/temp_visual/serum_w
	name = "血清w传送门"
	desc = "No... Not again..."
	icon = 'icons/effects/effects.dmi'
	icon_state = "blueshatter"
	randomdir = FALSE
	duration = 1 SECONDS
	layer = POINT_LAYER
