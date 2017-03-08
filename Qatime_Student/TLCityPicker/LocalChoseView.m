//
//  LocalChoseView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/23.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "LocalChoseView.h"

@implementation LocalChoseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *choseLabel = ({
            UILabel *_ = [[UILabel alloc]init];
            _.text = @"当前选择";
            [self addSubview:_];
            _.sd_layout
            .leftSpaceToView(self,20)
            .centerYEqualToView(self)
            .autoHeightRatio(0);
            [_ setSingleLineAutoResizeWithMaxWidth:200];
            _;
        
        });
        
        
        _city = ({
            UIButton *_=[[UIButton alloc]init];
            _.layer.borderColor = BUTTONRED.CGColor;
            _.layer.borderWidth = 0.8;
            [_ setTitleColor:BUTTONRED forState:UIControlStateNormal];
            _.titleLabel.font = [UIFont systemFontOfSize:13*ScrenScale];
            
            [self addSubview:_];
            _.sd_layout
            .leftSpaceToView(choseLabel,20)
            .topSpaceToView(self,10)
            .bottomSpaceToView(self,10)
            .widthRatioToView(choseLabel,1.0);
            _;
        });
        
        _getLocal= ({
            UIButton *_=[[UIButton alloc]init];
            [_ setImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
            _.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:_];
            _.sd_layout
            .rightSpaceToView(self,20)
            .topEqualToView(self)
            .bottomEqualToView(self)
            .widthEqualToHeight();
            _;
        });

        
    }
    return self;
}
@end
