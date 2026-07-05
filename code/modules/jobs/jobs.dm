// LOBOTOMYCORPORATION EDIT -- This whole un-modular monstrosity
GLOBAL_LIST_INIT(command_positions, list(
	"Manager",
	"Extraction Officer",
	"Records Officer",
	"Control Officer",
	"Training Officer",
	"Disciplinary Officer",
	"Sephirah",
	"Department Head",
	"Agent Captain",

	// City heads
	"Doctor-医生",
	"Hana Administrator-一协会管理员",
	"Association Section Director-协会科室主管",
	"Association Assistant Director-协会科室副管",
	"Subsidary Office Director-分事务所主管",
	"Index Messenger-食指传令员",
	"Blade Lineage Cutthroat-剑契组首领",
	"Grand Inquisitor-大审判官",
	"Thumb Sottocapo-拇指指挥官",
	"Kurokumo Kashira-黑云会甲头",

	// R-corp Fourth Pack
	"Ground Commander-地面指挥官",
	"Lieutenant Commander-中尉副指挥官",
	"Operations Officer-作战军官",
	"Rabbit Squad Captain-兔子队队长",
	"Reindeer Squad Captain-驯鹿队队长",
	"Rhino Squad Captain-犀牛队队长",
	"Rhino Squad Captain-乌鸦队队长",

	// R-corp Fifth Pack
	"Assault Commander-突击指挥官",
	"Base Commander-基地指挥官",
	"Support Officer-支援军官",
	"Rat Squad Leader-老鼠队队长",
	"Rooster Squad Leader-公鸡队队长",
	"Raccoon Squad Leader-浣熊队队长",
	"Roadrunner Squad Leader-走鹃队队长",

	// W-corp stuff
	"W-Corp Representative",
	"W-Corp L3 Squad Captain",

	// LCB Labs
	"District Manager",
	"LC Asset Protection",
	"Chief Medical Officer",
	"Lead Researcher",
	"High Security Commander",
	"Low Security Commander",

	"Office Director",
	))


GLOBAL_LIST_INIT(engineering_positions, list(
	"Containment Engineer", // LCB Labs
	))


GLOBAL_LIST_INIT(medical_positions, list(
	// LCB Labs
	"Chief Medical Officer",
	"Surgeon",
	"Nurse Practitioner",
	"Pharmacist",
	"Emergency Medical Technician",

	// City
	"Doctor-医生",
	"Nurse-护士",
	"Paramedic-急救员",
	"Medical Fixer Assistant-医疗收尾人助手",
	"Prosthetics Surgeon-义体医生",
	))


GLOBAL_LIST_INIT(science_positions, list(
	// LCB Labs
	"Lead Researcher",
	"Senior Researcher",
	"Information Systems Tech",
	"Research Archivist",
	"Researcher",
	"LC Staff",
	))


GLOBAL_LIST_INIT(supply_positions, list(
	))


GLOBAL_LIST_INIT(service_positions, list(
	"Clerk",

	"Proshetics Surgeon",
	"HHPP Chef",
	"Civilian",
	"Backstreets Butcher",
	"Carnival",
	"Workshop Attendant",
	"Main Office Representative",
	"Fishhook Office Fixer",

	// LCB Labs
	"LC Chef",
	"LC Janitor",
	))


GLOBAL_LIST_INIT(security_positions, list(
	"Department Head",
	"Department Captain",

	"Agent Captain",
	"Agent Lieutenant",
	"Senior Agent",
	"Agent",
	"Agent Intern",

	// LCB Labs
	"High Security Commander",
	"Low Security Commander",
	"High Security Officer",
	"Low Security Officer",
	"Damage Mitigation Officer",
	"Damage Exasperation Officer",
	"Internal Police",
	))


GLOBAL_LIST_INIT(nonhuman_positions, list(
	))



GLOBAL_LIST_INIT(w_corp_positions, list(
	"W-Corp Representative",
	"W-Corp L3 Squad Captain",
	"W-Corp L2 Type A Lieutenant",
	"W-Corp L2 Type B Support Agent",
	"W-Corp L2 Type C Weapon Specialist",
	"W-Corp L2 Type D Spear Agent",
	"W-Corp L1 Cleanup Agent",
))

//Exists to check who can fight stuff
GLOBAL_LIST_INIT(fighter_positions, list(
	//K Corp
	"Class 1",
	"Class 3",

	//L Corp
	"Extraction Officer",
	"Records Officer",
	"Training Officer",
	"Disciplinary Officer",
	"Department Head",
	"Department Captain",
	"Agent Captain",
	"Agent Lieutenant",
	"Senior Agent",
	"Agent",
	"Agent Intern",

	//R Corp
	"SPC",
	"SGT",

	//W Corp
	"L1",
	"L2",

	//Zwei
	"Z6",
))

