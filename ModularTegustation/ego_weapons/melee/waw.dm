/obj/item/ego_weapon/lamp
	name = "目灯"
	desc = "大鸟's eyes gained another in number for every creature it saved. \
	On this weapon, the radiant pride is apparent."
	special = "该武器攻击范围内所有的非人单位. \
			该武器在进行直接攻击时造成双倍伤害."
	icon_state = "lamp"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 12 // Does +14 with AOE
	attack_speed = 1.3
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("slams", "attacks")
	attack_verb_simple = list("slam", "attack")
	hitsound = 'sound/weapons/ego/hammer.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
	)

/obj/item/ego_weapon/lamp/attack(mob/living/M, mob/living/user)
	var/turf/target_turf = get_turf(M)
	. = ..()
	if(!.)
		return FALSE
	var/aoe = 14
	var/justicemod = get_attack_multiplier(user)
	aoe *= justicemod
	aoe *= force_multiplier
	for(var/mob/living/L in hearers(1, target_turf))
		if(L == user || ishuman(L))
			continue
		L.apply_damage(aoe, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))


/obj/item/ego_weapon/despair
	name = "盈泪之剑"
	desc = "A sword suitable for swift thrusts. \
	Even someone unskilled in dueling can rapidly puncture an enemy using this E.G.O with remarkable agility."
	special = "这把武器拥有一套连击系统，在手上使用来关闭. \
			它的攻击速度很快"
	icon_state = "despair"
	force = 10
	modified_attack_speed = 0.4
	damtype = WHITE_DAMAGE
	swingstyle = WEAPONSWING_THRUST
	attack_verb_continuous = list("stabs", "attacks", "slashes")
	attack_verb_simple = list("stab", "attack", "slash")
	hitsound = 'sound/weapons/ego/rapier1.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)
	var/combo = 0
	var/combo_time
	var/combo_wait = 10
	var/combo_on = TRUE

/obj/item/ego_weapon/despair/attack_self(mob/user)
	..()
	if(combo_on)
		to_chat(user,span_warning("你转换握姿，将不再执行终结技."))
		combo_on = FALSE
		return
	if(!combo_on)
		to_chat(user,span_warning("你转换握姿，将施展终结技."))
		combo_on =TRUE
		return

//This is like an anime character attacking like 4 times with the 4th one as a finisher attack.
/obj/item/ego_weapon/despair/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time || !combo_on)	//or you can turn if off I guess
		combo = 0
	combo_time = world.time + combo_wait
	if(combo==4)
		combo = 0
		user.changeNext_move(CLICK_CD_MELEE * 2)
		force *= 5	// Should actually keep up with normal damage.
		playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
		to_chat(user,span_warning("你失去了平衡，需要一点时间来重新调整姿态."))
	else
		user.changeNext_move(CLICK_CD_MELEE * 0.4)
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/despair/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/nihil/spade))
		return
	new /obj/item/ego_weapon/shield/despair_nihil(get_turf(src))
	to_chat(user,span_warning("[I]在被[src]吸收时，似乎也吸走了所有的光!"))
	playsound(user, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)
	qdel(I)
	qdel(src)

/obj/item/ego_weapon/totalitarianism
	name = "极权主义"
	desc = "When one is oppressed, sometimes they try to break free."
	special = "在手中使用可以解锁全部力量."
	icon_state = "totalitarianism"
	force = 72
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_speed = 3
	damtype = RED_DAMAGE
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleaves", "cuts")
	hitsound = 'sound/weapons/fixer/generic/finisher1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	var/charged = FALSE

/obj/item/ego_weapon/totalitarianism/attack(mob/living/M, mob/living/user)
	..()
	force = 72
	charged = FALSE

/obj/item/ego_weapon/totalitarianism/attack_self(mob/user)
	if(do_after(user, 12, src))
		charged = TRUE
		force = 96	//FULL POWER
		to_chat(user,span_warning("你在这次攻击中投入了全部力量."))

/obj/item/ego_weapon/totalitarianism/get_clamped_volume()
	return 50

/obj/item/ego_weapon/oppression
	name = "压迫者"
	desc = "Even light forms of contraint can be considered totalitarianism"
	special = "这把武器每次击中时都将积累能量，在手中使用可以释放能量到刀刃上."
	icon_state = "oppression"
	force = 8
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_speed = 0.3
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleaves", "cuts")
	hitsound = 'sound/weapons/fixer/generic/blade4.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)
	var/charged = FALSE
	var/meter = 0
	var/meter_counter = 1

/obj/item/ego_weapon/oppression/attack_self(mob/user)
	if (!charged)
		charged = TRUE
		to_chat(user,span_warning("你释放能量，为下次攻击增加[meter]伤害."))
		force += meter
		meter = 0

/obj/item/ego_weapon/oppression/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	meter += meter_counter
	meter_counter += 1

	meter = min(meter, 40)
	..()
	if(charged == TRUE)
		charged = FALSE
		force = 8
		meter_counter = 0

/obj/item/ego_weapon/remorse
	name = "悔恨"
	desc = "A hammer and nail, unwieldy and impractical against most. \
	Any crack, no matter how small, will be pried open by this E.G.O."
	special = "这把武器攻速较慢."
	icon_state = "remorse"
	special = "在手中使用这把武器可以改变它的模式. \
		钉击模式将目标打上死亡标记. \
		锤击模式将对所有有标记的人造成额外伤害."
	force = 20	//Does more damage later.
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("Smashes", "Pierces", "Cracks")
	attack_verb_simple = list("Smash", "Pierce", "Crack")
	hitsound = 'sound/weapons/ego/remorse.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	var/list/targets = list()
	var/ranged_damage = 40	//Fuckload of white on ability. Be careful!
	var/mode = FALSE		//False for nail, true for hammer

/obj/item/ego_weapon/remorse/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return

	if(!mode)
		if(!(M in targets))
			targets+= M

	if(mode)
		if(M in targets)
			playsound(M, 'sound/weapons/fixer/generic/nail1.ogg', 100, FALSE, 4)
			M.apply_damage(ranged_damage, WHITE_DAMAGE, null, M.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
			new /obj/effect/temp_visual/remorse(get_turf(M))
			targets -= M
	..()

/obj/item/ego_weapon/remorse/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(mode)	//Turn to nail
		mode = FALSE
		to_chat(user,span_warning("你切换到钉击模式，清除所有标记."))
		targets = list()
		return

	if(!mode)	//Turn to hammer
		mode = TRUE
		to_chat(user,span_warning("你切换到锤击模式."))
		return

/obj/item/ego_weapon/mini/crimson
	name = "猩红创痕"
	desc = "It's more important to deliver a decisive strike in blind hatred without hesitation than to hold on to insecure courage."
	special = "手中使用以激活远程攻击."
	icon_state = "crimsonclaw"
	special = "这把武器攻速较快."
	force = 12
	swingstyle = WEAPONSWING_LARGESWEEP
	modified_attack_speed = 0.6
	damtype = RED_DAMAGE
	hitsound = 'sound/abnormalities/redhood/attack_1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

	var/combo = 1
	var/combo_time
	var/combo_wait = 20
	// "Throwing" attack
	var/special_attack = FALSE
	var/special_damage = 50
	var/special_cooldown
	var/special_cooldown_time = 8 SECONDS
	var/special_checks_faction = FALSE

/obj/item/ego_weapon/mini/crimson/get_clamped_volume() //this is loud as balls without this proc
	return 20

/obj/item/ego_weapon/mini/crimson/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 1
	combo_time = world.time + combo_wait
	switch(combo)
		if(2)
			hitsound = 'sound/abnormalities/redhood/attack_2.ogg'
		if(3)
			hitsound = 'sound/abnormalities/redhood/attack_3.ogg'
		else
			hitsound = 'sound/abnormalities/redhood/attack_1.ogg'
	force *= (1 + (combo * 0.15))
	user.changeNext_move(CLICK_CD_MELEE * (0.5 + (combo * 0.2)))
	if(combo >= 3)
		combo = 0
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/mini/crimson/attack_self(mob/living/user)
	if(!CanUseEgo(user))
		return
	if(special_cooldown > world.time)
		return
	special_attack = !special_attack
	if(special_attack)
		to_chat(user, span_notice("你准备好投掷[src]."))
	else
		to_chat(user, span_notice("你暂时觉得不投掷[src]."))

/obj/item/ego_weapon/mini/crimson/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(special_cooldown > world.time)
		return
	if(!special_attack)
		return
	special_attack = FALSE
	special_cooldown = world.time + special_cooldown_time
	var/turf/target_turf = get_ranged_target_turf_direct(user, A, 8)
	var/list/turfs_to_hit = list()
	for(var/turf/T in getline(user, target_turf))
		if(T.density)
			break
		if(locate(/obj/machinery/door) in T)
			continue
		turfs_to_hit += T
	if(!LAZYLEN(turfs_to_hit))
		return
	playsound(user, 'sound/abnormalities/redhood/throw.ogg', 75, TRUE, 3)
	user.visible_message(span_warning("[user]投掷[src]向[A]!"))
	var/dealing_damage = special_damage // Damage reduces a little with each mob hit
	dealing_damage*=force_multiplier
	for(var/i = 1 to turfs_to_hit.len) // Basically, I copied my code from helper's realized ability. Yep.
		var/turf/open/T = turfs_to_hit[i]
		if(!istype(T))
			continue
		// Effects
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(T, src)
		var/matrix/M = matrix(D.transform)
		M.Turn(45 * i)
		D.transform = M
		D.alpha = min(150 + i*15, 255)
		animate(D, alpha = 0, time = 2 + i*2)
		// Actual damage
		for(var/obj/structure/window/W in T)
			W.obj_destruction("[src.name]")
		for(var/mob/living/L in T)
			if(L == user)
				continue
			if(special_checks_faction && user.faction_check_mob(L))
				continue
			to_chat(L, span_userdanger("你被[src]击中了!"))
			L.apply_damage(dealing_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))
			dealing_damage = max(dealing_damage * 0.9, special_damage * 0.3)

/obj/item/ego_weapon/thirteen
	name = "丧钟无声"
	desc = "Time flows as life does, and life goes as time does."
	special = "这把武器在第十三次命中时造成惊人伤害."
	icon_state = "thirteen"
	lefthand_file = 'icons/mob/inhands/96x96_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/96x96_righthand.dmi'
	inhand_x_dimension = 96
	inhand_y_dimension = 96
	force = 20
	swingstyle = WEAPONSWING_LARGESWEEP
	damtype = PALE_DAMAGE
	attack_verb_continuous = list("cuts", "attacks", "slashes")
	attack_verb_simple = list("cut", "attack", "slash")
	hitsound = 'sound/weapons/rapierhit.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)
	var/combo = 0
	var/combo_time
	var/combo_wait = 3 SECONDS

//On the 13th hit, Deals user justice x 2
/obj/item/ego_weapon/thirteen/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait
	if(combo >= 13)
		combo = 0
		force = get_modified_attribute_level(user, JUSTICE_ATTRIBUTE)
		new /obj/effect/temp_visual/thirteen(get_turf(M))
		playsound(src, 'sound/weapons/ego/price_of_silence.ogg', 25, FALSE, 9)
	..()
	combo += 1
	force = initial(force)


