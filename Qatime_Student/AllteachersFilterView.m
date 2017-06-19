//
//  AllteachersFilterView.m
//  Qatime_Student
//
//  Created by Shin on 2017/6/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "AllteachersFilterView.h"

@interface AllteachersFilterView (){
    
    UIView *_verLine;
}

@end

@implementation AllteachersFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _allBtnsArr = @[].mutableCopy;
        //全部按钮
        _allTeachersBtn  = [[UIButton alloc]init];
        [self addSubview: _allTeachersBtn];
        [_allTeachersBtn setTitle:@"全部" forState:UIControlStateNormal];
        _allTeachersBtn.sd_layout
        .leftSpaceToView(self, 10*ScrenScale)
        .topSpaceToView(self, 0)
        .bottomSpaceToView(self, 0)
        .widthIs(30);
        [_allTeachersBtn setupAutoSizeWithHorizontalPadding:10*ScrenScale buttonHeight:40*ScrenScale];
        [_allBtnsArr addObject:_allTeachersBtn];
        
        //高中按钮
        _highSchoolBtn  = [[UIButton alloc]init];
        [self addSubview: _highSchoolBtn];
        [_highSchoolBtn setTitle:@"高中" forState:UIControlStateNormal];
        [_highSchoolBtn setTitleColor:TITLECOLOR forState:UIControlStateNormal];
        _highSchoolBtn.sd_layout
        .leftSpaceToView(_allTeachersBtn, 10*ScrenScale)
        .topSpaceToView(self, 0)
        .bottomSpaceToView(self, 0)
        .widthIs(30);
        [_highSchoolBtn setupAutoSizeWithHorizontalPadding:10*ScrenScale buttonHeight:40*ScrenScale];
        [_allBtnsArr addObject:_highSchoolBtn];
        
        //初中按钮
        _middleSchoolBtn  = [[UIButton alloc]init];
        [self addSubview: _middleSchoolBtn];
        [_middleSchoolBtn setTitle:@"初中" forState:UIControlStateNormal];
        _middleSchoolBtn.sd_layout
        .leftSpaceToView(_highSchoolBtn, 10*ScrenScale)
        .topSpaceToView(self, 0)
        .bottomSpaceToView(self, 0)
        .widthIs(30);
        [_middleSchoolBtn setupAutoSizeWithHorizontalPadding:10*ScrenScale buttonHeight:40*ScrenScale];
        [_allBtnsArr addObject:_middleSchoolBtn];
        
        
        //小学按钮
        _primarySchoolBtn  = [[UIButton alloc]init];
        [self addSubview: _primarySchoolBtn];
        [_primarySchoolBtn setTitle:@"小学" forState:UIControlStateNormal];
        _primarySchoolBtn.sd_layout
        .leftSpaceToView(_middleSchoolBtn, 10*ScrenScale)
        .topSpaceToView(self, 0)
        .bottomSpaceToView(self, 0)
        .widthIs(30);
        [_primarySchoolBtn setupAutoSizeWithHorizontalPadding:10*ScrenScale buttonHeight:40*ScrenScale];
        [_allBtnsArr addObject:_primarySchoolBtn];
        
        
        for (UIButton *btn in _allBtnsArr) {
            
            btn.titleLabel.font = TEXT_FONTSIZE;
            [btn setTitleColor:TITLECOLOR forState:UIControlStateNormal];
            [btn setEnlargeEdge:10];
            
        }
        
        
        //科目筛选按钮
        _subjectBtn = ({
            UIControl *_ = [[UIControl alloc]init];
            [self addSubview:_];
            _.sd_layout
            .rightSpaceToView(self, 0)
            .topSpaceToView(self, 0)
            .bottomSpaceToView(self, 0)
            .widthIs(60);
            
            _subjectLabel = [[UILabel alloc]init];
            _subjectLabel.userInteractionEnabled = NO;
            [_ addSubview:_subjectLabel];
            _subjectLabel.textColor = TITLECOLOR;
            _subjectLabel.text = @"全科";
            _subjectLabel.font = [UIFont systemFontOfSize:15*ScrenScale];
            _subjectLabel.sd_layout
            .rightSpaceToView(_,15*ScrenScale)
            .centerYEqualToView(_)
            .autoHeightRatio(0);
            [_subjectLabel setSingleLineAutoResizeWithMaxWidth:100];
            
            UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"筛选"]];
            image.userInteractionEnabled = NO;
            [_ addSubview:image];
            image.sd_layout
            .rightSpaceToView(_subjectLabel,5)
            .topEqualToView(_subjectLabel)
            .bottomEqualToView(_subjectLabel)
            .widthEqualToHeight();
            
            //竖边栏
            _verLine = [[UIView alloc]init];
            _verLine.backgroundColor = SEPERATELINECOLOR_2;
            [_ addSubview:_verLine];
            _verLine.sd_layout
            .rightSpaceToView(image, 10*ScrenScale)
            .topEqualToView(_)
            .bottomEqualToView(_)
            .widthIs(0.5);
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
