// WAW Armor should be kept at ~140 total armor.

/*Developer's note - All LC13 armor has 50% of its red_damage armor as fire armor by default. */

/obj/item/clothing/suit/armor/ego_gear/waw
	icon = 'icons/obj/clothing/ego_gear/abnormality/waw.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/abnormality/waw.dmi'

/obj/item/clothing/suit/armor/ego_gear/waw/hornet
	name = "大黄蜂护甲"
	desc = "A dark coat with yellow details. You feel as if you can hear faint buzzing coming out of it."
	icon_state = "hornet"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 30, BLACK_DAMAGE = 40, PALE_DAMAGE = 20) // 140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/lamp
	name = "目灯"
	desc = "A dark coat with thousands of eyes on it. They are looking at you as you move."
	icon_state = "lamp"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 30, BLACK_DAMAGE = 60, PALE_DAMAGE = 30) // 140
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/waw/correctional
	name = "矫正护甲"
	desc = "A white, lightly bloodstained coat. it goes all the way down to your ankles."
	icon_state = "correctional"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 0, BLACK_DAMAGE = 60, PALE_DAMAGE = 30) // 140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60)

/obj/item/clothing/suit/armor/ego_gear/waw/despair
	name = "盈泪之甲"
	desc = "Tears fall like ash, embroidered as if they were constellations."
	icon_state = "despair"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 40, BLACK_DAMAGE = 20, PALE_DAMAGE = 60) // 140
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/despair/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/nihil/spade))
		return
	new /obj/item/clothing/suit/armor/ego_gear/despair_nihil(get_turf(src))
	to_chat(user,"<span class='warning'>The [I] seems to drain all of the light away as it is absorbed into [src]!</span>")
	playsound(user, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)
	qdel(I)
	qdel(src)

/obj/item/clothing/suit/armor/ego_gear/waw/hatred
	name = "以爱与恨之名"
	desc = "A magical one-piece dress imbued with the love and justice of a magical girl. \
	Wearing it may ignite your spirit of justice and the desire to protect the world. \
	Then you'll hear the sound of hatred, sinking deeper than love."
	icon_state = "hatred"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 20, BLACK_DAMAGE = 60, PALE_DAMAGE = 30) // 140
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/waw/hatred/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/nihil/heart))
		return
	new /obj/item/clothing/suit/armor/ego_gear/hatred_nihil(get_turf(src))
	to_chat(user,"<span class='warning'>The [I] seems to drain all of the light away as it is absorbed into [src]!</span>")
	playsound(user, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)
	qdel(I)
	qdel(src)

/obj/item/clothing/suit/armor/ego_gear/waw/oppression
	name = "压迫者"
	desc = "And I shall hold you here, forever."
	icon_state = "oppression"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 20, BLACK_DAMAGE = 40, PALE_DAMAGE = 30) //140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/waw/totalitarianism
	name = "极权主义"
	desc = "Or are you trapped here by me?"
	icon_state = "totalitarianism"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 20, BLACK_DAMAGE = 50, PALE_DAMAGE = 30) // 140
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/waw/goldrush
	name = "闪金冲锋"
	desc = "Bare armor. lightweight and ready for combat."
	icon_state = "gold_rush"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 40, BLACK_DAMAGE = 30, PALE_DAMAGE = 0) // 140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							)

/obj/item/clothing/suit/armor/ego_gear/waw/goldrush/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/nihil/diamond))
		return
	new /obj/item/clothing/suit/armor/ego_gear/goldrush_nihil(get_turf(src))
	to_chat(user,"<span class='warning'>[I]似乎把所有的光都吸收进了[src]里!</span>")
	playsound(user, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)
	qdel(I)
	qdel(src)

