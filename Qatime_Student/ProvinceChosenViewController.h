//
//  ProvinceChosenViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/6.
//  Copyright © 2017年 WWTD. All rights reserved.
//

//省份选择页

#import <UIKit/UIKit.h>
#import "ProvinceHeaderView.h"
#import "CityChosenViewController.h"
@interface ProvinceChosenViewController : UIViewController

@property(nonatomic,strong) UITableView *provinceTableView ;

@property(nonatomic,strong) ProvinceHeaderView *provinceHeader ;

@property(nonatomic,strong) CityChosenViewController *controller ;


@end
