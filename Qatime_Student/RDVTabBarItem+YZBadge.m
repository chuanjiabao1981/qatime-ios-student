//
//  RDVTabBarItem+YZBadge.m
//  Qatime_Student
//
//  Created by Shin on 2017/2/28.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "RDVTabBarItem+YZBadge.h"

static const void *isShowNowKey = &isShowNowKey;

static const void *badgeKey = &badgeKey;

@implementation RDVTabBarItem (YZBadge)


-(UIView *)badge{
    
    return objc_getAssociatedObject(self, badgeKey);
}

-(void)setBadge:(UIView *)badge{
    
    objc_setAssociatedObject(self, badgeKey, badge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}


- (BOOL)isShowNow{
    NSNumber *number = objc_getAssociatedObject(self, isShowNowKey);
  return [number boolValue];
    
}

-(void)setIsShowNow:(BOOL)isShowNow{
    
    objc_setAssociatedObject(self, isShowNowKey, @(isShowNow), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)showBadges{
    
    self.badge = [[UIView alloc]init];
    [self addSubview:self.badge];
    self.badge.frame = CGRectMake(self.width_sd - 20, 5, 10, 10) ;
    self.badge.layer.masksToBounds = YES;
    self.badge.layer.cornerRadius = 5;
    self.badge.backgroundColor = [UIColor redColor];
    self.badge.hidden = NO;
    
   self.isShowNow = YES;
    
    
}


- (void)hideBadges{
    
    self.badge.hidden = YES;
    self.isShowNow = NO;
    
}





@end
