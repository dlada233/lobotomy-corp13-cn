//Base index is Grade 5,
//Proxy is Grade 3,
//Messenger is Grade 2.
/obj/item/ego_weapon/city/index
	name = "食指 新兵剑"
	desc = "苦行者使用的新兵剑."
	icon_state = "index"
	inhand_icon_state = "index"
	force = 18
	damtype = PALE_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP

	attack_verb_continuous = list("smacks", "hammers", "beats")
	attack_verb_simple = list("smack", "hammer", "beat")
	var/prescript_target
	var/weapon_owner
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 80,
	)

/obj/item/ego_weapon/city/index/attack_self(mob/user)
	..()
	if(force != initial(force))
		to_chat(user, span_notice("指令状态仍然有效."))
		return

	//Okay, check if you have a prescript
	if(prescript_target && user == weapon_owner)
		var/mob/living/simple_animal/hostile/abnormality/Y = prescript_target
		if(Y.stat == DEAD)
			prescript_target = null
			to_chat(user, span_notice("你的指令已经过期. 在手中使用以接收新的指令."))
		else
			to_chat(user, span_notice("你的指令目标是 [prescript_target]."))

	//If you don't have one, pick a breached mob if available.
	else if(!prescript_target && user == weapon_owner)
		var/list/breached = list()
		for(var/mob/living/simple_animal/hostile/abnormality/B in GLOB.abnormality_mob_list)
			if(!(B.status_flags & GODMODE) && (B.stat != DEAD))
				breached+=B
		if(LAZYLEN(breached))
			prescript_target = pick(breached)
			to_chat(user, span_userdanger("你的指令目标是 [prescript_target]. 杀死他们，并用这把武器给予致命一击."))
		else
			to_chat(user, span_notice("没有可用的指令."))

	//If this weapon has no owner, than make you it.
	else if(!weapon_owner)
		to_chat(user, span_notice("这把武器现在属于你了，在手中使用来接收新的指令."))
		weapon_owner = user

	else
		to_chat(user, span_warning("这不是你的武器!"))


/obj/item/ego_weapon/city/index/attack(mob/living/target, mob/living/user)
	var/living = FALSE
	if(target.stat != DEAD)
		living = TRUE
	if(!..())
		return

	if(target.stat == DEAD && target == prescript_target && living)
		prescript_complete(user)

//Make this do something
/obj/item/ego_weapon/city/index/proc/prescript_complete(mob/living/user)
	prescript_target = null
	to_chat(user, span_userdanger("你已经完成了你的指令，你获得了恩赐。"))
	force *= 1.45	//BEEG BONUS
	addtimer(CALLBACK(src, PROC_REF(Return), user), 5 MINUTES)

/obj/item/ego_weapon/city/index/proc/Return(mob/living/carbon/human/user)
	force /= 1.45	//BEEG BONUS
	to_chat(user, span_notice("来自指令之中的力量现已消失."))


//Just gonna set this to the big proxy weapon for requirement reasons
/obj/item/ego_weapon/city/index/proxy
	name = "食指 长剑"
	desc = "代行者所使用的长剑."
	icon_state = "indexlongsword"
	inhand_icon_state = "indexlongsword"
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'
	force = 28
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)

//Just gonna set this to the big proxy weapon for requirement reasons
/obj/item/ego_weapon/city/index/proxy/spear
	name = "食指 长矛"
	desc = "代行者所使用的长矛."
	icon_state = "indexspear"
	inhand_icon_state = "indexspear"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left_64x64.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right_64x64.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	hitsound = 'sound/weapons/fixer/generic/nail1.ogg'
	reach = 2
	force = 32
	stuntime = 5
	swingstyle = WEAPONSWING_THRUST

//Fockin massive sword
/obj/item/ego_weapon/city/index/yan
	name = "食指 大剑"
	desc = "传令员所使用的大型剑."
	icon_state = "indexgreatsword"
	inhand_icon_state = "indexgreatsword"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left_64x64.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right_64x64.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleaves", "cuts")
	hitsound = 'sound/weapons/fixer/generic/finisher1.ogg'
	force = 65
	attack_speed = 2
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 120
							)
