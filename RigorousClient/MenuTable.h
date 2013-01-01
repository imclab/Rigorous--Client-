//
//  MenuTable.h
//  RigorousClient
//
//  Created by Phil Plückthun on 25.12.12.
//  Copyright (c) 2012 Phil Plückthun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NUIRenderer.h"

@class StartViewController;

@interface MenuTable : UITableView<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *cells;
}

@property(nonatomic,assign) StartViewController *father;

- (void)addMenupoint:(NSString*)desc key:(NSString*)key;
- (void)setFather:(StartViewController*)father;

@end
