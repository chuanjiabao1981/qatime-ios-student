//
//  QRMaskView.m
//  Qatime_Student
//
//  Created by Shin on 2017/2/28.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "QRMaskView.h"

@implementation QRMaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        [_indicator startAnimating];
        [self addSubview:_indicator];
        _indicator.sd_layout
        .centerXEqualToView(self)
        .centerYEqualToView(self)
        .heightIs(30)
        .widthIs(30);
        
        
        _status = [[UILabel alloc]init];
        _status.text = @"正在加载";
        _status.textColor = [UIColor whiteColor];
        
        [self addSubview:_status];
        _status.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(_indicator,20)
        .autoHeightRatio(0);
        [_status setSingleLineAutoResizeWithMaxWidth:100];
        
        
    }
    return self;
}
@end
