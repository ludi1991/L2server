---------------------------
--the data's from an Excel, don't edit it here
---------------------------

local value_list = {} 

value_list[1] = {id=1,classification=1,speaker="model",showName="guide",icon="6",expression=nil,dec="欧尼酱，你醒啦，真是担心死我了，都晕过去好几天了。",skip=nil,}
value_list[2] = {id=2,classification=1,speaker="model",showName="guide",icon="8",expression=nil,dec="为了看护好欧尼酱，喵酱的视野得紧紧跟随欧尼酱^~^",skip=1,}
value_list[3] = {id=3,classification=2,speaker="model",showName="guide",icon="2",expression=nil,dec="有事情点击我下，我就知道欧尼酱在呼唤我啦。",skip=1,}
value_list[4] = {id=4,classification=3,speaker="model",showName="guide",icon="0",expression=nil,dec="艾丝姐姐独自一人去无尽之塔去探索魔龙的线索了。",skip=nil,}
value_list[5] = {id=5,classification=3,speaker="model",showName="guide",icon="4",expression=nil,dec="还好右上角的战斗雷达可以实时看到艾丝姐姐的战况",skip=nil,}
value_list[6] = {id=6,classification=3,speaker="model",showName="guide",icon="3",expression=nil,dec="我担心她的危险，咱们快过去找她吧！",skip=nil,}
value_list[7] = {id=7,classification=4,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="现已经解锁第二个关卡了，这一关的boss比较强大！\n我们先去查看一下刚刚敌人掉落的武器部件吧！",skip=1,}
value_list[8] = {id=8,classification=5,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="貌似是个不错的装备，咱们赶紧帮艾丝姐姐装备上吧！",skip=1,}
value_list[9] = {id=9,classification=6,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="不知不觉中，好像还完成了一些任务，那么现在就去看看任务吧！",skip=1,}
value_list[10] = {id=10,classification=7,speaker="L",showName="喵酱",icon="guide",expression="guide_kaixin",dec="哇哦，完成了一个任务，奖励装备强化所需的强化石。",skip=1,}
value_list[11] = {id=11,classification=8,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="现在修整完毕，我们可以再去无尽之塔探索一下。",skip=1,}
value_list[12] = {id=12,classification=9,speaker="L",showName="喵酱",icon="guide",expression="guide_kaixin",dec="太好了，有了强化石，现在就学学怎么强化武器吧！",skip=1,}

value_list[101] = {id=101,classification=100,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="欧尼酱，咱们到无尽之塔的底层了，艾丝姐姐就在前方！",skip=1,}
value_list[102] = {id=102,classification=100,speaker="L",showName="枪炮射手-艾丝",icon="role_1",expression="role_1_kaixin",dec="队长大人你醒了！还好你没事^~^",skip=1,}
value_list[103] = {id=103,classification=100,speaker="L",showName="队长大人",icon="player",expression="player_weisuo",dec="（口水）你就是艾丝，卡哇伊戴斯乃，给我配了这么一个女主真是好福利啊Ψ(￣∀￣)Ψ",skip=1,}
value_list[104] = {id=104,classification=100,speaker="L",showName="枪炮射手-艾丝",icon="role_1",expression="role_1_haixiu",dec="喵酱，队长大人他在乱说些什么==",skip=1,}
value_list[105] = {id=105,classification=100,speaker="L",showName="喵酱",icon="guide",expression="guide_jionglian",dec="（尴尬）今天醒来后就这样，可能头部受伤了，变成脑残党了吧。",skip=1,}
value_list[106] = {id=106,classification=100,speaker="L",showName="队长大人",icon="player",expression="player_jionglian",dec="（无奈）（╬￣皿￣）喂，我才不是传说脑残兄贵呢！",skip=1,}
value_list[107] = {id=107,classification=100,speaker="R",showName="黑化镰刀杀手",icon="role_black_2",expression=nil,dec="魔龙圣地，竟然有人敢闯进来！",skip=1,}
value_list[108] = {id=108,classification=100,speaker="L",showName="喵酱",icon="guide",expression="guide_fanu",dec="（尴尬）不好，有个扛着镰刀的姐姐！",skip=1,}
value_list[108] = {id=108,classification=100,speaker="L",showName="枪炮射手-艾丝",icon="role_1",expression="role_1_chijing",dec="（疑问）魔龙杀手团的人怎么会在这里？",skip=1,}
value_list[109] = {id=109,classification=100,speaker="R",showName="黑化镰刀杀手",icon="role_black_2",expression=nil,dec=" 用我的的镰刀来告诉你答案吧！",skip=1,}
value_list[110] = {id=110,classification=100,speaker="L",showName="枪炮射手-艾丝",icon="role_1",expression="role_1_fanu",dec="看来她也已经被黑化了，就由我来挑战她吧，你们在边上注意安全。",skip=1,}

