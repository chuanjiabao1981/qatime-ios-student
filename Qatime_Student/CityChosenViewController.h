//
//  CityChosenViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/6.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"


@interface CityChosenViewController : UIViewController


@property(nonatomic,strong) UITableView *cityTableView ;


//传进来数据 进行初始化
-(instancetype)initWithChosenProvince:(NSString *)province andDataArr:(NSArray <City *>*)dataArr;


@end
