//
//  SettingView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "SettingView.h"

@implementation SettingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        /* 菜单 table*/
        
        _menuTableView =({
            UITableView *_ =[[UITableView alloc]init];
            [self addSubview:_];
            _.sd_layout
            .topSpaceToView(self,0)
            .leftSpaceToView(self,0)
            .rightSpaceToView(self,0)
            .heightEqualToWidth();
            _.bounces = NO;
            _.separatorStyle = UITableViewCellSeparatorStyleNone;
            _;
        });
        
        
        /* 退出登录按钮*/
        _logOutButton =({
            UIButton *_ =[[UIButton alloc]init];
            _.titleLabel.font = TITLEFONTSIZE;
            [self addSubview:_];
            _ .sd_layout
            .leftSpaceToView(self ,20)
            .rightSpaceToView(self,20)
            .topSpaceToView(_menuTableView,60)
            .heightRatioToView(self,0.06f);
            [_ setTitle:@"退出登录" forState:UIControlStateNormal];
            _.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
            [_ setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
            _.layer.borderColor = NAVIGATIONRED.CGColor;
            _.layer.borderWidth = 1;
            _;
        });
    }
    return self;
}


@end
