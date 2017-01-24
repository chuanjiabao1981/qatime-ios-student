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
        _backGroundView.backgroundColor = [UIColor whiteColor];

        
        
        /* 头像*/
        
        _headImageView  = [[UIImageView alloc]init];
        [_backGroundView addSubview:_headImageView];
        
        
        _name = [[UILabel alloc]init];
        [_backGroundView addSubview:_name];
        _name.textColor = TITLECOLOR;
        
        
        UIView *line = [[UIView alloc]init];
        [_backGroundView addSubview:line];
        line.backgroundColor = [UIColor lightGrayColor];
        
        _headImageView.sd_layout
        .centerXEqualToView(_backGroundView)
        .centerYEqualToView(_backGroundView)
        .heightRatioToView(_backGroundView,2/5.0f)
        .widthEqualToHeight();
        
        _headImageView.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5f];
        
        
        _name.sd_layout
        .topSpaceToView(_headImageView,5)
        .centerXEqualToView(_headImageView)
        .heightIs (40)
        .widthRatioToView(self,1/3.0f);
        _name.textAlignment = NSTextAlignmentCenter;
        
        
        
        line.sd_layout
        .leftEqualToView(_backGroundView)
        .rightEqualToView(_backGroundView)
        .bottomEqualToView(_backGroundView)
        .heightIs(0.4);
        
        
    }
    return self;
}

@end
