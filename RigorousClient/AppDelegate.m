//
//  AppDelegate.m
//  RigorousClient
//
//  Created by Phil Plückthun on 15.12.12.
//  Copyright (c) 2012 Phil Plückthun. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NUIAppearance init];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    StartViewController *temp = (StartViewController*) self.window.rootViewController;
    [temp willTerminate];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    StartViewController *temp = (StartViewController*) self.window.rootViewController;
    [temp willResignActive];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    StartViewController *temp = (StartViewController*) self.window.rootViewController;
    [temp willEnterForeground];
}

@end
