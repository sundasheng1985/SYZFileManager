//
//  SYZFileManager.h
//  Pods-SYZFileManager_Example
//
//  Created by LeeRay on 2019/6/1.
//

#import <Foundation/Foundation.h>
#import <SYZUIBasekit/SYZUIBasekit.h>
#import <SYZFileModuleName.h>

/**
 * 负责沙盒文件管理
 */
@interface SYZFileManager : NSObject
SYZSingletonInterface();

/** Home */
@property (nonatomic, copy, readonly) NSString *homePath;
/** Document */
@property (nonatomic, copy, readonly) NSString *documentPath;
/** Library */
@property (nonatomic, copy, readonly) NSString *libraryPath;
/** Cache */
@property (nonatomic, copy, readonly) NSString *cachePath;

- (NSString *)directoryPath:(NSSearchPathDirectory)type;
- (NSArray<NSString *> *)directoryFiles:(NSSearchPathDirectory)type;

/**
 获取某个模块的路径
 
 @param module 模块名字
 @param create 如果不存在，是否创建
 @return 路径
 */
- (NSString *)pathForModule:(SYZFileModuleType)module create:(BOOL)create;

/** 根据模块名删除文件夹 */
- (void)deleteDirectory:(NSArray<SYZFileModuleType> *)modules;

/** 根据路径创建文件 */
- (NSString *)createDirectoryForPath:(NSString *)path;

/** 根据路径删除文件 */
- (BOOL)delteFilePath:(NSString *)path;

/** 拷贝文件到新地址 */
- (BOOL)copyItemAtPath:(NSString *)oldPath newPath:(NSString *)newPath error:(NSError *)error;

/** 文件夹是否存在 */
- (BOOL)fileExistsAtPath:(NSString *)path;

/** 文件是否存在 */
- (BOOL)fileExist:(NSString *)path;

/** 根据模块名，获取该模块下的所有文件名，或者文件夹名 */
- (NSArray<NSString *> *)directoryAllFileForModule:(SYZFileModuleType)module;

/** 根据路径，获取该文件夹下的所有资源名字 */
- (NSArray<NSString *> *)directoryAllFileForPath:(NSString *)path;

#pragma mark - Cache
/** block 回调 Text */
- (void)cacheSize:(SYZOneParamCallback)handle;
- (void)cleanCache:(SYZVoidCallback)handle;

@end
