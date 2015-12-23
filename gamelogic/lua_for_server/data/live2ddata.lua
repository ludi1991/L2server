-- data for live2d Equipment

Live2dData = {}


-- id  =  "部位live2d骨骼的名字
Live2dData.partTable = {
    [1] = "PARTS_01_WEAPON_001_A"  ,         --主武器
 	[2] = "PARTS_01_JEWELRY_001_B" ,         --颈部装饰
    [3] = "PARTS_01_CLOTHES_001_A" ,        --上衣
    [4] = "PARTS_01_CLOTHES_001_B" ,  --下装
    [5] = "PARTS_01_JEWELRY_001_A" ,  --帽子
    [6] = "PARTS_01_JEWELRY_001_D" ,  --手套
    [7] = "PARTS_01_JEWELRY_001_C" ,   --腰带
    [8] = "PARTS_01_SHOES_001"  ,          --鞋子（改过了）   
    [9] = "PARTS_01_CLOTHES_002_A",      --上衣2
    [10] = "PARTS_01_CLOTHES_002_B",     --下装2
    [11] = "PARTS_01_JEWELRY_002_D" ,  --手套2
    [12] = "PARTS_01_JEWELRY_002_C" ,   --腰带2
    [13] = "PARTS_01_SHOES_002"  ,          --鞋子2
    [14] = "PARTS_01_SOCKS_001"  ,       --袜子
    [15] = "PARTS_01_WEAPON_001_B"  ,    --真正的副武器
    [16] = "PARTS_01_HAIR_FRONT_001",    --头发1前发
    [17] = "PARTS_01_HAIR_SIDE_001",    --头发1侧发
    [18] = "PARTS_01_HAIR_BACK_001",    --头发1后发
    [19] = "PARTS_01_HAIR_FRONT_002",    --头发2前发
    [20] = "PARTS_01_HAIR_SIDE_002",    --头发2侧发
    [21] = "PARTS_01_HAIR_BACK_002",    --头发2后发     
}



Live2dData.otherHideTable = {
	[1] = "PARTS_01_EYE_002",
	[2] = "PARTS_01_EYE_BALL_002",
	[3] = "PARTS_01_EYE_003",
	[4] = "PARTS_01_EYE_BALL_003",
}


