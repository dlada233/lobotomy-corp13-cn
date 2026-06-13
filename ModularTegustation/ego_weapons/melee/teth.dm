/obj/item/ego_weapon/training
	name = "训练锤"
	desc = "E.G.O用于主管进行教学"
	icon_state = "training"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 8
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("smacks", "hammers", "beats")
	attack_verb_simple = list("smack", "hammer", "beat")

/obj/item/ego_weapon/fragment
	name = "彼方的裂片"
	desc = "The spear often tries to lead the wielder into a long and endless realm of mind, \
	but they must try to not be swayed by it."
	icon_state = "fragment"
	force = 15
	reach = 2		//Has 2 Square Reach.
	stuntime = 5	//Longer reach, gives you a short stun.
	attack_speed = 1.2
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'


/obj/item/ego_weapon/horn
	name = "犄角"
	desc = "As the horn digs deep into the enemy's heart, it will turn blood red to show off the glamor that she couldn't in her life."
	icon_state = "horn"
	force = 10
	throwforce = 15		//You can only hold two so go nuts.
	throw_speed = 5
	throw_range = 7
	damtype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'

/obj/item/ego_weapon/lutemia
	name = "亲爱的lutemia"
	desc = "Don't you want your cares to go away?"
	icon_state = "lutemia"
	force = 4
	reach = 3		//Has 3 Square Reach.
	special = "在手中使用以开启这把武器的连击系统."
	modified_attack_speed = 0.6
	var/combo = 0
	var/combo_time
	var/combo_wait = 8
	var/combo_on = TRUE
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("whips", "lashes", "tears")
	attack_verb_simple = list("whip", "lash", "tear")
	hitsound = 'sound/weapons/whip.ogg'

/obj/item/ego_weapon/lutemia/attack_self(mob/user)
	..()
	if(combo_on)
		to_chat(user,span_warning("你改变了姿态，将不再使用终结技."))
		combo_on = FALSE
		return
	if(!combo_on)
		to_chat(user,span_warning("你改变了姿态，现在将进行终结技。."))
		combo_on =TRUE
		return

/obj/item/ego_weapon/lutemia/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 1
	if(!combo_on)
		combo = 0
	combo_time = world.time + combo_wait
	switch(combo)
		if(0)
			user.changeNext_move(CLICK_CD_MELEE * 0.6)
		if(1)
			force *= 0.6
			user.changeNext_move(CLICK_CD_MELEE * 0.3)
			combo_time = world.time + combo_wait - 3
		if(2)
			user.changeNext_move(CLICK_CD_MELEE * 0.6)
		if(3)
			combo = 0
			force *= 4
			user.changeNext_move(CLICK_CD_MELEE * 2)
	. = ..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/eyes
	name = "赤瞳"
	desc = "It is likely able to hear, touch, smell, as well as see. And most importantly, taste."
	icon_state = "eyes"
	force = 16 //Still less DPS, replaces baseball bat
	attack_speed = 1.6
	damtype = RED_DAMAGE
	knockback = KNOCKBACK_LIGHT
	attack_verb_continuous = list("beats", "smacks")
	attack_verb_simple = list("beat", "smack")
	hitsound = 'sound/weapons/fixer/generic/gen1.ogg'

/obj/item/ego_weapon/mini/wrist
	name = "割腕者"
	desc = "The flesh cleanly cut by a sharp tool creates a grotesque pattern with the bloodstains on the suit."
	special = "在手中使用来发动闪避动作."
	icon_state = "wrist"
	force = 5
	attack_speed = 0.5
	swingstyle = WEAPONSWING_LARGESWEEP
	damtype = WHITE_DAMAGE
	hitsound = 'sound/weapons/fixer/generic/knife2.ogg'
	var/dodgelanding

