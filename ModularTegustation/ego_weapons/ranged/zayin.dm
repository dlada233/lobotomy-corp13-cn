// All zayin pistols use the default 3 force for ego_gun pistols
/obj/item/ego_weapon/ranged/pistol/soda
	name = "苏打手枪"
	desc = "一支涂成清新紫色的手枪，每当使用这个EGO时，空气便会飘散出淡淡的葡萄香气."
	special = "若穿着对应护甲而倒下，韦尔奇乐的虾会赶来为你吊唁."
	icon_state = "soda"
	inhand_icon_state = "soda"
	projectile_path = /obj/projectile/ego_bullet/ego_soda
	burst_size = 1
	fire_delay = 6
	reloadtime = 0.8 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	var/shrimp_chosen

/obj/item/ego_weapon/ranged/pistol/soda/pickup(mob/user)
	. = ..()
	shrimp_chosen = user
	RegisterSignal(shrimp_chosen, COMSIG_LIVING_DEATH, PROC_REF(ShrimpFuneral))

/obj/item/ego_weapon/ranged/pistol/soda/dropped(mob/user)
	. = ..()
	UnregisterSignal(shrimp_chosen, COMSIG_LIVING_DEATH)
	shrimp_chosen = null

/obj/item/ego_weapon/ranged/pistol/soda/Destroy(mob/user)
	if(shrimp_chosen)
		UnregisterSignal(shrimp_chosen, COMSIG_LIVING_DEATH)
	shrimp_chosen = null
	return ..()

/obj/item/ego_weapon/ranged/pistol/soda/proc/ShrimpFuneral(mob/user)
	var/obj/item/clothing/suit/armor/ego_gear/zayin/soda/S = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(S))
		user.playsound_local(get_turf(user), 'sound/abnormalities/wellcheers/shrimptaps.ogg', 50, 0)
		for(var/i in 1 to 2)
			new /mob/living/simple_animal/hostile/aminion/shrimp/grieving(get_turf(user))

/obj/item/ego_weapon/ranged/pistol/nostalgia
	name = "怀念"
	desc = "一把看起来古老的手枪."
	special = "一把看起来古老的手枪，当穿戴对应的护甲时，手持此武器ALT单击或鼠标中键可为附近角色恢复SP值."
	icon_state = "nostalgia"
	inhand_icon_state = "nostalgia"
	projectile_path = /obj/projectile/ego_bullet/ego_nostalgia
	fire_sound = 'sound/weapons/gun/revolver/shot.ogg'
	reload_success_sound = 'sound/weapons/gun/revolver/load_bullet.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	fire_delay = 12
	max_shots = 6
	reloadtime = 0.6 SECONDS
	ammo_on_reload = 1

	var/pulse_startup
	var/pulse_startup_time = 10 SECONDS
	var/pulse_cooldown = 1 SECONDS
	var/pulse_healing = -0.5 //negative damage
	var/pulse_enabled = FALSE

/obj/item/ego_weapon/ranged/pistol/nostalgia/MiddleClickAction(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(pulse_startup > world.time)
		to_chat(H, "<span class='warning'>你使用这个能力太过频繁!</span>")
		return
	pulse_startup = world.time + pulse_startup_time
	var/obj/item/clothing/suit/armor/ego_gear/zayin/nostalgia/N = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(N))
		pulse_enabled = TRUE
		to_chat(H, "<span class='warning'>你使用[src]释放SP治疗波！</span>")
		H.playsound_local(get_turf(H), 'sound/abnormalities/old_lady/oldlady_debuff.ogg', 25, 0)
		HealPulse(user, 0)
	else
		pulse_enabled = FALSE
		to_chat(H, "<span class='warning'>使用此技能时，你必须装备对应的护甲!</span>")
	return ..()

/obj/item/ego_weapon/ranged/pistol/nostalgia/dropped(mob/user)
	. = ..()
	pulse_enabled = FALSE

/obj/item/ego_weapon/ranged/pistol/nostalgia/Destroy(mob/user)
	. = ..()
	pulse_enabled = FALSE

/obj/item/ego_weapon/ranged/pistol/nostalgia/proc/HealPulse(mob/living/carbon/human/user, count)
	if(!pulse_enabled)
		return
	if(count >= 10)
		return
	for(var/mob/living/carbon/human/L in livinginview(4, user))
		if(L.stat == DEAD || L == user || L.is_working) //no self-healing
			continue
		L.adjustSanityLoss(pulse_healing)
		to_chat(L, "<span class='nicegreen'>[user]处发出的一道脉冲使你感到心静神宁.</span>")
	addtimer(CALLBACK(src, PROC_REF(HealPulse), user, count += 1), pulse_cooldown)

