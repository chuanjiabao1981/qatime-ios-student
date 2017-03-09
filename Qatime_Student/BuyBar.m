//
//  BuyBar.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/12.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "BuyBar.h"

@implementation BuyBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _listenButton = [[UIButton alloc]init];
        _listenButton.backgroundColor = [UIColor whiteColor];
        [_listenButton setTitle:@"加入试听" forState:UIControlStateNormal];
        [_listenButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        _listenButton.titleLabel.font = TITLEFONTSIZE;
        
        _listenButton.layer.borderColor = BUTTONRED.CGColor;
        _listenButton.layer.borderWidth = 1.0;
        
        
        
        
        _applyButton =[[UIButton alloc]init];
        _applyButton.backgroundColor = [UIColor whiteColor];
        [_applyButton setTitle:@"立即报名" forState:UIControlStateNormal];
        [_applyButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        _applyButton.titleLabel.font = TITLEFONTSIZE;
        _applyButton.layer.borderColor = BUTTONRED.CGColor;
        _applyButton.layer.borderWidth = 1.0;
        
        
        UIView *line = [[UIView alloc]init];
        line .backgroundColor = [UIColor lightGrayColor];
        
        
        [self sd_addSubviews:@[_listenButton,_applyButton,line]];
    
        _listenButton.sd_layout
        .leftSpaceToView(self,10)
        .topSpaceToView(self,10)
        .bottomSpaceToView(self,10)
        .widthIs(self.width_sd/2-10-5);
        
        _applyButton.sd_layout
        .rightSpaceToView(self,10)
        .topEqualToView(_listenButton)
        .bottomEqualToView(_listenButton)
        .widthRatioToView(_listenButton,1.0);
        
        line.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topEqualToView(self)
        .heightIs(0.4);
        
        
    }
    return self;
}



@end
