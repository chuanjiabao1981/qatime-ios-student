//
//  VideoClassFullListViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/18.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoClassFullScreenListTableViewCell.h"
@interface VideoClassFullListViewController : UIViewController

@property (nonatomic, strong) UITableView *classList ;


-(instancetype)initWithArray:(NSArray *)classArray;
@end
