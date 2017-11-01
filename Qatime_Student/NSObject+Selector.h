//
//  NSObject+Selector.h
//  Qatime_Student
//
//  Created by Shin on 2017/10/31.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Selector)

-(id)yz_performSelector:(SEL)selector withObject:(id)object,...NS_REQUIRES_NIL_TERMINATION;

@end
