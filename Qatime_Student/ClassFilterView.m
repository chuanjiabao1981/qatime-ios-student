//
//  ClassFilterView.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ClassFilterView.h"
#import "UIButton+EnlargeTouchArea.h"

@implementation ClassFilterView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {

        //排序按钮
        _sortingButton = ({
        
            UIControl *_ = [[UIControl alloc]init];
            [self addSubview:_];
            UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"排序"]];
            image.userInteractionEnabled = YES;
            [_ addSubview:image];
            _.sd_layout
            .topEqualToView(self)
            .bottomEqualToView(self)
            .leftSpaceToView(self,5)
            .widthEqualToHeight();
            
            image.sd_layout
            .centerXEqualToView(_)
            .centerYEqualToView(_)
            .heightIs(self.height_sd*0.5)
            .widthEqualToHeight();
            
            _;
        });
        
        //最新按钮
        _newestButton = ({
            UIButton *_ = [[UIButton alloc]init];
            [self addSubview:_];
            [_ setTitle:@"最新" forState:UIControlStateNormal];
            [_ setTitleColor:TITLECOLOR forState:UIControlStateNormal];
            _.titleLabel.textColor = TITLECOLOR;
            _.titleLabel.font = [UIFont systemFontOfSize:15*ScrenScale];
            _.sd_layout
            .leftSpaceToView(_sortingButton,0)
            .topEqualToView(_sortingButton)
            .bottomEqualToView(_sortingButton)
            .widthEqualToHeight();
            
            [_ setEnlargeEdge:10];
            
            _;
        });
        
        //价格按钮
        _priceButton= ({
            UIButton *_ = [[UIButton alloc]init];
            [self addSubview:_];
            [_ setTitle:@"价格" forState:UIControlStateNormal];
            [_ setTitleColor:TITLECOLOR forState:UIControlStateNormal];
            _.titleLabel.textColor = TITLECOLOR;
            _.titleLabel.font = [UIFont systemFontOfSize:15*ScrenScale];
            _.sd_layout
            .leftSpaceToView(_newestButton,10)
            .topEqualToView(_newestButton)
            .bottomEqualToView(_newestButton)
            .widthEqualToHeight();
            
            _;
        });
        
        //人气按钮
        _popularityButton = ({
            UIButton *_ = [[UIButton alloc]init];
            [self addSubview:_];
            [_ setTitle:@"人气" forState:UIControlStateNormal];
            [_ setTitleColor:TITLECOLOR forState:UIControlStateNormal];
            _.titleLabel.textColor = TITLECOLOR;
            _.titleLabel.font = [UIFont systemFontOfSize:15*ScrenScale];
            _.sd_layout
            .leftSpaceToView(_priceButton,10)
            .topEqualToView(_priceButton)
            .bottomEqualToView(_priceButton)
            .widthEqualToHeight();
            
            [_ setEnlargeEdge:10];
            
            _;
        });

        
        //条件筛选按钮
        _filterButton = ({
            UIControl *_ = [[UIControl alloc]init];
            [self addSubview:_];
            _.sd_layout
            .rightEqualToView(self)
            .topEqualToView(self)
            .bottomEqualToView(self)
            .widthIs(self.height_sd*2);
            
            UILabel *label = [[UILabel alloc]init];
            label.userInteractionEnabled = YES;
            [_ addSubview:label];
            label.textColor = TITLECOLOR;
            label.text = @"筛选";
            label.font = [UIFont systemFontOfSize:15*ScrenScale];
            label.sd_layout
            .rightSpaceToView(_,15)
            .centerYEqualToView(_)
            .autoHeightRatio(0);
            [label setSingleLineAutoResizeWithMaxWidth:100];
            
            UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"筛选"]];
            image.userInteractionEnabled = YES;
            [_ addSubview:image];
            image.sd_layout
            .rightSpaceToView(label,0)
            .topEqualToView(label)
            .bottomEqualToView(label)
            .widthEqualToHeight();
            
            _;
        
        });
        
        
        //竖边栏
        UIView *verline = [[UIView alloc]init];
        verline.backgroundColor = SEPERATELINECOLOR;
        [self addSubview:verline];
        verline.sd_layout
        .rightSpaceToView(_filterButton,0)
        .topEqualToView(self)
        .bottomEqualToView(self)
        .widthIs(0.5);
        
        //标签按钮
        _tagsButton = ({
            UIControl *_ = [[UIControl alloc]init];
            [self addSubview:_];
            _.sd_layout
            .rightEqualToView(verline)
            .topEqualToView(self)
            .bottomEqualToView(self)
            .widthIs(self.height_sd*2);
            
            UILabel *label = [[UILabel alloc]init];
            label.userInteractionEnabled = YES;
            [_ addSubview:label];
            label.textColor = TITLECOLOR;
            label.text = @"标签";
            label.font = [UIFont systemFontOfSize:15*ScrenScale];
            label.sd_layout
            .rightSpaceToView(_,15)
            .centerYEqualToView(_)
            .autoHeightRatio(0);
            [label setSingleLineAutoResizeWithMaxWidth:100];
            
            UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"标签"]];
            image.userInteractionEnabled = YES;
            [_ addSubview:image];
            image.sd_layout
            .rightSpaceToView(label,0)
            .topEqualToView(label)
            .bottomEqualToView(label)
            .widthEqualToHeight();
            
            _;
            
        });

        
        
        
        
        
        UIView *line = [[UIView alloc]init];
            [self addSubview:line];
            line.backgroundColor = SEPERATELINECOLOR;
            line.sd_layout
            .leftEqualToView(self)
            .rightEqualToView(self)
            .bottomEqualToView(self)
            .heightIs(0.5);
        
    }
    return self;

}

@end
