//
//  VerifyPasswordView.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/20.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VerifyPasswordView.h"

#define SQUAREWIDTH self.width_sd*0.14

@implementation VerifyPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = BACKGROUNDGRAY;
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
            
       
    
    }
    return self;
}

@end
