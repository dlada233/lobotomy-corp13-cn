//Streetlight stuff, this is all Grade 7 teth stuff, leader is grade 6.
//They're generic weapons for the refinery, which is fine
/obj/item/ego_weapon/city/streetlight_greatsword
	name = "街灯事务所大剑"
	desc = "一把由身材高大的收尾人所使用的大剑.'早知道会这样...我应该，告诉...她...'"
	icon_state = "streetlight_greatsword"
	force = 18
	attack_speed = 2
	swingstyle = WEAPONSWING_LARGESWEEP
	damtype = RED_DAMAGE

	inhand_icon_state = "claymore"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")

/obj/item/ego_weapon/city/streetlight_bat
	name = "街灯事务所棍棒"
	desc = "黄黑条纹配色的棍棒, 虽是金属材质但是触感温暖，这是因为朋友之间的温情，还是那些失去一切之人的仇恨？"
	icon_state = "streetlight_bat"
	force = 15
	attack_speed = 1.5
	damtype = RED_DAMAGE

	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")

/obj/item/ego_weapon/city/streetlight_bat/attack(mob/living/target, mob/living/user)
	if(!..())
		return
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

//He has zwei moves in his 2nd iteration, give it to him here.
/obj/item/ego_weapon/city/zweihander/streetlight_baton
	name = "街灯事务所手杖"
	desc = "一把与双剑技巧兼容的手杖，它承载着一种悔恨的感觉..."
	icon_state = "streetlight_founder"
	inhand_icon_state = "streetlight_founder"
	force = 16
	damtype = BLACK_DAMAGE
	swingstyle = WEAPONSWING_SMALLSWEEP

	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	defense_buff_self = 0.6
	defense_buff_others = 0.9
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)
