//
//  UIControl+RemoveTarget.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/21.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "UIControl+RemoveTarget.h"

@implementation UIControl (RemoveTarget)

- (void)removeAllTargets {
    for (id target in [self allTargets]) {
        [self removeTarget:target action:NULL forControlEvents:UIControlEventAllEvents];
    }
}


@end
