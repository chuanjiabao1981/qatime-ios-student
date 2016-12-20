//
//  ChatListTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/17.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13BadgeView.h"
#import "ChatList.h"

@interface ChatListTableViewCell : UITableViewCell

/* 辅导班名字*/
@property(nonatomic,strong) UILabel *className ;

/* 新消息数量*/
@property(nonatomic,strong) M13BadgeView *badge ;

/* 辅导班model*/
@property(nonatomic,strong) ChatList *model ;



@end
