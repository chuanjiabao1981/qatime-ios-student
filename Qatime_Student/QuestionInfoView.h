//
//  QuestionInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/27.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Qatime_Student-Swift.h"
#import "YZReorder.h"
#import "Questions.h"

@interface QuestionInfoView : UIView

@property (nonatomic, strong) QuestionSubTitle *subTitle ;

@property (nonatomic, strong) UILabel *questionContent ;
@property (nonatomic, strong) UICollectionView *photosView ;
@property (nonatomic, strong) YZReorder *recorder ;

@property (nonatomic, strong) Questions *model ;
@end
