//
//  ChatViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/19.
//  Copyright © 2016年 WWTD. All rights reserved.
//



#import <UIKit/UIKit.h>

#import "UUInputFunctionView.h"
#import "TutoriumList.h"




/* 聊天页面*/
@interface ChatViewController : UIViewController


/**
 聊天视图
 */
@property(nonatomic,strong) UITableView *chatTableView ;

@property(nonatomic,strong) UUInputFunctionView *inputView ;

-(instancetype)initWithClass:(TutoriumListInfo *)tutorium;



@end
