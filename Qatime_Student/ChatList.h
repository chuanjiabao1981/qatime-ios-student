//
//  ChatList.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/20.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TutoriumList.h"

@interface ChatList : NSObject

@property(nonatomic,strong) NSString *name ;

@property(nonatomic,assign) NSInteger badge ;

@property(nonatomic,strong) TutoriumListInfo *tutorium ;
@end
