//
//  MyHomewoekTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/11.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkManage.h"

@interface MyHomewoekTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *title ;

@property (nonatomic, strong) UILabel *created_at ;

@property (nonatomic, strong) UILabel *aboutClass ;

//@property (nonatomic, strong) UILabel *status ;

@property (nonatomic, strong) HomeworkManage *model ;

@end
