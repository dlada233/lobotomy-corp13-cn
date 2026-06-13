// this was a mistake.
// By yours truely, Mori.
#define STATUS_EFFECT_FALSEKIND /datum/status_effect/false_kindness
/mob/living/simple_animal/hostile/abnormality/drifting_fox
	name = "流浪狐狸"
	desc = "一只毛茸茸的大狐狸，黄色的眼睛闪闪发光；破伞卡在它的背上."
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "drifting_fox"
	icon_living = "drifting_fox"
	icon_dead = "fox_egg"
	core_icon = "fox_egg"
	portrait = "drifting_fox"
	death_message = "Collapses into a glass egg"
	death_sound = 'sound/abnormalities/drifting_fox/fox_death_sound.ogg'
	pixel_x = -24
	pixel_y = -26
	base_pixel_x = -24
	base_pixel_y = -26
	del_on_death = FALSE
	maxHealth = 350
	health = 350
	rapid_melee = 2
	move_to_delay = 7
	damage_coeff = list( RED_DAMAGE = 0.9, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5 )
	melee_damage_lower = 2
	melee_damage_upper = 8
	melee_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gluttony
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/drifting_fox/fox_melee_sound.ogg'
	attack_verb_simple = "thwacks"
	attack_verb_continuous = "thwacks"
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 45,
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = list(15, 20, 25, 30, 35),
		ABNORMALITY_WORK_REPRESSION = 15,
	)
	work_damage_upper = 6
	work_damage_lower = 3
	work_damage_type = BLACK_DAMAGE
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	ego_list = list(
		/datum/ego_datum/weapon/sunshower,
		/datum/ego_datum/armor/sunshower,
	)
	gift_type = /datum/ego_gifts/sunshower
	gift_message = "狐狸从背上拔下一把伞递给你，或许是在表达谢意？"

	observation_prompt = "小巷垃圾场。<br.\
		潮湿的雨天让空气闷热难耐。<br.\
		角落堆积着破旧的雨伞。<br.\
		伞堆晃动起来。<br.\
		仔细看去，下面有只大狐狸。<br.\
		雨伞生锈的铁质伞骨深深扎进它的后背。"
	observation_choices = list(
		"抚摸狐狸" = list(TRUE, "低吼声逐渐平息。<br.\
			你再次抚摸它，<br.\
			它闭目露出愉悦神情。<br.\
			你再次抚摸它，<br.\
			它安卧于地，显得舒适。<br.\
			你再次抚摸它，<br.\
			它缩小化为雕像。"),
		"拔出雨伞" = list(FALSE, "那些雨伞似乎让它痛苦不堪。<br.\
			当你用力拔出时，带出了些许皮肉。<br.\
			狐狸尖声哀嚎，怒视着你。<br.\
			接着，它用嘴里的伞拍打你。<br.\
			似乎是在谴责你这种不计后果的解决态度。"),
	)

	var/list/pet = list()
	pet_bonus = "yips"
	var/umbrella_spawn_number = 1
	var/umbrella_spawn_time = 5 SECONDS
	var/umbrella_spawn_limit = 4
	var/list/spawned_mobs = list()
	var/initial_mobs_spawned

/mob/living/simple_animal/hostile/abnormality/drifting_fox/Login()
	. = ..()
	to_chat(src, "<h1>你扮演流浪狐狸，战斗型异想体</h1><br>\
		<b>|破旧庇护所|：损失10%生命值后，你将在周围生成破旧雨伞。\
		破旧雨伞会在你远离时传送至你身边。\
		此外，每存活一把雨伞，你都会获得小幅速度提升。<br>\
		<br>\
		|破旧雨伞|：破旧雨伞会主动攻击视野内的人类，向目标发射3x3范围AOE。\
		若目标被击中，将获得一个易伤状态，使其受到的所有BLACK伤害增加。\
		然而，雨伞被破坏时，每破坏一把你将损失5%生命值。<br></b>")

/mob/living/simple_animal/hostile/abnormality/drifting_fox/funpet(mob/petter)
	pet |= petter
	return ..()

/mob/living/simple_animal/hostile/abnormality/drifting_fox/AttemptWork(mob/living/carbon/human/user, work_type)
	if(user in pet)
		if(work_type == ABNORMALITY_WORK_ATTACHMENT)
			to_chat(user, span_notice("异想体似乎比平时更喜欢这类工作!"))
		else
			to_chat(user, span_warning("异想体似乎对你的工作选择感到不满."))
	. = ..()

/mob/living/simple_animal/hostile/abnormality/drifting_fox/WorkChance(mob/living/carbon/human/user, chance, work_type)
	if(user in pet)
		if(work_type == ABNORMALITY_WORK_ATTACHMENT)
			chance += 30
		else
			chance -= 10
		return chance
	. = ..()

/mob/living/simple_animal/hostile/abnormality/drifting_fox/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user in pet)
		pet -= user
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/drifting_fox/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/drifting_fox/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon_living = "fox_breach"
	icon_state = icon_living
	pixel_y = -6