/obj/item/clothing/suit/armor/ego_gear/waw/tiara
	name = "三重冕"
	desc = "Who will look after you when I am gone?"
	icon_state = "tiara"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 50, BLACK_DAMAGE = 30, PALE_DAMAGE = 50)
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/waw/cobalt
	name = "郁蓝创痕"
	desc = "The armor is torn up with countless traces that recount the history of the unending battle."
	icon_state = "cobalt_scar"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 30, BLACK_DAMAGE = 40, PALE_DAMAGE = 10)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/crimson
	name = "猩红创痕"
	desc = "It seems only darkness awaits those who find the value of their lives in nothing but destruction."
	icon_state = "crimson_scar"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 40, BLACK_DAMAGE = 30, PALE_DAMAGE = 10)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/spore
	name = "荧光菌孢"
	desc = "When stars light the night sky, its true form will be revealed."
	icon_state = "spore"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 60, BLACK_DAMAGE = 30, PALE_DAMAGE = 40)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/waw/stem
	name = "绿色枝干"
	desc = "Letting go of the obsession may ease the suffering a little."
	icon_state = "green_stem"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 10, BLACK_DAMAGE = 70, PALE_DAMAGE = 20)
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60)

/obj/item/clothing/suit/armor/ego_gear/waw/loyalty
	name = "忠诚"
	desc = "And god have mercy on anyone who hurt her queen."
	icon_state = "loyalty"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 30, BLACK_DAMAGE = 30, PALE_DAMAGE = 20)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80)

/obj/item/clothing/suit/armor/ego_gear/waw/executive
	name = "坚决执行"
	desc = "A VERY expensive suit. Just by looking at it, you can tell it's the cream of the crop. And so are you."
	icon_state = "executive"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 20) // 140
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/ecstasy
	name = "沉醉"
	desc = "The colorful pattern is fancy, quite akin to a child's costume."
	icon_state = "ecstasy"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 70, BLACK_DAMAGE = 10, PALE_DAMAGE = 20)
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80)

/obj/item/clothing/suit/armor/ego_gear/waw/intentions
	name = "善意"
	desc = "All aboard!"
	icon_state = "intentions"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 10, BLACK_DAMAGE = 60, PALE_DAMAGE = 30)
	attribute_requirements = list(FORTITUDE_ATTRIBUTE = 80)

/obj/item/clothing/suit/armor/ego_gear/waw/aroma
	name = "暗香"
	desc = "The ceramic surface is tough as if it had been glazed several times. \
			It may crumble back into primal clay if it is exposed to a powerful mental attack."
	icon_state = "aroma"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 70, BLACK_DAMAGE = 40, PALE_DAMAGE = 30) // 140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/waw/thirteen
	name = "丧钟无声"
	desc = "No one can go against the flow of time."
	icon_state = "thirteen"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 10, BLACK_DAMAGE = 50, PALE_DAMAGE = 70) // 140
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/assonance
	name = "相合"
	desc = "What is good if there is no evil?"
	icon_state = "assonance"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 60, BLACK_DAMAGE = 20, PALE_DAMAGE = 30) // 140
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/exuviae
	name = "脱落之皮"
	desc = "Its scales are multi layered, suitable for protection against external threats."
	icon_state = "exuviae"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 40, BLACK_DAMAGE = 20, PALE_DAMAGE = 20) // 140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/ebony_stem
	name = "黑色枝干"
	desc = "Someone must endure the pain to spare the rest of suffering."
	icon_state = "ebony_stem"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 10, BLACK_DAMAGE = 70, PALE_DAMAGE = 50) // 140
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/waw/feather
	name = "荣誉之羽"
	desc = "Bright as the abnormality it was extracted from, but somehow does not give off any heat. \
			Maybe keep it away from the cold..."
	icon_state = "featherofhonor"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 50, BLACK_DAMAGE = 30, PALE_DAMAGE = 10, FIRE = 60) //140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							)

/obj/item/clothing/suit/armor/ego_gear/waw/warring
	name = "英勇之羽"
	desc = "Wearing this undyed leather poncho fills you with contempt. \
	Only war will stop their barbaric sacrilege."
	icon_state = "warring"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 50, BLACK_DAMAGE = 40, PALE_DAMAGE = 40) // 140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60)

/obj/item/clothing/suit/armor/ego_gear/waw/animalism
	name = "兽性解放"
	desc = "Nothing left behind your eyes, just animal instinct and a hollow mind - impervious to everything and everyone."
	icon_state = "animalism"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 50, BLACK_DAMAGE = 40, PALE_DAMAGE = 40) //140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							)

