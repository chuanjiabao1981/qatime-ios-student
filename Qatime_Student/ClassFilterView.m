//
//  ClassFilterView.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ClassFilterView.h"
#import "UIButton+EnlargeTouchArea.h"

@interface ClassFilterView (){
    /**竖边栏*/
    UIView *_verline;
    /**竖边栏2*/
    UIView *_varLine;
    
    /**免费课筛选label*/
    UILabel *_freeLabel;
    
    /**标签图片*/
    UIImageView *_tagImage;
    /**分割线*/
    UIView *_line;
}

@end
@implementation ClassFilterView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {


        //最新按钮
        _newestButton = ({
            UIButton *_ = [[UIButton alloc]init];
            [self addSubview:_];
            [_ setTitle:@"最新" forState:UIControlStateNormal];
            [_ setTitleColor:SEPERATELINECOLOR_2 forState:UIControlStateNormal];
            _.titleLabel.textColor = TITLECOLOR;
            _.titleLabel.font = [UIFont systemFontOfSize:15*ScrenScale];
            _.sd_layout
            .leftSpaceToView(self,15*ScrenScale)
            .topEqualToView(self)
            .bottomEqualToView(self)
            .widthEqualToHeight();
            
            [_ setEnlargeEdge:10];
            
            _;
        });
        //最新 筛选箭头
        _newestArrow = ({
            UIImageView *_=[[UIImageView alloc]init];
            [self addSubview:_];
            _.sd_layout
            .centerYEqualToView(_newestButton)
            .leftSpaceToView(_newestButton,0)
            .heightRatioToView(_newestButton,0.3)
            .widthIs(5);
            _;
        });
        
        
        //价格按钮
        _priceButton= ({
            UIButton *_ = [[UIButton alloc]init];
            [self addSubview:_];
            [_ setTitle:@"价格" forState:UIControlStateNormal];
            [_ setTitleColor:SEPERATELINECOLOR_2 forState:UIControlStateNormal];
            _.titleLabel.textColor = TITLECOLOR;
            _.titleLabel.font = [UIFont systemFontOfSize:15*ScrenScale];
            _.sd_layout
            .leftSpaceToView(_newestButton,20*ScrenScale)
            .topEqualToView(_newestButton)
            .bottomEqualToView(_newestButton)
            .widthEqualToHeight();
            
            _;
        });
        
        //价格 筛选箭头
        _priceArrow = ({
            UIImageView *_=[[UIImageView alloc]init];
            [self addSubview:_];
            _.sd_layout
            .centerYEqualToView(_priceButton)
            .leftSpaceToView(_priceButton,0)
            .heightRatioToView(_priceButton,0.3)
            .widthIs(5);
            _;
        });

        
        //人气按钮
        _popularityButton = ({
            UIButton *_ = [[UIButton alloc]init];
            [self addSubview:_];
            [_ setTitle:@"人气" forState:UIControlStateNormal];
            [_ setTitleColor:SEPERATELINECOLOR_2 forState:UIControlStateNormal];
            _.titleLabel.textColor = TITLECOLOR;
            _.titleLabel.font = [UIFont systemFontOfSize:15*ScrenScale];
            _.sd_layout
            .leftSpaceToView(_priceButton,20*ScrenScale)
            .topEqualToView(_priceButton)
            .bottomEqualToView(_priceButton)
            .widthEqualToHeight();
            
            [_ setEnlargeEdge:10];
            
            _;
        });
        
        //人气 筛选箭头
        _popularityArrow = ({
            UIImageView *_=[[UIImageView alloc]init];
            [self addSubview:_];
            _.sd_layout
            .centerYEqualToView(_popularityButton)
            .leftSpaceToView(_popularityButton,0)
            .heightRatioToView(_popularityButton,0.3)
            .widthIs(5);
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
            .widthIs(self.height_sd*2*ScrenScale);
            
            UILabel *label = [[UILabel alloc]init];
            label.userInteractionEnabled = NO;
            [_ addSubview:label];
            label.textColor = TITLECOLOR;
            label.text = @"筛选";
            label.font = [UIFont systemFontOfSize:15*ScrenScale];
            label.sd_layout
            .rightSpaceToView(_,15*ScrenScale)
            .centerYEqualToView(_)
            .autoHeightRatio(0);
            [label setSingleLineAutoResizeWithMaxWidth:100];
            
            UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"筛选"]];
            image.userInteractionEnabled = NO;
            [_ addSubview:image];
            image.sd_layout
            .rightSpaceToView(label,0)
            .topEqualToView(label)
            .bottomEqualToView(label)
            .widthEqualToHeight();
            
            
            //竖边栏
            _verline = [[UIView alloc]init];
            _verline.backgroundColor = SEPERATELINECOLOR_2;
            [self addSubview:_verline];
            _verline.sd_layout
            .rightSpaceToView(_filterButton,0)
            .topEqualToView(self)
            .bottomEqualToView(self)
            .widthIs(0.5);
            
            _;
        
        });
        
        
        //竖边栏
        _verline = [[UIView alloc]init];
        _verline.backgroundColor = SEPERATELINECOLOR_2;
        [self addSubview:_verline];
        _verline.sd_layout
        .rightSpaceToView(_filterButton,0)
        .topEqualToView(self)
        .bottomEqualToView(self)
        .widthIs(0.5);
        
        
        //免费课程筛选按钮
