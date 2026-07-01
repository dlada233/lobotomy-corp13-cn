//Warden
/obj/item/paper/fluff/info/waw/warden
	abno_type = /mob/living/simple_animal/hostile/abnormality/warden
	abno_code = "T-01-114"
	abno_info = list(
		"当正义等级为3或更低且勇气等级为3或更低的员工完成工作后，逆卡巴拉计数器会降低。",
		"当工作结果为差时，逆卡巴拉计数器会降低。",
		"当'典狱长'处于逃脱状态并杀死一名员工时，它会将该员工的灵魂拖入其裙下，并开始移动得更快。",
		"任何击中'典狱长'的投射物均对其无效。",
		"注意：'典狱长'最有效的镇压方式是群体作战。")

//Bee
/obj/item/paper/fluff/info/waw/queenbee
	abno_type = /mob/living/simple_animal/hostile/abnormality/queen_bee
	abno_code = "T-04-50"
	abno_info = list(
		"当工作结果为普通时，逆卡巴拉计数器有常规概率降低。",
		"当工作结果为差时，计数器有高概率降低。",
		"计数器归零时，「女王蜂」向大范围区域释放孢子。",
		"经观测：孢子会附着员工并持续造成红色伤害。",
		"持续医疗护理使感染者恢复健康状态可消除孢子。",
		"感染者生命值耗尽时，巨型工蜂破体而出并攻击附近员工，受害者尸体中会涌出更多工蜂。")

//Jbird
/obj/item/paper/fluff/info/waw/jbird
	abno_type = /mob/living/simple_animal/hostile/abnormality/judgement_bird
	abno_code = "O-02-62"
	abno_info = list(
		"当工作结果为普通时，逆卡巴拉计数器有常规概率降低。",
		"当工作结果为差时，计数器有高概率降低。")
	abno_breach_damage_type = "青色"
	abno_breach_damage_count = "极高"

//Bbird
/obj/item/paper/fluff/info/waw/bbird
	abno_type = /mob/living/simple_animal/hostile/abnormality/big_bird
	abno_code = "O-02-40"
	abno_info = list(
		"设施内有一名员工死亡后，逆卡巴拉计数器降低。",
		"当工作结果为差时，逆卡巴拉计数器降低。",
		"当工作结果为优时，逆卡巴拉计数器增加。",
		"当设施内的紧急状况达到二级警报时，无论其逆卡巴拉计数器如何，「大鸟」都会突破收容单元。",
		"每当「大鸟」摆动它的灯时，附近被照到的员工可能会被魅惑。")
	abno_breach_damage_type = "即死"
	abno_breach_damage_count = "不适用"
//KOD
/obj/item/paper/fluff/info/waw/kod
	abno_type = /mob/living/simple_animal/hostile/abnormality/despair_knight
	abno_code = "O-01-73"
	abno_info = list(
		"首位以优级结果完成沟通工作的员工将获「绝望骑士」祝福（此后称为O-01-73-1）。",
		"祝福使红色/白色/黑色伤害减半，但青色伤害翻倍。",
		"祝福导致O-01-73-1对其他异想体的工作能力大幅下降。",
		"祝福在员工死亡/恐慌时消失，可转移至新员工。",
		"计数器归零时，该异想体会被长剑贯穿。",
		"当O-01-73-1死亡/恐慌，或累计三把长剑贯穿时，「绝望骑士」突破收容。")
	abno_can_breach = TRUE
	abno_breach_damage_type = "青色"
	abno_breach_damage_count = "极高"

//QOH
/obj/item/paper/fluff/info/waw/qoh
	abno_type = /mob/living/simple_animal/hostile/abnormality/hatred_queen
	abno_code = "O-01-04"
	abno_info = list(
		"当工作结果为差时，逆卡巴拉计数器会减少。",
		"当设施内发生3次逆卡巴拉熔毁且没有员工死亡时，逆卡巴拉计数器会减少。",
		"当逆卡巴拉计数器处于最大值时，若设施内有4名员工死亡，憎恶女王会自愿协助异常镇压。然而，如果在提供协助期间有50%的员工死亡，异常的状态将会改变并需要立即镇压。",
		"当憎恶女王的逆卡巴拉计数器变为1时，其状态发生改变。在此状态下工作成功率较低。由于她的焦虑和强迫症，该状态被指定为“歇斯底里”。",
		"当她处于歇斯底里状态时，产出16个或更多PE-Box会使逆卡巴拉计数器增加。",
		"当她处于歇斯底里状态时，产出15个或更少PE-Box会使逆卡巴拉计数器减少。")
	abno_breach_damage_type = "黑色"
	abno_breach_damage_count = "高"

