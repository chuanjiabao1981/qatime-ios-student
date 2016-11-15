//
//  Chat_Account.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/15.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chat_Account : NSObject
//"user_id": 584,
////    "accid": "8b8dac47fc743ebc7d163bd360caaafb",
////    "token": "d5559c6a388e2a0b91684223711f4c1e",
////    "name": "马老师1",
////    "icon": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/avatars/small_14c4a876183d7886ca8684a1650fa785.png"


@property(nonatomic,strong) NSString *user_id ;
@property(nonatomic,strong) NSString *accid ;
@property(nonatomic,strong) NSString *token ;
@property(nonatomic,strong) NSString *name ;
@property(nonatomic,strong) NSString *icon ;
@end
