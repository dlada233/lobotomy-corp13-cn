// Bullets number defines
#define MANAGER_HP_BULLET 1
#define MANAGER_SP_BULLET 2
#define MANAGER_RED_BULLET 3
#define MANAGER_WHITE_BULLET 4
#define MANAGER_BLACK_BULLET 5
#define MANAGER_PALE_BULLET 6
#define MANAGER_YELLOW_BULLET 7
#define MANAGER_DUAL_BULLET 8
#define MANAGER_QUAD_BULLET 9
#define MANAGER_KILL_BULLET 10
GLOBAL_VAR_INIT(execution_enabled, FALSE)

/obj/machinery/computer/camera_advanced/manager
	name = "managerial camera console"
	desc = "A computer used for remotely handling a facility."
	icon_screen = "camera3"
	icon_keyboard = "generic_key"
	resistance_flags = INDESTRUCTIBLE
	var/datum/action/innate/cyclemanagerbullet/cycle
	var/datum/action/innate/firemanagerbullet/fire
	var/datum/action/innate/cyclecommand/cyclecommand
	var/datum/action/innate/managercommand/command
	var/datum/action/innate/manager_track/follow
	var/ammo = 4
	var/bullet_type = 0
	var/command_type = 1
	var/command_delay = 0.5 SECONDS
	var/command_cooldown
	//Used for limiting the amount of commands that can exist.
	var/current_commands = 0
	var/max_commands = 10
	///Variable stolen from AI. Essential for tracking feature.
	var/static/datum/trackable/track = new
	//Command Types sorted in order.
	var/list/command_types = list(
		/obj/effect/temp_visual/holo_command/command_move,
		/obj/effect/temp_visual/holo_command/command_warn,
		/obj/effect/temp_visual/holo_command/command_guard,
		/obj/effect/temp_visual/holo_command/command_heal,
		/obj/effect/temp_visual/holo_command/command_fight_a,
		/obj/effect/temp_visual/holo_command/command_fight_b,
	)

	///Costs for the bullets
	var/list/bullet_cost = list(1,1,1,1,1,1,1,1.75,3,1,)

	/// Used for radial menu; Type = list(name, desc, icon_state)
	/// List of bullets available for use are defined in lobotomy_corp subsystem
	var/list/bullet_types = alist(
		MANAGER_HP_BULLET = list(
			"name" = HP_BULLET,
			"desc" = "恢复员工HP.",
			"icon_state" = "green",
		),

		MANAGER_SP_BULLET = list(
			"name" = SP_BULLET,
			"desc" = "恢复员工SP.",
			"icon_state" = "blue",
		),


		MANAGER_RED_BULLET = list(
			"name" = RED_BULLET,
			"desc" = "给予员工红色伤害护盾.",
			"icon_state" = "red",
		),

		MANAGER_WHITE_BULLET = list(
			"name" = WHITE_BULLET,
			"desc" = "给予员工白色伤害护盾.",
			"icon_state" = "white",
		),

		MANAGER_BLACK_BULLET = list(
			"name" = BLACK_BULLET,
			"desc" = "给予员工黑色伤害护盾.",
			"icon_state" = "black",
		),

		MANAGER_PALE_BULLET = list(
			"name" = PALE_BULLET,
			"desc" = "给予员工青色伤害护盾.",
			"icon_state" = "pale",
		),

		MANAGER_YELLOW_BULLET = list(
			"name" = YELLOW_BULLET,
			"desc" = "降低异想体的移动速度.",
			"icon_state" = "yellow",
		),

		MANAGER_DUAL_BULLET = list(
			"name" = DUAL_BULLET,
			"desc" = "同时恢复员工的HP与SP.",
			"icon_state" = "cyan",
		),

		MANAGER_QUAD_BULLET = list(
			"name" = QUAD_BULLET,
			"desc" = "添加持久且能抵御所有伤害的护盾.",
			"icon_state" = "rainbow",
		),

		MANAGER_KILL_BULLET = list(
			"name" = KILL_BULLET,
			"desc" = "处决员工，只留下物品.",
			"icon_state" = "kill",
		),

	)

	/* Locked actions */
	// Unlocked by completing records core suppression
	var/datum/action/innate/swap_cells/swap

