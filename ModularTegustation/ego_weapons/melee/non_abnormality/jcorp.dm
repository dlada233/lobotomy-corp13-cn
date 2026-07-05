//Ting-Tang, weapons are quite gimmicky, and leaves up to chance. Thus does a bit more damage than their tier allows.
//All weapons, but leader are grade 7, they are all quite the jobber anyways.
/obj/item/ego_weapon/city/ting_tang
	name = "叮当帮刺刀"
	desc = "扭曲的金属片，造成的伤口难以愈合。"
	special = "造成50%至100%最大伤害的随机伤害，如有未治疗的精神损伤将根据严重程度使最小伤害降至最低10%。"
	icon_state = "tingtang_shank"
	inhand_icon_state = "tingtang_shank"
	force = 13
	attack_speed = 1
	damtype = WHITE_DAMAGE //Almost everyone and their mother in this god forsaken district does something with sanity.

	attack_verb_continuous = list("slices", "gashes", "stabs")
	attack_verb_simple = list("slice", "gash", "stab")
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'
	var/sp_mod

/obj/item/ego_weapon/city/ting_tang/attack(mob/living/target, mob/living/user) //mostly stolen from dice code
	sp_mod = user.sanityhealth / user.maxSanity * 0.5 //hits .5 at max sanity.
	sp_mod = max(0.10, sp_mod)
	force = rand(force*sp_mod, force)
	..()
	force = initial(force)

/obj/item/ego_weapon/city/ting_tang/cleaver
	name = "叮当帮砍刀"
	desc = "相当沉重，显然是为全力挥砍设计的。"
	icon_state = "tingtang_cleaver"
	inhand_icon_state = "tingtang_cleaver"
	force = 20
	attack_speed = 1.5
	hitsound = 'sound/weapons/fixer/generic/blade5.ogg'

/obj/item/ego_weapon/city/ting_tang/pipe
	name = "叮当帮管棍"
	desc = "沉重的金属管，你确信它曾属于某辆汽车。"
	icon_state = "tingtang_pipe"
	inhand_icon_state = "tingtang_pipe"
	force = 27
	attack_speed = 2
	attack_verb_continuous = list("smacks", "bludgeons", "beats")
	attack_verb_simple = list("smack", "bludgeon", "beat")
	hitsound = 'sound/weapons/fixer/generic/baton1.ogg'

/obj/item/ego_weapon/city/ting_tang/knife //Leader, Grade 6
	name = "叮当帮匕首"
	desc = "末端的指钩让你能玩些花式技巧——假如你有那技术的话。"
	icon_state = "tingtang_knife"
	inhand_icon_state = "tingtang_knife"
	force = 18
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_speed = 1
	hitsound = 'sound/weapons/fixer/generic/knife1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)

//Los Mariachis - Grade 7 with poise crits, white version of Kurokumo.
/obj/item/ego_weapon/city/mariachi
	name = "沙槌"
	desc = "马利亚奇乐队使用的单只沙槌。"
	special = "每次攻击获得1点架势。每点架势提供2%的暴击率（3倍伤害），效果线性叠加。暴击后架势归零。"
	icon_state = "maracas"
	inhand_icon_state = "maracas"
	force = 11
	damtype = WHITE_DAMAGE

	attack_verb_continuous = list("bashes", "clubs")
	attack_verb_simple = list("bashes", "clubs")
	hitsound = 'sound/weapons/fixer/generic/maracas1.ogg'
	var/poise = 0

/obj/item/ego_weapon/city/mariachi/examine(mob/user)
	. = ..()
	. += "当前架势: [poise]/20."

/obj/item/ego_weapon/city/mariachi/attack(mob/living/target, mob/living/carbon/human/user)
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

/obj/item/ego_weapon/city/mariachi/attack_self(mob/user)
	var/obj/item/clothing/suit/armor/ego_gear/city/mariachi/aida/Y = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Y))
		to_chat(user,span_notice("你摇动沙槌，演奏出美妙旋律。"))
		playsound(src, 'sound/weapons/fixer/generic/maracas_shake.ogg', 50, TRUE)
	else
		to_chat(user,span_warning("像你这般无趣之人？不配摇动这沙槌。"))

//Sp healing for jobbers
/obj/item/ego_weapon/city/mariachi_blades
	name = "双砍刀"
	desc = "马利亚奇乐队使用的砍刀对。"
	special = "击杀时恢复15点精神值。"
	icon_state = "mariachi_blades"
	inhand_icon_state = "mariachi_blades"
	force = 11
	damtype = WHITE_DAMAGE

	attack_verb_continuous = list("slashes", "slices")
	attack_verb_simple = list("slash", "slice")
	hitsound = 'sound/weapons/fixer/generic/blade1.ogg'

/obj/item/ego_weapon/city/mariachi_blades/attack(mob/living/target, mob/living/carbon/human/user)
	var/living = FALSE
	if(!CanUseEgo(user))
		return
	if(target.stat != DEAD)
		living = TRUE
	..()
	if(target.stat == DEAD && living)
		user.adjustSanityLoss(-15)
		living = FALSE

//Leader, Grade 6 (She's pretty weak)
/obj/item/ego_weapon/city/mariachi/dual
	name = "对击沙槌"
	desc = "马利亚奇乐队首领使用的沙槌对。"
	icon_state = "dualmaracas"
	inhand_icon_state = "dualmaracas"
	force = 9		//Double the maracas twice the attack speed.
	attack_speed = 0.5
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)

//Pre-nerf Aida, the real prize of J-corp. Grade 5
/obj/item/ego_weapon/city/mariachi/dual/boss
	name = "发光沙槌"
	desc = "马利亚奇乐队首领使用的发光沙槌，唯亡者得见。"
	icon_state = "dualmaracas_boss"
	inhand_icon_state = "dualmaracas_boss"
	force = 12
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
