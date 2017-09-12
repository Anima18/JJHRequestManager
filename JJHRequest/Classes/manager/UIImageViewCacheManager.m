//
//  UIImageViewCacheManager.m
//  Pods
//
//  Created by jianjianhong on 17/9/7.
//
//

#import "UIImageViewCacheManager.h"
#import <AFNetworking/AFImageDownloader.h>

@implementation UIImageViewCacheManager

+ (void)clearAllImageCache {
    AFImageDownloader *downloader = [AFImageDownloader defaultInstance];
    NSURLCache *urlCache = downloader.sessionManager.session.configuration.URLCache;
    [urlCache removeAllCachedResponses];
    
    [downloader.imageCache removeAllImages];
}

+ (void)clearImageCacheWithURL:(NSURL *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    AFImageDownloader *downloader = [AFImageDownloader defaultInstance];
    [[AFImageDownloader defaultURLCache] removeCachedResponseForRequest:request];
//    NSURLCache *urlCache = downloader.sessionManager.session.configuration.URLCache;
//    [urlCache removeCachedResponseForRequest:request];
    
    [downloader.imageCache removeImageforRequest:request withAdditionalIdentifier:request.URL.absoluteString];
}

@end
