//
//  main.m
//  RigorousClient
//
//  Created by Phil Plückthun on 15.12.12.
//  Copyright (c) 2012 Phil Plückthun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [NUISettings init];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
