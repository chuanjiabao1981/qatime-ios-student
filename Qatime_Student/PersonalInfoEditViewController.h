//
//  PersonalInfoEditViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/1/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditHeadTableViewCell.h"
#import "EditNameTableViewCell.h"
#import "EditGenderTableViewCell.h"
#import "EditBirthdayTableViewCell.h"

@interface PersonalInfoEditViewController : UIViewController

/* 列表*/
@property(nonatomic,strong) UITableView *editTableView ;


/* 完成按钮*/
@property(nonatomic,strong) UIButton *finishButton ;

-(instancetype)initWithInfo:(NSDictionary *)info ;

@end
