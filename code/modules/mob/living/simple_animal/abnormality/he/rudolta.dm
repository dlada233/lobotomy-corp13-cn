//ho ho hoe -gail
/mob/living/simple_animal/hostile/abnormality/rudolta
	name = "雪橇鲁道夫"
	desc = "由三个部分拼成的异想体: 无角、毁容的驼鹿, \"圣诞老人\" 以及雪橇. \
	鲁道夫是公正的生物，无论你喜欢与否，她都会平等地给每个人送礼物."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "rudolta"
	icon_living = "rudolta"
	icon_dead = "rudolta_dead"
	portrait = "rudolta"
	maxHealth = 450
	health = 450
	pixel_x = -16
	base_pixel_x = -16
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2, FIRE = 1.5)
	stat_attack = HARD_CRIT
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2
	move_to_delay = 6
	minimum_distance = 2 // Don't move all the way to melee
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(20, 40, 40, 35, 0),
		ABNORMALITY_WORK_INSIGHT = list(50, 60, 60, 55, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(40, 50, 50, 45, 40),
		ABNORMALITY_WORK_REPRESSION = 0,
	)
	work_damage_upper = 4
	work_damage_lower = 3
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/sloth
	max_boxes = 18
	friendly_verb_continuous = "scorns"
	friendly_verb_simple = "scorns"

	ego_list = list(
		/datum/ego_datum/weapon/christmas,
		/datum/ego_datum/armor/christmas,
	)
	gift_type =  /datum/ego_gifts/christmas
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY
	//Try not to make other observations this long - This is by PM though so, we have to use it. -Coxswain
	observation_prompt = "传说有个每年实现愿望的男人。<br>好孩子更可能见到他。<br>\
		背着巨大麻袋的男人。<br>乘驯鹿雪橇周游世界的男人。<br>\
		Alex收到了礼物。<br>尽管他是个顽劣的孩子。<br>这不公平。<br>我无法接受。<br>次年圣诞我去了Alex家。<br>\
		若那人此次仍只为Alex而来，我定要质问为何从不眷顾我。<br>\
		那夜万籁俱寂。<br>我守在沉睡的Alex身旁等待。<br>\
		有时荒诞童话恰是绝望中仅存的微光。<br>当我见到圣诞老人时，脑中浮现肢解他的画面。<br>...<br>\
		此刻他就在眼前。<br>我理想中的存在。<br>人们不再称其为圣诞老人。<br>麻袋中有物蠕动。我......"
	observation_choices = list(
		"未打开麻袋" = list(TRUE, "麻袋里承载着欲望。<br>\
			那是我自幼期盼的希望。<br>我始终未曾开启。<br>你的愿望可曾实现？"),
		"打开了麻袋" = list(FALSE, "里面盛着我毕生渴求之物。<br>\
			如潘多拉魔盒，永无归袋之日。"),
	)

	var/pulse_cooldown
	var/pulse_cooldown_time = 1.8 SECONDS
	var/pulse_damage = 5

/mob/living/simple_animal/hostile/abnormality/rudolta/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/rudolta/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/rudolta/PickTarget(list/Targets)
	return

/mob/living/simple_animal/hostile/abnormality/rudolta/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((pulse_cooldown < world.time) && !(status_flags & GODMODE))
		WhitePulse()

/mob/living/simple_animal/hostile/abnormality/rudolta/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/rudolta/proc/WhitePulse()
	pulse_cooldown = world.time + pulse_cooldown_time
	playsound(src, 'sound/abnormalities/rudolta/throw.ogg', 50, FALSE, 4)
	for(var/mob/living/L in livinginview(8, src))
		if(faction_check_mob(L))
			continue
		L.deal_damage(pulse_damage, WHITE_DAMAGE)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))