//General Bee
/obj/item/paper/fluff/info/waw/generalbee
	abno_type = /mob/living/simple_animal/hostile/abnormality/general_b
	abno_code = "T-01-118"
	abno_info = list(
		"当工作结果为一般时，逆卡巴拉计数器有普通概率减少。",
		"当工作结果为差时，逆卡巴拉计数器有高概率减少。",
		"当逆卡巴拉计数器达到0时，将军蜂会向设施派遣一队士兵。",
		"警告：切勿让女王蜂的孢子接触到将军蜂。")
	abno_can_breach = TRUE
	abno_breach_damage_type = "红色 & 黑色"
	abno_breach_damage_count = "高"

//Shrimp
/obj/item/paper/fluff/info/waw/shrimpexec
	abno_type = /mob/living/simple_animal/hostile/abnormality/shrimp_exec
	abno_code = "O-02-119"
	abno_info = list(
		"当工作结果为差时，逆卡巴拉计数器会减少。",
		"当逆卡巴拉计数器达到0时，一支虾打击部队会抵达某个部门的主休息室。",
		"一名员工完成工作后，虾业协会经理会要求一个想法或服务。",
		"当员工靠近时，该异常会重复其请求。",
		"观察得出结论，每个请求对应特定的工作类型。执行该工作类型会显著提高工作成功率。",
		"当工作结果为优时，虾业协会经理会为该员工订购虾主题商品。可能的物品包括：<br>\
		<ol type=1>\
			<li>“虾业集团”品牌枪械</li>\
			<li>虾仁手榴弹</li>\
			<li>一罐韦乐奇尔牌苏打水</li>\
		</ol>")

//SnowWhitesApple
/obj/item/paper/fluff/info/waw/snowwhitesapple
	abno_type = /mob/living/simple_animal/hostile/abnormality/snow_whites_apple
	abno_code = "F-04-42"
	abno_info = list(
		"当工作结果为一般时，逆卡巴拉计数器有普通概率减少。",
		"当工作结果为差时，逆卡巴拉计数器有高概率减少。",
		"当白雪公主的苹果突破收容时，它开始将其根茎和枝条沿着所在区域的地面蔓延。",
		"由白雪公主的苹果产生的苦涩植物在其不在场时会进入休眠状态。",
		"白雪公主的苹果只能通过其根茎和枝条进行攻击。建议员工在战斗中避免穿越该异常的延伸部分。")
	abno_breach_damage_type = "黑色"
	abno_breach_damage_count = "高"

//Express Train to Hell
/obj/item/paper/fluff/info/waw/express
	abno_type = /mob/living/simple_animal/hostile/abnormality/express_train
	abno_code = "T-09-86"
	abno_info = list(
		"每分钟，售票亭的一盏灯会点亮，且逆卡巴拉计数器会减少。",
		"当有灯光点亮时开始工作流程，所有灯光会熄灭且工作成功率提高。",
		"当员工在1盏灯点亮时进行工作，该员工恢复HP和SP。2盏灯点亮时恢复更多HP和SP。",
		"当员工在3盏灯点亮时进行工作，附近的员工恢复HP和SP。",
		"当员工在4盏灯点亮时进行工作，设施内所有员工恢复HP和SP。",
		"若所有4盏灯点亮状态持续1分钟，列车将沿水平路径穿过设施，对其撞击的一切造成巨额黑色伤害。")

//Silence
/obj/item/paper/fluff/info/waw/silence
	abno_type = /mob/living/simple_animal/hostile/abnormality/silence
	abno_code = "O-04-65"
	abno_info = list(
		"每13分钟，钟声会鸣响一次。",
		"当工作结果为优时，异常有高概率感到满意。",
		"当工作结果为一般时，异常有中等概率感到满意。",
		"若在两次钟声鸣响之间未满足上述任一条件，所有员工将受到巨额青色伤害。")

//The Dreaming Current
/obj/item/paper/fluff/info/waw/current
	abno_type = /mob/living/simple_animal/hostile/abnormality/dreaming_current
	abno_code = "T-02-71"
	abno_info = list(
		"当员工在工作过程中惊慌时，逆卡巴拉计数器会减少。",
		"当自律等级为1的员工完成工作时，逆卡巴拉计数器会减少。",
		"突破收容后，梦中的洋流会穿过设施的区域，对其路径上的一切造成巨额红色伤害。")
	abno_breach_damage_type = "红色"
	abno_breach_damage_count = "极高"

