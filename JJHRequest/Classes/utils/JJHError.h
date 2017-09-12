//
//  UTError.h
//  Pods
//
//  Created by jianjianhong on 17/8/17.
//
//

#import <Foundation/Foundation.h>
@class UTRequestParam;

@interface JJHError : NSObject

+ (NSError *)dataRequestError:(UTRequestParam *)param;

+ (NSError *)downloadRequestError:(UTRequestParam *)param;

+ (NSString *)errorMessage:(NSError *)error;

@end
