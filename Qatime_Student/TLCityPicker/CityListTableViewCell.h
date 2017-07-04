//
//  CityListTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/9.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLCity.h"

@interface CityListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *cityName ;

//特别添加一个city属性
@property (nonatomic, strong) TLCity *model ;


@end
