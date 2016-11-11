//
//  NoticeTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notice.h"

@interface NoticeTableViewCell : UITableViewCell

/* 喇叭图*/
@property(nonatomic,strong) UIImageView  *noticeImage ;

/* 日期*/
@property(nonatomic,strong) UILabel *edit_at ;

/* 时间*/
@property(nonatomic,strong) UILabel *time ;

/* 内容*/
@property(nonatomic,strong) UILabel *announcement ;



/* 公告状态*/
@property(nonatomic,strong) UILabel *status ;

/* notice model*/
@property(nonatomic,strong) Notice *model ;


@end
