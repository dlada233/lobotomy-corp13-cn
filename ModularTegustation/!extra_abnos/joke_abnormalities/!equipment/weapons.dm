//All ZAYIN joke E.G.O

// All TETH joke E.G.O
/obj/item/ego_weapon/an_ego
	name = "ego"
	desc = "一种可用于攻击的武器，遗憾的是，由于你未安装《反恐精英：起源》，该武器缺少纹理."
	special = "手中使用该武器能使用能力."
	icon_state = "an_ego"
	icon = 'ModularTegustation/Teguicons/joke_abnos/joke_weapons.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/joke_abnos/joke_lefthand.dmi'
	righthand_file = 'ModularTegustation/Teguicons/joke_abnos/joke_righthand.dmi'
	force = 10
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("攻击", "攻击", "攻击")
	attack_verb_simple = list("攻击", "攻击", "攻击")
	var/random_sound_list = list( // Random goofy sounds
		'sound/effects/yem.ogg',
		'sound/effects/wow.ogg',
		'sound/effects/gong.ogg',
		'sound/effects/adminhelp.ogg',
		'sound/effects/meow1.ogg',
		'sound/effects/meltdownAlert.ogg',
		'sound/effects/pray.ogg',
		'sound/effects/sanity_lost.ogg',
		'sound/effects/tremorburst.ogg',
	)

/obj/item/ego_weapon/an_ego/attack_self(mob/user)
	if(do_after(user, 12, src))
		playsound(get_turf(user), "[pick(random_sound_list)]", 50, TRUE)

// All HE joke E.G.O

// All WAW joke E.G.O
/obj/item/ego_weapon/pro_skub
	name = "pro-skub"
	desc = "A battle-sign powered by ferverent love for one's skub."
	icon = 'ModularTegustation/Teguicons/joke_abnos/joke_weapons.dmi'
	icon_state = "pro_skub"
	force = 25
	reach = 2
	stuntime = 3
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = "swing_hit"
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)

// All ALEPH joke E.G.O
//The Chaos Dunk
/obj/item/ego_weapon/chaosdunk
	name = "混沌灌篮"
	desc = "十亿个篮球在银河系中同时滚动. \
	一万亿个篮球在宇宙中被狠狠地砸进篮筐. \
	我能感受到每一个存在的篮球，它们的全部知识正通过我的血管流淌. \
	每一次跳投、篮板、三分球、上篮、扣篮和罚球，我都在场. 我即是篮球. \
	虽然我已经重新打造了终极篮球，但我仍有一件事必须完成。还有一个篮球，它在呼唤着主人. \
	不，不是主人，而是伙伴. 我必须找到这个篮球，把它从它所惧怕的深不可测的遗忘中拯救出来."
	special = "这把武器在投掷时会造成惊人的伤害."
	icon_state = "basketball"
	inhand_icon_state = "basketball"
	icon = 'icons/obj/items_and_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	force = 10 // It attacks very fast but is rather weak
	attack_speed = 0.5
	throwforce = 60
	throw_speed = 1
	throw_range = 10
	damtype = RED_DAMAGE
	hitsound = 'sound/weapons/fixer/generic/gen1.ogg'
	var/activated = FALSE
	var/list/random_colors = list(
		"red" = "#FF0000",
		"blue" = "#00FF00",
		"green" = "#0000FF",
		"yellow" = "#FFFF00",
		"cyan" = "#00FFFF",
		"purple" = "#FF00FF"
	)
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 100,
		PRUDENCE_ATTRIBUTE = 80,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 100,
	)

/obj/item/ego_weapon/chaosdunk/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	addtimer(CALLBACK(src, PROC_REF(ChangeColors)), 5) //Call ourselves every 0.5 seconds to change color
	set_light(4, 3, "#FFFF00") //Range of 4, brightness of 3 - Same range as a flashlight
	filters += filter(type="drop_shadow", x=0, y=0, size=5, offset=2, color=rgb(158, 4, 163))
	filters += filter(type="drop_shadow", x=0, y=0, size=5, offset=2, color=rgb(27, 255, 6))

