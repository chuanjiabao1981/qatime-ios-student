//
//  TutoriumList.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TutoriumListInfo : NSObject

/* model所包含的内容 及项目*/
@property(nonatomic,strong) NSString *classID ;
@property(nonatomic,strong) NSString *name ;
@property(nonatomic,strong) NSString *subject ;
@property(nonatomic,strong) NSString *grade ;
@property(nonatomic,strong) NSString *teacher_name ;
@property(nonatomic,strong) NSString *price ;
@property(nonatomic,strong) NSString *current_price ;
@property(nonatomic,strong) NSString *chat_team_id ;
@property(nonatomic,strong) NSString *buy_tickets_count ;
@property(nonatomic,strong) NSString *preset_lesson_count ;
@property(nonatomic,strong) NSString *taste_count ;
@property(nonatomic,strong) NSString *completed_lesson_count ;
@property(nonatomic,strong) NSString *live_start_time ;
@property(nonatomic,strong) NSString *live_end_time ;
@property(nonatomic,strong) NSString *publicize ;
@property(nonatomic,strong) NSString *pull_address ;
@property(nonatomic,strong) NSString *board ;
@property(nonatomic,strong) NSString *camera ;
@property(nonatomic,strong) NSString *preview_time ;
@property(nonatomic,assign) BOOL is_tasting ;
@property(nonatomic,assign) BOOL is_bought ;
@property(nonatomic,strong) NSString *status;

/* 在加载消息列表页时该属性才有用,其他接口用不到*/
@property(nonatomic,assign) BOOL notify ;

@end



/* 类声明*/


@interface TutoriumList : NSObject

@property(nonatomic,strong) NSString *status ;
@property(nonatomic,strong) NSArray *data ;

@property(nonatomic,strong) TutoriumListInfo * tutoriumListInfo;





@end


