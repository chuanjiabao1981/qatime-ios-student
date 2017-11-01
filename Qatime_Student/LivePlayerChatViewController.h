//
//  LivePlayerChatViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/10/23.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUInputFunctionView.h"


typedef void(^SendBarrages)(NSString *barrageString);

@interface LivePlayerChatViewController : UIViewController
/**聊天视图*/
@property(nonatomic,strong) UITableView *chatTableView ;

@property(nonatomic,strong) UUInputFunctionView *inputView ;

@property (nonatomic, copy) SendBarrages sendBarrage ;

-(instancetype)initWithChatTeamID:(NSString *)chatTeamID andClassID:(NSString *)classID;
@end
