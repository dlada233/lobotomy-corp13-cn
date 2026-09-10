#define HOLOPAD_MAX_DIAL_TIME 200

#define HOLORECORD_DELAY	"delay"
#define HOLORECORD_SAY		"say"
#define HOLORECORD_SOUND	"sound"
#define HOLORECORD_LANGUAGE	"lang"
#define HOLORECORD_PRESET	"preset"
#define HOLORECORD_RENAME "rename"

#define HOLORECORD_MAX_LENGTH 200

/mob/camera/ai_eye/remote/holo/setLoc()
	. = ..()
	var/obj/machinery/holopad/H = origin
	H?.move_hologram(eye_user, loc)

/obj/machinery/holopad/remove_eye_control(mob/living/user)
	if(user.client)
		user.reset_perspective(null)
	user.remote_control = null

//this datum manages it's own references

/datum/holocall
	var/mob/living/user	//the one that called
	var/obj/machinery/holopad/calling_holopad	//the one that sent the call
	var/obj/machinery/holopad/connected_holopad	//the one that answered the call (may be null)
	var/list/dialed_holopads	//all things called, will be cleared out to just connected_holopad once answered

	var/mob/camera/ai_eye/remote/holo/eye	//user's eye, once connected
	var/obj/effect/overlay/holo_pad_hologram/hologram	//user's hologram, once connected
	var/datum/action/innate/end_holocall/hangup	//hangup action

	var/call_start_time
	var/head_call = FALSE //calls from a head of staff autoconnect, if the receiving pad is not secure.

//creates a holocall made by `requester` from `calling_pad` to `callees`
/datum/holocall/New(mob/living/requester, obj/machinery/holopad/calling_pad, list/callees, elevated_access = FALSE)
	call_start_time = world.time
	user = requester
	calling_pad.outgoing_call = src
	calling_holopad = calling_pad
	head_call = elevated_access
	dialed_holopads = list()

	for(var/I in callees)
		var/obj/machinery/holopad/H = I
		if(!QDELETED(H) && H.is_operational)
			dialed_holopads += H
			if(head_call)
				if(H.secure)
					calling_pad.say("Auto-connection refused, falling back to call mode.")
					H.say("Incoming call.")
				else
					H.say("Incoming connection.")
			else
				H.say("Incoming call.")
			LAZYADD(H.holo_calls, src)

	if(!dialed_holopads.len)
		calling_pad.say("Connection failure.")
		qdel(src)
		return

	testing("Holocall started")

//cleans up ALL references :)
/datum/holocall/Destroy()
	QDEL_NULL(hangup)

	if(!QDELETED(eye))
		QDEL_NULL(eye)

	if(connected_holopad && !QDELETED(hologram))
		hologram = null
		connected_holopad.clear_holo(user)

	user = null

	//Hologram survived holopad destro
	if(!QDELETED(hologram))
		hologram.HC = null
		QDEL_NULL(hologram)

	for(var/I in dialed_holopads)
		var/obj/machinery/holopad/H = I
		LAZYREMOVE(H.holo_calls, src)
	dialed_holopads.Cut()

	if(calling_holopad)
		calling_holopad.calling = FALSE
		calling_holopad.outgoing_call = null
		calling_holopad.SetLightsAndPower()
		calling_holopad = null
	if(connected_holopad)
		connected_holopad.SetLightsAndPower()
		connected_holopad = null

	testing("Holocall destroyed")

	return ..()

//Gracefully disconnects a holopad `H` from a call. Pads not in the call are ignored. Notifies participants of the disconnection
/datum/holocall/proc/Disconnect(obj/machinery/holopad/H)
	testing("Holocall disconnect")
	if(H == connected_holopad)
		var/area/A = get_area(connected_holopad)
		calling_holopad.say("[A] holopad disconnected.")
	else if(H == calling_holopad && connected_holopad)
		connected_holopad.say("[user] disconnected.")

	ConnectionFailure(H, TRUE)

//Forcefully disconnects a holopad `H` from a call. Pads not in the call are ignored.
/datum/holocall/proc/ConnectionFailure(obj/machinery/holopad/H, graceful = FALSE)
	testing("Holocall connection failure: graceful [graceful]")
	if(H == connected_holopad || H == calling_holopad)
		if(!graceful && H != calling_holopad)
			calling_holopad.say("Connection failure.")
		qdel(src)
		return

	LAZYREMOVE(H.holo_calls, src)
	dialed_holopads -= H
	if(!dialed_holopads.len)
		if(graceful)
			calling_holopad.say("Call rejected.")
		testing("No recipients, terminating")
		qdel(src)

