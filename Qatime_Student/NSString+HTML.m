//
//  NSString+HTML.m
//  Qatime_Student
//
//  Created by Shin on 2017/11/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "NSString+HTML.h"

@implementation NSString (HTML)

//正则去除网络标签
+(NSString *)getPureStringwithHTMLString:(NSString *)string{
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:string];
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        string = [string stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return string;
  
}

@end
