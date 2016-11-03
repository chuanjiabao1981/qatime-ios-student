//
//  PersonalView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/3.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "PersonalView.h"

@implementation PersonalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        
        
        
        
        /* 退出登录按钮*/
        _logOutButton = [[UIButton alloc]init];
        [self addSubview:_logOutButton];
        _logOutButton .sd_layout.leftSpaceToView(self ,10).rightSpaceToView(self,10).bottomSpaceToView(self,60).heightRatioToView(self,0.08f);
        _logOutButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
        [_logOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_logOutButton setBackgroundColor:[UIColor orangeColor]];
        
        
        
        
        
        
        
    }
    return self;
}

@end
