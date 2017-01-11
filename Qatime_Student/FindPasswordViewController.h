//
//  FindPasswordViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "FindPasswordView.h"

@interface FindPasswordViewController : UIViewController

@property(nonatomic,strong) NavigationBar  *navigationBar ;

@property(nonatomic,strong) FindPasswordView  *findPasswordView ;


-(instancetype)initWithFindPassword;

@end
