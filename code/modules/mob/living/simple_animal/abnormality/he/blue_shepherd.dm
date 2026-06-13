//Oh boy, here I go doing a complex abnormality after staying up for too long!
//He's kinda strong for a HE, has to take out other HEs.
//His lore is that he's strong to Red buddy (who does red damage) but the trick is that they don't actually fight ;)
//He just uses Red buddy as a means to escape but in reality he loves the little guy for it.
//-Kirie Saito
/mob/living/simple_animal/hostile/abnormality/blue_shepherd
	name = "蓝袍牧羊人"
	desc = "一个穿着蓝袍子的奇怪人形生物."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "blueshep"
	icon_living = "blueshep"
	icon_dead = "blueshep_dead"
	portrait = "blue_shepherd"
	attack_sound = 'sound/weapons/slash.ogg'
	del_on_death = FALSE
	pixel_x = -8
	base_pixel_x = -8
	maxHealth = 500
	health = 500
	rapid_melee = 2
	move_force = MOVE_FORCE_NORMAL + 1 //I couldn't make it the same as the normal move_force_strong without shepherd pushing tables which looked weird
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 50,
		ABNORMALITY_WORK_REPRESSION = 30,
		"释放" = 100,
	)
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	melee_damage_lower = 6
	melee_damage_upper = 8
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	work_damage_upper = 5
	work_damage_lower = 3
	work_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/pride
	attack_verb_continuous = "cuts"
	attack_verb_simple = "cuts"
	faction = list("blueshep")
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 4

	ego_list = list(
		/datum/ego_datum/weapon/oppression,
		/datum/ego_datum/armor/oppression,
	)
	gift_type = /datum/ego_gifts/oppression
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/red_buddy = 5,
	)

	observation_prompt = "除了监视我就无事可做了? 总之，在我懒散度日时... <br>\
		恶狼正从山坡袭来. <br>唯有我能阻止它，若你放我出去，我便将你从恶狼爪下解救. <br>\
		如何，成交吗?"
	observation_choices = list(
		"你在说谎" = list(TRUE, "哼，可悲不是吗？它只等我一个，我大可随意抛弃这一切。<br>\
			像我这般无生命的造物与那条野狗本不配被爱，但它仍会永远等我。<br>可有人等你？"),
		"释放他" = list(FALSE, "明智之选，其他人无需担忧，我以尾指起誓绝不伤他们分毫."),
	)

	var/death_counter //He won't go off a timer, he'll go off deaths. Takes 8 for him.
	var/slash_current = 4
	var/slash_cooldown = 4
	var/slash_damage = 8
	var/slashing = FALSE
	var/range = 2
	var/hired = FALSE
	var/lie_chance = 30 // % chance to lie
	var/datum/abnormality/buddy //the red buddy datum linked to this shepherd
	var/mob/living/simple_animal/hostile/abnormality/red_buddy/awakened_buddy //the red buddy shepherd is currently fighting with
	var/awakened = FALSE //if shepherd has seen red buddy or not
	var/list/people_list = list() //list of people shepperd can mention
	var/buddy_hit = FALSE
	var/red_hit = FALSE // Controls Little Red Riding Hooded Mercenary's ability to be "hit" by slash attacks
	var/combat_map = FALSE
	//lines said during combat
	var/list/combat_lines = list(
		"接招吧！",
		"看这招！",
		"我要宰了你！",
		"这算关押我的代价！",
		"死吧！",
	)
	//lines shepperd say when someone's dead
	var/list/people_dead_lines = list(
		" 这么快就完蛋了？",
		" 死了？要是我在场就能帮上忙了...",
		" 死了？真可惜，我还挺喜欢他们的。",
	)
	//lines shepperd say when someone is still alive
	var/list/people_alive_lines = list(
		" 居然还活着，不过也撑不了多久。",
		" 比你强多了，需要的话我可以解决他们。",
		" 能力相当出色，可惜摊上你这队友。",
		" 要是他们早该放我自由了，你怎么就不行？",
	)
	//lines shepperd say when something has breached
	var/list/abno_breach_lines = list(
		" 突破收容了，知道我能帮忙对吧？",
		" 跑出来了，你真觉得自己能单独应付？",
		" 正在大闹特闹，你们连本职工作都做不好？",
		" 都突破收容了还浪费时间陪我？真荣幸。",
	)
	//lines shepperd say when an abno hasn't breached (yet)
	var/list/abno_safe_lines = list(
		" 和我一样关在牢里，但自由可不是这么容易剥夺的。",
		" 还没突破收容，但我可不保证会维持现状。",
		" 凭你们这工作态度还没逃出来？我可没这么好对付。",
		" 状态良好，你们没有主管监控这些吗？",
	)
	//lines shepherd say about red buddy
	var/list/red_buddy_lines = list(
		"恶狼正从山坡袭来...",
		"我说恶狼会出现撕碎地下室时，你还以为在撒谎？",
		"知道吗？那个与我相连的存在没有生命，而无生命者永远等待。",
		"那个红色家伙？它们渴望爱、拥抱和幸福的瞬间。",
		"当那'伙伴'完全认清处境时，就会化为恶狼。只有这样才能引起我的关注和照顾，多傻啊。",
	)
	var/no_counter = FALSE
	var/sidesteping = FALSE
	var/countering = FALSE
	var/counter_damage = 5
	//PLAYABLES ATTACKS
	attack_action_types = list(/datum/action/innate/abnormality_attack/toggle/sheperd_spin_toggle, /datum/action/cooldown/evade, /datum/action/cooldown/parry)

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/Login()
	. = ..()
	to_chat(src, "<h1>你扮演蓝袍牧羊人，战斗型异想体</h1><br>\
		<b>|屠戮者|：攻击时若旋转攻击冷却完毕将自动触发。\
		该攻击是以自身为中心的5x5范围AOE，造成中量黑色伤害。\
		可通过技能按钮切换旋转攻击开关。<br>\
		<br>\
		|侧移|：点击屏幕左上角按钮或使用快捷键（默认空格键）触发'闪避'能力。\
		触发后获得1秒加速并无实体化（子弹可穿透），效果结束后减速1.5秒。<br>\
		<br>\
		|反击|：点击屏幕左上角按钮或使用快捷键（默认E键）触发'反击'能力。\
		若随后1秒内受到伤害，将触发5x5范围AOE造成黑色伤害，\
		被击中的类人生物将陷入击倒状态。\
		</b>")