/obj/item/ego_weapon/mini/wrist/attack_self(mob/living/carbon/user)
	if(user.dir == 1)
		dodgelanding = locate(user.x, user.y + 5, user.z)
	if(user.dir == 2)
		dodgelanding = locate(user.x, user.y - 5, user.z)
	if(user.dir == 4)
		dodgelanding = locate(user.x + 5, user.y, user.z)
	if(user.dir == 8)
		dodgelanding = locate(user.x - 5, user.y, user.z)
	user.adjustStaminaLoss(8, TRUE, TRUE)
	user.throw_at(dodgelanding, 3, 2, spin = TRUE)

/obj/item/ego_weapon/regret
	name = "悔恨"
	desc = "Before swinging this weapon, expressing one’s condolences for the demise of the inmate who couldn't even have a funeral would be nice."
	icon_state = "regret"
	force = 20				//Lots of damage, way less DPS
	damtype = RED_DAMAGE
	attack_speed = 2 // Really Slow. This is the slowest teth we have, +0.4 to Eyes 1.6
	attack_verb_continuous = list("smashes", "bludgeons", "crushes")
	attack_verb_simple = list("smash", "bludgeon", "crush")
	hitsound = 'sound/weapons/fixer/generic/club3.ogg'
	usesound = 'sound/weapons/fixer/generic/club3.ogg'
	tool_behaviour = TOOL_MINING

/obj/item/ego_weapon/mini/blossom
	name = "落樱"
	desc = "The flesh cleanly cut by a sharp tool creates a grotesque pattern with the bloodstains on the suit."
	special = "Upon throwing, this weapon returns to the user."
	icon_state = "blossoms"
	force = 8
	throwforce = 10
	throw_speed = 1
	throw_range = 7
	damtype = WHITE_DAMAGE
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/ego_weapon/mini/blossom/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
	if(thrownby && !caught)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, throw_at), thrownby, throw_range+2, throw_speed, null, TRUE), 1)
	if(caught)
		return
	else
		return ..()

/obj/item/ego_weapon/cute
	name = "超特么可爱!!!"
	desc = "One may think, 'How can a weapon drawn from such a cute Abnormality be any good?' \
		However, the claws are actually quite durable and sharp."
	icon_state = "cute"
	force = 5
	attack_speed = 0.5
	damtype = RED_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	hitsound = 'sound/weapons/slashmiss.ogg'

/obj/item/ego_weapon/mini/trick
	name = "帽子戏法"
	desc = "Imagination is the only weapon in the war with reality."
	icon_state = "trick"
	force = 8
	swingstyle = WEAPONSWING_LARGESWEEP
	throwforce = 10
	throw_speed = 5
	throw_range = 7
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("jabs")
	attack_verb_simple = list("jabs")
	hitsound = 'sound/weapons/slashmiss.ogg'

/obj/item/ego_weapon/sorrow
	name = "悲伤"
	desc = "It all returns to nothing."
	special = "在手中使用这把武器以受伤为代价传送到随机部门."
	icon_state = "sorrow"
	force = 12					//Bad DPS, can teleport
	attack_speed = 1.5
	damtype = RED_DAMAGE
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleave", "cut")
	hitsound = 'sound/weapons/fixer/generic/blade4.ogg'

/obj/item/ego_weapon/sorrow/attack_self(mob/living/user)
	var/area/turf_area = get_area(get_turf(user))
	if(istype(turf_area, /area/fishboat))
		to_chat(user, span_warning("[src]在这里无法使用!."))
		return
	if(do_after(user, 50, src))	//Five seconds of not doing anything, then teleport.
		new /obj/effect/temp_visual/dir_setting/ninja/phase/out (get_turf(user))
		user.adjustBruteLoss(user.maxHealth*0.3)

		//teleporting half
		var/turf/T = pick(GLOB.department_centers)
		user.forceMove(T)
		new /obj/effect/temp_visual/dir_setting/ninja/phase (get_turf(user))
		playsound(src, 'sound/effects/contractorbatonhit.ogg', 100, FALSE, 9)

