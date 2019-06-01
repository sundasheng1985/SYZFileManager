//
//  SYZZipManager.m
//  Pods-SYZFileManager_Example
//
//  Created by LeeRay on 2019/6/1.
//

#import "SYZZipManager.h"
#import <SYZFileManager.h>
#import <pthread.h>
#import <SSZipArchive/SSZipArchive.h>

@interface SYZZipManager ()
@property (nonatomic, copy) NSString *baseBundlePath;
@end

@implementation SYZZipManager{
    pthread_mutex_t mutex;
}

SYZSingletonImplementation(SYZZipManager)

- (instancetype)init {
    if (self = [super init]) {
        self.baseBundlePath = [[NSBundle mainBundle] bundlePath];
        pthread_mutex_init(&mutex, NULL);
    }
    return self;
}

- (void)unZip:(NSString *)name module:(SYZFileModuleType)module {
    if (SYZIsEmptyString(name)) return;
    NSArray *files = [name componentsSeparatedByString:@"."];
    if (SYZIsEmptyArray(files)) return;
    NSString *directoryName = files.firstObject;
    NSString *basePath = [[SYZFileManager sharedInstance] pathForModule:module create:YES];
    if (SYZIsEmptyString(basePath)) return;
    NSString *saveDirectoryPath = [basePath stringByAppendingPathComponent:directoryName];
    if ([[SYZFileManager sharedInstance] fileExistsAtPath:saveDirectoryPath])  return;
    saveDirectoryPath = [[SYZFileManager sharedInstance] createDirectoryForPath:saveDirectoryPath];
    if (SYZIsEmptyString(saveDirectoryPath)) return;
    NSString *newPath = [basePath stringByAppendingPathComponent:name];
    NSString *oldPath = [self.baseBundlePath stringByAppendingPathComponent:name];
    NSError *error;
    BOOL next = [[SYZFileManager sharedInstance] copyItemAtPath:oldPath newPath:newPath error:error];
    if (next && SYZIsEmpty(error)) {
        [self _unZip:newPath name:directoryName writePath:saveDirectoryPath];
    } else {
        NSLog(@"解压zip error : %@", error.localizedDescription);
        [[SYZFileManager sharedInstance] delteFilePath:newPath];
    }
}

- (void)unDownloadZip:(NSString *)path module:(SYZFileModuleType)module {
    if (SYZIsEmptyString(path) || SYZIsEmptyString(module)) return;
    NSString *name = path.lastPathComponent;
    NSArray *files = [name componentsSeparatedByString:@"."];
    if (SYZIsEmptyArray(files)) return;
    NSString *directoryName = files.firstObject;
    NSString *basePath = [[SYZFileManager sharedInstance] pathForModule:module create:YES];
    if (SYZIsEmptyString(basePath)) return;
    NSString *saveDirectoryPath = [basePath stringByAppendingPathComponent:directoryName];
    if ([[SYZFileManager sharedInstance] fileExistsAtPath:saveDirectoryPath]) return;
    saveDirectoryPath = [[SYZFileManager sharedInstance] createDirectoryForPath:saveDirectoryPath];
    if (SYZIsEmptyString(saveDirectoryPath)) return;
    [self _unZip:path name:directoryName writePath:saveDirectoryPath];
}

- (void)zip:(NSString *)path cover:(BOOL)cover {
    if (SYZIsEmptyString(path)) return;
    if ([[SYZFileManager sharedInstance] fileExistsAtPath:path]) {
        if (!cover) return;
        [[SYZFileManager sharedInstance] delteFilePath:path];
    }
}

#pragma mark - private
- (void)_unZip:(NSString *)path name:(NSString *)name writePath:(NSString *)writePath {
    if (SYZIsEmptyString(path) || SYZIsEmptyString(writePath)) return;
    pthread_mutex_lock(&mutex);
    NSError *error;
    BOOL next = [SSZipArchive unzipFileAtPath:path toDestination:writePath overwrite:YES password:nil error:&error];
    if (next && SYZIsEmpty(error)) {
        NSLog(@"unZip success path -- %@", writePath);
        [[SYZFileManager sharedInstance] delteFilePath:path];
    } else {
        NSLog(@"unZip error");
        [[SYZFileManager sharedInstance] delteFilePath:path];
        [[SYZFileManager sharedInstance] delteFilePath:writePath];
    }
    pthread_mutex_unlock(&mutex);
}


@end
