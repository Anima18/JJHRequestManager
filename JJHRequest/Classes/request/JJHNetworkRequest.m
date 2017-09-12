//
//  JJHNetworkRequest.m
//  IOSRequestManager
//
//  Created by jianjianhong on 17/8/1.
//  Copyright © 2017年 Anima18. All rights reserved.
//

#import "JJHNetworkRequest.h"
#import "JJHRequestParam.h"
#import "JJHNetworkingTask.h"
#import "MBProgressHUDUtil.h"
#import "YYModel.h"
#import "ReactiveObjC.h"
#import "JJHError.h"

@interface JJHNetworkRequest () <MBProgressHUDDelegate>

/* 请求参数 */
@property(nonatomic, strong) JJHRequestParam *requestParam;

/* HUD 显示信息 */
@property(nonatomic, copy) NSString *progressMessage;

/* 网络请求Task */
@property(nonatomic, strong) NSURLSessionDataTask *task;

/* 请求信号 */
@property(nonatomic, weak) RACSignal *signal;

@end

@implementation JJHNetworkRequest

-(instancetype)init {
    if (self = [super init])
    {
        _requestParam = [[JJHRequestParam alloc] init];
        _progressMessage = @"正在处理中，请稍后...";
        [MBProgressHUDUtil setDelegate:self];
        [MBProgressHUDUtil addRequest:self];
    }
    return self;
}

+ (JJHNetworkRequest *)request {
    //JJHNetworkRequest *request = [JJHNetworkRequest new];
    return [[JJHNetworkRequest alloc] init];
}

- (JJHNetworkRequest *)url:(NSString *)url {
    _requestParam.url = url;
    return self;
}

- (JJHNetworkRequest *)method:(HTTPRequestMethod)method {
    _requestParam.method = method;
    return self;
}

- (JJHNetworkRequest *)methodString:(NSString *)method {
    if([@"GET" isEqualToString:method]) {
        _requestParam.method = GET;
    }else if ([@"POST" isEqualToString:method]) {
        _requestParam.method = POST;
    }
    return self;
}

- (JJHNetworkRequest *)dataClass:(NSString *)cls {
    _requestParam.cls = cls;;
    return self;
}

- (JJHNetworkRequest *)downloadFilePath:(NSString *)filePath {
    _requestParam.downloadFilePath = filePath;
    return self;
}

- (JJHNetworkRequest *)progressMessage:(NSString *)message {
    self.progressMessage = message;
    return self;
}

- (JJHNetworkRequest *)addParam:(NSString *)key value:(NSObject *)value {
    _requestParam.param[key] = value;
    return self;
}

-(JJHNetworkRequest *)setParam:(NSMutableDictionary *)param {
    _requestParam.param = param;
    return self;
}

- (JJHNetworkRequest *)uploadFileParam:(NSMutableDictionary *)fileParam {
    _requestParam.uploadFileParam = fileParam;
    return self;
}

- (void)data:(void(^)(id result))success failure:(void(^)(NSUInteger code, NSString *errorMessage))failure {
    NSError *error = [JJHError dataRequestError:_requestParam];
    if(error) {
        failure(error.code, [JJHError errorMessage:error]);
        return;
    }
    
    [MBProgressHUDUtil showProgress:self.progressMessage];
    self.task = [JJHNetworkingTask dataTask:_requestParam success:^(id result) {
        
        id data = [NSClassFromString(_requestParam.cls) yy_modelWithJSON:result];
        
        success(data);
        [MBProgressHUDUtil hideProgress];
    } failure:^(NSError *error) {
    
        failure(error.code, [JJHError errorMessage:error]);
        [MBProgressHUDUtil hideProgress];
    }];
}

- (void)download:(void (^)(NSString *))success failure:(void (^)(NSUInteger code, NSString *errorMessage))failure {
    NSError *error = [JJHError downloadRequestError:_requestParam];
    if(error) {
        failure(error.code, [JJHError errorMessage:error]);
        return;
    }
    
    [MBProgressHUDUtil showBarProgress:self.progressMessage details:nil];
    MBProgressHUD *HUD = [MBProgressHUDUtil HUD];
    self.task = [JJHNetworkingTask downloadTask:_requestParam progress:^(NSProgress *downloadProgress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"%@", [NSThread currentThread]);
            if (HUD) {
                
                HUD.progress = downloadProgress.fractionCompleted;
                
                HUD.labelText = [NSString stringWithFormat:@"%2.f%%",downloadProgress.fractionCompleted*100];
                
            }
        });
        
    } completionHandler:^(NSURL *filePath, NSError *error) {
        [MBProgressHUDUtil hideProgress];
        if(error) {
            failure(error.code, [JJHError errorMessage:error]);
        }else {
            success(filePath);
        }
    }];

}

