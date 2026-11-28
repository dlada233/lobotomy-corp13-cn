/* Backpacks
 * Contains:
 *		Backpack
 *		Backpack Types
 *		Satchel Types
 */

/*
 * Backpack
 */

/obj/item/storage/backpack
	name = "背包"
	desc = "背在身上，用来装东西。"
	icon_state = "backpack"
	inhand_icon_state = "backpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK	//ERROOOOO
	resistance_flags = NONE
	max_integrity = 300

/obj/item/storage/backpack/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 21
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_items = 21

/*
 * Backpack Types
 */

/obj/item/storage/backpack/old/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 12

/obj/item/bag_of_holding_inert
	name = "未激活的次元背包"
	desc = "目前只是一块笨重的金属，上面留了一个可装入蓝空间异常核心的插槽。"
	icon = 'icons/obj/storage.dmi'
	icon_state = "brokenpack"
	inhand_icon_state = "brokenpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	item_flags = NO_MAT_REDEMPTION

/obj/item/storage/backpack/holding
	name = "次元背包"
	desc = "开口通往一小片独立的蓝空间。"
	icon_state = "holdingpack"
	inhand_icon_state = "holdingpack"
	resistance_flags = FIRE_PROOF
	item_flags = NO_MAT_REDEMPTION
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 60, ACID = 50)
	component_type = /datum/component/storage/concrete/bluespace/bag_of_holding

/obj/item/storage/backpack/holding/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.allow_big_nesting = TRUE
	STR.max_w_class = WEIGHT_CLASS_GIGANTIC
	STR.max_combined_w_class = 35

/obj/item/storage/backpack/holding/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]正往[src]里跳！看起来是想自杀。"))
	user.dropItemToGround(src, TRUE)
	user.Stun(100, ignore_canstun = TRUE)
	sleep(20)
	playsound(src, "rustle", 50, TRUE, -5)
	qdel(user)

/obj/item/storage/backpack/santabag
	name = "圣诞老人的礼物袋"
	desc = "太空圣诞老人每逢圣诞就用它给太空里的乖孩子送礼物。好大的口袋！"
	icon_state = "giftbag0"
	inhand_icon_state = "giftbag"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/backpack/santabag/Initialize()
	. = ..()
	regenerate_presents()

/obj/item/storage/backpack/santabag/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 60

/obj/item/storage/backpack/santabag/suicide_act(mob/user)
	user.visible_message(span_suicide("[user]把[src]套在头上，拉紧袋口。看来今年没什么过节的心情……"))
	return (OXYLOSS)

/obj/item/storage/backpack/santabag/proc/regenerate_presents()
	addtimer(CALLBACK(src, PROC_REF(regenerate_presents)), 30 SECONDS)

	var/mob/M = get(loc, /mob)
	if(!istype(M))
		return
	if(M.mind && HAS_TRAIT(M.mind, TRAIT_CANNOT_OPEN_PRESENTS))
		var/datum/component/storage/STR = GetComponent(/datum/component/storage)
		var/turf/floor = get_turf(src)
		var/obj/item/I = new /obj/item/a_gift/anything(floor)
		if(STR.can_be_inserted(I, stop_messages=TRUE))
			STR.handle_item_insertion(I, prevent_warning=TRUE)
		else
			qdel(I)


/obj/item/storage/backpack/cultpack
	name = "战利品架"
	desc = "既能多带点装备，又能让所有人见识一下你疯到了什么地步。"
	icon_state = "cultpack"
	inhand_icon_state = "backpack"

/obj/item/storage/backpack/clown
	name = "咯咯笑伯爵"
	desc = "叭叭公司出品的背包。"
	icon_state = "clownpack"
	inhand_icon_state = "clownpack"

/obj/item/storage/backpack/explorer
	name = "探险背包"
	desc = "结实耐用，适合收存战利品。"
	icon_state = "explorerpack"
	inhand_icon_state = "explorerpack"

