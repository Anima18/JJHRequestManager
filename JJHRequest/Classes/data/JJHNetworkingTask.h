//
//  JJHNetworkingTask.h
//
//  Created by jianjianhong on 17/8/3.
//  Copyright © 2017年 jianjianhong. All rights reserved.
//
//  JJHNetworkingTask是所有网络请求的入口，提供数据请求、文件下载请求和文件上传请求功能。
//  JJHNetworkingTask是个单例模式

#import <Foundation/Foundation.h>
@class JJHRequestParam;

@interface JJHNetworkingTask : NSObject


/**
 创建一个数据请求任务

 @param param 请求参数
 @param success 成功回调
 @param failure 失败回调
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)dataTask:(JJHRequestParam *)param
                              success:(void(^)(id result))success
                              failure:(void(^)(NSError *erro))failure;


/**
 创建一个文件上传  请求任务

 @param param 请求参数
 @param progress 文件上传进度
 @param completionHandler 文件上传结束回调
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)uploadTask:(JJHRequestParam *)param
                               progress:(void(^)(NSProgress *progress))progress
                      completionHandler:(void (^)(id responseObject, NSError *error))completionHandler;


/**
 创建一个文件下载请求任务

 @param param 请求参数
 @param progress 文件下载进度
 @param completionHandler 文件下载结束回调
 @return NSURLSessionDownloadTask
 */
+ (NSURLSessionDownloadTask *)downloadTask:(JJHRequestParam *)param
                                    progress:(void(^)(NSProgress *progress))progress
                           completionHandler:(void (^)(NSURL *filePath, NSError *error))completionHandler;

@end
