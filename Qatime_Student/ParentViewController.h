//
//  ParentViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentView.h"
#import "NavigationBar.h"
@interface ParentViewController : UIViewController

@property(nonatomic,strong) ParentView *parentView ;

/* 家长电话*/
@property(nonatomic,strong) NSString *parentPhone ;



- (instancetype)initWithPhone:(NSString *)phone;

@end
