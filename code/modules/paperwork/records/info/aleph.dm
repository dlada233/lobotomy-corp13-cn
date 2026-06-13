// The Silent Orchestra
/obj/item/paper/fluff/info/aleph/tso
	abno_type = /mob/living/simple_animal/hostile/abnormality/silentorchestra
	abno_code = "T-01-31"
	abno_info = list(
		"当工作结果为优时，逆卡巴拉计数器减少。",
		"当工作结果为差时，逆卡巴拉计数器减少。",
		"沉默乐团突破收容时演奏包含4个乐章。随着乐章推进，聆听员工持续承受白色伤害且音乐影响范围扩大。",
		"各乐章弱点变化：第一乐章弱青色，第二乐章弱黑色，第三乐章弱白色，第四乐章仅红色攻击有效。终章高潮时获得全伤害免疫。")
	abno_breach_damage_type = "白色"
	abno_breach_damage_count = "中至高"
	abno_resistances = list(
		RED_DAMAGE = "免疫/免疫/免疫/普通/免疫",
		WHITE_DAMAGE = "免疫/免疫/普通/免疫/免疫",
		BLACK_DAMAGE = "免疫/普通/免疫/免疫/免疫",
		PALE_DAMAGE = "普通/免疫/免疫/免疫/免疫")

// Blue Star
/obj/item/paper/fluff/info/aleph/bluestar
	abno_type = /mob/living/simple_animal/hostile/abnormality/bluestar
	abno_code = "O-03-93"
	abno_info = list(
		"自律等级≤3的员工接触异想体时会立即投身碧蓝新星。",
		"谨慎等级≤4的员工完成工作时，逆卡巴拉计数器减少。",
		"工作时间超过40秒时，逆卡巴拉计数器减1且工作员工投身其中。",
		"突破收容后，所有声音湮灭为寂静，伴随低频嗡鸣与视觉干扰效应。",
		"突破收容状态下，设施内所有惊慌员工将被吸入异想体中心湮灭。")
	abno_breach_damage_type = "白色"
	abno_breach_damage_count = "极高"

// White Night
/obj/item/paper/fluff/info/aleph/whitenight
	abno_type = /mob/living/simple_animal/hostile/abnormality/white_night
	abno_code = "T-03-46"
	abno_info = list(
		"当逆卡巴拉计数器归零，白夜与其使徒将再度降临。",
		"当工作结果为优时，计数器高概率增加；全体员工身心恢复健康。",
		"当工作结果为差时，逆卡巴拉计数器减少。")
	abno_breach_damage_type = "青色"
	abno_breach_damage_count = "高"

// Nothing There
/obj/item/paper/fluff/info/aleph/nothingthere
	abno_type = /mob/living/simple_animal/hostile/abnormality/nothing_there
	abno_code = "O-06-20"
	abno_info = list(
		"工作员工勇气等级越低，成功率越低且工作稳定性越差。",
		"正义等级<4的员工完成工作时，逆卡巴拉计数器减少。",
		"当工作结果为差时，员工将遭袭并成为一无所有的躯壳。",
		"当计数器归零时，一无所有将伪装成死亡员工消失于收容单元。")
	abno_breach_damage_count = "极高" // 主要因"再见"和"你好"连击
	abno_resistances = list(
		RED_DAMAGE = "极高/免疫/免疫",
		WHITE_DAMAGE = "较高/较高/极高",
		BLACK_DAMAGE = "较高/较高/极高",
		PALE_DAMAGE = "较低/普通/较高")

// The Mountain of Smiling Bodies
/obj/item/paper/fluff/info/aleph/mountain
	abno_type = /mob/living/simple_animal/hostile/abnormality/mountain
	abno_code = "T-01-75"
	abno_info = list(
		"员工在工作过程中死亡或重伤时，逆卡巴拉计数器减少。",
		"受伤员工开始工作时，逆卡巴拉计数器减少。",
		"当工作结果为差时，逆卡巴拉计数器减少。",
		"设施内累计2名员工死亡时，逆卡巴拉计数器减少。",
		"突破收容期间对尸体极度敏感。镇压时需确保无人员死亡；若发生伤亡，立即将尸山与尸体隔离。",
		"若上一层级未能完成镇压，必须严防尸山所在部门发生死亡事件。",
		"镇压需持续削减主体HP并消灭衍生物，仅攻击主体无法完全镇压。")