//Answers a call made to a holopad `H` which cannot be the calling holopad. Pads not in the call are ignored
/datum/holocall/proc/Answer(obj/machinery/holopad/H)
	testing("Holocall answer")
	if(H == calling_holopad)
		CRASH("How cute, a holopad tried to answer itself.")

	if(!(H in dialed_holopads))
		return

	if(connected_holopad)
		CRASH("Multi-connection holocall")

	for(var/I in dialed_holopads)
		if(I == H)
			continue
		Disconnect(I)

	for(var/I in H.holo_calls)
		var/datum/holocall/HC = I
		if(HC != src)
			HC.Disconnect(H)

	connected_holopad = H

	if(!Check())
		return

	calling_holopad.calling = FALSE
	hologram = H.activate_holo(user)
	hologram.HC = src

	//eyeobj code is horrid, this is the best copypasta I could make
	eye = new
	eye.origin = H
	eye.eye_initialized = TRUE
	eye.eye_user = user
	eye.name = "Camera Eye ([user.name])"
	user.remote_control = eye
	user.reset_perspective(eye)
	eye.setLoc(H.loc)

	hangup = new(eye, src)
	hangup.Grant(user)
	playsound(H, 'sound/machines/ping.ogg', 100)
	H.say("Connection established.")

//Checks the validity of a holocall and qdels itself if it's not. Returns TRUE if valid, FALSE otherwise
/datum/holocall/proc/Check()
	for(var/I in dialed_holopads)
		var/obj/machinery/holopad/H = I
		if(!H.is_operational)
			ConnectionFailure(H)

	if(QDELETED(src))
		return FALSE

	. = !QDELETED(user) && !user.incapacitated() && !QDELETED(calling_holopad) && calling_holopad.is_operational && user.loc == calling_holopad.loc

	if(.)
		if(!connected_holopad)
			. = world.time < (call_start_time + HOLOPAD_MAX_DIAL_TIME)
			if(!.)
				calling_holopad.say("No answer received.")

	if(!.)
		testing("Holocall Check fail")
		qdel(src)

/datum/action/innate/end_holocall
	name = "End Holocall"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "camera_off"
	var/datum/holocall/hcall

/datum/action/innate/end_holocall/New(Target, datum/holocall/HC)
	..()
	hcall = HC

/datum/action/innate/end_holocall/Activate()
	hcall.Disconnect(hcall.calling_holopad)


//RECORDS
/datum/holorecord
	var/caller_name = "Unknown" //requester name
	var/image/caller_image
	var/list/entries = list()
	var/language = /datum/language/common //Initial language, can be changed by HOLORECORD_LANGUAGE entries

/datum/holorecord/proc/set_caller_image(mob/user)
	var/olddir = user.dir
	user.setDir(SOUTH)
	caller_image = image(user)
	user.setDir(olddir)

/obj/item/disk/holodisk
	name = "holorecord disk"
	desc = "Stores recorder holocalls."
	icon_state = "holodisk"
	obj_flags = UNIQUE_RENAME
	custom_materials = list(/datum/material/iron = 100, /datum/material/glass = 100)
	var/datum/holorecord/record
	//Preset variables
	var/preset_image_type
	var/preset_record_text

/obj/item/disk/holodisk/Initialize(mapload)
	. = ..()
	if(preset_record_text)
		INVOKE_ASYNC(src, PROC_REF(build_record))

/obj/item/disk/holodisk/Destroy()
	QDEL_NULL(record)
	return ..()

/obj/item/disk/holodisk/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/disk/holodisk))
		var/obj/item/disk/holodisk/holodiskOriginal = W
		if (holodiskOriginal.record)
			if (!record)
				record = new
			record.caller_name = holodiskOriginal.record.caller_name
			record.caller_image = holodiskOriginal.record.caller_image
			record.entries = holodiskOriginal.record.entries.Copy()
			record.language = holodiskOriginal.record.language
			to_chat(user, span_notice("You copy the record from [holodiskOriginal] to [src] by connecting the ports!"))
			name = holodiskOriginal.name
		else
			to_chat(user, span_warning("[holodiskOriginal] has no record on it!"))
	..()

