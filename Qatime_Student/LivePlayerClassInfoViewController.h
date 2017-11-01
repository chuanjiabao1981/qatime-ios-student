//
//  LivePlayerClassInfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/10/23.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoHeaderView.h"


@interface LivePlayerClassInfoViewController : UIViewController

@property (nonatomic, strong) InfoHeaderView *headerView ;

@property (nonatomic, strong) UITableView *classList ;

-(instancetype)initWithClassID:(NSString *)classID;

@end
