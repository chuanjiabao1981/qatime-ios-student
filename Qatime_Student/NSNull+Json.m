//
//  NSNull+Json.m
//  Qatime_Student
//
//  Created by Shin on 2017/5/3.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "NSNull+Json.h"

@implementation NSNull (Json)

- (NSUInteger)length { return 0; }

- (NSInteger)integerValue { return 0; };

- (float)floatValue { return 0; };

- (NSString *)description { return @"0(NSNull)"; }

- (NSArray *)componentsSeparatedByString:(NSString *)separator { return @[]; }

- (id)objectForKey:(id)key { return nil; }

- (BOOL)boolValue { return NO; }

- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)aSet{
    NSRange nullRange = {NSNotFound, 0};
    return nullRange;
}

//add methods of NSString if needed

@end
