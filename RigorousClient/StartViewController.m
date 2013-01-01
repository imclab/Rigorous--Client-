//
//  StartViewController.m
//  RigorousClient
//
//  Created by Phil Plückthun on 23.12.12.
//  Copyright (c) 2012 Phil Plückthun. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()
- (void)setupClient;
@end

@implementation StartViewController

@synthesize tableView = _tableView;
@synthesize tableData = _tableData;

- (void)setContentView:(NSString*)viewname
{
    NSArray *tempLoad = [[NSBundle mainBundle] loadNibNamed:viewname owner:self options:nil];
    if ([tempLoad count] > 0){
        UIView *newView = [tempLoad objectAtIndex:0];
        [newView setFrame:_center_view.frame];
        [_center_view removeFromSuperview];
        _center_view = newView;
        [_mainview addSubview:_center_view];
        [_center_view addSubview:centerShadowView];
        [_mainview setCenterContentView:_center_view];
    }
    if (_mainview.state == PaperFoldStateRightUnfolded) {
        [_mainview setPaperFoldState:PaperFoldStateDefault animated:true];
    }
}

- (void)viewDidLoad
{
    [self setContentView:@"iTunes"];
    
    [_right_view setBackgroundColor:UIColorFromRGB(0x555555)];
    [_right_menu_view setBackgroundColor:UIColorFromRGB(0x555555)];
    [_right_menu_view setSeparatorColor:UIColorFromRGB(0x666666)];
    [_right_menu_view setScrollEnabled:false];
    [_right_menu_view setFather:self];
    
    [_right_menu_view addMenupoint:@"iTunes" key:@"iTunes"];
    [_right_menu_view addMenupoint:@"Keynote" key:@"Keynote"];
    [_right_menu_view addMenupoint:@"PowerPoint" key:@"PowerPoint"];
    [_right_menu_view addMenupoint:@"VLC Player" key:@"VLC"];
    
    [_mainview setCenterContentView:_center_view];
    [_mainview setLeftFoldContentView:_tableView foldCount:3 pullFactor:0.9];
    [_mainview setRightFoldContentView:_right_view width:150.0 foldCount:2 pullFactor:0.9];
    [_mainview setDelegate:self];
    [_mainview setPaperFoldState:PaperFoldStateLeftUnfolded animated:false];
    
    centerShadowView = [[ShadowView alloc] initWithFrame:CGRectMake(0,0,5,_center_view.frame.size.height) foldDirection:FoldDirectionHorizontalRightToLeft];
    [centerShadowView setColorArrays:@[[UIColor clearColor],[UIColor colorWithWhite:0 alpha:0.3]]];
    [_center_view addSubview:centerShadowView];
    
    ShadowView *rightShadowView = [[ShadowView alloc] initWithFrame:CGRectMake(0,0,5,_center_view.frame.size.height) foldDirection:FoldDirectionHorizontalRightToLeft];
    [rightShadowView setColorArrays:@[[UIColor clearColor],[UIColor colorWithWhite:0 alpha:0.3]]];
    [_right_view addSubview:rightShadowView];
    
    _tableData = [[NSMutableArray alloc] init];
    [_tableView reloadData];
    [self setupClient];
    [self showIntro];

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)willEnterForeground
{
    _tableData = [[NSMutableArray alloc] init];
    [_tableView reloadData];
    [netServiceBrowser searchForServicesOfType:@"_Rigorous._tcp." inDomain:@""];
}

- (void)willTerminate
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [netServiceBrowser stop];
    if ([asyncSocket isConnected]) {
        [asyncSocket disconnect];
    }
}

- (void)willResignActive
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [netServiceBrowser stop];
    if ([asyncSocket isConnected]) {
        [asyncSocket disconnect];
    }
}

- (void)showIntro
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 180)];
    
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 20;
    welcomeLabelRect.size.height = 20;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"Welcome to Rigorous!";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = CGRectGetMaxY(welcomeLabelRect)+5;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect);
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoLabelRect];
    infoLabel.text = @"With Rigorous you can control your Mac like you control your TV! Select your Mac to unleash the full power of Rigorous.";
    infoLabel.numberOfLines = 4;
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.shadowColor = [UIColor blackColor];
    infoLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:infoLabel];
    
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}