//Yang
/obj/item/paper/fluff/info/waw/yang
	abno_type = /mob/living/simple_animal/hostile/abnormality/yang
	abno_code = "O-05-103"
	abno_info = list(
		"当工作结果为差时，逆卡巴拉计数器会减少。",
		"当工作时间超过30秒时，O-05-102的逆卡巴拉计数器会减少。",
		"当逆卡巴拉计数器达到0时，阳会协助异常镇压并治疗附近员工的SP。",
		"当阳受到攻击时，攻击者会受到等量的白色伤害。",
		"警告：阳死亡后，请立即撤离其尸体周围区域。",
		"警告：当阳突破收容且O-05-102在设施内时，O-05-102会突破收容并尝试与阳会合。",
		"警告：必须同时镇压阳和O-05-102，否则它们会复活并继续旅程。",
		"当阳和O-05-102相遇时，存在的一切将化为虚无。",
		"当阳和O-05-102同时在设施内时，两者的工作产出率和最大PE产量都会提高。")
	abno_breach_damage_type = "白色"
	abno_breach_damage_count = "高"

//Yin
/obj/item/paper/fluff/info/waw/yin
	abno_type = /mob/living/simple_animal/hostile/abnormality/yin
	abno_code = "O-05-102"
	abno_info = list(
		"当工作结果为差时，逆卡巴拉计数器会减少。",
		"当工作时间超过30秒时，O-05-103的逆卡巴拉计数器会减少。",
		"当逆卡巴拉计数器达到0时，阴会在设施内游荡，对附近员工造成黑色伤害。",
		"警告：当阴突破收容且O-05-103在设施内时，O-05-103会突破收容并尝试与阴会合。",
		"警告：必须同时镇压阴和O-05-103，否则它们会复活并继续旅程。",
		"当阴和O-05-103相遇时，虚无的一切将化为存在。",
		"当阴和O-05-103同时在设施内时，两者的工作产出率和最大PE产量都会提高。")

//Alriune
/obj/item/paper/fluff/info/waw/alriune
	abno_type = /mob/living/simple_animal/hostile/abnormality/alriune
	abno_code = "T-04-53"
	abno_info = list(
		"当工作结果为优时，逆卡巴拉计数器有普通概率减少。",
		"当工作结果为差时，逆卡巴拉计数器会减少。",
		"任何因爱娜温攻击而惊慌的员工将立即死亡。")
	abno_breach_damage_type = "白色"
	abno_breach_damage_count = "极高"

//Naked Nest
/obj/item/paper/fluff/info/waw/nakednest
	abno_type = /mob/living/simple_animal/hostile/abnormality/naked_nest
	abno_code = "O-02-74"
	abno_info = list(
		"观察表明，裸巢及其变体携带着能够寄生人类的蛇形生物。这些生物被命名为O-02-74-1。",
		"低HP员工更容易被O-02-74-1寄生。特别是在工作中受到较高伤害会提高寄生概率。",
		"通过手术移除未成熟的O-02-74-1会导致寄生虫从宿主体内排出。",
		"获得优等工作结果可防止寄生发生，并能提取一次性解药。",
		"被寄生的员工随时间推移会显现以下症状：<br>\
		<ol type=1>\
			<li>皮肤发绿及神经系统损伤</li>\
			<li>移动速度急剧下降</li>\
		</ol>\
		任何员工出现上述症状需立即处理。",
		"当出现上述症状的员工被单独留置4分钟，会转变为类似裸巢的形态（O-02-74-2）。",
		"O-02-74-2个体会产生与裸巢特性相同的O-02-74-1寄生虫。",
		"注意：O-02-74-1宿主的尸体必须焚毁或销毁，以防转变为O-02-74-2。",
		"注意：O-02-74-1对低温表现出极度厌恶，会试图逃往温暖环境。")
	abno_can_breach = TRUE
	abno_breach_damage_type = "红色" // 由子实体造成
	abno_breach_damage_count = "中"

//King of Greed
/obj/item/paper/fluff/info/waw/greedking
	abno_type = /mob/living/simple_animal/hostile/abnormality/greed_king
	abno_code = "O-01-64"
	abno_info = list(
		"当工作结果为一般时，逆卡巴拉计数器有低概率减少。",
		"当工作结果为差时，逆卡巴拉计数器有高概率减少。",
		"贪婪女王的行为模式是在逃脱时吞噬路径上的一切物体。镇压时请注意异常移动方向。")
	abno_breach_damage_type = "红色"
	abno_breach_damage_count = "极高"