/datum/action/cooldown/evade
	name = "Dodge"
	icon_icon = 'ModularTegustation/Teguicons/teguicons.dmi'
	button_icon_state = "ruina_evade"
	desc = "Gain a short speed boost evade your foes!"
	cooldown_time = 30
	var/speeded_up = 2
	var/restspeed = 4
	var/speed_duration = 10
	var/weaken_duration = 15
	var/old_speed

/datum/action/cooldown/evade/Trigger()
	if(!..())
		return FALSE
	if (istype(owner, /mob/living/simple_animal/hostile/abnormality/blue_shepherd))
		var/mob/living/simple_animal/hostile/abnormality/blue_shepherd/H = owner
		old_speed = 3
		H.move_to_delay = speeded_up
		H.UpdateSpeed()
		H.sidesteping = TRUE
		H.density = FALSE
		H.no_counter = TRUE
		addtimer(CALLBACK(src, PROC_REF(slowdown)), speed_duration)
		StartCooldown()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/Moved()
	. = ..()
	if (sidesteping)
		MoveVFX()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/MoveVFX()
	set waitfor = FALSE
	var/obj/viscon_filtereffect/distortedform_trail/trail = new(src.loc,themob = src, waittime = 5)
	trail.vis_contents += src
	trail.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=2, color=rgb(0, 250, 229))
	trail.filters += filter(type = "blur", size = 3)
	animate(trail, alpha=120)
	animate(alpha = 0, time = 10)

/datum/action/cooldown/evade/proc/slowdown()
	if (istype(owner, /mob/living/simple_animal/hostile/abnormality/blue_shepherd))
		var/mob/living/simple_animal/hostile/abnormality/blue_shepherd/H = owner
		H.move_to_delay = restspeed
		H.density = TRUE
		H.sidesteping = FALSE
		addtimer(CALLBACK(src, PROC_REF(recover)), weaken_duration)
		H.UpdateSpeed()

