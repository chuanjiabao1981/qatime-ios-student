//
//  HaveNoClassView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/15.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "HaveNoClassView.h"

@implementation HaveNoClassView

-(instancetype)initWithTitle:(NSString *)title{
    
    self = [super init];
    if (self) {
        
        _titleLabel.text = title;
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = BACKGROUNDGRAY;
        
        _titleLabel = [UILabel new];
        _titleLabel.text = @"";
        [self addSubview:_titleLabel];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.sd_layout
        .centerYEqualToView(self)
        .centerXEqualToView(self)
        .autoHeightRatio(0)
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0);
        
    }
    return self;
}






@end
