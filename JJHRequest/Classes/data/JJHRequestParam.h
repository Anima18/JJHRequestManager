//
//  RequestParam.h
//  AFNetworkingDemo
//
//  Created by jianjianhong on 17/8/3.
//  Copyright © 2017年 jianjianhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJHNetworkRequestDefine.h"

@interface JJHRequestParam : NSObject

/* url */
@property(nonatomic, copy) NSString *url;

/* method */
@property(nonatomic, assign) HTTPRequestMethod method;

/* 序列化对象Class */
@property(nonatomic, copy) NSString *cls;

/* 请求参数 */
@property(nonatomic, strong) NSMutableDictionary *param;

/* 文件上传参数 */
@property(nonatomic, strong) NSMutableDictionary *uploadFileParam;

/* 文件下载路径 */
@property(nonatomic, copy) NSString *downloadFilePath;

@end