/datum/action/cooldown/evade/proc/recover()
	if (istype(owner, /mob/living/simple_animal/hostile/abnormality/blue_shepherd))
		var/mob/living/simple_animal/hostile/abnormality/blue_shepherd/H = owner
		H.move_to_delay = old_speed
		H.no_counter = FALSE
		H.UpdateSpeed()

/datum/action/cooldown/parry
	name = "Counter"
	icon_icon = 'ModularTegustation/Teguicons/teguicons.dmi'
	button_icon_state = "hollowpoint_ability"
	desc = "Predict an attack, to deal damage to your foes!"
	cooldown_time = 100
	var/counter_duration = 10

/datum/action/cooldown/parry/Trigger()
	if(!..())
		return FALSE
	if (istype(owner, /mob/living/simple_animal/hostile/abnormality/blue_shepherd))
		var/mob/living/simple_animal/hostile/abnormality/blue_shepherd/H = owner
		if(H.no_counter)
			to_chat(H, "你正在闪避!")
			return FALSE
		else
			H.ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
			H.countering = TRUE
			H.slashing = TRUE
			H.manual_emote("举起它的剑...")
			H.color = "#26a2d4"
			playsound(H, 'sound/items/unsheath.ogg', 75, FALSE, 4)
			addtimer(CALLBACK(src, PROC_REF(endcounter)), counter_duration)
			StartCooldown()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if (countering)
		counter()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	. = ..()
	if (countering)
		counter()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/counter()
	var/list/been_hit = list()
	say(pick(combat_lines))
	playsound(src, 'sound/weapons/fixer/generic/finisher2.ogg', 75, TRUE, 2)
	for(var/turf/T in range(2, src))
		new /obj/effect/temp_visual/smash_effect(T)
		been_hit = HurtInTurf(T, been_hit, counter_damage, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, mech_damage = 15)
		for(var/mob/living/carbon/human/H in T)
			H.Knockdown(20)
	countering = FALSE

/datum/action/cooldown/parry/proc/endcounter()
	if (istype(owner, /mob/living/simple_animal/hostile/abnormality/blue_shepherd))
		var/mob/living/simple_animal/hostile/abnormality/blue_shepherd/H = owner
		H.countering = FALSE
		H.slashing = FALSE
		H.color = null
		H.ChangeResistances(list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5))

/datum/action/innate/abnormality_attack/toggle/sheperd_spin_toggle
	name = "屠戮者"
	button_icon_state = "sheperd_toggle0"
	chosen_attack_num = 2
	chosen_message = span_colossus("你不再触发屠戮者.")
	button_icon_toggle_activated = "sheperd_toggle1"
	toggle_attack_num = 1
	toggle_message = span_colossus("你将会触发屠戮者.")
	button_icon_toggle_deactivated = "sheperd_toggle0"


