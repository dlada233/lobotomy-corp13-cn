//My sweet orange tree - The cure
/obj/item/ego_weapon/ranged/flammenwerfer
	name = "喷火器"
	desc = "一把很烂的火焰喷射器，但非常适合清理被感染的区域和人员."
	special = "在手中使用来对自己喷火，这是为了阻止你自己的感染."
	icon = 'icons/obj/flamethrower.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/flamethrower_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/flamethrower_righthand.dmi'
	icon_state = "flamethrower1"
	inhand_icon_state = "flamethrower_1"
	projectile_path = /obj/projectile/ego_bullet/flammenwerfer
	weapon_weight = WEAPON_HEAVY
	spread = 50
	fire_sound = 'sound/effects/burn.ogg'
	autofire = 0.08 SECONDS
	fire_sound_volume = 5

/obj/item/ego_weapon/ranged/flammenwerfer/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(do_after(H, 12, src))
		to_chat(H,"<span class='warning'>你将自己点燃!</span>")
		H.playsound_local(get_turf(H), 'sound/effects/burn.ogg', 100, 0)
		H.apply_damage(10, RED_DAMAGE, null, H.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		H.adjust_fire_stacks(1)
		H.IgniteMob()

//Nihil Upgrade
/obj/item/ego_weapon/ranged/hatred_nihil
	name = "漫无目的的憎恶"
	desc = "如果我站在善的一边，那么就必然有人站在恶的一边. 倘若无人扮演邪恶，我的憎恶将腐烂于心."
	icon_state = "hate"
	inhand_icon_state = "hate"
	fire_delay = 1
	autofire = 0.5 SECONDS
	special = "这把武器会治疗它所击中的人类."
	force = 35
	damtype = BLACK_DAMAGE
	weapon_weight = WEAPON_HEAVY
	projectile_path = /obj/projectile/ego_bullet/ego_hatred
	fire_sound = 'sound/abnormalities/hatredqueen/attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/can_blast = TRUE
	var/blasting = FALSE
	var/blast_damage = 150

/obj/item/ego_weapon/ranged/hatred_nihil/proc/Recharge(mob/user)
	can_blast = TRUE
	to_chat(user,"<span class='nicegreen'>阿尔卡纳之力已准备好发射.</span>")

/obj/item/ego_weapon/ranged/hatred_nihil/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(!can_blast)
		to_chat(user,"<span class='warning'>你发射的太过频繁了.</span>")
		return
	can_blast = FALSE
	var/obj/effect/qoh_sygil/S = new(get_turf(src))
	S.icon_state = "qoh1"
	switch(user.dir)
		if(EAST)
			S.pixel_x += 16
			var/matrix/new_matrix = matrix()
			new_matrix.Scale(0.5, 1)
			S.transform = new_matrix
			S.layer = (src.layer + 0.1)
		if(WEST)
			S.pixel_x += -16
			var/matrix/new_matrix = matrix()
			new_matrix.Scale(0.5, 1)
			S.transform = new_matrix
			S.layer = (src.layer + 0.1)
		if(SOUTH)
			S.pixel_y += -16
			S.layer = (src.layer + 0.1)
		if(NORTH)
			S.pixel_y += 16
			S.layer -= 0.1
	addtimer(CALLBACK(S, TYPE_PROC_REF(/obj/effect/qoh_sygil, fade_out)), 3 SECONDS)
	if(do_after(user, 15, src))
		var/aoe = blast_damage
		var/justicemod = get_attack_multiplier(user)
		var/firsthit = TRUE //One target takes full damage
		var/turf/stepturf = (get_step(get_step(user, user.dir), user.dir))
		playsound(src, 'sound/abnormalities/hatredqueen/gun.ogg', 65, FALSE, 4)
		aoe*=justicemod
		for(var/turf/T in range(2, stepturf))
			new /obj/effect/temp_visual/revenant(T)
		for(var/mob/living/L in range(2, stepturf)) //knocks enemies away from you
			if(L == user || ishuman(L))
				continue
			L.apply_damage(aoe, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			if(firsthit)
				aoe = (aoe / 2)
				firsthit = FALSE
			var/throw_target = get_edge_target_turf(L, get_dir(L, get_step_away(L, src)))
			if(!L.anchored)
				var/whack_speed = (prob(60) ? 1 : 4)
				L.throw_at(throw_target, rand(1, 2), whack_speed, user)
	addtimer(CALLBACK(src, PROC_REF(Recharge), user), 15 SECONDS)
