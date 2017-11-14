//
//  NSString+HTML.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HTML)

/** 去掉html标签后返回的纯字符串 */
+(NSString *)getPureStringwithHTMLString:(NSString *)string;

@end
