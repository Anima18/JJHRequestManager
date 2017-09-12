//
//  RequestParam.m
//  AFNetworkingDemo
//
//  Created by jianjianhong on 17/8/3.
//  Copyright © 2017年 jianjianhong. All rights reserved.
//

#import "JJHRequestParam.h"

@implementation JJHRequestParam

-(instancetype)init {
    self = [super init];
    if(self) {
        self.param = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end
