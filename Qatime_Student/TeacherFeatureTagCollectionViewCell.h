//
//  TeacherFeatureTagCollectionViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/19.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherFeatureTagCollectionViewCell : UICollectionViewCell

/**对勾符号*/
@property (nonatomic, strong) UIImageView *featureImage ;
/**特色内容*/
@property (nonatomic, strong) UILabel *features ;
/**更新某些视图的布局*/
- (void)updateLayoutSubviews;

@end
