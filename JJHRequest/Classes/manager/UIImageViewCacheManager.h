//
//  UIImageViewCacheManager.h
//  Pods
//
//  Created by jianjianhong on 17/9/7.
//
//

#import <Foundation/Foundation.h>

@interface UIImageViewCacheManager : NSObject

+ (void)clearAllImageCache;

+ (void)clearImageCacheWithURL:(NSURL *)url;


@end