/mob/living/simple_animal/hostile/abnormality/blue_shepherd/Initialize()
	. = ..()
	if(IsCombatMap())
		combat_map = TRUE
		faction |= "hostile"
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(OnMobDeath)) // Alright, here we go again
	RegisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED, PROC_REF(OnNewCrew))
	//makes a list of people and abno to shit talk
	if(LAZYLEN(GLOB.mob_living_list))
		for(var/mob/living/carbon/human/H in GLOB.mob_living_list)
			if(H.stat != DEAD)
				people_list += H
	//check if red buddy is in the facility
	if(LAZYLEN(SSlobotomy_corp.all_abnormality_datums))
		for(var/datum/abnormality/A in SSlobotomy_corp.all_abnormality_datums)
			if(ispath(A.abno_path, /mob/living/simple_animal/hostile/abnormality/red_buddy))
				buddy = A
				return
	if(!buddy)
		RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_SPAWN, PROC_REF(OnAbnoSpawn)) //if red buddy isn't in the facility, we wait for him

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	UnregisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED)
	UnregisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_SPAWN)
	LAZYCLEARLIST(people_list)
	return ..()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/WorkChance(mob/living/carbon/human/user, chance)
	var/mob/living/simple_animal/hostile/abnormality/red_buddy/buddy_abno = buddy?.current
	if(buddy_abno)
		chance += (buddy_abno.suffering * 0.5) //the more red buddy suffers, the higher your work chance on shepherd is
	return chance

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	var/mob/living/simple_animal/hostile/abnormality/red_buddy/buddy_abno = buddy?.current
	if(buddy_abno?.suffering >= 40)
		user.Apply_Gift(new gift_type) //you get a free gift if you somehow made the dog suffer that much
		datum_reference.qliphoth_change(-1)
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(1)
	else if(work_type == "释放")
		hired = TRUE
		say("终于，这里面越来越闷了!")
		datum_reference.qliphoth_change(-4)
	else
		datum_reference.qliphoth_change(-1)
		SLEEP_CHECK_DEATH(10)
	if(status_flags & GODMODE)
		Lying(buddy_abno, user)
	return

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/BreachEffect(mob/living/carbon/human/user, breach_type)
	var/sighted = FALSE
	for(var/mob/living/carbon/human/L in view(4, src))
		sighted = TRUE
		break

	if(sighted && hired == FALSE)
		say("我受够你了!")
	else
		var/turf/T = pick(GLOB.xeno_spawn)
		forceMove(T)
		hired = FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/AttackingTarget(atom/attacked_target)
	. = ..()
	if(client)
		switch(chosen_attack)
			if(1)
				if(isliving(attacked_target))
					slash_current-=1
				return OpenFire()
			if(2)
				return
		return

	slash_current-=1
	if(slash_current == 0)
		slash_current = slash_cooldown
		say(pick(combat_lines))
		slashing = TRUE
		slash()
	if(awakened_buddy)
		awakened_buddy.GiveTarget(attacked_target)

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/OpenFire()
	if(slash_current == 0)
		slash_current = slash_cooldown
		say(pick(combat_lines))
		slashing = TRUE
		slash()
	..()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/death(gibbed)
	if(awakened_buddy)
		awakened_buddy.death()
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	var/mob/living/buddy_abno = buddy?.current
	if(!buddy_abno)
		return

	if(!awakened && can_see(src, buddy_abno, 10))
		awakened_buddy = buddy_abno
		awakened = TRUE //ho god ho fuck
		slash_cooldown = 3
		slash_damage = 10
		melee_damage_lower = 8
		melee_damage_upper = 10
		ChangeMoveToDelayBy(-0.5)
		maxHealth = maxHealth * 4
		set_health(health * 4)
		med_hud_set_health()
		med_hud_set_status()
		update_health_hud() //I have to do this shit manually because adjustHealth is just fucked when changing max HP
	if(!awakened_buddy)
		return

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/Move()
	if(slashing)
		return FALSE
	if(awakened_buddy)
		awakened_buddy.LoseTarget()
	return ..()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/stop_pulling()
	if(pulling == awakened_buddy) //it's tempting to make player controlled shepherd pull you forever but I'll hold off on it
		return FALSE
	..()