-- id = {"纹理的位置",纹理的索引(统一地方的纹理索引是固定的)}
Live2dData.textureTable = {
	[1] = {"Lead_1_1024/texture_00.png" ,0},   --这个图片是眼睛和头部
 	[2] = {"Lead_1_1024/texture_01.png" ,1},   --身体和内衣
	[3] = {"Lead_1_1024/texture_02.png",2} ,   --手臂
	[4] = {"Lead_1_1024/texture_03.png",3} ,   --腿部
	[5] = {"Lead_1_1024/texture_04.png",4} ,   --脸部阴影和其他眼睛
	[6] = {"Lead_1_1024/texture_05.png",5} ,   --头发
	[7] = {"Lead_1_1024/texture_06.png",6} ,   --头发辫子部分
	[8] = {"Lead_1_1024/texture_07.png",7} ,   --上衣，枪炮
	[9] = {"Lead_1_1024/texture_08.png",8} ,   --下装，枪炮
	[10] ={ "Lead_1_1024/texture_09.png",9} ,  --武器，枪炮
	[11] ={ "Lead_1_1024/texture_10.png",10} ,    --项链，枪炮
	[12] ={ "Lead_1_1024/texture_11.png",11} ,    --腰带，枪炮
	[13] ={ "Lead_1_1024/texture_12.png",12} ,    --鞋子，枪炮
	[14] ={ "Lead_1_1024/texture_13.png",13} ,    --帽子1
	[15] ={ "Lead_1_1024/texture_14.png",14} ,    --手套，枪炮
	[17] ={ "Lead_1_1024/texture_06c.png",6} ,    --第一个头发的辫子部分，此图已不存在
	[18] ={ "Lead_1_1024/texture_07c.png",7} ,    --上衣，枪炮，第二阶
	[19] ={ "Lead_1_1024/texture_08c.png",8} ,    --下装，枪炮，第二阶
	[20] ={ "Lead_1_1024/texture_09c.png",9} ,    --武器，枪炮变色
	[21] ={ "Lead_1_1024/texture_10c.png",10} ,    --枪炮项链变色，此图已不存在
	[22] ={ "Lead_1_1024/texture_11c.png",11} ,    --腰带，枪炮，第二阶
	[23] ={ "Lead_1_1024/texture_12c.png",12} ,    --鞋子，枪炮，第二阶
	[24] ={ "Lead_1_1024/texture_13c.png",13} ,    --帽子1变色
	[25] ={ "Lead_1_1024/texture_14c.png",14} ,    --手套，枪炮，第二阶
	[26] ={ "Lead_1_1024/texture_15.png",15},    --袜子，枪炮
	[27] ={ "Lead_1_1024/texture_16.png",16},    --下装2
	[28] ={ "Lead_1_1024/texture_17.png",17},    --腰带2
	[29] ={ "Lead_1_1024/texture_18.png",18},    --手套2
	[30] ={ "Lead_1_1024/texture_19.png",19},    --上衣2
	[31] ={ "Lead_1_1024/texture_20.png",20},    --鞋子2
	[32] ={ "Lead_1_1024/texture_07d.png",7} ,    --上衣1变色，黄
	[33] ={ "Lead_1_1024/texture_08d.png",8} ,    --下装1变色，黄
	[34] ={ "Lead_1_1024/texture_09d.png",9} ,    --武器1变色2
	[35] ={ "Lead_1_1024/texture_10d.png",10} ,    --枪炮项链变色，此图已不存在
	[36] ={ "Lead_1_1024/texture_11d.png",11} ,    --腰带1变色，黄
	[37] ={ "Lead_1_1024/texture_12d.png",12} ,    --鞋子1变色，黄
	[38] ={ "Lead_1_1024/texture_13d.png",13} ,    --帽子1变色，黄
	[39] ={ "Lead_1_1024/texture_14d.png",14} ,    --手套1变色，黄
    [40] ={ "Lead_1_1024/texture_07e.png",7} ,    --上衣1变色，红
	[41] ={ "Lead_1_1024/texture_08e.png",8} ,    --下装1变色，红
	[42] ={ "Lead_1_1024/texture_09e.png",9} ,    --武器1变色3
	[43] ={ "Lead_1_1024/texture_10e.png",10} ,    --枪炮项链变色，此图已不存在
	[44] ={ "Lead_1_1024/texture_11e.png",11} ,    --腰带1变色，红
	[45] ={ "Lead_1_1024/texture_12e.png",12} ,    --鞋子1变色，红
	[46] ={ "Lead_1_1024/texture_13e.png",13} ,    --帽子1变色，红
	[47] ={ "Lead_1_1024/texture_14e.png",14} ,    --手套1变色，红
	[48] ={ "Lead_1_1024/texture_21.png",21} ,     --真正的副武器腿部
	[49] ={ "Lead_1_1024/texture_21c.png",21} ,     --枪炮，真正的副武器变色1腿部，此图已不存在
	[50] ={ "Lead_1_1024/texture_21d.png",21} ,     --枪炮，真正的副武器变色2腿部，此图已不存在
	[51] ={ "Lead_1_1024/texture_21e.png",21} ,     --枪炮，真正的副武器变色3腿部，此图已不存在
	[52] ={ "Lead_1_1024/texture_22.png",22} ,     --枪炮，真正的副武器背部，全部
	[53] ={ "Lead_1_1024/texture_22c.png",22} ,     --枪炮，真正的副武器，背部第二阶
	[54] ={ "Lead_1_1024/texture_22d.png",22} ,     --枪炮，真正的副武器，背部第三阶
	[55] ={ "Lead_1_1024/texture_22e.png",22} ,     --枪炮，真正的副武器变色3背部
	[56] ={ "Lead_1_1024/texture_23.png",23},      --金色披散卷发
	[57] ={ "Lead_1_1024/texture_07a.png",7},      --白色初始装上衣
	[58] ={ "Lead_1_1024/texture_08a.png",8},      --白色初始装下装
	[59] ={ "Lead_1_1024/texture_09a.png",9},      --和小怪一样的紫色变色枪
	[60] ={ "Lead_1_1024/texture_12a.png",12},    --白色初始鞋子
	[61] ={ "Lead_1_1024/texture_14a.png",14},    --白色初始手套
	[62] ={ "Lead_1_1024/texture_0_512.png",22},    --边长512的空白通用图片
	[63] ={ "Lead_1_1024/texture_22b.png",22},    --枪炮，副武器背部，第一阶

}

