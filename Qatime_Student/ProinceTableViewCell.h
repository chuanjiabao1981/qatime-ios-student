//
//  ProinceTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/6.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Province.h"
#import "City.h"
@interface ProinceTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *title ;

@property(nonatomic,strong) Province *model ;

@property(nonatomic,strong) City *cityModel ;

@end