/obj/item/ego_weapon/sorority
	name = "姐妹"
	desc = "Look to your sisters, and fight in sorority."
	special = "在手中使用这把武器将对你周围的人造成少量肉体伤害，但轻微治疗他们的SP"
	icon_state = "sorority"
	force = 8					//Also a support weapon
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("zaps", "prods")
	attack_verb_simple = list("zap", "prod")
	hitsound = 'sound/weapons/fixer/generic/baton4.ogg'

/obj/item/ego_weapon/sorority/attack_self(mob/user)
	if(do_after(user, 10, src))	//Just a second to heal people around you, but it also harms them
		playsound(src, 'sound/weapons/taser.ogg', 200, FALSE, 9)
		for(var/mob/living/carbon/human/L in range(2, get_turf(user)))
			L.adjustBruteLoss(L.maxHealth*0.1)
			L.adjustSanityLoss(-10)
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))

/obj/item/ego_weapon/mini/bean
	name = "魔豆"
	desc = "We may never find out what lies at the top, but perhaps those who made it are doing well up there."
	icon_state = "bean"
	force = 8
	damtype = BLACK_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'

/obj/item/ego_weapon/shield/hearth
	name = "灶炉"
	desc = "Home sweet home. Warmth and safety aplenty."
	icon_state = "hearth"
	force = 10
	attack_speed = 1
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	reductions = list(10, 30, 20, 0) // 60
	projectile_block_duration = 0 SECONDS //No ranged parry
	block_duration = 1 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/parry.ogg'
	block_message = "You attempt to parry the attack!"
	hit_message = "parries the attack!"
	block_cooldown_message = "You rearm your blade."

/obj/item/ego_weapon/shield/hearth/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	return 0 //Prevents ranged  parry

/obj/effect/temp_visual/smash1
	icon = 'icons/effects/effects.dmi'
	icon_state = "smash1"
	duration = 3

#define LANTERN_MODE_REMOTE (1<<0)
#define LANTERN_MODE_AUTO (1<<1)

/obj/item/ego_weapon/lantern //meat lantern
	name = "诱捕幻灯"
	desc = "Teeth sticking out of some spots of the equipment is a rather frightening sight."
	special = "攻击附近的地块以制造陷阱，远程模式可以从远处触发陷阱. \
	自动模式设置的陷阱会在敌人经过时触发，在手中使用来切换模式."
	icon_state = "lantern"
	force = 15
	attack_speed = 1.5
	damtype = BLACK_DAMAGE
	hitsound = 'sound/weapons/fixer/generic/gen1.ogg'
	var/mode = LANTERN_MODE_REMOTE
	var/traplimit = 6
	var/list/traps = list()
	var/burst_cooldown
	var/burst_cooldown_time = 5 SECONDS

/obj/item/ego_weapon/lantern/attack_self(mob/user)
	if(mode == LANTERN_MODE_REMOTE)
		to_chat(user, span_info("你调整任何新放置的陷阱，使其由运动触发."))
		mode = LANTERN_MODE_AUTO
	else
		to_chat(user, span_info("你现在可以远程触发任何放置的陷阱."))
		mode = LANTERN_MODE_REMOTE

/obj/item/ego_weapon/lantern/proc/CreateTrap(target, mob/user, proximity_flag)
	var/turf/T = get_turf(target)
	if((get_dist(user, T) > 20))
		return
	var/obj/effect/temp_visual/lanterntrap/R = locate(/obj/effect/temp_visual/lanterntrap) in T
	if(R)
		if(!proximity_flag && mode != LANTERN_MODE_REMOTE)
			return
		if(burst_cooldown <= world.time)
			R.burst()
			burst_cooldown = world.time + burst_cooldown_time
		else
			to_chat(user, "<span class='warning'>你的陷阱刚刚被触发了!")
		return
	if(proximity_flag && (LAZYLEN(traps) < traplimit))
		var/obj/effect/temp_visual/lanterntrap/trap = new(T, user, src, mode)
		var/justicemod = get_attack_multiplier(user)
		trap.damage_multiplier*=justicemod
		trap.damage_multiplier*=force_multiplier
		user.changeNext_move(CLICK_CD_MELEE)

