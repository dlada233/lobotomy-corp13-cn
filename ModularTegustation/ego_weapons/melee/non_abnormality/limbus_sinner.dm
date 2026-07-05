//Sinner weapons - TETH
/obj/item/ego_weapon/mini/hayong //李箱
	name = "乌瞰刀" //原文: ha yong
	desc = "你认不认识“化为标本的天才”？"
	special = "这把武器的攻击速度非常快，在手中使用此武器可进行翻滚闪避."
	icon_state = "hayong"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 3
	attack_speed = 0.3
	damtype = WHITE_DAMAGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	var/dodgelanding

/obj/item/ego_weapon/mini/hayong/attack_self(mob/living/carbon/user)
	if(user.dir == 1)
		dodgelanding = locate(user.x, user.y + 5, user.z)
	if(user.dir == 2)
		dodgelanding = locate(user.x, user.y - 5, user.z)
	if(user.dir == 4)
		dodgelanding = locate(user.x + 5, user.y, user.z)
	if(user.dir == 8)
		dodgelanding = locate(user.x - 5, user.y, user.z)
	user.adjustStaminaLoss(20, TRUE, TRUE)
	user.throw_at(dodgelanding, 3, 2, spin = TRUE)

/obj/item/ego_weapon/shield/walpurgisnacht
	name = "瓦尔普吉斯之夜"
	desc = "只要努力，就永远不会犯错." // 原文:Man errs so long as he strives
	icon_state = "walpurgisnacht"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 16
	attack_speed = 1.6
	damtype = WHITE_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP

	attack_verb_continuous = list("cuts", "smacks", "bashes")
	attack_verb_simple = list("cuts", "smacks", "bashes")
	hitsound = 'sound/weapons/bladeslice.ogg'
	reductions = list(20, 30, 10, 0) // 60
	projectile_block_duration = 1 SECONDS
	block_duration = 1 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/ego/clash1.ogg'
	projectile_block_message = "你将弹丸弹开!"
	block_message = "你试图格挡攻击!"
	hit_message = "格挡了攻击!"
	block_cooldown_message = "你重整了武器."

/obj/item/ego_weapon/lance/suenoimpossible
	name = "纯真之梦" //原文: sueno impossible
	desc = "至那颗遥不可及之星！!"
	icon_state = "sueno_impossible"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/96x96_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/96x96_righthand.dmi'
	inhand_x_dimension = 96
	inhand_y_dimension = 96
	force = 19
	reach = 2		//Has 2 Square Reach.
	stuntime = 5
	attack_speed = 1.6// really slow
	damtype = RED_DAMAGE

	attack_verb_continuous = list("bludgeons", "whacks")
	attack_verb_simple = list("bludgeon", "whack")
	hitsound = 'sound/weapons/fixer/generic/spear2.ogg'

/obj/item/ego_weapon/shield/sangria
	name = "简.生.至.美" //原文 S.A.N.G.R.I.A
	desc = "简洁的缩写天然生育出至美的艺术." // 原文 A simple acronym naturally breeds the most beautiful art.
	icon_state = "sangria"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	force = 6
	attack_speed = 0.5
	damtype = BLACK_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP

	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	reductions = list(20, 20, 20, 0) // 60 - Diet Diet Daredevil
	projectile_block_duration = 0 SECONDS //No ranged parry
	block_duration = 0.5 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/parry.ogg'
	block_message = "你试图格挡攻击!"
	hit_message = "格挡了攻击!"
	block_cooldown_message = "你重整了武器."

/obj/item/ego_weapon/shield/sangria/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	return 0 //Prevents ranged  parry

/obj/item/ego_weapon/mini/soleil
	name = "烈日" //原文:soleil
	desc = "今天，我杀了母亲。不，也许是昨天?"
	icon_state = "soleil"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 5
	attack_speed = 0.5
	damtype = RED_DAMAGE


/obj/item/ego_weapon/taixuhuanjing
	name = "太虚幻境"
	desc = "宝玉亦瑕，好事多魔."
	icon_state = "tai_xuhuan_jing"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 11
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.2
	damtype = WHITE_DAMAGE

	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/sword1.ogg'

/obj/item/ego_weapon/revenge
	name = "复仇" //原文:revenge
	desc = "我并没有弄碎你的心—— 是你自个儿把心揉碎了；揉碎了你的心，把我的心也揉碎了."
	icon_state = "revenge"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 17
	attack_speed = 1.6
	damtype = BLACK_DAMAGE

	attack_verb_continuous = list("beats", "smacks")
	attack_verb_simple = list("beat", "smack")

