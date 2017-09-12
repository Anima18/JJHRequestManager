//
//  MBProgressHUDUtil.h
//  MBProgressHUDDemo
//
//  Created by jianjianhong on 17/8/4.
//  Copyright © 2017年 jianjianhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@class JJHNetworkRequest;

@interface MBProgressHUDUtil : NSObject

+ (void)showProgress:(NSString *)message;

+ (void)showBarProgress:(NSString *)message details:(NSString *)details;

+ (MBProgressHUD *)HUD;

+ (void)hideProgress;

+ (void)setDelegate:(id<MBProgressHUDDelegate>)delegate;

+ (void)addRequest:(JJHNetworkRequest *)request;

+ (NSArray *)requests;

+ (void)clearRequests;

@end