/obj/item/ego_weapon/lantern/afterattack(atom/target, mob/living/user, proximity_flag, params)
	if(check_allowed_items(target, 1))
		CreateTrap(target, user, proximity_flag)
	. = ..()

/obj/effect/temp_visual/lanterntrap
	name = "诱捕陷阱"
	icon_state = "mini_lantern" //temp visual
	layer = ABOVE_ALL_MOB_LAYER
	duration = 60 SECONDS
	var/resonance_damage = 15
	var/damage_multiplier = 1
	var/mob/creator
	var/obj/item/ego_weapon/lantern/res
	var/rupturing = FALSE //So it won't recurse
	var/range = 1
	var/mine_mode

/obj/effect/temp_visual/lanterntrap/Initialize(mapload, set_creator, set_resonator, mode)
	mine_mode = mode
	if(mode == LANTERN_MODE_AUTO)
		icon_state = "mini_lantern_auto" //temp visual
		resonance_damage = 25
		range = 0
		RegisterSignal(src, list(COMSIG_MOVABLE_CROSSED, COMSIG_ATOM_ENTERED), PROC_REF(burst_check))
	. = ..()
	creator = set_creator
	res = set_resonator
	if(res)
		res.traps += src
	playsound(src,'sound/weapons/resonator_fire.ogg',50,TRUE)
	deltimer(timerid)
	timerid = addtimer(CALLBACK(src, PROC_REF(burst)), duration, TIMER_STOPPABLE)

/obj/effect/temp_visual/lanterntrap/Destroy()
	if(res)
		res.traps -= src
		res = null
	creator = null
	return ..()

/obj/effect/temp_visual/lanterntrap/proc/burst_check()
	for(var/mob/living/L in get_turf(src))
		if(creator.faction_check_mob(L))
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.sanity_lost)
					burst()
		if(!creator.faction_check_mob(L))
			burst()

/obj/effect/temp_visual/lanterntrap/proc/burst()
	var/turf/T = get_turf(src)
	playsound(T, 'sound/effects/ordeals/amber/midnight_out.ogg', 40,TRUE)
	for(var/turf/open/T2 in RANGE_TURFS(range, src))
		new /obj/effect/temp_visual/yellowsmoke(T2)
		for(var/mob/living/L in creator.HurtInTurf(T2, list(), resonance_damage * damage_multiplier, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE))
			to_chat(L, span_userdanger("[src]咬了你!"))
			if(creator)
				creator.visible_message(span_danger("[creator]在[L]上激活了[src]!"),span_danger("你激活了在[L]上的[src]!"), null, COMBAT_MESSAGE_RANGE, L)
	if(mine_mode == LANTERN_MODE_REMOTE)//So that you can't just place one automatic mine and 5 manual ones around it
		rupturing = TRUE
		for(var/obj/effect/temp_visual/lanterntrap/field in orange((range * 2) + 1, src))//Wierd formula that lets you spread out your mines for a big aoe.
			if(field.mine_mode == mine_mode && !field.rupturing)//So that it can't trigger automatic mines by accident.
				field.burst()
		qdel(src)
	else
		qdel(src)

#undef LANTERN_MODE_REMOTE
#undef LANTERN_MODE_AUTO

/obj/item/ego_weapon/sloshing
	name = "晃晃悠悠"
	desc = "It hits just right! Let's help ourselves to some wine when we come back!"
	icon_state = "sloshing"
	force = 20
	attack_speed = 2
	damtype = WHITE_DAMAGE
	hitsound = 'sound/abnormalities/fairygentleman/ego_sloshing.ogg'
	attack_verb_continuous = list("smacks", "strikes", "beats")
	attack_verb_simple = list("smack", "strike", "beat")

/obj/item/ego_weapon/red_sheet
	name = "朱符"
	desc = "A bo staff covered in talismans. Despite being tightly glued to the weapon, they flutter about as you strike."
	special = "攻击敌人多次将附加一个咒语给他们，这会让它们面对黑色伤害更加脆弱."
	icon_state = "red_sheet"
	force = 8
	damtype = BLACK_DAMAGE
	hitsound = 'sound/abnormalities/nocry/ego_redsheet.ogg'
	var/hit_count = 0

