/mob/living/simple_animal/hostile/abnormality/wall_gazer
	name = "面壁女"//（出自脑叶）
	desc = "一个苍白的裸体女人，长着黑色的长发，完全遮住了她的脸."
	icon = 'ModularTegustation/Teguicons/96x48.dmi'
	icon_state = "ladyfacingthewall"
	portrait = "lady_facing_the_wall"
	maxHealth = 200
	health = 200
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(55, 55, 55, 55, 55),
		ABNORMALITY_WORK_INSIGHT = list(45, 45, 30, 30, 0),
		ABNORMALITY_WORK_ATTACHMENT = list(100, 100, 100, 100, 100),
		ABNORMALITY_WORK_REPRESSION = list(55, 55, 30, 30, 30),
	)
	pixel_x = -32
	base_pixel_x = -8

	work_damage_upper = 3
	work_damage_lower = 2
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/sloth
	start_qliphoth = 2
	var/scream_range = 10
	var/scream_damage = 25
	ego_list = list(
		/datum/ego_datum/weapon/wedge,
		/datum/ego_datum/armor/wedge,
	)
	gift_type =  /datum/ego_gifts/wedge
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "一个女人正在哭泣. \
		你背对着她无法看见面容，但你知道她是谁. \
		她含糊的低语令人难以理解，使你寒毛直竖. 她含糊的低语令人难以理解，使你寒毛直竖. \
		女人的啜泣仿佛在逼迫你转身. \
		而你内心深处有个声音警告着：绝不能回头."
	observation_choices = list(
		"转身" = list(TRUE, "你直面恐惧，转身面向那个女人."),
		"不要转身" = list(FALSE, "转身可能引发恐怖之事，你头也不回地离开了房间."),
	)

	work_start_lines = list("除了%ABNO一直盯着墙壁以外，我们对它一无所知.",
	"迄今为止还没有人看到过%ABNO的脸，但这并不意味着有人想要看到它的脸.",
	"在聆听它的低语之后，你能推测出它一直在思念着某人.", "最好...就这样把它晾在墙边吧.",
	"只希望%PERSON戴好了耳塞.")
	early_work_lines = list("%ABNO总是保持着同一个姿势，要不是因为它的低语，人们八成会把它当成一尊雕塑.",
	"%PERSON似乎不怎么害怕%ABNO，因为无论是谁进入它的收容单元，它都只是跪在那里一动不动.",
	"%PERSON在%ABNO背后巡视了一阵，确认一切安好后开始了工作.",
	"%ABNO附近的墙面已经长霉，尽管如此，没有人愿意去重新上漆.")
	middle_work_lines = list("工作期间，%PERSON听到了%ABNO述说的晦涩难懂的低语.",
	"在%PERSON工作时，收容单元内是如此的寂静，直到%ABNO那疯狂的低语打破了沉默.",
	"即便知道%PERSON就在收容单元内，%ABNO也没有一丝一毫的动作.", "即便%ABNO什么事情都没有做，%PERSON依然能感受到从它身上散发出的那份凄凄楚楚.")
	late_work_lines = list("低语模糊而嘶哑.", "低语的声音似乎越来越大.",
	"如果更加集中注意力的话，似乎就能听清它到底在说什么了，然而并没有%PERSON真的敢去尝试.",
	"一如既往的，低沉的耳语难以理解，不过也没人在乎.")
	work_end_lines = list("%PERSON尽力试着专注于手头的工作.", "%PERSON明白无视它才是最好的选择。.",
	"不管%ABNO说了些什么，%PERSON都将其置若罔闻，如同自己是聋子一般.", "%PERSON快马加鞭地进行着手头的工作，以便能尽快离开收容单元.")

/mob/living/simple_animal/hostile/abnormality/wall_gazer/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/wall_gazer/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(70))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/wall_gazer/ZeroQliphoth(mob/living/carbon/human/user)
	scream()
	datum_reference.qliphoth_change(start_qliphoth)
	return

/mob/living/simple_animal/hostile/abnormality/wall_gazer/proc/scream()
	for(var/mob/living/L in range(scream_range, src))
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		playsound(get_turf(src), 'sound/spookoween/girlscream.ogg', 400)
		L.deal_damage(scream_damage, WHITE_DAMAGE, attack_type = (ATTACK_TYPE_SPECIAL))

/mob/living/simple_animal/hostile/abnormality/wall_gazer/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	// If you do work while having low Temperance, fuck you and you go insane for turning your back to face her
	if(work_type == ABNORMALITY_WORK_ATTACHMENT)
		datum_reference.qliphoth_change(-1)

	if((get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40) && !(GODMODE in user.status_flags))
		flick("ladyfacingthewall_active", src)
		user.adjustSanityLoss(user.maxSanity)
		user.apply_status_effect(/datum/status_effect/panicked_lvl_4)
	return
