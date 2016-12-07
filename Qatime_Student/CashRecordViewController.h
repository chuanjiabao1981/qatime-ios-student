//
//  CashRecordViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CashRecordView.h"

@interface CashRecordViewController : UIViewController


@property(nonatomic,strong) CashRecordView *cashRecordView ;

- (instancetype)initWithSelectedItem:(NSInteger)item ;


@end
