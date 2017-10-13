//
//  QuestionPhotosCollectionViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/8/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13ProgressViewRing.h"

@interface QuestionPhotosCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *image ;

@property (nonatomic, strong) UIButton *deleteBtn ;

@property (nonatomic, strong) UIView *effectView ;

@property (nonatomic, strong) M13ProgressViewRing *progress ;

@property (nonatomic, strong) UIView *faildEffectView ;

@property (nonatomic, strong) UIButton *faidBtn ;

@end
