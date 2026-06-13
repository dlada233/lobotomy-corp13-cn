/mob/living/simple_animal/hostile/abnormality/flesh_idol
	name = "血肉偶像"
	desc = "中间钉着肉的十字架."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "flesh_idol"
	portrait = "flesh_idol"
	maxHealth = 700
	health = 700
	threat_level = WAW_LEVEL
	pixel_x = -16
	base_pixel_x = -16
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 55,
		ABNORMALITY_WORK_INSIGHT = 55,
		ABNORMALITY_WORK_ATTACHMENT = 55,
		ABNORMALITY_WORK_REPRESSION = 55,
	)
	start_qliphoth = 4
	max_boxes = 20
	work_damage_upper = 0
	work_damage_lower = 0		//Work damage is later
	work_damage_type = RED_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/lust
	can_spawn = FALSE // Should be a Tool

	ego_list = list(
		/datum/ego_datum/weapon/heart,
		/datum/ego_datum/armor/heart,
	)
	gift_type = /datum/ego_gifts/heart
	abnormality_origin = ABNORMALITY_ORIGIN_ALTERED

	observation_prompt = "我已祈祷七天七夜，营养不良使皮肤紧绷，缺觉让双眼充血，衣服也被自己的污物弄脏。<br>\
		尽管喉咙干得无法持续诵经，我仍翕动嘴唇。<br>\
		真的有人在听吗？<br>我的祈祷能传达到祂那里吗？<br>我只求一个征兆。"
	observation_choices = list(
		"停止祈祷" = list(TRUE, "那里空无一人，上帝不在此处。"),
		"继续祈祷" = list(FALSE, "若上帝真爱世人，自会显现征兆。"),
	)

	var/counter_interval = 5 MINUTES
	var/next_counter_gain //What was the next time you gain Qlip?
	var/reset_time = 1 MINUTES
	var/damage_amount = 5
	var/run_num = 2		//How many things you breach

	var/list/blacklist = list(
		/mob/living/simple_animal/hostile/abnormality/melting_love,
		/mob/living/simple_animal/hostile/abnormality/distortedform,
		/mob/living/simple_animal/hostile/abnormality/white_night,
		/mob/living/simple_animal/hostile/abnormality/nihil,
		/mob/living/simple_animal/hostile/abnormality/galaxy_child,
		/mob/living/simple_animal/hostile/abnormality/fetus,
		/mob/living/simple_animal/hostile/abnormality/crying_children,
	)

/mob/living/simple_animal/hostile/abnormality/flesh_idol/Initialize()
	. = ..()
	next_counter_gain = world.time + counter_interval

/mob/living/simple_animal/hostile/abnormality/flesh_idol/Life()
	. = ..()
	if(next_counter_gain < world.time)
		datum_reference.qliphoth_change(1)
		next_counter_gain = world.time + counter_interval

/mob/living/simple_animal/hostile/abnormality/flesh_idol/WorkComplete(mob/living/carbon/human/user, work_type, pe)
	..()
	//heal amount = the PE you made
	var/heal_amount = pe*2
	datum_reference.qliphoth_change(-1)

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat != DEAD)
			H.adjustBruteLoss(-heal_amount) // It heals everyone by 50 or 100 points
			H.adjustSanityLoss(-heal_amount) // It heals everyone by 50 or 100 points
	heal_amount = initial(heal_amount)


/mob/living/simple_animal/hostile/abnormality/flesh_idol/Worktick(mob/living/carbon/human/user)
	var/list/damtypes = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	var/damage = pick(damtypes)
	work_damage_type = damage
	user.deal_damage(damage_amount, damage) // take 5 random damage each time
	WorkDamageEffect()

//Prevents red work damage effecs from appearing
/mob/living/simple_animal/hostile/abnormality/flesh_idol/WorktickFailure(mob/living/carbon/human/user)
	playsound(datum_reference.console, 'sound/machines/synth_no.ogg', 25, FALSE, -4)
	return

//Meltdown
/mob/living/simple_animal/hostile/abnormality/flesh_idol/ZeroQliphoth(mob/living/carbon/human/user)
	addtimer(CALLBACK (datum_reference, TYPE_PROC_REF(/datum/abnormality, qliphoth_change), 4), reset_time)
	var/list/total_abnormalities = list()

	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list)
		if(A.datum_reference.qliphoth_meter > 0 && A.IsContained() && !(A.type in blacklist) && A.z == z)
			total_abnormalities += A

	if(!LAZYLEN(total_abnormalities))
		return

	var/mob/living/simple_animal/hostile/abnormality/processing = pick(total_abnormalities)
	processing.datum_reference.qliphoth_change(-200)