/obj/item/clothing/suit/armor/ego_gear/waw/darkcarnival
	name = "黑色狂欢节"
	desc = "The only bad things are those we make in our minds."
	icon_state = "dark_carnival"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 60, BLACK_DAMAGE = 10, PALE_DAMAGE = 10) // 140
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/dipsia
	name = "渴求鲜血"
	desc = "The blood, in its purest and clearest form! Bring me eternal happiness!"
	icon_state = "dipsia"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 0, BLACK_DAMAGE = 40, PALE_DAMAGE = 30) // 140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/pharaoh
	name = "法老"
	desc = "What creature walks on four legs in the morning, two legs at noon, and three in the evening?"
	icon_state = "pharaoh"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 60, BLACK_DAMAGE = 50, PALE_DAMAGE = 0) // 140
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/moonlight
	name = "月光"
	desc = "A classic, dark dress whose edge resembles an ink cap. \
			You may take a step towards the truth of the moon that was so difficult to understand if you wear it. "
	icon_state = "moonlight"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 70, BLACK_DAMAGE = 40, PALE_DAMAGE = 0) // 140
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/blind_rage
	name = "盲目的愤怒"
	desc = "There is no sorrow like the betrayal of a friend. \
			Nor is there such rage."
	icon_state = "blind_rage"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 0, BLACK_DAMAGE = 50, PALE_DAMAGE = 40) // 140
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/blind_rage/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/nihil/club))
		return
	new /obj/item/clothing/suit/armor/ego_gear/blind_rage_nihil(get_turf(src))
	to_chat(user,"<span class='warning'>[I]似乎把所有的光都吸收进了[src]里!</span>")
	playsound(user, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)
	qdel(I)
	qdel(src)

/obj/item/clothing/suit/armor/ego_gear/waw/heart
	name = "怜悯之心"
	desc = "And the prayer shall inevitably end with the eternal despair of its worshiper."
	icon_state = "heart"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 10, BLACK_DAMAGE = 10, PALE_DAMAGE = 50) // 140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80)

/obj/item/clothing/suit/armor/ego_gear/waw/diffraction
	name = "虚无衍射体"
	desc = "You can ignore the ridiculous advice that you can see it with your mind."
	icon_state = "diffraction"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 30, BLACK_DAMAGE = 30, PALE_DAMAGE = 30) // 140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80)

/obj/item/clothing/suit/armor/ego_gear/waw/infinity
	name = "永恒期限"
	desc = "You know it to be true."
	icon_state = "infinity"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 30, BLACK_DAMAGE = 30, PALE_DAMAGE = 50) // 140
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80)

/obj/item/clothing/suit/armor/ego_gear/waw/amrita
	name = "无量"
	desc = "You can smell old dirt and fire if you put your nose close enough."
	icon_state = "amrita"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 0, BLACK_DAMAGE = 50, PALE_DAMAGE = 30) // 140
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/discord
	name = "不和"
	desc = "What is evil if there is no good?"
	icon_state = "discord"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 40, BLACK_DAMAGE = 60, PALE_DAMAGE = 20) // 140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/innocence
	name = "童年回忆"
	desc = "In my dreams as child, Peter Pan would reach out a hand for me to hold and take me to Neverland. I had forgotten all of that, until I went into that room."
	icon_state = "innocence"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 70, BLACK_DAMAGE = 40, PALE_DAMAGE = 30) //140
	attribute_requirements = list(
					PRUDENCE_ATTRIBUTE = 80
					)

/obj/item/clothing/suit/armor/ego_gear/waw/rimeshank
	name = "冰结之爪"
	desc = "Well, I can't just shiver in the cold forever, can I?"
	icon_state = "rimeshank"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 40, BLACK_DAMAGE = 0, PALE_DAMAGE = 30, FIRE = 20) //140
	attribute_requirements = list(
					FORTITUDE_ATTRIBUTE = 80
					)

