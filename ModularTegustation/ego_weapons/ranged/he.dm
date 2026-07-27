/obj/item/ego_weapon/ranged/prank
	name = "蕾蒂希娅"
	desc = "掌握并使用这杆步枪需要时间的磨合. 粗糙的结构设计令它的外表有些老旧，可它仍有不可忽视的威力. 枪上那些小巧的配件就如同少女心中对幸福的憧憬."
	icon_state = "prank"
	worn_icon_state = "prank"
	inhand_icon_state = "prank"
	force = 16
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_prank
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	max_shots = 10
	ammo_on_reload = 1
	reloadtime = 0.3 SECONDS
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	reload_success_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/pistol/gaze
	name = "凝视"
	desc = "具有出色爆发力的马格南手枪."
	icon_state = "gaze"
	inhand_icon_state = "gaze"
	force = 6
	projectile_path = /obj/projectile/ego_bullet/ego_gaze
	fire_delay = 3 //FAN THE HAMMER
	click_cooldown_override = 3
	shotsleft = 8
	reloadtime = 2 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/deagle.ogg'
	vary_fire_sound = FALSE
	weapon_weight = WEAPON_HEAVY
	fire_sound_volume = 70
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/galaxy
	name = "小小银河"
	desc = "你手中的鹅卵石闪耀着，摇曳着，抖动着. 在那之后，它便成了整个银河. “一个藏在鹅卵石中的小小银河.” 当男孩哭泣时，一颗闪亮的新星会诞生于其中. 我在你的小小银河中吗？"
	special = "This weapon's magic doesn't hit allies."
	icon_state = "galaxy"
	inhand_icon_state = "galaxy"
	projectile_path = /obj/projectile/ego_bullet/ego_galaxy
	force = 10
	attack_speed = 0.8
	damtype = BLACK_DAMAGE
	fire_delay = 10
	max_shots = 10
	passive_reload = 2 SECONDS
	ammo_on_reload = 1
	reloadtime = 0.3 SECONDS
	reload_start_sound = 'sound/magic/charge.ogg'
	reload_text = "小小银河开始回复魔力."
	fire_sound = 'sound/magic/wand_teleport.ogg'
	weapon_weight = WEAPON_MEDIUM
	fire_sound_volume = 70
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)

	fire_sound = 'sound/magic/staff_change.ogg'

	alternate_fire_name = "闪光"
	alternate_info = "这把武器发射速度变慢，但会发射一个缓慢移动的投射物，该投射物会在一个小范围内锁定最近的目标."
	alternate_reload_type = RELOADTYPE_SHARED_MAGAZINE
	alternate_projectile_path = /obj/projectile/ego_bullet/ego_galaxy/homing
	alternate_fire_sound = 'sound/magic/charge.ogg'
	alternate_fire_sound_volume = 70
	alternate_toggle_sound = 'sound/magic/wand_teleport.ogg'
	alternate_toggle_sound_volume = 65
	alternate_toggle_enabled_message = span_notice("你引导魔力，使其寻找家的方向.")
	alternate_toggle_disabled_message = span_notice("你释放魔力，不再使其自主寻路.")

/obj/item/ego_weapon/ranged/galaxy/EnableAltfire(mob/user, silent = TRUE)
	. = ..()
	fire_delay = 12

/obj/item/ego_weapon/ranged/galaxy/DisableAltfire(mob/user, silent = TRUE)
	. = ..()
	fire_delay = 10

//The yandere weapon
/obj/item/ego_weapon/ranged/unrequited
	name = "无私的爱"
	desc = "这把武器渴望被关爱，它会不惜一切手段来引起你的注意，同时也嫉妒着你对其他事物的关心."
	special = "如果你拥有其他EGO武器，这把武器的威力会降低."
	icon_state = "unrequited"
	inhand_icon_state = "unrequited"
	force = 16
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_unrequited
	fire_delay = 10
	burst_size = 3
	burst_delay = 5
	max_shots = 24
	reloadtime = 1.8 SECONDS
	fire_sound = 'sound/weapons/gun/l6/shot.ogg'
	vary_fire_sound = FALSE
	weapon_weight = WEAPON_HEAVY
	fire_sound_volume = 70
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/unrequited/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
	if(!CanUseEgo(user))
		return
	if(semicd)
		return
	var/onlyweapon = TRUE
	fire_delay = 10
	var/list/search_area = user.contents.Copy()
	for(var/obj/item/storage/spare_space in search_area)
		search_area |= spare_space.contents
	for(var/obj/item/ego_weapon/disloyal_weapon in search_area)
		if(disloyal_weapon == src)
			continue
		// You are breaking my heart player-sama </3
		onlyweapon = FALSE
		fire_delay = 13
		break
	if(onlyweapon)
		new /obj/effect/temp_visual/mermaid_drowning(get_turf(user))
	return ..()

