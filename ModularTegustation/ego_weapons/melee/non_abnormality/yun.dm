//Yun Office. This is all throwaway junk for the Allas workshop
/obj/item/ego_weapon/city/yun
	name = "润事务所棍棒"
	desc = "A stern baton. It's easy to see how callous the previous user must have been."
	icon_state = "yun_fixer"
	force = 9
	damtype = RED_DAMAGE

	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")

/obj/item/ego_weapon/city/yun/shortsword
	name = "润事务所短剑"
	desc = "一把质量不错的短剑，握着它让你充满纯真新人的雄心壮志."
	icon_state = "yun_sword"
	force = 9
	attack_speed = 0.7
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'
	swingstyle = WEAPONSWING_LARGESWEEP

/obj/item/ego_weapon/city/yun/chainsaw
	name = "润事务所链锯"
	desc = "一把重型链锯，你需要一个增强装置才能用一只手使用它，它看起来很昂贵。"
	icon_state = "yun_chainsword"
	force = 11
	attack_verb_continuous = list("slices", "saws", "rips")
	attack_verb_simple = list("slice", "saw", "rip")
	hitsound = 'sound/abnormalities/helper/attack.ogg'

//Grade 6, still junk
/obj/item/ego_weapon/city/yun/fist
	name = "润事务所手套"
	desc = "润事务所负责人使用的手套."
	icon_state = "yun_fist"
	force = 16
	attack_verb_continuous = list("punches", "jabs", "slaps")
	attack_verb_simple = list("punches", "jabs", "slaps")
	hitsound = 'sound/weapons/punch1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/city/yun/fist/melee_attack_chain(mob/user, atom/target, params)
	..()
	hitsound = "sound/weapons/punch[pick(1,2,3,4)].ogg"

