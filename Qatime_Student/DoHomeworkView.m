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
        
        self.titleLine.hidden = YES;
        self.questionLine.sd_layout
        .topSpaceToView(self, 20);
        [self.questions updateLayout];
        
    }
    return self;
}

@end
