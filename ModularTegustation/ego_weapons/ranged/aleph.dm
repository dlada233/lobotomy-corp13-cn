/obj/item/ego_weapon/ranged/star
	name = "新星之声"
	desc = "新星自我们的绝望中闪耀，一小团怀恋正散发着温暖的明光."
	icon_state = "star"
	inhand_icon_state = "star"
	special = "这把武器根据使用者的SP值会进行一定数量的额外射击.\n这把武器具有敌我识别功能，无视友方并能穿透所有敌方目标."

	force = 18
	damtype = WHITE_DAMAGE
	attack_speed = 0.5

	projectile_path = /obj/projectile/ego_bullet/star
	weapon_weight = WEAPON_MEDIUM
	spread = 0
	burst_size = 3
	burst_delay = 1.5
	fire_delay = 15
	max_shots = 60
	ammo_on_reload = 1
	reloadtime = 0.1 SECONDS
	passive_reload = 3 SECONDS
	reload_start_sound = 'sound/weapons/pulse.ogg'
	reload_text = "新星之声重新充能中."

	fire_sound = 'sound/weapons/ego/star.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 25
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/ranged/star/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
	if(!CanUseEgo(user))
		return
	burst_size = 1
	if(user.sanityhealth >= (user.maxSanity * 0.3))
		burst_size = 2
	if(user.sanityhealth >= (user.maxSanity * 0.6))
		burst_size = 3
	return ..()

/obj/item/ego_weapon/ranged/star/suicide_act(mob/living/carbon/user)
	. = ..()
	user.visible_message(span_suicide("[user]双腿扭曲并朝着相反方向延伸! 这是一种自杀行为!"))
	playsound(src, 'sound/abnormalities/bluestar/pulse.ogg', 50, FALSE, 40, falloff_distance = 10)
	user.unequip_everything()
	QDEL_IN(user, 1)
	return MANUAL_SUICIDE

/obj/item/ego_weapon/ranged/adoration
	name = "爱慕"
	desc = "这是一个装有神秘黏液的大杯子. \
	这些粘液是一场骇人实验的残留物. 触碰粘液的人会抱怨皮肤上那股怪异的感觉，然而它绝不会止步于此."
	icon_state = "adoration"
	inhand_icon_state = "adoration"

	force = 40
	damtype = BLACK_DAMAGE

	projectile_path = /obj/projectile/ego_bullet/adoration
	weapon_weight = WEAPON_MEDIUM
	fire_delay = 15
	pellets = 3
	variance = 15
	randomspread = FALSE
	max_shots = 16
	ammo_on_reload = 1
	passive_reload = 3 SECONDS
	reloadtime = 0.3 SECONDS
	reload_start_sound = 'sound/abnormalities/meltinglove/ranged_hit.ogg'
	reload_text = "杯中的黏液正在再生."

	fire_sound = 'sound/effects/attackblob.ogg'
	fire_sound_volume = 50
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)
	alternate_reload_time = 5
	alternate_fire_name = "具有感染力的爱"
	alternate_projectile_path = /obj/projectile/ego_bullet/adoration/super
	alternate_info = "这把武器会发射一个巨大而缓慢的黏液球，发射所需弹药量是常规射击的两倍，且需要先蓄力充能再发射. \
	黏液球造成范围伤害并施加DOT效果."
	alternate_reload_type = RELOADTYPE_SHARED_MAGAZINE
	alternate_fire_sound = 'sound/abnormalities/meltinglove/ranged.ogg'
	alternate_pellets = 1
	alternate_variance  = 0
	alternate_toggle_sound = 'sound/effects/attackblob.ogg'
	alternate_toggle_sound_volume = 50
	alternate_toggle_enabled_message = span_notice("你保持专注，准备开始进行蓄力充能射击.")
	alternate_toggle_disabled_message = span_notice("你保持专注，准备开始进行常规射击.")

/obj/item/ego_weapon/ranged/adoration/EnableAltfire(mob/user, silent = TRUE)
	. = ..()
	variance = 0
	ammo_per_shot = 2
	chargetime = 5

/obj/item/ego_weapon/ranged/adoration/DisableAltfire(mob/user, silent = TRUE)
	. = ..()
	variance = initial(variance)
	ammo_per_shot = 1
	chargetime = 0

/obj/item/ego_weapon/ranged/nihil
	name = "虚无"
	desc = "决定相信自己的直觉后，弄臣每走一步，都会说出自己在那条路上遇到的每一个人的名字."
	icon_state = "nihil"
	inhand_icon_state = "nihil"
	force = 28
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/nihil
	weapon_weight = WEAPON_HEAVY
	pellets = 4
	variance = 20
	fire_sound = 'sound/weapons/fixer/generic/energy1.ogg'
	fire_sound_volume = 50
	fire_delay = 10
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)
	var/wrath
	var/despair
	var/greed
	var/hate
	var/list/powers = list("hatred", "despair", "greed", "wrath")