//Ebony queen's apple
/obj/item/paper/fluff/info/waw/ebony_queen
	abno_type = /mob/living/simple_animal/hostile/abnormality/ebony_queen
	abno_code = "F-04-141"
	abno_info = list(
		"当工作结果为优时，逆卡巴拉计数器有常规概率降低。",
		"当工作结果为差时，逆卡巴拉计数器有高概率降低。",
		"黑檀女王的苹果主要通过根系攻击。镇压期间员工应避免站在该异想体的延伸部位上。")
	abno_breach_damage_type = "黑色"
	abno_breach_damage_count = "极高"

//The Firebird
/obj/item/paper/fluff/info/waw/fire_bird
	abno_type = /mob/living/simple_animal/hostile/abnormality/fire_bird
	abno_code = "O-02-101"
	abno_info = list(
		"当工作结果为优时，逆卡巴拉计数器会减少。",
		"当工作结果为一般时，逆卡巴拉计数器有低概率减少。此外，计数器越低，员工在炎雀收容单元工作时受到的伤害越高。",
		"当工作结果为差时，逆卡巴拉计数器会增加。",
		"当计数器为1时，炎雀会赐予与其工作的<name>光芒。该员工的HP和SP会立即恢复，并在接下来一段时间持续恢复。若员工完成工作后HP低于最大值的20%，炎雀同样会赐予光芒。",
		"突破收容后，炎雀短时间内会自行返回收容单元。仅当受到伤害时才会展现攻击性，被其攻击导致HP或SP归零的员工会死亡。攻击炎雀者会被其光芒灼伤双眼，致盲员工工作效率减半。当员工完成工作流程后，炎雀会治愈其眼伤。")
	abno_breach_damage_type = "红色/白色"
	abno_breach_damage_count = "极高"

//Thunderbird
/obj/item/paper/fluff/info/waw/thunder_bird
	abno_type = /mob/living/simple_animal/hostile/abnormality/thunder_bird
	abno_code = "T-02-137"
	abno_info = list(
		"当工作结果为优且员工健康值较高时，逆卡巴拉计数器会增加。",
		"当工作结果为一般时，逆卡巴拉计数器有普通概率减少。",
		"当工作结果为差时，逆卡巴拉计数器会减少。",
		"必须清除收容单元附近所有有机残留物。")
	abno_breach_damage_type = "黑色"
	abno_breach_damage_count = "高"

//Clown Smiling at Me
/obj/item/paper/fluff/info/waw/clown
	abno_type = /mob/living/simple_animal/hostile/abnormality/clown
	abno_code = "O-01-17"
	abno_info = list(
		"当工作结果为差时，逆卡巴拉计数器会减少。",
		"当工作结果为优时，逆卡巴拉计数器有高概率减少。",
		"O-01-17死亡时会爆炸，使附近员工受到高额红色伤害。")

//La Luna
/obj/item/paper/fluff/info/waw/luna
	abno_type = /mob/living/simple_animal/hostile/abnormality/luna
	abno_code = "D-01-105"
	abno_info = list(
		"当工作结果为一般时，逆卡巴拉计数器有普通概率减少。",
		"当工作结果为差时，逆卡巴拉计数器会减少。",
		"可命令员工执行演奏工作来弹奏钢琴。但请注意，演奏结束时逆卡巴拉计数器会减少。",
		"音乐会使所有员工的自律与正义暂时小幅提升，但演奏结束时演奏者会损失一半HP。",
		"当员工第三次进入单元演奏时，逆卡巴拉计数器会降为0。",
		"月光女神突破收容后，会在第三乐章结束时自愿返回收容单元。若在第三乐章结束前镇压月光女神，乐章将提前终止。")
	abno_can_breach = TRUE
	abno_breach_damage_type = "红色/黑色"
	abno_breach_damage_count = "高"

//Little Prince
/obj/item/paper/fluff/info/waw/little_prince
	abno_type = /mob/living/simple_animal/hostile/abnormality/little_prince
	abno_code = "O-04-66"
	abno_info = list(
		"连续执行3次非洞察类工作后，逆卡巴拉计数器会减少。",
		"连续执行2次洞察类工作后，逆卡巴拉计数器会增加。",
		"连续3次与小王子的员工会完全被其孢子感染。请定期安排这些员工处理其他异常以抵抗感染。",
		"当工作结果为差时，逆卡巴拉计数器会减少。",
		"持续接触小王子的员工在收容单元内表现出急性疼痛症状。随后，其体内出现类似小王子的组织，该员工开始转变为小王子-1。",
		"当计数器降为0时，小王子会吸引员工进入其收容单元。被吸引的员工进入后会发生上述转变现象。",
		"镇压小王子-1时请注意其死亡时释放的孢子。这些孢子会造成持续精神伤害，因孢子惊慌的员工可能试图进入小王子收容单元，必须立即阻止。")
	abno_can_breach = TRUE // 针对衍生体
	abno_breach_damage_type = "黑色"
	abno_breach_damage_count = "高"

