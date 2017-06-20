//
//  AboutUsView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/30.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YYLabel.h"

@interface AboutUsView : UIScrollView

@property(nonatomic,strong) UIImageView *logo ;

@property(nonatomic,strong) UILabel *aboutUs ;

@property(nonatomic,strong) UITableView *menuTableView ;

@property (nonatomic, strong) UILabel *versionLabel ;

@end
