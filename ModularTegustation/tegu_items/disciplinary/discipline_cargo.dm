#define CAT_GADGET 1
#define CAT_EQUIP 2
#define CAT_MEDICAL 3
#define CAT_RESOURCE 4
#define CAT_OTHER 5
//CONSOLE CODE uses a altered form of mining_vendor


/obj/machinery/computer/extraction_cargo/discipline
	name = "惩戒部装备终端"
	icon_screen = "disciplinary_cargo"
	order_list = list(
		//Gadgets - Technical Equipment, active, that the Disc team could use.
		new /datum/data/extraction_cargo("追踪植入物套件 ", 		/obj/item/storage/box/minertracker,									150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("命令投影仪 ",			/obj/item/commandprojector,											150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("'DEEPSCAN'套件 ",				/obj/item/deepscanner,												150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("逆卡巴拉抑制场生成器 ",	/obj/item/powered_gadget/slowingtrapmk1,							150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("再生仪扩增器 ",		/obj/item/safety_kit,												150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Drain 检测仪 ",				/obj/item/powered_gadget/detector_gadget/abnormality,				200, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Keen-Sense 测距仪 ",		/obj/item/powered_gadget/detector_gadget/ordeal,					200, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("原型脑啡肽注射器",/obj/item/powered_gadget/enkephalin_injector,						200, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("手持电击枪",				/obj/item/powered_gadget/handheld_taser,							300, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("状态显示仪 ",			/obj/item/powered_gadget/vitals_projector,							300, CAT_GADGET) = 1,

		//Equipment - L-公司 Gear
		new /datum/data/extraction_cargo("L-公司 制式警棍 ",			/obj/item/ego_weapon/city/lcorp/baton,								100, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("L-公司 制式砍刀 " ,		/obj/item/ego_weapon/city/lcorp/machete,							100, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("L-公司 制式棍棒 ",			/obj/item/ego_weapon/city/lcorp/club,								100, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("L-公司 制式盾牌 ",			/obj/item/ego_weapon/shield/lcorp_shield,							100, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("L-公司 制式手枪 ",			/obj/item/ego_weapon/ranged/city/lcorp/pistol,						100, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("L-公司 制式全自动手枪 ",	/obj/item/ego_weapon/ranged/city/lcorp/automatic_pistol,			100, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("L-公司 制式防护背心 ",	/obj/item/clothing/suit/armor/ego_gear/city/lcorp_vest,				100, CAT_EQUIP) = 1,

		//Medical
		new /datum/data/extraction_cargo("耐力安瓿 ",		/obj/item/reagent_containers/hypospray/medipen/safety/rcorp,			40, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("HP安瓿 ",			/obj/item/reagent_containers/hypospray/medipen/safety/kcorp,			50, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("SP安瓿 ",			/obj/item/reagent_containers/hypospray/medipen/safety/lcorp,			50, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("HP绷带 ",			/obj/item/safety_bandage/kcorp,											150, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("SP月长石 ",		/obj/item/safety_bandage/mcorp,											150, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("H公司浸药绷带 ",	/obj/item/safety_bandage/hcorp,											150, CAT_MEDICAL) = 1,

		//Resources - This is for EGOshards
		new /datum/data/extraction_cargo("T1 EGO碎片(红色) ",		/obj/item/egoshard,								50, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("T1 EGO碎片(白色)) ",	/obj/item/egoshard/white,						100, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("T1 EGO碎片(黑色) ",	/obj/item/egoshard/black,						100, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("T2 EGO碎片(红色) ",		/obj/item/egoshard/bad,							300, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("T2 EGO碎片(白色)) ",	/obj/item/egoshard/bad/white,					300, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("T2 EGO碎片(黑色) ",	/obj/item/egoshard/bad/black,					300, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("T3 EGO碎片(红色) ",		/obj/item/egoshard/good,						400, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("T3 EGO碎片(白色)) ",	/obj/item/egoshard/good/white,					400, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("T3 EGO碎片(黑色) ",	/obj/item/egoshard/good/black,					400, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("T3 EGO碎片(青色) ",		/obj/item/egoshard/good/pale,					400, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("T4 EGO碎片(红色) ",		/obj/item/egoshard/great,						900, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("T4 EGO碎片(白色)) ",	/obj/item/egoshard/great/white,					900, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("T4 EGO碎片(黑色) ",	/obj/item/egoshard/great/black,					900, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("T4 EGO碎片(青色) ",		/obj/item/egoshard/great/pale,					900, CAT_RESOURCE) = 1,

		//Random stuff
		new /datum/data/extraction_cargo("口香糖 ",		/obj/item/storage/box/gum/bubblegum,								15, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("雪茄 ",						/obj/item/clothing/mask/cigarette/cigar/havana,						25, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("啤酒 ",						/obj/item/reagent_containers/food/drinks/beer,						25, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Spraycan ",					/obj/item/toy/crayon/spraycan,										40, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("魔法8号球 ",				/obj/item/toy/eightball,											70, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Six-Pack ",					/obj/item/storage/cans,												70, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("钓鱼装备 ",			/obj/item/storage/box/fishing,										70, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("威士忌 ",					/obj/item/reagent_containers/food/drinks/bottle/whiskey,			100, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("苦艾酒 ",					/obj/item/reagent_containers/food/drinks/bottle/absinthe/premium,	100, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("滑板 ",					/obj/item/melee/skateboard,											100, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("螺旋眼镜 ",				/obj/item/clothing/glasses/sunglasses/gar,							100, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Skub ",						/obj/item/skub,														200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("人体模型 ",					/obj/structure/mannequin,											200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("金鱼钩 ",			/obj/item/fishing_component/hook/shiny,								200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("强化鱼线 ",	/obj/item/fishing_component/line/reinforced,						200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("1000眼 ",					/obj/item/stack/spacecash/c1000,									200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("宠物哨子 ",					/obj/item/pet_whistle,												200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("玛格丽特披萨 ",			/obj/item/food/pizza/margherita,									300, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("超螺旋眼睛 ",			/obj/item/clothing/glasses/sunglasses/gar/supergar,					500, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("员工队长披风 ",		/obj/item/clothing/neck/cloak/hos/agent,							500, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("员工队长帽子 ",		/obj/item/clothing/head/hos/agent,									500, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("玩偶盒",				/obj/item/plushgacha,												1000, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Binah玩偶 ",					/obj/item/toy/plush/binah,											1000, CAT_OTHER) = 1,


	)


#undef CAT_GADGET
#undef CAT_EQUIP
#undef CAT_MEDICAL
#undef CAT_RESOURCE
#undef CAT_OTHER
