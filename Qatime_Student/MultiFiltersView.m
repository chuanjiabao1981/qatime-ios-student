//
//  MultiFiltersView.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MultiFiltersView.h"

@implementation MultiFiltersView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(self.width_sd/4-20, (self.width_sd/4-20)/3);
        
        _filtersCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width_sd, self.height_sd) collectionViewLayout:layout];
        _filtersCollection.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_filtersCollection];
        
    }
    return self;
}

@end
