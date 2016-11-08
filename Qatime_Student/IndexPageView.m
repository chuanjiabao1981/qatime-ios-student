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
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];

        _recommandClassCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:flowLayout];
        _recommandClassCollectionView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_recommandClassCollectionView];
        
        _recommandClassCollectionView.showsVerticalScrollIndicator = NO;
        
        
        
    }
    return self;
}

@end