//Flesh Idol
/obj/item/paper/fluff/info/waw/flesh_idol
	abno_type = /mob/living/simple_animal/hostile/abnormality/flesh_idol
	abno_code = "T-09-79"
	abno_info = list(
		"工作完成后，设施内所有人员获得治疗。",
		"工作期间，员工持续受到随机类型伤害。",
		"工作完成后，逆卡巴拉计数器减少。",
		"经过5分钟后，逆卡巴拉计数器增加。",
		"当逆卡巴拉计数器达到0时，一个随机异常突破收容。")
	abno_work_damage_type = "随机"

//Dimensional Refraction
/obj/item/paper/fluff/info/waw/dimensional_refraction
	abno_type = /mob/living/simple_animal/hostile/abnormality/dimensional_refraction
	abno_code = "O-03-88"
	abno_info = list(
		"当工作结果为差时，逆卡巴拉计数器会减少。",
		"突破收容后，设施及其员工将难以通过任何方式侦测该异常。建议主管或文员提供协助。")
	abno_breach_damage_type = "红色"
	abno_breach_damage_count = "高"

//Contract, Signed
/obj/item/paper/fluff/info/waw/contract
	abno_type = /mob/living/simple_animal/hostile/abnormality/contract
	abno_code = "C-03-140"
	abno_info = list(
		"当工作结果为优或一般时，C-03-140会与员工签订合同，小幅提升其对应属性，但降低后续工作成功率。",
		"当工作结果为一般时，逆卡巴拉计数器有低概率减少。",
		"当工作结果为差时，逆卡巴拉计数器会减少。",
		"工作期间若员工签订合同，所受伤害全部减少。",
		"当逆卡巴拉计数器达到0时，C-03-140将与阴影人物签订合同，随后将其释放至设施内。")

//Nosferatu
/obj/item/paper/fluff/info/waw/nosferatu
	abno_type = /mob/living/simple_animal/hostile/abnormality/nosferatu
	abno_code = "O-01-65"
	abno_info = list(
		"O-01-65 的饥渴会随时间累积。逆卡巴拉计数器会随之变化以反映其饥渴程度。",
		"当工作完成时，除非逆卡巴拉计数器处于最大值，否则会从员工身上抽取少量血液。",
		"当工作结果为差时，员工会被强制抽取中等量的血液。",
		"当压迫工作成功时，饥渴程度会增加，但不会抽取血液。",
		"如果同一名员工连续三次被抽血，则会被强制抽取致命量的血液。",
		"当获得过多血液时，该异想体会陷入狂暴并突破收容。",
		"当诺斯费拉图出逃时，它会对血液表现出敏感反应。如果该异想体容易接触到血液，镇压会变得困难。")
	abno_breach_damage_type = "红色/黑色"
	abno_breach_damage_count = "高"

//Servant of Wrath
/obj/item/paper/fluff/info/waw/wrath
	abno_type = /mob/living/simple_animal/hostile/abnormality/wrath_servant
	abno_code = "O-01-139"
	abno_info = list(
		"当工作结果为优时，愤怒侍从不稳定性增加。",
		"执行依恋工作时，不稳定性会提高。",
		"依恋工作结果为优时，愤怒侍从会与工作者成为朋友。",
		"当愤怒侍从的朋友完成工作时，其不稳定性会增加。",
		"执行镇压工作时，不稳定性降低且不受工作结果或友谊影响。",
		"与愤怒侍从成为朋友者可要求其追猎设施内最强威胁。",
		"此时愤怒侍从不稳定性大幅增加，逆卡巴拉计数器减少2点。",
		"愤怒侍从突破收容后，所有镇压尝试均无效。",
		"设施其他区域会出现名为青林隐士的存在。",
		"隐士攻击周围员工，造成巨额白色伤害。",
		"唯一镇压方式是让愤怒侍从杀死青林隐士。",
		"注意：绝大多数情况下青林隐士会压倒愤怒侍从。")

//Sphinx
/obj/item/paper/fluff/info/waw/sphinx
	abno_type = /mob/living/simple_animal/hostile/abnormality/sphinx
	abno_code = "T-03-33"
	abno_info = list(
		"高自律等级员工的工作成功率显著提高。",
		"工作结果为优时，异常有低概率提供宝藏。",
		"工作结果为差时，逆卡巴拉计数器减少。此外，自律等级≤4的员工会丧失一种感官。",
		"被异常石化的员工Joshua可通过金针宝藏解救。")