//stops shepherd pushing people or things he shouldn't because of his move force
/mob/living/simple_animal/hostile/abnormality/blue_shepherd/MobBump(mob/M)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/CanAttack(atom/the_target)
	if(slashing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/slash()
	if(buddy?.current?.status_flags & GODMODE)
		buddy.qliphoth_change(-1) //buddy can hear it fight
	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(range, orgin)
	for(var/i = 0 to range)
		playsound(src, 'sound/weapons/slice.ogg', 75, FALSE, 4)
		for(var/turf/T in all_turfs)
			if(get_dist(orgin, T) > i)
				continue
			addtimer(CALLBACK(src, PROC_REF(SlashHit), T, all_turfs, i, buddy_hit), (3 * (i+1)) + 0.5 SECONDS)

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/SlashHit(turf/T, list/all_turfs, slash_count, buddy_hit)
	if(stat == DEAD)
		return
	new /obj/effect/temp_visual/smash_effect(T)
	for(var/mob/living/L in HurtInTurf(T, list(), slash_damage, BLACK_DAMAGE, check_faction = combat_map, hurt_mechs = TRUE, hurt_structure = TRUE, break_not_destroy = TRUE))
		if(L == awakened_buddy && !buddy_hit)
			buddy_hit = TRUE //sometimes buddy get hit twice so we check if it got hit in this slash
			awakened_buddy.adjustHealth(700) //it would take approximatively 9 slashes to take buddy down
			break
		if(istype(L, /mob/living/simple_animal/hostile/abnormality/red_hood))
			if(!red_hit)
				red_hit = TRUE
				var/mob/living/simple_animal/hostile/abnormality/red_hood/current_red = L
				current_red.WatchIt()
			all_turfs -= T
			continue // Red doesn't get hit.
		L.deal_damage(slash_damage, BLACK_DAMAGE)
		all_turfs -= T
	if(slash_count >= range)
		buddy_hit = FALSE
		slashing = FALSE

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/OnMobDeath(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!(status_flags & GODMODE)) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(!died.ckey)
		return FALSE
	if(died.z != z)
		return FALSE
	death_counter += 1
	if(death_counter >= 2)
		death_counter = 0
		datum_reference.qliphoth_change(-1)
	return TRUE


//I put it into its own proc because it's a big chunk of code that bloat the entire work complete segment
//when shepherd has work done on him, he has a 50% chance to lie about abno breach or people being alive or dead
//mentions of red buddy are ALWAYS a lie and trigger a counter on red buddy.
/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/Lying(mob/living/simple_animal/hostile/abnormality/red_buddy/buddy_abno, mob/living/carbon/human/user)
	var/lie //if shepperd's lying or not
	if(prob(lie_chance))
		lie = TRUE
		if(buddy_abno)
			buddy_abno.lying_timer = addtimer(CALLBACK(buddy_abno, TYPE_PROC_REF(/mob/living/simple_animal/hostile/abnormality/red_buddy, ShepherdLying)), 90 SECONDS)
			buddy_abno.lying = TRUE
	else
		lie = FALSE
	if(lie && !isnull(buddy?.current) && prob(25)) //pretty unlikely to mention red buddy overall, but it's a very easy to spot "lie"
		say(pick(red_buddy_lines))
		return
	var/list/abno_list = AbnoListGen()
	if(prob(50) && LAZYLEN(abno_list)) //decide which subject to pick
		var/datum/abnormality/abno_datum = pick(abno_list)
		var/mob/living/simple_animal/hostile/abnormality/abno = abno_datum.current
		if((!(abno.status_flags & GODMODE) && !lie) || ((abno.status_flags & GODMODE) && lie))
			say(abno.name + pick(abno_breach_lines))
		else
			say(abno.name + pick(abno_safe_lines))
	else if(LAZYLEN(people_list))
		var/mob/living/carbon/human/subject = pick(people_list)
		if(isnull(subject))
			people_list -= subject
		else if(subject == user)
			say("我出狱只是时间问题，但你可以把我当成朋友而不是敌人.")
		else if((subject.stat == DEAD && !lie) || (subject.stat != DEAD && lie))
			say(subject.name + pick(people_dead_lines))
		else
			say(subject.name + pick(people_alive_lines))
	else
		say("相信我，你得放我出去!") //if he has somehow nothing to lie about

///makes a list of abno datum that can breach and aren't dead/null
/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/AbnoListGen()
	var/list/abno_list = list()
	if(LAZYLEN(SSlobotomy_corp.all_abnormality_datums))
		for(var/datum/abnormality/A in SSlobotomy_corp.all_abnormality_datums)
			if(isnull(A.current))
				continue
			if(A.name == "染红的巴迪") //this one is a special case
				continue
			if(A.current.can_breach && A.name != name)
				abno_list += A
	return abno_list

///add stuff to the list when newbies arrive and removes duplicates so the list isn't full of the same respawned guy(s)
/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/OnNewCrew(datum_source, mob/living/newbie)
	SIGNAL_HANDLER
	if(!ishuman(newbie)) //dogs stealing our job
		return
	if(LAZYLEN(people_list))
		for(var/mob/living/carbon/human/person in people_list)
			if(newbie.real_name == person.real_name)
				people_list -= person
	people_list += newbie

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/OnAbnoSpawn(datum/source, datum/abnormality/abno)
	SIGNAL_HANDLER
	if(abno.name == "染红的巴迪")
		buddy = abno
		UnregisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_SPAWN)

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/TriggerDodge()
	for(var/datum/action/cooldown/evade/A in actions)
		A.Trigger()

/mob/living/simple_animal/hostile/abnormality/blue_shepherd/proc/TriggerCounter()
	for(var/datum/action/cooldown/parry/A in actions)
		A.Trigger()
