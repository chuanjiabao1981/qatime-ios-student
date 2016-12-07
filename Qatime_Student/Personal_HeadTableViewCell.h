//
//  Personal_HeadTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/5.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

@interface Personal_HeadTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *name ;
@property(nonatomic,strong) UIImageView *image ;

@property(nonatomic,strong) UserInfoModel *model ;

@end
