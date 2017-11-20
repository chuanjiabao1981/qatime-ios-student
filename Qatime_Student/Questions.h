//
//  Questions.h
//  Qatime_Student
//
//  Created by Shin on 2017/8/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Answers.h"
@interface Questions : NSObject
//测试数据
@property (nonatomic, strong) NSString *questionID ;
@property (nonatomic, strong) NSString *title ;
@property (nonatomic, strong) NSString *parent_id ;
@property (nonatomic, strong) NSString *status ;
@property (nonatomic, strong) NSString *user_id ;
@property (nonatomic, strong) NSString *user_name ;
@property (nonatomic, strong) NSString *course_id ;
@property (nonatomic, strong) NSString *course_name ;
@property (nonatomic, strong) NSString *course_model_name ;
@property (nonatomic, strong) NSString *created_at ;
@property (nonatomic, strong) NSString *model_name ;
@property (nonatomic, strong) NSString *body ;
@property (nonatomic, strong) Answers *answer ;

@property (nonatomic, strong) NSArray *attachments ;


//判断用的
@property (nonatomic, assign) BOOL haveBody ;
@property (nonatomic, assign) BOOL havePhotos ;
@property (nonatomic, assign) BOOL haveRecord ;



//"id": 95,
//"title": "hello",
//"parent_id": null,
//"status": "pending",
//"user_id": 2892,
//"user_name": "信雅壮",
//"course_id": 9,
//"course_name": "IOS小班课测试",
//"course_model_name": "LiveStudio::CustomizedGroup",
//"created_at": 1505302314,
//"model_name": "LiveStudio::Question",
//"body": "你好",
//"answer": null

@end