value_list[111] = {id=111,classification=199,speaker="R",showName="受伤的黑化镰刀杀手",icon="broken_role_black_2",expression=nil,dec="好强大的主角光环，作为新手怪物，果然光荣的领便当了==",skip=1,}
value_list[112] = {id=112,classification=199,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="哇，姐姐好厉害，以后咱们队伍就有安全保障了，不像某人，只知道嘴炮，战斗力只有5 (-､-) ",skip=1,}
value_list[113] = {id=113,classification=199,speaker="L",showName="队长大人",icon="player",expression="player_jionglian",dec=" (￣ε(#￣) 哦咦！你难道不也是嘛，还吐槽你老哥我！不过话说回来，我好歹也是队长，怎么没有战斗力呢（疑问）",skip=1,}
value_list[114] = {id=114,classification=199,speaker="L",showName="喵酱",icon="guide",expression="guide_jionglian",dec="咦，欧尼酱你难道忘了，咱们武器召唤师都是召唤武器少女上场作战，咱们只是作为指挥的呢？",skip=1,}
value_list[115] = {id=115,classification=199,speaker="L",showName="队长大人",icon="player",expression="player_weisuo",dec="酱紫啊，那还倒是既省事又安全呢，还可以召唤不同的美眉上场对不对？",skip=1,}
value_list[116] = {id=116,classification=199,speaker="L",showName="枪炮射手-艾丝",icon="role_1",expression="role_1_zhengchang",dec="这里很危险，我们还是回去讨论吧。",skip=1,}

value_list[201] = {id=201,classification=200,speaker="R",showName="黑化镰刀杀手",icon="role_black_2",expression=nil,dec=" (つ﹏⊂) 囧，你们怎么又来了，求放过，好不容易开发组又给我加了点戏份==",skip=1,}
value_list[202] = {id=202,classification=200,speaker="L",showName="枪炮射手-艾丝",icon="role_1",expression="role_1_fanu",dec="你是魔龙杀手团的吧，知道红月在哪里嘛？",skip=1,}
value_list[203] = {id=203,classification=200,speaker="R",showName="黑化镰刀杀手",icon="role_black_2",expression=nil,dec="哼，红月大人岂是你们能见的，打赢我再说！",skip=1,}
value_list[204] = {id=204,classification=289,speaker="R",showName="黑化镰刀杀手",icon="role_black_2",expression=nil,dec=" (￣ε(#￣)呜呜，演坏人真辛苦啊，被打的满地找牙==",skip=1,}
value_list[205] = {id=205,classification=289,speaker="L",showName="枪炮射手-艾丝",icon="role_1",expression="role_1_zhengchang",dec="红月她在哪？",skip=1,}
value_list[206] = {id=206,classification=289,speaker="L",showName="喵酱",icon="guide",expression="guide_fanu",dec="不说就把你吊起来打哦~",skip=1,}
value_list[207] = {id=207,classification=289,speaker="R",showName="受伤的黑化镰刀杀手",icon="broken_role_black_2",expression=nil,dec="(疼)别、别，红月大人就在无尽之塔的上层。不过你们得先过团长大人那一关。",skip=1,}
value_list[208] = {id=208,classification=294,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="现已经解锁第三个关卡了，这一关的boss比较强大！\n我们先去查看一下刚刚敌人掉落的武器部件吧！",skip=nil,}
value_list[209] = {id=209,classification=295,speaker="L",showName="喵酱",icon="guide",expression="guide_kaixin",dec="貌似是个不错的装备，咱们赶紧帮艾丝姐姐装备上吧！",skip=nil,}