// Staining Rose
/obj/item/paper/fluff/info/aleph/rose
	abno_type = /mob/living/simple_animal/hostile/abnormality/staining_rose
	abno_code = "F-04-116"
	abno_info = list(
		"F-04-116 会选择一个满足“条件”的员工作为其“选中者”。等级为4级或任意属性达到5级的员工满足此条件。",
		"如果非“选中者”的员工对 F-04-116 进行工作，或者在无存活“选中者”的情况下逆卡巴拉计数器归零，该异想体将使收容单元外的员工患上一种会咳出红色玫瑰花瓣的疾病。",
		"这种疾病会无止境地在人与人、部门与部门之间传播。为了安全起见，员工可以在恢复机附近进行隔离。",
		"“选中者”对其的持续工作，F-04-116 会逐渐被“染红”，直至异想体准备好“绽放”。在异想体被染红的过程中，员工在工作时会逐渐受到不可避免的递增的青色伤害。",
		"当 F-04-116 完全被“染红”，或者在有“选中者”员工存活的情况下逆卡巴拉计数器归零时，会触发一次“绽放”事件。",
		"在“绽放”事件期间，被选中的员工会受到大量的、不可避免的青色伤害。如果 F-04-116 尚未完全“染红”，则该伤害是致命的，并且会使员工感染疾病。",
		"如果“绽放”事件是由完全“染红”的玫瑰所导致，则工作会自动完成并取得极大的成功。",
		"如果“选中者”员工连续 4 次对 F-04-116 以外的异想体进行工作，逆卡巴拉计数器会降低。",
		"如果“选中者”员工因任何原因死亡，F-04-116 会将整个设施变成一座玫瑰园。")
	abno_breach_damage_type = "青色"
	abno_breach_damage_count = "极高"

// Melting Love
/obj/item/paper/fluff/info/aleph/melty
	abno_type = /mob/living/simple_animal/hostile/abnormality/melting_love
	abno_code = "D-03-109"
	abno_info = list(
		"当工作结果为差时，逆卡巴拉计数器减少。",
		"当工作结果为一般时，逆卡巴拉计数器有普通概率减少。",
		"溶解之爱会向首位执行非镇压工作的员工（标记为D-03-109-1）赠与粘液团。该粘液团可恢复D-03-109-1的SP并提升其自律值。但粘液效果随异想体状态变化的规律仍需进一步观察。",
		"当D-03-109-1完成镇压工作时，逆卡巴拉计数器减少。",
		"当D-03-109-1完成工作结果为优时，计数器有低概率增加1点。",
		"D-03-109-1死亡时，逆卡巴拉计数器直接归零。",
		"注意：D-03-109-1<strong>不携带</strong>传染性病原体。")

// CENSORED
/obj/item/paper/fluff/info/aleph/censored
	abno_type = /mob/living/simple_animal/hostile/abnormality/censored
	abno_code = "O-03-89"
	abno_info = list(
		"可通过特殊工作类型使计数器增加1点，但执行员工将永久消失。",
		"等级≤4的员工接触异想体会立即陷入惊慌。",
		"异想体突破收容时，等级≤3的员工出现相同反应。",
		"工作过程中员工惊慌时，逆卡巴拉计数器减少。",
		"当工作结果为差时，逆卡巴拉计数器减少。")

// Titania
/obj/item/paper/fluff/info/aleph/titania
	abno_type = /mob/living/simple_animal/hostile/abnormality/titania
	abno_code = "F-01-130"
	abno_info = list(
	"当工作结果为差时，逆卡巴拉计数器降低。",
	"当一名理智未满的员工开始对提泰妮娅进行工作时，逆卡巴拉计数器减少。",
	"当设施内有 2 名员工陷入恐慌后，逆卡巴拉计数器降低。",
	"突破收容时，提泰妮娅会持续召唤敌对的小精灵，它们会为她进行侦查。",
	"在小精灵攻击员工后的一段时间内，该员工受到的白色伤害增加，并且提泰妮娅似乎会追踪他们。",
	"突破收容时，提泰妮娅会设立规则，如果员工违反规则，则会受到青色伤害。",
	"当一名员工在恐慌或重伤状态下被提泰妮娅攻击时，他们会被直接抹杀。")
	abno_breach_damage_type = "红色/青色"

