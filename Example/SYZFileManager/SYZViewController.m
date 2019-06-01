//
//  SYZViewController.m
//  SYZFileManager
//
//  Created by sundasheng1985 on 06/01/2019.
//  Copyright (c) 2019 sundasheng1985. All rights reserved.
//

#import "SYZViewController.h"
#import <SYZFileManager/SYZFileManager.h>
#import <SYZFileManager/SYZZipManager.h>

@interface SYZViewController ()

@end

@implementation SYZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *arrays = @[@"5ae2a0020cf2a9e8ef8a3735.zip",
                        @"5ae29e1c0cf2a9e8ef8a372f.zip",
                        @"5ae29e840cf2a9e8ef8a3730.zip",
                        @"5ae29ed10cf2a9e8ef8a3731.zip"];
    for (NSString *zip in arrays) {
        [[SYZZipManager sharedInstance] unZip:zip module:SYZFileModuleTypeSessionBubble];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