/mob/living/simple_animal/hostile/abnormality/drifting_fox/death(gibbed)
	icon = 'ModularTegustation/Teguicons/abno_cores/he.dmi'
	pixel_x = -16
	pixel_y = 0
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/drifting_fox/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(health <= 900 && !initial_mobs_spawned)
		playsound(src, 'sound/abnormalities/drifting_fox/fox_aoe_sound.ogg', 50, FALSE, 4)
		initial_mobs_spawned = TRUE
		addtimer(CALLBACK(src, PROC_REF(UmbrellaLoop)), 30 SECONDS)
		for(var/i=4, i>=1, i--) //spawn 4 umbrellas right off the bat
			var/mob/living/simple_animal/hostile/aminion/umbrella/newmob = new(get_turf(src))
			newmob.faction = faction
			spawned_mobs+=newmob
			newmob.friend = src
			newmob.GoToFox()
			newmob.ranged_cooldown_time = rand(20,80)
			move_to_delay = clamp(move_to_delay - 1, 3, 7) //Speed up
			UpdateSpeed()

/mob/living/simple_animal/hostile/abnormality/drifting_fox/proc/UmbrellaLoop()
	listclearnulls(spawned_mobs)
	for(var/mob/living/L in spawned_mobs)
		if(L.stat == DEAD)
			spawned_mobs -= L
	if(length(spawned_mobs) >= umbrella_spawn_limit)
		return
	var/mob/living/simple_animal/hostile/aminion/umbrella/newmob = new(get_turf(src))
	newmob.faction = faction
	spawned_mobs+=newmob
	newmob.friend = src
	newmob.GoToFox()
	newmob.ranged_cooldown_time = rand(20,80)
	move_to_delay = clamp(move_to_delay - 1, 3, 7) //Speed up
	addtimer(CALLBACK(src, PROC_REF(UmbrellaLoop)), umbrella_spawn_time)

//Summons
/mob/living/simple_animal/hostile/aminion/umbrella
	name = "雨伞"
	desc = "一把破旧的伞；狐狸似乎有很多多余的东西."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "foxbrella"
	icon_living = "foxbrella"
	faction = list("hostile")
	maxHealth = 125
	health = 125
	density = FALSE
	status_flags = MUST_HIT_PROJECTILE // Allows projectiles to hit non-dense mob
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	del_on_death = FALSE
	ranged = TRUE
	ranged_cooldown_time = 3 SECONDS
	fear_level = 0
	can_affect_emergency = FALSE //they're not really minions fully
	var/teleport_cooldown_time = 10 SECONDS
	var/teleport_cooldown
	/// The drifting fox
	var/mob/living/simple_animal/hostile/abnormality/friend

/// Deal damge to the fox
/mob/living/simple_animal/hostile/aminion/umbrella/death(gibbed)
	visible_message(span_notice("[src]落在地上，伞自己闭合了!"))
	if(friend)
		friend.deal_damage(50, BLACK_DAMAGE)
		friend.move_to_delay = clamp(move_to_delay + 1, 3, 7) //Slowdown
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	return ..()

///checks if the fox is in view every 10 seconds, and if not teleports to it
/mob/living/simple_animal/hostile/aminion/umbrella/Life()
	. = ..()
	if(!friend || stat == DEAD) //for some reason life() works on death ain't that something
		return
	if(QDELETED(friend) || friend.status_flags & GODMODE) //Fox died, we're gone too
		death()
		return
	if(teleport_cooldown < world.time)
		teleport_cooldown = world.time + teleport_cooldown_time
		if(!can_see(src, friend, vision_range))
			GoToFox()

/mob/living/simple_animal/hostile/aminion/umbrella/proc/GoToFox()
	if(!friend)
		return
	var/turf/move_turf = get_step(friend, pick(1,2,4,5,6,8,9,10))
	if(!isopenturf(move_turf))
		move_turf = get_turf(friend)
	forceMove(move_turf)
	LoseTarget()

/mob/living/simple_animal/hostile/aminion/umbrella/OpenFire()
	ranged_cooldown_time = rand(20,80) //keeps them attacking asynchronously
	if(!isliving(target))
		LoseTarget()
		return
	var/turf/target_turf = get_turf(target)
	for(var/turf/L in view(1, target_turf))
		new /obj/effect/temp_visual/cult/sparks(L)
	SLEEP_CHECK_DEATH(6)
	for(var/turf/T in view(1, target_turf))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		for(var/mob/living/carbon/human/H in HurtInTurf(T, list(), 5, BLACK_DAMAGE, null, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE))
			H.apply_status_effect(STATUS_EFFECT_FALSEKIND)
	playsound(target_turf, 'sound/abnormalities/drifting_fox/fox_umbrella.ogg', 25, TRUE, 4)
	ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/aminion/umbrella/Move()
	return FALSE

/mob/living/simple_animal/hostile/aminion/umbrella/AttackingTarget(atom/attacked_target)
	if(!target)
		GiveTarget(attacked_target)
	OpenFire()
	return

/datum/status_effect/false_kindness // MAYBE the black sunder shti works this time.
	id = "false_kindness"
	duration = 2 SECONDS //lasts 2 seconds becuase this is for an AI that attacks fast as shit, its not meant to fuck you up with other things.
	alert_type = /atom/movable/screen/alert/status_effect/false_kindness
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/false_kindness
	name = "假仁慈"
	desc = "你会感受到自己所犯错误的重量."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "false_kindness" //Bit of a placeholder sprite, it works-ish so

/datum/status_effect/false_kindness/on_apply() //" Borrowed " from Ptear blade, courtesy of gong.
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner //Stolen from Ptear Blade, MAYBE works on people?
	to_chat(status_holder, span_userdanger("你感到狐狸在注视着你!"))
	status_holder.physiology.black_mod *= 1.3

/datum/status_effect/false_kindness/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_userdanger("你觉得它的目光已经抬起.")) //stolen from PT wep, but I asked so this 100% ok.
	status_holder.physiology.black_mod /= 1.3

#undef STATUS_EFFECT_FALSEKIND
