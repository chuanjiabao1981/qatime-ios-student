//
//  VideoClassFullScreenListTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/18.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoClass.h"

@interface VideoClassFullScreenListTableViewCell : UITableViewCell

/**序号*/
@property (nonatomic, strong) UILabel *numbers ;

/**课程名*/
@property (nonatomic, strong) UILabel *className ;

/**model*/
@property (nonatomic, strong) VideoClass *model ;

@end