/obj/item/ego_weapon/chaosdunk/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(activated)
		return
	if(!CanUseEgo(user))
		to_chat(user, span_warning("[src]一直沉睡在你手中..."))
		return
	activated = TRUE

/obj/item/ego_weapon/chaosdunk/proc/ChangeColors()
	set waitfor = FALSE
	animate(src, color = pick(random_colors), time=5)
	var/f1 = filters[filters.len]
	animate(f1,offset = rand(1,5),size = rand(1,20),alpha=200,time=5)
	sleep(5)
	update_icon()
	ChangeColors()

/obj/item/ego_weapon/chaosdunk/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	if(!activated)
		return
	if((ishuman(hit_atom)))
		var/mob/living/carbon/M = hit_atom
		M.deal_damage(10, STAMINA, source = throwingdatum.thrower, attack_type = (ATTACK_TYPE_RANGED))
		if(prob(75))
			M.Paralyze(60)
			visible_message(span_danger("[M] 几乎只能勉强压制住[src]的力量！"))
			return
	else
		new /obj/effect/temp_visual/explosion(get_turf(src))
		visible_message(span_danger("[src]剧烈的爆炸!"))
		playsound(src, 'sound/abnormalities/crying_children/sorrow_shot.ogg', 45, FALSE, 5)
		for(var/mob/living/L in view(1, src))
			var/aoe = 50
			L.deal_damage(aoe, RED_DAMAGE, throwingdatum.thrower, attack_type = (ATTACK_TYPE_RANGED))
			new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))
	activated = FALSE

// Curse of Violet Noon be upon thee
/obj/item/ego_weapon/violet_curse //Ignore the name dream maker doesn't handle the font well.
	name = "ᓵ⚍∷ᓭᒷ 𝙹⎓ ⍊╎𝙹ꖎᒷℸ ̣  リ𝙹𝙹リ"
	desc = "We tried to understand what would refuse to listen. \
	We reached for a shred of comprehension that they could give. \
	We stared into the dark unending abyss wishing for love and compassion. \
	In the end we recived nothing but madness, there was no hope for understanding."
	special = "这把武器在蓄力充能完成时能进行无差别的高额红色伤害传送攻击. \
	在杀死敌人时能造成GIB."
	icon = 'ModularTegustation/Teguicons/joke_abnos/joke_weapons.dmi'
	icon_state = "violet_curse"
	lefthand_file = 'icons/mob/inhands/96x96_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/96x96_righthand.dmi'
	inhand_x_dimension = 96
	inhand_y_dimension = 96
	force = 68
	attack_speed = 1.8
	damtype = BLACK_DAMAGE
	hitsound = 'sound/abnormalities/apocalypse/slam.ogg'
	attack_verb_continuous = list("crushes", "devastates")
	attack_verb_simple = list("crush", "devastate")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)

	charge = TRUE
	charge_cost = 10
	charge_cap = 10
	charge_effect = "能进行无差别的高额红色伤害传送攻击."
	successfull_activation = "你感到紫罗兰正午的力量正在你体内流淌."

	var/dash_range = 8
	var/aoe_damage = 150

/obj/item/ego_weapon/violet_curse/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/ego_weapon/violet_curse/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return

	. = ..()

	if(charge >= charge_cost)
		icon_state = "violet_curse_c"
		inhand_icon_state = "violet_curse_c"
		update_icon_state()

	if(target.stat == DEAD && !(target.status_flags & GODMODE))
		target.gib()

