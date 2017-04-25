//
//  ChargeCollectionViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ChargeCollectionViewCell.h"

@implementation ChargeCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _title = [[UILabel alloc]init];
        _title.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        _title.layer.borderWidth = 1;
        _title.textColor = TITLECOLOR;
        _title.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_title];
        _title.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0);
        
        
        
    }
    return self;
}

@end
