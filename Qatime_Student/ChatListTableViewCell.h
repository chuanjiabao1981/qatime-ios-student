//
//  ChatListTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/17.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13BadgeView.h"
#import "WZLBadgeImport.h"
#import "ChatList.h"
#import "Qatime_Student-Swift.h"

@interface ChatListTableViewCell : UITableViewCell

/**辅导班图*/
@property (nonatomic, strong) UIImageView *image ;

/** 辅导班名字*/
@property(nonatomic,strong) UILabel *className ;

/**最后一条消息收到的时间*/
@property (nonatomic, strong) UILabel *lastTime;

/** 不接受推送的图标*/
@property(nonatomic,strong) UIImageView *closeNotice ;

@property(nonatomic,assign) BOOL noticeOn ;

/** 作为badge*/
@property(nonatomic,strong) UILabel *badge ;

@property(nonatomic,assign) NSInteger badgeNumber ;

/** 辅导班model*/
@property(nonatomic,strong) ChatList *model ;


@end
