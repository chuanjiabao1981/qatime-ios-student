//
//  ReplayFilterView.m
//  Qatime_Student
//
//  Created by Shin on 2017/6/21.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ReplayFilterView.h"

@implementation ReplayFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //最近更新按钮
        _newestBtn = ({
            UIButton *_ = [[UIButton alloc]init];
            [self addSubview:_];
            [_ setTitle:@"最近更新" forState:UIControlStateNormal];
            [_ setTitleColor:BUTTONRED forState:UIControlStateNormal];
            
            _.titleLabel.font = [UIFont systemFontOfSize:15*ScrenScale];
            _.sd_layout
            .leftSpaceToView(self,15*ScrenScale)
            .topEqualToView(self)
            .bottomEqualToView(self)
            .widthIs(80);
            
            [_ setEnlargeEdge:10];
            
            _;
        });
        //最新 筛选箭头
        _newestArrow = ({
            UIImageView *_=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"下箭头红"]];
            [self addSubview:_];
            _.sd_layout
            .centerYEqualToView(_newestBtn)
            .leftSpaceToView(_newestBtn,0)
            .heightRatioToView(_newestBtn,0.3)
            .widthIs(5);
            _;
        });
        
        
        //最多人观看按钮
        _popularityBtn= ({
            UIButton *_ = [[UIButton alloc]init];
            [self addSubview:_];
            [_ setTitle:@"最多人看" forState:UIControlStateNormal];
            [_ setTitleColor:SEPERATELINECOLOR_2 forState:UIControlStateNormal];
            _.titleLabel.textColor = TITLECOLOR;
            _.titleLabel.font = [UIFont systemFontOfSize:15*ScrenScale];
            _.sd_layout
            .leftSpaceToView(_newestBtn,20*ScrenScale)
            .topEqualToView(_newestBtn)
            .bottomEqualToView(_newestBtn)
            .widthIs(80);
            
            _;
        });
        
        //最多人看 箭头
        _popularityArrow = ({
            UIImageView *_=[[UIImageView alloc]init];
            [self addSubview:_];
            _.sd_layout
            .centerYEqualToView(_popularityBtn)
            .leftSpaceToView(_popularityBtn,0)
            .heightRatioToView(_popularityBtn,0.3)
            .widthIs(5);
            _;
        });

        UIView *line = [[UIView alloc]init];
        [self addSubview:line];
        line.backgroundColor = SEPERATELINECOLOR_2;
        line.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .bottomSpaceToView(self, 0)
        .heightIs(0.5);
        
    }
    return self;
}

@end
