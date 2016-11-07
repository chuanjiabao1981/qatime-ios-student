//
//  NSString+UTF8Coding.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/4.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UTF8Coding)

+(NSString*)encodeString:(NSString*)unencodedString;
-(NSString *)decodeString:(NSString*)encodedString;

@end
