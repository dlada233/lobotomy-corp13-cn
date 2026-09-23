/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon
	name = "G公司军官"
	desc = "一名重度虫化、拥有两根锋利的昆虫手臂的员工。在烟霾战争期间，G公司会将那些虫化更为剧烈的人作为突击部队。"
	icon_state = "gcorp5"
	icon_living = "gcorp5"
	icon_dead = "gcorp_corpse2"
	death_message = "虚弱地敬礼，然后倒下."
	maxHealth = 330
	health = 330
	rapid_melee = 2
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.8)
	attack_verb_continuous = "切削"
	attack_verb_simple = "切削"
	death_sound = 'sound/voice/mook_death.ogg'
	butcher_results = list(/obj/item/food/meat/slab/buggy = 2)
	silk_results = list(/obj/item/stack/sheet/silk/steel_simple = 2, /obj/item/stack/sheet/silk/steel_advanced = 1)

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/AttackingTarget(atom/attacked_target)
	adjustBruteLoss(-3)
	if(health <= maxHealth * 0.25 && stat != DEAD && prob(75))
		walk_to(src, 0)
		move_to_delay = 3.3
		say("FOR G CORP!!!")
		animate(src, transform = matrix()*1.8, color = "#FF0000", time = 15)
		addtimer(CALLBACK(src, PROC_REF(DeathExplosion)), 15)
	..()

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/proc/DeathExplosion()
	if(QDELETED(src))
		return
	visible_message(span_danger("[src]突然爆炸!"))
	new /obj/effect/temp_visual/explosion(get_turf(src))
	playsound(loc, 'sound/effects/ordeals/steel/gcorp_boom.ogg', 60, TRUE)
	for(var/mob/living/L in ohearers(3, src))
		L.deal_damage(20, RED_DAMAGE, attack_type = (ATTACK_TYPE_SPECIAL))

	//Buff allies, all of these buffs only activate once.
	//Buff the grunts around you when you die
	for(var/mob/living/simple_animal/hostile/ordeal/steel_dawn/Y in ohearers(7, src))
		if(Y.stat >= UNCONSCIOUS)
			continue
		Y.say("FOR G CORP!!!")

		//increase damage
		Y.melee_damage_lower *= 1.5
		Y.melee_damage_upper *= 1.5
		//And heal 50%
		Y.adjustBruteLoss(-Y.maxHealth*0.5)

	//And any manager
	for(var/mob/living/simple_animal/hostile/ordeal/steel_dusk/Z in ohearers(7, src))
		if(Z.stat >= UNCONSCIOUS)
			continue
		Z.say("今夜全军点兵.")
		Z.screech_windup = 3 SECONDS

	gib()

//flying varient trades movement and attack speed for a sweeping attack.
/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying
	name = "G公司 Arial侦察兵"
	desc = "一只带有翅膀，长着昆虫手臂的重度虫化员工. 烟霾战争期间，兔子队常常被隐藏在烟雾弥漫的天空中的蜂群袭击."
	icon_state = "gcorp6"
	icon_living = "gcorp6"
	environment_smash = FALSE
	is_flying_animal = TRUE
	footstep_type = null
	rapid_melee = 1
	ranged = TRUE
	ranged_cooldown_time = 15 SECONDS
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	buffed = FALSE
	move_to_delay = 3
	var/charging = FALSE

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/Move()
	if(buffed && !charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/AttackingTarget(atom/attacked_target)
	if(ranged_cooldown <= world.time && prob(30))
		if(!target)
			GiveTarget(attacked_target)
		OpenFire()
		return
	return ..()

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/CanAllowThrough(atom/movable/mover, turf/target)
	if(charging && isliving(mover))
		return TRUE
	. = ..()

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/Shoot(atom/A)
	if(buffed || !isliving(A))
		return FALSE
	animate(src, alpha = alpha - 50, pixel_y = base_pixel_y + 25, layer = 6, time = 10)
	buffed = TRUE
	density = FALSE
	if(do_after(src, 2 SECONDS, target = src))
		ArialSupport()
	else
		visible_message(span_notice("[src]坠落到地面."))
		deal_damage(30, RED_DAMAGE)
	//return to the ground
	density = TRUE
	layer = initial(layer)
	buffed = FALSE
	alpha = initial(alpha)
	pixel_y = initial(pixel_y)
	base_pixel_y = initial(base_pixel_y)

	//from current location fly to the enemy and hit them. Utilizes some little helper abnormality code. Later on i should make them less accurate.
/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/proc/ArialSupport()
	charging = TRUE
	var/turf/target_turf = get_turf(target)
	for(var/i=0 to 7)
		var/turf/wallcheck = get_step(src, get_dir(src, target_turf))
		if(!ClearSky(wallcheck))
			break
		var/mob/living/sweeptarget = locate(target) in wallcheck
		if(sweeptarget)
			SweepAttack(sweeptarget)
			break
		forceMove(wallcheck)
		SLEEP_CHECK_DEATH(0.5)
	charging = FALSE

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/proc/SweepAttack(mob/living/sweeptarget)
	sweeptarget.visible_message(span_danger("[src]直冲[sweeptarget]!"), span_userdanger("[src]直冲向你!"))
	sweeptarget.deal_damage(10, RED_DAMAGE, src, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
	playsound(get_turf(src), 'sound/effects/meteorimpact.ogg', 50, TRUE)
	if(sweeptarget.mob_size <= MOB_SIZE_HUMAN)
		DoKnockback(sweeptarget, src, get_dir(src, sweeptarget))
		shake_camera(sweeptarget, 2, 3)
		shake_camera(src, 1, 3)

/mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying/proc/DoKnockback(atom/target, mob/thrower, throw_dir) //stolen from the knockback component since this happens only once
	if(!ismovable(target) || throw_dir == null)
		return
	var/atom/movable/throwee = target
	if(throwee.anchored)
		return
	if(QDELETED(throwee))
		return
	var/atom/throw_target = get_edge_target_turf(throwee, throw_dir)
	throwee.safe_throw_at(throw_target, 1, 1, thrower, gentle = TRUE)