/obj/item/ego_weapon/stem
	name = "绿色枝干"
	desc = "All personnel involved in the equipment's production wore heavy protection to prevent them from being influenced by the entity."
	special = "持有此武器可以免疫白雪公主藤蔓的减速效果. \
				当在手中使用时，使用者将在引导7秒后发动藤蔓爆发，击中使用者周围三格范围内的所有敌人. \
				如果在30%SP以下发动藤蔓爆发，伤害会提高50%! \
				但由于F-04-42的强烈恨意，此时攻击将会对盟友也造成伤害."
	icon_state = "green_stem"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 24
	reach = 2		//Has 2 Square Reach.
	stuntime = 5	//Longer reach, gives you a short stun.
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	equip_sound = 'sound/creatures/venus_trap_hit.ogg'
	pickup_sound = 'sound/creatures/venus_trap_hurt.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80
							)
	var/vine_cooldown = 0
	/*
	* Added for debugging. channeling_duration_start
	* is divided by each cycle. So if we go through 2
	* channeling cycles the duration of the channel would
	* be (channelling_duration_start / 2). After 6 cycles
	* the channeling ends. At the end of each cycle
	* vine_damage is applied to enemies in a 5 tile AOE.
	*/
	var/channeling_duration_start = 1 SECONDS
	var/channeling_cycle_max = 6
	var/vine_damage = 20

/obj/item/ego_weapon/stem/attack_self(mob/living/user)
	. = ..()
	if(!CanUseEgo(user))
		return
	if(vine_cooldown <= world.time)
		user.visible_message(span_notice("[user]将[src]刺入地面."), span_nicegreen("你将[src]刺入地面."))
		vine_cooldown = world.time + (channeling_duration_start * channeling_cycle_max)
		vine_damage *=force_multiplier
		var/mob/living/carbon/human/L = user
		var/vine_damage_bonus = 0
		var/affected_mobs = 0
		AlterMoveResist(user, 2.5)
		//Bonus Damage is applied if sanity is below 30%
		if(L.sanityhealth <= (L.maxSanity * 0.3))
			to_chat(user, span_warning("当[src]深入你的手臂时，你感受到她的影响."))
			vine_damage_bonus = vine_damage * 0.5

		for(var/i = 1 to channeling_cycle_max)
			//Burst is (channeling_duration_start / channeling_cycle_max) seconds
			var/channel_level = channeling_duration_start / i
			if(!do_after(user, channel_level, target = user))
				to_chat(user, span_warning("你的藤蔓爆发被打断了."))
				AlterMoveResist(user, 0.4)
				break
			for(var/mob/living/C in oview(5, get_turf(src)))
				//If you have a vine damage bonus, destroy them ALL.
				if(user.faction_check_mob(C) && !vine_damage_bonus)
					continue
				new /obj/effect/temp_visual/vinespike(get_turf(C))
				C.apply_damage(vine_damage + vine_damage_bonus, BLACK_DAMAGE, null, C.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
				affected_mobs += 1
			playsound(loc, 'sound/creatures/venus_trap_hurt.ogg', min(75, affected_mobs * 15), TRUE, round( affected_mobs * 0.5))
		AlterMoveResist(user, 0.4)

/*
* Alters Move resist to prevent knockback
* throw_safe knockback checks for anchored
* or a lower move_resist to its force.
* The default force is MOVE_FORCE_STRONG
* which is 2x the force of default.
* To be honest this should be a mob proc.
*/
/obj/item/ego_weapon/stem/proc/AlterMoveResist(mob/living/M, num)
	if(!M || !num)
		return
	M.move_resist *= num

/obj/item/ego_weapon/ebony_stem
	name = "黑色枝干"
	desc = "An apple does not culminate when it ripens to bright red; \
	only when the apple shrivels up and attracts lowly creatures."
	special = "该武器具有远程攻击."
	icon_state = "ebony_stem"
	force = 24
	damtype = BLACK_DAMAGE
	swingstyle = WEAPONSWING_THRUST
	attack_verb_continuous = list("admonishes", "rectifies", "conquers")
	attack_verb_simple = list("admonish", "rectify", "conquer")
	hitsound = 'sound/weapons/ego/rapier2.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	var/ranged_cooldown
	var/ranged_cooldown_time = 1.2 SECONDS
	var/ranged_damage = 20

/obj/item/ego_weapon/ebony_stem/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(ranged_cooldown > world.time)
		to_chat(user, "<span class='warning'>你的远程攻击尚在充能中!")
		return
	if(!CanUseEgo(user))
		return
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf))
		return
	if((get_dist(user, target_turf) < 2) || !(target_turf in view(10, user)))
		return
	..()
	ranged_cooldown = world.time + ranged_cooldown_time
	if(do_after(user, 5))
		var/damage_dealt = (ranged_damage * force_multiplier)
		playsound(target_turf, 'sound/abnormalities/ebonyqueen/attack.ogg', 50, TRUE)
		for(var/turf/open/T in RANGE_TURFS(1, target_turf))
			new /obj/effect/temp_visual/thornspike(T)
			user.HurtInTurf(T, list(), damage_dealt, BLACK_DAMAGE, hurt_mechs = TRUE)

/obj/item/ego_weapon/wings // Is this overcomplicated? Yes. But I'm finally happy with what I want to make of this weapon.
	name = "折翼"
	desc = "He stopped, gave a deep sigh, quickly tore from his shoulders the ribbon Marie had tied around him, \
		pressed it to his lips, put it on as a token, and, bravely brandishing his bare sword, \
		jumped as nimbly as a bird over the ledge of the cabinet to the floor."
	special = "这个武器有一个独特的连击系统，每次点击攻击两次.\n \
		按Z键进行旋转攻击，点击一个远处目标，以固定方向冲向他们."
	icon_state = "wings"
	force = 12
	attack_speed = 0.6
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slashes", "claws")
	attack_verb_simple = list("slashes", "claws")
	hitsound = 'sound/weapons/fixer/generic/dodge3.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60
							)
	var/hit_count = 0
	var/max_count = 16
	var/special_cost = 4
	var/special_force = 10
	var/special_combo = 0
	var/special_combo_mult = 0.2
	var/decay_time = 3 SECONDS
	var/combo_hold
	var/special_combo_hold
	var/special_cooldown = 3
	var/specialing = FALSE
	var/list/hit_turfs = list()

/obj/item/ego_weapon/wings/attack(mob/living/M, mob/living/user) // This part's simple, basically Oppression but with decay.
	if(!CanUseEgo(user))
		return
	if(world.time > combo_hold) // Your combo ended.
		hit_count = 0
	if(max_count > hit_count)
		hit_count++
	else if(prob(10))
		to_chat(user, span_notice("[src]的羽毛竖立!")) // "Hey dumbass, you can stop smacking them now"
	combo_hold = world.time + decay_time
	..()
	INVOKE_ASYNC(src, PROC_REF(SecondSwing), M, user)
	return

/obj/item/ego_weapon/wings/attack_self(mob/user)
	. = ..()
	if(world.time > combo_hold && hit_count > 0)
		to_chat(user, span_notice("[src]的羽毛飘落...")) // Notify you the combo's over
		hit_count = 0
	if(!(special_cost > hit_count) && !(specialing))
		specialing = TRUE
		combo_hold = world.time + decay_time
		hit_count -= special_cost
		if(special_combo < 4) // Special combo goes up to 5.
			special_combo++
		else if(prob(20)) // If your special combo is at max, you get some glory.
			user.visible_message(span_notice("[user]犹如疾风!"))
		Pirouette(user)
		specialing = FALSE

/obj/item/ego_weapon/wings/afterattack(atom/A, mob/living/user, params) // Time for the ANIME BLADE DASH ATTACK
	if(world.time > combo_hold && hit_count > 0)
		to_chat(user, span_notice("[src]的羽毛飘落..."))
		hit_count = 0
		return
	if(special_cost > hit_count || !CanUseEgo(user) || get_dist(get_turf(A), get_turf(user)) < 2 || specialing)
		return
	var/aim_dir = get_cardinal_dir(get_turf(user), get_turf(A)) // You can only anime dash in a cardinal direction.
	if(CheckPath(user, aim_dir))
		to_chat(user,span_notice("你需要更大的空间!"))
	else
		user.visible_message(span_notice("[user]向前跃进, [src]在手中起舞!")) // ANIME AS FUCK
		playsound(src, hitsound, 75, FALSE, 4) // Might need a punchier sound, but none come to mind.
		hit_count -= special_cost
		combo_hold = world.time + decay_time // Specials continue the regular AND special combo.
		if(special_combo_hold > world.time)
			if(special_combo < 4)
				special_combo++
			else if(prob(20))
				user.visible_message(span_notice("[user]犹如疾风!"))
		else
			special_combo = 1
		special_combo_hold = world.time + decay_time
		hit_turfs = list() // Clear the list of turfs we hit last time
		specialing = TRUE
		addtimer(CALLBACK(src, PROC_REF(ResetSpecial)), special_cooldown)// Engage special cooldown
		Leap(user, aim_dir, 0)
	return

