//
//  DoHomeworkView.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/13.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "DoHomeworkView.h"
#import "UITextView+Placeholder.h"

@implementation DoHomeworkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _answers = [[UITextView alloc]init];
        [self addSubview:_answers];
        _answers.sd_layout
        .leftSpaceToView(self, 10*ScrenScale)
        .rightSpaceToView(self, 10*ScrenScale)
        .topSpaceToView(self, 10*ScrenScale)
        .heightIs(220*ScrenScale);
        
        _answers.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        _answers.layer.borderWidth = 0.5;
        _answers.placeholderLabel.font = TEXT_FONTSIZE;
        _answers.placeholder = @"请输入作答内容";
        
        
    }
    return self;
}

@end
