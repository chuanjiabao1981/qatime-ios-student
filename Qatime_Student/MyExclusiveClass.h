//
//  MyExclusiveClass.h
//  Qatime_Student
//
//  Created by Shin on 2017/7/28.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExclusiveInfo.h"

@interface MyExclusiveClass : NSObject

@property (nonatomic, strong) NSString *classID ;
@property (nonatomic, strong) NSString *used_count ;
@property (nonatomic, strong) NSString *buy_count ;
@property (nonatomic, strong) NSString *lesson_price ;
@property (nonatomic, strong) NSString *status ;
@property (nonatomic, strong) NSString *type ;
@property (nonatomic, strong) ExclusiveInfo *customized_group ;

@end