/obj/item/ego_weapon/ranged/cannon/harmony
	name = "谐奏放射器"
	desc = "即使这把武器看起来像一台已经锈蚀的机器，可它演奏出来的歌曲仍比普通的乐器更加悦耳动听. 而代价是，持有者要献出自己的肉体来使它演奏. 艺术是恶魔从绝望与痛苦之中挖掘出的珍宝. 不要停止演奏，就算你的身体已如碎肉一般亦是如此"
	special = "这把武器发射音波冲击."
	icon_state = "harmony"
	inhand_icon_state = "harmony"
	force = 24
	damtype = RED_DAMAGE // Its a massive chunk of metal
	projectile_path = /obj/projectile/ego_bullet/ego_harmony
	fire_delay = 15
	chargetime = 7
	max_shots = 5
	reloadtime = 0.8 SECONDS
	alternate_reload_time = 0.8 SECONDS
	alternate_fire_name = "研磨之音"
	alternate_reload_type = RELOADTYPE_SHARED_MAGAZINE
	alternate_projectile_path = /obj/projectile/ego_bullet/ego_harmony/strong
	alternate_info = "这把武器的射击伤害将会提高，但每次开火都将损失使用者的HP."
	alternate_fire_sound = 'sound/weapons/ego/cannon.ogg'
	alternate_toggle_enabled_message = span_notice("你按下开关，武器上研磨使用者的锯齿刀片开始疯狂转动.")
	alternate_toggle_disabled_message = span_notice("你按下开关，武器上研磨使用者的锯齿刀片开始缓缓转动.")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/cannon/harmony/before_firing(atom/target, mob/living/user)
	if(alternate_selected)
		playsound(src, 'sound/abnormalities/singingmachine/chew.ogg', 50, TRUE)
		to_chat(user, span_danger("[src]在开火时研磨你的身体!"))
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(user), pick(GLOB.alldirs))
		user.adjustBruteLoss(user.maxHealth*0.05)

/obj/item/ego_weapon/ranged/transmission
	name = "失真信号"
	desc = "这是一把老式步枪."
	icon_state = "transmission"
	inhand_icon_state = "transmission"
	force = 16
	projectile_path = /obj/projectile/ego_bullet/ego_transmission
	weapon_weight = WEAPON_HEAVY
	fire_delay = 7
	max_shots = 10
	ammo_on_reload = 1
	reloadtime = 0.4 SECONDS
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	reload_success_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/song
	name = "怀旧老歌"
	desc = "没有什么比经典更胜一筹."
	special = "这把武器在弹匣打空后换弹会为附近的玩家回复SP."
	icon_state = "song"
	inhand_icon_state = "song"
	force = 16
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_song
	fire_sound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	weapon_weight = WEAPON_MEDIUM
	max_shots = 32
	reloadtime = 2 SECONDS
	spread = 8
	autofire = 0.15 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)
	var/currentshots = 0
	var/sanity_gain = 10

/obj/item/ego_weapon/ranged/song/reload_ego(mob/user)
	currentshots = shotsleft
	. = ..()

/obj/item/ego_weapon/ranged/song/OnReload(mob/user)
	if(currentshots == 0)
		playsound(src, 'sound/abnormalities/siren/sirenhappy.ogg', 100, FALSE, 9)
		for(var/mob/living/carbon/human/L in range(3, get_turf(user)))
			L.adjustSanityLoss(-sanity_gain)

/obj/item/ego_weapon/ranged/pistol/songmini
	name = "怀旧金曲"
	desc = "过去已去."
	icon_state = "songmini"
	inhand_icon_state = "songmini"
	force = 6
	damtype = WHITE_DAMAGE
	pellets = 4
	variance = 15
	randomspread = FALSE
	projectile_path = /obj/projectile/ego_bullet/ego_songmini
	fire_sound = 'sound/weapons/gun/revolver/shot_light.ogg'
	max_shots = 16
	reloadtime = 1 SECONDS
	autofire = 0.2 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/crossbow/wedge
	name = "刺耳嚎叫"
	desc = "这是一把被充斥着复仇的妖妇所诅咒的十字弩. 她的执念使她的长发沿着弩身生长. 弩箭弹射所发出的声音会使人联想起她那刺耳的尖叫. 持有者在使用这把武器时必须小心，因为弩身上生长着的发丝会紧紧缠住他们的双手，并将他们带入无尽的哀伤之中. 唯有坚强的意志与冷酷的内心才能抵御这种哀伤."
	icon_state = "screamingwedge"
	inhand_icon_state = "screamingwedge"
	force = 16
	damtype = WHITE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_wedge
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/pistol/swindle
	name = "骗局"
	desc = "蛇油对人和动物都能有效，能立即缓解疼痛！蛇油的作用就像药膏甚至比药膏还要好！"
	icon = 'icons/obj/guns/projectile.dmi'//put some non-E.G.O sprites to use
	icon_state = "goldrevolver"
	inhand_icon_state = "deagleg"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	special = "This weapon fires dice that deal varying amounts of damage."
	force = 6
	projectile_path = /obj/projectile/ego_bullet/ego_swindle
	weapon_weight = WEAPON_MEDIUM
	fire_delay = 5
	max_shots = 8
	ammo_on_reload = 1
	reloadtime = 0.15 SECONDS
	reload_success_sound = 'sound/weapons/gun/revolver/load_bullet.ogg'
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/ego_weapon/ranged/ringing
	name = "铃声响"
	desc = "枪中传来你过去的回声，它们现在被置入枪管准备发射."
	icon_state = "ringing"
	inhand_icon_state = "ringing"
	special = "这把武器开火时发射声波，同时也可以当做扩音器使用."
	force = 12
	attack_speed = 1
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_ringing
	weapon_weight = WEAPON_MEDIUM
	max_shots = 45
	reloadtime = 3 SECONDS
	autofire = 0.15 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/shot_alt.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)
	var/spamcheck = 0
	var/list/voicespan = list(SPAN_COMMAND)

