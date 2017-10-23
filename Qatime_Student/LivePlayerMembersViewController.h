//
//  LivePlayerMembersViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/10/23.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LivePlayerMembersViewController : UIViewController

@property (nonatomic, strong) UITableView *memeberList ;

-(instancetype)initWithClassID:(NSString *)classID;

@end