/obj/item/ego_weapon/red_sheet/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(isliving(target))
		++hit_count
		if(hit_count >= 4)
			var/mob/living/simple_animal/M = target
			if(!ishuman(M) && !M.has_status_effect(/datum/status_effect/display/rend/black))
				playsound(src, 'sound/abnormalities/so_that_no_cry/curse_talisman.ogg', 100, 1)
				to_chat(user, "一张来自[src]的符咒贴到了[target]!")
				new /obj/effect/temp_visual/talisman(get_turf(M))
				M.apply_status_effect(/datum/status_effect/display/rend/black)
				hit_count = 0

/obj/item/ego_weapon/shield/capote
	name = "斗牛披风"
	desc = "Charge me with all your strength! Your horns cannot pierce my soul!"//yes this is a SMT quote
	icon_state = "capote"
	worn_icon = 'icons/obj/clothing/belt_overlays.dmi'
	worn_icon_state = "capote"
	force = 10
	attack_speed = 1
	damtype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	reductions = list(20, 20, 20, 0)
	block_duration = 1 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/fixer/generic/dodge.ogg'
	block_message = "你尝试闪避攻击!"
	hit_message = "躲避攻击!"
	block_cooldown_message = "你调整架势."

/obj/item/ego_weapon/mini/sticking
	name = "粘连"
	desc = "A weapon fit for those that would backstab someone after gaining their trust."
	special = "该武器每次攻击将累计1点平衡，每点平衡增加2%暴击概率，暴击造成三倍伤害，暴击后平衡清零。此外，随着持续攻击，这把武器的伤害和攻速会不断提升."
	icon_state = "sticking"
	force = 5
	attack_speed = 0.5
	swingstyle = WEAPONSWING_LARGESWEEP
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/fixer/generic/knife2.ogg'
	var/poise = 0

/obj/item/ego_weapon/mini/sticking/examine(mob/user)
	. = ..()
	. += "当前平衡: [poise]/20."

/obj/item/ego_weapon/mini/sticking/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	poise+=1
	if(poise>= 20)
		poise = 20

	//Crit itself.
	if(prob(poise*2))
		force*=3
		to_chat(user, span_userdanger("Critical!"))
		poise = 0
	..()
	force = initial(force)

/obj/item/ego_weapon/zauberhorn
	name = "zauberhorn"
	desc = "Falada, Falada, thou art dead, and all the joy in my life has fled."
	special = "这把E.G.O.可以在枪和近战武器之间切换."
	icon_state = "zauberhorn"
	force = 5
	damtype = BLACK_DAMAGE
	attack_speed = 0.5
	attack_verb_continuous = list("cuts", "slices")
	attack_verb_simple = list("cuts", "slices")
	hitsound = 'sound/weapons/fixer/generic/club2.ogg'

	var/gun_cooldown
	var/gun_cooldown_time = 1.2 SECONDS

/obj/item/ego_weapon/zauberhorn/Initialize()
	RegisterSignal(src, COMSIG_PROJECTILE_ON_HIT, PROC_REF(projectile_hit))
	return ..()

/obj/item/ego_weapon/zauberhorn/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	if(!CanUseEgo(user))
		return
	if(!proximity_flag && gun_cooldown <= world.time)
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		var/obj/projectile/ego_bullet/zauberhorn/G = new /obj/projectile/ego_bullet/zauberhorn(proj_turf)
		G.fired_from = src //for signal check
		playsound(user, 'sound/abnormalities/pagoda/throw.ogg', 100, TRUE) //yes im reusing a sound bite me
		G.firer = user
		G.preparePixelProjectile(target, user, clickparams)
		G.fire()
		G.damage*=force_multiplier
		gun_cooldown = world.time + gun_cooldown_time
		return

