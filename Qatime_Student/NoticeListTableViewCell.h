//
//  NoticeListTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/17.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notice.h"

@interface NoticeListTableViewCell : UITableViewCell

/* 时间*/
@property(nonatomic,strong) UILabel *time ;

/* 消息内容*/
@property(nonatomic,strong) UILabel *content ;


@end
