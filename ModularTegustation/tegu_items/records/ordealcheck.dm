//Silver Watch
//Checks the infomation of the current facility.
/obj/item/records/information
	name = "记录部银表"
	desc = "一块记录部使用的银色手表，可以用来查看设施内的各种信息."
	icon_state = "watch_silver"
	// Unlike other watches, the silver watch has no cooldown
	watch_cooldown_time = 0

/obj/item/records/information/WatchAction(mob/user)
	var/time_to_abno = (SSabnormality_queue.next_abno_spawn - world.time)/10
	var/mob/living/simple_animal/hostile/abnormality/queued_abno = SSabnormality_queue.queued_abnormality

	//Abno stuff. Just in case the manager is being a bit quiet.
	to_chat(user, span_notice("当前状态:"))
	to_chat(user, span_notice("异常体数量: [SSabnormality_queue.spawned_abnos]."))
	to_chat(user, span_notice("下个异常体: [initial(queued_abno.name)]."))
	if(SSabnormality_queue.rooms_start > SSabnormality_queue.spawned_abnos)
		if(time_to_abno <= INFINITY/20)
			to_chat(user, span_notice("距离下一个异常体出现还有: [time_to_abno] 秒."))
		else
			to_chat(user, span_notice("请等待提取准备下一个异常体."))

	//PE stuff. He doesn't really need to know this but information and all that
	if(SSlobotomy_corp.box_goal != 0)	//Make sure it's not infinity
		if(SSlobotomy_corp.goal_reached)
			to_chat(user, span_notice("PE 指标已完成！</span><br><span class='notice'>当前 PE: [SSlobotomy_corp.available_box]"))
		else
			to_chat(user, span_notice("PE 目标: [SSlobotomy_corp.goal_boxes + SSlobotomy_corp.available_box] / [SSlobotomy_corp.box_goal]."))
	else
		to_chat(user, span_notice("PE 指标仍在计算中，请稍候."))

	//Ordeal stuff
	to_chat(user, span_notice("当前逆卡巴拉熔毁进度: [SSlobotomy_corp.qliphoth_meter] / [SSlobotomy_corp.qliphoth_max]."))
	if(SSlobotomy_corp.next_ordeal && (SSlobotomy_corp.qliphoth_state + 1 >= SSlobotomy_corp.next_ordeal_time))
		to_chat(user, span_notice("[SSlobotomy_corp.next_ordeal.name] 将在下一次逆卡巴拉熔毁时被发生."))
	..()
