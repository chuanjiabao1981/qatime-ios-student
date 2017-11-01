//
//  ShareView.h
//  Qatime_Student
//
//  Created by Shin on 2017/10/30.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView

@property (nonatomic, strong) UILabel *shareLabel ;

@property (nonatomic, strong) UIButton *wechatBtn ;

+ (instancetype)sharedView;


@end
