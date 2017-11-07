//
//  AboutUsViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/30.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutUsView.h"
#import "AboutUsHead.h"
#import "AboutUsFoot.h"
@interface AboutUsViewController : UIViewController

@property(nonatomic,strong) AboutUsView *aboutUsView ;

@property (nonatomic, strong) AboutUsHead *headView ;

@property (nonatomic, strong) AboutUsFoot *footView ;

@end
