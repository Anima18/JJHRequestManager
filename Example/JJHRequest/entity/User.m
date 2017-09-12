//
//  User.m
//  MyLib
//
//  Created by jianjianhong on 17/7/17.
//  Copyright © 2017年 jianjianhong. All rights reserved.
//

#import "User.h"
#import "Course.h"

@implementation User

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"courseList" : [Course class]};
}

@end
