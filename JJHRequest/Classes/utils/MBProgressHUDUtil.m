//
//  MBProgressHUDUtil.m
//  MBProgressHUDDemo
//
//  Created by jianjianhong on 17/8/4.
//  Copyright © 2017年 jianjianhong. All rights reserved.
//

#import "MBProgressHUDUtil.h"

@interface MBProgressHUDUtil ()

/* HUD */
@property(nonatomic, strong) MBProgressHUD *hud;
/* delegate */
@property(nonatomic, weak) id<MBProgressHUDDelegate> delegate;

/* requst list */
@property(nonatomic, strong) NSMutableArray *requestList;
@end

@implementation MBProgressHUDUtil

- (instancetype)init {
    if(self = [super init]) {
        UIWindow *view = [UIApplication sharedApplication].keyWindow;
        
        self.hud = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:self.hud];
        self.hud.removeFromSuperViewOnHide = NO;
        
        self.requestList = [NSMutableArray new];
    }
    return self;
}

+ (id)sharedInstance {
    static MBProgressHUDUtil * progressUtil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        progressUtil = [[MBProgressHUDUtil alloc] init];
        
    });
    return progressUtil;
}

+ (void)showProgress:(NSString *)message {
    MBProgressHUDUtil *progressUtil = [self sharedInstance];
    progressUtil.hud.mode = MBProgressHUDModeIndeterminate;
    progressUtil.hud.label.text = message;
    [progressUtil.hud.button setTitle:NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
    [progressUtil.hud.button addTarget:self action:@selector(hideProgress) forControlEvents:UIControlEventTouchUpInside];
    
    [progressUtil.hud showAnimated:YES];
}

+ (void)showBarProgress:(NSString *)message details:(NSString *)details{
    MBProgressHUDUtil *progressUtil = [self sharedInstance];
    
    // Set the bar determinate mode to show task progress.
    progressUtil.hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    progressUtil.hud.label.text = NSLocalizedString(message, @"HUD loading title");
    progressUtil.hud.detailsLabel.text = NSLocalizedString(details, @"HUD title");
    progressUtil.hud.progress = 0;
    [progressUtil.hud.button setTitle:NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
    [progressUtil.hud.button addTarget:self action:@selector(hideProgress) forControlEvents:UIControlEventTouchUpInside];
    [progressUtil.hud showAnimated:YES];
    
}

+ (MBProgressHUD *)HUD {
    MBProgressHUDUtil *progressUtil = [self sharedInstance];
    return progressUtil.hud;
}

+ (void)hideProgress {
    MBProgressHUDUtil *progressUtil = [self sharedInstance];
    if(progressUtil != nil && progressUtil.hud != nil) {
        [progressUtil.hud hideAnimated:YES];
    }
}

+ (void)setDelegate:(id<MBProgressHUDDelegate>)delegate {
    MBProgressHUDUtil *progressUtil = [self sharedInstance];
    progressUtil.delegate = delegate;
    progressUtil.hud.delegate = progressUtil.delegate;
}

+ (void)addRequest:(JJHNetworkRequest *)request {
    MBProgressHUDUtil *progressUtil = [self sharedInstance];
    [progressUtil.requestList addObject:request];
}

+ (NSArray *)requests {
    MBProgressHUDUtil *progressUtil = [self sharedInstance];
    return progressUtil.requestList;
}

+ (void)clearRequests {
    MBProgressHUDUtil *progressUtil = [self sharedInstance];
    [progressUtil.requestList removeAllObjects];
}

@end
