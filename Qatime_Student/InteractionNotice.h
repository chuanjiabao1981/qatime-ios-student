//
//  InteractionNotice.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/8.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InteractionNotice : NSObject
//"content": "123",
//"lastest": true,
//"announcement": "123",
//"edit_at": "2017-04-08 15:05:56 ",
//"created_at": "2017-04-08 15:05:56 "

@property (nonatomic, strong) NSString *content ;
@property (nonatomic, assign) BOOL lastest ;
@property (nonatomic, strong) NSString *announcement ;
@property (nonatomic, strong) NSString *edit_at ;
@property (nonatomic, strong) NSString *created_at ;


@end