/obj/item/ego_weapon/ranged/ringing/equipped(mob/M, slot)//megaphone code
	. = ..()
	if (slot == ITEM_SLOT_HANDS && !HAS_TRAIT(M, TRAIT_SIGN_LANG))
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	else
		UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/ego_weapon/ranged/ringing/dropped(mob/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/ego_weapon/ranged/ringing/proc/handle_speech(mob/living/carbon/user, list/speech_args)
	if (user.get_active_held_item() == src)
		if(spamcheck > world.time)
			to_chat(user, span_warning("[src]需要充能!"))
		else
			playsound(loc, 'sound/items/megaphone.ogg', 100, FALSE, TRUE)
			spamcheck = world.time + 50
			speech_args[SPEECH_SPANS] |= voicespan

/obj/item/ego_weapon/ranged/syrinx
	name = "泣婴"
	desc = "还有什么声音比源自原始本能的呐喊更强烈呢?"
	icon_state = "syrinx"
	inhand_icon_state = "syrinx"
	special = "This weapon fires hitscan sound waves."
	force = 10
	attack_speed = 0.7
	damtype = RED_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_syrinx
	weapon_weight = WEAPON_MEDIUM
	spread = 0
	max_shots = 40
	ammo_on_reload = 1
	ammo_on_melee = 3
	passive_reload = 2 SECONDS
	reloadtime = 0.45 SECONDS
	fire_sound = 'sound/weapons/ego/syrinx1.ogg'
	reload_start_sound = 'sound/weapons/bite.ogg'
	reload_text = "The weapon wails, readying to cry once more."
	fire_sound_volume = 25
	autofire = 0.2 SECONDS
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
	)


/obj/item/ego_weapon/ranged/syrinx/before_firing(atom/target, mob/living/user)
	fire_sound = "sound/weapons/ego/syrinx[rand(1,3)].ogg"
	return ..()

/obj/item/ego_weapon/ranged/pistol/deathdealer
	name = "嗜赌如命" // death dealer
	desc = "一把镀金的左轮手枪，结构似乎违背了所有已知的枪械设计原理... 或许这是一种幸运?"
	icon_state = "deathdealer" //Placeholder sprite. Will need to comission/replace with proper sprites
	inhand_icon_state = "deathdealer"
	special = "这把武器每次换弹时都会改变子弹类型. 除非射完全部六发子弹，否则无法重新换弹."
	projectile_path = /obj/projectile/ego_bullet/ego_gaze
	weapon_weight = WEAPON_HEAVY
	fire_delay = 8
	max_shots = 6
	reloadtime = 1.3 SECONDS
	fire_sound = 'sound/weapons/gun/revolver/shot_alt.ogg'
	vary_fire_sound = FALSE
	var/list/ammotypes = list(
		/obj/projectile/ego_bullet/ego_magicbullet,
		/obj/projectile/ego_bullet/ego_supershotgun,
		/obj/projectile/ego_bullet/ego_solemnlament,
		/obj/projectile/ego_bullet/ego_harmony,
		/obj/projectile/ego_bullet/ego_match,
		/obj/projectile/ego_bullet/ego_gaze,
	)
	//TODO: Make it so that the fire_sound manages to match the bullet, I.E. magic bullet shots use the magic bullet sound.

/obj/item/ego_weapon/ranged/pistol/deathdealer/reload_ego(mob/user)
	if(shotsleft != 0)
		to_chat(user,span_warning("你没有清空弹巢，无法重新换弹！"))
		return
	projectile_path = pick(ammotypes)
	update_projectile_examine()
	if(projectile_path == /obj/projectile/ego_bullet/ego_supershotgun)
		pellets = 10
		variance = 35
	else
		pellets = initial(pellets)
		variance = initial(variance)
	return ..()

/obj/item/ego_weapon/ranged/sodarifle
	name = "苏打步枪"
	desc = "一把显然来自虾公司的步枪."
	icon_state = "sodarifle"
	inhand_icon_state = "sodarifle"
	force = 16
	projectile_path = /obj/projectile/ego_bullet/soda_rifle
	weapon_weight = WEAPON_HEAVY
	fire_delay = 6
	max_shots = 10
	reloadtime = 1.4 SECONDS
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40,
							)

