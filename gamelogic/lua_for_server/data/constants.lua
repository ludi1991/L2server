require "config"

SCREEN_WIDTH = 1136
SCREEN_HEIGHT = 640
--unit converter   
-- textNum=require "view.Sprite.UnitConSprite"
--model dir
MODEL_PLAYER_DIR    = "live2d/player/"
MODEL_PLAYER    = "Lead.model.json"

MODEL_PLAYER_NEW_DIR = "live2d/player_new/"
MODEL_PLAYER_NEW = "Lead_1.model.json"

MODEL_PLAYER_MODEL_DIR = "live2d/model/"
MODEL_PLAYER_MODEL = "Lead_00.model.json"

MODEL_PLAYER_LEAD_DIR = "live2d/Lead/"
MODEL_PLAYER_LEAD = "Lead_00.model.json"

IMAGE_TITLE = "title/title.png"
IMAGE_TITLEBG = "title/titlebg.png"
IMAGE_TITLECIRCLE = "title/titlecircle.png"
IMAGE_TITLELIGHT = "title/titlelight.png"

IMAGE_BACK = "equipment/Cancel_button.png"
IMAGE_CHOOSEBACK="ui/fightScene/UI_fightScene_return.png"
IMAGE_CHOOSEBACKEFFECT="ui/fightScene/UI_fightScene_returnDown.png"
IMAGE_BG = "mainScenebg/mainbg.png"

SPINE_01 = "spine/1.ExportJson"
SPINE_02 = "spine/2.ExportJson"
SPINE_03 = "spine/Extelle.ExportJson"


MISIC_TITLE = "title/titlelight.wav"
FIGHT_BG="mainScenebg/fightbg.png"
FIGHT_GRASS="mainScenebg/fingGrass.png"

--装备的资源
IMAGE_TITLEEQUIPMENT = "equipment/background.png"
IMAGE_SUITEQUIPMENT = "equipment/Aries_suit_word.png"
IMAGE_ARROWEQUIPMENT = "equipment/Arrow.png"
IMAGE_FRAMEEQUIPMENT = "equipment/Background_frame.png"
IMAGE_BOXEQUIPMENT = "equipment/Blue_box.png"
IMAGE_CANCELEQUIPMENT = "equipment/Cancel_button.png"
IMAGE_CRITEQUIPMENT = "equipment/Crit_word.png"
IMAGE_CURRENTEEQUIPMENT = "equipment/Equip_the_current_button.png"
IMAGE_LVEQUIPMENT = "equipment/LV22.png"
IMAGE_LOGOEQUIPMENT = "equipment/Magician_logo.png"
IMAGE_WORDEQUIPMENT = "equipment/Magician_word.png"
IMAGE_PURPLEEQUIPMENT = "equipment/Purple_box.png" --小紫
IMAGE_TEXTBOXEQUIPMENT = "equipment/Text_box.png"
IMAGE_POPUPEQUIPMENT = "equipment/Popup.png"
IMAGE_SKIRTEQUIPMENT = "equipment/skirt.png"
IMAGE_SWORDEQUIPMENT = "equipment/sword.png"
IMAGE_BARDEQUIPMENT = "equipment/bard.png"
IMAGE_BASEPLEQUIPMENT = "equipment/baseplate.png"
IMAGE_TITLEJINNIUEQUIPMENT = "equipment/Taurussuitword.png"
IMAGE_AA = "equipment/Blue_box.png" --大蓝
IMAGE_PURPLDDEEQUIPMENT = "equipment/Purple_box.png" --紫色
IMAGE_BB = "equipment/Purple_boxBIG.png" --大紫
IMAGE_BLUEEQUIPMENT = "equipment/smallblue.png"  --蓝色
IMAGE_CC = "equipment/Green_boxBIG.png" --大绿
IMAGE_GREENEQUIPMENT = "equipment/Green_box.png" --绿色
IMAGE_ROLEFRAME = "equipment/fazhen.png"
IMAGE_YIWEIYIFUFRAME = "equipment/Has_been_the_current.png"
IMAGE_FAGUANFUFRAME = "equipment/faguanganniu.png"
IMAGE_FAGUANDIDUFUFRAME = "equipment/faguandi.png"
IMAGE_SO = "equipment/smallorange.png" --小橙色
IMAGE_BO = "equipment/orange.png" --大橙色
IMAGE_FANYE = "equipment/arrow_shineright.png" 
IMAGE_SCANCEL = "equipment/Cancel_button_shine.png" 
IMAGE_NZHUANGBEI = "equipment/Equipthecurrentbutton.png" 
IMAGE_SZHUANGBEI = "equipment/anniu_shine.png" 
IMAGE_JINYONGEQUIP = "equipment/jinyongequip.png" 
IMAGE_CANEQUIP = "equipment/canequip.png" 
IMAGE_NOEQUIP = "equipment/noequip.png" 



--背包的资源
IMAGE_BIANBAG = "bag/_biankuang.png"
IMAGE_ANNIUBAG = "bag/anniu.png"
IMAGE_ANNNIUBAG = "bag/anniud.png"
IMAGE_BACKBAG = "bag/bag_back.png"
IMAGE_PURPLRBAG = "bag/purple.png"
IMAGE_SMALLBAG = "bag/purplesmall.png"
IMAGE_RIGHTBACKBAG = "bag/rightbigback.png"
IMAGE_SANNIUBAG = "bag/sanniu.png"
IMAGE_BAGANHEIBAG = "bag/bagan.png"
IMAGE_PAGEBAG = "bag/Page.png"


