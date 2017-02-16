//
//  UUProgressHUD.h
//  1111
//
//  Created by shake on 14-8-6.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUProgressHUD : UIView

//@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@property(nonatomic,strong) UIView *HUDView;

/**
 状态图片
 */

@property(nonatomic,strong) UIImageView *statusImageView ;


/**
 是否可以监听音量()
 */
@property(nonatomic,assign) BOOL canHearVolum ;




+ (void)show;

+ (void)dismissWithSuccess:(NSString *)str;

+ (void)dismissWithError:(NSString *)str;

+ (void)changeSubTitle:(NSString *)str;

@end
