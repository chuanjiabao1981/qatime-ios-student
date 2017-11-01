//
//  ChatListViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/10/30.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatList.h"
#import "ChatListTableViewCell.h"

typedef void(^Push)(UIViewController *controller);

typedef void(^UnreadCountPlus)(NSInteger unreadCount);

typedef void(^UnreadCountMinus)(NSInteger unreadCount);

@interface ChatListViewController : UIViewController

@property (nonatomic, strong) UITableView *mainView ;

@property (nonatomic, copy) Push pushBlock ;

@property (nonatomic, copy) UnreadCountPlus unreadChatMessageCountPlus ;

@property (nonatomic, copy) UnreadCountMinus unreadChatMessageCountMinus ;

@end
