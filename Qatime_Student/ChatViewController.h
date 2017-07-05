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
#import "NavigationBar.h"


/* 聊天页面*/
@interface ChatViewController : UIViewController

@property (nonatomic, strong) NavigationBar *navigationBar;
/**
 聊天视图
 */
@property(nonatomic,strong) UITableView *chatTableView ;

@property(nonatomic,strong) UUInputFunctionView *inputView ;

@property (nonatomic, assign) CourseType classType ;

-(instancetype)initWithClass:(id)tutorium andClassType:(CourseType)type;

@end
