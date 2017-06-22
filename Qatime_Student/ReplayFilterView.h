//
//  ReplayFilterView.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/21.
//  Copyright © 2017年 WWTD. All rights reserved.
//  筛选栏

#import <UIKit/UIKit.h>

@interface ReplayFilterView : UIView

/**最新*/
@property (nonatomic, strong) UIButton *newestBtn ;
/**最新箭头*/
@property (nonatomic, strong) UIImageView *newestArrow ;


/**最多人看*/
@property (nonatomic, strong) UIButton *popularityBtn ;
/**最新箭头*/
@property (nonatomic, strong) UIImageView *popularityArrow ;

@end
