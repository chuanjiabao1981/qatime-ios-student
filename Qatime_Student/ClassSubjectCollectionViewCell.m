//
//  ClassSubjectCollectionViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ClassSubjectCollectionViewCell.h"

@implementation ClassSubjectCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        _subject = ({
            UILabel *_ = [[UILabel alloc]initWithFrame:self.contentView.frame];
            [self.contentView addSubview:_];
            _.textAlignment = NSTextAlignmentCenter;
            _.textColor = TITLECOLOR;
            _.layer.borderWidth = 1;
            _.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
            _;
        
        });
        
    }
    return self;
    
}

@end
