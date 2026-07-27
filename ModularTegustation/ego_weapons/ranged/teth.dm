//All teth Rifles should be around 22 DPS (31 per bullet
//All Teth Pistols should hit about

//Does slightly less damage due to AOE.
/obj/item/ego_weapon/ranged/cannon/match
	name = "终末火柴之光"
	desc = "这把武器所喷出的火焰会如同原初之火一样咆哮，烈火不会熄灭，直到它将世上所有的幸福温暖和光明统统烧尽. \
	被烈焰灼烧的人会对世界产生无尽的仇恨，直至他们的意识与身躯一并化为灰烬. 实验这把武器时会造成无法避免的伤亡."
	icon_state = "match"
	inhand_icon_state = "match"
	special = "这把武器造成AOE范围伤害."
	force = 15
	projectile_path = /obj/projectile/ego_bullet/ego_match

/obj/item/ego_weapon/ranged/pistol/beak
	name = "小喙"
	desc = "小小身躯也能造成巨大的痛苦, \
	这把武器配套的子弹有着尖锐的弹头，就像是一颗颗小尖牙. 它会给目标造成巨大的痛苦."
	icon_state = "beak"
	inhand_icon_state = "beak"
	force = 4
	special = "这把武器在双手各持时具有极高的精准度."
	projectile_path = /obj/projectile/ego_bullet/ego_beak
	fire_delay = 10
	max_shots = 7
	reloadtime = 2.1 SECONDS
	fire_sound = 'sound/weapons/gun/revolver/shot_alt.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	dual_wield_spread = 0

/obj/item/ego_weapon/ranged/beaksmg
	name = "小喙mk2"
	desc = "不要宽恕那些阻碍自己前进的蠢货，用无情的火力彻底击溃挡在你面前的人."
	icon_state = "beaksmg"
	inhand_icon_state = "beaksmg"
	force = 10
	special = "这把武器在使用者的HP低于一半时会增加子弹伤害与子弹散布."
	projectile_path = /obj/projectile/ego_bullet/ego_bulletsmg
	weapon_weight = WEAPON_MEDIUM
	spread = 10
	max_shots = 30
	reloadtime = 2 SECONDS
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'
	autofire = 0.16 SECONDS
	var/angry = FALSE

/obj/item/ego_weapon/ranged/beaksmg/before_firing(atom/target, mob/living/user)
	if(user.health <= user.maxHealth/2)
		angry = TRUE
	else
		angry = FALSE
	if(angry)
		spread = 30
		projectile_path = /obj/projectile/ego_bullet/ego_bulletsmg/strong
		color = "#FF0000"
	else
		spread = initial(spread)
		projectile_path = initial(projectile_path)
		color = "#FFFFFF"
	return ..()

/obj/item/ego_weapon/ranged/noise
	name = "噪音"
	desc = "这些声音将你带回了每个人早已遗忘的“那一天”."
	icon_state = "noise"
	inhand_icon_state = "noise"
	force = 10
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_noise
	weapon_weight = WEAPON_HEAVY
	pellets = 5
	variance = 15
	randomspread = FALSE
	fire_delay = 10
	max_shots = 8
	ammo_on_reload = 1
	reloadtime = 0.6 SECONDS
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'
	round_text = "You start loading a shell."
	reload_success_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'

/obj/item/ego_weapon/ranged/pistol/solitude
	name = "孤独"
	desc = "即便该异想体的核心已经变成了E.G.O的形式，那种强烈的孤独感也仍旧存在于这把武器上. 它射出的子弹并不会穿透敌人的骨头，反而会留下永久的，孤独的空白. 这把手枪在被制造出来时便已锈迹斑斑了."
	icon_state = "solitude"
	inhand_icon_state = "solitude"
	force = 4
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_solitude
	fire_delay = 10
	max_shots = 6
	reloadtime = 0.5 SECONDS
	ammo_on_reload = 1
	fire_sound = 'sound/weapons/gun/revolver/shot_light.ogg'
	reload_success_sound = 'sound/weapons/gun/revolver/load_bullet.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70

/obj/item/ego_weapon/ranged/pistol/shy
	name = "此刻的神色"
	desc = "这件装备上的各种表情都是由布料填塞出来的. \
	人们可能会因为害羞而拒绝展露自己的面容与表情，当你觉得已经无法从面容上掩盖你的情感时，那就穿上我们，让我们来遮住你的脸吧."
	icon_state = "shy"
	inhand_icon_state = "shy"
	force = 4
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_shy
	fire_sound = 'sound/effects/meatslap.ogg'
	vary_fire_sound = FALSE
	max_shots = 20
	reloadtime = 1.2 SECONDS
	autofire = 0.2 SECONDS