/obj/item/storage/backpack/mime
	name = "默索包裹"
	desc = "无声公司为沉默的工作人员制作的无声背包。"
	icon_state = "mimepack"
	inhand_icon_state = "mimepack"

/obj/item/storage/backpack/medic
	name = "医疗背包"
	desc = "专为无菌环境设计的背包。"
	icon_state = "medicalpack"
	inhand_icon_state = "medicalpack"

/obj/item/storage/backpack/security
	name = "安保背包"
	desc = "十分结实的背包。"
	icon_state = "securitypack"
	inhand_icon_state = "securitypack"

/obj/item/storage/backpack/captain
	name = "站长背包"
	desc = "纳米传讯为高级职员特制的背包。"
	icon_state = "captainpack"
	inhand_icon_state = "captainpack"

/obj/item/storage/backpack/industrial
	name = "工业背包"
	desc = "耐磨结实，经得住空间站的日常工作。"
	icon_state = "engiepack"
	inhand_icon_state = "engiepack"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/botany
	name = "园艺背包"
	desc = "由纯天然纤维制成的背包。"
	icon_state = "botpack"
	inhand_icon_state = "botpack"

/obj/item/storage/backpack/chemistry
	name = "化学背包"
	desc = "经过特殊处理，能防污并阻隔危险液体。"
	icon_state = "chempack"
	inhand_icon_state = "chempack"

/obj/item/storage/backpack/genetics
	name = "遗传学背包"
	desc = "格外结实，以防有人突然变身大力士。"
	icon_state = "genepack"
	inhand_icon_state = "genepack"

/obj/item/storage/backpack/science
	name = "科研背包"
	desc = "特制的防火背包，隐约有股等离子体的味道。"
	icon_state = "toxpack"
	inhand_icon_state = "toxpack"

/obj/item/storage/backpack/virology
	name = "病毒学背包"
	desc = "用低致敏性纤维制成，有助于防止疾病传播。闻起来有股猴味。"
	icon_state = "viropack"
	inhand_icon_state = "viropack"

/obj/item/storage/backpack/ert
	name = "应急响应小队指挥官背包"
	desc = "应急响应小队指挥官使用的大背包，有许多口袋。"
	icon_state = "ert_commander"
	inhand_icon_state = "securitypack"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/ert/security
	name = "应急响应小队安保背包"
	desc = "应急响应小队安保员使用的大背包，有许多口袋。"
	icon_state = "ert_security"

/obj/item/storage/backpack/ert/medical
	name = "应急响应小队医疗背包"
	desc = "应急响应小队医护人员使用的大背包，有许多口袋。"
	icon_state = "ert_medical"

/obj/item/storage/backpack/ert/engineer
	name = "应急响应小队工程背包"
	desc = "应急响应小队工程师使用的大背包，有许多口袋。"
	icon_state = "ert_engineering"

/obj/item/storage/backpack/ert/janitor
	name = "应急响应小队保洁背包"
	desc = "应急响应小队保洁员使用的大背包，有许多口袋。"
	icon_state = "ert_janitor"

/obj/item/storage/backpack/ert/clown
	name = "应急响应小队小丑背包"
	desc = "应急响应小队小丑使用的大背包，有许多口袋。"
	icon_state = "ert_clown"
/*
 * Satchel Types
 */

/obj/item/storage/backpack/satchel
	name = "挎包"
	desc = "款式时髦的挎包。"
	icon_state = "satchel-norm"
	inhand_icon_state = "satchel-norm"

/obj/item/storage/backpack/satchel/leather
	name = "皮挎包"
	desc = "以优质皮革制成的精美挎包。"
	icon_state = "satchel"
	inhand_icon_state = "satchel"

/obj/item/storage/backpack/satchel/leather/withwallet/PopulateContents()
	new /obj/item/storage/wallet/random(src)