/obj/item/ego_weapon/ranged/nihil/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(!istype(I, /obj/item/nihil))
		return

	if(powers[1] == "hatred" && istype(I, /obj/item/nihil/heart))
		powers[1] = "hearts"
		IncreaseAttributes(user, powers[1])
		qdel(I)
	else if(powers[2] == "despair" && istype(I, /obj/item/nihil/spade))
		powers[2] = "spades"
		IncreaseAttributes(user, powers[2])
		qdel(I)
	else if(powers[3] == "greed" && istype(I, /obj/item/nihil/diamond))
		powers[3] = "diamonds"
		IncreaseAttributes(user, powers[3])
		qdel(I)
	else if(powers[4] == "wrath" && istype(I, /obj/item/nihil/club))
		powers[4]= "clubs"
		IncreaseAttributes(user, powers[4])
		qdel(I)
	else
		to_chat(user,"<span class='warning'>你已经使用过此升级了!</span>")

/obj/item/ego_weapon/ranged/nihil/proc/IncreaseAttributes(user, current_suit)
	for(var/atr in attribute_requirements)
		if(atr == TEMPERANCE_ATTRIBUTE)
			attribute_requirements[atr] += 5
		else
			attribute_requirements[atr] += 10
	to_chat(user,"<span class='warning'>[src]的装备需求已提升!</span>")

	switch(current_suit)
		if("hearts")
			to_chat(user,"<span class='nicegreen'>从[src]中抽出[current_suit]色Ace牌移除了友军火力!</span>")

		if("spades")
			to_chat(user,"<span class='nicegreen'>从[src]中抽出[current_suit]色Ace牌使其获得造成青色伤害的能力!</span>")

		if("diamonds")
			to_chat(user,"<span class='nicegreen'>从[src]中抽出[current_suit]色Ace牌使其获得造成红色伤害的能力!</span>")

		if("clubs")
			to_chat(user,"<span class='nicegreen'>从[src]中抽出[current_suit]色Ace牌使其获得造成黑色伤害的能力!</span>")
	to_chat(user,"<span class='nicegreen'>[current_suit]的Ace牌逐渐消散，但是[src]同时也变得更加强大!</span>")
	return

/obj/item/ego_weapon/ranged/pink
	name = "粉红军备"
	desc = "粉红色象征着温暖与爱. \
			但这把粉红涂装的枪真的能够代表爱吗？伤害他人的工具又该如何传递爱与和平？"
	icon_state = "pink"
	inhand_icon_state = "pink"
	special = "这把武器具有瞄准镜，按住鼠标中键或者ALT键可以向该方向扩大视野. 发射出的子弹飞行时间为零，并且具有敌我识别功能. 当命中更远处的目标时，造成的伤害会增加."
	force = 40
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/pink
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/abnormalities/armyinblack/pink.ogg'
	fire_delay = 20
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13
	max_shots = 5
	reloadtime = 2.1 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/mob/current_holder

/obj/item/ego_weapon/ranged/pink/MiddleClickAction(atom/target, mob/living/user)
	. = ..()
	if(.)
		return
	zoom(user, get_cardinal_dir(user, target))

/obj/item/ego_weapon/ranged/pink/zoom(mob/living/user, direc, forced_zoom)
	if(!CanUseEgo(user))
		return
	if(!user || !user.client)
		return
	if(isnull(forced_zoom))
		zoomed = !zoomed
	else
		zoomed = forced_zoom
	if(src != user.get_active_held_item())
		if(!zoomed)
			UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
			UnregisterSignal(user, COMSIG_ATOM_DIR_CHANGE)
			user.client.view_size.zoomIn()
		return
	if(!zoomed)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(user, COMSIG_ATOM_DIR_CHANGE)
		user.client.view_size.zoomIn()
	else
		RegisterSignal(user, COMSIG_ATOM_DIR_CHANGE, PROC_REF(rotate))
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(UserMoved))
		user.client.view_size.zoomOut(zoom_out_amt, zoom_amt, direc)
	return zoomed

/obj/item/ego_weapon/ranged/pink/proc/UserMoved(mob/living/user, direc)
	SIGNAL_HANDLER
	zoom(user)//disengage

