//
//  VideoClassInfo_InfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoClassInfo_InfoView.h"

@interface VideoClassInfo_InfoViewController : UIViewController
@property (nonatomic, strong) VideoClassInfo_InfoView *mainView ;

-(instancetype)initWithClassInfo:(VideoClassInfo *)classInfo;
@end