/obj/item/storage/backpack/satchel/fireproof
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/satchel/eng
	name = "工业挎包"
	desc = "结实的挎包，多配了几个口袋。"
	icon_state = "satchel-eng"
	inhand_icon_state = "satchel-eng"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/satchel/med
	name = "医疗挎包"
	desc = "医疗部门使用的无菌挎包。"
	icon_state = "satchel-med"
	inhand_icon_state = "satchel-med"

/obj/item/storage/backpack/satchel/vir
	name = "病毒学挎包"
	desc = "采用病毒学部门配色的无菌挎包。"
	icon_state = "satchel-vir"
	inhand_icon_state = "satchel-vir"

/obj/item/storage/backpack/satchel/chem
	name = "化学师挎包"
	desc = "采用化学师配色的无菌挎包。"
	icon_state = "satchel-chem"
	inhand_icon_state = "satchel-chem"

/obj/item/storage/backpack/satchel/gen
	name = "遗传学家挎包"
	desc = "采用遗传学家配色的无菌挎包。"
	icon_state = "satchel-gen"
	inhand_icon_state = "satchel-gen"

/obj/item/storage/backpack/satchel/tox
	name = "科学家挎包"
	desc = "适合装研究材料。"
	icon_state = "satchel-tox"
	inhand_icon_state = "satchel-tox"

/obj/item/storage/backpack/satchel/hyd
	name = "园艺师挎包"
	desc = "由纯天然纤维制成的挎包。"
	icon_state = "satchel-hyd"
	inhand_icon_state = "satchel-hyd"

/obj/item/storage/backpack/satchel/sec
	name = "安保挎包"
	desc = "为安保工作准备的结实挎包。"
	icon_state = "satchel-sec"
	inhand_icon_state = "satchel-sec"

/obj/item/storage/backpack/satchel/explorer
	name = "探险挎包"
	desc = "结实耐用，适合收存战利品。"
	icon_state = "satchel-explorer"
	inhand_icon_state = "satchel-explorer"

/obj/item/storage/backpack/satchel/cap
	name = "站长挎包"
	desc = "纳米传讯高级职员专用的挎包。"
	icon_state = "satchel-cap"
	inhand_icon_state = "satchel-cap"

/obj/item/storage/backpack/satchel/flat
	name = "走私者挎包"
	desc = "这个挎包很薄，能轻松塞进狭窄的缝隙。"
	icon_state = "satchel-flat"
	inhand_icon_state = "satchel-flat"
	w_class = WEIGHT_CLASS_NORMAL //Can fit in backpacks itself.

/obj/item/storage/backpack/satchel/flat/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE, INVISIBILITY_OBSERVER, use_anchor = TRUE)

/obj/item/storage/backpack/satchel/flat/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 15
	STR.set_holdable(null, list(/obj/item/storage/backpack/satchel/flat)) //muh recursive backpacks)

/obj/item/storage/backpack/satchel/flat/PopulateContents()
	var/datum/supply_pack/costumes_toys/randomised/contraband/C = new
	for(var/i in 1 to 2)
		var/ctype = pick(C.contains)
		new ctype(src)

	qdel(C)

/obj/item/storage/backpack/satchel/flat/with_tools/PopulateContents()
	new /obj/item/stack/tile/plasteel(src)
	new /obj/item/crowbar(src)

	..()

/obj/item/storage/backpack/satchel/flat/empty/PopulateContents()
	return

/obj/item/storage/backpack/duffelbag
	name = "旅行包"
	desc = "可以多装些东西的大旅行包。"
	icon_state = "duffel"
	inhand_icon_state = "duffel"

/obj/item/storage/backpack/duffelbag/cursed
	name = "活体旅行包"
	desc = "一个受诅咒的小丑旅行包，什么食物都想吃。\n警告标签上说它会吃掉放进去的食物。要是给它吃厨师从微波炉里刮下来的焦糊残渣，恐怕会有不良反应……"
	icon_state = "duffel-curse"
	inhand_icon_state = "duffel-curse"
	slowdown = 2
	item_flags = DROPDEL
	max_integrity = 100
	///counts time passed since it ate food
	var/hunger = 0

