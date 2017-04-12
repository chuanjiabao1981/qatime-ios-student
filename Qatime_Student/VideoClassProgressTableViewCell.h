//
//  VideoClassProgressTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoClassInfo.h"

@interface VideoClassProgressTableViewCell : UITableViewCell
/**序号*/
@property (nonatomic, strong) UILabel *numbers ;

/**课程名*/
@property (nonatomic, strong) UILabel *className ;

/**时长*/
@property (nonatomic, strong) UILabel *duringTime ;

/**观看状态*/
@property (nonatomic, strong) UILabel *status ;

/**model*/
@property (nonatomic, strong) VideoClassInfo *model ;

@end
