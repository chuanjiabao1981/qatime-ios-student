//
//  SetPayPasswordView.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "SetPayPasswordView.h"

#define SQUAREWIDTH self.width_sd*0.14


@implementation SetPayPasswordView

-(instancetype)initWithFrame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor  = [UIColor whiteColor];
        
        _imageArr = @[].mutableCopy;
        
        for (NSInteger i = 0; i<6; i++) {
            UIImageView *image = [[UIImageView alloc]init];
            image.frame = CGRectMake((self.width_sd-SQUAREWIDTH*6)/2+SQUAREWIDTH*i-1.6, 40, SQUAREWIDTH, SQUAREWIDTH) ;
            image.layer.borderColor = [UIColor lightGrayColor].CGColor;
            image.layer.borderWidth = 0.8;
            image.userInteractionEnabled = YES;
            image.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:image];
            image.tag = i;
            [_imageArr addObject:image];
            
        }
        
        /* 忘记支付密码按钮*/
        _findPayPasswordButton = [[UIButton alloc]init];
        [_findPayPasswordButton setTitle:@"忘记支付密码?" forState:UIControlStateNormal];
        [_findPayPasswordButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self addSubview:_findPayPasswordButton];
        
        _findPayPasswordButton.sd_layout
        .topSpaceToView(_imageArr[5],30)
        .rightEqualToView(_imageArr[5])
        .heightIs(30)
        .widthIs(200);
        
        [_findPayPasswordButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        
        /* 完成按钮*/
        _finishButton = [[UIButton alloc]init];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        _finishButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _finishButton.layer.borderWidth = 1;
        
        [self addSubview:_finishButton];
        _finishButton.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(_imageArr[5],20)
        .heightRatioToView(self,0.07);
        
        
    }
    return self;
    
}

@end
