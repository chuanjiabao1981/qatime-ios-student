//
//  WithDrawInfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithDrawInfoView.h"

@interface WithDrawInfoViewController : UIViewController

@property(nonatomic,strong) WithDrawInfoView *withDrawInfoView ;

-(instancetype)initWithAmount:(NSString *)money andPayType:(NSString *)payType andTicketToken:(NSString *)ticketToken ;

@end