/obj/item/ego_weapon/wings/proc/Pirouette(mob/living/user)
	user.visible_message(span_notice("[user]原地旋转, [src]向敌人飞旋而出!")) // You cool looking bitch
	playsound(src, hitsound, 75, FALSE, 4)
	for(var/turf/T in orange(1, user)) // Most of this code was jacked from Harvest tbh
		new /obj/effect/temp_visual/smash_effect(T)
	var/aoe = special_force * (1 + special_combo_mult * special_combo)
	var/justicemod = get_attack_multiplier(user)
	aoe*=justicemod
	aoe*=force_multiplier
	for(var/mob/living/L in range(1, user))
		if(L == user) // Might remove FF immunity sometime
			continue
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(!H.sanity_lost)
				continue
		L.apply_damage(aoe, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		L.visible_message(span_danger("[user]切割[L]!"))

/obj/item/ego_weapon/wings/proc/Leap(mob/living/user, dir = SOUTH, times_ran = 3)
	user.forceMove(get_step(get_turf(user), dir))
	var/end_leap = FALSE
	if(times_ran > 2)
		end_leap = TRUE
	if(CheckPath(user, dir)) // If we have something ahead of us, yes, but we're ALSO going to attack around us
		to_chat(user,span_notice("你飞跃较短!"))
		for(var/turf/T in orange(1, user)) // I hate having to use this code twice but it's TWO LINES and I don't need to use callbacks with it so it's not getting a proc
			hit_turfs |= T
		end_leap = TRUE
	if(end_leap)
		for(var/turf/T in hit_turfs) // Once again mostly jacked from harvest, but modified to work with hit_turfs instead of an on-the-spot orange
			new /obj/effect/temp_visual/smash_effect(T)
			for(var/mob/living/L in T.contents)
				var/aoe = special_force * 1 + (special_combo_mult * special_combo)
				var/justicemod = get_attack_multiplier(user)
				aoe*=justicemod
				aoe*=force_multiplier
				if(L == user)
					continue
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(!H.sanity_lost)
						continue
				L.apply_damage(aoe, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
				L.visible_message(span_danger("[user] evicerates [L]!"))
		return
	for(var/turf/T in orange(1, user))
		hit_turfs |= T
	addtimer(CALLBACK(src, PROC_REF(Leap), user, dir, times_ran + 1), 0.1)

/obj/item/ego_weapon/wings/proc/CheckPath(mob/living/user, dir = SOUTH)
	var/list/immediate_path = list() // Looks two tiles ahead for anything dense; the leap attack must move you at least one tile and will stop one tile short of a dense one
	immediate_path |= get_step(get_turf(user), dir)
	immediate_path |= get_step(immediate_path[1], dir)
	var/fail_charge = FALSE
	for(var/turf/T in immediate_path)
		if(T.density)
			fail_charge = TRUE
		for(var/obj/machinery/door/D in T.contents)
			if(D.density)
				fail_charge = TRUE
		for(var/obj/structure/window/W in T.contents)
			fail_charge = TRUE
	return fail_charge

/obj/item/ego_weapon/wings/proc/SecondSwing(mob/living/M, mob/living/user)
	sleep(CLICK_CD_MELEE*attack_speed*0.5+1)
	if(get_dist(M, user) > 1)
		return
	if(force && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("你不想伤害其他生物!"))
		return
	if(max_count > hit_count)
		hit_count++
	else if(prob(10))
		to_chat(user, span_notice("[src]的羽毛竖立!")) // "Hey dumbass, you can stop smacking them now"
	combo_hold = world.time + decay_time
	playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
	user.do_attack_animation(M)
	M.attacked_by(src, user)

	log_combat(user, M, "attacked", src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")

/obj/item/ego_weapon/wings/proc/ResetSpecial()
	specialing = FALSE

/obj/item/ego_weapon/mini/mirth
	name = "欢声笑语"
	desc = "A round of applause, for the clowns who joined us for tonight’s show!"
	special = "这把剑可以和它的姊妹剑结合，创造出一种新的武器."
	icon_state = "mirth"
	force = 12
	attack_speed = 0.5
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("cuts", "attacks", "slashes")
	attack_verb_simple = list("cut", "attack", "slash")
	hitsound = 'sound/weapons/ego/sword1.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
							)

	var/dash_cooldown
	var/dash_cooldown_time = 4 SECONDS
	var/dash_range = 6

/obj/item/ego_weapon/mini/mirth/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/ego_weapon/mini/malice))
		return
	switch(tgui_alert(user,"将[I]和[src]结合成一把新的E.G.O.? 这把新武器需要100的勇气和80的其他属性来装备.","结合E.G.O.",list("Yes", "No"), 5 SECONDS))
		if("Yes")
			if(get_dist(src, user) > 1 || get_dist(I, user) > 1)
				to_chat(user, span_notice("你离得太远了，无法进行结合工作!"))
				return
		if("No")
			return FALSE
	playsound(loc, 'sound/items/screwdriver.ogg', 100, TRUE)
	var/obj/item/ego_weapon/wield/darkcarnival/theweapon = new /obj/item/ego_weapon/wield/darkcarnival(get_turf(src))
	var/obj/item/ego_weapon/mini/malice/component = I
	theweapon.force_multiplier = max(component.force_multiplier, force_multiplier)
	to_chat(user, span_notice("你将[src]和[I]结合成[theweapon]!"))
	qdel(I)
	qdel(src)

/obj/item/ego_weapon/mini/mirth/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(!isliving(A))
		return
	if(dash_cooldown > world.time)
		to_chat(user, "<span class='warning'>你的突袭还在充能!")
		return
	if((get_dist(user, A) < 2) || (!(can_see(user, A, dash_range))))
		return
	..()
	dash_cooldown = world.time + dash_cooldown_time
	for(var/i in 2 to get_dist(user, A))
		step_towards(user,A)
	if(get_dist(user, A) < 2)
		A.attackby(src,user)
	playsound(src, 'sound/abnormalities/clownsmiling/jumpscare.ogg', 50, FALSE, 9)
	to_chat(user, "<span class='warning'>你向[A]突袭!")

/obj/item/ego_weapon/mini/malice
	name = "恶意不息"
	desc = "Seeing that I wasn't amused, it took out another tool. \
	I thought it was a tool. Just that moment."
	special = "这把剑可以和它的姊妹剑结合，创造出一种新的武器."
	icon_state = "malice"
	force = 12
	attack_speed = 0.5
	damtype = RED_DAMAGE
	attack_verb_continuous = list("cuts", "attacks", "slashes")
	attack_verb_simple = list("cut", "attack", "slash")
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
							)

	var/dash_cooldown
	var/dash_cooldown_time = 4 SECONDS
	var/dash_range = 6

/obj/item/ego_weapon/mini/malice/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/ego_weapon/mini/mirth))
		return
	switch(tgui_alert(user,"将[I]和[src]结合成一把新的E.G.O.? 这把新武器需要100的勇气和80的其他属性来装备.","结合E.G.O.",list("Yes", "No"), 5 SECONDS))
		if("Yes")
			if(get_dist(src, user) > 1 || get_dist(I, user) > 1)
				to_chat(user, span_notice("你离得太远了，无法进行结合工作!"))
				return
		if("No")
			return FALSE
	playsound(loc, 'sound/items/screwdriver.ogg', 100, TRUE)
	var/obj/item/ego_weapon/wield/darkcarnival/theweapon = new /obj/item/ego_weapon/wield/darkcarnival(get_turf(src))
	var/obj/item/ego_weapon/mini/mirth/component = I
	theweapon.force_multiplier = max(component.force_multiplier, force_multiplier)
	to_chat(user, span_notice("你将[src]和[I]结合成[theweapon]!"))
	qdel(I)
	qdel(src)

/obj/item/ego_weapon/mini/malice/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(!isliving(A))
		return
	if(dash_cooldown > world.time)
		to_chat(user, "<span class='warning'>你的突袭还在充能!")
		return
	if((get_dist(user, A) < 2) || (!(can_see(user, A, dash_range))))
		return
	..()
	dash_cooldown = world.time + dash_cooldown_time
	for(var/i in 2 to get_dist(user, A))
		step_towards(user,A)
	if(get_dist(user, A) < 2)
		A.attackby(src,user)
	playsound(src, 'sound/abnormalities/clownsmiling/jumpscare.ogg', 50, FALSE, 9)
	to_chat(user, "<span class='warning'>你向[A]突袭!")

/obj/item/ego_weapon/shield/swan
	name = "黑天鹅"
	desc = "It yeared for a dream it would never wake up from, but reality was as cruel as ever.\
	All that was left is a worn parasol it once treasured."
	special = "这把武器在格挡前有小蓄力动作, 并在成功格挡成功时发动反击."
	icon_state = "swan_closed"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 10
	attack_speed = 0.5
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("bashs", "whaps", "beats", "prods", "pokes")
	attack_verb_simple = list("bash", "whap", "beat", "prod", "poke")
	hitsound = 'sound/weapons/fixer/generic/spear1.ogg'
	reductions = list(40, 30, 50, 30) // 150
	projectile_block_duration = 1 SECONDS
	block_duration = 3 SECONDS // Exempt from normal reduction due to block restriction.
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/ego/clash1.ogg'
	projectile_block_message = "你将投射物弹开!"
	block_cooldown_message = "你重新握持E.G.O."
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)
	var/close_cooldown
	var/close_cooldown_time = 6 SECONDS
	var/reflect_cooldown
	var/reflect_cooldown_time = 1 //need to prevent simultaneous hits; bullets overlapping is very bad.

/obj/item/ego_weapon/shield/swan/attack_self(mob/user)
	if(close_cooldown > world.time) //prevents shield usage with no DPS loss
		to_chat(user,span_warning("你没法这么频繁的使用!"))
		return
	if(do_after(user, 4, src))
		icon_state = "swan"
		close_cooldown = world.time + close_cooldown_time
		..()
	user.update_inv_hands()

/obj/item/ego_weapon/shield/swan/DisableBlock(mob/living/carbon/human/user)
	. = ..()
	icon_state = "swan_closed"
	to_chat(user,span_nicegreen("你合上了伞."))
	user.update_inv_hands()
	return

/obj/item/ego_weapon/shield/swan/AnnounceBlock(mob/living/carbon/human/source, damage, damagetype, def_zone)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(Reflect), source, damage)

/obj/item/ego_weapon/shield/swan/proc/Reflect(mob/living/carbon/human/user, damage, damagetype, def_zone)
	if(!block)
		return
	if(reflect_cooldown > world.time)
		return
	reflect_cooldown = world.time + reflect_cooldown_time
	var/turf/proj_turf = user.loc
	if(!isturf(proj_turf))
		return
	var/list/mob_list = list()
	for(var/mob/living/simple_animal/hostile/H in livinginview(8, user))
		mob_list += H
	if(!mob_list.len)
		return
	var/mob/living/simple_animal/hostile/target = pick(mob_list)
	var/obj/projectile/ego_bullet/swan/S = new /obj/projectile/ego_bullet/swan(proj_turf)
	S.fired_from = src //for signal check
	playsound(user, 'sound/weapons/resonator_blast.ogg', 30, TRUE)
	S.firer = user
	S.preparePixelProjectile(target, user)
	S.fire()
	S.damage *= force_multiplier
	return

/obj/item/ego_weapon/shield/swan/Initialize()
	RegisterSignal(src, COMSIG_PROJECTILE_ON_HIT, PROC_REF(projectile_hit))
	return ..()

/obj/item/ego_weapon/shield/swan/proc/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	SIGNAL_HANDLER
	return TRUE

/obj/projectile/ego_bullet/swan
	name = "粘性物质"
	icon_state = "neurotoxin"
	damage = 16
	damage_type = BLACK_DAMAGE

	hitsound = 'sound/abnormalities/wrath_servant/small_smash1.ogg'
	hitsound_wall = 'sound/abnormalities/wrath_servant/small_smash1.ogg'

/obj/item/ego_weapon/moonlight
	name = "月光"
	desc = "The serpentine ornament is loyal to the original owner’s taste. The snake’s open mouth represents the endless yearning for music."
	special = "在手中使用来恢复周围人的理智."
	icon_state = "moonlight"
	force = 20
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("beats", "jabs")
	attack_verb_simple = list("beat", "jab")
	var/ability_cooldown
	var/ability_cooldown_time = 30 SECONDS
	var/shield_hp = 50
	var/aoe_damage = 30
	var/inuse
	var/shield_time = 15 SECONDS
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/moonlight/attack_self(mob/user)
	. = ..()
	if(!CanUseEgo(user))
		return

	if(ability_cooldown > world.time)
		to_chat(user,span_warning("你使用太过频繁."))
		return

	if(inuse)
		return

	inuse = TRUE

	if(!do_after(user, 15))	//1.5 seconds is fair enough for getting a shield
		inuse = FALSE
		return
	inuse = FALSE
	ability_cooldown = ability_cooldown_time + world.time
	var/aoe = aoe_damage
	var/justicemod = get_attack_multiplier(user)
	aoe *= justicemod
	aoe *= force_multiplier
	var/list/been_hit = list()
	for(var/turf/T in view(user, 1))
		been_hit += user.HurtInTurf(T, list(), aoe, damtype, check_faction = TRUE, hurt_mechs = TRUE)
		new /obj/effect/temp_visual/revenant(T)
	playsound(src, 'sound/magic/wandodeath.ogg', 200, FALSE, 9)

	if(LAZYLEN(been_hit))
		playsound(src, 'sound/magic/staff_healing.ogg', 200, FALSE, 9)
		for(var/mob/living/carbon/human/L in range(8, get_turf(user)))
			L.apply_shield(/datum/status_effect/interventionshield/black, shield_health = shield_hp, shield_duration = shield_time)