/obj/item/ego_weapon/violet_curse/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(!currently_charging)
		return
	if(!isliving(A))
		return
	if((get_dist(user, A) < 2) || (!(can_see(user, A, dash_range))))
		return
	..()
	if(do_after(user, 5, src))
		var/turf/target = get_turf(A)
		currently_charging = FALSE
		playsound(src, 'sound/effects/ordeals/violet/midnight_portal_off.ogg', 50, FALSE, -1)
		animate(user, alpha = 1,pixel_x = 0, pixel_z = 16, time = 0.1 SECONDS)
		user.pixel_z = 16
		ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
		user.forceMove(target)
		user.Stun(2 SECONDS, ignore_canstun = TRUE) //No Moving midair
		var/obj/effect/temp_visual/warning3x3/W = new(target)
		W.color = "#8700ff"
		sleep(2 SECONDS)
		REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
		JumpAttack(target,user)
		animate(user, alpha = 255,pixel_x = 0, pixel_z = -16, time = 0.1 SECONDS)
		user.pixel_z = 0
		icon_state = "violet_curse"
		inhand_icon_state = "violet_curse"
		update_icon_state()

/obj/item/ego_weapon/violet_curse/proc/JumpAttack(target, mob/living/user, proximity_flag, params)
	playsound(src, 'sound/effects/ordeals/violet/monolith_down.ogg', 65, 1)
	var/obj/effect/temp_visual/v_noon/V = new(target)
	animate(V, alpha = 0, transform = matrix()*2, time = 10)
	for(var/turf/open/T in view(2, target))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
	for(var/mob/living/L in range(2, target))
		if(L.z != user.z)
			continue
		var/justicemod = get_attack_multiplier(user)
		aoe_damage *= justicemod
		aoe_damage *= force_multiplier
		if(L == user) //This WILL friendly fire there is no escape
			continue
		L.deal_damage(aoe_damage, RED_DAMAGE, user, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
		to_chat(L, span_userdanger("你被一座巨石压得喘不过气!"))
		if(L.health < 0)
			L.gib()
		aoe_damage = initial(aoe_damage)

//Buff Rudolta
/obj/item/ego_weapon/ultimate_christmas
	name = "终极圣诞"
	desc = "圣诞老人的袋子非常沉重，足以装下送给全世界每个人的礼物。这个也不例外."
	icon_state = "ultimate_christmas"
	icon = 'ModularTegustation/Teguicons/joke_abnos/joke_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 48
	attack_speed = 1.6
	damtype = RED_DAMAGE
	knockback = KNOCKBACK_HEAVY
	attack_verb_continuous = list("击打", "叩打")
	attack_verb_simple = list("击打", "叩打")
	hitsound = 'sound/abnormalities/rudolta_buff/onrush1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
	)

//The wild ride
/obj/item/ego_weapon/lance/wild_ride
	name = "狂野之旅"
	desc = "我想离开狂野之旅!"
	icon_state = "tattered_kingdom" //temporary until someone decides to sprite it
	lefthand_file = 'icons/mob/inhands/96x96_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/96x96_righthand.dmi'
	inhand_x_dimension = 96
	inhand_y_dimension = 96
	force = 20
	reach = 2		//Has 2 Square Reach.
	attack_speed = 2.0 // really slow
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("穿透", "歪斜")
	attack_verb_simple = list("穿透", "歪斜")
	hitsound = 'sound/weapons/fixer/generic/spear2.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 120
							)
	charge_speed_cap = 8 //Charges significantly faster, but teleports back upon hitting something
	force_per_tile = 4
	pierce_force_cost = 15
	var/turf/saved_location = null

/obj/item/ego_weapon/lance/wild_ride/LowerLance(mob/user)
	. = ..()
	saved_location = get_turf(src)

/obj/item/ego_weapon/lance/wild_ride/RaiseLance(mob/user)
	. = ..()
	saved_location = null

/obj/item/ego_weapon/lance/wild_ride/UserBump(mob/living/carbon/human/user, atom/A)
	. = ..()
	LanceInteraction(user)

/obj/item/ego_weapon/lance/wild_ride/proc/LanceInteraction(mob/living/carbon/human/user)
	if(saved_location)
		user.forceMove(saved_location)

/obj/item/ego_weapon/lance/wild_ride/get_clamped_volume()
	return 40