value_list[301] = {id=301,classification=300,speaker="R",showName="黑化镰刀团长",icon="role_black_2",expression=nil,dec="十步杀一人，千里不留行。死在我的刀下，是你们的荣幸！",skip=1,}
value_list[302] = {id=302,classification=300,speaker="L",showName="喵酱",icon="guide",expression="guide_kuqi",dec="（尴尬）这位姐姐好大的气场！",skip=1,}
value_list[303] = {id=303,classification=300,speaker="L",showName="枪炮射手-艾丝",icon="role_1",expression="role_1_fanu",dec="（谨慎）小心，对方实力很强！",skip=1,}



value_list[305] = {id=305,classification=389,speaker="R",showName="受伤的黑化镰刀团长",icon="broken_role_black_2",expression=nil,dec="Orz怎么会输了？不可能啊，明明按照设定我可是团长大人啊（吐血）",skip=1,}
value_list[306] = {id=306,classification=389,speaker="L",showName="枪炮射手-艾丝",icon="role_1",expression="role_1_kaixin",dec="这也许就是正义的力量！",skip=1,}
value_list[307] = {id=307,classification=389,speaker="L",showName="队长大人",icon="player",expression="player_kaixin",dec="（得意）嘻嘻，明明是我技能指挥的好Ψ(￣∀￣)Ψ",skip=1,}
value_list[308] = {id=308,classification=389,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="少臭美了，你连技能具体设定都还不清楚吧。我带你去了解下吧！",skip=nil,}
value_list[309] = {id=309,classification=394,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="武器少女的技能相辅相成，各有特色，我们先查看一下艾丝姐姐的技能吧！",skip=nil,}

value_list[401] = {id=401,classification=400,speaker="R",showName="黑化镰刀团长",icon="role_black_2",expression=nil,dec="又是你们，上次不小心输了，这次可没那么容易咯！",skip=1,}
value_list[402] = {id=402,classification=400,speaker="L",showName="枪炮射手-艾丝",icon="role_1",expression="role_1_haixiu",dec="现在魔龙肆掠人间，早已不是我们守护的那个神龙了，现在枪炮部队也。。。",skip=1,}
value_list[403] = {id=403,classification=400,speaker="R",showName="黑化镰刀团长",icon="role_black_2",expression=nil,dec="（╬￣皿￣）打住，不准神龙大人的威名！他，可是人家的偶像呢Ψ(￣∀￣)Ψ",skip=1,}
value_list[404] = {id=404,classification=400,speaker="L",showName="喵酱",icon="guide",expression="guide_jionglian",dec="（尴尬）对面这姐姐好不讲道理哦，亏还是什么团长呢！",skip=1,}
value_list[405] = {id=405,classification=400,speaker="L",showName="枪炮射手-艾丝",icon="role_1",expression="role_1_zhengchang",dec="没办法，应该是被什么邪恶能量控制了吧。看来必须一战了！",skip=1,}



value_list[409] = {id=409,classification=489,speaker="R",showName="受伤的黑化镰刀团长",icon="broken_role_black_2",expression=nil,dec="可恶的剧本，我还以为我是个什么终极boss呢，我去找策划单挑！",skip=1,}