/obj/item/storage/backpack/duffelbag/cursed/examine(mob/user)
	. = ..()

	if(hunger > 25)
		. += "<span class='danger'>The bag is growling for food...</span>"

/obj/item/storage/backpack/duffelbag/cursed/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	START_PROCESSING(SSobj,src)
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
	ADD_TRAIT(user, TRAIT_CLUMSY, CURSED_ITEM_TRAIT)
	ADD_TRAIT(user, TRAIT_PACIFISM, CURSED_ITEM_TRAIT)
	ADD_TRAIT(user, TRAIT_DUFFEL_CURSED, CURSED_ITEM_TRAIT)

/obj/item/storage/backpack/duffelbag/cursed/dropped(mob/living/carbon/human/user)
	REMOVE_TRAIT(user, TRAIT_DUFFEL_CURSED, CURSED_ITEM_TRAIT)
	REMOVE_TRAIT(user, TRAIT_CLUMSY, CURSED_ITEM_TRAIT)
	REMOVE_TRAIT(user, TRAIT_PACIFISM, CURSED_ITEM_TRAIT)
	STOP_PROCESSING(SSobj,src)

	var/turf/T = get_turf(user)
	playsound(T, 'sound/effects/splat.ogg', 50, TRUE)
	new /obj/effect/decal/cleanable/vomit(T)

	. = ..()

/obj/item/storage/backpack/duffelbag/cursed/process()
	///don't process if it's somehow on the floor
	if(!iscarbon(src.loc))
		return
	var/mob/living/carbon/user = src.loc
	///check hp
	if(obj_integrity == 0)
		user.dropItemToGround(src, TRUE)
	hunger++
	///check hunger
	if((hunger > 50) && prob(20))
		for(var/obj/item/I in contents)
			if(IS_EDIBLE(I))
				var/obj/item/food/F = I
				F.forceMove(user.loc)
				playsound(src, 'sound/items/eatfood.ogg', 20, TRUE)
				///poisoned food damages it
				if(istype(F, /obj/item/food/badrecipe))
					to_chat(user, "<span class='warning'>[name]的肚子咕咕叫了起来！</span>")
					obj_integrity -= 50
				else
					to_chat(user, "<span class='notice'>[name]吃掉了你的[F]！</span>")
				qdel(F)
				hunger = 0
				return
		///no food found: it bites you and loses some hp
		var/affecting = user.get_bodypart(BODY_ZONE_CHEST)
		user.deal_damage(60, BRUTE, def_zone = affecting)
		hunger = initial(hunger)
		playsound(src, 'sound/items/eatfood.ogg', 20, TRUE)
		to_chat(user, "<span class='warning'>[name]啃起了你的后背！</span>")
		obj_integrity -= 25

/obj/item/storage/backpack/duffelbag/captain
	name = "站长旅行包"
	desc = "盛放站长用品的大旅行包。"
	icon_state = "duffel-captain"
	inhand_icon_state = "duffel-captain"

/obj/item/storage/backpack/duffelbag/med
	name = "医疗旅行包"
	desc = "盛放备用医疗物资的大旅行包。"
	icon_state = "duffel-med"
	inhand_icon_state = "duffel-med"

/obj/item/storage/backpack/duffelbag/med/surgery
	name = "手术器械旅行包"
	desc = "盛放备用医疗物资的大旅行包，这个包似乎专为手术器械设计。"

