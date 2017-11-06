//
//  ShareViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/10/30.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareView.h"
#import "SnailQuickMaskPopups.h"

@interface ShareViewController : UIViewController

@property (nonatomic, strong) ShareView *sharedView ;


/**
 分享方法

 @param sharedDic 传进来的参数
 */
- (void)sharedWithContentDic:(NSDictionary *)sharedDic;

@end