/obj/machinery/computer/camera_advanced/manager/Initialize(mapload)
	. = ..()
	GLOB.lobotomy_devices += src

	cycle = new
	fire = new
	cyclecommand = new
	command = new
	follow = new

	command_cooldown = world.time
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, PROC_REF(RechargeMeltdown))

/obj/machinery/computer/camera_advanced/manager/Destroy()
	GLOB.lobotomy_devices -= src
	return ..()

/obj/machinery/computer/camera_advanced/manager/examine(mob/user)
	. = ..()
	if(ammo)
		. += span_notice("它装载有[round(ammo)]发子弹.")

/obj/machinery/computer/camera_advanced/manager/GrantActions(mob/living/carbon/user) //sephirah console breaks off from this branch so any edits you want on both must be done manually.
	..()

	//List abilities here:
	if(cycle)
		cycle.target = src
		cycle.Grant(user)
		actions += cycle

	if(fire)
		fire.target = src
		fire.Grant(user)
		actions += fire

	if(cyclecommand)
		cyclecommand.target = src
		cyclecommand.Grant(user)
		actions += cyclecommand

	if(command)
		command.target = src
		command.Grant(user)
		actions += command

	if(follow)
		follow.target = src
		follow.Grant(user)
		actions += follow

	if(swap)
		swap.target = src
		swap.Grant(user)
		swap.selected_abno = null
		actions += swap

	RegisterSignal(user, COMSIG_MOB_CTRL_CLICKED, PROC_REF(OnHotkeyClick)) //wanted to use shift click but shift click only allowed applying the effects to my player.
	RegisterSignal(user, COMSIG_XENO_TURF_CLICK_ALT, PROC_REF(OnAltClick))
	RegisterSignal(user, COMSIG_MOB_SHIFTCLICKON, PROC_REF(ManagerExaminate))
	RegisterSignal(user, COMSIG_MOB_CTRLSHIFTCLICKON, PROC_REF(OnCtrlShiftClick))

/obj/machinery/computer/camera_advanced/manager/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/managerbullet) && ammo <= GetFacilityUpgradeValue(UPGRADE_BULLET_COUNT))
		ammo++
		to_chat(user, span_notice("你装载[O]到[src]. 现在有[ammo]发子弹储存."))
		playsound(get_turf(src), 'sound/weapons/kenetic_reload.ogg', 10, 0, 3)
		qdel(O)
		return
	..()

/obj/machinery/computer/camera_advanced/manager/remove_eye_control(mob/living/user)
	UnregisterSignal(user, list(COMSIG_MOB_CTRL_CLICKED, COMSIG_XENO_TURF_CLICK_ALT, COMSIG_MOB_SHIFTCLICKON, COMSIG_MOB_CTRLSHIFTCLICKON))
	..()

/obj/machinery/computer/camera_advanced/manager/proc/OnHotkeyClick(datum/source, atom/clicked_atom) //system control for hotkeys
	SIGNAL_HANDLER

	// No target :(
	if(!isliving(clicked_atom))
		return

	// No bullets :(
	if(ammo < bullet_cost[bullet_type])
		playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
		to_chat(source, span_warning("子弹用光."))
		return

	// AOE bullets
	if(SSlobotomy_corp.manager_bullet_area > -1)
		var/success = FALSE
		for(var/mob/living/L in range(SSlobotomy_corp.manager_bullet_area, clicked_atom))
			if(ishuman(L))
				ClickedEmployee(source, L)
				success = TRUE
			if(ishostile(L))
				ClickedAbno(source, L)
				success = TRUE
		if(success)
			ammo -= bullet_cost[bullet_type]
			to_chat(source, span_warning("<b>[ammo]</b> 发子弹剩余."))
		return

	// Non-AOE
	if(ishuman(clicked_atom) && ClickedEmployee(source, clicked_atom))
		ammo -= bullet_cost[bullet_type]
		to_chat(source, span_warning("<b>[ammo]</b> 发子弹剩余."))
		return
	if(ishostile(clicked_atom) && ClickedAbno(source, clicked_atom))
		ammo -= bullet_cost[bullet_type]
		to_chat(source, span_warning("<b>[ammo]</b> 发子弹剩余."))
		return