// Lady out of Space
/obj/item/paper/fluff/info/aleph/space_lady
	abno_type = /mob/living/simple_animal/hostile/abnormality/space_lady
	abno_code = "O-01-131"
	abno_info = list(
		"对太空女士进行工作时，员工将承受等量的黑色与白色伤害。",
		"当工作结果为一般时，逆卡巴拉计数器有低概率减少。",
		"当工作结果为差时，逆卡巴拉计数器有两次普通概率减少机会。",
		"等级≤4的员工完成工作时，逆卡巴拉计数器减少。若员工等级≤3，计数器会再次减少。",
		"等级≤2的员工尝试工作时，将被太空女士吞噬且计数器减少。")
	abno_work_damage_type = "白色 & 黑色"
	abno_work_damage_count = "极高"
	abno_breach_damage_type = "白色 & 黑色"
	abno_breach_damage_count = "极高"

// The Jester of Nihil
/obj/item/paper/fluff/info/aleph/nihil
	abno_type = /mob/living/simple_animal/hostile/abnormality/nihil
	abno_code = "O-01-150"
	abno_info = list(
		"当工作结果为优时，逆卡巴拉计数器增加。",
		"当工作结果为差时，逆卡巴拉计数器减少2点。",
		"当魔法少女类异想体突破收容时，逆卡巴拉计数器减少2点。",
		"执行镇压工作时，员工承受黑色伤害。",
		"当计数器归零时，设施被窒息黑暗笼罩。",
		"黑暗会剥夺员工属性，并引发大规模逆卡巴拉熔毁。",
		"当计数器归零且设施内收容≥2个魔法少女类异想体时，O-01-150将突破收容。")

// God of the Seasons
/obj/item/paper/fluff/info/aleph/seasons
	abno_type = /mob/living/simple_animal/hostile/abnormality/seasons
	abno_code = "M-06-35"
	abno_info = list(
		"该异想体随时间在四种状态间轮转，分别称为\"春\"、\"夏\"、\"秋\"、\"冬\"。",
		"初次出现在设施时呈现无害微型态，此阶段任何工作结果均导致逆卡巴拉计数器减少。",
		"当计数器首次归零或长时间未干预时，异想体显露真身且最大计数器永久降为1。",
		"不同状态下工作或突破时，员工承受的伤害类型各异。",
		"计数器归零时，设施将出现持续室内异常气象。",
		"当工作结果为差时，逆卡巴拉计数器减少1点。")
	abno_work_rates = list(
			ABNORMALITY_WORK_INSTINCT = "\"夏\"季高效，\"春\"季普通",
			ABNORMALITY_WORK_INSIGHT = "\"春\"季高效，\"冬\"季普通",
			ABNORMALITY_WORK_ATTACHMENT = "\"秋\"季高效，\"夏\"季普通",
			ABNORMALITY_WORK_REPRESSION = "\"冬\"季高效，\"秋\"季普通")
	abno_work_damage_type = "白色/红色/黑色/青色"
	abno_breach_damage_type = "白色/红色/黑色/青色"
	abno_resistances = list(
		RED_DAMAGE = "较高/极高/较高/较低",
		WHITE_DAMAGE = "极高/普通/普通/普通",
		BLACK_DAMAGE = "普通/较高/极高/较高",
		PALE_DAMAGE = "较低/较低/较低/极高")

//Last Shot
/obj/item/paper/fluff/info/aleph/last_shot
	abno_type = /mob/living/simple_animal/hostile/abnormality/last_shot
	abno_code = "C-06-152"
	abno_info = list(
		"自律等级≤3的员工工作成功率大幅提升。",
		"自律等级≥5的员工工作成功率大幅降低。",
		"勇气等级<5的员工承受更多工作伤害。",
		"正义等级<5的员工承受更多工作伤害。",
		"当工作结果为差时，逆卡巴拉计数器减少。",
		"计数器归零时，终末弹将在收容单元内增殖血肉直至被摧毁。")

