//
//  YZSquareMenuCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommandTeacher.h"

@interface YZSquareMenuCell : UICollectionViewCell
    
@property(nonatomic,strong) UIImageView *iconImage ;
@property(nonatomic,strong) UILabel *iconTitle ;
@property(nonatomic,assign) NSInteger *lines ;



/* 附加属性*/
@property(nonatomic,strong) NSString *teacherID ;


@end