/obj/machinery/computer/camera_advanced/manager/proc/ClickedEmployee(mob/living/owner, mob/living/carbon/human/H) //contains carbon copy code of fire action
	if(!istype(H))
		to_chat(owner, span_warning("无效目标."))
		return FALSE

	switch(bullet_type)
		if(MANAGER_HP_BULLET)
			if(H.health >= H.maxHealth)
				playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
				to_chat(owner, span_warning("ERROR: 目标身体无需恢复."))
				return FALSE
			H.adjustBruteLoss(-GetFacilityUpgradeValue(UPGRADE_BULLET_HEAL)*H.maxHealth)
		if(MANAGER_SP_BULLET)
			if(H.sanity_lost)
				playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
				to_chat(owner, span_warning("ERROR: 目标精神太过不稳定."))
				return FALSE
			if(H.sanityhealth >= H.maxSanity)
				playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
				to_chat(owner, span_warning("ERROR: 目标精神无需稳定."))
				return FALSE
			H.adjustSanityLoss(-GetFacilityUpgradeValue(UPGRADE_BULLET_HEAL)*H.maxSanity)
		if(MANAGER_DUAL_BULLET)
			if(H.sanity_lost)
				playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
				to_chat(owner, span_warning("ERROR: 目标精神太过不稳定."))
				return FALSE
			if((H.health >= H.maxHealth) && (H.sanityhealth >= H.maxSanity))
				playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
				to_chat(owner, span_warning("ERROR: 目标身体无需治愈."))
				return FALSE
			H.adjustBruteLoss(-GetFacilityUpgradeValue(UPGRADE_BULLET_HEAL)*H.maxHealth)
			H.adjustSanityLoss(-GetFacilityUpgradeValue(UPGRADE_BULLET_HEAL)*H.maxSanity)
		if(MANAGER_RED_BULLET)
			if (H.has_status_effect(/datum/status_effect/interventionshield))
				playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
				to_chat(owner, span_warning("ERROR: 目标已拥有相同类型护盾."))
				return FALSE
			H.apply_shield(/datum/status_effect/interventionshield, shield_health = GetFacilityUpgradeValue(UPGRADE_BULLET_SHIELD_HEALTH))
		if(MANAGER_WHITE_BULLET)
			if (H.has_status_effect(/datum/status_effect/interventionshield/white))
				playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
				to_chat(owner, span_warning("ERROR: 目标已拥有相同类型护盾."))
				return FALSE
			H.apply_shield(/datum/status_effect/interventionshield/white, shield_health = GetFacilityUpgradeValue(UPGRADE_BULLET_SHIELD_HEALTH))
		if(MANAGER_BLACK_BULLET)
			if (H.has_status_effect(/datum/status_effect/interventionshield/black))
				playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
				to_chat(owner, span_warning("ERROR: 目标已拥有相同类型护盾."))
				return FALSE
			H.apply_shield(/datum/status_effect/interventionshield/black, shield_health = GetFacilityUpgradeValue(UPGRADE_BULLET_SHIELD_HEALTH))
		if(MANAGER_PALE_BULLET)
			if (H.has_status_effect(/datum/status_effect/interventionshield/pale))
				playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
				to_chat(owner, span_warning("ERROR: 目标已拥有相同类型护盾."))
				return FALSE
			H.apply_shield(/datum/status_effect/interventionshield/pale, shield_health = GetFacilityUpgradeValue(UPGRADE_BULLET_SHIELD_HEALTH))
		if(MANAGER_QUAD_BULLET)
			if (H.has_status_effect(/datum/status_effect/interventionshield/quad))
				playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
				to_chat(owner, span_warning("ERROR: 目标已拥有相同类型护盾."))
				return FALSE
			H.apply_shield(/datum/status_effect/interventionshield/quad, shield_health = GetFacilityUpgradeValue(UPGRADE_BULLET_SHIELD_HEALTH) * 2)
		if(MANAGER_YELLOW_BULLET)
			if(!owner.faction_check_mob(H))
				if (H.has_status_effect(/datum/status_effect/qliphothoverload))
					playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
					to_chat(owner, span_warning("ERROR: 目标当前正受影响."))
					return FALSE
				H.apply_status_effect(/datum/status_effect/qliphothoverload)
				if (GetFacilityUpgradeValue(UPGRADE_YELLOW_BULLET))
					H.apply_status_effect(/datum/status_effect/qliphothshred)
			else
				to_chat(owner, span_warning("WELFARE SAFETY SYSTEM ERROR: TARGET SHARES CORPORATE FACTION."))
				return FALSE
		if(MANAGER_KILL_BULLET)
			if(Execute(owner, H))
				return TRUE
			return FALSE
		else
			to_chat(owner, span_warning("ERROR: 子弹初始化失败."))
			return FALSE
	playsound(get_turf(src), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
	playsound(get_turf(H), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
	return TRUE

/obj/machinery/computer/camera_advanced/manager/proc/Execute(mob/living/owner, mob/living/carbon/human/H)
	set waitfor = FALSE
	if(!GLOB.execution_enabled) //Failsafe in case admins turn off the bullets due to a rampaging manager
		to_chat(owner, span_warning("ERROR: 子弹初始化失败 - 授权已被撤销."))
		return FALSE
	if(owner.mind.assigned_role != "Manager") //You aren't the manager!
		to_chat(owner, span_warning("ERROR: 子弹初始化失败 - 仅主管授权可用."))
		return FALSE
	if(H.mind)
		if(H.mind.assigned_role == "Sephirah" || H.mind.assigned_role == "Main Office Representative") //Too important to execute
			to_chat(owner, span_warning("ERROR: 子弹初始化失败 - 目标实体超出用户权限范围."))
			return FALSE
	if(SSmaptype.maptype == "skeld")
		to_chat(owner, span_warning("ERROR: 子弹初始化失败 - 处决弹激活故障."))
		return FALSE
	switch(tgui_alert(owner,"确定处决[H]? 管理员将受到该操作的通知，你需要为可能的后果负责.","处决单确认开火",list("Yes", "No"), 3 SECONDS))
		if("Yes")
			log_admin("[key_name(owner)] has fired an execution bullet at player [key_name(H)] who was playing as [H].")
			playsound(get_turf(src), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
			playsound(get_turf(H), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
			H.unequip_everything()
			new /obj/effect/temp_visual/execute_bullet(get_turf(H))
			QDEL_IN(H, 1)
			return TRUE
		if("No")
			to_chat(owner, span_nicegreen("你决定让[H]再多活一会..."))
			return FALSE
	return FALSE //prevents bullet loss on indecisiveness

/obj/machinery/computer/camera_advanced/manager/proc/ClickedAbno(mob/living/owner, mob/living/simple_animal/hostile/H)
	if(!istype(H))
		to_chat(owner, span_warning("无效目标."))
		return FALSE

	if(bullet_type == MANAGER_YELLOW_BULLET)
		if (H.has_status_effect(/datum/status_effect/qliphothoverload))
			playsound(get_turf(src), 'sound/weapons/empty.ogg', 10, 0, 3)
			to_chat(owner, span_warning("ERROR: 目标当前正受影响."))
			return FALSE
		H.apply_status_effect(/datum/status_effect/qliphothoverload)
		if (GetFacilityUpgradeValue(UPGRADE_YELLOW_BULLET))
			H.apply_status_effect(/datum/status_effect/qliphothshred)
		playsound(get_turf(src), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
		playsound(get_turf(H), 'ModularTegustation/Tegusounds/weapons/guns/manager_bullet_fire.ogg', 10, 0, 3)
		return TRUE

	to_chat(owner, span_warning("ERROR: 子弹初始化失败."))
	return FALSE

/obj/machinery/computer/camera_advanced/manager/proc/ManagerExaminate(mob/living/user, atom/clicked_atom)
	user.examinate(clicked_atom) //maybe put more info on the agent/abno they examine if we want to be fancy later

	if(ishuman(clicked_atom))
		var/mob/living/carbon/human/H = clicked_atom

		if (user.mind.assigned_role == "Manager" && GetFacilityUpgradeValue(UPGRADE_ARCHITECT_2))
			to_chat(user, span_notice("员工HP [H.health]."))
			to_chat(user, span_notice("员工SP [H.sanityhealth]."))
		to_chat(user, span_notice("员工等级 [get_user_level(H)]."))
		to_chat(user, span_notice("勇气等级 [get_attribute_level(H, FORTITUDE_ATTRIBUTE)]."))
		to_chat(user, span_notice("谨慎等级 [get_attribute_level(H, PRUDENCE_ATTRIBUTE)]."))
		to_chat(user, span_notice("自律等级 [get_attribute_level(H, TEMPERANCE_ATTRIBUTE)]."))
		to_chat(user, span_notice("正义等级 [get_attribute_level(H, JUSTICE_ATTRIBUTE)]."))
		return

	if(istype(clicked_atom, /mob/living/simple_animal))
		var/mob/living/simple_animal/monster = clicked_atom
		if (user.mind.assigned_role == "Manager" && GetFacilityUpgradeValue(UPGRADE_ARCHITECT_2))
			var/message = "[clicked_atom]的当前HP为 : [monster.health] \n[clicked_atom]'s resistances are :"

			var/list/damage_types = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
			for(var/i in damage_types)
				var/damage_type = i
				if(GLOB.damage_type_shuffler?.is_enabled)
					damage_type = GLOB.damage_type_shuffler.mapping_defense[i]
				var/resistance = monster.damage_coeff.getCoeff(damage_type)
				message += "\n[capitalize(i)]: [resistance]x"

			to_chat(user, span_notice(message))
			return
		var/message = "[clicked_atom]的抗性为 :"

		var/list/damage_types = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
		for(var/i in damage_types)
			var/damage_type = i
			if(GLOB.damage_type_shuffler?.is_enabled)
				damage_type = GLOB.damage_type_shuffler.mapping_defense[i]
			var/resistance = SimpleResistanceToText(monster.damage_coeff.getCoeff(damage_type))
			message += "\n[capitalize(i)]: [resistance]"

		to_chat(user, span_notice(message))

/obj/machinery/computer/camera_advanced/manager/proc/OnAltClick(mob/living/user, turf/open/T)
	var/mob/living/C = user
	if(command_cooldown <= world.time)
		for(var/obj/effect/temp_visual/holo_command/V in T)
			qdel(V)
			return
		if(current_commands >= max_commands)
			to_chat(C, span_warning("到达命令上限."))
			return
		playsound(get_turf(src), 'sound/machines/terminal_success.ogg', 8, 3, 3)
		playsound(get_turf(T), 'sound/machines/terminal_success.ogg', 8, 3, 3)
		if(command_type > 0 && command_type <= 6)
			var/thing_to_spawn = command_types[command_type]
			var/thing_spawned = new thing_to_spawn(get_turf(T))
			current_commands++
			RegisterSignal(thing_spawned, COMSIG_PARENT_QDELETING, PROC_REF(ReduceCommandAmount))
		else
			to_chat(C, span_warning("ERROR: 校准失败."))
		CommandTimer()

/obj/machinery/computer/camera_advanced/manager/proc/OnCtrlShiftClick(mob/living/user, atom/target)
	if(!istype(swap))
		return
	swap.Activate(target)

//Used in the tracking of existing commands.
/obj/machinery/computer/camera_advanced/manager/proc/ReduceCommandAmount()
	SIGNAL_HANDLER
	current_commands--

//Numerical Procs that alter variables
/obj/machinery/computer/camera_advanced/manager/proc/CommandTimer()
	command_cooldown = world.time + command_delay
	return

/obj/machinery/computer/camera_advanced/manager/proc/AlterCommandType(amount)
	command_type = command_type + amount
	return

/obj/machinery/computer/camera_advanced/manager/proc/RechargeMeltdown()
	playsound(get_turf(src), 'sound/weapons/kenetic_reload.ogg', 10, 0, 3)
	ammo = GetFacilityUpgradeValue(UPGRADE_BULLET_COUNT)

//Employee Tracking Code: Butchered AI Tracking

/*--------------------------------------------\
|Employee Tracking Code: Butchered AI Tracking|
\--------------------------------------------*/
//Shows a list of creatures that can be tracked.
/obj/machinery/computer/camera_advanced/manager/proc/TrackableCreatures()
	track.initialized = TRUE
	track.names.Cut()
	track.namecounts.Cut()
	track.humans.Cut()
	track.others.Cut()

	if(current_user.stat == DEAD)
		return list()

	for(var/i in GLOB.mob_living_list)
		var/mob/living/L = i
		if(L.stat == DEAD)
			continue
		if(!L.can_track(current_user))
			continue

		var/name = L.name
		if(name in track.names)
			continue

		if(ishuman(L))
			track.humans[name] = L
		else
			track.others[name] = L

	var/list/targets = sortList(track.humans) + sortList(track.others)

	return targets

//Proc for following a target.
/obj/machinery/computer/camera_advanced/manager/proc/MobTracking(mob/living/target)
	if(!istype(target))
		to_chat(current_user, span_warning("ERROR: 无效的追踪目标."))
		return

	if(!target || !target.can_track(current_user))
		to_chat(current_user, span_warning("目标附近没有可用摄像机."))
		return

	to_chat(current_user, span_notice("正在追踪 [target.get_visible_name()]."))
	if(eyeobj)
		//Orbit proc is essentially follow.
		eyeobj.orbit(target)
	else
		to_chat(current_user, span_notice("ERROR: 摄像机无响应."))

	/*----------\
	|Action Code|
	\----------*/
/datum/action/innate/cyclemanagerbullet
	name = "HP-N 子弹"
	desc = "能够加快员工的恢复速度."
	icon_icon = 'icons/obj/manager_bullets.dmi'
	button_icon_state = "green"

/datum/action/innate/cyclemanagerbullet/Activate()
	var/list/bullets = list()
	var/list/display_bullets = list()
	var/obj/machinery/computer/camera_advanced/manager/console = target
	for(var/i = 1 to console.bullet_types.len)
		// Missing upgrade!
		if(!GetFacilityUpgradeValue(console.bullet_types[i]["name"]))
			continue
		bullets[console.bullet_types[i]["name"]] = i
		var/image/bullet_image = image(icon = 'icons/obj/manager_bullets.dmi', icon_state = console.bullet_types[i]["icon_state"])
		display_bullets += list(console.bullet_types[i]["name"] = bullet_image)
	var/chosen_bullet = show_radial_menu(owner, owner.remote_control, display_bullets, radius = 38, require_near = FALSE)
	chosen_bullet = bullets[chosen_bullet]
	if(QDELETED(src) || QDELETED(target) || QDELETED(owner) || !chosen_bullet)
		return FALSE

	to_chat(owner, span_notice("[console.bullet_types[chosen_bullet]["name"]] bullet selected."))
	name = "[console.bullet_types[chosen_bullet]["name"]] bullet"
	desc = console.bullet_types[chosen_bullet]["desc"]
	button_icon_state = console.bullet_types[chosen_bullet]["icon_state"]
	console.bullet_type = chosen_bullet
	UpdateButtonIcon()
	playsound(get_turf(target), 'sound/weapons/kenetic_reload.ogg', 15, TRUE)

/datum/action/innate/firemanagerbullet
	name = "Fire Initialized Bullet"
	desc = "Hotkey = Ctrl + Click"
	icon_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "projectile"

/datum/action/innate/firemanagerbullet/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/carbon/human/C = owner
	var/turf/T = get_turf(C.remote_control)
	var/obj/machinery/computer/camera_advanced/manager/X = target
	var/list/valid_targets = list()
	for(var/mob/living/L in T)
		if(L.stat == DEAD)
			continue
		if(!ishuman(L) && !ishostile(L))
			continue
		valid_targets += L
	if(!LAZYLEN(valid_targets))
		to_chat(C, span_warning("No valid targets found!"))
		return FALSE
	return X.OnHotkeyClick(C, pick(valid_targets))

/datum/action/innate/cyclecommand
	name = "切换命令"
	desc = "Welfare apologizes for any complications with the technology."
	icon_icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	button_icon_state = "Move_here_wagie"
	var/button_icon1 = "Move_here_wagie"
	var/button_icon2 = "Watch_out_wagie"
	var/button_icon3 = "Guard_this_wagie"
	var/button_icon4 = "Heal_this_wagie"
	var/button_icon5 = "Fight_this_wagie1"
	var/button_icon6 = "Fight_this_wagie2"

/datum/action/innate/cyclecommand/Activate()
	var/obj/machinery/computer/camera_advanced/manager/X = target
	switch(X.command_type)
		if(0) //if 0 change to 1
			to_chat(owner, span_notice("移动图像已准备."))
			button_icon_state = button_icon1
			X.AlterCommandType(1)
		if(1)
			to_chat(owner, span_notice("警告图像已准备."))
			button_icon_state = button_icon2
			X.AlterCommandType(1)
		if(2)
			to_chat(owner, span_notice("守卫图像已准备."))
			button_icon_state = button_icon3
			X.AlterCommandType(1)
		if(3)
			to_chat(owner, span_notice("治疗图像已准备."))
			button_icon_state = button_icon4
			X.AlterCommandType(1)
		if(4)
			to_chat(owner, span_notice("低烈度战斗图像已准备."))
			button_icon_state = button_icon5
			X.AlterCommandType(1)
		if(5)
			to_chat(owner, span_notice("高烈度战斗图像已准备."))
			button_icon_state = button_icon6
			X.AlterCommandType(1)
		else
			X.AlterCommandType(-5)
			to_chat(owner, span_notice("移动图像已准备."))
			button_icon_state = button_icon1
	UpdateButtonIcon()

/datum/action/innate/managercommand
	name = "部署命令"
	desc = "快捷键 = Alt + 左键"
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "deploy_box"

/datum/action/innate/managercommand/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/C = owner
	var/mob/camera/ai_eye/remote/xenobio/E = C.remote_control
	var/obj/machinery/computer/camera_advanced/manager/X = E.origin
	var/cooldown = X.command_cooldown
	if(cooldown <= world.time)
		X.OnAltClick(C, get_turf(E))

//////////////
// Unlockables
//////////////

// Records core reward
/datum/action/innate/swap_cells
	name = "交换异想体收容单元"
	desc = "Hotkey = Ctrl + Shift + 左键"
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "vortex_ff_off"
	/// Currently selected abnormality; Next activation will do the swap
	var/datum/abnormality/selected_abno = null

/datum/action/innate/swap_cells/Activate(mob/living/simple_animal/hostile/abnormality/A = null)
	if(isnull(A))
		A = locate() in get_turf(owner.remote_control)

	if(!istype(A) || !istype(A.datum_reference) || !A.IsContained())
		to_chat(owner, span_warning("The target must be an abnormality within your containment zone!"))
		return

	if(!selected_abno)
		selected_abno = A.datum_reference
		to_chat(owner, span_notice("[A.datum_reference.name] selected as first argument for a cell swap. Activate on a second abnormality to perform."))
		return

	if(!selected_abno.SwapPlaceWith(A.datum_reference))
		to_chat(owner, span_danger("Cell swap failed! Both arguments have been reset."))
		selected_abno = null
		return
	to_chat(owner, span_notice("Cell swap between <b>[selected_abno.name] and [A.datum_reference.name]</b> was successful! Arguments reset."))
	selected_abno = null
	playsound(get_turf(target), 'sound/machines/terminal_success.ogg', 10, TRUE)

// Temp Effects

/obj/effect/temp_visual/commandMove
	icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	icon_state = "Move_here_wagie"
	duration = 150 		//15 Seconds

/obj/effect/temp_visual/commandWarn
	icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	icon_state = "Watch_out_wagie"
	duration = 150

/obj/effect/temp_visual/commandGaurd
	icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	icon_state = "Guard_this_wagie"
	duration = 150

/obj/effect/temp_visual/commandHeal
	icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	icon_state = "Heal_this_wagie"
	duration = 150

/obj/effect/temp_visual/commandFightA
	icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	icon_state = "Fight_this_wagie1"
	duration = 150

/obj/effect/temp_visual/commandFightB
	icon = 'ModularTegustation/Teguicons/lc13icons.dmi'
	icon_state = "Fight_this_wagie2"
	duration = 150

/turf/open/AltClick(mob/user)
	SEND_SIGNAL(user, COMSIG_XENO_TURF_CLICK_ALT, src)
	..()

#undef HP_BULLET
#undef SP_BULLET
#undef RED_BULLET
#undef WHITE_BULLET
#undef BLACK_BULLET
#undef PALE_BULLET
#undef YELLOW_BULLET

//Manager Camera Tracking Code
/datum/action/innate/manager_track
	name = "跟随生物"
	desc = "追踪一个生物."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "meson"

/datum/action/innate/manager_track/Activate()
	if(!target || !isliving(owner))
		return
	var/mob/living/C = owner
	var/mob/camera/ai_eye/remote/xenobio/E = C.remote_control
	var/obj/machinery/computer/camera_advanced/manager/X = E.origin

	var/target_name = input(C, "选择追踪对象", "追踪") as null|anything in X.TrackableCreatures()
	///Complicated stuff
	var/list/trackeable = list()
	trackeable += X.track.humans + X.track.others
	var/list/targets = list()
	for(var/I in trackeable)
		var/mob/M = trackeable[I]
		if(M.name == target_name)
			targets += M
	if(name == target_name)
		targets += src
	if(targets.len)
		X.MobTracking(pick(targets))

//TODO:
// Due to the sephirah console being a weaker form of manager console
// it would of been smarter to make manager a subtype of manager that had only the command
// feature. But due to that requiring mappers to replace the manager console with a new manager console
// it was safer to make this downgraded form.

/obj/machinery/computer/camera_advanced/manager/sephirah //crude and lazy but i think it may work.
	name = "sephirah监控终端"
	icon_screen = "camera2"
	ammo = 0

/obj/machinery/computer/camera_advanced/manager/sephirah/Initialize(mapload)
	. = ..()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START) //unsure if this is the most effective way of doing it.

/obj/machinery/computer/camera_advanced/manager/sephirah/GrantActions(mob/living/carbon/user)
	if(off_action)
		off_action.target = user
		off_action.Grant(user)
		actions += off_action

	if(jump_action)
		jump_action.target = user
		jump_action.Grant(user)
		actions += jump_action
	//replaces proc from camera_advance origin.

	if(cyclecommand)
		cyclecommand.target = src
		cyclecommand.Grant(user)
		actions += cyclecommand

	if(command)
		command.target = src
		command.Grant(user)
		actions += command

	if(follow)
		follow.target = src
		follow.Grant(user)
		actions += follow

	RegisterSignal(user, COMSIG_XENO_TURF_CLICK_ALT, PROC_REF(OnAltClick))
	RegisterSignal(user, COMSIG_MOB_SHIFTCLICKON, PROC_REF(ManagerExaminate))

/obj/machinery/computer/camera_advanced/manager/sephirah/ClickedEmployee()
	return

/obj/machinery/computer/camera_advanced/manager/sephirah/RechargeMeltdown()
	return

#undef MANAGER_HP_BULLET
#undef MANAGER_SP_BULLET
#undef MANAGER_RED_BULLET
#undef MANAGER_WHITE_BULLET
#undef MANAGER_BLACK_BULLET
#undef MANAGER_PALE_BULLET
#undef MANAGER_YELLOW_BULLET
#undef MANAGER_DUAL_BULLET
#undef MANAGER_QUAD_BULLET
#undef MANAGER_KILL_BULLET

/obj/machinery/computer/camera_advanced/manager/representative
	name = "代表监控终端"
	desc = "A computer used for remotely monitoring a facility."
	icon_screen = "camera1"
	icon_keyboard = "security_key"
	light_color = COLOR_SOFT_RED
	ammo = 0

/obj/machinery/computer/camera_advanced/manager/representative/Initialize(mapload)
	. = ..()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START) //unsure if this is the most effective way of doing it.

/obj/machinery/computer/camera_advanced/manager/representative/GrantActions(mob/living/carbon/user)
	if(off_action)
		off_action.target = user
		off_action.Grant(user)
		actions += off_action

	if(jump_action)
		jump_action.target = user
		jump_action.Grant(user)
		actions += jump_action
	//replaces proc from camera_advance origin.

	if(cyclecommand)
		cyclecommand.target = src
		cyclecommand.Grant(user)
		actions += cyclecommand

	if(command)
		command.target = src
		command.Grant(user)
		actions += command

	if(follow)
		follow.target = src
		follow.Grant(user)
		actions += follow

	RegisterSignal(user, COMSIG_XENO_TURF_CLICK_ALT, PROC_REF(OnAltClick))
	RegisterSignal(user, COMSIG_MOB_SHIFTCLICKON, PROC_REF(RepExaminate))

/obj/machinery/computer/camera_advanced/manager/representative/ClickedEmployee()
	return

/obj/machinery/computer/camera_advanced/manager/representative/RechargeMeltdown()
	return

/obj/machinery/computer/camera_advanced/manager/representative/proc/RepExaminate(mob/living/user, atom/clicked_atom)
	user.examinate(clicked_atom) //maybe put more info on the agent/abno they examine if we want to be fancy later