/obj/item/ego_weapon/heaven
	name = "天国"
	desc = "As it spreads its wings for an old god, a heaven just for you burrows its way."
	icon_state = "heaven"
	force = 24
	reach = 2		//Has 2 Square Reach.
	stuntime = 5	//Longer reach, gives you a short stun.
	throwforce = 40
	throw_speed = 5
	throw_range = 7
	damtype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/fixer/generic/nail1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/heaven/get_clamped_volume()
	return 25

/obj/item/ego_weapon/spore
	name = "荧光菌孢"
	desc = "A spear covered in spores and affection. \
	It lights the employee's heart, shines like a star, and steadily tames them."
	special = "击中目标后，目标对白色伤害的弱点增加0.2."
	icon_state = "spore"
	force = 24
	reach = 2		//Has 2 Square Reach.
	stuntime = 5	//Longer reach, gives you a short stun.
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/spore/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(isliving(target))
		var/mob/living/simple_animal/M = target
		if(!ishuman(M) && !M.has_status_effect(/datum/status_effect/display/rend/white))
			new /obj/effect/temp_visual/cult/sparks(get_turf(M))
			M.apply_status_effect(/datum/status_effect/display/rend/white)

// Reworked to use the bloodfeast component. Collect blood to improve your life leech ability.
/obj/item/ego_weapon/dipsia
	name = "渴求鲜血"
	desc = "The thirst will never truly be quenched."
	special = "在命中时治疗你自己."
	icon_state = "dipsia"
	force = 24
	damtype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/pierce_slow.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	var/siphoning = FALSE
	var/siphon_time = 1 SECONDS

/obj/item/ego_weapon/dipsia/Initialize()
	. = ..()
	AddComponent(/datum/component/bloodfeast, siphon = TRUE, range = 2, starting = 100, threshold = 1500, max_amount = 1500)

/obj/item/ego_weapon/dipsia/examine(mob/user)
	. = ..()
	var/datum/component/bloodfeast/bloodfeast = GetComponent(/datum/component/bloodfeast)
	if(bloodfeast) // dont want to succ blood while contained
		. += "已存储 [bloodfeast.blood_amount]U 血液."

/obj/item/ego_weapon/dipsia/proc/AdjustThirst(blood_amount)
	var/datum/component/bloodfeast/bloodfeast = GetComponent(/datum/component/bloodfeast)
	bloodfeast.AdjustBlood(blood_amount)

/obj/item/ego_weapon/dipsia/attack_self(mob/living/user)
	if(!CanUseEgo(user))
		return
	if(siphoning)
		to_chat(user,span_warning("你停止用 [src] 汲取血液."))
		siphoning = FALSE
		filters = null
		user.playsound_local(user, 'sound/effects/bleed.ogg', 25, TRUE)
		return
	var/datum/component/bloodfeast/bloodfeast = GetComponent(/datum/component/bloodfeast)
	siphoning = TRUE
	user.playsound_local(user, 'sound/effects/bleed_apply.ogg', 25, TRUE)
	to_chat(user,span_warning("你开始用 [src] 汲取血液."))
	if(bloodfeast.blood_amount < 100)
		to_chat(user,span_warning("这把剑会吸取你的血液以维持自身运转!"))
		user.adjustBruteLoss(20)
		AdjustThirst(100)
	AdjustThirst(-50)
	filters += filter(type="drop_shadow", x=0, y=0, size=5, offset=2, color=rgb(163, 8, 8))
	addtimer(CALLBACK(src, PROC_REF(SiphonDrain), user), siphon_time)

/obj/item/ego_weapon/dipsia/proc/SiphonDrain(mob/user)
	if(!siphoning)
		return
	var/datum/component/bloodfeast/bloodfeast = GetComponent(/datum/component/bloodfeast)
	AdjustThirst(-10)
	if(bloodfeast.blood_amount < 1)
		siphoning = FALSE
		filters = null
		if(user)
			to_chat(user,span_warning("你 [src] 因缺乏血液而停止工作!"))
			return
	addtimer(CALLBACK(src, PROC_REF(SiphonDrain), user), siphon_time)

/obj/item/ego_weapon/dipsia/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		var/justicemod = get_attack_multiplier(user)
		AdjustThirst(force * justicemod)
		var/heal_amt = force* 0.05
		if(siphoning)
			heal_amt *= 4
		if(isanimal(target))
			var/mob/living/simple_animal/S = target
			if(S.damage_coeff.getCoeff(damtype) > 0)
				heal_amt *= S.damage_coeff.getCoeff(damtype)
			else
				heal_amt = 0
			user.adjustBruteLoss(-heal_amt)
	..()

/obj/item/ego_weapon/shield/pharaoh
	name = "法老"
	desc = "Look on my Works, ye Mighty, and despair!"
	special = "这种武器可以移除石化."
	icon_state = "pharaoh"
	force = 12
	attack_speed = 0.5
	swingstyle = WEAPONSWING_LARGESWEEP
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("decimates", "bisects")
	attack_verb_simple = list("decimate", "bisect")
	hitsound = 'sound/weapons/bladeslice.ogg'
	reductions = list(30, 50, 30, 40) // 150
	projectile_block_duration = 0.5 SECONDS
	block_duration = 1 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/ego/clash1.ogg'
	projectile_block_message ="神是不怕死的!"
	block_message = "你试图抵挡攻击!"
	hit_message = "抵挡攻击!"
	block_cooldown_message = "你重新持握好了武器."
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/shield/pharaoh/pre_attack(atom/A, mob/living/user, params)
	if(istype(A, /obj/structure/statue/petrified) && CanUseEgo(user))
		playsound(A, 'sound/effects/break_stone.ogg', rand(10, 50), TRUE)
		A.visible_message(span_danger("[A]返回正常!"), span_userdanger("你解除了石化!"))
		qdel(A)
		return TRUE
	. = ..()

/obj/item/ego_weapon/blind_rage
	name = "盲目的愤怒"
	desc = "Those who suffer injustice tend to lash out at all those around them."
	icon_state = "blind_rage"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 32
	attack_speed = 1.2
	special = "这把武器能造成毁灭性的红色和黑色范围伤害，小心使用!"
	damtype = RED_DAMAGE
	attack_verb_continuous = list("smashes", "crushes", "flattens")
	attack_verb_simple = list("smash", "crush", "flatten")
	hitsound = 'sound/abnormalities/wrath_servant/big_smash1.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)

	var/aoe_damage = 7
	var/aoe_damage_type = BLACK_DAMAGE
	var/aoe_range = 2
	var/attacks = 0

/obj/item/ego_weapon/blind_rage/get_clamped_volume()
	return 30

/obj/item/ego_weapon/blind_rage/attack(mob/living/M, mob/living/carbon/human/user)
	var/turf/target_turf = get_turf(M)
	. = ..()
	if(!.)
		return FALSE
	attacks++
	attacks %= 3
	switch(attacks)
		if(0)
			hitsound = 'sound/abnormalities/wrath_servant/big_smash1.ogg'
		if(1)
			hitsound = 'sound/abnormalities/wrath_servant/big_smash2.ogg'
		if(2)
			hitsound = 'sound/abnormalities/wrath_servant/big_smash3.ogg'
	var/damage = aoe_damage * get_attack_multiplier(user)
	damage *= force_multiplier
	if(attacks == 0)
		damage *= 3
	if(user.sanity_lost)
		damage *= 1.2
	for(var/turf/open/T in RANGE_TURFS(aoe_range, target_turf))
		var/obj/effect/temp_visual/small_smoke/halfsecond/smonk = new(T)
		smonk.color = COLOR_GREEN
		var/list/been_hit = QDELETED(M) ? list() : list(M)
		user.HurtInTurf(T, been_hit, damage, damtype, hurt_mechs = TRUE, hurt_structure = TRUE, break_not_destroy = TRUE)
		user.HurtInTurf(T, list(), damage, aoe_damage_type, hurt_mechs = TRUE, hurt_structure = TRUE, break_not_destroy = TRUE)
		if(prob(5))
			new /obj/effect/gibspawner/generic/silent/wrath_acid(T) // The non-damaging one
	var/mob/living/carbon/human/myman = user
	var/obj/item/ego_weapon/blind_rage/Y = myman.get_inactive_held_item()
	var/obj/item/clothing/suit/armor/ego_gear/realization/woundedcourage/Z = myman.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Y) && Y != src && istype(Z) && !QDELETED(M)) //dual wielding and wearing Wounded Courage? if so...
		Y.melee_attack_chain(user, M)

/obj/item/ego_weapon/blind_rage/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/nihil/club))
		return
	new /obj/item/ego_weapon/blind_rage/nihil(get_turf(src))
	to_chat(user,span_warning("[I]在被[src]吸收时，似乎也吸走了所有的光!"))
	playsound(user, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)
	qdel(I)
	qdel(src)

/obj/item/ego_weapon/mini/heart
	name = "怜悯之心"
	desc = "The supplicant will suffer various ordeals in a manner like being put through a trial."
	icon_state = "heart"
	special = "攻击自己来为10米内其他人恢复HP."
	inhand_icon_state = "bloodbath"
	force = 22
	damtype = RED_DAMAGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(FORTITUDE_ATTRIBUTE = 80)

/obj/item/ego_weapon/mini/heart/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	..()
	if(M==user)
		for(var/mob/living/carbon/human/L in range(10, user))
			if(L==user)
				continue
			L.adjustBruteLoss(-10)

/obj/item/ego_weapon/diffraction
	name = "虚无衍射体"
	desc = "Many employees have sustained injuries from erroneous calculation."
	special = "此武器对20% HP以下的目标造成双倍伤害."
	icon_state = "diffraction"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 20
	swingstyle = WEAPONSWING_LARGESWEEP
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slices", "cuts")
	attack_verb_simple = list("slice", "cut")
	hitsound = 'sound/weapons/blade1.ogg'
	attribute_requirements = list(FORTITUDE_ATTRIBUTE = 80)

/obj/item/ego_weapon/diffraction/attack(mob/living/target, mob/living/user)
	if((target.health <= target.maxHealth * 0.4) && !(target.status_flags & GODMODE))
		force *= 2
	..()
	force = initial(force)

/obj/item/ego_weapon/mini/infinity
	name = "永恒期限"
	desc = "A giant novelty pen."
	special = "这个武器用随机伤害类型标记敌人，他们会在5秒后受到伤害."
	icon_state = "infinity"
	force = 16
	hitsound = 'sound/abnormalities/book/scribble.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)
	damtype = PALE_DAMAGE
	var/mark_damage = 12
	var/mark_type = RED_DAMAGE

/obj/item/ego_weapon/mini/infinity/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	..()
	mark_type = pick(RED_DAMAGE,WHITE_DAMAGE, BLACK_DAMAGE)
	var/color = "red"
	if(mark_type == WHITE_DAMAGE)
		color = "white"
	if(mark_type == BLACK_DAMAGE)
		color = "black"
	target.visible_message(span_danger("[user]用[color]代码标记[target]!"), \
	span_userdanger("[user]用[color]代码标记了你!"), COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger("你写入[color]代码到[target]上!"))

	var/obj/effect/infinity/P = new get_turf(target)
	if(mark_type == RED_DAMAGE)
		P.color = COLOR_RED

	if(mark_type == BLACK_DAMAGE)
		P.color = COLOR_PURPLE

	addtimer(CALLBACK(src, PROC_REF(cast), target, user, mark_type), 5 SECONDS)