// The Crying Children
/obj/item/paper/fluff/info/aleph/crying_children
	abno_type = /mob/living/simple_animal/hostile/abnormality/crying_children
	abno_code = "O-01-430" // Philip's Birthday April 30th
	abno_info = list(
		"当2名员工死亡时，逆卡巴拉计数器减少。",
		"完成沟通工作时，逆卡巴拉计数器增加。",
		"工作结果为一般时，员工有普通概率被诅咒。",
		"工作结果为差时，逆卡巴拉计数器减少且员工被诅咒。",
		"被诅咒员工一段时间后恢复丧失的感官。",
		"突破收容时随时间推移引燃整个设施。削减生命值可延缓此过程。",
		"分裂为3名孩童时，全体员工被诅咒。击杀孩童可解除对应诅咒。",
		"所有孩童死亡时重新融合并强化。")

//Army in Black
/obj/item/paper/fluff/info/aleph/army
	abno_type = /mob/living/simple_animal/hostile/abnormality/army
	abno_code = "D-01-106"
	abno_info = list(
		"可命令深黯军团保护员工，但下达指令时逆卡巴拉计数器减少。",
		"执行压迫工作时，逆卡巴拉计数器减少。",
		"每2名员工死亡后，逆卡巴拉计数器减少。",
		"当工作结果为差时，逆卡巴拉计数器减少。",
		"成功镇压异想体时，逆卡巴拉计数器增加。")

// Distorted Form
/obj/item/paper/fluff/info/aleph/distortedform
	abno_type = /mob/living/simple_animal/hostile/abnormality/distortedform
	abno_code = "O-06-38"
	abno_info = list(
		"警告：O-06-38会周期性伪装成其他异想体，尝试工作时将显露真身。",
		"正义等级≤4的员工完成工作或工作失败时，O-06-38会发出恐怖尖啸。",
		"尖啸将激怒其他异想体，需按逆卡巴拉熔毁事件处理。",
		"若未处理被激怒异想体，多个异想体将同时突破收容。",
		"当工作结果为优时，逆卡巴拉计数器增加1点。",
		"忽略熔毁事件时，逆卡巴拉计数器减少1点。")
	abno_work_damage_type = "全类型"
	abno_breach_damage_type = "随机"

// Nobody Is
/obj/item/paper/fluff/info/aleph/nobodyis
	abno_type = /mob/living/simple_animal/hostile/abnormality/nobody_is
	abno_code = "O-06-180"
	abno_info = list(
		"进行工作的员工谨慎等级越低，成功率就越低，工作也越不稳定。",
		"当正义等级低于4级的员工完成工作时，逆卡巴拉计数器降低。",
		"当工作结果为差时，逆卡巴拉计数器降低。",
		"设施内的一名员工会被映照在“面目全非”脸部的镜子上。",
		"当设施内只有一名具有异想体工作能力的员工时，工作伤害增加。",
		"否则，当所选员工完成工作时，他们会被同化入异想体之中。",)
	abno_breach_damage_count = "极高" // 形态转换后无法挽回
	abno_resistances = list(
		RED_DAMAGE = "较高/较高/极高",
		WHITE_DAMAGE = "较高/较高/极高",
		BLACK_DAMAGE = "极高/免疫/免疫",
		PALE_DAMAGE = "较低/普通/较高")

/*// Black Sun
/obj/item/paper/fluff/info/aleph/blacksun
	abno_type = /mob/living/simple_animal/hostile/abnormality/black_sun
	abno_code = "M-03-192"
	abno_info = list(
		"This abnormality will rise over the course of 12 minutes",
		"The closer the sun is to the peak, the more PE was generated from M-03-192.",
		"As time goes on, this abnormality boosts your stats significantly.",
		"Working on the abnormality will cause it to set once more, and cause all of it's boosts to subside.",
		)
*/
