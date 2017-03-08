//
//  IndexPageView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "IndexPageView.h"

@implementation IndexPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 课程视频列表collection*/
        _recommandClassCollectionView = ({
         UICollectionView *_ = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width_sd, self.height_sd) collectionViewLayout:[UICollectionViewFlowLayout new]];
            _.backgroundColor = [UIColor whiteColor];
            _.showsVerticalScrollIndicator = NO;
            [self addSubview:_];
           
            _;
        });
        
        
    }
    return self;
}

@end