/obj/effect/infinity
	name = "mark"
	icon = 'icons/effects/cult_effects.dmi'
	icon_state = "rune3center"
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/infinity/Initialize()
	. = ..()
	animate(src, alpha = 0, time = 1 SECONDS)
	QDEL_IN(src, 1 SECONDS)

/obj/item/ego_weapon/mini/infinity/proc/cast(mob/living/target, mob/living/user, damage_color)
	if(!target)
		return
	var/justicemod = get_attack_multiplier(user)
	var/modified_damage = mark_damage
	modified_damage *= justicemod
	modified_damage *= force_multiplier
	target.apply_damage(modified_damage, damage_color, null, target.run_armor_check(null, damage_color), spread_damage = TRUE)		//MASSIVE fuckoff punch
	playsound(loc, 'sound/weapons/fixer/generic/energyfinisher3.ogg', 15, TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
	new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(target), pick(GLOB.alldirs))

/obj/item/ego_weapon/amrita
	name = "无量"
	desc = "The rings attached to the cane represent the middle way and the Six Paramitas."
	special = "在手中使用这把武器能伤害你能触及的所有非人类."
	icon_state = "amrita"
	force = 24
	reach = 2		//Has 2 Square Reach.
	stuntime = 5	//Longer reach, gives you a short stun.
	throw_speed = 5
	throw_range = 7
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slams", "attacks")
	attack_verb_simple = list("slam", "attack")
	hitsound = 'sound/abnormalities/clouded_monk/monk_attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	var/can_spin = TRUE
	var/spinning = FALSE

/obj/item/ego_weapon/amrita/get_clamped_volume()
	return 20

/obj/item/ego_weapon/amrita/attack(mob/living/target, mob/living/user)
	if(!can_spin)
		return FALSE
	..()
	can_spin = FALSE
	addtimer(CALLBACK(src, PROC_REF(spin_reset)), 13)

/obj/item/ego_weapon/amrita/proc/spin_reset()
	can_spin = TRUE

/obj/item/ego_weapon/amrita/attack_self(mob/user) //spin attack with knockback
	if(!CanUseEgo(user))
		return
	if(!can_spin)
		to_chat(user,span_warning("我攻击的太频繁了."))
		return
	can_spin = FALSE
	if(do_after(user, 13, src))
		var/aoe = force
		var/justicemod = get_attack_multiplier(user)
		var/firsthit = TRUE //One target takes full damage
		can_spin = TRUE
		addtimer(CALLBACK(src, PROC_REF(spin_reset)), 13)
		playsound(src, 'sound/abnormalities/clouded_monk/monk_bite.ogg', 75, FALSE, 4)
		aoe*=justicemod
		aoe*=force_multiplier

		for(var/turf/T in orange(2, user))
			new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in range(2, user)) //knocks enemies away from you
			if(L == user || ishuman(L))
				continue
			L.apply_damage(aoe, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			if(firsthit)
				aoe = (aoe / 2)
				firsthit = FALSE
			var/throw_target = get_edge_target_turf(L, get_dir(L, get_step_away(L, src)))
			if(!L.anchored)
				var/whack_speed = (prob(60) ? 1 : 4)
				L.throw_at(throw_target, rand(1, 2), whack_speed, user)
	spin_reset()

/obj/item/ego_weapon/wield/discord
	name = "不和"
	desc = "The existance of evil proves the existance of good, just as light proves the existance of darkness."
	special = "这种武器可以是双手持握，在使用时可以快速连续攻击三次.\n 使用此武器攻击时，将治疗附近使用相合的盟友."
	icon_state = "discord"
	force = 19
	wielded_force = 22
	attack_speed = 0.8
	wielded_attack_speed = 0.8
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	damtype = BLACK_DAMAGE

/obj/item/ego_weapon/wield/discord/attack(mob/living/target, mob/living/carbon/human/user)
	if(!..())
		return FALSE
	if(!ishostile(target))
		return
	if(target.stat == DEAD || target.status_flags & GODMODE)
		return
	Harmony(user)
	if(!wielded)
		return
	user.changeNext_move(CLICK_CD_MELEE*wielded_attack_speed*2.5)
	for(var/i = 1 to 2)
		addtimer(CALLBACK(src, PROC_REF(MultiSwing), target, user), CLICK_CD_MELEE * 0.6 * i)

/obj/item/ego_weapon/wield/discord/proc/MultiSwing(mob/living/target, mob/living/carbon/human/user)
	if(get_dist(target, user) > 1)
		return
	if(src != user.get_active_held_item())
		return
	if(!wielded)
		return
	Harmony(user)
	playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
	user.do_attack_animation(target)
	target.attacked_by(src, user)
	log_combat(user, target, pick(attack_verb_continuous), src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")

/obj/item/ego_weapon/wield/discord/proc/Harmony(mob/living/carbon/human/user)
	var/heal_amount = 4
	if(wielded)
		heal_amount = 3
	for(var/mob/living/carbon/human/Yang in view(7, user))
		var/obj/item/ego_weapon/ranged/assonance/A = Yang.get_active_held_item()
		if(istype(A, /obj/item/ego_weapon/ranged/assonance))
			if(!A.CanUseEgo(Yang))
				continue
			Yang.adjustBruteLoss(-heal_amount)
			Yang.adjustSanityLoss(-heal_amount)
			break

/obj/item/ego_weapon/shield/innocence
	name = "纯真"
	desc = "But why is it about ‘innocence’? After countless assumptions and careful research, we learned that it could be defined as \[REDACTED\]."
	icon_state = "innocence"
	force = 68
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("shoves", "bashes")
	attack_verb_simple = list("shove", "bash")
	hitsound = 'sound/weapons/fixer/generic/gen2.ogg'
	reductions = list(10, 70, 50, 20) //150
	projectile_block_duration = 3 SECONDS
	block_duration = 3 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/abnormalities/orangetree/ding.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/rimeshank
	name = "冰结之爪"
	desc = "Stay frozen... And there will be no pain."
	special = "这个武器可以在短时间的蓄力后进行跳跃攻击."
	icon_state = "rimeshank"
	force = 44
	attack_speed = 2
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slams", "attacks")
	attack_verb_simple = list("slam", "attack")
	hitsound = 'sound/abnormalities/babayaga/attack.ogg'
	usesound = 'sound/effects/picaxe1.ogg'
	toolspeed = 0.3
	tool_behaviour = TOOL_MINING
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

	var/dash_cooldown
	var/dash_cooldown_time = 6 SECONDS
	var/dash_range = 10
	var/can_attack = TRUE

/obj/item/ego_weapon/rimeshank/get_clamped_volume()
	return 30

/obj/item/ego_weapon/rimeshank/attack(mob/living/target, mob/living/user)
	if(!can_attack)
		return
	..()
	can_attack = FALSE
	addtimer(CALLBACK(src, PROC_REF(JumpReset)), 20)

/obj/item/ego_weapon/rimeshank/proc/JumpReset()
	can_attack = TRUE

/obj/item/ego_weapon/rimeshank/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user) || !can_attack)
		return
	if(!isliving(A))
		return
	if(dash_cooldown > world.time)
		to_chat(user, span_warning("你的突袭扔在充能!"))
		return
	if((get_dist(user, A) < 2) || (!(can_see(user, A, dash_range))))
		return
	..()
	if(do_after(user, 5, src))
		dash_cooldown = world.time + dash_cooldown_time
		user.Immobilize(0.6 SECONDS)
		ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
		playsound(src, 'sound/abnormalities/babayaga/charge.ogg', 50, FALSE, -1)
		animate(user, alpha = 1,pixel_x = 0, pixel_z = 16, time = 0.1 SECONDS)
		user.pixel_z = 16
		sleep(0.5 SECONDS)
		if(QDELETED(user))
			return
		else if(QDELETED(A) || !can_see(user, A, dash_range))
			REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
			animate(user, alpha = 255,pixel_x = 0, pixel_z = -16, time = 0.1 SECONDS)
			user.pixel_z = 0
			return
		for(var/i in 2 to get_dist(user, A))
			step_towards(user,A)
		if((get_dist(user, A) < 2))
			JumpAttack(A,user)
		REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
		to_chat(user, span_warning("你跳向[A]!"))
		animate(user, alpha = 255,pixel_x = 0, pixel_z = -16, time = 0.1 SECONDS)
		user.pixel_z = 0

/obj/item/ego_weapon/rimeshank/proc/JumpAttack(atom/A, mob/living/user, proximity_flag, params)
	force = 20
	A.attackby(src,user)
	force = initial(force)
	can_attack = FALSE
	addtimer(CALLBACK(src, PROC_REF(JumpReset)), 20)
	for(var/mob/living/L in range(2, A))
		if(L.z != user.z) // Not on our level
			continue
		var/aoe = 15
		var/justicemod = get_attack_multiplier(user)
		aoe*=justicemod
		aoe*=force_multiplier
		if(L == user || ishuman(L))
			continue
		L.apply_damage(aoe, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		var/obj/effect/temp_visual/small_smoke/halfsecond/FX =  new(get_turf(L))
		FX.color = "#a2d2df"

/obj/item/ego_weapon/animalism
	name = "兽性解放"
	desc = "The frothing madness of the revving engine brings a fleeting warmth to your hands and heart alike."
	special = "这把武器一下攻击四次."
	icon_state = "animalism"
	force = 10
	attack_speed = 1.3
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slices", "saws", "rips")
	attack_verb_simple = list("slice", "saw", "rip")
	hitsound = 'sound/abnormalities/helper/attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/animalism/attack(mob/living/target, mob/living/user)
	if(!..())
		return
	for(var/i = 1 to 3)
		sleep(2)
		if(target in view(reach,user))
			playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
			user.do_attack_animation(target)
			target.attacked_by(src, user)
			log_combat(user, target, pick(attack_verb_continuous), src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")

/obj/item/ego_weapon/animalism/melee_attack_chain(mob/living/user, atom/target, params)
	..()
	if(isliving(target))
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(target), pick(GLOB.alldirs))

/obj/item/ego_weapon/psychic
	name = "心灵匕首"
	desc = "A saber from the deepest sea, meant for a groom's mortality."
	special = "在手中使用可以进行闪避动作."
	icon_state = "psychic"
	force = 8
	attack_speed = 0.3
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("stabs", "attacks", "slashes")
	attack_verb_simple = list("stab", "attack", "slash")
	hitsound = 'sound/weapons/fixer/generic/knife4.ogg'
	var/dodgelanding

/obj/item/ego_weapon/psychic/attack_self(mob/living/carbon/user)
	if(user.dir == 1)
		dodgelanding = locate(user.x, user.y + 5, user.z)
	if(user.dir == 2)
		dodgelanding = locate(user.x, user.y - 5, user.z)
	if(user.dir == 4)
		dodgelanding = locate(user.x + 5, user.y, user.z)
	if(user.dir == 8)
		dodgelanding = locate(user.x - 5, user.y, user.z)
	user.adjustStaminaLoss(20, TRUE, TRUE)
	user.throw_at(dodgelanding, 3, 2, spin = TRUE)

/obj/item/ego_weapon/grasp
	name = "司掌"
	desc = "I should’ve said that I'm sorry that I let go of your hand and apologized, even if it didn't mean anything."
	special = "这种武器可以使用来向目标突袭."
	icon_state = "grasp"
	force = 12
	attack_speed = 0.5
	damtype = PALE_DAMAGE
	attack_verb_continuous = list("cuts", "attacks", "slashes")
	attack_verb_simple = list("cut", "attack", "slash")
	hitsound = 'sound/weapons/fixer/generic/knife2.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
							)

	var/dash_cooldown
	var/dash_cooldown_time = 3 SECONDS
	var/dash_range = 4
	var/charging = TRUE

