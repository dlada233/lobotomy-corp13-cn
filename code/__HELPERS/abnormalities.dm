/// This proc returns text explanation of simple mob's resistances
/proc/SimpleResistanceToText(resist = 1)
	switch(resist)
		if(0 to 0) //Just putting 0 doesn't work.
			return "免疫"
		if(1 to 1)
			return "一般"
		if(-INFINITY to 0)
			return "吸收"
		if(0 to 0.5)
			return "极高"
		if(0.5 to 1)
			return "较高"
		if(1 to 1.5)
			return "较低"
		if(2 to INFINITY)
			return "致命弱点"
		if(1.5 to 2)
			return "极低"
	return "Unknown ([resist])"

/// Returns text description for combat damage
/proc/SimpleDamageToText(damage = 10)
	switch(damage)
		if(0 to 0)
			return "无"
		if(-INFINITY to 0)
			return "治愈性"
		if(0 to 8)
			return "非常低"
		if(8 to 15)
			return "低"
		if(15 to 25)
			return "中"
		if(25 to 35)
			return "高"
		if(50 to INFINITY)
			return "极高"
		if(35 to 50)
			return "非常高"

	return "Unknown ([damage])"

/// Returns text description of work damage
/proc/SimpleWorkDamageToText(damage = 1)
	switch(damage)
		if(0 to 0)
			return "无"
		if(-INFINITY to 0)
			return "治愈性"
		if(0 to 2)
			return "非常低"
		if(2 to 4)
			return "低"
		if(4 to 5)
			return "中"
		if(5 to 6)
			return "高"
		if(8 to INFINITY)
			return "极高"
		if(6 to 7)
			return "非常高"

	return "Unknown ([damage])"

/// Returns text description of work success rate
/proc/SimpleSuccessRateToText(rate = 50)
	switch(rate)
		if(-INFINITY to 10)
			return "非常低"
		if(10 to 30)
			return "低"
		if(30 to 50)
			return "一般"
		if(70 to INFINITY)
			return "非常高"
		if(50 to 70)
			return "高"

	return "Unknown ([rate])"

/*
	Try to keep images 256px on at least one side to keep file sizes small - Coxswain
*/
GLOBAL_LIST_EMPTY(abnormality_portraits)
#define PORTRAIT_PATH "icons/UI_Icons/abnormality_portraits/"
/proc/create_portrait_paths()
	. = list()
	for(var/file in flist(PORTRAIT_PATH))
		if(copytext("[file]", -1) == "/")
			continue
		. += file("[PORTRAIT_PATH][file]")
	GLOB.abnormality_portraits = .
#undef PORTRAIT_PATH