/obj/item/ego_weapon/revenge/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

/obj/item/ego_weapon/mini/hearse
	name = "灵棺" //原文:hearse
	desc = "那个混蛋还活着，就在那边..."// 原文:That bastard is still alive, over there...
	icon_state = "hearse"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 16 //Lots of damage, way less DPS
	damtype = WHITE_DAMAGE

	attack_speed = 2 // Really Slow
	attack_verb_continuous = list("smashes", "bludgeons", "crushes")
	attack_verb_simple = list("smash", "bludgeon", "crush")

/obj/item/ego_weapon/shield/hearse
	name = "灵棺" //原文:hearse
	desc = "如果可以的话，管我叫以实玛利吧."
	special = "这把武器攻击速度较慢，但是造成极高的伤害."
	icon_state = "hearse_shield"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 20
	damtype = WHITE_DAMAGE

	attack_verb_continuous = list("shoves", "bashes")
	attack_verb_simple = list("shove", "bash")
	hitsound = 'sound/weapons/genhit2.ogg'
	reductions = list(40, 20, 30, 0) // 90
	projectile_block_duration = 3 SECONDS
	block_duration = 3 SECONDS
	block_cooldown = 3 SECONDS
	block_sound_volume = 30

/obj/item/ego_weapon/raskolot //horn but a boomerang
	name = "分裂" //原文: raskolot
	desc = "如果她能忘掉一切，重头再来."
	icon_state = "raskolot"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 11
	throwforce = 25
	throw_speed = 1
	throw_range = 7
	damtype = RED_DAMAGE

	hitsound = 'sound/weapons/ego/axe2.ogg'

/obj/item/ego_weapon/raskolot/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
	if(thrownby && !caught)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, throw_at), thrownby, throw_range+2, throw_speed, null, TRUE), 1)
	if(caught)
		return
	else
		return ..()

/obj/item/ego_weapon/vogel
	name = "沃格尔" //原文: vogel
	desc = "邪恶的世界就从那里开始了，就在我们房子的正中央."// 原文: The evil world began there, right in the middle of our house.
	icon_state = "vogel"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 11
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.2
	damtype = RED_DAMAGE

	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/axe2.ogg'

/obj/item/ego_weapon/nobody
	name = "一无是处" //原文: nobody
	desc = "我一无是处."// 原文: I am nothing at all.
	special = "这把EGO既可以作为枪械，也可以用作近战."
	icon_state = "nobody"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 9
	damtype = RED_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP

	attack_speed = 0.8
	attack_verb_continuous = list("cuts", "slices")
	attack_verb_simple = list("cuts", "slices")
	hitsound = 'sound/weapons/ego/sword2.ogg'

	var/gun_cooldown
	var/blademark_cooldown
	var/gunmark_cooldown
	var/gun_cooldown_time = 1.2 SECONDS

/obj/item/ego_weapon/nobody/Initialize()
	RegisterSignal(src, COMSIG_PROJECTILE_ON_HIT, PROC_REF(projectile_hit))
	return ..()

/obj/item/ego_weapon/nobody/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	if(!CanUseEgo(user))
		return
	if(!proximity_flag && gun_cooldown <= world.time)
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		var/obj/projectile/ego_bullet/nobody/G = new /obj/projectile/ego_bullet/nobody(proj_turf)
		G.fired_from = src //for signal check
		playsound(user, 'sound/weapons/gun/shotgun/shot_alt.ogg', 100, TRUE)
		G.firer = user
		G.preparePixelProjectile(target, user, clickparams)
		G.fire()
		gun_cooldown = world.time + gun_cooldown_time
		return

/obj/item/ego_weapon/nobody/proc/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	SIGNAL_HANDLER
	return TRUE

/obj/projectile/ego_bullet/nobody
	name = "gunblade bullet"
	damage = 20
	damage_type = RED_DAMAGE


/obj/item/ego_weapon/ungezifer
	name = "突然，某一日" //原文: ungezifer
	desc = "一天早晨，我从不安的睡梦中醒来，发现自己躺在床上变成了一只巨大的甲虫."
	icon_state = "ungezifer"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 19 // Lots of damage, way less DPS
	damtype = BLACK_DAMAGE

	attack_speed = 2 // Really Slow
	attack_verb_continuous = list("smashes", "bludgeons", "crushes")
	attack_verb_simple = list("smash", "bludgeon", "crush")
	hitsound = 'sound/weapons/ego/justitia2.ogg'