/obj/item/ego_weapon/grasp/attack_self(mob/user)
	..()
	if(charging)
		to_chat(user,span_warning("你改变你的姿态，将不再执行突袭."))
		charging = FALSE
		force = initial(force) + 2
		return
	if(!charging)
		to_chat(user,span_warning("你改变你的姿态，将执行突袭."))
		charging =TRUE
		force = initial(force)
		return

/obj/item/ego_weapon/grasp/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(!isliving(A) || !charging)
		return
	if(dash_cooldown > world.time)
		to_chat(user, "<span class='warning'>你的突袭还在充能!")
		return
	if((get_dist(user, A) < 2) || (!(can_see(user, A, dash_range))))
		return
	..()
	dash_cooldown = world.time + dash_cooldown_time
	for(var/i in 2 to get_dist(user, A))
		step_towards(user,A)
	if(get_dist(user, A) < 2)
		A.attackby(src,user)
	playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
	to_chat(user, "<span class='warning'>你突袭[A]!")

/obj/item/ego_weapon/cobalt
	name = "郁蓝创痕"
	desc = "Once upon a time, these claws would cut open the bellies of numerous creatures and tear apart their guts."
	special = "当生命值为一半的情况下，额外造成75%伤害."
	icon_state = "cobalt"
	force = 12
	attack_speed = 0.5
	swingstyle = WEAPONSWING_LARGESWEEP
	damtype = RED_DAMAGE
	attack_verb_continuous = list("claws")
	attack_verb_simple = list("claw")
	hitsound = 'sound/abnormalities/big_wolf/Wolf_Hori.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/cobalt/attack(mob/living/target, mob/living/user)
	force = initial(force)
	if(!..())
		return
	var/our_health = 100 * (user.health / user.maxHealth)
	sleep(2)
	if(our_health <= 50 && isliving(target) && target.stat != DEAD)
		FrenzySwipe(user)

//Attack again but with less of the code.
/obj/item/ego_weapon/cobalt/proc/FrenzySwipe(mob/living/wolf)
	var/list/killers = list()
	for(var/mob/living/hunters in oview(get_turf(wolf), 1))
		//This is placed here as a safety net in the case that the user is in the middle of 30 enemies
		if(killers.len >= 5)
			break
		if(hunters.stat == DEAD)
			continue
		killers += hunters
	if(!killers.len)
		return FALSE
	var/mob/living/those_we_rend = pick(killers)
	if(!those_we_rend)
		return FALSE
	if(prob(25))
		wolf.visible_message(span_warning("[wolf]疯狂地用爪撕裂[those_we_rend]!"), span_warning("你疯狂地用爪撕裂 [those_we_rend]!"))
	if(ishuman(wolf))
		force = 9
		playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
		wolf.do_attack_animation(those_we_rend)
		those_we_rend.attacked_by(src, wolf)
		log_combat(wolf, those_we_rend, pick(attack_verb_continuous), src.name, "(INTENT: [uppertext(wolf.a_intent)]) (DAMTYPE: [uppertext(damtype)])")
		wolf.log_message("[wolf] attacked [those_we_rend] due to the cobalt scar weapon ability.", LOG_ATTACK) //the following attack will log itself
	return TRUE

/obj/item/ego_weapon/scene
	name = "一如剧本所写"
	desc = "The scenario is about a man who was raised in a normal family. \
	One day, he picks up a mask from the street and goes on to impulsively murder all the people that he knows."
	special = "该武器可以储存伤害以备以后治疗."
	icon_state = "scenario"
	force = 24
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("disrespects", "sullies")
	attack_verb_simple = list("disrespect", "sully")
	hitsound = 'sound/effects/fish_splash.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)
	var/amount_filled
	var/amount_max = 30

/obj/item/ego_weapon/scene/update_icon_state()
	. = ..()
	if(amount_filled)
		icon_state = "scenario_filled"
	else
		icon_state = "scenario"

/obj/item/ego_weapon/scene/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		var/heal_amt = force*0.025
		if(isanimal(target))
			var/mob/living/simple_animal/S = target
			if(S.damage_coeff.getCoeff(damtype) > 0)
				heal_amt *= S.damage_coeff.getCoeff(damtype)
			else
				heal_amt = 0
		amount_filled = clamp(amount_filled + heal_amt, 0, amount_max)
		if(amount_filled >= amount_max)
			to_chat(user, "<span class='warning'>[src]是满的!")
	update_icon()
	..()

/obj/item/ego_weapon/scene/attack_self(mob/living/carbon/human/user)
	..()
	if(!amount_filled)
		to_chat(user, "<span class='warning'>[src]是空的!")
		return
	if(do_after(user, 12, src))
		to_chat(user, "<span class='warning'>你喝了一口[src]!")
		playsound(get_turf(src), 'sound/items/drink.ogg', 50, TRUE) //slurp
		user.adjustBruteLoss(-amount_filled)
		user.adjustSanityLoss(-amount_filled)
		amount_filled = 0
	update_icon()

/obj/item/ego_weapon/lance/tattered_kingdom
	name = "王国长枪"
	desc = "No one remembers those who gave their effort to raise the kingdom. It’s a truth that repeats on and on."
	icon_state = "tattered_kingdom"
	lefthand_file = 'icons/mob/inhands/96x96_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/96x96_righthand.dmi'
	inhand_x_dimension = 96
	inhand_y_dimension = 96
	force = 24
	reach = 2		//Has 2 Square Reach.

	damtype = RED_DAMAGE
	attack_verb_continuous = list("pierces", "jabs")
	default_attack_verbs = list("pierce", "jab")
	hitsound = 'sound/weapons/fixer/generic/spear2.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	couch_cooldown_time = 4 SECONDS
	force_cap = 48 //double base damage
	force_per_tile = 3 //if I can read, this means you need to cross 8 tiles for max damage
	pierce_force_cost = 12
	stuntime = 5	//Longer reach, gives you a short stun.

/obj/item/ego_weapon/warring
	name = "交战"
	desc = "It was a good day to die, but everybody did."
	special = "投掷后，该武器将返回使用者手中. 投掷会激活充能效果."
	icon_state = "warring2"
	force = 20
	attack_speed = 0.8
	swingstyle = WEAPONSWING_LARGESWEEP
	throwforce = 40
	throw_speed = 1
	throw_range = 7
	damtype = BLACK_DAMAGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
	)

	charge = TRUE
	ability_type = ABILITY_UNIQUE
	charge_cost = 5
	allow_ability_cancel = FALSE
	charge_effect = "在一次强大的爆发中消耗所有的能量."
	successfull_activation = "你释放你的充能!"

/obj/item/ego_weapon/warring/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/ego_weapon/warring/attack(mob/living/target, mob/living/user)
	if(charge_amount == 4 || charge_amount == 19)//audio tells for min and maximum charge bursts
		playsound(src, 'sound/magic/lightningshock.ogg', 50, TRUE)
	. = ..()

/obj/item/ego_weapon/warring/attack_self(mob/living/user)
	if(!currently_charging && charge_amount >= 5)
		playsound(src, 'sound/magic/lightningshock.ogg', 50, TRUE)
		icon_state = "warring2_firey"
		hitsound = 'sound/abnormalities/thunderbird/tbird_peck.ogg'
		if(user)
			user.update_inv_hands()
	else
		return
	. = ..()

/obj/item/ego_weapon/warring/ChargeAttack(mob/living/user)
	playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)
	var/turf/T = get_turf(src)
	for(var/mob/living/L in view(1, T))
		var/aoe = (charge_amount + 5) * 5
		var/justicemod = get_attack_multiplier(user)
		aoe*=justicemod
		if(L == user || ishuman(L))
			continue
		L.apply_damage(aoe, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		new /obj/effect/temp_visual/tbirdlightning(get_turf(L))
	icon_state = initial(icon_state)
	hitsound = initial(hitsound)
	charge_amount = initial(charge_amount)
	currently_charging = FALSE

/obj/item/ego_weapon/warring/on_thrown(mob/living/carbon/user, atom/target)//No, clerks cannot hilariously kill themselves with this
	if(!CanUseEgo(user))
		return
	return ..()

/obj/item/ego_weapon/warring/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
	if(thrownby && !caught)
		if(currently_charging && isliving(hit_atom))
			ChargeAttack(hit_atom)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, throw_at), thrownby, throw_range+2, throw_speed, null, TRUE), 1)
	if(caught)
		return
	else
		return ..()

/obj/item/ego_weapon/warring/get_clamped_volume()
	return 40

/obj/item/ego_weapon/hyde
	name = "hyde"
	desc = "The most racking pangs succeeded: a grinding in the bones, deadly nausea, and a horror of the spirit that cannot be exceeded at the hour of birth or death."
	special = "激活手中的这把武器以获得注射器，以受到伤害为代价赋予它力量."
	icon_state = "hyde"
	force = 20
	attack_speed = 0.8
	damtype = RED_DAMAGE
	attack_verb_continuous = list("punches", "slaps", "scratches")
	attack_verb_simple = list("punch", "slap", "scratch")
	hitsound = 'sound/weapons/fixer/generic/knife2.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
							)
	var/chosen_style
	var/transformed = FALSE

/obj/item/ego_weapon/hyde/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/ego_weapon/hyde/get_clamped_volume()
	return 40

