//
//  PersonalTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/5.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

@interface PersonalTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel  *name ;

@property(nonatomic,strong) UILabel  *content;

@property(nonatomic,strong) UserInfoModel *model ;

@end
