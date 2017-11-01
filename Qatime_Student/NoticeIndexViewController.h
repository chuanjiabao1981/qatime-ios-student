//
//  NoticeIndexViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/16.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "NoticeIndexView.h"
#import <NIMSDK/NIMSDK.h>
#import "NoticeListViewController.h"
#import "ChatListViewController.h"


@interface NoticeIndexViewController : UIViewController

@property(nonatomic,strong) NoticeIndexView *noticeIndexView ;

@property (nonatomic, strong) ChatListViewController *chatList ;

@property (nonatomic, strong) NoticeListViewController *noticeList ;




@end