/obj/item/ego_weapon/ranged/nightshade
	name = "茄属植物"
	desc = "奇怪的是，他不仅仅是一个处于植物人状态的失血患者."
	special = "如果穿着对应护甲，发射的子弹会治疗命中的友方单位."
	icon_state = "nightshade"
	inhand_icon_state = "nightshade"
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_nightshade
	burst_size = 1
	fire_delay = 5
	max_shots = 1
	reloadtime = 1 SECONDS
	weapon_weight = WEAPON_MEDIUM
	fire_sound = 'sound/weapons/bowfire.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 50
	reload_text = "你开始投掷飞镖."
	mobile_reload = TRUE

/obj/item/ego_weapon/ranged/nightshade/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
	var/obj/item/clothing/suit/armor/ego_gear/zayin/nightshade/C = user.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(C))
		projectile_path = /obj/projectile/ego_bullet/ego_nightshade/healing
	else
		projectile_path = /obj/projectile/ego_bullet/ego_nightshade
	return ..()

/obj/item/ego_weapon/ranged/nightshade/Initialize()
	. = ..()
	shotsleft = 0//Starts unloaded

/obj/item/ego_weapon/ranged/bucket
	name = "水桶"
	desc = "一把由木条制成的弹弓，能发射打水漂的石头，你想许下什么样愿望？"
	special = "穿着对应护甲时，手持此武器可以为附近的人制作礼物."
	icon_state = "bucket"
	inhand_icon_state = "bucket"
	force = 2
	attack_speed = 0.5
	projectile_path = /obj/projectile/ego_bullet/ego_bucket
	fire_delay = 6
	chargetime = 5
	fire_sound = 'sound/weapons/bowfire.ogg'
	vary_fire_sound = TRUE
	weapon_weight = WEAPON_HEAVY
	fire_sound_volume = 50
	var/ability_cooldown_time = 60 SECONDS
	var/ability_cooldown

/obj/item/ego_weapon/ranged/bucket/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(ability_cooldown > world.time)
		to_chat(H, "<span class='warning'>你使用能力太过频繁了!</span>")
		return
	var/obj/item/clothing/suit/armor/ego_gear/tools/bucket/T = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(T))
		to_chat(H, "<span class='warning'>使用此技能时，你必须装备相应护甲!</span>")
		return
	to_chat(H, "<span class='warning'>你用[src]来描绘来自许愿井的某物!</span>")
	H.playsound_local(get_turf(H), 'sound/abnormalities/bloodbath/Bloodbath_EyeOn.ogg', 25, 0)
	SpawnItem(user)
	ability_cooldown = world.time + ability_cooldown_time

/obj/item/ego_weapon/ranged/bucket/proc/SpawnItem(mob/user)
	var/list/lootoptions = list(
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_red,
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_white,
		/obj/item/food/salad/lifestew,
		/obj/item/reagent_containers/food/drinks/fairywine,
		/obj/item/food/breadslice/plain,
		/obj/item/food/mint,
		/obj/item/food/rationpack,
		/obj/item/clothing/mask/facehugger/bongy,
		/obj/item/clothing/neck/tie/black,
		/obj/item/clothing/neck/tie/blue,
		/obj/item/clothing/neck/tie/red,
		/obj/item/clothing/neck/tie/horrible,
		/obj/item/clothing/mask/cigarette/cigar/havana,
		/obj/item/poster/random_contraband,
		/obj/item/poster/random_official,
		/obj/item/toy/plush/rabbit,
		/obj/item/toy/plush/blank,
		/obj/item/toy/plush/bongy,
		/obj/item/trash/raisins,
		/obj/item/trash/candy,
		/obj/item/trash/cheesie,
		/obj/item/trash/chips,
		/obj/item/trash/popcorn,
		/obj/item/trash/sosjerky,
		/obj/item/trash/plate,
		/obj/item/trash/pistachios,
		/obj/item/food/candy_corn/prison,)
	for(var/mob/living/carbon/human/L in livinginview(5, user))
		if((!ishuman(L)) || L.stat == DEAD || L == user)
			continue
		to_chat(L, "<span class='warning'>[user]赠予了你礼物!</span>")
		var/gift = pick(lootoptions)
		new gift(get_turf(L))
	var/gift = pick(lootoptions)//you get one too!
	new gift(get_turf(user))

/obj/item/ego_weapon/ranged/pistol/oceanic
	name = "海之味"
	desc = "一支涂成清新橙色的手枪，每当使用这个EGO时，空气便会飘散出淡淡的橙子香气."
	icon_state = "oceanic"
	inhand_icon_state = "oceanic"
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_oceanic
	fire_delay = 5
	max_shots = 8
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