/obj/item/storage/backpack/duffelbag/med/surgery/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/circular_saw(src)
	new /obj/item/surgicaldrill(src)
	new /obj/item/cautery(src)
	new /obj/item/bonesetter(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/razor(src)
	new /obj/item/blood_filter(src)

/obj/item/storage/backpack/duffelbag/med/upgradedsurgery
	name = "手术器械旅行包"
	desc = "装备用医疗物资的大旅行包，这个包里似乎装着升级过的手术器械。"
	icon_state = "duffel-syndiemed"
	inhand_icon_state = "duffel-syndiemed"

/obj/item/storage/backpack/duffelbag/med/upgradedsurgery/PopulateContents()
	new /obj/item/scalpel/advanced(src)
	new /obj/item/retractor/advanced(src)
	new /obj/item/cautery/advanced(src)
	new /obj/item/bonesetter(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/razor(src)
	new /obj/item/blood_filter(src)
	new /obj/item/reagent_containers/medigel/sterilizine(src)

/obj/item/storage/backpack/duffelbag/explorer
	name = "探险旅行包"
	desc = "盛放奇珍异宝的大旅行包。"
	icon_state = "duffel-explorer"
	inhand_icon_state = "duffel-explorer"

/obj/item/storage/backpack/duffelbag/hydroponics
	name = "园艺旅行包"
	desc = "盛放备用园艺工具的大旅行包。"
	icon_state = "duffel-hydroponics"
	inhand_icon_state = "duffel-hydroponics"

/obj/item/storage/backpack/duffelbag/chemistry
	name = "化学旅行包"
	desc = "盛放化学品的大旅行包。"
	icon_state = "duffel-chemistry"
	inhand_icon_state = "duffel-chemistry"

/obj/item/storage/backpack/duffelbag/genetics
	name = "遗传学家旅行包"
	desc = "盛放各种基因突变样本的大旅行包。"
	icon_state = "duffel-genetics"
	inhand_icon_state = "duffel-genetics"

/obj/item/storage/backpack/duffelbag/toxins
	name = "科学家旅行包"
	desc = "盛放备用科研组件的大旅行包。"
	icon_state = "duffel-toxins"
	inhand_icon_state = "duffel-toxins"

/obj/item/storage/backpack/duffelbag/virology
	name = "病毒学家旅行包"
	desc = "盛放病毒样本瓶的大旅行包。"
	icon_state = "duffel-virology"
	inhand_icon_state = "duffel-virology"

/obj/item/storage/backpack/duffelbag/sec
	name = "安保旅行包"
	desc = "盛放备用安保物资和弹药的大旅行包。"
	icon_state = "duffel-sec"
	inhand_icon_state = "duffel-sec"

/obj/item/storage/backpack/duffelbag/sec/surgery
	name = "手术器械旅行包"
	desc = "盛放备用物资的大旅行包，内衬为各种锋利器械预留了位置。"

/obj/item/storage/backpack/duffelbag/sec/surgery/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/circular_saw(src)
	new /obj/item/bonesetter(src)
	new /obj/item/surgicaldrill(src)
	new /obj/item/cautery(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/blood_filter(src)

/obj/item/storage/backpack/duffelbag/engineering
	name = "工业旅行包"
	desc = "盛放备用工具和物资的大旅行包。"
	icon_state = "duffel-eng"
	inhand_icon_state = "duffel-eng"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/duffelbag/drone
	name = "无人机旅行包"
	desc = "盛放工具和帽子的大旅行包。"
	icon_state = "duffel-drone"
	inhand_icon_state = "duffel-drone"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/duffelbag/drone/PopulateContents()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/cable_coil(src)
	new /obj/item/wirecutters(src)
	new /obj/item/multitool(src)

/obj/item/storage/backpack/duffelbag/clown
	name = "小丑旅行包"
	desc = "能装下许多搞笑道具的大旅行包！"
	icon_state = "duffel-clown"
	inhand_icon_state = "duffel-clown"

/obj/item/storage/backpack/duffelbag/clown/cream_pie/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/food/pie/cream(src)

/obj/item/storage/backpack/fireproof
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/duffelbag/syndie
	name = "可疑的旅行包"
	desc = "盛放备用战术物资的大旅行包。"
	icon_state = "duffel-syndie"
	inhand_icon_state = "duffel-syndieammo"
	slowdown = 0
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/duffelbag/syndie/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.silent = TRUE

/obj/item/storage/backpack/duffelbag/syndie/hitman
	desc = "可以多装些东西的大旅行包，背面印着纳米传讯的标志。"
	icon_state = "duffel-syndieammo"
	inhand_icon_state = "duffel-syndieammo"

/obj/item/storage/backpack/duffelbag/syndie/hitman/PopulateContents()
	new /obj/item/clothing/under/suit/black(src)
	new /obj/item/clothing/accessory/waistcoat(src)
	new /obj/item/clothing/suit/toggle/lawyer/black(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/head/fedora(src)

/obj/item/storage/backpack/duffelbag/syndie/med
	name = "医疗旅行包"
	desc = "盛放备用战术医疗物资的大旅行包。"
	icon_state = "duffel-syndiemed"
	inhand_icon_state = "duffel-syndiemed"

/obj/item/storage/backpack/duffelbag/syndie/surgery
	name = "手术旅行包"
	desc = "一个看起来可疑的手术器械旅行包。"
	icon_state = "duffel-syndiemed"
	inhand_icon_state = "duffel-syndiemed"

/obj/item/storage/backpack/duffelbag/syndie/surgery/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/circular_saw(src)
	new /obj/item/bonesetter(src)
	new /obj/item/surgicaldrill(src)
	new /obj/item/cautery(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/clothing/suit/straight_jacket(src)
	new /obj/item/clothing/mask/muzzle(src)
	new /obj/item/mmi/syndie(src)
	new /obj/item/blood_filter(src)
	new /obj/item/stack/medical/bone_gel(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo
	name = "弹药旅行包"
	desc = "盛放备用弹药的大旅行包。"
	icon_state = "duffel-syndieammo"
	inhand_icon_state = "duffel-syndieammo"

/obj/item/storage/backpack/duffelbag/syndie/ammo/shotgun
	desc = "塞满斗牛犬霰弹枪弹匣的大旅行包。"

/obj/item/storage/backpack/duffelbag/syndie/ammo/shotgun/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/ammo_box/magazine/m12g/slug(src)
	new /obj/item/ammo_box/magazine/m12g/slug(src)
	new /obj/item/ammo_box/magazine/m12g/dragon(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo/smg
	desc = "塞满 C-20r 冲锋枪弹匣的大旅行包。"

/obj/item/storage/backpack/duffelbag/syndie/ammo/smg/PopulateContents()
	for(var/i in 1 to 9)
		new /obj/item/ammo_box/magazine/smgm45(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo/mech
	desc = "塞满各种机甲弹药的大旅行包。"

/obj/item/storage/backpack/duffelbag/syndie/ammo/mech/PopulateContents()
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/storage/belt/utility/syndicate(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo/mauler
	desc = "塞满各种机甲弹药的大旅行包。"

/obj/item/storage/backpack/duffelbag/syndie/ammo/mauler/PopulateContents()
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/missiles_he(src)
	new /obj/item/mecha_ammo/missiles_he(src)
	new /obj/item/mecha_ammo/missiles_he(src)

/obj/item/storage/backpack/duffelbag/syndie/c20rbundle
	desc = "装有一支 C-20r、几只弹匣和一个廉价消音器的大旅行包。"

/obj/item/storage/backpack/duffelbag/syndie/c20rbundle/PopulateContents()
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/gun/ballistic/automatic/c20r(src)
	new /obj/item/suppressor/specialoffer(src)

/obj/item/storage/backpack/duffelbag/syndie/bulldogbundle
	desc = "装有一支斗牛犬霰弹枪、几个弹鼓和一副热成像眼镜的大旅行包。"

/obj/item/storage/backpack/duffelbag/syndie/bulldogbundle/PopulateContents()
	new /obj/item/gun/ballistic/shotgun/bulldog(src)
	new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/clothing/glasses/thermal/syndi(src)

/obj/item/storage/backpack/duffelbag/syndie/med/medicalbundle
	desc = "装有医疗器材、一挺 Donksoft 轻机枪、一大盒防暴飞镖和一双仿制磁力靴的旅行包。"

/obj/item/storage/backpack/duffelbag/syndie/med/medicalbundle/PopulateContents()
	new /obj/item/clothing/shoes/magboots/syndie(src)
	new /obj/item/storage/firstaid/tactical(src)
	new /obj/item/gun/ballistic/automatic/l6_saw/toy(src)
	new /obj/item/ammo_box/foambox/riot(src)

/obj/item/storage/backpack/duffelbag/syndie/med/bioterrorbundle
	desc = "装有危险化学品、手持试剂喷雾器、生化泡沫手雷、Donksoft 突击步枪、防暴飞镖、飞镖手枪和一盒注射器的大旅行包。"

/obj/item/storage/backpack/duffelbag/syndie/med/bioterrorbundle/PopulateContents()
	new /obj/item/reagent_containers/spray/chemsprayer/bioterror(src)
	new /obj/item/storage/box/syndie_kit/chemical(src)
	new /obj/item/gun/syringe/syndicate(src)
	new /obj/item/gun/ballistic/automatic/c20r/toy(src)
	new /obj/item/storage/box/syringes(src)
	new /obj/item/ammo_box/foambox/riot(src)
	new /obj/item/grenade/chem_grenade/bioterrorfoam(src)
	if(prob(5))
		new /obj/item/food/pizza/pineapple(src)

/obj/item/storage/backpack/duffelbag/syndie/c4/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/grenade/c4(src)

/obj/item/storage/backpack/duffelbag/syndie/x4/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/grenade/c4/x4(src)

/obj/item/storage/backpack/duffelbag/syndie/firestarter
	desc = "装有新俄罗斯背负式火焰喷射器、精英太空服、斯捷奇金 APS 手枪、微型炸弹、弹药及其他装备的大旅行包。"

/obj/item/storage/backpack/duffelbag/syndie/firestarter/PopulateContents()
	new /obj/item/clothing/under/mercenary/soviet(src)
	new /obj/item/watertank/op(src)
	new /obj/item/clothing/suit/space/hardsuit/syndi/elite(src)
	new /obj/item/gun/ballistic/automatic/pistol/aps(src)
	new /obj/item/ammo_box/magazine/m9mm_aps/fire(src)
	new /obj/item/ammo_box/magazine/m9mm_aps/fire(src)
	new /obj/item/reagent_containers/food/drinks/bottle/vodka/badminka(src)
	new /obj/item/reagent_containers/hypospray/medipen/stimulants(src)
	new /obj/item/grenade/syndieminibomb(src)

// For ClownOps.
/obj/item/storage/backpack/duffelbag/clown/syndie/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	slowdown = 0
	STR.silent = TRUE

/obj/item/storage/backpack/duffelbag/clown/syndie/PopulateContents()
	new /obj/item/pda/clown(src)
	new /obj/item/clothing/under/rank/civilian/clown(src)
	new /obj/item/clothing/shoes/clown_shoes(src)
	new /obj/item/clothing/mask/gas/clown_hat(src)
	new /obj/item/bikehorn(src)
	new /obj/item/implanter/sad_trombone(src)

/obj/item/storage/backpack/henchmen
	name = "翅膀"
	desc = "赏给立功手下的。多半轮不到你。"
	icon_state = "henchmen"
	inhand_icon_state = "henchmen"

/obj/item/storage/backpack/duffelbag/cops
	name = "警用旅行包"
	desc = "盛放备用警用装备的大旅行包。"
	slowdown = 0
