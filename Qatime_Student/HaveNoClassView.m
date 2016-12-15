//
//  HaveNoClassView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/15.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "HaveNoClassView.h"

@implementation HaveNoClassView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [UILabel new];
        _titleLabel.text = @"";
        [self addSubview:_titleLabel];
        _titleLabel.textColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.00];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.sd_layout
        .centerYEqualToView(self)
        .centerXEqualToView(self)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightRatioToView(self,0.04);
        
        
        
    }
    return self;
}






@end
