//
//  Attachment.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/21.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMCustomObject.h>

@interface Attachment : NSObject<NIMCustomAttachment>
//简单新建一个有标题和副标题的自定义消息

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *subTitle;
@end
