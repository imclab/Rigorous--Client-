//
//  StartViewController.h
//  RigorousClient
//
//  Created by Phil Plückthun on 23.12.12.
//  Copyright (c) 2012 Phil Plückthun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AESCrypt.h"
#import "GCDAsyncSocket.h"
#import "DeviceCell.h"
#import "PaperFoldView.h"
#import "WBNoticeView.h"
#import "WBErrorNoticeView.h"
#import "WBSuccessNoticeView.h"
#import "MBProgressHUD.h"
#import "KGModal.h"
#import "MenuTable.h"

@interface StartViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSNetServiceBrowserDelegate, NSNetServiceDelegate, PaperFoldViewDelegate, MBProgressHUDDelegate>
{
    NSNetServiceBrowser *netServiceBrowser;
    NSNetService *serverService;
	NSMutableArray *serverAddresses;
	GCDAsyncSocket *asyncSocket;
    MBProgressHUD *HUD;
    ShadowView *centerShadowView;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) IBOutlet PaperFoldView *mainview;
@property (nonatomic, strong) IBOutlet UIView *center_view;
@property (nonatomic, strong) IBOutlet UIView *right_view;
@property (nonatomic, strong) IBOutlet MenuTable *right_menu_view;

- (void)setContentView:(NSString*)viewname;
- (void)showErrorNotice:(NSString*)text;
- (void)showSuccessNotice:(NSString*)text;
- (void)sendMessage:(NSString *)msg;
- (void)connectToNextAddress;
- (void)willTerminate;
- (void)willResignActive;
- (void)willEnterForeground;
- (void)showIntro;

@end
