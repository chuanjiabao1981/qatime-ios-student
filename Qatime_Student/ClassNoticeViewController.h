//
//  ClassNoticeViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/10/23.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTableViewCell.h"

@interface ClassNoticeViewController : UIViewController

@property (nonatomic, strong) UITableView *noticeList ;

-(instancetype)initWithClassID:(NSString *)classID;

@end
