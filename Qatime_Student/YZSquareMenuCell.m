//
//  YZSquareMenuCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "YZSquareMenuCell.h"

@implementation YZSquareMenuCell
    
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _iconImage = [[UIImageView alloc]init];
        _iconTitle = [[UILabel alloc]init];
        
        [self.contentView addSubview:_iconImage];
        [self.contentView addSubview:_iconTitle];
        
        [_iconImage setFrame:CGRectMake(self.frame.size.width/4/2,0,self.frame.size.width*3/4,self.frame.size.width*3/4)];
        [_iconTitle setFrame:CGRectMake(0, self.frame.size.width*3/4, self.frame.size.width, self.frame.size.width/4)];
        [_iconTitle setTextColor:[UIColor blackColor]];
        [_iconTitle setFont:[UIFont systemFontOfSize:14]];
        _iconTitle.textAlignment = NSTextAlignmentCenter;
        
        
        
        _teacherID =[NSString string];
        
        
    }
    return self;
}
    


    
    
    
@end


//
//@property(nonatomic,strong) UIImageView *iconImage ;
//@property(nonatomic,strong) UILabel *iconTitle ;




