//
//  NSString+ContainEmoji.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/22.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ContainEmoji)
+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (BOOL)stringWithEmojiEncode:(NSString *)string;

@end
