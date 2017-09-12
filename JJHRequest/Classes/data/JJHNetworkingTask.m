//
//  JJHNetworkingTask.m
//
//  Created by jianjianhong on 17/8/3.
//  Copyright © 2017年 jianjianhong. All rights reserved.
//

#import "JJHNetworkingTask.h"
#import "AFHTTPSessionManager.h"
#import "JJHRequestParam.h"

@implementation JJHNetworkingTask {
    
    AFHTTPSessionManager *_manager;
    
}

- (id)init
{
    if (self = [super init])
    {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer.HTTPShouldHandleCookies = YES;
        
        _manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        //        [_HTTPManager.requestSerializer setTimeoutInterval:TIME_NETOUT];
        //
        //把版本号信息传导请求头中
        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"iOS-%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]] forHTTPHeaderField:@"MM-Version"];
        
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", @"text/plain", @"application/octet-stream",nil];
        
        
    }
    return self;
}

+ (id)sharedInstance {
    static JJHNetworkingTask * helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[JJHNetworkingTask alloc] init];
    });
    return helper;
}

+ (NSURLSessionDataTask *)dataTask:(JJHRequestParam *)param success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    JJHNetworkingTask *helper = [JJHNetworkingTask sharedInstance];
    
    NSURLSessionDataTask *task ;
    if(param.method == GET) {
        task = [helper p_getTask:param.url parameters:param.param success:success failure:failure];
    }else if(param.method == POST) {
        task = [helper p_postTask:param.url parameters:param.param success:success failure:failure];
    }
    return task;
}

- (NSURLSessionDataTask *)p_getTask:(NSString*)url parameters:(NSMutableDictionary*)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSURLSessionDataTask *task = [_manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    return task;
}

- (NSURLSessionDataTask *)p_postTask:(NSString*)url parameters:(NSMutableDictionary*)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSURLSessionDataTask *task = [_manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    return task;
}

+ (NSURLSessionDownloadTask *)downloadTask:(JJHRequestParam *)param
                                    progress:(void(^)(NSProgress *progress))progress
                           completionHandler:(void (^)(NSURL *filePath, NSError *error))completionHandler {
    JJHNetworkingTask *helper = [JJHNetworkingTask sharedInstance];
    return [helper p_downloadTask:param progress:progress completionHandler:completionHandler];
}

- (NSURLSessionDownloadTask *)p_downloadTask:(JJHRequestParam *)param progress:(void (^)(NSProgress *))progress completionHandler:(void (^)(NSURL *, NSError *))completionHandler {
    
    NSURL *URL = [NSURL URLWithString:param.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [NSURL URLWithString:param.downloadFilePath];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        completionHandler(filePath, error);
        
    }];
    
    
    [downloadTask resume];
    return downloadTask;
}

+ (NSURLSessionDataTask *)uploadTask:(JJHRequestParam *)param
                               progress:(void(^)(NSProgress *progress))progress
                      completionHandler:(void (^)(id responseObject, NSError *error))completionHandler {
    JJHNetworkingTask *helper = [JJHNetworkingTask sharedInstance];
    return [helper p_uploadTask:param progress:progress completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)p_uploadTask:(JJHRequestParam *)param
                               progress:(void(^)(NSProgress *progress))progress
                      completionHandler:(void (^)(id responseObject, NSError *error))completionHandler{
    
    NSMutableURLRequest *request = [_manager.requestSerializer multipartFormRequestWithMethod:[self getStringForRequestType:param.method] URLString:param.url parameters:param.param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //文件上传
        NSDictionary *fileParam = param.uploadFileParam;
        if (fileParam) {
            for (NSString *key in [fileParam allKeys]) {
                [formData appendPartWithFileData:[fileParam objectForKey:key] name:@"file" fileName:key mimeType:@"application/octet-stream"];
            }
        }
        
    } error:nil];
    
    NSURLSessionDataTask *task = [_manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress);
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        completionHandler(responseObject, error);
    }];
    
    [task resume];
    return task;
}

-(NSString *)getStringForRequestType:(HTTPRequestMethod)type {
    
    NSString *requestTypeString;
    
    switch (type) {
        case POST:
            requestTypeString = @"POST";
            break;
            
        case GET:
            requestTypeString = @"GET";
            break;
            
        default:
            requestTypeString = @"POST";
            break;
    }
    
    return requestTypeString;
}
@end