GLOBAL_LIST_INIT(r_corp_positions, list(
	// 4th Pack Command
	"Ground Commander-地面指挥官",
	"Lieutenant Commander-中尉副指挥官",
	"Operations Officer-作战军官",
	"Rabbit Squad Captain-兔子队队长",
	"Reindeer Squad Captain-驯鹿队队长",
	"Rhino Squad Captain-犀牛队队长",
	"Rhino Squad Captain-乌鸦队队长",

	// 5th Pack Command
	"Assault Commander-突击指挥官",
	"Base Commander-基地指挥官",
	"Support Officer-支援军官",
	"Rat Squad Leader-老鼠队队长",
	"Rooster Squad Leader-公鸡队队长",
	"Raccoon Squad Leader-浣熊队队长",
	"Roadrunner Squad Leader-走鹃队队长",

	// 4th Pack troops
	"R-Corp Suppressive Rabbit - R-公司抑制兔子",
	"R-Corp Assault Rabbit - R-公司突击兔子",
	"R-Corp Medical Reindeer - R-公司医疗驯鹿",
	"R-Corp Berserker Reindeer - R-公司狂战士驯鹿",
	"R-Corp Gunner Rhino - R-公司机枪手犀牛",
	"R-Corp Hammer Rhino - R-公司重锤犀牛",
	"R-Corp Scout Raven - R-公司侦查渡鸦",
	"R-Corp Support Raven - R-公司支援渡鸦",

	// 5th Pack troops
	"R-Corp Rat - R-公司老鼠",
	"R-Corp Rooster - R-公司公鸡",
	"R-Corp Raccoon Spy - R-公司浣熊间谍",
	"R-Corp Raccoon Sniper - R-公司浣熊狙击手",
	"R-Corp Roadrunner - R-公司走鹃",
))

GLOBAL_LIST_INIT(hana_positions, list(
	"Hana Administrator-一协会管理员",
	"Hana Representative - 一协会代表",
	"Hana Intern - 一协会实习生",
))

GLOBAL_LIST_INIT(fixer_positions, list(
	"East Office Director - 东部事务所主管",
	"East Office Fixer - 东部事务所收尾人",
	"North Office Director - 北部事务所主管",
	"North Office Fixer - 北部事务所收尾人",

	"Association Section Director-协会科室主管",
	"Association Veteran - 协会资深收尾人",
	"Association Fixer - 协会收尾人",
	"Roaming Association Fixer - 自由协会收尾人",

	"Medical Fixer Assistant-医疗收尾人助手",
	"Fixer - 收尾人",
	"Rat - 耗子", // most fitting, somehow

	"Office Fixer",
))

GLOBAL_LIST_INIT(association_positions, list(
	"Association Section Director-协会科室主管",
	"Association Veteran - 协会资深收尾人",
	"Association Fixer - 协会收尾人",
	"Roaming Association Fixer - 自由协会收尾人",
))

GLOBAL_LIST_INIT(city_antagonist_positions, list(
	"Index Messenger-食指传令员",
	"Index Proxy - 食指代行者",
	"Index Proselyte - 食指传教士",

	"Blade Lineage Cutthroat-剑契组首领",
	"Blade Lineage Salsu - 剑契组杀手",
	"Blade Lineage Ronin - 剑契组浪人",
	"Blade Lineage Roaming Salsu - 剑契组流浪杀手",

	"Grand Inquisitor-大审判官",
	"N Corp Grosshammer",
	"N Corp Mittlehammer",
	"N Corp Kleinhammer",

	"Thumb Sottocapo-拇指指挥官",
	"Thumb Capo - 拇指队长",
	"Thumb Soldato - 拇指士兵",

	"Kurokumo Kashira-黑云会甲头",
	"Kurokumo Hosa - 黑云会辅佐",
	"Kurokumo Wakashu - 黑云会若衆",
))


// job categories for rendering the late join menu
GLOBAL_LIST_INIT(position_categories, list(
	// LOBOTOMYCORPORATION ADDITION START
	"W Corp" = list("jobs" = w_corp_positions, "color" = "#00b5ad"),
	"R Corp" = list("jobs" = r_corp_positions, "color" = "#f2711c"),
	"Hana" = list("jobs" = hana_positions, "color" = "#ffffff"),
	"Association" = list("jobs" = association_positions, "color" = "#5baa27"),
	"Syndicate" = list("jobs" = city_antagonist_positions, "color" = "#db2828"),
	"Fixers" = list("jobs" = fixer_positions, "color" = "#767676"),
	// LOBOTOMYCORPORATION ADDITION END
	EXP_TYPE_COMMAND = list("jobs" = command_positions, "color" = "#ccccff"),
	EXP_TYPE_ENGINEERING = list("jobs" = engineering_positions, "color" = "#ffeeaa"),
	EXP_TYPE_SUPPLY = list("jobs" = supply_positions, "color" = "#ddddff"),
	EXP_TYPE_SILICON = list("jobs" = nonhuman_positions - "pAI", "color" = "#ccffcc"),
	EXP_TYPE_SERVICE = list("jobs" = service_positions, "color" = "#bbe291"),
	EXP_TYPE_MEDICAL = list("jobs" = medical_positions, "color" = "#ffddf0"),
	EXP_TYPE_SCIENCE = list("jobs" = science_positions, "color" = "#ffddff"),
	EXP_TYPE_SECURITY = list("jobs" = security_positions, "color" = "#ffdddd"),
))

