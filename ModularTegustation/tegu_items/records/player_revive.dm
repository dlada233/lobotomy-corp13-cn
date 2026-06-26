// Copper watch
// A quick revive, but only works on intact corpses. Using it halves the user's HP.
/obj/item/records_revive
	name = "记录部绿铜怀表"
	desc = "一块高科技的手持设备，可从实时备份中恢复员工的生物数据，但需要巨大的个人代价，要求身体完整无损."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'//also lmao its called teguitems there
	icon_state = "watch_copper"
	var/energy = 0
	var/maximum_energy = 40
	w_class = WEIGHT_CLASS_SMALL

/obj/item/records_revive/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_RECORDS_1))
		. += span_notice("这块表已经升级了，充电量增加了25%.")
	. += "将此怀表佩戴在尸体或者濒死伤者上，可使其完全康复."
	. += "该设备需要40负性脑啡肽(NE)才能执行."
	. += "警告 : 这块怀表本身不稳定，使用会导致你当前的HP减半."
	. += "当前存储 [energy]/[maximum_energy] 负性脑啡肽."
	. += "当员工完成异常工作和战胜考验时，该工具会得到重新充能."

/obj/item/records_revive/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_WORK_COMPLETED, PROC_REF(WorkCharge))
	RegisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END, PROC_REF(OrdealCharge))

/obj/item/records_revive/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_WORK_COMPLETED)
	UnregisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END)
	return ..()

/obj/item/records_revive/proc/WorkCharge(SSdcs, datum_reference, user, work_type)
	SIGNAL_HANDLER
	AdjustNE(1) //Somehow there wasn't a datum

/obj/item/records_revive/proc/OrdealCharge(datum/source, datum/ordeal/O = null)
	SIGNAL_HANDLER
	if(!istype(O))
		return
	AdjustNE(round(maximum_energy / 2))
	maximum_energy += 10

/obj/item/records_revive/proc/AdjustNE(addition)
	if (GetFacilityUpgradeValue(UPGRADE_RECORDS_1))
		addition *= 1.25
	energy = clamp(energy + addition, 0, maximum_energy)

/obj/item/records_revive/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)
		return
	if(!ishuman(target))
		return
	// Check if user is Records Officer
	if(!ishuman(user))
		to_chat(user, span_warning("你无法使用它!"))
		return
	var/mob/living/carbon/human/user_human = user
	if(user_human.mind?.assigned_role != "Records Officer")
		to_chat(user, span_warning("你无法使用它!"))
		return
	var/mob/living/carbon/human/H = target
	if(H == user_human)
		to_chat(user, span_warning("你没法救你自己!"))
		return
	if(H.stat == CONSCIOUS)
		to_chat(user, span_warning("[H]状态良好!"))
		return
	// Check cooldown
	if(energy < 40)
		to_chat(user, span_warning("[src]没有足够的能量来运转."))
		return
	DoRevive(H, user)

/obj/item/records_revive/proc/DoRevive(mob/living/carbon/human/H, mob/living/carbon/human/user)
	if(!H)
		return FALSE
	H.revive(full_heal = TRUE, admin_revive = TRUE)
	H.grab_ghost()
	AdjustNE(-40)
	playsound(user, 'sound/creatures/lc13/clockhead/rewind.ogg', 50, FALSE)
	user.apply_damage((user.health * 0.5), BRUTE)
