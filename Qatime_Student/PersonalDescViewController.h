//
//  PersonalDescViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/6.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTextView.h"
#import "ChangeDescDelegate.h"




@interface PersonalDescViewController : UIViewController

@property(nonatomic,strong) YYTextView *textView ;

@property(nonatomic,weak) id <ChangeDescDelegate> delegate ;

@end
