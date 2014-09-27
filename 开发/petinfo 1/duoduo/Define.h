//
//  Define.h
//  duoduo
//
//  Created by tenyea on 14-3-25.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#ifndef duoduo_Define_h
#define duoduo_Define_h
#define itunesappid 919808699
#define shareSdkAppID @"2db22b1a5954"
#pragma mark -
#pragma mark URL
#define Host @"www.baidu.com"
//#define BASE_URL @"http://192.168.1.145:8090/petInfo/"
#define BASE_URL @"http://www.tysoft.cn:8099/"

//#define BASE_URL @"http://app.nen.com.cn/"
#define URL_Post_uploadPetImage @""
// 注册
#define URL_RegisterServlet @"AppRegister"
// 登录
#define URL_Login @"AppLogin"
//修改密码
#define URL_UpdatePassword @"AppUpdatePassword"
//获取医院列表
#define URL_getHospitalList @"AppHosList"
//获取医生列表
#define URL_getDoctorList @"AppDocList"
//获取医生详情
#define URL_getDoctorInfo @"AppDocInfo"
//医院信息列表接口
#define URL_getHosInfoList @"AppHosInfoList"
//医院信息图文内容
#define URL_getHosInfo @"AppHosInfo"
//医院简介
#define URL_getHosDes @"AppHosDes"
//用户医院评论
#define URL_UserToHosDis @"AppUserToHosDis"
//医院评论列表
#define URL_getHosDisList @"AppHosDis"
//帖子回复详情接口
#define URL_getDisList @"AppPetPhotoDis"
//回帖
#define URL_AddDis @"AppAddDis"
//回复我的和我的回复
#define URL_Reply @"AppHuiFuWoDe"
//显示用户问诊列表
#define URL_getInquiryList @"AppInquiryList"
//问诊详细内容
#define URL_getInquiryContent @"AppInquiryReply"
//我的帖子
#define URL_getPostList @"AppPetPhotoPostList"
//帖子详情
#define URL_getPostContent @"AppPetPhotoDisList"
//添加宠物
#define URL_addPetInfo_Post @"AppAddPet"
//删除宠物
#define URL_deletePet @"AppDelPet"
//修改用户信息
#define URL_updateUserInfo_Post @"AppUpdateUser"
//获取验证码
#define URL_getSecurity @"AppSendCode"
//修改密码
#define URL_updatePassWoreBySecurity @"AppFindPassword"
//上传用户头像
#define URL_uploadUserImage_Post @"AppUpdateHead"
//在线问诊
#define URL_AskOnline_Post @"AppAddInquiry"

//获取宠物种类
#define URL_getPetKind @"AppPetList"
//日常知识列表接口
#define URL_getKnowledgeList @"AppKnowledgeList"
//日常饲养详情
#define URL_getFeed @"AppFeed"

//查看其他用户信息
#define URL_getUserInfo @"AppUserInfo"
#pragma mark -
#pragma mark 百度
//百度统计信息
#define BaiduMobStat_APPID @"3aec05f5e8"
//百度推送信息
#define BPushchannelid @"BPushchannelid"
#define BPushappid @"BPushappid"
#define BPushuserid @"BPushuserid"

#pragma mark -
#pragma mark 通知
#pragma mark NSNotificationCenter


#pragma mark - 
#pragma mark userdefault
#define UD_userID_Str @"UD_userID"
#define UD_userName_Str @"UD_userName" //用户名
#define UD_userInfo_DIC @"UD_userInfo"//用户信息
#define UD_userInfo_temp_DIC @"UD_userInfo_temp"//用户信息
#define UD_pet_Array @"UD_pet"//所有的宠物信息
#define UD_petInfo_temp_PetModel @"UD_petInfo_temp"//临时宠物信息。用于新增宠物的
#define UD_Locationnow_DIC @"UD_Locationnow"//本次登陆的位置
#define UD_nowPosition_Str @"UD_nowPosition"//当前位置
#define UD_pageVersion @"pageVersion"//用于显示引导图
#endif




#pragma mark Servlet
// 注册
#define URL_RegisterServlet @"AppRegister"
// 登录
#define URL_Login @"AppLogin"
// 首页
#define URL_Ao @"AppAo"
// 故事页
#define URL_Story @"AppStory"
//附近宠物
#define URL_getNearPet @"AppNearPet"
// 故事页 4合1
#define URL_Story_Four_To_One @"AppPetPhotoList"
// 宠物萌照详细
#define URL_Pet_Photo @"AppKnowledge"
// 发宠物萌照
#define URL_Add_Pet_Photo @"AppAddPetPhoto"
// 赞
#define URL_Like @"AppLike"

#pragma mark color
#define TextColor COLOR(247, 247, 247)

#pragma mark String

#define Tenyea_str_button_loading @"正在加载"
#define Tenyea_str_load_error @"出错了..请稍后再试."
#define Tenyea_str_userNameIsNo @"用户名不存在,请重新输入"