/obj/item/clothing/suit/armor/ego_gear/waw/hypocrisy
	name = "伪善"
	desc = "All things natural are bound to turn to dust someday. Thus, this evergreen robe must be kept far apart from mother nature."
	icon_state = "hypocrisy"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 40, BLACK_DAMAGE = 0, PALE_DAMAGE = 30) // 140
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/my_own_bride
	name = "我的新娘"
	desc = "May your life work, Come back for you."
	icon_state = "wife"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 60, BLACK_DAMAGE = 30, PALE_DAMAGE = 20) // 140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60)

/obj/item/clothing/suit/armor/ego_gear/waw/swan
	name = "黑天鹅"
	desc = "Whenever she felt exhausted from the agony and struggle, she looked at her brooch, a memento of the past, to stifle her feelings."
	icon_state = "swan"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 20, BLACK_DAMAGE = 50, PALE_DAMAGE = 10) // 140
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80)

/obj/item/clothing/suit/armor/ego_gear/waw/psychic
	name = "心灵匕首"
	desc = "But a mermaid has no tears, and therefore she suffers so much more."
	icon_state = "psychic"
	armor = list(RED_DAMAGE = -30, WHITE_DAMAGE = 70, BLACK_DAMAGE = 40, PALE_DAMAGE = 60) // 140
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80)

/obj/item/clothing/suit/armor/ego_gear/waw/scene
	name = "一如剧本所写"
	desc = "Title: Peccatum Proprium. Today, we perform for the king. Characters : A, The failed, The Abandoned, The Broken, The Coward, and......."
	icon_state = "scenario"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 50, BLACK_DAMAGE = 50, PALE_DAMAGE = 10) // 140
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80)

/obj/item/clothing/suit/armor/ego_gear/waw/rosa
	name = "荆棘花园"
	desc = "Our only wish is that our garden will bloom full of flowers."
	icon_state = "rosa"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 50, BLACK_DAMAGE = 30, PALE_DAMAGE = 30) // 140
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/waw/blind_obsession
	name = "盲目"
	desc = "Allow me to describe this grand and epic beast!"
	icon_state = "blind_obsession"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = -10, BLACK_DAMAGE = 50, PALE_DAMAGE = 40)//140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60)

/obj/item/clothing/suit/armor/ego_gear/waw/holiday
	name = "假期"
	desc = "A snazzy outfit for bringing Christmas cheer to all the boys and girls."
	icon = 'ModularTegustation/Teguicons/joke_abnos/joke_armor.dmi'
	worn_icon = 'ModularTegustation/Teguicons/joke_abnos/joke_worn.dmi'
	icon_state = "ultimate_christmas"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 50, BLACK_DAMAGE = 10, PALE_DAMAGE = 20) // 140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/sunyata
	name = "空即是色"
	desc = "Karma shall find its way back to you, and rest atop your head."
	icon_state = "sunyata"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 50, BLACK_DAMAGE = -10, PALE_DAMAGE = 50)//140
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/waw/effervescent
	name = "沸腾腐蚀"
	desc = "Coalesce all your flaws and fears into something stronger."
	icon_state = "shell"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 60, BLACK_DAMAGE = 20, PALE_DAMAGE = 10) // 140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							)

/obj/item/clothing/suit/armor/ego_gear/waw/havana
	name = "哈瓦那"
	desc = "Sit down, relax and take a deep breath."
	icon_state = "havana"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 20, BLACK_DAMAGE = 30, PALE_DAMAGE = 60) // 140
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/heaven
	name = "天堂"
	desc = "That's what a gaze is. Attention. An invisible string that connects us."
	icon_state = "heaven"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 60, BLACK_DAMAGE = 60, PALE_DAMAGE = 10) // 140. LobCorp original stats: 1.2, 0.8, 0.6, 1.2.
	attribute_requirements = list(FORTITUDE_ATTRIBUTE = 80) //Requires Fortitude Level 3 in LobCorp.

/obj/item/clothing/suit/armor/ego_gear/waw/ardor_star
	name = "红焰新星"
	desc = "A brown jacket with fiery frills at the ends. Warm to the touch."
	icon_state = "ardor_blossom"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 20, BLACK_DAMAGE = 30, PALE_DAMAGE = 30, FIRE = 60) // 140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							)
