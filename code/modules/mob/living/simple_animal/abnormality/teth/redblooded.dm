/mob/living/simple_animal/hostile/abnormality/redblooded
	name = "热血美国人"
	desc = "一个亮红色的恶魔，有着超大的手臂和油腻的黑发，它的眼睛一直盯着你. "
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "american_idle"
	icon_living = "american_idle"
	core_icon = "american"
	portrait = "red_blooded_american"
	var/icon_furious = "american_idle_injured"
	del_on_death = TRUE
	maxHealth = 260
	health = 260
	rapid_melee = 1
	melee_queue_distance = 2
	move_to_delay = 4
	attack_sound = 'sound/weapons/ego/mace1.ogg'
	attack_verb_continuous = "slams"
	attack_verb_simple = "slam"
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	ranged = TRUE
	ranged_cooldown_time = 4 SECONDS
	casingtype = /obj/item/ammo_casing/caseless/true_patriot
	projectilesound = 'sound/weapons/gun/shotgun/shot.ogg'
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 4
	melee_damage_upper = 6
	faction = list("hostile")
	speak_emote = list("snarls")
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 45,
		ABNORMALITY_WORK_INSIGHT = 35,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(60, 60, 60, 55, 55),
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/red_blooded
	harvest_phrase = span_notice("你从%ABNO身上采集了血样。血液在%VESSEL中嘶嘶作响。")
	harvest_phrase_third = "%PERSON用%ABNO的血样装满了%VESSEL。"

	ego_list = list(
		/datum/ego_datum/weapon/patriot,
		/datum/ego_datum/armor/patriot,
	)
	gift_type = /datum/ego_gifts/patriot
	gift_message = "Protect and serve."
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	observation_prompt = "\"知道吗，我曾是个好士兵。\" <br>\
		\"用我的霰弹枪轰掉那些怪胎。<br>和我的战友们聊天。\" <br>\
		\"这就是我需要的全部。<br>也是我想要的全部。<br>即使现在，我也在为我的国家荣耀而战。\" <br>\
		\"你有什么要服务和保护的东西或人吗？\""
	observation_choices = list(
		"我有" = list(TRUE, "\"呵。\" <br>\
			\"我们可能不是同一阵营，但我尊重这点。\" <br>\
			\"那就去吧，怪胎。<br>让我看看你能保护好对你重要的东西。\""),
		"我没有" = list(FALSE, "\"呸。<br>那活着还有什么意义，嗯？\" <br>\
			\"没有要保护的旗帜，没有要实现的目标...\" <br>\
			\"你和动物有什么区别？<br>滚出我的视线。\""),
	)

	var/ammo = 6
	var/max_ammo = 6
	var/reload_time = 2 SECONDS
	var/last_reload_time = 0
	var/bloodlust = 0 //more you do repression, more damage it deals. decreases on other works.
	var/list/fighting_quotes = list(
		"来吧，怪胎！拿出你的本事！",
		"噗，尽管试试，怪胎。",
		"很好，终于有点乐子了。来吧，怪胎。",
		"你们当中总算有个带种的了。",
		"可悲。你太弱了，知道吗？",
	)

	var/list/bored_quotes = list(
		"无聊。得了吧，我们都清楚来点打斗会更好。",
		"啊，真是个懦夫。行吧，你做你的事，娘娘腔。",
		"哈欠。该死，你们这些怪胎真没劲。",
		"共党分子。他们没一个有种的，对吧？",
		"如果整天就坐着等，那把我派来干嘛？",
	)

	var/list/breach_quotes = list(
		"是时候把你们这些怪胎清除了！",
		"哈！你们完蛋了，怪胎们！",
		"你们不是对手！赶紧去死吧！",
		"吃屎吧，你们这些该死的共党！",
		"这会很有趣！",
	)

