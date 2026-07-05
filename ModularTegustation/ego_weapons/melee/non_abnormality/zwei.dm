//This one will get messy.
//Anything Zwei related goes here. That's Zwei, Streetlight and anything else under Zwei.
//Base Zwei is Grade 6, Vet is Grade 5.

/obj/item/ego_weapon/city/zweihander
	name = "双手大剑"
	desc = "二协会所用双手大剑."
	special = "在手中使用以强化自身及周围所有人的防御力."
	icon_state = "zwei"
	force = 27
	attack_speed = 2
	damtype = RED_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP

	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	var/ready = TRUE
	var/defense_buff_self = 0.5
	var/defense_buff_others = 0.8
	var/list/buffed_people = list()
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 40,
		TEMPERANCE_ATTRIBUTE = 40,
		JUSTICE_ATTRIBUTE = 40,
	)


/obj/item/ego_weapon/city/zweihander/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return

	if(!ready)
		return
	ready = FALSE
	user.Immobilize(3 SECONDS)
	user.physiology.red_mod *= defense_buff_self
	user.physiology.white_mod *= defense_buff_self
	user.physiology.black_mod *= defense_buff_self
	user.physiology.pale_mod *= defense_buff_self
	to_chat(user, span_userdanger("坚守阵地!"))

	buffed_people = list()

	for(var/mob/living/carbon/human/L in orange(5, get_turf(user)))
		L.physiology.red_mod *= defense_buff_others
		L.physiology.white_mod *= defense_buff_others
		L.physiology.black_mod *= defense_buff_others
		L.physiology.pale_mod *= defense_buff_others
		buffed_people += L

		//Visible message just didn't work here. No clue why.
		to_chat(L, span_userdanger("坚守阵地!"))

	playsound(src, 'sound/misc/whistle.ogg', 50, TRUE)
	addtimer(CALLBACK(src, PROC_REF(Return), user), 3 SECONDS)

/obj/item/ego_weapon/city/zweihander/proc/Return(mob/living/carbon/human/user)
	user.physiology.red_mod /= defense_buff_self
	user.physiology.white_mod /= defense_buff_self
	user.physiology.black_mod /= defense_buff_self
	user.physiology.pale_mod /= defense_buff_self
	to_chat(user, span_notice("你的防御buff已经失效!"))

	for(var/mob/living/carbon/human/L in buffed_people)
		L.physiology.red_mod /= defense_buff_others
		L.physiology.white_mod /= defense_buff_others
		L.physiology.black_mod /= defense_buff_others
		L.physiology.pale_mod /= defense_buff_others
		to_chat(L, span_notice("你的防御buff已经失效!"))

	addtimer(CALLBACK(src, PROC_REF(Cooldown), user), 15 SECONDS)

/obj/item/ego_weapon/city/zweihander/proc/Cooldown(mob/living/carbon/human/user)
	ready = TRUE
	to_chat(user, span_notice("你可以再次使用你的防御buff。"))

//Vet Zwei
/obj/item/ego_weapon/city/zweihander/vet
	name = "资深双手大剑"
	desc = "二协会资深成员使用的双手大剑."
	icon_state = "zwei_vet"
	force = 40
	defense_buff_self = 0.3
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

//Mini Zwei
/obj/item/ego_weapon/city/zweihander/knife
	name = "单手剑"
	desc = "二协会某些成员使用的单手剑."
	icon_state = "zwei_mini"
	force = 16
	attack_speed = 1

//Noreqs for the ERT
/obj/item/ego_weapon/city/zweihander/noreq
	attribute_requirements = list()

/obj/item/ego_weapon/city/zweihander/vet/noreq
	attribute_requirements = list()

//the funny zwei baton
/obj/item/ego_weapon/city/zweibaton
	name = "二协镇暴棍"
	desc = "二协会使用的镇暴棍."
	special = "攻击一个人以在一段时间后使他们昏迷."
	icon_state = "zwei_baton"
	inhand_icon_state = "zwei_baton"
	force = 20
	attack_speed = 2
	damtype = RED_DAMAGE

	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)


/obj/item/ego_weapon/city/zweibaton/attack(mob/living/target, mob/living/carbon/human/user)
	..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/T = target
	T.Jitter(20)
	T.set_confusion(max(10, T.get_confusion()))
	T.stuttering = max(8, T.stuttering)
	T.adjustStaminaLoss(force*2, TRUE, TRUE)

	SEND_SIGNAL(T, COMSIG_LIVING_MINOR_SHOCK)

	playsound(src, 'sound/weapons/egloves.ogg', 50, TRUE, -1)

/obj/item/ego_weapon/city/zweiwest
	name = "二协骑士大剑"
	desc = "二协会西部成员使用的大剑."
	special = "当对两格距离外使用，将进行冲刺然后阻断，如果未能冲刺，将导致犹豫不决."
	icon_state = "zweiwest"
	inhand_icon_state = "zweiwest"
	force = 25
	reach = 2
	attack_speed = 2
	damtype = RED_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	var/defense_buff = 0.8
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 40,
		TEMPERANCE_ATTRIBUTE = 40,
		JUSTICE_ATTRIBUTE = 40,
	)

	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "slice", "tear", "lacerate", "rip", "dice", "cut")

/obj/item/ego_weapon/city/zweiwest/attack(mob/living/target, mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return
	if(target.stat == DEAD)
		return

	if(get_dist(target, user) < 2)//You need to use your range to trigger the guard
		return

	var/dodgelanding
	if(user.dir == 1)
		dodgelanding = locate(user.x, user.y + 1, user.z)
	if(user.dir == 2)
		dodgelanding = locate(user.x, user.y - 1, user.z)
	if(user.dir == 4)
		dodgelanding = locate(user.x + 1, user.y, user.z)
	if(user.dir == 8)
		dodgelanding = locate(user.x - 1, user.y, user.z)
	user.throw_at(dodgelanding, 1, 1, spin = FALSE)

	if(isliving(target))
		if(get_dist(target, user) > 1)//If you try to use the greatsword like a spear you deserve this
			user.changeNext_move(CLICK_CD_MELEE * 2)
			user.Knockdown(2 SECONDS)
			var/obj/item/held = user.get_active_held_item()
			user.dropItemToGround(held)
			to_chat(user, span_userdanger("你的挥砍过于大开大合，导致你失去平衡!"))
			return

	if(!isliving(target))
		return

	user.Immobilize(2 SECONDS)
	user.physiology.red_mod *= defense_buff
	user.physiology.white_mod *= defense_buff
	user.physiology.black_mod *= defense_buff
	user.physiology.pale_mod *= defense_buff
	user.changeNext_move(CLICK_CD_MELEE * 0.15)
	to_chat(user, span_userdanger("你将大剑砸向地面!"))
	user.say("大剑守护!")

	playsound(src, 'sound/weapons/ego/shield1.ogg', 50, TRUE)

	addtimer(CALLBACK(src, PROC_REF(Return), user), 2 SECONDS)

/obj/item/ego_weapon/city/zweiwest/proc/Return(mob/living/carbon/human/user)
	user.physiology.red_mod /= defense_buff
	user.physiology.white_mod /= defense_buff
	user.physiology.black_mod /= defense_buff
	user.physiology.pale_mod /= defense_buff
	to_chat(user, span_notice("你再次举起你的大剑!"))

/obj/item/ego_weapon/city/zweiwest/vet
	name = "二协资深骑士大剑"
	desc = "二协会资深成员使用的大剑."
	icon_state = "zweiwest_fat"
	inhand_icon_state = "zweiwest_fat"
	force = 36
	defense_buff = 0.5
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
