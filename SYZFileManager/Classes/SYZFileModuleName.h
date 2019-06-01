//
//  SYZFileModuleName.h
//  Pods-SYZFileManager_Example
//
//  Created by LeeRay on 2019/6/1.
//

#import <Foundation/Foundation.h>

typedef NSString * SYZFileModuleType NS_EXTENSIBLE_STRING_ENUM;
/** 短视频 */
FOUNDATION_EXTERN SYZFileModuleType const SYZFileModuleTypeShortVideo;
/** 礼物Zip */
FOUNDATION_EXTERN SYZFileModuleType const SYZFileModuleTypePresentZip;
/** 聚聚气泡 */
FOUNDATION_EXTERN SYZFileModuleType const SYZFileModuleTypeSessionBubble;
/** 开机广告 */
FOUNDATION_EXTERN SYZFileModuleType const SYZFileModuleTypeOpenAd;
/** 直播会看消息txt */
FOUNDATION_EXTERN SYZFileModuleType const SYZFileModuleTypeLiveHistoryTxt;
/** 表情 */
FOUNDATION_EXTERN SYZFileModuleType const SYZFileModuleTypeEmotion;
/** 数据库 */
FOUNDATION_EXTERN SYZFileModuleType const SYZFileModuleTypeSYZDB;
/** BGM音乐 */
FOUNDATION_EXTERN SYZFileModuleType const SYZFileModuleTypeSYZBGM;
/** 敏感词 */
FOUNDATION_EXTERN SYZFileModuleType const SYZFileModuleTypeIllegalWords;

/** 敏感词文件名字 */
extern NSString * const SYZIllegalName;

@interface SYZFileModuleName : NSObject

@end