value_list[501] = {id=501,classification=500,speaker="R",showName="镰刀死神-红月",icon="role_2",expression="role_2_fanu",dec="猩红之月，死亡之血！",skip=1,}
value_list[502] = {id=502,classification=500,speaker="L",showName="枪炮射手-艾丝",icon="role_1",expression="role_1_haixiu",dec="红。。。红月？",skip=1,}
value_list[503] = {id=503,classification=500,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="原来这就是艾丝姐姐的朋友啊，看着不像坏人啊？",skip=1,}
value_list[504] = {id=504,classification=500,speaker="R",showName="镰刀死神-红月",icon="role_2",expression="role_2_zhengchang",dec="艾丝，好久不见。果然，你我之间，必有一战！",skip=1,}
value_list[505] = {id=505,classification=500,speaker="L",showName="枪炮射手-艾丝",icon="role_1",expression="role_1_aichou",dec="难道真的要这样嘛，红月？",skip=1,}
value_list[506] = {id=506,classification=500,speaker="R",showName="镰刀死神-红月",icon="role_2",expression="role_2_fanu",dec="让我看看你有没有变强？",skip=1,}



value_list[508] = {id=508,classification=589,speaker="R",showName="镰刀死神-红月",icon="role_2",expression="role_2_kaixin",dec="（释然）艾丝，你变强了，恭喜你！",skip=1,}
value_list[509] = {id=509,classification=589,speaker="L",showName="枪炮射手-艾丝",icon="role_1",expression="role_1_kaixin",dec="红月，现在魔龙肆掠人间，早已不是我们守护的那个神龙了，你和我们一起去讨伐魔龙，守护和平吧！",skip=1,}
value_list[510] = {id=510,classification=589,speaker="L",showName="队长大人",icon="player",expression="player_weisuo",dec="（口水）对啊对啊，快到碗里来！",skip=1,}
value_list[511] = {id=511,classification=589,speaker="R",showName="镰刀死神-红月",icon="role_2",expression="role_2_kaixin",dec="其实我只是卧底在此探寻魔龙的情报的。",skip=1,}
value_list[512] = {id=512,classification=589,speaker="R",showName="枪炮射手-艾丝",icon="role_1",expression="role_1_kuqi",dec="吓死我了，以为姐姐你也被魔龙黑化了==",skip=1,}
value_list[513] = {id=513,classification=589,speaker="R",showName="镰刀死神-红月",icon="role_2",expression="role_2_kaixin",dec="哈哈，朋友在哪里，我就在哪里。",skip=1,}
value_list[514] = {id=514,classification=589,speaker="L",showName="队长大人",icon="player",expression="player_weisuo",dec="耶，太好了，咱们一起回去吃顿大餐庆祝一下吧",skip=1,}
value_list[515] = {id=515,classification=589,speaker="R",showName="镰刀死神-红月",icon="role_2",expression="role_2_haixiu",dec="有点饿了，好怀念以前和艾丝一起打猎时的烤乳猪呢~",skip=nil,}
value_list[516] = {id=516,classification=589,speaker="L",showName="枪炮射手-艾丝",icon="role_1",expression="role_1_kaixin",dec="我也是，以后能一起并肩作战，真是太好了！魔龙肯定会被我们打败",skip=1,}
value_list[517] = {id=517,classification=589,speaker="L",showName="队长大人",icon="player",expression="player_weisuo",dec="这么快就开始开后宫了，太开心了！",skip=nil,}
value_list[518] = {id=518,classification=594,speaker="L",showName="喵酱",icon="guide",expression="guide_kaixin",dec="太好了，咱们的队伍又变强了，红月可是有很厉害的持续作战能力呢，欧尼酱赶紧去和她熟悉一下吧",skip=nil,}
value_list[519] = {id=519,classification=595,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="武器少女需要和欧尼酱先签订契约之后才能出战",skip=nil,}
value_list[520] = {id=520,classification=595,speaker="L",showName="喵酱",icon="guide",expression="guide_kaixin",dec="和欧尼酱签订的武器少女们之间还能通过灵魂连接增强能力",skip=nil,}
value_list[521] = {id=521,classification=595,speaker="L",showName="队长大人",icon="player",expression="player_weisuo",dec="百合大法好啊(。⌒∇⌒)。",skip=nil,}