//        _freeClassButton = ({
        
//            UIControl *_ = [[UIControl alloc]init];
//            [self addSubview:_];
//            _.sd_layout
//            .rightEqualToView(self)
//            .topEqualToView(self)
//            .bottomEqualToView(self)
//            .widthIs(self.width_sd*3*ScrenScale);
//            
//            UILabel *label = [[UILabel alloc]init];
//            label.userInteractionEnabled = NO;
//            [_ addSubview:label];
//            label.textColor = TITLECOLOR;
//            label.text = @"免费课程";
//            label.font = [UIFont systemFontOfSize:15*ScrenScale];
//            label.sd_layout
//            .rightSpaceToView(_,15*ScrenScale)
//            .centerYEqualToView(_)
//            .autoHeightRatio(0);
//            [label setSingleLineAutoResizeWithMaxWidth:100];
//            
//            BEMCheckBox *box = [[BEMCheckBox alloc]init];
//            [_ addSubview:box];
//            box.sd_layout
//            .rightSpaceToView(label,0)
//            .topEqualToView(label)
//            .bottomEqualToView(label)
//            .widthEqualToHeight();
//            box.boxType =BEMBoxTypeSquare;
//            box.onAnimationType = BEMAnimationTypeFill;
//            box.offAnimationType = BEMAnimationTypeFill;
//            
//            UIView *varLine = [[UIView alloc]init];
//            varLine.backgroundColor = SEPERATELINECOLOR_2;
//            [_ addSubview:varLine];
//            varLine.sd_layout
//            .leftSpaceToView(_, 0)
//            .topEqualToView(self)
//            .bottomEqualToView(self)
//            .widthIs(0.5);
//            
//            _;
//
//        
//        });
        
        
        //免费提示label
        _freeLabel = [[UILabel alloc]init];
        _freeLabel.userInteractionEnabled = NO;
        [self addSubview:_freeLabel];
        _freeLabel.textColor = TITLECOLOR;
        _freeLabel.text = @"免费课程";
        _freeLabel.font = [UIFont systemFontOfSize:15*ScrenScale];
        _freeLabel.sd_layout
        .rightSpaceToView(self,15*ScrenScale)
        .centerYEqualToView(self)
        .autoHeightRatio(0);
        [_freeLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        //box按钮
        _freeButton = [[BEMCheckBox alloc]init];
        [self addSubview:_freeButton];
        _freeButton.sd_layout
        .rightSpaceToView(_freeLabel,10)
        .topEqualToView(_freeLabel)
        .bottomEqualToView(_freeLabel)
        .widthEqualToHeight();
        
        _freeButton.boxType =BEMBoxTypeSquare;
        _freeButton.onAnimationType = BEMAnimationTypeFill;
        _freeButton.offAnimationType = BEMAnimationTypeFill;
        _freeButton.onTintColor = NAVIGATIONRED;
        _freeButton.lineWidth = 1;
        _freeButton.onFillColor = NAVIGATIONRED;
        _freeButton.offFillColor = [UIColor clearColor];
        _freeButton.onCheckColor = [UIColor whiteColor];

        
        _varLine = [[UIView alloc]init];
        _varLine.backgroundColor = SEPERATELINECOLOR_2;
        [self addSubview:_varLine];
        _varLine.sd_layout
        .rightSpaceToView(_freeButton, 15)
        .topEqualToView(self)
        .bottomEqualToView(self)
        .widthIs(0.5);


        //标签按钮
        _tagsButton = ({
            UIButton *_ = [[UIButton alloc]init];
            [_ setTitle:@"标签" forState:UIControlStateNormal];
            [_ setTitleColor:TITLECOLOR forState:UIControlStateNormal];
            _.titleLabel.font = [UIFont systemFontOfSize:15*ScrenScale];
            [self addSubview:_];
            _.sd_layout
            .rightEqualToView(_verline)
            .topEqualToView(self)
            .bottomEqualToView(self);
            [_ setupAutoSizeWithHorizontalPadding:10 buttonHeight:self.height_sd];
            
            _;
            
        });
        _tagImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"标签"]];
        [self addSubview: _tagImage];
        _tagImage.sd_layout
        .rightSpaceToView(_tagsButton,0)
        .centerYEqualToView(_tagsButton)
        .heightRatioToView(_tagsButton,0.5)
        .widthEqualToHeight();
        
        _line = [[UIView alloc]init];
            [self addSubview:_line];
            _line.backgroundColor = SEPERATELINECOLOR_2;
            _line.sd_layout
            .leftEqualToView(self)
            .rightEqualToView(self)
            .bottomEqualToView(self)
            .heightIs(0.5);
        
    }
    return self;

}

