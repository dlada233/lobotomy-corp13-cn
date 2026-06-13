// ZAYIN Armor should be kept at 10 total armor.

/*Developer's note - All LC13 armor has 50% of its red_damage armor as fire armor by default. */

/obj/item/clothing/suit/armor/ego_gear/zayin
	icon = 'icons/obj/clothing/ego_gear/abnormality/zayin.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/abnormality/zayin.dmi'

/obj/item/clothing/suit/armor/ego_gear/zayin/penitence
	name = "赎罪"
	desc = "A piece of EGO armor intended to protect its user from mental decay. This suit will be no better than rags to those who have no sense of guilt."
	icon_state = "penitence"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/tough
	name = "粗夹克"
	desc = "A leather jacket with an unusually luxurious figure. Only those who maintain a clean “hairstyle” with no impurities on their head will be deemed worthy of equipping this suit."
	icon_state = "tough"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/tough/SpecialEgoCheck(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_BALD))
		return TRUE
	to_chat(H, "<span class='notice'>只有那些致力于干净发型的人才能使用[src]!</span>")
	return FALSE

/obj/item/clothing/suit/armor/ego_gear/zayin/tough/SpecialGearRequirements()
	return "\n<span class='warning'>使用者必须拥有干净的发型.</span>"

/obj/item/clothing/suit/armor/ego_gear/zayin/soda
	name = "美味苏打"
	desc = "A suit of armor that feels like you're wearing aluminum. \
	It’s quite light for armor, so it is rather comfortable to wear."
	icon_state = "soda"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/little_alice
	name = "小爱丽丝"	//Looks like alice from Shin Megami Tensei
	desc = "Oh, they are so very beautiful."
	icon_state = "little_alice"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/wingbeat
	name = "翅振"
	desc = "Most of the employees do not know the true meaning of The Fairies’ Care."
	icon_state = "wingbeat"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/change
	name = "改变"
	desc = "Everything can be changed if you try hard enough!"
	icon_state = "change"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/doze
	name = "瞌睡"
	desc = "While this looks like a set of pajamas, it protects the user from mental damage."
	icon_state = "doze"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/nostalgia
	name = "怀旧"
	desc = "An old brown jacket. What seems to be an L corp logo is stitched into the side. This logo, strangely, is not one for the company you work at"
	icon_state = "nostalgia"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/evening
	name = "暮光"
	desc = "If you accept it, your whole world will change."
	icon_state = "evening"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 10)

/obj/item/clothing/suit/armor/ego_gear/zayin/cavernous_wailing
	name = "低泣"
	desc = "Doesn't it make you more gloomy than anything?"
	icon_state = "cavernous_wailing"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/nightshade
	name = "茄属植物"
	desc = "It could hear all the meaningless words I have said and will say in the future and perfectly understand them."
	icon_state = "nightshade"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/hugs
	name = "拥抱"
	desc = "Soft and squishy, you could hug it for days."
	icon_state = "hugs"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/letter_opener
	name = "开信刀"
	desc = "Liberty. Reason. Justice. Civility. Edification. Perfection. MAIL!"
	icon_state = "letter_opener"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/sunset
	name = "猩红蛾月食"
	desc = "A bright suit that brings you warmth."
	icon_state = "eclipse"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/oceanic
	name = "海之味"
	desc = "A suit that's old and dyed crimson, and made of thin plastic."
	icon_state = "oceanic"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/dead_dream
	name = "永眠梦境"
	desc = "We guarantee cryopreservation is as safe as can be. The future is just one dream away."
	icon_state = "dead_dream"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/cord
	name = "粗线"
	desc = "A suit that resembles a sweater.."
	icon_state = "cord"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)


