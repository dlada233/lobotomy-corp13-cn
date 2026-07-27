/obj/projectile/ego_bullet/ego_prank
	name = "蕾蒂希娅"
	damage = 10
	damage_type = BLACK_DAMAGE

/obj/projectile/ego_bullet/ego_transmission
	name = "失真信号"
	damage = 14
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_gaze
	name = "凝视"
	damage = 9 //Slow as balls reload
	damage_type = RED_DAMAGE

//Homing weapon with no homing
/obj/projectile/ego_bullet/ego_galaxy
	name = "小小银河"
	icon_state = "magicm"
	damage = 18
	ff_multiplier = 0
	damage_type = BLACK_DAMAGE
	speed = 1.5

//Homing weapon (Galaxy)
/obj/projectile/ego_bullet/ego_galaxy/homing
	homing = TRUE
	speed = 1.25
	homing_turn_speed = 30		//Angle per tick.
	var/homing_range = 9

/obj/projectile/ego_bullet/ego_galaxy/homing/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(fireback)), 3)

/obj/projectile/ego_bullet/ego_galaxy/homing/proc/fireback()
	icon_state = "magich"
	set_homing_target(GetHomingTarget(homing_range))


/obj/projectile/ego_bullet/ego_unrequited
	name = "无私的爱"
	damage = 7
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_harmony
	name = "谐奏"
	icon_state = "pulse0"
	damage = 50
	damage_type = WHITE_DAMAGE
	hitscan = TRUE

/obj/projectile/ego_bullet/ego_harmony/strong
	damage = 75

/obj/projectile/ego_bullet/ego_song
	name = "歌声"
	damage = 3
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_songmini
	name = "歌声"
	damage = 1 //4 pellets
	damage_type = WHITE_DAMAGE
	spread = 5

/obj/projectile/ego_bullet/ego_wedge
	name = "尖叫声"
	damage = 38
	damage_type = WHITE_DAMAGE
	icon_state = "arrow_greyscale"
	color = "#AAFF00"

/obj/projectile/ego_bullet/regs
	name = "锐利之爪"
	damage = 10
	damage_type = BLACK_DAMAGE
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/tracer/laser/regs
	tracer_type = /obj/effect/projectile/tracer/laser/regs
	impact_type = /obj/effect/projectile/impact/laser/regs

/obj/effect/projectile/tracer/laser/regs
	name = "move-in claw"
	icon_state = "replica"
/obj/effect/projectile/impact/laser/regs
	name = "move-in impact"
	icon_state = "replica"

/obj/projectile/ego_bullet/replica/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/T = target
	var/mob/living/user = firer
	if(user.faction_check_mob(T))//player faction
		T.Knockdown(50)//trip the target
		return BULLET_ACT_BLOCK
	qdel(src)

/obj/projectile/ego_bullet/ego_swindle
	name = "骗局"
	icon_state = "d6"
	damage = 14
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_swindle/Initialize()
	. = ..()
	damage = rand(4, 24)

/obj/projectile/ego_bullet/ego_ringing
	name = "铃声"
	icon_state = "energy2"
	damage = 3
	damage_type = BLACK_DAMAGE
	hitscan = TRUE

/obj/projectile/ego_bullet/ego_ringing/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/splatter_dir = 0
	var/hitx = target.pixel_x + rand(-8, 8)
	var/hity = target.pixel_y + rand(-8, 8)
	if(isliving(target))
		splatter_dir = angle2dir(Angle)
		hitx = target.pixel_x + (sin(Angle) * 16)
		hity = target.pixel_y + (cos(Angle) * 16)

	new/obj/effect/temp_visual/dir_setting/longbloodsplatter/purple(get_turf(target), splatter_dir, hitx, hity)

/obj/projectile/ego_bullet/ego_syrinx
	name = "泣婴"
	icon_state = "ecstasy"
	damage_type = WHITE_DAMAGE
	color = COLOR_GREEN
	damage = 8
	hitscan = TRUE

/obj/projectile/ego_bullet/ego_syrinx/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/splatter_dir = 0
	var/hitx = target.pixel_x + rand(-8, 8)
	var/hity = target.pixel_y + rand(-8, 8)
	if(isliving(target))
		splatter_dir = angle2dir(Angle)
		hitx = target.pixel_x + (sin(Angle) * 16)
		hity = target.pixel_y + (cos(Angle) * 16)

	new/obj/effect/temp_visual/dir_setting/longbloodsplatter(get_turf(target), splatter_dir, hitx, hity)

/obj/projectile/ego_bullet/ego_squeak
	name = "吱吱声"
	damage = 3
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/soda_rifle
	damage = 11
	speed = 0.25
