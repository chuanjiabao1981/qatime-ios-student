//
//  InteractionMemberListViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/1.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractionMemberListViewController : UIViewController


@property (nonatomic, strong) UITableView  *membersTableView ;


-(instancetype)initWithClassID:(NSString *)classID;

@end