/obj/item/ego_weapon/hyde/proc/Transform(mob/living/carbon/human/user)
	user.emote("scream")
	playsound(get_turf(src),'sound/effects/limbus_death.ogg', 75, 1)//YEOWCH!
	icon_state = ("hyde_" + chosen_style)
	update_icon_state()
	force = 28
	switch(chosen_style)
		if("red")
			user.apply_damage(50, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			damtype = RED_DAMAGE
			to_chat(user, span_notice("为了适应肌肉发达的爪子，你被雕刻的骨头传来剧痛."))
			hitsound = 'sound/weapons/bladeslice.ogg'
		if("white")
			user.apply_damage(50, WHITE_DAMAGE, null, user.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
			damtype = WHITE_DAMAGE
			to_chat(user, span_notice("焦虑涂满手臂."))
			hitsound = 'sound/effects/hit_kick.ogg'
		if("black")
			user.apply_damage(50, BLACK_DAMAGE, null, user.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			damtype = BLACK_DAMAGE
			to_chat(user, span_notice("手臂上喷出硬毛，充满了憎恨."))
			hitsound = 'sound/weapons/ego/spear1.ogg'
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)
	user.update_inv_hands()
	transformed = TRUE
	addtimer(CALLBACK(src, PROC_REF(ResetTimer), user), 600)

/obj/item/ego_weapon/hyde/attack_self(mob/living/carbon/human/user)
	if(transformed)
		return
	if(!CanUseEgo(user))
		return
	SwitchForm(user)

// Radial menu
/obj/item/ego_weapon/hyde/proc/CheckMenu(mob/living/carbon/human/user)
	if(!istype(user))
		return FALSE
	if(QDELETED(src))
		return FALSE
	if(user.incapacitated() || !user.is_holding(src))
		return FALSE
	return TRUE

/obj/item/ego_weapon/hyde/proc/SwitchForm(mob/living/carbon/human/user)
	var/list/armament_icons = list(
		"red" = image(icon = 'icons/obj/ego_weapons.dmi', icon_state = "hyde_red_indicator"),
		"white"  = image(icon = 'icons/obj/ego_weapons.dmi', icon_state = "hyde_white_indicator"),
		"black"  = image(icon = 'icons/obj/ego_weapons.dmi', icon_state = "hyde_black_indicator"),
	)
	armament_icons = sortList(armament_icons)
	var/choice = show_radial_menu(user, src , armament_icons, custom_check = CALLBACK(src, PROC_REF(CheckMenu), user), radius = 42, require_near = TRUE)
	if(!choice || !CheckMenu(user))
		return
	if(do_after(user, 10, src, IGNORE_USER_LOC_CHANGE))
		chosen_style = choice
		Transform(user)

/obj/item/ego_weapon/hyde/proc/ResetTimer(mob/living/carbon/human/user)
	if(!transformed)
		return
	icon_state = "hyde"
	force = initial(force)
	hitsound = initial(hitsound)
	damtype = initial(damtype)
	transformed = FALSE
	REMOVE_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)
	if(user)
		user.update_inv_hands()
		to_chat(user, span_notice("你的手臂恢复正常."))
		playsound(get_turf(src),'sound/effects/attackblob.ogg', 75, 1)

/obj/item/ego_weapon/hyde/on_thrown(mob/living/carbon/user, atom/target)//you can't throw it. bleh
	if(transformed)
		return
	return ..()

/obj/item/ego_weapon/rosa
	name = "荆棘花园"
	desc = "See? Wish, wish for it. Knowing that it is a sin. Only then can you bloom such colorful roses."
	special = "击打自己可以恢复别人的SP."
	icon_state = "rosa"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 24
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("lashes", "punishes", "whips", "slaps", "lacerates")
	attack_verb_simple = list("lash", "punish","whip", "slap", "lacerate")
	hitsound = 'sound/weapons/whip.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/rosa/attack(mob/living/M, mob/living/user)
	..()
	if(M==user)
		var/justicemod = get_attack_multiplier(user)
		var/heal_amount = (force * justicemod * 0.75)
		var/armormod = (user.run_armor_check(null, WHITE_DAMAGE))
		if(armormod)//skips all the math if you're not wearing armor
			heal_amount -= (heal_amount * (armormod / 100))//wearing da capo will reduce it to 0
		heal_amount *= 0.5
		for(var/mob/living/carbon/human/L in range(10, user))
			if(L==user)
				continue
			L.adjustSanityLoss(-heal_amount)

/obj/item/ego_weapon/blind_obsession
	name = "盲目"
	desc = "All hands, full speed toward where the lights flicker. The waves... will lay waste to everything in our way."
	special = "这武器需要两只手才能使用. \
			使用它，在短时间内以速度为代价解锁其全部力量. \
			当你以最大力量投掷时，这把武器会在AOE范围内伤害除你之外的所有人，小心使用! \
			此外它的伤害在最大力量投掷时造成的伤害增加75%."
	icon_state = "blind_obsession"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 60
	attack_speed = 2.5
	throwforce = 60
	throw_speed = 1
	throw_range = 9
	damtype = RED_DAMAGE
	attack_verb_continuous = list("bashes", "smashes")
	attack_verb_simple = list("bashes", "smashes")
	hitsound = 'sound/weapons/ego/hammer.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	var/charged
	var/speed_slowdown = 0
	var/mob/current_holder
	var/power_timer
	var/thrown = FALSE


//Equipped setup
/obj/item/ego_weapon/blind_obsession/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	if(slot != ITEM_SLOT_HANDS) //Clean up our slowdown and whatnot if we're storing the anchor somewhere on our person
		dropped(user)
	else
		current_holder = user //If it's going into our hands, then we wanna register the signal and register as the holder
		RegisterSignal(current_holder, COMSIG_MOVABLE_MOVED, PROC_REF(UserMoved))

//Destroy setup
/obj/item/ego_weapon/blind_obsession/Destroy(mob/user)
	if(!user)
		return ..()
	speed_slowdown = 0
	UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED)
	PowerReset(user)
	current_holder = null
	user.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/anchor, multiplicative_slowdown = 0)
	return ..()

//Dropped setup
/obj/item/ego_weapon/blind_obsession/dropped(mob/user)
	. = ..()
	if(!user)
		return
	speed_slowdown = 0
	if(current_holder) //This check wouldn't need to exist but P Corp items call dropped() when we remove an item from them, and it will runtime if we don't check here
		UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED)
	if(!thrown)
		PowerReset(user)
	current_holder = null
	user.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/anchor, multiplicative_slowdown = 0)

/obj/item/ego_weapon/blind_obsession/proc/UserMoved(mob/user)
	SIGNAL_HANDLER
	user.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/anchor, multiplicative_slowdown = speed_slowdown)

/obj/item/ego_weapon/blind_obsession/CanUseEgo(mob/living/user)
	. = ..()
	if(user.get_inactive_held_item())
		to_chat(user, span_notice("单手无法使用[src]！"))
		return FALSE

/obj/item/ego_weapon/blind_obsession/attack_self(mob/user)
	if(user.get_inactive_held_item())
		to_chat(user, span_notice("单手无法使用[src]!"))
		return
	if(charged)
		to_chat(user, span_notice("你已经准备好全力投掷[src]了!"))
		return
	if(do_after(user, 12, src))
		charged = TRUE
		speed_slowdown = 1
		throwforce = 80
		to_chat(user,span_warning("你在这次投掷中用尽全力."))
		power_timer = addtimer(CALLBACK(src, PROC_REF(PowerReset)), 3 SECONDS, TIMER_STOPPABLE)//prevents storing 3 powered up anchors and unloading all of them at once

/obj/item/ego_weapon/blind_obsession/proc/PowerReset(mob/user)
	to_chat(user, span_warning("你在使用[src]时去了平衡."))
	charged = FALSE
	speed_slowdown = 0
	throwforce = 60
	deltimer(power_timer)
	thrown = FALSE

/obj/item/ego_weapon/blind_obsession/on_thrown(mob/living/carbon/user, atom/target)//No, clerks cannot hilariously kill others with this
	if(!CanUseEgo(user))
		return
	if(user.get_inactive_held_item())
		to_chat(user, span_notice("单手无法投掷[src]!"))
		return
	thrown = TRUE
	user.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/anchor, multiplicative_slowdown = 0)
	return ..()

/obj/item/ego_weapon/blind_obsession/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	deltimer(power_timer)
	playsound(src, 'sound/weapons/ego/hammer.ogg', 300, FALSE, 9)
	if(charged)
		var/damage = 40
		if(ishuman(thrownby))
			damage *= get_attack_multiplier(thrownby)
			damage *= force_multiplier
			for(var/turf/open/T in range(1, src))
				var/obj/effect/temp_visual/small_smoke/halfsecond/smonk = new(T)
				smonk.color = COLOR_TEAL
				if(!ismob(thrownby))
					continue
				thrownby.HurtInTurf(T, list(thrownby), damage, RED_DAMAGE)
			PowerReset(thrownby)

/datum/movespeed_modifier/anchor
	multiplicative_slowdown = 0
	variable = TRUE

/obj/item/ego_weapon/abyssal_route
	name = "潜渊之河"
	desc = "I am the only one who moves in these waves. ... Shatter."
	special = "这把武器有一个以下潜攻击为结尾的连击系统. 在手中使用可以关闭这个连击系统. \
			这把武器拥有很快的攻击速度."
	icon_state = "abyssal_route"
	force = 10
	modified_attack_speed = 0.4
	damtype = BLACK_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_verb_continuous = list("stabs", "attacks", "slashes")
	attack_verb_simple = list("stab", "attack", "slash")
	hitsound = 'sound/weapons/ego/rapier1.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)
	var/combo = 0
	var/combo_time
	var/combo_wait = 10
	var/combo_on = TRUE
	var/can_attack = TRUE

/obj/item/ego_weapon/abyssal_route/attack_self(mob/user)
	..()
	if(combo_on)
		to_chat(user, span_warning("你改变握姿，将不再发动下潜终结技."))
		combo_on = FALSE
		return
	if(!combo_on)
		to_chat(user, span_warning("你改变握姿，将发动下潜终结技."))
		combo_on = TRUE
		return

/obj/item/ego_weapon/abyssal_route/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user)|| !can_attack)
		return
	if(world.time > combo_time || !combo_on)	//or you can turn if off I guess
		combo = 0
	combo_time = world.time + combo_wait
	if(combo == 4)
		combo = 0
		user.changeNext_move(CLICK_CD_MELEE * 2)
		force *= 2	// Should actually keep up with normal damage.
		playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
	else
		user.changeNext_move(CLICK_CD_MELEE * 0.4)
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/abyssal_route/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user)|| !can_attack)
		return
	if(!isliving(A))
		return
	if(!combo_on)
		return
	..()
	if(combo == 4)
		user.Immobilize(1.1 SECONDS)
		ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
		can_attack = FALSE
		sleep(0.5 SECONDS)
		if(QDELETED(user))
			REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
			return
		playsound(get_turf(src), 'sound/abnormalities/piscinemermaid/waterjump.ogg', 20, 0, 3)
		animate(user, alpha = 1,pixel_x = 0, pixel_z = -16, time = 0.1 SECONDS)
		user.pixel_z = -16
		sleep(0.5 SECONDS)
		can_attack = TRUE
		if(QDELETED(user))
			return
		else if(QDELETED(A) || user.z != A.z)
			animate(user, alpha = 255,pixel_x = 0, pixel_z = 16, time = 0.1 SECONDS)
			user.pixel_z = 0
			REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
			return
		for(var/i in 2 to get_dist(user, A))
			step_towards(user,A)
		if((get_dist(user, A) < 2))
			DiveAttack(A,user)
		REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
		playsound(get_turf(src), 'sound/abnormalities/bloodbath/Bloodbath_EyeOn.ogg', 20, 0, 3)
		to_chat(user, span_warning("你潜袭[A]!"))
		animate(user, alpha = 255,pixel_x = 0, pixel_z = 16, time = 0.1 SECONDS)
		user.pixel_z = 0

/obj/item/ego_weapon/abyssal_route/proc/DiveAttack(atom/A, mob/living/user, proximity_flag, params)
	A.attackby(src,user)
	can_attack = FALSE
	addtimer(CALLBACK(src, PROC_REF(DiveReset)), 5)
	for(var/turf/open/T in range(1, user))
		var/obj/effect/temp_visual/small_smoke/halfsecond/smonk = new(T)
		smonk.color = COLOR_TEAL
	for(var/mob/living/L in range(1, user))
		if(L.z != user.z) // Not on our level
			continue
		var/aoe = 28
		var/justicemod = get_attack_multiplier(user)
		aoe*=justicemod
		aoe*=force_multiplier
		if(L == user || ishuman(L))
			continue
		L.apply_damage(aoe, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)

/obj/item/ego_weapon/abyssal_route/proc/DiveReset()
	can_attack = TRUE