- (void)setMode:(FilterViewShowsMode)mode{
    
    _mode = mode;
    
    switch (mode) {
        case LiveClassMode:{
            _popularityArrow.hidden = NO;
            _popularityButton.hidden = NO;
            _tagImage.hidden = NO;
            _tagsButton.hidden = NO;
            _filterButton.hidden =NO;
            _verline.hidden = NO;
            
            _freeLabel.hidden = YES;
            _freeButton.hidden = YES;
            _varLine.hidden = YES;
            
            
        }
            break;
            
        case InteractionMode:{
            
            _popularityArrow.hidden = YES;
            _popularityButton.hidden = YES;
            _tagImage.hidden = YES;
            _tagsButton.hidden = YES;
            _filterButton.hidden =YES;
            _verline.hidden = YES;
        
            _freeLabel.hidden = YES;
            _freeButton.hidden = YES;
            _varLine.hidden = YES;
            
        }
            break;
        case VideoMode:{
            _popularityArrow.hidden = YES;
            _popularityButton.hidden = YES;
            _tagImage.hidden = YES;
            _tagsButton.hidden = YES;
            _filterButton.hidden =YES;
            _verline.hidden = YES;
            
            _freeLabel.hidden = NO;
            _freeButton.hidden = NO;
            _varLine.hidden = NO;
            
            
        }
            break;
        case ExclusiveMode:{
            
            _popularityArrow.hidden = NO;
            _popularityButton.hidden = NO;
            _filterButton.hidden =NO;
            _verline.hidden = NO;
            
            _tagImage.hidden = YES;
            _tagsButton.hidden = YES;
            _freeLabel.hidden = YES;
            _freeButton.hidden = YES;
            _varLine.hidden = YES;
            
        }
            break;
    }
    
    
    
}

@end