/obj/item/ego_weapon/ranged/dream
	name = "迷魂梦境"
	desc = "我们必须保持清醒，这家残酷的公司甚至不允许人们拥有甜美的梦. 这件武器将唤醒那些沉浸在甜美梦境中的人们，当催人入睡的声音停止时，黎明便将到来."
	icon_state = "dream"
	inhand_icon_state = "dream"
	force = 7
	attack_speed = 0.8
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_dream
	weapon_weight = WEAPON_MEDIUM
	fire_sound = "dreamy_gun"
	autofire = 0.25 SECONDS
	max_shots = 16
	reload_start_sound = 'sound/creatures/goose1.ogg' //I have no idea what to use for this
	reload_text = "武器正在为发射恢复能量."
	ammo_on_reload = 1
	passive_reload = 1.5 SECONDS
	reloadtime = 0.2 SECONDS

/obj/item/ego_weapon/ranged/page
	name = "书页"
	desc = "创作的痛苦! 煎熬! 折磨!"
	icon_state = "page"
	inhand_icon_state = "page"
	force = 10
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_page
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	max_shots = 10
	reloadtime = 0.2 SECONDS
	ammo_on_reload = 1
	reload_success_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'

/obj/item/ego_weapon/ranged/snapshot
	name = "快照"
	desc = "我发誓，那副道德败坏的肖像是只是为了让我们放松警惕."
	icon_state = "snapshot"
	inhand_icon_state = "snapshot"
	special = "这把武器发射扫描光束."
	force = 10
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/snapshot
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10
	max_shots = 12
	ammo_on_reload = 1
	passive_reload = 1.5 SECONDS
	reloadtime = 0.25 SECONDS
	fire_sound = 'sound/weapons/sonic_jackhammer.ogg'
	reload_start_sound = 'sound/items/polaroid2.ogg'
	reload_text = "武器开始恢复能量."

/obj/item/ego_weapon/ranged/wishing_cairn
	name = "祈愿石"
	desc = "告诉我你的愿望，说出你内心的渴望..."
	icon_state = "wishing_cairn"
	inhand_icon_state = "wishing_cairn"
	special = "这把武器有一个短距离的连击系统."
	force = 10
	attack_speed = 1
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_wishing
	weapon_weight = WEAPON_MEDIUM
	burst_delay = 6
	burst_size = 2
	fire_delay = 10
	fire_sound = 'sound/abnormalities/pagoda/throw.ogg'
	var/ammo2 = /obj/projectile/ego_bullet/ego_wishing2

/obj/item/ego_weapon/ranged/wishing_cairn/proc/Ammo_Change()
	projectile_path = ammo2
	fire_sound = 'sound/abnormalities/pagoda/throw2.ogg'

/obj/item/ego_weapon/ranged/wishing_cairn/afterattack(atom/target, mob/user)
	. = ..()
	projectile_path = initial(projectile_path)
	fire_sound = 'sound/abnormalities/pagoda/throw.ogg'

/obj/item/ego_weapon/ranged/aspiration
	name = "渴望"
	desc = "活着的渴望比任何事物都更强烈. 同时悔恨也终于在我的体内激起一阵颤栗."
	icon_state = "aspiration"
	inhand_icon_state = "aspiration"
	special = "这把武器会以消耗HP为代价发射扫描光束. \n 命中友方时会治疗目标的HP,"
	force = 7
	attack_speed = 0.8
	projectile_path = /obj/projectile/ego_bullet/ego_aspiration
	weapon_weight = WEAPON_MEDIUM
	autofire = 0.5 SECONDS
	fire_sound = 'sound/abnormalities/fragment/attack.ogg'