value_list[601] = {id=601,classification=600,speaker="R",showName="黑化的雷电之眼",icon="role_black_3",expression=nil,dec="每打敌人一次，都可以让他们更弱一些",skip=1,}
value_list[602] = {id=602,classification=600,speaker="L",showName="喵酱",icon="guide",expression="guide_jionglian",dec="对面怎么有个自言自语的萝莉",skip=1,}
value_list[603] = {id=603,classification=600,speaker="L",showName="镰刀死神-红月",icon="role_2",expression="role_2_fanu",dec="他们是雷电系少女皮卡的复制体，他们的破坏力很高，让我来对付她吧",skip=1,}
value_list[604] = {id=604,classification=600,speaker="R",showName="黑化的雷电之眼",icon="role_black_3",expression=nil,dec="每打敌人一次，都可以让他们更弱一些",skip=1,}
value_list[605] = {id=605,classification=600,speaker="L",showName="镰刀死神-红月",icon="role_2",expression="role_2_fanu",dec="我不会让你们发挥出你们的战斗优势的。速战速决吧，我还要回去吃烤乳猪",skip=1,}
value_list[606] = {id=606,classification=689,speaker="L",showName="镰刀死神-红月",icon="role_2",expression="role_2_kaixin",dec="（贪吃）走吧，回去看看乳猪烤熟了没",skip=1,}
value_list[607] = {id=607,classification=694,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="装备镶嵌系统开启了！宝石什么的乖乖拿来！",skip=nil,}
value_list[608] = {id=608,classification=694,speaker="L",showName="队长大人",icon="player3",expression="player_jionglian",dec="哈哈哈，发财咯发财咯，我要收集很多大宝石",skip=nil,}
value_list[609] = {id=609,classification=695,speaker="L",showName="喵酱",icon="guide",expression="guide_fanu",dec="想什么呢！快点快点！",skip=nil,}
value_list[610] = {id=610,classification=695,speaker="L",showName="队长大人",icon="player3",expression="player_jionglian",dec="喵酱你今天怎么了…",skip=nil,}

value_list[701] = {id=701,classification=700,speaker="R",showName="黑化的雷电之眼",icon="role_black_3",expression=nil,dec="每打敌人一次，都可以让他们更弱一些",skip=1,}
value_list[702] = {id=702,classification=700,speaker="L",showName="喵酱",icon="guide",expression="guide_beishang",dec="她应该也只是复制体吧，只会说这一句话",skip=1,}
value_list[801] = {id=801,classification=800,speaker="R",showName="黑化的雷电之眼",icon="role_black_3",expression=nil,dec="每打敌人一次，都可以让他们更弱一些",skip=1,}
value_list[901] = {id=901,classification=900,speaker="R",showName="黑化的雷电之眼",icon="role_black_3",expression=nil,dec="每打敌人一次，都可以让他们更弱一些",skip=1,}
value_list[902] = {id=902,classification=905,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="快速挂机系统开启！不来试试吗？",skip=1,}
value_list[903] = {id=903,classification=905,speaker="L",showName="队长大人",icon="player6",expression="player_weisuo",dec="要是健身也能<快速挂肌>就好了...",skip=nil,}

value_list[904] = {id=904,classification=950,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="解锁新玩法-实验室！",skip=nil,}
value_list[905] = {id=905,classification=950,speaker="L",showName="喵酱",icon="guide",expression="guide_kaixin",dec="赶快去看看吧！",skip=nil,}