/obj/item/ego_weapon/ranged/pink/Destroy(mob/user)//FIXME: causes component runtimes
	if(!user)
		return ..()
	if(zoomed)
		UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(current_holder, COMSIG_ATOM_DIR_CHANGE)
		current_holder = null
		return ..()

/obj/item/ego_weapon/ranged/pink/dropped(mob/user)
	. = ..()
	if(!user)
		return
	if(zoomed)
		UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(current_holder, COMSIG_ATOM_DIR_CHANGE)
		current_holder = null

/obj/item/ego_weapon/ranged/arcadia
	name = "阿卡迪亚亦有我" //Et in Arcadia Ego （拉丁语 名画《阿卡迪亚的牧人》）
	desc = "日中则昃，人亦衰亡."
	icon_state = "arcadia"
	inhand_icon_state = "arcadia"
	force = 40
	projectile_path = /obj/projectile/ego_bullet/arcadia
	weapon_weight = WEAPON_HEAVY
	spread = 5
	recoil = 1.5
	fire_sound = 'sound/weapons/gun/rifle/shot_atelier.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 30
	fire_delay = 7

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)


	max_shots = 16	//Based off a henry .44
	reloadtime = 0.5 SECONDS
	ammo_on_reload = 1

/obj/item/ego_weapon/ranged/arcadia/judge
	name = "评判"
	desc = "你将受到评判；正如我一样." // You will be judged; as I have （可能是圣经）
	icon_state = "judge"
	inhand_icon_state = "judge"
	force = 40
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/judge
	weapon_weight = WEAPON_MEDIUM	//Cannot be dual wielded
	recoil = 1
	fire_sound_volume = 30
	fire_delay = 3	//FAN THE HAMMER
	click_cooldown_override = 3

	max_shots = 6	//Based off a colt Single Action Navy
	reloadtime = 1 SECONDS


/obj/item/ego_weapon/ranged/havana
	name = "哈瓦那"
	desc = "它简单的外表背后，隐藏着许多挣扎."
	special = "这把武器发射短程火焰，可穿透目标，但击中目标越多，造成的伤害越低."
	icon_state = "havana"
	inhand_icon_state = "havana"
	force = 30
	damtype = PALE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_hookah
	weapon_weight = WEAPON_HEAVY
	spread = 20
	fire_sound = 'sound/effects/burn.ogg'
	autofire = 0.04 SECONDS
	fire_sound_volume = 5
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
	)
	reloadtime = 3 SECONDS
	max_shots = 150

//Just a funny gold soda pistol. It was originally meant to just be a golden meme weapon, now it is the only pale gun, lol
/obj/item/ego_weapon/ranged/pistol/executive
	name = "虾之秩序"
	desc = "一把漆成黑色，表面镀金的手枪. 每当使用这把EGO时，空气中便弥漫着一丝嫩煎牛里脊的淡淡香气."
	icon_state = "executive"
	inhand_icon_state = "executive"
	special = "这把武器具有极高的精准度. \n弹仓内的最后一发子弹将造成大量伤害. 若最后一发子弹直接击杀目标，这把武器将自动装填."
	force = 15
	damtype = PALE_DAMAGE
	burst_size = 1
	fire_delay = 5
	max_shots = 12
	reloadtime = 1.2 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	spread = 0
	variance = 0
	dual_wield_spread = 0
	projectile_path = /obj/projectile/ego_bullet/ego_executive
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
	)

/obj/item/ego_weapon/ranged/pistol/executive/proc/AutoReload(mob/user)
	if(shotsleft == max_shots)
		return
	playsound(src, 'sound/weapons/ego/executive_reload.ogg', 70, FALSE)
	shotsleft = max_shots
	UpdateAmmoCounter()
	to_chat(user, span_nicegreen("一个新的弹匣出现在[src]里!"))
	// Might as well reload the other gun
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		for(var/obj/item/ego_weapon/ranged/pistol/executive/G in H.held_items)
			if(G == src || G.shotsleft == G.max_shots)
				continue
			G.shotsleft = G.max_shots
			G.UpdateAmmoCounter()
			playsound(G, 'sound/weapons/ego/executive_reload.ogg', 70, FALSE)
			to_chat(user, span_nicegreen("一个新的弹匣出现在[G]里!"))

/obj/item/ego_weapon/ranged/pistol/executive/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
	if(!CanUseEgo(user))
		return
	if(shotsleft == 1)
		projectile_path = /obj/projectile/ego_bullet/ego_executive/kill_shot
		fire_sound = 'sound/weapons/ego/executive_shot.ogg'
	. = ..()
	if(!shotsleft)
		projectile_path = initial(projectile_path)
		fire_sound = initial(fire_sound)
		update_projectile_examine()
