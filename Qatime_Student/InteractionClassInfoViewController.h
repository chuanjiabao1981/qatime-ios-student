//
//  InteractionClassInfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/1.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractionInfoHeadView.h"

@interface InteractionClassInfoViewController : UIViewController

@property (nonatomic, strong) InteractionInfoHeadView *headView ;
@property (nonatomic, strong) UITableView *mainView ;

-(instancetype)initWithClassID:(NSString *)classID;

@end