/obj/item/ego_weapon/windup
	name = "时钟发条"
	desc = "Yes, we can rewind your wasted time. \
	Just wind it up, close your eyes, and count to ten. When you open them, you will be standing at the exact moment you wished to be in."
	special = "在手上使用来给武器充能，最多充能四次，无充能时只造成很少伤害."
	icon_state = "windup"
	force = 10
	attack_speed = 0.5
	damtype = PALE_DAMAGE
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleaves", "cuts")
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)
	var/charges = 0
	var/max_charges = 4

/obj/item/ego_weapon/windup/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	..()
	if(charges > 0)
		if(charges == 4)
			playsound(src, 'sound/abnormalities/clock/finish.ogg', 60)
		else
			playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
	charges = max(0, charges - 1)
	if(charges == 0)
		force = 10

/obj/item/ego_weapon/windup/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(charges >= 4)
		to_chat(user,span_warning("你没法再扭动发条了!"))
		return
	if(do_after(user, (8 + (charges * 4)), src))
		charges = min(charges + 1, max_charges)
		force = (charges * 10 + 5)
		to_chat(user,span_warning("你扭动[src]的发条."))
		playsound(src.loc, 'sound/abnormalities/clock/clank.ogg', 75, TRUE)
		PlayChargeSound()
		if(charges < max_charges)
			attack_self(user)

/obj/item/ego_weapon/windup/proc/PlayChargeSound()
	set waitfor = FALSE
	sleep(10)
	if(!charges) //We don't play the sound if the player has already emptied out by now
		return
	if(charges >= 4)
		playsound(src.loc, 'sound/weapons/fixer/generic/energy3.ogg', 75, TRUE)
		return
	playsound(src.loc, 'sound/abnormalities/clock/turn_on.ogg', 75, TRUE)

/obj/item/ego_weapon/holiday
	name = "悲惨假日"
	desc = "This bag is heavy, like the burden of bringing joy to the world every night on Christmas Eve."
	icon_state = "ultimate_christmas"
	icon = 'ModularTegustation/Teguicons/joke_abnos/joke_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 40
	attack_speed = 1.6
	swingstyle = WEAPONSWING_LARGESWEEP
	damtype = RED_DAMAGE
	knockback = KNOCKBACK_MEDIUM
	attack_verb_continuous = list("bashes", "clubs")
	attack_verb_simple = list("bashes", "clubs")
	hitsound = 'sound/abnormalities/rudolta_buff/onrush1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/holiday/get_clamped_volume()
	return 30

/obj/item/ego_weapon/sunyata
	name = "空即是色"
	desc = "One. Two. The weight of your Karma returns with each rumbling of the earth."
	icon_state = "sunyata"
	force = 28
	attack_speed = 1.2
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("smacks", "slaps", "attacks", "pokes")
	attack_verb_simple = list("smack", "slap", "attack", "poke")
	hitsound = 'sound/abnormalities/myformempties/attack.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60)
	var/can_spin = TRUE
	var/spin_range = 3
	var/spinning = FALSE

/obj/item/ego_weapon/sunyata/attack(mob/living/target, mob/living/user)
	if(spinning)
		return FALSE
	..()
	can_spin = FALSE
	addtimer(CALLBACK(src, PROC_REF(spin_reset)), 12)

/obj/item/ego_weapon/sunyata/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(!can_spin)
		to_chat(user,span_warning("你攻击的太过频繁."))
		return
	if(do_after(user, 12, src))
		can_spin = TRUE
		addtimer(CALLBACK(src, PROC_REF(spin_reset)), 12)
		playsound(src, 'sound/abnormalities/myformempties/MFEattack.ogg', 75, FALSE, 4)//get a proper sound for this
		var/aoe = 20
		var/justicemod = get_attack_multiplier(user)
		aoe*=force_multiplier
		aoe*=justicemod
		var/turf/target_c = get_turf(src)
		var/list/turf_list = list()
		for(var/i = 1 to spin_range)
			turf_list = spiral_range_turfs(i, target_c) - spiral_range_turfs(i-1, target_c)
			for(var/turf/open/T in turf_list)
				new /obj/effect/temp_visual/cult/sparks(T)
				for(var/mob/living/L in T)
					if(L == user || ishuman(L))
						continue
					L.apply_damage(aoe, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
			sleep(1.5)

/obj/item/ego_weapon/sunyata/proc/spin_reset()
	can_spin = TRUE

/obj/item/ego_weapon/sunyata/get_clamped_volume()
	return 40

/obj/item/ego_weapon/effervescent
	name = "沸腾腐蚀"
	desc = "Even the scum of the earth can be molded into something useful with time and pressure."
	icon_state = "shell"
	special = "该武器会将敌人覆盖在淤泥中，造成白色伤害. 猛推可以将此效果应用到你点击的其他地块."
	force = 24
	reach = 2
	stuntime = 5
	damtype = RED_DAMAGE
	swingstyle = WEAPONSWING_THRUST

	attack_verb_continuous = list("coats", "covers", "sprays")
	attack_verb_simple = list("coat", "cover", "spray")

	hitsound = 'sound/weapons/ego/effervescent.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
	)

/obj/item/ego_weapon/effervescent/proc/StickyMuck(mob/living/target)
	target.apply_status_effect(/datum/status_effect/effervescent_sticky)

/obj/item/ego_weapon/effervescent/get_thrust_turfs(atom/target, mob/user)
	. = getline(get_step_towards(user, target), target)
	. += get_turf_in_angle(Get_Angle(user, target), get_turf(target), 1)
	for(var/turf/T in .)
		var/obj/effect/temp_visual/thrust/TT = new(T, swingcolor ? swingcolor : COLOR_GRAY)
		var/matrix/M = matrix(TT.transform)
		M.Turn(Get_Angle(user, target)-90)
		TT.transform = M
	return

/obj/item/ego_weapon/effervescent/SweepMiss(atom/target, mob/living/carbon/human/user)
	user.visible_message("<span class='danger'>[user] [swingstyle > WEAPONSWING_LARGESWEEP ? "thrusts" : "swings"] at [target]!</span>",\
		"<span class='danger'>You [swingstyle > WEAPONSWING_LARGESWEEP ? "thrust" : "swing"] at [target]!</span>", null, COMBAT_MESSAGE_RANGE, user)
	playsound(src, 'sound/abnormalities/ambling pearl/goo effect.ogg', 30, TRUE)
	user.do_attack_animation(target, used_item = src, no_effect = TRUE)

/obj/item/ego_weapon/effervescent/GetTarget(mob/user, list/potential_targets = list(), atom/clicked)
	if(ismob(clicked))
		. = clicked

	for(var/mob/living/simple_animal/hostile/H in potential_targets) // Hostile List
		if(H.status_flags & GODMODE)
			continue
		if(user.faction_check_mob(H))
			continue
		if(H.stat == DEAD)
			continue
		StickyMuck(H)
		if(.)
			continue
		. = H
		break

	if(.)
		return
	return ..()

/datum/status_effect/effervescent_sticky
	id = "EGOeffervescent"
	duration = 50 SECONDS
	tick_interval = 7
	status_type = STATUS_EFFECT_REFRESH
	examine_text = span_warning("SUBJECTPRONOUN is covered in sticky green goo filled with writhing maggots.")
	alert_type = null

/datum/status_effect/effervescent_sticky/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_ATOM_ATTACK_HAND, PROC_REF(CleanOff))

/datum/status_effect/effervescent_sticky/on_remove()
	UnregisterSignal(owner, COMSIG_ATOM_ATTACK_HAND)
	return ..()

/datum/status_effect/effervescent_sticky/tick()
	. = ..()
	for(var/mob/living/victim in orange(2, src))
		if(faction_check(victim.faction, owner.faction))
			victim.deal_damage(5, WHITE_DAMAGE)
	if(prob(40))
		playsound(owner, 'sound/abnormalities/ambling pearl/goo effect.ogg', 40)

/datum/status_effect/effervescent_sticky/proc/CleanOff(datum/source, mob/living/carbon/wiper)
	. = FALSE
	if(!istype(wiper))
		return
	if(wiper.a_intent != INTENT_HELP)
		return
	if(wiper != owner)
		owner.visible_message(span_notice("[wiper] begins to clean the muck off [owner]."), span_notice("You begin to wipe the muck off [owner]."), ignored_mobs = owner)
		to_chat(owner, span_notice("[wiper] begins to wipe the muck off of you."))
	else
		owner.visible_message(span_notice("[owner] begins to wipe the muck off themselves."), span_notice("You begin to wipe the muck off yourself."))
	if(!do_after(wiper, 5, owner))
		return TRUE
	if(QDELETED(src))
		return
	if(wiper != owner)
		owner.visible_message(span_nicegreen("[wiper] wipes the muck off [owner]."), span_nicegreen("You wipe the muck off [owner]."), ignored_mobs = owner)
		to_chat(owner, span_nicegreen("[wiper] wipes the muck off of you."))
	else
		owner.visible_message(span_nicegreen("[owner] wipes the muck off themselves."), span_nicegreen("You wipe the muck off yourself."))
	qdel(src)
	return TRUE

/obj/item/ego_weapon/contempt
	name = "轻蔑，敬畏"
	desc = "From the excavated brain, geysers of hatred and contempt erupt. It's as if those feelings were inside you all along."
	icon_state = "contempt"
	force = 24
	reach = 2
	stuntime = 5
	throwforce = 80
	throw_speed = 5
	throw_range = 7
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/abnormalities/spiral_contempt/spiral_hit.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	var/list/targets = list()
	var/ranged_damage = 70
	var/mode = FALSE
	var/toggle_cooldown
	var/toggle_cooldown_time = 1 SECONDS

/obj/item/ego_weapon/contempt/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return

	if(!mode)
		if(!(M in targets))
			targets+= M
	if(mode)
		if(M in targets)
			playsound(M, 'sound/abnormalities/spiral_contempt/spiral_bleed.ogg', 100, FALSE, 4)
			M.apply_damage(ranged_damage, BLACK_DAMAGE, null, M.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			new /obj/effect/temp_visual/contempt_blood(get_turf(M))
			targets -= M
	..()
	hitsound = initial(hitsound)

/obj/item/ego_weapon/contempt/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(toggle_cooldown > world.time)//spam prevention
		return
	toggle_cooldown = world.time + toggle_cooldown_time
	if(mode)
		mode = FALSE
		to_chat(user,span_warning("你的[src]正在滴血."))
		targets = list()
		playsound(src, 'sound/abnormalities/spiral_contempt/spiral_grow.ogg', 20, FALSE)
		return

	if(!mode)
		mode = TRUE
		to_chat(user,span_warning("你的[src]现在长出了黄金尖刺."))
		playsound(src, 'sound/abnormalities/spiral_contempt/spiral_whine.ogg', 20, FALSE)
		return

/obj/item/ego_weapon/contempt/get_clamped_volume()
	return 25

/obj/item/ego_weapon/ardor_star
	name = "红焰新星"
	desc = "Though I can't guide you... I can offer a warm embrace."
	icon_state = "ardor_star"
	inhand_icon_state = "ardor_star"
	special = "这把武器造成额外的火焰伤害."
	force = 20
	attack_speed = 1.8
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/ardor_star/attack(mob/living/target, mob/living/user)
	..()
	if(!CanUseEgo(user))
		return
	var/justicemod = get_attack_multiplier(user)
	var/damage = force * justicemod * force_multiplier * 0.5
	target.apply_damage(damage, FIRE, null, target.run_armor_check(null, FIRE), spread_damage = TRUE)
	target.apply_lc_burn(3)
