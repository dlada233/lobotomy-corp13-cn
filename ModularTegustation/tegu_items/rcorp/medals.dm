/obj/item/clothing/accessory/medal/rcorp
	name = "杰出行为勋章"
	desc = "因杰出表现而授予的铜制勋章. 这是莫大的荣誉，但也是R公司所颁发的最基础勋章. \
		通常由军官授予士兵，以表彰他们超出职责范围的出色表现."

/obj/item/clothing/accessory/medal/silver/rcorp
	name = "荣誉勋章"
	desc = "因为R公司利益所做出的杰出战斗或牺牲而授予的奖章，通常授予纪律表现良好的士兵."

/obj/item/clothing/accessory/medal/gold/rcorp
	name = "卓越英勇勋章"
	desc = "一种极为罕见的金质勋章，仅由R公司指挥官授予其士兵. \
	获得这样的奖章是最高荣誉之一，因此非常稀少，几乎没有被授予给除了队长之外的人."


//Medal Boxes
/obj/item/storage/lockbox/medal/officer
	name = "队长奖章盒"
	desc = "一个用于存放奖章的保险箱，里面的奖章用于授予在特定领域表现卓越的人士."
	req_access = list(ACCESS_COMMAND)

/obj/item/storage/lockbox/medal/officer/PopulateContents()
	new /obj/item/clothing/accessory/medal/rcorp(src)

/obj/item/storage/lockbox/medal/lcdr
	name = "Lieutenant Commander-中尉副指挥官奖章盒"
	desc = "一个用于存放奖章的保险箱，里面的奖章用于授予在特定领域表现卓越的人士."
	req_access = list(ACCESS_COMMAND)

/obj/item/storage/lockbox/medal/lcdr/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/rcorp(src)
	new /obj/item/clothing/accessory/medal/silver/rcorp(src)

/obj/item/storage/lockbox/medal/cdr
	name = "指挥官的奖章盒"
	desc = "一个用于存放奖章的保险箱，里面的奖章用于授予在特定领域表现卓越的人士."
	req_access = list(ACCESS_MANAGER)

/obj/item/storage/lockbox/medal/cdr/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/rcorp(src)
	for(var/i in 1 to 2)
		new /obj/item/clothing/accessory/medal/silver/rcorp(src)
	new /obj/item/clothing/accessory/medal/gold/rcorp(src)