- (void)setupClient
{    
	netServiceBrowser = [[NSNetServiceBrowser alloc] init];
	
	[netServiceBrowser setDelegate:self];
	[netServiceBrowser searchForServicesOfType:@"_Rigorous._tcp." inDomain:@""];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender didNotSearch:(NSDictionary *)errorInfo
{
	NSLog(@"DidNotSearch: %@", errorInfo);
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing
{
	NSLog(@"DidFindService: %@", [netService name]);
    
    [_tableData addObject:netService];
    [_tableView reloadData];
    [_mainview updateLeftScreenshot];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing
{
	NSLog(@"DidRemoveService: %@", [netService name]);
    
    [_tableData removeObject:netService];
    [_tableView reloadData];
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)sender
{
	NSLog(@"DidStopSearch");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    DeviceCell *cell = (DeviceCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[DeviceCell alloc] init];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
    NSNetService *temp = [_tableData objectAtIndex:indexPath.row];
    [[cell itemDescription] setText:[temp name]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Connecting";
    HUD.square = YES;
    HUD.dimBackground = YES;
    [HUD show:YES];
    
    serverService = [_tableData objectAtIndex:indexPath.row];
    [serverService setDelegate:self];
    [serverService resolveWithTimeout:10.0];
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
	NSLog(@"DidNotResolve");
    
    [HUD show:NO];
    [HUD removeFromSuperview];
    [self showErrorNotice:@"Couldn't resolve service!"];
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	NSLog(@"DidResolve: %@", [sender addresses]);
    serverAddresses = [[sender addresses] mutableCopy];
	
	if (asyncSocket == nil)
	{
		asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
		[self connectToNextAddress];
	} else {
        [self connectToNextAddress];
    }
}

- (void)connectToNextAddress
{
    NSLog(@"List of %d addresses", [serverAddresses count]);
	
    BOOL done = NO;
	while (!done && ([serverAddresses count] > 0))
	{
		NSData *addr;
		
		if (YES) {
			addr = [serverAddresses objectAtIndex:0];
			[serverAddresses removeObjectAtIndex:0];
		}
		else {
			addr = [serverAddresses lastObject];
			[serverAddresses removeLastObject];
		}
		
		NSLog(@"Attempting connection to %@", addr);
		NSError *err = nil;
		if ([asyncSocket connectToAddress:addr error:&err]) {
			done = YES;
		} else {
			NSLog(@"Unable to connect: %@", err);
		}
	}
	
	if (!done)
	{
		NSLog(@"Unable to connect to any resolved address");
	}
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
	NSLog(@"Socket:DidConnectToHost: %@ Port: %hu", host, port);
    
    [_mainview setPaperFoldState:PaperFoldStateDefault];
    [HUD show:NO];
    [HUD removeFromSuperview];
    [self showSuccessNotice:@"Connected successfully!"];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
	NSLog(@"SocketDidDisconnect:WithError: %@", err);
	
    if (err != nil) {
        [_tableData removeObject:serverService];
        [_tableView reloadData];
        [self showErrorNotice:@"Connection lost!"];
    }
    [_mainview updateLeftScreenshot];
    [_mainview setPaperFoldState:PaperFoldStateLeftUnfolded];
}

- (void)sendMessage:(NSString *)msg
{
    NSLog(@"Message to send: %@", msg);
    NSString *message = [NSString stringWithFormat:@"%@ \n", msg];
    NSString *encryptedData = [AESCrypt encrypt:message password:@KEYPHRASE];
    NSData* data = [encryptedData dataUsingEncoding: NSASCIIStringEncoding];
    [asyncSocket writeData:data withTimeout:3 tag:0];
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{    
    [self showErrorNotice:@"Couldn't send command!"];
    
    return 0;
}

- (void)paperFoldView:(id)paperFoldView didFoldAutomatically:(BOOL)automatic toState:(PaperFoldState)paperFoldState
{
    if (paperFoldState == PaperFoldStateLeftUnfolded) {
        if ([asyncSocket isConnected]) {
            [asyncSocket disconnect];
            [serverService stop];
        }
    }
}

- (void)showSuccessNotice:(NSString*)text
{
    WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:self.view title:text];
    [notice setTapToDismissEnabled:true];
    [notice show];
}

- (void)showErrorNotice:(NSString*)text
{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:@"Error" message:text];
    [notice setTapToDismissEnabled:true];
    [notice show];
}

// ------------------------------------------------------------------------------------

- (IBAction)actioniTunesPlayPause:(id)sender
{
    [self sendMessage:@"itunes action:playpause"];
}

- (IBAction)actioniTunesPlayPrevious:(id)sender
{
    [self sendMessage:@"itunes action:previoustrack"];
}

- (IBAction)actioniTunesPlayNext:(id)sender
{
    [self sendMessage:@"itunes action:nexttrack"];
}

- (IBAction)actionKeynoteNextSlide:(id)sender
{
    [self sendMessage:@"keynote action:nextslide"];
}

- (IBAction)actionKeynotePreviousSlide:(id)sender
{
    [self sendMessage:@"keynote action:previousslide"];
}

- (IBAction)actionKeynotePlayPauseSlide:(id)sender
{
    [self sendMessage:@"keynote action:playpause"];
}

- (IBAction)actionPowerPointNextSlide:(id)sender
{
    [self sendMessage:@"powerpoint action:nextslide"];
}

- (IBAction)actionPowerPointPreviousSlide:(id)sender
{
    [self sendMessage:@"powerpoint action:previousslide"];
}

- (IBAction)actionPowerPointPlayPauseSlide:(id)sender
{
    [self sendMessage:@"powerpoint action:playpause"];
}

- (IBAction)actionVLCPlayPause:(id)sender
{
    [self sendMessage:@"vlc action:playpause"];
}

- (IBAction)actionVLCMute:(id)sender
{
    [self sendMessage:@"vlc action:mute"];
}

- (IBAction)actionVLCStop:(id)sender
{
    [self sendMessage:@"vlc action:stop"];
}

- (IBAction)actionVLCVolumeUp:(id)sender
{
    [self sendMessage:@"vlc action:volumeup"];
}

- (IBAction)actionVLCVolumeDown:(id)sender
{
    [self sendMessage:@"vlc action:volumedown"];
}

- (IBAction)actionVLCFullscreen:(id)sender
{
    [self sendMessage:@"vlc action:fullscreen"];
}

@end
