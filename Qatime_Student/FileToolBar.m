//
//  FileToolBar.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/19.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "FileToolBar.h"

@implementation FileToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _selectAllBtn = [[UIButton alloc]init];
        [self addSubview: _selectAllBtn];
        _selectAllBtn.sd_layout
        .topSpaceToView(self, 0)
        .bottomSpaceToView(self, 0)
        .leftSpaceToView(self, 0)
        .widthRatioToView(self, 0.5);
        [_selectAllBtn setTitleColor:BUTTONRED forState:UIControlStateNormal];
        [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        _selectAllBtn.layer.borderWidth = 0.5;
        _selectAllBtn.layer.borderColor = BUTTONRED.CGColor;
        _selectAllBtn.titleLabel.font = TEXT_FONTSIZE;
        
        _deletBtn = [[UIButton alloc]init];
        [self addSubview: _deletBtn];
        _deletBtn.sd_layout
        .topSpaceToView(self, 0)
        .bottomSpaceToView(self, 0)
        .leftSpaceToView(_selectAllBtn, 0)
        .rightSpaceToView(self, 0);
        [_deletBtn setTitleColor:BUTTONRED forState:UIControlStateNormal];
         [_deletBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deletBtn.layer.borderWidth = 0.5;
        _deletBtn.layer.borderColor = BUTTONRED.CGColor;
        _deletBtn.titleLabel.font = TEXT_FONTSIZE;
        
    }
    return self;
}

@end
