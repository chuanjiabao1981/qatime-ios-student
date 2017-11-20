//
//  PersonalViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalView.h"
#import "HeadBackView.h"

@interface PersonalViewController : UIViewController

@property(nonatomic,strong) PersonalView *personalView ;

@property(nonatomic,strong) HeadBackView *headView ;

//中间部分的菜单按钮
@property (nonatomic, strong) UICollectionView *menuCollection ;

@end
