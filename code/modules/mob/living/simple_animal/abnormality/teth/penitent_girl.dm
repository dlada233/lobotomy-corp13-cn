#define STATUS_EFFECT_PENITENCE /datum/status_effect/penitence
//Sorry Lads, not much I can do here - Kirie
//I tried to improve it. - Coxswain
/mob/living/simple_animal/hostile/abnormality/penitentgirl
	name = "忏悔少女"
	desc = "一个头发垂在眼睛上的女孩."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "penitent"
	portrait = "penitent"
	maxHealth = 230
	health = 230
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 50,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = list(80, 60, 50, 50, 50),
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	is_flying_animal = TRUE
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/gloom

	ego_list = list(
		/datum/ego_datum/weapon/sorrow,
		/datum/ego_datum/armor/sorrow,
	)
	gift_type =  /datum/ego_gifts/sorrow
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB
	can_spawn = FALSE // Normally doesn't appear

	observation_prompt = "面前的女孩在跳舞，摇摇晃晃地来回摆动。<br>\
		她的双脚从脚踝处被砍断，却仍在移动。<br>\
		你..."
	observation_choices = list(
		"穿上鞋子" = list(TRUE, "你移开断脚，穿上鞋子。<br>\
			感觉很好。<br>你想跳舞。<br>请砍掉我的双脚。"),
		"不穿鞋子" = list(FALSE, "你怎么能做这么恶心的事？<br>\
			你把鞋子留在原地。<br>\
			女孩继续无忧无虑地移动着。"),
	)

//Work Mechanics
/mob/living/simple_animal/hostile/abnormality/penitentgirl/AttemptWork(mob/living/carbon/human/user, work_type)
	//Prudence too high, random damage type time.
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) >= 40)
		work_damage_type = pick(WHITE_DAMAGE, RED_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/penitentgirl/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	// you are going to cut your own leg off
	work_damage_type = initial(work_damage_type)
	if((get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40) && (get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 40))
		user.deal_damage(50, WHITE_DAMAGE) //DIE!

	if(user.sanity_lost)
		user.apply_status_effect(STATUS_EFFECT_PENITENCE)
		user.say("为什么我不能有一点自由？她的鞋子看起来很美!")
		QDEL_NULL(user.ai_controller)
		user.ai_controller = /datum/ai_controller/insane/wander/penitence
		user.InitializeAIController()
		user.apply_status_effect(/datum/status_effect/panicked_type/wander/penitence)


//Status Effect
/datum/status_effect/penitence
	id = "penitence"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 MINUTES
	alert_type = null

/datum/status_effect/penitence/on_apply()
	. = ..()
	if(!ishuman(owner))
		return FALSE //Autoremoves it
	owner.add_overlay(mutable_appearance('icons/mob/clothing/feet.dmi', "red_shoes", -ABOVE_MOB_LAYER)) //Yes I am reusing assets! No, I am not sorry!

/datum/status_effect/penitence/on_remove()
	. = ..()
	owner.cut_overlay(mutable_appearance('icons/mob/clothing/feet.dmi', "red_shoes", -ABOVE_MOB_LAYER))
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	if(!status_holder.sanity_lost) //Are we still insane? If not, we get to keep our legs.
		return
	if(HAS_TRAIT(status_holder, TRAIT_NODISMEMBER))
		return
	var/obj/item/bodypart/left_leg = status_holder.get_bodypart(BODY_ZONE_L_LEG)
	var/obj/item/bodypart/right_leg = status_holder.get_bodypart(BODY_ZONE_R_LEG)
	var/did_the_thing = (left_leg?.dismember() && right_leg?.dismember()) //not all limbs can be removed, so important to check that we did. the. thing.
	if(!did_the_thing)
		return
	if(status_holder.stat < UNCONSCIOUS) //Not unconscious/dead
		status_holder.say("请原谅我...我这就把脚切掉.")
	status_holder.adjustBruteLoss(300)//DIE! For real, this time.

/datum/status_effect/penitence/tick()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	if(!status_holder.sanity_lost && !QDELETED(status_holder))
		qdel(src)
	else
		status_holder.emote("spin")

#undef STATUS_EFFECT_PENITENCE

//Sanity Lines
// Insanity lines
/datum/ai_controller/insane/wander/penitence
	lines_type = /datum/ai_behavior/say_line/insanity_penitence

/datum/ai_behavior/say_line/insanity_penitence
	lines = list(
		"愿意加入我吗?",
		"我为什么想跳舞? 你为什么想活下去?",
		"看看这些动作!",
		"哈哈哈...",
		"我觉得自己充满活力!",
	)

/datum/status_effect/panicked_type/wander/penitence
	icon = "penitence"
