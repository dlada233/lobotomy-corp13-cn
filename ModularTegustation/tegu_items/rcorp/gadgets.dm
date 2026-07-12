/obj/item/disk/nuclear/rcorp
	name = "R-公司指挥追踪信标"
	desc = "持有这个物品让兔子们知道你在哪."
	icon_state = "servo"

/obj/item/pinpointer/nuke/rcorp
	name = "R-公司指挥追踪"
	desc = "能追踪持有指挥追踪信标的人."

/obj/item/pinpointer/nuke/rcorp/Initialize()
	..()
	toggle_on()

//Shelters
/datum/map_template/shelter/command
	name = "Large Command Shelter"
	shelter_id = "shelter_command"
	description = "A little bit of requisitions, medical and command equipment is all here."
	mappath = "_maps/templates/shelter_command.dmm"

/obj/item/survivalcapsule/rcorpcommand
	name = "large command shelter capsule"
	desc = "A luxury command post in a capsule."
	template_id = "shelter_command"

/datum/map_template/shelter/smallcommand
	name = "Small Command Shelter"
	shelter_id = "shelter_smallcommand"
	description = "A little bit of requisitions, medical and command equipment is all here."
	mappath = "_maps/templates/shelter_smallcommand.dmm"

/obj/item/survivalcapsule/rcorpsmallcommand
	name = "small command shelter capsule"
	desc = "A small command post in a capsule."
	template_id = "shelter_smallcommand"

//Announcement machines
/obj/item/announcementmaker
	name = "R-公司公告平板"
	desc = "R公司地面指挥官在部队部署期间用于快速发布公告的专用平板电脑."
	icon = 'icons/obj/modular_tablet.dmi'
	icon_state = "tablet-red"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/announcementmaker/attack_self(mob/living/user)
	..()
	var/input = stripped_input(user,"发布什么样的公告?", ,"测试公告")
	minor_announce("[input]" , "公告来自: [user.name]")

//Tablet variants
/obj/item/announcementmaker/wcorp
	name = "W-公司公告平板"
	desc = "WARP清洁L2-LT人员用于在战场上快速发布公告的专用平板电脑."
	icon_state = "tablet-blue"

/obj/item/announcementmaker/lcorp
	name = "L-公司公告平板"
	desc = "L-Corp员工队长在持续发生熔毁以及出逃时用于发布快速公告的专用平板电脑."
	icon_state = "tablet-brown"