/obj/item/ego_weapon/ranged/aspiration/before_firing(atom/target,mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.adjustBruteLoss(H.maxHealth * 0.05)
	return ..()

/obj/item/ego_weapon/ranged/patriot
	name = "爱国者"
	desc = "不要问国家为你做了什么，而是问问你为国家做什么." // Are you willing to do what it takes to protect your country?
	icon_state = "patriot"
	inhand_icon_state = "patriot"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 10
	projectile_path = /obj/projectile/ego_bullet/ego_patriot
	pellets = 4
	randomspread = FALSE
	variance = 15
	weapon_weight = WEAPON_HEAVY
	fire_delay = 12
	max_shots = 8
	ammo_on_reload = 1
	reloadtime = 0.8 SECONDS
	fire_sound = 'sound/weapons/gun/shotgun/shot.ogg'
	round_text = "You start loading a shell."
	reload_success_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'

/obj/item/ego_weapon/ranged/luckdraw
	name = "好运牌"
	desc = "一副似乎抽不尽的带刃扑克. 你愿意赌上多少来赢得大奖？"
	icon_state = "luckdraw"
	inhand_icon_state = "luckdraw"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	special = "这把武器的投射物移动缓慢，但能穿透敌人."
	force = 4
	attack_speed = 0.5
	projectile_path = /obj/projectile/ego_bullet/ego_luckdraw
	weapon_weight = WEAPON_MEDIUM
	autofire = 0.35 SECONDS
	max_shots = 52
	ammo_on_reload = 1
	passive_reload = 3 SECONDS
	reloadtime = 0.05 SECONDS
	fire_sound = 'sound/items/handling/paper_pickup.ogg' //Mostly just using this for a lack of a better "card-flicking" noise
	reload_start_sound = 'sound/items/cardshuffle.ogg'
	reload_text = "好运牌开始重新洗牌."

/obj/item/ego_weapon/ranged/pistol/tough
	name = "谢顶之灾"
	desc = "这是一把屌爆了的格洛克手枪！能够轻松击落一架直升飞机！它使你想起了一名伟大的刑警，在谢顶之前，他与黑恶势力斗争了整整25年！！！"
	special = "手持此武器并穿戴对应护甲时，ALT单击或鼠标中键即可使附近的人变成秃头."
	icon_state = "bald"
	inhand_icon_state = "bald"
	force = 4
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_tough
	fire_delay = 5
	reloadtime = 0.8 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	var/pulse_cooldown
	var/pulse_cooldown_time = 60 SECONDS
	var/blast_delay = 3 SECONDS

/obj/item/ego_weapon/ranged/pistol/tough/MiddleClickAction(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(pulse_cooldown > world.time)
		to_chat(H, "<span class='warning'>你使用这个能力太频繁了!</span>")
		return
	var/obj/item/clothing/suit/armor/ego_gear/zayin/tough/T = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(T))
		to_chat(H, "<span class='warning'>要使用能力，你必须穿着对应护甲!</span>")
		return
	to_chat(H, "<span class='warning'>你使用 [src] 创造了秃之领域!</span>")
	H.playsound_local(get_turf(H), 'sound/abnormalities/wrath_servant/hermit_magic.ogg', 25, 0)
	BaldBlast(user)
	pulse_cooldown = world.time + pulse_cooldown_time
	return ..()

/obj/item/ego_weapon/ranged/pistol/tough/proc/BaldBlast(mob/living/carbon/human/user ,list/baldtargets = list(), burst_chain)
	for(var/mob/living/carbon/human/L in livinginview(5, user)) //not even the dead are safe.
		if(!ishuman(L))
			continue
		if(HAS_TRAIT(L, TRAIT_BALD))
			continue
		if(L in baldtargets)
			to_chat(L, "<span class='warning'>你感觉棒极了!</span>")
			ADD_TRAIT(L, TRAIT_BALD, "ABNORMALITY_BALD")
			L.hairstyle = "Bald"
			L.update_hair()
			continue

		baldtargets += L
		to_chat(L, "<span class='warning'>你遭到了秃头心理攻击. 如果这段话正在被非秃头人士阅读，只要你在[user]的领域范围内你就会被赋予以极快速度变秃的特权!</span>")
	if(!burst_chain)
		addtimer(CALLBACK(src, PROC_REF(BaldBlast), user, baldtargets, TRUE), blast_delay)

/obj/item/ego_weapon/ranged/pistol/tough/SpecialEgoCheck(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_BALD))
		return TRUE
	to_chat(H, "<span class='notice'>只有对整洁发型有执着的人才能使用 [src]!</span>")
	return FALSE

/obj/item/ego_weapon/ranged/pistol/tough/SpecialGearRequirements()
	return "\n<span class='warning'>使用者必须拥有最整洁的发型.</span>"

/obj/item/ego_weapon/ranged/cannon/adjustment
	name = "行为矫正仪"
	desc = "一把舒适且易于瞄准和发射的臂跑."
	icon_state = "adjustment"
	inhand_icon_state = "adjustment"
	special = "这把枪会恢复命中目标的SP."
	force = 15
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_adjustment
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	chargetime = 8
	recoil = 0
	max_shots = 6
	ammo_on_reload = null
	reloadtime = 2.5 SECONDS
	fire_sound = 'sound/abnormalities/thunderbird/tbird_beam.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 25
