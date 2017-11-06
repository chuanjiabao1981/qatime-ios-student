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
        [_listenButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
        _listenButton.titleLabel.font = TITLEFONTSIZE;
        
        _listenButton.layer.borderColor = NAVIGATIONRED.CGColor;
        _listenButton.layer.borderWidth = 1.0;
        
        
        _applyButton =[[UIButton alloc]init];
        _applyButton.backgroundColor = [UIColor whiteColor];
        [_applyButton setTitle:@"立即报名" forState:UIControlStateNormal];
        [_applyButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
        _applyButton.titleLabel.font = TITLEFONTSIZE;
        _applyButton.layer.borderColor = NAVIGATIONRED.CGColor;
        _applyButton.layer.borderWidth = 1.0;
        
        
        _shareButton = [[UIButton alloc]init];
        [_shareButton setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateNormal];
       
        
        UIView *line = [[UIView alloc]init];
        line .backgroundColor = [UIColor lightGrayColor];
        
        
        [self sd_addSubviews:@[_listenButton,_applyButton,_shareButton,line]];
       
        _applyButton.sd_layout
        .rightSpaceToView(self,10*ScrenScale)
        .topSpaceToView(self, 10*ScrenScale)
        .bottomSpaceToView(self, 10*ScrenScale)
        .widthIs(self.width_sd/4-15*ScrenScale);
    
        _listenButton.sd_layout
        .rightSpaceToView(_applyButton, 10*ScrenScale)
        .topEqualToView(_applyButton)
        .bottomEqualToView(_applyButton)
        .widthRatioToView(_applyButton, 1.0);
        
        _shareButton.sd_layout
        .leftSpaceToView(self, 15*ScrenScale)
        .topSpaceToView(self, 10*ScrenScale)
        .bottomSpaceToView(self, 10*ScrenScale)
        .widthEqualToHeight();
        
        line.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topEqualToView(self)
        .heightIs(0.4);
        
        _listenButton.sd_cornerRadius = @(M_PI);
        _applyButton.sd_cornerRadius = @(M_PI);
        
        
    }
    return self;
}



@end
