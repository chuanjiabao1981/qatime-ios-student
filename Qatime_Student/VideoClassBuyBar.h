//
//  VideoClassBuyBar.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/13.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoClassBuyBarDelegate <NSObject>

/**左边试听按钮*/
- (void)enterTaste:(UIButton *)sender;
/**右边学习按钮*/
- (void)enterStudy:(UIButton *)sender;

@end

@interface VideoClassBuyBar : UIView

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton ;

@property (nonatomic, weak) id <VideoClassBuyBarDelegate> delegate ;

@end