GLOBAL_LIST_INIT(exp_jobsmap, list(
// LOBOTOMYCORPORATION EDIT START
//	EXP_TYPE_CREW = list("titles" = command_positions | engineering_positions | medical_positions | science_positions | supply_positions | security_positions | service_positions | list("AI","Cyborg")), // crew positions
//	EXP_TYPE_COMMAND = list("titles" = command_positions),
	EXP_TYPE_CREW = list("titles" = command_positions | engineering_positions | medical_positions | science_positions | supply_positions | security_positions | service_positions | w_corp_positions | r_corp_positions | hana_positions | association_positions | city_antagonist_positions | list("AI","Cyborg")), // crew positions
	EXP_TYPE_COMMAND = list("titles" = command_positions | hana_positions),
// LOBOTOMYCORPORATION EDIT END
	EXP_TYPE_ENGINEERING = list("titles" = engineering_positions),
	EXP_TYPE_MEDICAL = list("titles" = medical_positions),
	EXP_TYPE_SCIENCE = list("titles" = science_positions),
	EXP_TYPE_SUPPLY = list("titles" = supply_positions),
//	EXP_TYPE_SECURITY = list("titles" = security_positions), // LOBOTOMYCORPORATION EDIT OLD
	EXP_TYPE_SECURITY = list("titles" = security_positions | city_antagonist_positions | association_positions | w_corp_positions | r_corp_positions | fixer_positions), // LOBOTOMYCORPORATION EDIT NEW
	EXP_TYPE_SILICON = list("titles" = list("AI","Cyborg")),
	EXP_TYPE_SERVICE = list("titles" = service_positions)
))

GLOBAL_LIST_INIT(exp_specialmap, list(
	EXP_TYPE_LIVING = list(), // all living mobs
	EXP_TYPE_ANTAG = list(),
	EXP_TYPE_SPECIAL = list("Lifebringer","Ash Walker","Exile","Servant Golem","Free Golem","Hermit","Translocated Vet","Escaped Prisoner","Hotel Staff","SuperFriend","Space Syndicate","Ancient Crew","Space Doctor","Space Bartender","Beach Bum","Skeleton","Zombie","Space Bar Patron","Lavaland Syndicate","Ghost Role"), // Ghost roles
	EXP_TYPE_GHOST = list() // dead people, observers
))
GLOBAL_PROTECT(exp_jobsmap)
GLOBAL_PROTECT(exp_specialmap)

//this is necessary because antags happen before job datums are handed out, but NOT before they come into existence
//so I can't simply use job datum.department_head straight from the mind datum, laaaaame.
/proc/get_department_heads(job_title)
	if(!job_title)
		return list()

	for(var/datum/job/J in SSjob.occupations)
		if(J.title == job_title)
			return J.department_head //this is a list

/proc/get_full_job_name(job)
	var/static/regex/cap_expand = new("cap(?!tain)")
	var/static/regex/cmo_expand = new("cmo")
	var/static/regex/hos_expand = new("hos")
	var/static/regex/hop_expand = new("hop")
	var/static/regex/rd_expand = new("rd")
	var/static/regex/ce_expand = new("ce")
	var/static/regex/qm_expand = new("qm")
	var/static/regex/sec_expand = new("(?<!security )officer")
	var/static/regex/engi_expand = new("(?<!station )engineer")
	var/static/regex/atmos_expand = new("atmos tech")
	var/static/regex/doc_expand = new("(?<!medical )doctor|medic(?!al)")
	var/static/regex/mine_expand = new("(?<!shaft )miner")
	var/static/regex/chef_expand = new("chef")
	var/static/regex/borg_expand = new("(?<!cy)borg")

	job = lowertext(job)
	job = cap_expand.Replace(job, "captain")
	job = cmo_expand.Replace(job, "chief medical officer")
	job = hos_expand.Replace(job, "head of security")
	job = hop_expand.Replace(job, "head of personnel")
	job = rd_expand.Replace(job, "research director")
	job = ce_expand.Replace(job, "chief engineer")
	job = qm_expand.Replace(job, "quartermaster")
	job = sec_expand.Replace(job, "security officer")
	job = engi_expand.Replace(job, "station engineer")
	job = atmos_expand.Replace(job, "atmospheric technician")
	job = doc_expand.Replace(job, "medical doctor")
	job = mine_expand.Replace(job, "shaft miner")
	job = chef_expand.Replace(job, "cook")
	job = borg_expand.Replace(job, "cyborg")
	return job
