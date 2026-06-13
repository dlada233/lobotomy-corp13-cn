/mob/living/simple_animal/hostile/abnormality/meat_lantern
	name = "陆生鮟鱇"
	desc = "你所能看到的只是一个白色的小丘，上面有两只眼睛和一朵发光的花."
	icon = 'ModularTegustation/Teguicons/64x32.dmi'
	icon_state = "lantern"
	icon_living = "lantern"
	portrait = "meat_lantern"
	maxHealth = 330
	health = 330
	base_pixel_x = -16
	pixel_x = -16
	threat_level = TETH_LEVEL
	faction = list("hostile")
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(45, 45, 50, 55, 55),
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 45,
		ABNORMALITY_WORK_REPRESSION = 30,
	)
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	can_patrol = FALSE
	can_breach = TRUE
	del_on_death = FALSE
	death_message = "在血淋淋中爆炸."
	trigger_lights = FALSE

	work_damage_upper = 3
	work_damage_lower = 1
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/sloth
	start_qliphoth = 1
	ego_list = list(
		/datum/ego_datum/weapon/lantern,
		/datum/ego_datum/armor/lantern,
	)

	gift_type = /datum/ego_gifts/lantern
	gift_message = "没有任何员工见过陆生鮟鱇的完整形态."

	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "设施里总是单调的色彩，灰墙，灰地，灰顶，连人都是灰色的。<br>\
		直到某天，你看见一朵美丽的绿色小花从地面长出，散发着微光."
	observation_choices = list(
		"触摸花瓣" = list(TRUE, "这是你见过最美的事物，你伸手轻抚花瓣，指尖传来轻痒触感，突然脚下开始震动..."),
		"呼叫安保" = list(FALSE, "如此美丽之物不应存在于都市. 你呼叫安保后匆忙返回灰色工作岗位."),
	)

	var/can_act = TRUE
	var/detect_range = 1
	var/chop_cooldown
	var/chop_cooldown_time = 4 SECONDS
	var/chop_damage = 500

/mob/living/simple_animal/hostile/abnormality/meat_lantern/PostSpawn()
	. = ..()
	med_hud_set_health() //show medhud while in containment
	med_hud_set_status()

//Cameras cant auto track it now.
/mob/living/simple_animal/hostile/abnormality/meat_lantern/can_track(mob/living/user)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/meat_lantern/PickTarget(list/Targets)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/meat_lantern/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/meat_lantern/Goto(target, delay, minimum_distance)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/meat_lantern/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/meat_lantern/FearEffect() //makes it too easy to find with a giant exclamation mark over your head
	return

/mob/living/simple_animal/hostile/abnormality/meat_lantern/death()
	. = ..()
	gib()

/mob/living/simple_animal/hostile/abnormality/meat_lantern/HasProximity(atom/movable/AM)
	if(!isliving(AM))
		return
	var/mob/living/L = AM
	if(L.stat == DEAD || faction_check_mob(L))
		return
	if(!can_act || (chop_cooldown > world.time))
		return
	INVOKE_ASYNC(src, PROC_REF(BigChop))

/mob/living/simple_animal/hostile/abnormality/meat_lantern/proc/BigChop()
	can_act = FALSE
	new /obj/effect/temp_visual/yellowsmoke(get_turf(src))
	icon = 'ModularTegustation/Teguicons/224x128.dmi'
	flick("lantern_bite_open",src)
	pixel_x = base_pixel_x - 88
	playsound(get_turf(src), 'sound/effects/ordeals/amber/midnight_out.ogg', 40)
	SLEEP_CHECK_DEATH(7)
	icon = 'ModularTegustation/Teguicons/128x128.dmi'
	flick("lantern_bite_closed", src)
	pixel_x = base_pixel_x - 40
	for(var/mob/living/L in oview(1, src))
		if(faction_check_mob(L))
			continue
		L.deal_damage(chop_damage, RED_DAMAGE)
		if(L.health < 0)
			L.gib(FALSE,TRUE,TRUE)
	SLEEP_CHECK_DEATH(2.5)
	icon = initial(icon)
	pixel_x = base_pixel_x
	can_act = TRUE
	chop_cooldown = world.time + chop_cooldown_time
	addtimer(CALLBACK(src, PROC_REF(ProximityCheck)), chop_cooldown_time)

/mob/living/simple_animal/hostile/abnormality/meat_lantern/proc/ProximityCheck()
	for(var/mob/living/L in range(1,src)) //hidden istype() call
		if(L == src)
			continue
		if(faction_check_mob(L))
			continue
		BigChop()
		return

/mob/living/simple_animal/hostile/abnormality/meat_lantern/med_hud_set_health()
	if(!IsContained())
		var/image/holder = hud_list[HEALTH_HUD]
		holder.icon_state = null
		return
	..()

/mob/living/simple_animal/hostile/abnormality/meat_lantern/med_hud_set_status()
	if(!IsContained())
		var/image/holder = hud_list[STATUS_HUD]
		holder.icon_state = null
		return
	..()

/mob/living/simple_animal/hostile/abnormality/meat_lantern/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if (get_attribute_level(user, TEMPERANCE_ATTRIBUTE) >= 60)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/meat_lantern/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/meat_lantern/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_MINING)//as funny as it sounds, this abnormality would be unreachable
		sleep(10 SECONDS)
	. = ..()
	update_icon()
	density = FALSE
	med_hud_set_health() //hides medhud
	med_hud_set_status()
	if(breach_type != BREACH_MINING)
		forceMove(pick(GLOB.xeno_spawn))
	chop_cooldown = world.time + chop_cooldown_time
	proximity_monitor = new(src, detect_range)
	return

/mob/living/simple_animal/hostile/abnormality/meat_lantern/update_icon_state()
	icon = initial(icon)
	icon_living = IsContained() ? initial(icon_state) : "lantern_breach"
	icon_state = icon_living

/obj/effect/temp_visual/yellowsmoke
	icon = 'icons/effects/96x96.dmi'
	icon_state = "smoke2"
	duration = 15
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -32
	base_pixel_y = -32
	color = COLOR_VIVID_YELLOW