/obj/item/ego_weapon/zauberhorn/proc/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	SIGNAL_HANDLER
	return TRUE

/obj/projectile/ego_bullet/zauberhorn
	name = "飞行马蹄"
	icon_state = "horseshoe"
	hitsound = 'sound/weapons/fixer/generic/club3.ogg'
	damage = 20
	damage_type = BLACK_DAMAGE

/obj/item/ego_weapon/sanitizer
	name = "洗手液"
	desc = "It's very shocking."
	icon_state = "sanitizer"
	force = 16
	attack_speed = 1.6
	damtype = BLACK_DAMAGE
	knockback = KNOCKBACK_LIGHT
	attack_verb_continuous = list("beats", "smacks")
	attack_verb_simple = list("beat", "smack")
	hitsound = 'sound/weapons/fixer/generic/gen1.ogg'

/obj/item/ego_weapon/lance/curfew
	name = "午夜深宵"
	desc = "The thing itself had never forgotten its glory days."
	icon_state = "curfew"
	lefthand_file = 'icons/mob/inhands/96x96_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/96x96_righthand.dmi'
	inhand_x_dimension = 96
	inhand_y_dimension = 96
	force = 18
	reach = 2		//Has 2 Square Reach.
	stuntime = 6	//Longer reach, gives you a short stun.
	attack_speed = 1.8// really slow
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("bludgeons", "whacks")
	attack_verb_simple = list("bludgeon", "whack")
	hitsound = 'sound/weapons/fixer/generic/spear2.ogg'

/obj/item/ego_weapon/lance/skinprophet
	name = "9章2节"
	desc = "The people walking in darkness have seen a great light; on those living in the land of deep darkness a light has dawned."
	special = "A polearm that collapses, and extends while charging."
	icon_state = "prophet"
	lefthand_file = 'icons/mob/inhands/96x96_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/96x96_righthand.dmi'
	damtype = WHITE_DAMAGE
	force = 16
	inhand_x_dimension = 96
	inhand_y_dimension = 96
	attack_speed = 2
	attack_verb_continuous = list("stabs", "impales")
	attack_verb_simple = list("stab", "impale")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	reach = 1
	force_cap = 30
	force_per_tile = 2
	pierce_force_cost = 20
	charge_speed_cap = 2
	couch_cooldown_time = 3 SECONDS

/obj/item/ego_weapon/kikimora
	name = "奇奇莫拉"
	desc = "Many would speak her name."
	icon_state = "kikimora"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 16
	attack_speed = 1.6
	damtype = RED_DAMAGE
	attack_verb_continuous = list("beats", "smacks")
	attack_verb_simple = list("beat", "smack")
	hitsound = 'sound/weapons/fixer/generic/gen1.ogg'

/obj/item/ego_weapon/denial
	name = "否认"
	desc = "Unregulated ingestion of Enkephalin may cause a wide range of unverified psychopathological symptoms."
	icon_state = "denial"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 15
	damtype = WHITE_DAMAGE
	attack_speed = 1.5
	attack_verb_continuous = list("smashes", "bludgeons", "crushes")
	attack_verb_simple = list("smash", "bludgeon", "crush")
	hitsound = 'sound/abnormalities/ichthys/slap.ogg'

/obj/item/ego_weapon/rapunzel
	name = "长发公主"
	desc = "Scissors long since lost to time. Packs a punch while being unwieldy."
	icon_state = "rapunzel"
	force = 16
	stuntime = 5	//Mucho damage, bit of stun in exchange
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/fixer/generic/knife2.ogg'

/obj/item/ego_weapon/mini/clayman
	name = "创作自由"
	desc = "Clay and flesh are both mediums for expression."
	special = "该武器在蓄力攻击后造成减速."
	icon_state = "creativefreedom"
	force = 10
	attack_speed = 0.7
	damtype = PALE_DAMAGE
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/ego_weapon/mini/clayman/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	damtype = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE)
	if(prob(10))
		damtype = PALE_DAMAGE
	..()

