//
//  SettingTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell

/* 菜单名*/
@property(nonatomic,strong) UILabel *settingName ;

/* 箭头图*/
@property(nonatomic,strong) UIImageView *arrow ;

/* 价格*/
@property(nonatomic,strong) UILabel *balance ;

/* logo图*/
@property(nonatomic,strong) UIImageView *logoImage ;

@end