/obj/item/disk/holodisk/proc/build_record()
	record = new
	var/list/lines = splittext(preset_record_text,"\n")
	for(var/line in lines)
		var/prepared_line = trim(line)
		if(!length(prepared_line))
			continue
		var/splitpoint = findtext(prepared_line," ")
		if(!splitpoint)
			continue
		var/command = copytext(prepared_line, 1, splitpoint)
		var/value = copytext(prepared_line, splitpoint + length(prepared_line[splitpoint]))
		switch(command)
			if("DELAY")
				var/delay_value = text2num(value)
				if(!delay_value)
					continue
				record.entries += list(list(HOLORECORD_DELAY,delay_value))
			if("NAME")
				if(!record.caller_name)
					record.caller_name = value
				else
					record.entries += list(list(HOLORECORD_RENAME,value))
			if("SAY")
				record.entries += list(list(HOLORECORD_SAY,value))
			if("SOUND")
				record.entries += list(list(HOLORECORD_SOUND,value))
			if("LANGUAGE")
				var/lang_type = text2path(value)
				if(ispath(lang_type,/datum/language))
					record.entries += list(list(HOLORECORD_LANGUAGE,lang_type))
			if("PRESET")
				var/preset_type = text2path(value)
				if(ispath(preset_type,/datum/preset_holoimage))
					record.entries += list(list(HOLORECORD_PRESET,preset_type))
	if(!preset_image_type)
		record.caller_image = image('icons/mob/animal.dmi',"old")
	else
		var/datum/preset_holoimage/H = new preset_image_type
		record.caller_image = H.build_image()

//These build requester image from outfit and some additional data, for use by mappers for ruin holorecords
/datum/preset_holoimage
	var/nonhuman_mobtype //Fill this if you just want something nonhuman
	var/outfit_type
	var/species_type = /datum/species/human

/datum/preset_holoimage/proc/build_image()
	if(nonhuman_mobtype)
		if(nonhuman_mobtype == "angela")
			. = image('icons/mob/animal.dmi',"angela")
		else
			var/mob/living/L = nonhuman_mobtype
			. = image(initial(L.icon),initial(L.icon_state))
	else
		var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy("HOLODISK_PRESET")
		if(species_type)
			mannequin.set_species(species_type)
		if(outfit_type)
			mannequin.equipOutfit(outfit_type,TRUE)
		mannequin.setDir(SOUTH)
		COMPILE_OVERLAYS(mannequin)
		. = image(mannequin)
		unset_busy_human_dummy("HOLODISK_PRESET")

