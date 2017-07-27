//
//  ExclusiveChatViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UUInputFunctionView.h"
@interface ExclusiveChatViewController : UIViewController
/**聊天视图*/
@property(nonatomic,strong) UITableView *chatTableView ;

@property(nonatomic,strong) UUInputFunctionView *inputView ;

-(instancetype)initWithChatTeamID:(NSString *)chatTeamID andClassID:(NSString *)classID;

@end