/mob/living/simple_animal/hostile/abnormality/redblooded/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, "<h1>你是热血美国人，支援型异想体。</h1><br>\
		<b>|美国之道|：当你选择至少2格外的地块时，将消耗1发弹药发射6颗弹丸，每颗造成18点伤害。<br>\
		你每2秒被动装填1发弹药，但也可以通过攻击人类或机甲来装填1发弹药。</b>")

/mob/living/simple_animal/hostile/abnormality/redblooded/AttemptWork(mob/living/carbon/human/user, work_type)
	work_damage_upper = 4 + bloodlust
	work_damage_lower = 2 + bloodlust
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		say(pick(fighting_quotes))
		bloodlust +=2
	if(bloodlust >= 6)
		icon_state = icon_furious
	else
		icon_state = "american_idle"
	return ..()

/mob/living/simple_animal/hostile/abnormality/redblooded/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(50)) //slightly higher than other TETHs, given that the counter can be raised
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/redblooded/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/redblooded/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(1)
	if(work_type != ABNORMALITY_WORK_REPRESSION)
		if(bloodlust > 0)
			bloodlust -= ( 1 + round(bloodlust / 5)) //just to keep high bloodlust from being impossibly hard to lower
		if(bloodlust == 0)
			say(pick(bored_quotes))
	return ..()

/mob/living/simple_animal/hostile/abnormality/redblooded/ZeroQliphoth(mob/living/carbon/human/user)
	say(pick(breach_quotes))
	BreachEffect()
	return

//Breach
/mob/living/simple_animal/hostile/abnormality/redblooded/proc/Reload()
	playsound(src, 'sound/weapons/gun/general/bolt_rack.ogg', 25, TRUE)
	to_chat(src, span_nicegreen("你填装霰弹枪..."))
	ammo += 1

/mob/living/simple_animal/hostile/abnormality/redblooded/Life()
	. = ..()
	if (last_reload_time < world.time - reload_time)
		last_reload_time = world.time
		if (ammo < max_ammo)
			Reload()

/mob/living/simple_animal/hostile/abnormality/redblooded/AttackingTarget(atom/attacked_target)
	if(ammo < max_ammo)
		if(isliving(attacked_target))
			Reload()
		if(ismecha(attacked_target))
			Reload()
	return ..()

/mob/living/simple_animal/hostile/abnormality/redblooded/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon_state = "american_aggro"
	GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/redblooded/MoveToTarget(list/possible_targets)
	if(ranged_cooldown <= world.time)
		OpenFire(target)
	return ..()

/mob/living/simple_animal/hostile/abnormality/redblooded/OpenFire(atom/A)
	if(get_dist(src, A) >= 2)
		if(ammo <= 0)
			to_chat(src, span_warning("没子弹了!"))
			return FALSE
		else
			ammo -= 1
			return ..()
	else
		return FALSE

//Projectiles
/obj/item/ammo_casing/caseless/true_patriot
	name = "爱国子弹"
	desc = "a true patriot casing"
	projectile_type = /obj/projectile/true_patriot
	pellets = 6
	variance = 25

/obj/projectile/true_patriot
	name = "美国弹丸"
	desc = "100% real, surplus military ammo."
	damage_type = RED_DAMAGE

	damage = 2

/obj/item/ammo_casing/caseless/rcorp_true_patriot
	name = "爱国子弹"
	desc = "a true patriot casing"
	projectile_type = /obj/projectile/rcorp_true_patriot
	pellets = 6
	variance = 25

/obj/projectile/rcorp_true_patriot
	name = "美国弹丸"
	desc = "100% real, surplus military ammo."
	damage_type = RED_DAMAGE

	damage = 4

/datum/reagent/abnormality/red_blooded
	name = "沸腾的红血"
	description = " constantly boiling. It'll burn going down but it motives you to keep fighting."
	color = "#D2042D"
	health_restore = -1
	sanity_restore = 0.2
	metabolization_rate = 0.8 * REAGENTS_METABOLISM
	stat_changes = list(0, 0, 0, 5) //damages your HP but boosts justice and lightly heals SP.


