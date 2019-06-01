//
//  SYZFileManager.m
//  Pods-SYZFileManager_Example
//
//  Created by LeeRay on 2019/6/1.
//

#import "SYZFileManager.h"

@interface SYZFileManager ()
@property (nonatomic, copy, readwrite) NSString *homePath;
@property (nonatomic, copy, readwrite) NSString *documentPath;
@property (nonatomic, copy, readwrite) NSString *libraryPath;
@property (nonatomic, copy, readwrite) NSString *cachePath;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSMutableDictionary *fileCache;
@end

@implementation SYZFileManager

SYZSingletonImplementation(SYZFileManager)

- (instancetype)init {
    if (self = [super init]) {
        _homePath = NSHomeDirectory();
        _documentPath = [self directoryPath:NSDocumentDirectory];
        _libraryPath = [self directoryPath:NSLibraryDirectory];
        _cachePath = [self directoryPath:NSCachesDirectory];
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}

- (NSString *)directoryPath:(NSSearchPathDirectory)type {
    NSArray *files = [self directoryFiles:type];
    if (SYZIsEmptyArray(files)) return @"";
    return files.firstObject;
}

- (NSArray<NSString *> *)directoryFiles:(NSSearchPathDirectory)type {
    return NSSearchPathForDirectoriesInDomains(type, NSUserDomainMask, YES);
}

- (NSString *)pathForModule:(SYZFileModuleType)module create:(BOOL)create {
    return [self _createDirectory:module create:create];
}

- (void)deleteDirectory:(NSArray<SYZFileModuleType> *)modules {
    for (NSString *module in modules) {
        NSString *path = [self _pathForModule:module];
        BOOL next = [self _deletePath:path];
        if (!next) {
            NSLog(@"删除 %@ 模块文件夹失败", module);
        }
    }
}

- (NSString *)createDirectoryForPath:(NSString *)path {
    if (![self fileExistsAtPath:path]) {
        NSError *error = [self _createPath:path];
        if (error) {
            NSLog(@"创建文件夹失败");
            return @"";
        }
    }
    return path;
}

- (BOOL)copyItemAtPath:(NSString *)oldPath newPath:(NSString *)newPath error:(NSError *)error {
    if (SYZIsEmptyString(oldPath) || SYZIsEmptyString(newPath)) return NO;
    return [self.fileManager copyItemAtPath:oldPath toPath:newPath error:&error];
}

- (BOOL)delteFilePath:(NSString *)path {
    if (SYZIsEmptyString(path)) return NO;
    return [self _deletePath:path];
}

- (BOOL)fileExistsAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    return ([self.fileManager fileExistsAtPath:path isDirectory:&isDirectory]);
}

- (BOOL)fileExist:(NSString *)path {
    return [self.fileManager fileExistsAtPath:path];
}

- (NSArray<NSString *> *)directoryAllFileForModule:(SYZFileModuleType)module {
    NSString *path = [self _pathForModule:module];
    if (![self fileExistsAtPath:path]) {
        return @[];
    }
    NSError *error;
    NSArray *array = [self.fileManager contentsOfDirectoryAtPath:path error:&error];
    
    NSMutableArray *names = [NSMutableArray array];
    for (NSString *name in array) {
        if ([name containsString:@"."] || [name containsString:@"/"]) {
            continue;
        }
        [names addObject:name];
    }
    
    if (SYZIsNotEmpty(error)) {
        NSLog(@"获取某文件下的资源列表 error : %@", error.localizedDescription);
        return @[];
    }
    return names;
}

- (NSArray<NSString *> *)directoryAllFileForPath:(NSString *)path {
    if (![self fileExistsAtPath:path]) {
        return @[];
    }
    NSError *error;
    NSArray *array = [self.fileManager contentsOfDirectoryAtPath:path error:&error];
    
    if (SYZIsNotEmpty(error)) {
        NSLog(@"获取某文件下的资源列表 error : %@", error.localizedDescription);
        return @[];
    }
    return array;
}

- (void)cacheSize:(SYZOneParamCallback)handle {
    NSEnumerator *enumerator = [[self.fileManager subpathsAtPath:self.cachePath] objectEnumerator];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        long long floderSize = 0;
        NSString *fileName;
        while ((fileName = [enumerator nextObject]) != nil) {
            NSString *absolutePath = [self.cachePath stringByAppendingPathComponent:fileName];
            //如果包含了系统文件，直接忽略此次操作
            if ([absolutePath containsString:@".DS"]) continue;
            floderSize += [self _fileSizePath:absolutePath];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (handle) {
                handle([NSString syz_stringWithFileSize:floderSize]);
            }
        });
    });
}

- (void)cleanCache:(SYZVoidCallback)handle {
    NSArray *files = [self.fileManager subpathsAtPath:self.cachePath];
    for (NSString *obj in files) {
        NSString *absolutePath = [self.cachePath stringByAppendingPathComponent:obj];
        [self delteFilePath:absolutePath];
    }
    
    if (handle) {
        handle();
    }
}

#pragma mark - Private
- (NSString *)_createDirectory:(NSString *)module create:(BOOL)create {
    NSString *path = [self _pathForModule:module];
    if (![self fileExistsAtPath:path]) {
        if (create) {
            NSError *error = [self _createPath:path];
            if (SYZIsNotEmpty(error)) {
                NSLog(@"创建模块 %@ 文件失败 error : %@", module, error.localizedDescription);
            }
        } else {
            return @"";
        }
    }
    return path;
}

- (NSError *)_createPath:(NSString *)path {
    NSError *error;
    [self.fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    return error;
}

- (BOOL)_deletePath:(NSString *)path {
    if (![self fileExistsAtPath:path]) return NO;
    NSError *error;
    BOOL next = [self.fileManager removeItemAtPath:path error:&error];
    if (SYZIsEmpty(error) && next) {
        return YES;
    }
    return NO;
}

- (BOOL)_createFilePath:(NSString *)path reset:(BOOL)reset {
    if ([self fileExistsAtPath:path]) {
        if (!reset) return YES;
        [self _deletePath:path];
    }
    
    BOOL success = [self.fileManager createFileAtPath:path contents:nil attributes:nil];
    if (!success) {
        NSLog(@"创建 %@ 文件失败", path);
        return NO;
    }
    return YES;
}

- (NSString *)_pathForModule:(SYZFileModuleType)module {
    return [self.documentPath stringByAppendingPathComponent:module];
}

- (long long)_fileSizePath:(NSString *)filePath {
    if ([self fileExistsAtPath:filePath]) {
        return [self.fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    return 0;
}

SYZLazyCreateMutableDictionary(fileCache);

@end
