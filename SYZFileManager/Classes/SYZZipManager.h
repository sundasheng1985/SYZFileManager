//
//  SYZZipManager.h
//  Pods-SYZFileManager_Example
//
//  Created by LeeRay on 2019/6/1.
//

#import <Foundation/Foundation.h>
#import <SYZUIBasekit/SYZUIBasekit.h>
#import <SYZFileModuleName.h>

/**
 * 负责Zip解压，打包
 */
@interface SYZZipManager : NSObject

SYZSingletonInterface();

#pragma mark - UnZip
/** 解压本地zip */
- (void)unZip:(NSString *)name module:(SYZFileModuleType)module;

/** 解压网络下载的zip */
- (void)unDownloadZip:(NSString *)path module:(SYZFileModuleType)module;

#pragma mark - Zip
/** 打包zip */
- (void)zip:(NSString *)path cover:(BOOL)cover;
@end