value_list[1001] = {id=1001,classification=1000,speaker="R",showName="雷电之眼-皮卡",icon="role_3",expression="role_3_fanu",dec="什么人来骚扰本大小姐？",skip=1,}
value_list[1002] = {id=1002,classification=1000,speaker="L",showName="镰刀死神-红月",icon="role_2",expression="role_2_kaixin",dec="皮卡，好久不见",skip=1,}
value_list[1003] = {id=1003,classification=1000,speaker="R",showName="雷电之眼-皮卡",icon="role_3",expression="role_3_zhengchang",dec="这不是红月姐姐嘛，怎么和一群坏人在一起呢？",skip=1,}
value_list[1004] = {id=1004,classification=1000,speaker="L",showName="镰刀死神-红月",icon="role_2",expression="role_2_kaixin",dec="他们是我的朋友，我现在和他们并肩作战。",skip=1,}
value_list[1005] = {id=1005,classification=1000,speaker="R",showName="雷电之眼-皮卡",icon="role_3",expression="role_3_kaixin",dec="终于有机会和你比一比，看看到底谁才是最厉害的武器少女。",skip=1,}

value_list[1007] = {id=1007,classification=1099,speaker="R",showName="雷电之眼-皮卡",icon="role_3",expression="role_3_kuqi",dec="唉，早知道这样，本大小姐就不放水了~所以不要以为你真的赢了我哦！",skip=1,}
value_list[1008] = {id=1008,classification=1099,speaker="L",showName="枪炮射手-艾丝",icon="role_1",expression="role_1_zhengchang",dec="现在魔龙肆掠人间，早已不是我们守护的那个神龙了，我们需要你一起啊!",skip=1,}
value_list[1009] = {id=1009,classification=1099,speaker="L",showName="队长大人",icon="player",expression="player_weisuo",dec="小妹妹，看你还有点本领，就和本大人一起对抗魔龙吧，本大人肯定不会亏待你的（贼笑）~",skip=1,}
value_list[1010] = {id=1010,classification=1099,speaker="R",showName="雷电之眼-皮卡",icon="role_3",expression="role_3_haixiu",dec="好吧==，既然你们都这么哀求我，那就勉强答应你吧，不过可不要指望我出力哦~",skip=1,}
value_list[1011] = {id=1011,classification=1099,speaker="L",showName="队长大人",icon="player",expression="player_jionglian",dec="（╬￣皿￣）哪里有哀求你？你有什么好勉强的啊？",skip=1,}
value_list[1012] = {id=1012,classification=1099,speaker="L",showName="喵酱",icon="guide",expression="guide_haixiu",dec="太好了，我们队伍又有新成员了！虽然我对她没什么好感。",skip=1,}
value_list[1013] = {id=1013,classification=1100,speaker="L",showName="队长大人",icon="player",expression="player_weisuo",dec="哈哈，后宫又添一名，还是名傲娇萝莉!",skip=1,}

value_list[1200] = {id=1200,classification=1200,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="解锁了竞技场！",skip=nil,}
value_list[1201] = {id=1201,classification=1200,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="在这里可以与小伙伴们展开猫斗，哦不，是战斗。",skip=nil,}
value_list[1202] = {id=1202,classification=1200,speaker="L",showName="喵酱",icon="guide",expression="guide_kaixin",dec="有没有很兴奋啊？赶快去试试看吧！",skip=nil,}