/obj/item/disk/holodisk/example
	preset_image_type = /datum/preset_holoimage/clown
	preset_record_text = {"
	NAME Clown
	DELAY 10
	SAY Why did the chaplain cross the maint ?
	DELAY 20
	SAY He wanted to get to the other side!
	SOUND clownstep
	DELAY 30
	LANGUAGE /datum/language/narsie
	SAY Helped him get there!
	DELAY 10
	SAY ALSO IM SECRETLY A GORILLA
	DELAY 10
	PRESET /datum/preset_holoimage/gorilla
	NAME Gorilla
	LANGUAGE /datum/language/common
	SAY OOGA
	DELAY 20"}

/datum/preset_holoimage/engineer
	outfit_type = /datum/outfit/job/engineer

/datum/preset_holoimage/engineer/rig
	outfit_type = /datum/outfit/job/engineer/gloved/rig

/datum/preset_holoimage/engineer/ce
	outfit_type = /datum/outfit/job/ce

/datum/preset_holoimage/engineer/ce/rig
	outfit_type = /datum/outfit/job/engineer/gloved/rig

/datum/preset_holoimage/engineer/atmos
	outfit_type = /datum/outfit/job/atmos

/datum/preset_holoimage/engineer/atmos/rig
	outfit_type = /datum/outfit/job/engineer/gloved/rig

/datum/preset_holoimage/researcher
	outfit_type = /datum/outfit/job/scientist

/datum/preset_holoimage/captain
	outfit_type = /datum/outfit/job/captain

/datum/preset_holoimage/nanotrasenprivatesecurity
	outfit_type = /datum/outfit/nanotrasensoldiercorpse2

/datum/preset_holoimage/gorilla
	nonhuman_mobtype = /mob/living/simple_animal/hostile/gorilla

/datum/preset_holoimage/corgi
	nonhuman_mobtype = /mob/living/simple_animal/pet/dog/corgi

/datum/preset_holoimage/clown
	outfit_type = /datum/outfit/job/clown

/datum/preset_holoimage/angela
	nonhuman_mobtype = "angela"

/obj/item/disk/holodisk/donutstation/whiteship
	name = "Blackbox Print-out #DS024"
	desc = "A holodisk containing the last viable recording of DS024's blackbox."
	preset_image_type = /datum/preset_holoimage/engineer/ce
	preset_record_text = {"
	NAME Geysr Shorthalt
	SAY Engine renovations complete and the ships been loaded. We all ready?
	DELAY 25
	PRESET /datum/preset_holoimage/engineer
	NAME Jacob Ullman
	SAY Lets blow this popsicle stand of a station.
	DELAY 20
	PRESET /datum/preset_holoimage/engineer/atmos
	NAME Lindsey Cuffler
	SAY Uh, sir? Shouldn't we call for a secondary shuttle? The bluespace drive on this thing made an awfully weird noise when we jumped here..
	DELAY 30
	PRESET /datum/preset_holoimage/engineer/ce
	NAME Geysr Shorthalt
	SAY Pah! Ship techie at the dock said to give it a good few kicks if it started acting up, let me just..
	DELAY 25
	SOUND punch
	SOUND sparks
	DELAY 10
	SOUND punch
	SOUND sparks
	DELAY 10
	SOUND punch
	SOUND sparks
	SOUND warpspeed
	DELAY 15
	PRESET /datum/preset_holoimage/engineer/atmos
	NAME Lindsey Cuffler
	SAY Uhh.. is it supposed to be doing that??
	DELAY 15
	PRESET /datum/preset_holoimage/engineer/ce
	NAME Geysr Shorthalt
	SAY See? Working as intended. Now, are we all ready?
	DELAY 10
	PRESET /datum/preset_holoimage/engineer
	NAME Jacob Ullman
	SAY Is it supposed to be glowing like that?
	DELAY 20
	SOUND explosion

	"}

/obj/item/disk/holodisk/ruin/snowengieruin
	name = "Blackbox Print-out #EB412"
	desc = "A holodisk containing the last moments of EB412. There's a bloody fingerprint on it."
	preset_image_type = /datum/preset_holoimage/engineer
	preset_record_text = {"
	NAME Dave Tundrale
	SAY Maria, how's Build?
	DELAY 10
	NAME Maria Dell
	PRESET /datum/preset_holoimage/engineer/atmos
	SAY It's fine, don't worry. I've got Plastic on it. And frankly, i'm kinda busy with, the, uhhm, incinerator.
	DELAY 30
	NAME Dave Tundrale
	PRESET /datum/preset_holoimage/engineer
	SAY Aight, wonderful. The science mans been kinda shit though. No RCDs-
	DELAY 20
	NAME Maria Dell
	PRESET /datum/preset_holoimage/engineer/atmos
	SAY Enough about your RCDs. They're not even that important, just bui-
	DELAY 15
	SOUND explosion
	DELAY 10
	SAY Oh, shit!
	DELAY 10
	PRESET /datum/preset_holoimage/engineer/atmos/rig
	LANGUAGE /datum/language/narsie
	NAME Unknown
	SAY RISE, MY LORD!!
	DELAY 10
	LANGUAGE /datum/language/common
	NAME Plastic
	PRESET /datum/preset_holoimage/engineer/rig
	SAY Fuck, fuck, fuck!
	DELAY 20
	SAY It's loose! CALL THE FUCKING SHUTT-
	DELAY 10
	PRESET /datum/preset_holoimage/corgi
	NAME Blackbox Automated Message
	SAY Connection lost. Dumping audio logs to disk.
	DELAY 50"}

//Tutorial Holodisks
/obj/item/disk/holodisk/tutorial
	preset_image_type = /datum/preset_holoimage/angela

/obj/item/disk/holodisk/tutorial/build_record()
	..()
	record.caller_name = "Angela"

/obj/item/disk/holodisk/tutorial/tutorialintro
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 你好，员工，欢迎来到LC13入职培训程序。
	DELAY 40
	SAY 如果你已经了解SS13物品栏和移动控制的基础知识，请取下你的背包，爬到塑料帘下面。
	DELAY 45
	SAY 否则，使用WASD键移动，进入前方的传送门。
	DELAY 30
	SAY 如果你无法移动，可能需要按TAB键进入热键模式。检查屏幕底部的文本栏，确保它没有变色。
	DELAY 50"}

/obj/item/disk/holodisk/tutorial/basicmechanic1
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY SS13的一个关键机制是使用手部系统与物体互动。你有左右两个手部槽位，可以持有物品。
	DELAY 40
	SAY 你可以用空手或手持物品点击物体来与环境互动。
	DELAY 35
	SAY 试着用空手点击附近的物体，看看它们有什么作用。你需要站在它们旁边才能使用。
	DELAY 45
	SAY 如果你当前持有物品而无法与物体互动，按Q键丢弃物品。
	DELAY 40
	SAY 大多数机器只能空手操作。例如，你可以通过点击全息垫来手动开始和结束我的信息。
	DELAY 50"}

/obj/item/disk/holodisk/tutorial/basicmechanic2
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 这个区域将教你物品使用的基础知识。
	DELAY 25
	SAY 用当前手点击物品将其拾起。你需要站在物品旁边才能做到。
	DELAY 45
	SAY 你可以按X键切换当前手。当前手会有边框高亮显示。
	DELAY 45
	SAY 点击当前手中的物品或按Z键将“使用手持物品”。
	DELAY 40
	SAY 如果单个格子上有多个物品，右键点击或Alt+点击该格子以查看那里的所有物品。
	DELAY 50
	SAY 使用Shift+中键点击来指向物体。这在告诉其他玩家你想让他们看什么时很有用。
	DELAY 50"}

/obj/item/disk/holodisk/tutorial/basicmechanic3
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 这个区域将教你物品栏的基础知识。
	DELAY 25
	SAY 要查看所有装备槽位，请点击屏幕左下角的背包图标。每个槽位可以存放特定类型的物品。
	DELAY 50
	SAY 当前手持物品时，点击槽位或容器以存放该物品。
	DELAY 40
	SAY 按E键将当前手中的物品装备到可用槽位。
	DELAY 40
	SAY 用空手点击手持的存储物品以查看其内容。
	DELAY 40
	SAY 你也可以通过点击拖拽存储物品的图标到你的<span class='bold'>图标</span>上来做到这一点。
	DELAY 40
	SAY 要卸下背包等存储物品，请点击拖拽该物品的图标到<span class='bold'>手部槽位</span>上。
	DELAY 45"}

/obj/item/disk/holodisk/tutorial/basicmechanic4
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 按T键说话。
	DELAY 20
	SAY 要在公共无线电频道说话，在发言前输入;，例如<span class='italics'>; 你好，世界！</span>。
	DELAY 40
	SAY 不过，由于我们不为实习生提供无线电耳机，这样做不会有任何作用。
	DELAY 30
	SAY 像麦克风这样的物品在手持时可以改变你说话的方式。测试一下。
	DELAY 35
	SAY 当你熟悉控制后，从背部槽位取下背包，归还所有物品，然后继续。
	DELAY 50"}

/obj/item/disk/holodisk/tutorial/basicmechanic5
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 要检查物体并阅读其描述，右键点击物体并在下拉菜单中选择“检查”。
	DELAY 45
	SAY 你也可以通过Shift+点击物品来检查。
	DELAY 35
	SAY 这个区域的所有结构你都可以移动到上面。要做到这一点，在静止时点击拖拽你的角色图标到<span class='bold'>物体</span>上。
	DELAY 50
	SAY 一些物体，比如睡眠舱，有特定功能的快捷方式。检查它们以了解它们能做什么。
	DELAY 45
	SAY 在你完成这里的结构后，点击拖拽你的玩家角色到挡住出口的桌子上。
	DELAY 35"}

/obj/item/disk/holodisk/tutorial/basicmechanic6
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 找到屏幕右下角带有符号的四格网格。
	DELAY 40
	SAY 这些方格是“意图”，影响你使用物品和<span class='bold'>空手</span>的方式。
	DELAY 40
	SAY 你可以使用数字键1-4或点击方格来循环切换它们。
	DELAY 40
	SAY 帮助意图（绿色）允许你扶起其他人并给予拥抱。
	DELAY 35
	SAY 解除武装意图（蓝色）将物体和人推开，可能导致他们掉落物品。
	DELAY 40
	SAY 抓取意图（黄色）抓住人并将物体拖在身后。通过反复点击抓取意图来增加抓取力度。
	DELAY 50
	SAY 可以使用“抵抗”按钮或按键B来挣脱抓取。
	DELAY 35
	SAY 伤害意图（红色）允许你出拳。它还确保你会用所持物品进行攻击。
	DELAY 40
	SAY 当另一名玩家撞到你时，如果你处于帮助意图，他们会与你交换位置。其他意图则会阻挡他们的移动。
	DELAY 40
	SAY 按键盘上的2切换到解除武装意图，然后点击挡住你去路的箱子将其推开。
	DELAY 40"}

/obj/item/disk/holodisk/tutorial/basicmechanic7
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 你已经到达SS13机制训练的最后一节。
	DELAY 30
	SAY 你可能已经注意到意图旁边还有额外的按钮和窗口。
	DELAY 35
	SAY 这些用于触发某些动作并改变你的互动方式，例如你瞄准的身体部位。
	DELAY 45
	SAY 要爬到某些物体或其他人下面，使用“休息”按钮或按键U躺在地上。
	DELAY 40
	SAY 当你爬行时，除非投射物专门瞄准你，否则无法击中你。
	DELAY 30
	SAY 现在，爬到塑料帘下面，进入传送门，继续脑叶公司专属训练。
	DELAY 40"}

/obj/item/disk/holodisk/tutorial/stats
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 在脑叶公司，我们主要关注员工的4项关键属性。它们是勇气、谨慎、自律和正义。
	DELAY 50
	SAY 要查看你的属性，打开右上角的IC标签页，点击“查看属性”。
	DELAY 50
	SAY 勇气增加你的最大生命值（HP），谨慎增加你的最大精神值（SP）。
	DELAY 40
	SAY 自律提供额外的工作成功率和更快的工作速度。提高它能提升执行工作的效率。
	DELAY 55
	SAY 正义增加你的移动速度和你的<span class='bold'>近战</span>伤害。
	DELAY 40
	SAY 每项属性都有两个重要的数值需要关注：属性值和属性等级。
	DELAY 40
	SAY 属性值就是数值本身，而属性等级用罗马数字表示，从20之后每增加20提升一级。
	DELAY 50
	SAY 与异常体的许多互动都取决于这些数值，一个等级的差距往往就是生与死的区别。
	DELAY 55
	SAY 所有这些属性共同决定了一个总体员工等级，它主要涉及与恐惧相关的互动。
	DELAY 50"}

/obj/item/disk/holodisk/tutorial/info1
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 脑叶公司是一家能源公司，我们通过作用于被称为“异想体”的实体来生产能源。
	DELAY 45
	SAY 有四种主要的工作类型：本能、洞察、沟通和压迫。
	DELAY 40
	SAY 每种工作类型的<span class='bold'>成功率</span>显示为极低/低/一般/高/极高。这可以通过工作修正值来调整，比如你的自律。
	DELAY 45
	SAY 完成每项工作的时间取决于异想体可以产生的最大PE-box数量和工作修正值。
	DELAY 50
	SAY 工作结束时，工作结果将根据产生的PE-box产量分为好、一般或差。
	DELAY 45
	SAY 某些异想体还可能具有特殊工作类型。阅读我们关于异想体行为的文档非常重要。
	DELAY 50"}

/obj/item/disk/holodisk/tutorial/info2
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 每个异想体都有指定的危险等级、工作偏好和独特的怪异能力，可能对生存构成危险。
	DELAY 45
	SAY 危险等级从最不危险到最危险依次为：ZAYIN、TETH、HE、WAW，最后是ALEPH。
	DELAY 40
	SAY 对异想体工作会招致恐惧惩罚，根据你的员工等级与危险等级之间的差距，扣除你总精神值的一定百分比。
	DELAY 55
	SAY 大多数异想体还有一个逆卡巴拉计数器，可以在检查它们的控制台时看到。
	DELAY 35
	SAY 当逆卡巴拉计数器降至0时，异想体会对设施产生负面影响。这通常包括突破收容并变得敌对。
	DELAY 55
	SAY 要查找关于异想体的信息，请在我们设施的<span class='italics'>记录部</span>中找到你在这个房间里看到的柜子。
	DELAY 50"}

/obj/item/disk/holodisk/tutorial/works
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 工作不仅会产生能源，这个过程还会提升你的属性，让你成为更优秀的员工。
	DELAY 35
	SAY 本能工作提升你的勇气。
	DELAY 25
	SAY 洞察工作提升你的谨慎。
	DELAY 25
	SAY 沟通工作提升你的自律。
	DELAY 25
	SAY 压迫工作提升你的正义。
	DELAY 30
	SAY 根据异常体的危险等级，工作能提升的属性有上限（20 + 20 × 危险等级）。
	DELAY 45
	SAY 例如，ZAYIN最多只能将你的属性提升到40，TETH则到60。随着你经验增长，你必须转向更危险的异常体。
	DELAY 55
	SAY 建议优先提升自律，因为它直接影响你的工作能力，但并非强制要求。
	DELAY 40"}

/obj/item/disk/holodisk/tutorial/ordeal
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 每隔几次熔毁，就会发生一次“考验”。这些全设施范围的挑战是脑叶公司轮班的进程标志。
	DELAY 45
	SAY 当考验即将来临时，考验监视器上会出现一个图标，标明考验的类型。
	DELAY 40
	SAY 考验开始后，设施周围会出现一组敌人，需要及时击败它们。
	DELAY 45
	SAY 员工<span class='bold'>必须</span>停止工作来应对考验，因为它们会严重削弱设施的功能。
	DELAY 55
	SAY 考验按颜色分类：琥珀色、血色、绿色、靛蓝、钢铁、紫罗兰和白色。
	DELAY 35
	SAY 琥珀考验拥有压倒性的虫群。绯红考验在死亡时触发效果。绿色考验擅长战斗。
	DELAY 45
	SAY 靛蓝考验利用尸体恢复力量。钢铁考验专注于控制重要位置。紫罗兰考验是静止的威胁，会降低逆卡巴拉计数器。
	DELAY 55
	最后，白色考验使用专门造成特定伤害类型的强大敌人。
	DELAY 35
	SAY 考验的层级如下：黎明、正午、黄昏和午夜。它们会越来越致命，也越来越难以应对。
	DELAY 50"}

/obj/item/disk/holodisk/tutorial/damage
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 有四种伤害类型，用颜色区分：红色Red、白色White、黑色Black和蓝色Pale。
	DELAY 40
	SAY 红色攻击对你的生命值造成伤害。当生命值降至0时，你会死亡。
	DELAY 45
	SAY 白色攻击对你的精神值造成伤害。当精神值耗尽时，你会发疯并失去对角色的控制。
	DELAY 50
	SAY 发疯的员工会对设施做出有害行为。用白色伤害攻击他们可以恢复他们的精神值。
	DELAY 55
	SAY 黑色攻击同时对你的生命值和精神值造成伤害。
	DELAY 45
	SAY 蓝色攻击造成你最大生命值一定百分比的伤害，无论你的最大生命值有多高。
	DELAY 45"}

/obj/item/disk/holodisk/tutorial/ego
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 当员工成功完成工作后，脑叶公司会以PE-box的形式收集产生的能源。
	DELAY 45
	SAY 这些PE-box可以用来生产与对应异想体相关的特殊装备，称为E.G.O.。
	DELAY 45
	SAY 每件E.G.O.都有独特的伤害/抗性、属性要求和特殊特性。检查它们以查看其品质。
	DELAY 50
	SAY E.G.O.护甲对伤害类型有抗性，检查时可以通过标签看到。每点数值代表10%的减免。
	DELAY 55
	SAY 要穿戴E.G.O.护甲，首先用空手取下你o_clothing槽位中的护甲背心。
	DELAY 45
	SAY 然后，手持E.G.O.护甲，在静止时点击你的o_clothing槽位。
	DELAY 45
	SAY E.G.O.武器存放在腰带和套装储物槽中。小型E.G.O.武器还可以存放在E.G.O.武器腰带中。
	DELAY 50
	SAY E.G.O.可以从我们设施<span class='italics'>研发部</span>的控制台获取。
	DELAY 45
	SAY 提醒一下，E.G.O.轻武器腰带不适用于教程E.G.O.。
	DELAY 40
	SAY 从附近的架子上装备一套E.G.O.护甲和武器。你很快就会需要它们。
	DELAY 40"}

/obj/item/disk/holodisk/tutorial/mainroom
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 入职培训最重要的部分就在前方。
	DELAY 30
	SAY 你将开始与一些简单的异常体工作。它们的记录可以在这里以及各自的收容单元中找到。
	DELAY 50
	SAY 像这个房间这样的主部门房间有一个再生器，可以恢复生命值和精神值。受伤时务必回到这里。
	DELAY 50
	SAY 当你第一次目击异常体突破收容时，你会遭受“恐惧”，受到的精神伤害与它的威胁等级和你的员工等级之间的差距成正比。
	DELAY 55
	SAY 异常体会造成一种伤害类型，并对每种伤害类型有不同抗性。阅读它们的记录，以便在镇压时加以利用。
	DELAY 50
	SAY <span class='warning'>记住，工作期间不要移动。</span> 否则你将自动失败，失去所有已产生的PE，并根据剩余工作量受到伤害。
	DELAY 55
	SAY 如有必要，比如你因外部威胁而面临直接危险，可以利用这一特性紧急脱离。
	DELAY 40
	SAY 完成工作会提升你的属性，你可以通过“IC”标签页 > “查看属性”来查看。
	DELAY 40
	SAY 别忘了在工作时穿戴合适的E.G.O.以减少伤害。完成后将它们放回架子。
	DELAY 45"}

/obj/item/disk/holodisk/tutorial/warning
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 为模拟我们设施的工作环境，再生器不会影响走廊或收容单元。
	DELAY 45"}

/obj/item/disk/holodisk/tutorial/meltdown
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 如果你觉得自己已经足够熟练地与异常体工作，那就继续听。
	DELAY 40
	SAY 否则，请回到走廊继续练习。
	DELAY 30
	SAY 逆卡巴拉计量表，可以通过检查<span class='italics'>考验监视器</span>看到，每次完成工作都会增加。
	DELAY 50
	SAY 这意味着工作会推进回合，随着时间推移增加难度。尽量高效地完成工作。
	DELAY 45
	SAY 当它达到阈值时，公告会揭示哪些异常体受到了逆卡巴拉熔毁的影响。
	DELAY 45
	SAY 这些异常体必须在规定时间内进行工作，否则它们会立即突破收容。你可以通过检查它们的控制台来查看这个计时器。
	DELAY 55
	SAY 如果你想要一个例子，激活机器以触发训练用异常体的熔毁。
	DELAY 45"}

/obj/item/disk/holodisk/tutorial/department
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 我们的设施由多个部门的主房间通过长长的走廊连接而成。
	DELAY 40
	SAY 以下是部门列表：控制部（control）、情报部（intelligence）、培训部（training）、安保部（safety）、中央本部（central command）、福利部（welfare）、惩戒部（disciplinary）、记录部（records）、研发部（research）和构筑部（architecture）。
	DELAY 50
	SAY 每个设施的布局各不相同，但所有设施都有一些共同特征。
	DELAY 40
	SAY 中央本部位于最中心，在镇压时通常充当角斗场。
	DELAY 45
	SAY 控制部有监控台，安保部充当医疗室，培训部设有厨房，福利部存放清洁用品。
	DELAY 50
	SAY 记录部存有关于异常体的信息，研发部则是生产EGO的地方。
	DELAY 40
	SAY 使用设施中的电梯可以到达主管办公室。
	DELAY 35
	SAY 异常体可以在与你刚才走过的走廊类似的走廊中生成的收容单元里找到。
	DELAY 45
	SAY 你可以使用这个监控摄像头控制台来观看当前回合。试着辨认各个部门和其他重要特征。
	DELAY 45"}

/obj/item/disk/holodisk/tutorial/ending
	preset_record_text = {"
	NAME Angela
	DELAY 10
	SAY 恭喜！你已完成入职培训，现在准备好在脑叶公司开始工作了！
	DELAY 45
	SAY 如果你在设施中需要任何帮助，请前往右上角的导师标签页，使用导师帮助来提问。
	DELAY 50
	SAY 你也可以爬进附近的传送门，返回脑叶公司教程的起点。
	DELAY 40
	SAY 当你准备好离开时，将你的角色图标拖拽到员工存储装置上，在弹出的窗口中点击“是”。
	DELAY 50
	SAY 首先在屏幕底部的文本栏中输入<span class='italics'>ghost</span>。然后输入<span class='italics'>respawn</span>来加入设施。
	DELAY 50
	SAY 我们建议新玩家以“员工”(Agent)身份加入回合，因为其他职位有各种限制，玩法循环也不同。
	DELAY 45
	SAY 祝你好运，员工。直面恐惧，创造未来。
	DELAY 60"}
