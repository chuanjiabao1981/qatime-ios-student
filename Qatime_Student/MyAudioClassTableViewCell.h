//
//  MyAudioClassTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAudioClass.h"

@interface MyAudioClassTableViewCell : UITableViewCell

@property (nonatomic, strong) MyAudioClass *model ;
/**课程状态*/
@property (nonatomic, strong) UILabel *status ;


@end
