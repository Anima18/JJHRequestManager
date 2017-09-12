//
//  User.h
//  MyLib
//
//  Created by jianjianhong on 17/7/17.
//  Copyright © 2017年 jianjianhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

/* name */
@property(nonatomic, copy) NSString *name;

/* age */
@property(nonatomic, assign) NSInteger age;

/* sex */
@property(nonatomic, copy) NSString *sex;

/* course */
@property(nonatomic, strong) NSArray *courseList;

@end