- (void)upload:(void (^)(id))success failure:(void (^)(NSUInteger, NSString *))failure {
    NSError *error = [JJHError dataRequestError:_requestParam];
    if(error) {
        failure(error.code, [JJHError errorMessage:error]);
        return;
    }
    
    [MBProgressHUDUtil showBarProgress:self.progressMessage details:nil];
    MBProgressHUD *HUD = [MBProgressHUDUtil HUD];
    self.task = [JJHNetworkingTask uploadTask:_requestParam progress:^(NSProgress *progress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"%@", [NSThread currentThread]);
            if (HUD) {
                
                HUD.progress = progress.fractionCompleted;
                
                HUD.labelText = [NSString stringWithFormat:@"%2.f%%",progress.fractionCompleted*100];
                
            }
        });
    } completionHandler:^(id responseObject, NSError *error) {
        [MBProgressHUDUtil hideProgress];
        if(error) {
            failure(error.code, [JJHError errorMessage:error]);
        }else {
            id data = [NSClassFromString(_requestParam.cls) yy_modelWithJSON:responseObject];
            success(data);
        }
    }];
}


- (JJHNetworkRequest *)dataRequest {
    self.signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSError *error = [JJHError dataRequestError:_requestParam];
        if(error) {
            [subscriber sendError:error];
        }else {
            [MBProgressHUDUtil showProgress:self.progressMessage];
            self.task = [JJHNetworkingTask dataTask:_requestParam success:^(id result) {
                id data = [NSClassFromString(_requestParam.cls) yy_modelWithJSON:result];
                NSDictionary *dict = @{[self description]:data};
                [subscriber sendNext:dict];
                [subscriber sendCompleted];
            } failure:^(NSError *error) {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }];
            
        }
        return nil;
    }];
    NSLog(@"UTRequest key %@", [self description]);
    return self;
}

- (JJHNetworkRequest *)downloadRequest {
    self.signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSError *error = [JJHError downloadRequestError:_requestParam];
        if(error) {
            [subscriber sendError:error];
        }else {
            [MBProgressHUDUtil showBarProgress:self.progressMessage details:nil];
            MBProgressHUD *HUD = [MBProgressHUDUtil HUD];
            self.task = [JJHNetworkingTask downloadTask:_requestParam progress:^(NSProgress *downloadProgress) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSLog(@"%@", [NSThread currentThread]);
                    if (HUD) {
                        
                        HUD.progress = downloadProgress.fractionCompleted;
                        
                        HUD.labelText = [NSString stringWithFormat:@"%2.f%%",downloadProgress.fractionCompleted*100];
                        
                    }
                });
                
            } completionHandler:^(NSURL *filePath, NSError *error) {
                if(error) {
                    [subscriber sendError:error];
                }else {
                    NSDictionary *dict = @{[self description]:filePath};
                    [subscriber sendNext:dict];
                }
                [subscriber sendCompleted];
            }];
        }
        
        return nil;
    }];
    
    return self;
}

- (JJHNetworkRequest *)uploadRequest {
    self.signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSError *error = [JJHError dataRequestError:_requestParam];
        if(error) {
            [subscriber sendError:error];
        }else {
            [MBProgressHUDUtil showBarProgress:self.progressMessage details:nil];
            MBProgressHUD *HUD = [MBProgressHUDUtil HUD];
            self.task = [JJHNetworkingTask uploadTask:_requestParam progress:^(NSProgress *progress) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSLog(@"%@", [NSThread currentThread]);
                    if (HUD) {
                        
                        HUD.progress = progress.fractionCompleted;
                        
                        HUD.labelText = [NSString stringWithFormat:@"%2.f%%",progress.fractionCompleted*100];
                        
                    }
                });
            } completionHandler:^(id responseObject, NSError *error) {
                if(error) {
                    [subscriber sendError:error];
                }else {
                    id data = [NSClassFromString(_requestParam.cls) yy_modelWithJSON:responseObject];
                    NSDictionary *dict = @{[self description]:data};
                    [subscriber sendNext:dict];
                }
                [subscriber sendCompleted];
            }];
        }
        
        return nil;
    }];
    
    return self;
}

- (RACSignal *)signal {
    return _signal;
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    NSArray *requests = [MBProgressHUDUtil requests];
    for (JJHNetworkRequest *request in requests) {
        if(request.task) {
            [request.task cancel];
            NSLog(@"cancel task");
        }
    }
    [MBProgressHUDUtil clearRequests];
    
}

@end
