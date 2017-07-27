//
//  ExclusiveMembersViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExclusiveMembersViewController : UIViewController

@property (nonatomic, strong) UITableView  *membersTableView ;

-(instancetype)initWithClassID:(NSString *)classID;

@end