value_list[1501] = {id=1501,classification=1500,speaker="R",showName="狮王之拳-濑蒽",icon="role_4",expression="role_4_kaixin",dec="让你们尝尝拳拳到肉的感觉！",skip=1,}
value_list[1502] = {id=1502,classification=1594,speaker="R",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="拳套姐姐也加入我们了！",skip=1,}
value_list[1503] = {id=1503,classification=1594,speaker="R",showName="喵酱",icon="guide",expression="guide_kaixin",dec="快来看看新的后宫，哦不，是队员。",skip=1,}
value_list[1601] = {id=1601,classification=1600,speaker="R",showName="黑化枪炮士兵",icon="role_black_2",expression=nil,dec="既然闯到了开发组正在开发中的副本，快去给开发组点个赞吧！",skip=1,}
value_list[1701] = {id=1701,classification=1700,speaker="R",showName="黑化枪炮士兵",icon="role_black_2",expression=nil,dec="既然闯到了开发组正在开发中的副本，快去给开发组点个赞吧！",skip=1,}
value_list[1801] = {id=1801,classification=1800,speaker="R",showName="黑化枪炮士兵",icon="role_black_2",expression=nil,dec="既然闯到了开发组正在开发中的副本，快去给开发组点个赞吧！",skip=1,}
value_list[1901] = {id=1901,classification=1900,speaker="R",showName="黑化枪炮士兵",icon="role_black_2",expression=nil,dec="既然闯到了开发组正在开发中的副本，快去给开发组点个赞吧！",skip=1,}
value_list[2001] = {id=2001,classification=2000,speaker="R",showName="黑化枪炮士兵",icon="role_black_2",expression=nil,dec="既然闯到了开发组正在开发中的副本，快去给开发组点个赞吧！",skip=1,}
value_list[2500] = {id=2500,classification=2500,speaker="L",showName="喵酱",icon="guide",expression="guide_kaixin",dec="恭喜欧尼酱解锁了召唤师技能系统，快去查看下召唤师技能吧！",skip=1,}


value_list[10100] = {id=10100,classification=10100,speaker="L",showName="喵酱",icon="guide",expression="guide_kaixin",dec="队长大人可以指挥武器少女释放技能。记得艾丝姐姐的被动天赋是暴击伤害提升25%哦",skip=1,}
value_list[10101] = {id=10101,classification=10100,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="现在，试试看释放普通攻击吧！普通攻击不仅造成伤害，也会增加能量。",skip=1,}
value_list[10110] = {id=10110,classification=10110,speaker="L",showName="喵酱",icon="guide",expression="guide_kaixin",dec="获得了能量，可以释放特殊技能了",skip=1,}
value_list[10111] = {id=10111,classification=10110,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="使用技能的效果比普通攻击更好！这个技能是必然暴击的，和艾丝姐姐的被动完美配合。",skip=1,}

value_list[10200] = {id=10200,classification=10200,speaker="L",showName="喵酱",icon="guide",expression="guide_kaixin",dec="这次我们又有一个新技能可以使用啦！",skip=1,}
value_list[10201] = {id=10201,classification=10200,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="赶快试一试！虽然伤害低一些，但是可以增加艾丝姐姐3回合的攻击力呢！",skip=1,}

value_list[10300] = {id=10300,classification=10300,speaker="L",showName="喵酱",icon="guide",expression="guide_jionglian",dec="危险，我们赶紧释放XP大招吧",skip=1,}
value_list[10301] = {id=10301,classification=10300,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="使用大招会消耗非常多的怒气值，但是杀伤力也非同一般！艾丝姐姐的大招攻击的暴击概率可是翻倍的哦！",skip=1,}

value_list[10400] = {id=10400,classification=10400,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="武器少女的装备开启了镶嵌系统，欧尼酱赶紧随我去了解下吧",skip=nil,}
value_list[10401] = {id=10401,classification=10401,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="花费一定金币在装备上开出宝石孔，有了宝石孔才可以镶嵌宝石",skip=nil,}
value_list[10402] = {id=10402,classification=10402,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="选择一个宝石镶嵌上去吧，镶嵌上后也可以自由卸下和更换哦",skip=nil,}
value_list[10500] = {id=10500,classification=10500,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="欧尼酱，这是生产材料的实验室，我们可以生产下金币",skip=nil,}
value_list[10501] = {id=10501,classification=10501,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="实验室上产的金币可能会被他人抢劫，欧尼酱要格外小心哦，当然我们也是可以抢劫别人的！",skip=nil,}
value_list[10502] = {id=10502,classification=10502,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="实验室-复仇介绍",skip=nil,}
value_list[10503] = {id=10503,classification=10503,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="实验室-结束语",skip=nil,}
value_list[10600] = {id=10600,classification=10600,speaker="L",showName="喵酱",icon="guide",expression="guide_zhengchang",dec="恭喜欧尼酱开启了属于自己的召唤师技能系统",skip=nil,}







return value_list