//Clouded Monk
/obj/item/paper/fluff/info/waw/clouded_monk
	abno_type = /mob/living/simple_animal/hostile/abnormality/clouded_monk
	abno_code = "D-01-110"
	abno_info = list(
		"员工执行洞察工作时SP得到治疗。",
		"每有2名员工死亡，逆卡巴拉计数器减少1点。",
		"当工作结果为一般时，逆卡巴拉计数器有低概率减少。",
		"当工作结果为差时，逆卡巴拉计数器减少。")

//My Sweet Orange Tree
/obj/item/paper/fluff/info/waw/orange_tree
	abno_type = /mob/living/simple_animal/hostile/abnormality/orange_tree
	abno_code = "O-02-23"
	abno_info = list(
		"当工作结果为一般时，员工有普通概率被0-02-23感染。",
		"当工作结果为差时，逆卡巴拉计数器有高概率减少且员工被0-02-23感染。",
		"当逆卡巴拉计数器达到0时，O-02-23将在广阔区域扩散。",
		"经观察确认，该异常会附着员工特定时长，期间持续造成白色伤害。具有高度传染性且难以再收容。",
		"感染者受到红色伤害时有极低概率治愈感染，使用配备的火焰喷射器是更有效的防护手段。",
		"当感染者的SP耗尽时，该员工会陷入惊慌并加速感染扩散。")

//Pygmalion
/obj/item/paper/fluff/info/waw/pygmalion
	abno_type = /mob/living/simple_animal/hostile/abnormality/pygmalion
	abno_code = "M-03-157"
	abno_info = list(
		"最后一名对 M-03-157 进行工作的员工此后将被称作“雕刻家”。",
		"“雕刻家”在对 M-03-157 进行的任何类型工作都会有更高的成功率。",
		"当“雕刻家”取得优级工作结果时，逆卡巴拉计数器有高概率降低。",
		"当工作结果为差时，逆卡巴拉计数器有高概率降低。")

//Parasite Tree
/obj/item/paper/fluff/info/waw/parasite_tree
	abno_type = /mob/living/simple_animal/hostile/abnormality/parasite_tree
	abno_code = "D-04-108"
	abno_info = list(
		"员工完成D-04-108工作后，其自律与谨慎获得祝福提升",
		"每当员工获得祝福，D-04-108会长出发光花蕾",
		"其他异常突破收容时，D-04-108会释放治疗树叶自动寻找理智与生命值最低的员工",
		"当D-04-108花朵绽放时，受祝福员工遭受重度精神侵蚀直至通过镇压工作摧毁花朵",
		"D-04-108-1分泌传染性剧毒，但清除该实体可轻易净化污染区域",
		"注意：通过镇压工作摧毁D-04-108花朵可阻止员工转变为D-04-108-1")

//Dream of Black Swan
//Parasite Tree
/obj/item/paper/fluff/info/waw/black_swan
	abno_type = /mob/living/simple_animal/hostile/abnormality/black_swan
	abno_code = "F-02-70"
	abno_info = list(
		"当2名员工死亡时，F-02-70-1的眼球突然融化",
		"当2名员工惊慌时，F-02-70-2的手臂消失",
		"当2个异常突破收容时，F-02-70-3的双腿化为污泥",
		"当工作结果为差时，F-02-70-4失去耳朵与面颊",
		"当工作结果为一般时，F-02-70-5的下半面部完全消失",
		"因熔毁或破坏导致逆卡巴拉计数器减少时，其中一名兄弟会受伤")

//Apex Predator
/obj/item/paper/fluff/info/waw/predator
	abno_type = /mob/living/simple_animal/hostile/abnormality/apex_predator
	abno_code = "D-04-146"
	abno_info = list(
		"当工作结果为一般时，逆卡巴拉计数器有普通概率减少。",
		"当工作结果为差时，逆卡巴拉计数器会减少。",
		"当员工以非满血状态工作时，工作伤害大幅增加。",
		"当工作员工死亡或失去意识时，逆卡巴拉计数器会减少。",
		"危险 - 顶级掠食者突破收容后必须立即定位。")
	abno_breach_damage_type = "红色"
	abno_breach_damage_count = "极高"

//Baba Yaga
/obj/item/paper/fluff/info/waw/babayaga
	abno_type = /mob/living/simple_animal/hostile/abnormality/babayaga
	abno_code = "M-04-166"
	abno_info = list(
		"当工作结果为一般时，逆卡巴拉计数器有普通概率减少。",
		"当工作结果为差时，逆卡巴拉计数器减少。此外，员工会遭到冰冻奴隶群攻击。",
		"当勇气与自律等级均<4的员工完成工作时，逆卡巴拉计数器减少。该员工同时会遭到冰冻奴隶群攻击。",
		"芭芭雅嘎突破收容时会产生强力冲击波，附近员工根据距离承受等比例巨额红色伤害。",
		"芭芭雅嘎每次落地时，会召唤小群冰冻奴隶攻击附近员工。")
	abno_breach_damage_type = "红色"
	abno_breach_damage_count = "极高"