--一键熔炼
IMAGE_ANNIU = "yijianronglian/anniu.png"
IMAGE_BEIJINAN = "yijianronglian/beijingan.png"
IMAGE_TANKUAN = "yijianronglian/fff.png"
IMAGE_MIANBAN = "yijianronglian/mianban.png"
IMAGE_QUEDINGTEXT = "yijianronglian/quedingtext.png"
IMAGE_QUEDING = "yijianronglian/queidng.png"
IMAGE_QUXIAO = "yijianronglian/quxiao.png"
IMAGE_XUANPINZHI = "yijianronglian/textxuanzezhuangbeipingzhi.png"
IMAGE_XIAYIBU = "yijianronglian/xiayibu.png"
IMAGE_XUANZHUANGBEI = "yijianronglian/xuanzezhuangbeitwext.png"
IMAGE_BACK = "yijianronglian/buttonBack.png"
IMAGE_CHUSHIANNIU  = "yijianronglian/smallButton.png"
IMAGE_XUANZENNIU  = "yijianronglian/xuanzeanniu.png"

--MainScene
IMAGE_SHINK = "mainScenebg/guanqia_0002_zhankai.png"
IMAGE_DIFRAME = "mainScenebg/guanqia_0008_rightboard.png"


--game status
GS_INIT = 0
GS_MAIN = 1 
GS_FIGHT = 2
GS_CHANGESCENE = 3

--物品类型
kITEM_EQUIPMENT = 20
--kITEM_CONSUME = 2
--kITEM_PART = 3
kITEM_STRENGTHEN_STONE = 10
kITEM_GEM = 11
kITEM_GIFT_BAG = 12
kITEM_HERO = 13
kITEM_LAB = 14
kITEM_BOSS_TICKET = 15

STRENGTHEN_STONE_ITEM_ID = 1000001
KEY_ITEM_ID = 1400001
BATTERY_ITEM_ID = 1400002
FIGHT_BOSS_TICKET_ITEM_ID = 1500001

TOTAL_EQUIPMENT_POS = 8
TOTAL_QUALITY = 4
TOTAL_SUIT = 12 --套装数（武姬数)

MAX_GEM_LEVEL = 8

EQUIP_COLOR_TBL = {cc.c3b(0,175,64),cc.c3b(0,118,169),cc.c3b(134,51,154),cc.c3b(238,118,36),cc.c3b(0,0,0)}

MAX_FIGHT_TURN = 100--18 --start from 0

--等级解锁
if config.limit_open_system then
    UNLOCK_AUTO_FIGHT = 2 --自动战斗
    UNLOCK_DELAY_TASK = 4 --每日任务
    UNLOCK_INLAY = 12 --装备镶嵌
    UNLOCK_SUIT_ATTRIBUTE = 10 --装备共鸣（有用？）
    UNLOCK_ARENA = 5 --竞技场
    UNLOCK_ARENA_TEAM = 18 --团队战斗
    UNLOCK_RANK = 5 --排行榜
    UNLOCK_RANK_TEAM = 18 --排行榜团队挑战 --useless
    UNLOCK_LAB = 14 --家园系统
    UNLOCK_LAB_ROB = 14 --家园掠夺
    UNLOCK_LAB_HELP = 14 --家园互助
    UNLOCK_LAB_INSTRUMENT_2 = 19 --家园生产仪器2
    UNLOCK_LAB_INSTRUMENT_3 = 24 --家园生产仪器3
    UNLOCK_BAG = 1 --背包
    UNLOCK_QUICK_FIGHT = 7 --快速挂机
else
    UNLOCK_AUTO_FIGHT = 1 --自动战斗
    UNLOCK_DELAY_TASK = 1 --每日任务
    UNLOCK_INLAY = 1  --装备镶嵌
    UNLOCK_SUIT_ATTRIBUTE = 1  --装备共鸣（有用？）
    UNLOCK_ARENA = 1 --竞技场
    UNLOCK_ARENA_TEAM = 1  --团队战斗
    UNLOCK_RANK = 1 --排行榜
    UNLOCK_RANK_TEAM = 1  --排行榜团队挑战 --useless
    UNLOCK_LAB = 1  --家园系统
    UNLOCK_LAB_ROB = 1  --家园掠夺
    UNLOCK_LAB_HELP = 1  --家园互助
    UNLOCK_LAB_INSTRUMENT_2 = 1  --家园生产仪器2
    UNLOCK_LAB_INSTRUMENT_3 = 1  --家园生产仪器3
    UNLOCK_BAG = 1 --背包
    UNLOCK_QUICK_FIGHT = 1 --快速挂机
end



--任务部分
TASKTYPE_COMMON = 1
TASKTYPE_DAILY  = 2

--战斗逻辑部分
FIGHTTYPE_NORMAL = 1
FIGHTTYPE_ARENA1 = 2
FIGHTTYPE_ARENA3 = 3
FIGHTTYPE_LAB = 4

--不知如何投放的消耗或者获取
LAB_ROB_SEARCH_GOLD = 200 --搜索消耗金币
-- LAB_PRODUCE_TIME = {5, 10, 15}  --3种材料的生产时间
LAB_PRODUCE_TIME = {3600, 7200, 10800}  --3种材料的生产时间

--实验室一些参数
LAB_INSTRUMENT_STATUS_DONTHAVE = -1
LAB_INSTRUMENT_STATUS_EMPTY = 0
LAB_INSTRUMENT_STATUS_RUNNING = 1
LAB_INSTRUMENT_STATUS_FULL = 2


--玩家头像
-- PLAYER_HEAD_IMG = {"head_1","head_2","head_3","head_4"}