/obj/item/ego_weapon/mini/clayman/EgoAttackInfo(mob/user)
	if(force_multiplier != 1)
		return span_notice("It deals [round((force) * force_multiplier)] damage. (+ [(force_multiplier - 1) * 100]%)")
	return span_notice("It deals [force] damage.")

/obj/item/ego_weapon/white_gossypium
	name = "白色羽花"
	desc = "Like a straw, this vine seeks to suck the blood out of your veins."
	icon_state = "white_gossypium"
	force = 18
	reach = 4 //has 4 square reach
	attack_speed = 2.2 //a TETH whip should probably be slower than Eris
	damtype = RED_DAMAGE
	attack_verb_continuous = list("whips", "lashes", "tears")
	attack_verb_simple = list("whip", "lash", "tear")
	hitsound = 'sound/weapons/whip.ogg'

/obj/item/ego_weapon/philia
	name = "友爱"
	desc = "Everything will be okay in the end."
	special = "这把武器在命中时会小范围回复SP."
	icon_state = "philia"
	force = 8
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("smacks", "hammers", "beats")
	attack_verb_simple = list("smack", "hammer", "beat")

/obj/item/ego_weapon/philia/attack(mob/living/target, mob/living/carbon/human/user)
	var/turf/target_turf = get_turf(target)
	. = ..()
	if(!.)
		return FALSE
	if(target.status_flags & GODMODE || (target.stat == DEAD))
		return
	for(var/mob/living/L in hearers(2, target_turf))
		var/heal_amt = force*0.025
		var/justicemod = get_attack_multiplier(user)
		heal_amt *= justicemod
		heal_amt *= force_multiplier
		if(!ishuman(L))
			continue
		var/mob/living/carbon/human/H = L
		H.adjustSanityLoss(-heal_amt)
		new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))


/obj/item/ego_weapon/luminosity
	name = "光辉"
	desc = "A weapon that is hard to use even in the best of circumstances."
	special = "在手中使用来开关这把武器的连击系统. \
			这把武器拥有很高攻速，最后的终结技能小范围为人类提供治疗."
	icon_state = "luminosity"
	force = 4
	modified_attack_speed = 0.4
	hitsound = 'sound/weapons/fixer/generic/club2.ogg'
	damtype = RED_DAMAGE
	attack_verb_continuous = list("smacks", "hammers", "beats")
	attack_verb_simple = list("smack", "hammer", "beat")
	var/combo = 0
	var/combo_time
	var/combo_wait = 10
	var/combo_on = TRUE

/obj/item/ego_weapon/luminosity/attack_self(mob/user)
	..()
	if(combo_on)
		to_chat(user,span_warning("你改变了握法，现在将不再使用终结技."))
		combo_on = FALSE
		return
	if(!combo_on)
		to_chat(user,span_warning("你改变了握法，现在将使用终结技."))
		combo_on =TRUE
		return

/obj/item/ego_weapon/luminosity/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time || !combo_on)	//or you can turn if off I guess
		combo = 0
	combo_time = world.time + combo_wait
	if(combo==4)
		hitsound = 'sound/weapons/ego/farmwatch.ogg'
		combo = 0
		user.changeNext_move(CLICK_CD_MELEE * 2)
		force *= 5	// Should actually keep up with normal damage.
		to_chat(user,span_warning("你失去了平衡，花点时间调整一下站姿."))
		if(!(M.status_flags & GODMODE) && M.stat != DEAD)
			var/turf/target_turf = get_turf(M)
			for(var/mob/living/L in hearers(2, target_turf))
				var/heal_amt = force*0.05
				var/justicemod = get_attack_multiplier(user)
				heal_amt *= justicemod
				heal_amt *= force_multiplier
				if(!ishuman(L))
					continue
				var/mob/living/carbon/human/H = L
				H.adjustBruteLoss(-heal_amt)
				new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))
	else
		user.changeNext_move(CLICK_CD_MELEE * 0.4)
	..()
	combo += 1
	force = initial(force)
	hitsound = initial(hitsound)
