//
//  TranslateViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/2/20.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMSDK.h"

@interface TranslateViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIButton *cancelBtn;

@property (nonatomic,strong) IBOutlet UIView *errorTipView;

@property (nonatomic,copy)   void (^completeHandler)(void)  ;

- (instancetype)initWithMessage:(NIMMessage *)message;


@end
