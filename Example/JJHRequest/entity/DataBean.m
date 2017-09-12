//
//  DataBean.m
//  Pods
//
//  Created by jianjianhong on 17/8/7.
//
//

#import "DataBean.h"
#import "User.h"

@implementation DataBean

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"rows" : [User class]};
}
@end
