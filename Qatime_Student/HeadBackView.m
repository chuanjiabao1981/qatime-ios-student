//
//  HeadBackView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "HeadBackView.h"


#define SCREENWIDTH self.frame.size.width
#define SCREENHEIGHT self.frame.size.height

@implementation HeadBackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        /* 头像的背景*/
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [self addSubview:_backGroundView];
        _backGroundView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];

        
        
        /* 头像*/
        
        _headImageView  = [[UIImageView alloc]init];
        [_backGroundView addSubview:_headImageView];
        
        
        _headImageView.sd_layout
        .centerXEqualToView(_backGroundView)
        .centerYEqualToView(_backGroundView)
        .heightRatioToView(_backGroundView,1/3.0f)
        .widthEqualToHeight();
        
        _headImageView.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5f];
        
        
        
        
    }
    return self;
}

@end
