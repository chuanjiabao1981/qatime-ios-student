//
//  TagsFilterView.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "TagsFilterView.h"

@implementation TagsFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(self.width_sd/2-30, (self.width_sd/2-30)*0.2);
        _tagsCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width_sd, self.height_sd) collectionViewLayout:layout];
        _tagsCollection.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tagsCollection];
        
        
    }
    return self;
}
@end