-- 人物基本会用到的纹理id
Live2dData.baseTextureTable = {
	1,2,3,4,5,6,7,56
}



-- id 对应某件装备 骨骼 + 资源 的名字
Live2dData.equipTable = {

	[17] = { 9, 30 },  --上衣2
	[18] = { 10, 27 },  --下装2
	[19] = { 11, 29 },  --手镯
	[20] = { 12, 28 },  --金属腰带
	[21] = { 13, 31 },  --鞋子2
	[22] = { 14, 26 },  --袜子
	[23] = { 16, 6 },  --褐色头发前发
	[24] = { 17, 6 },  --褐色头发侧发
	[25] = { 18, 7 },  --褐色头发马尾
	[26] = { 19, 56 },  --金色卷发前发
	[27] = { 20, 56 },  --金色卷发侧发
	[28] = { 21, 56 },  --金色卷发后发
	[29] = { 2, 11 }, -- 枪炮项链
	[30] = { 3, 57 },  --白色初始上衣
	[31] = { 4, 58 },  --白色初始下装
	[32] = { 6, 61 },  --白色初始手套
	[33] = { 8, 60 },  --白色初始鞋子
	[34] = { 1, 59 },  --和小怪一样的紫色变色枪


	[2010101] = { 1, 42 },   -- 蓝光大枪--绿色
	[2010201] = { 15, 48, 62 },   --副武器，仅有腿部
	[2010303] = { 3, 8 },    --枪炮，上衣
	[2010403] = { 4, 9 } ,    --枪炮，下装
	[2010503] = { 5, 14 },   --头部装饰
	[2010603] = { 6, 15 },   --护腕
	[2010703] = { 7, 12 },   --腰带
	[2010803] = { 8, 13 },    --鞋子

    [2010102] = { 1, 20 },   --蓝光大枪的变色--红色
	[2010202] = { 15, 48, 63 },   --副武器，有背部
	[2010302] = { 3, 18 },  --枪炮，上衣，第二阶
	[2010402] = { 4, 19 },  --枪炮，下装，第二阶
	[2010502] = { 5, 24 },  --头部装饰变色1
	[2010602] = { 6, 25 },  --手套，第二阶
	[2010702] = { 7, 22 },  --腰带，第二阶
	[2010802] = { 8, 23 },  --鞋子，第二阶

	[2010103] = { 1, 10 },   --蓝光大枪
	[2010203] = { 15, 48, 53},   --副武器，进阶
	[2010304] = { 3, 32 },  --枪炮，上衣，黄色
	[2010404] = { 4, 33 },  --枪炮，下装，黄色
	[2010504] = { 5, 38 },  --头部装饰变色2
	[2010604] = { 6, 39 },  --手套变色，黄
	[2010704] = { 7, 36 },  --腰带变色，黄
	[2010804] = { 8, 37 },  --鞋子变色，黄

	[2010104] = { 1, 34 },   --蓝光大枪变色--黄色
	[2010204] = { 15, 48, 54 },   --副武器，进阶
	[2010301] = { 3, 40 },  --枪炮，上衣，红色
	[2010401] = { 4, 41 },  --枪炮，下装，红色
	[2010501] = { 5, 46 },  --头部装饰变色3
	[2010601] = { 6, 47 },  --手套变色，红
	[2010701] = { 7, 44 },  --腰带变色，红
	[2010801] = { 8, 45 },  --鞋子变色，红

}