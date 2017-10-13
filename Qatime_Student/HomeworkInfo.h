//
//  HomeworkInfo.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeworkManage.h"



@interface HomeworkInfo : HomeworkManage

@property (nonatomic, assign) BOOL edited ;//是否编辑过

/** 问题 */
@property (nonatomic, strong) NSString *body ;

@property (nonatomic, strong) NSMutableArray  *homeworkPhotos ;

@property (nonatomic, strong) NSString *homeworkRecordURL ;

/** 我的答案 */
@property (nonatomic, strong) NSString *myAnswerTitle ;

/** 我的答案的 图片们 */
@property (nonatomic, strong) NSMutableArray  *myAnswerPhotos ;

/** 我的答案的 语音文件 */
@property (nonatomic, strong) NSString *myAnswerRecorderURL ;
@property (nonatomic, strong) NSDictionary *myAnswerRecord ;

@property (nonatomic, strong) NSDictionary *answers ;

/** 老师批语 */
@property (nonatomic, strong) NSDictionary *correction ;

@property (nonatomic, strong) NSMutableArray *correctionPhotos ;

@property (nonatomic, strong) NSString *correctionRecordURL ;



//用来判断状态的  奇异属性.

@property (nonatomic, assign) BOOL havePhotos ;
@property (nonatomic, assign) BOOL haveRecord ;

@property (nonatomic, assign) BOOL haveAnswerPhotos ;
@property (nonatomic, assign) BOOL haveAnswerRecord ;

@property (nonatomic, assign) BOOL haveCorrectPhotos ;
@property (nonatomic, assign) BOOL haveCorrectRecord ;

@property (nonatomic, assign) BOOL haveCorrection;



@end
