/mob/living/simple_animal/hostile/abnormality/someones_portrait
	name = "某人的肖像"
	desc = "一个简单的肖像，有一个头，红色的眼睛，盯着某处或某人."
	pixel_y = 64
	base_pixel_y = 64
	density = FALSE
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "someones_portrait"
	icon_living = "someones_portrait"
	portrait = "someonesportrait"
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = list(30, 20, 10, 0, 0),
		ABNORMALITY_WORK_ATTACHMENT = list(45, 45, 40, 40, 40),
		ABNORMALITY_WORK_REPRESSION = list(55, 55, 50, 50, 50),
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/envy
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)

	ego_list = list(
		/datum/ego_datum/weapon/snapshot,
		/datum/ego_datum/armor/snapshot,
	)
	gift_type = /datum/ego_gifts/snapshot
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

//TODO: Resprite + redo of this
	observation_prompt = "这幅肖像画在我们家族中留存已久. <br>\
		据说画中是我们一位非常重要的亲戚，但没人认得画中人. <br>我一直憎恶这幅画，为什么其他人就看不出来它只是在等待时机、伺机攻击?"
	observation_choices = list(
		"摧毁画像" = list(TRUE, "某夜，趁众人熟睡时，我溜出房间来到那可怕之物面前. <br>\
			我从口袋掏出打火机点燃，将它凑向画布... <br>\
			事实证明我是对的——它一直伺机攻击，而我在无人时进入了它的攻击范围..."),
	)

//Initialize
/mob/living/simple_animal/hostile/abnormality/someones_portrait/PostSpawn()
	..()
	DestroyLights()

//Work
/mob/living/simple_animal/hostile/abnormality/someones_portrait/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 40 && get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 40)
		PanicUser(user)
	DestroyLights()

/mob/living/simple_animal/hostile/abnormality/someones_portrait/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if (!(user.sanity_lost))
		PanicUser(user, TRUE)

/mob/living/simple_animal/hostile/abnormality/someones_portrait/Worktick(mob/living/carbon/human/user) //We apply hallucination every worktick due to varying work time
	if(!user.hallucination)
		user.hallucination += 3 //Attempt to get them to cancel work out of paranoia.

//Procs
/mob/living/simple_animal/hostile/abnormality/someones_portrait/proc/DestroyLights()
	for(var/obj/machinery/light/L in range(3, src)) //blows out the lights
		L.on = 1
		L.break_light_tube()

/mob/living/simple_animal/hostile/abnormality/someones_portrait/proc/PanicUser(mob/living/carbon/human/user, workfailure) //its over bros...
	to_chat(user, span_userdanger("他来找你了! 快跑!"))
	playsound(get_turf(user), 'sound/abnormalities/someonesportrait/panic.ogg', 40, FALSE, -5)
	user.adjustSanityLoss(user.maxSanity)
	if(!workfailure)
		addtimer(CALLBACK(src, PROC_REF(PanicCheck), user), 1) //Gives sanity time to update for forced panic type

/mob/living/simple_animal/hostile/abnormality/someones_portrait/proc/PanicCheck(mob/living/carbon/human/user) //forced wander panic
	var/mob/living/carbon/human/H = user
	if (H.sanity_lost)
		QDEL_NULL(H.ai_controller)
		H.ai_controller = /datum/ai_controller/insane/wander
		H.InitializeAIController()
		H.apply_status_effect(/datum/status_effect/panicked_type/wander)
		return
