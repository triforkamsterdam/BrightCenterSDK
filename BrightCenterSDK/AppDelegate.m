//
//  AppDelegate.m
//  BrightCenterSDK
//
//  Created by Tom van Zummeren on 8/28/13.
//  Copyright (c) 2013 Tom van Zummeren. All rights reserved.
//

#import "AppDelegate.h"
#import "MyCoolEduAppController.h"
#import "BCStudentPickerController.h"

@implementation AppDelegate

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
    // In iOS7 this doesn't work. Instead each controller decides whether to hide the status bar
    application.statusBarHidden = YES;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    MyCoolEduAppController *controller = [MyCoolEduAppController new];
    self.window.rootViewController = controller;
//    self.window.rootViewController = [BCStudentPickerNavigationController new];

    return YES;
}

@end