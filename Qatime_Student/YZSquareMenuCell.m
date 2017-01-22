//
//  YZSquareMenuCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "YZSquareMenuCell.h"
#import "UIImageView+WebCache.h"

@implementation YZSquareMenuCell
    
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _iconImage = [[UIImageView alloc]init];
        _iconTitle = [[UILabel alloc]init];
        
        [self.contentView addSubview:_iconImage];
        [self.contentView addSubview:_iconTitle];
        
        [_iconImage setFrame:CGRectMake(self.width_sd/4/2,0,self.width_sd*3/4,self.width_sd*3/4)];
        _iconImage.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        
        [_iconTitle setFrame:CGRectMake(0, self.width_sd*3/4, self.width_sd, self.width_sd/4)];
        [_iconTitle setTextColor:[UIColor blackColor]];
//        [_iconTitle setFont:[UIFont systemFontOfSize:14*ScrenScale]];
        _iconTitle.textAlignment = NSTextAlignmentCenter;
        _iconTitle.font = [UIFont systemFontOfSize:12];
        _iconTitle.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
        
        _teacherID =[NSString string];
        
        
    }
    return self;
}

   
    
@end