//Big and Will be Bad Wolf
/obj/item/paper/fluff/info/waw/big_wolf
	abno_type = /mob/living/simple_animal/hostile/abnormality/big_wolf
	abno_code = "F-02-58"
	abno_info = list(
		"当工作结果为差时，逆卡巴拉计数器减少且工作员工被吞噬。",
		"当员工执行本能工作获得优等结果时，F-02-58会吐出所有被吞噬员工。",
		"当F-02-58生命值低于50%时，其嚎叫会削弱附近异常的收容强度。"
		)

//Poor Screenwriter's Note
/obj/item/paper/fluff/info/waw/screenwriter
	abno_type = /mob/living/simple_animal/hostile/abnormality/screenwriter
	abno_code = "O-05-29" //originally O-05-31 in lobotomy corp, but it's taken by TSO.
	abno_info = list(
		"落魄编剧的笔记要求一切按照其剧本发展，工作也不例外。若不确定如何操作，请翻页。",
		"当工作结果为差时，逆卡巴拉计数器会减少。",
		"当逆卡巴拉计数器达到0时，数名员工将被选中参演一场\"戏剧\"",
		"扮演\"懦夫\"的员工力量下降，扮演\"破碎者\"的生命值降低，扮演\"失败者\"的精神值减少。",
		"扮演\"受害者\"的员工遭受最严酷的命运：全属性下降并被演员\"A\"追杀。",
		"当\"受害者\"死亡或不存在时，另一角色将被选为新的\"受害者\"。",
		"当演员\"A\"被击败时，异常被镇压。")
	abno_work_rates = list(
		"营养" = "低",
		"清洁" = "低",
		"共识" = "低",
		"娱乐" = "低",
		"暴力" = "低")
	abno_breach_damage_type = "白色"
	abno_breach_damage_count = "高"

//Sign of Roses
/obj/item/paper/fluff/info/waw/rose_sign
	abno_type = /mob/living/simple_animal/hostile/abnormality/rose_sign
	abno_code = "O-04-177" //O-04-21-22 in LCB
	abno_info = list(
		"执行洞察工作时，玫瑰印记收容单元内会种植一朵玫瑰。",
		"当存在四朵玫瑰时执行洞察工作，逆卡巴拉计数器会减少。",
		"执行镇压工作时，一朵已种植玫瑰会枯萎。",
		"无玫瑰状态下执行镇压工作，逆卡巴拉计数器会减少。",
		"收容单元内生长的玫瑰（编号O-04-177-1）大幅提升所有工作成功率和PE-Box产量。",
		"员工Orga在多朵O-04-177-1存在时工作承受了远超预期的伤害。",
		"玫瑰印记突破收容时，所有员工被标记荆棘王冠。O-04-177-1会周期性地出现在被标记者附近并将其击杀。",
		"当O-04-177-1被镇压时，玫瑰印记会进入易伤状态。")
	abno_breach_damage_type = "黑色"
	abno_breach_damage_count = "低"

//Dream-Devouring Siltcurrent
/obj/item/paper/fluff/info/waw/siltcurrent
	abno_type = /mob/living/simple_animal/hostile/abnormality/siltcurrent
	abno_code = "T-02-179"
	abno_info = list(
		"勇气等级≤2的员工完成工作时，逆卡巴拉计数器会减少。",
		"当工作结果为差时，逆卡巴拉计数器会减少。",
		"员工因缺氧昏迷时，逆卡巴拉计数器会减少。",
		"工作期间，Jimbo注意到氧气持续流失。",
		"突破收容后，设施将处于水淹状态直至噬梦浊流被再收容。",
		"水淹状态下，靠近噬梦浊流的员工持续受到缺氧伤害。",
		"突破收容时，设施各处出现漂浮残骸。",
		"LaVerne攻击残骸或噬梦浊流时可恢复部分氧气。",
		"当噬梦浊流试图潜入破损残骸时，会陷入短暂眩晕并受到重创。",
		"眩晕状态下噬梦浊流承受额外伤害。")
	abno_breach_damage_type = "红色"
	abno_breach_damage_count = "极高"

