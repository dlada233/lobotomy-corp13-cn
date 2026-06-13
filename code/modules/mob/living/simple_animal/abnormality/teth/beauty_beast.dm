/mob/living/simple_animal/hostile/abnormality/beauty
	name = "美女与野兽"
	desc = "浑身是棕色皮毛的四足怪物，眼睛的数量无法计算."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "beauty"
	icon_living = "beauty"
	icon_dead = "beauty_dead"
	portrait = "beauty_beast"

	pixel_x = -8
	base_pixel_x = -8

	maxHealth = 230
	health = 230
	del_on_death = FALSE
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 20, -20, -20, -20),
		ABNORMALITY_WORK_INSIGHT = list(50, 50, 40, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(30, 15, -50, -50, -50),
		ABNORMALITY_WORK_REPRESSION = 65,
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/envy

	ego_list = list(
		/datum/ego_datum/weapon/horn,
		/datum/ego_datum/armor/horn,
	)
	gift_type =  /datum/ego_gifts/horn
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "房间各处可见斑驳血泊。\
		这不是员工的血。我听见怪物在咆哮。它渴望死亡。日复一日。\
		这些血泊是怪物徒劳挣扎想要结束生命的证明。\
		\"杀了我。用你手中的刀刺穿我。\"怪物无法言语，但困在其中的灵魂在呐喊，我能听见。\
		\"既然能听见，为何不帮我解脱？\"怪物发出责问。"
	observation_choices = list(
		"因为死亡解决不了根本问题" = list(TRUE, "'那不重要。每一秒对我都是煎熬. \
			比起这无尽的痛苦，死亡已是恩赐.' \"但你是对的。这是你该解决的课题，不是我的.\" \
			\"孩子，能许下承诺吗?当你准备好时，会让我摆脱这轮回吗?\""),
		"因为我根本没带刀" = list(FALSE, "你在说谎，你心知肚明随时能从口袋里抽出那把刀."),
	)

	var/injured = FALSE

//it needs to use PostSpawn or we can't get the datum of beauty
/mob/living/simple_animal/hostile/abnormality/beauty/PostSpawn()
	. = ..()
	var/cursed = RememberVar("cursed")
	if(!cursed)
		return
	for(var/mob/dead/observer/O in GLOB.player_list) //we grab the last person that died to beauty and yeet them in there
		if(O.ckey == cursed)
			O.mind.transfer_to(src)
			src.ckey = cursed
			to_chat(src, span_userdanger("你开始有成百上千只眼睛从嘴里冒出来，同时一对角从眼窝里伸出，上面还装饰着花朵，如今，你这野兽，永远在寻找能解除你诅咒的人."))
			to_chat(src, span_notice("(如果你想离开这个身体，你可以简单地用OOC栏的Ghost，这样做没有任何责任.)"))
			TransferVar("cursed", null) //we reset the cursed just in case
			return

/mob/living/simple_animal/hostile/abnormality/beauty/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/beauty/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		if(!injured)
			injured = TRUE
			icon_state = "beauty_injured"

		else if (!(GODMODE in user.status_flags))//If you already did repression, die.
			TransferVar("cursed", user.ckey)
			user.gib()
			death()

	else
		injured = FALSE
		icon_state = icon_living
	return


