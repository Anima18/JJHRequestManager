//
//  JJHError.m
//  Pods
//
//  Created by jianjianhong on 17/8/17.
//
//

#import "JJHError.h"
#import "JJHRequestParam.h"

@implementation JJHError

+ (NSError *)dataRequestError:(JJHRequestParam *)param {
    if(!param.url) {
        return [NSError errorWithDomain:@"" code:9001 userInfo:@{@"NSLocalizedDescription":@"请求URL不能为空"}];
    }else if(!param.method) {
        return [NSError errorWithDomain:@"" code:9002 userInfo:@{@"NSLocalizedDescription":@"请求Mothed不能为空"}];
    }else if(!param.cls) {
        return [NSError errorWithDomain:@"" code:9003 userInfo:@{@"NSLocalizedDescription":@"请求序列化对象Class不能为空"}];
    }
    
    return nil;
}

+ (NSError *)downloadRequestError:(JJHRequestParam *)param {
    if(!param.url) {
        return [NSError errorWithDomain:@"" code:9001 userInfo:@{@"NSLocalizedDescription":@"请求URL不能为空"}];
    }else if(!param.method) {
        return [NSError errorWithDomain:@"" code:9002 userInfo:@{@"NSLocalizedDescription":@"请求Mothed不能为空"}];
    }else if(!param.downloadFilePath) {
        return [NSError errorWithDomain:@"" code:9002 userInfo:@{@"NSLocalizedDescription":@"请求的下载路径不能为空"}];
    }
    
    return nil;
}

+ (NSString *)errorMessage:(NSError *)error {
    NSString *errorMessage;
    switch (error.code) {
        case NSURLErrorBadURL:
            errorMessage = @"错误的URL";
            break;
        case NSURLErrorTimedOut:
            errorMessage = @"请求超时";
            break;
        case NSURLErrorCannotFindHost:
            errorMessage = @"未能找到使用指定主机名的服务器";
            break;
        case NSURLErrorCancelled:
            errorMessage = @"请求已取消";
            break;
        case NSURLErrorNetworkConnectionLost:
            errorMessage = @"网络连接失败";
            break;
        case NSURLErrorNotConnectedToInternet:
            errorMessage = @"网络已断开";
            break;
        default:
            errorMessage = error.localizedDescription;
            break;
    }
    return errorMessage;
}

@end