//Little Red Riding Hooded Mercenary
/obj/item/paper/fluff/info/waw/red_hood
	abno_type = /mob/living/simple_animal/hostile/abnormality/red_hood
	abno_code = "F-01-57"
	abno_info = list(
		"雇佣F-01-57镇压突破异常或处决考验是高效策略，但需支付相应代价。",
		"镇压异常的费用随风险等级递增，非异常目标的费用随工作日推进而增加。",
		"任务期间F-01-57不攻击员工，镇压完成后自动返回收容。",
		"异常突破时逆卡巴拉计数器减少，但O-02-56（一无所有）突破除外。",
		"遭遇F-01-117（蓝袍牧童）、F-02-127（痛苦的巴迪）及F-02-58（大灰狼）时反应强烈。",
		"此时F-01-57进入情感高涨状态：攻速提升、伤害双向增加、自动追踪目标。",
		"若未能击杀F-02-58，F-01-57将陷入狂暴状态。"
		)

//My Form Empties
/obj/item/paper/fluff/info/waw/my_form_empties
	abno_type =  /mob/living/simple_animal/hostile/abnormality/my_form_empties
	abno_code = "M-04-199"//M-04-04-04 in limbus company
	abno_info = list(
		"计数器为2时无我入定吟诵经文，恢复附近员工SP。",
		"计数器降为1时进入无我相状态，提升工作成功率。",
		"无我相状态下工作结果为优时，计数器减少。",
		"无我相状态下工作结果为一般时，计数器增加；否则有低概率减少。",
		"当工作结果为差时，计数器减少。",
		"突破收容时，数个敌对实体M-04-199-1随行。",
		"突破收容时所有员工受业报影响，承受伤害增加。",
		"业报可通过攻击除M-04-199外的实体转移。"
		)
	abno_breach_damage_type = "白色"
	abno_breach_damage_count = "极高"

//Hookah Caterpillar
/obj/item/paper/fluff/info/waw/caterpillar
	abno_type = /mob/living/simple_animal/hostile/abnormality/caterpillar
	abno_code = "F-02-190"
	abno_info = list(
		"F-02-190 拥有自己的羽化计数器，因此其收容单元内配备了一个检测器来监测该计数器的当前等级。",
		"对 F-02-190 进行压制以外类型的工作会增加其羽化计数器。",
		"当工作顺利进行时，James 会持续受到白色伤害，直到其精神值降至 20% 以下。",
		"当正义等级为 5 级的员工完成对 F-02-190 的压制工作时，羽化计数器会被重置为 0。",
		"F-02-190 的羽化计数器越高，它能产生的能量和 PE 箱就越多，同时员工面临的风险也越大。",
		"当羽化计数器变得过高时，对 F-02-190 进行压制以外的工作会导致其突破收容。",
		"突破收容后，F-02-190 会向整个设施释放烟雾。任何吸入烟雾的人都会受到苍白伤害。"
	)
	abno_breach_damage_type = "青色"
	abno_breach_damage_count = "极高"

// Ardor Blossom Moth
/obj/item/paper/fluff/info/waw/ardor_blossom_moth
	abno_type = /mob/living/simple_animal/hostile/abnormality/ardor_moth
	abno_code = "T-02-182"
	abno_info = list(
		"当工作结果为差时，逆卡巴拉计数器减少2。",
		"每隔一段时间，T-02-182收容单元前及内部区域会散落余烬。",
		"当余烬落在员工身上时，逆卡巴拉计数器降低。",
		"当员工缓慢走过余烬时，余烬落在其身上的几率会显著降低。",
		"当工作结果为普通时，逆卡巴拉计数器有低概率增加。",
		"当工作结果为优时，逆卡巴拉计数器有高概率增加。此外，如果存在余烬，它们会暂时消散。",
	)
	abno_breach_damage_type = "火焰/红色"
	abno_breach_damage_count = "极高"

// The Burrowing Heaven(穿刺乐园)
/obj/item/paper/fluff/info/waw/burrowing_heaven
	abno_type = /mob/living/simple_animal/hostile/abnormality/burrowing_heaven
	abno_code = "O-04-72"
	abno_info = list(
		"在对穿刺乐园进行工作时，必须保持主管或两名员工在场并使异想体时刻处于视线范围内.",
		"在工作过程中，当异想体离开视线范围时，逆卡巴拉计数器会降低. 当穿刺乐园的收容单元在现象发生后仍处于无人监控状态时，计数器会继续降低.",
		"当工作结果为普通或良好时，逆卡巴拉计数器会增加. 似乎可以根据工作结果一次性增加多达3个计数.",
		"<警告> 在镇压过程中不要停止观察异想体。",
	)
	abno_breach_damage_type = "黑色"
	abno_breach_damage_count = "极高"
