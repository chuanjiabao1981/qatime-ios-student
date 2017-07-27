//
//  ExclusivePlayerInfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExclusivePlayerInfoView.h"

@interface ExclusivePlayerInfoViewController : UIViewController

@property (nonatomic, strong) ExclusivePlayerInfoView *headView ;
@property (nonatomic, strong) UITableView *mainView ;

-(instancetype)initWithClassID:(NSString *)classID;

@end
