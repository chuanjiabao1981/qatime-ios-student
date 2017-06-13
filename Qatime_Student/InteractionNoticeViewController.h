//
//  InteractionNoticeViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/1.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractionNoticeViewController : UIViewController

@property (nonatomic, strong) UITableView *noticeTableView ;



-(instancetype)initWithClassID:(NSString *)classID;

@end
