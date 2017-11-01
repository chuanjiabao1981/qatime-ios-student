//
//  NSObject+Selector.m
//  Qatime_Student
//
//  Created by Shin on 2017/10/31.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "NSObject+Selector.h"

@implementation NSObject (Selector)

-(id)yz_performSelector:(SEL)selector withObject:(id)object,...NS_REQUIRES_NIL_TERMINATION;
{
    //根据类名以及SEL 获取方法签名的实例
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    if (signature == nil) {
        NSLog(@"--- 使用实例方法调用 为nil ---");
        signature = [self methodSignatureForSelector:selector];
        if (signature == nil) {
            NSLog(@"使用类方法调用 也为nil， 此时return");
            return nil;
        }
    }
    //NSInvocation是一个消息调用类，它包含了所有OC消息的成分：target、selector、参数以及返回值。
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;
    NSUInteger argCount = signature.numberOfArguments;
    // 参数必须从第2个索引开始，因为前两个已经被target和selector使用
    argCount = argCount > 2 ? argCount - 2 : 0;
    NSMutableArray *objs = [NSMutableArray arrayWithCapacity:0];
    if (object) {
        [objs addObject:object];
        va_list args;
        va_start(args, object);
        while ((object = va_arg(args, id))){
            [objs addObject:object];
        }
        va_end(args);
    }
    if (objs.count != argCount){
        NSLog(@"--- objs.count != argCount! please check it! ---");
        return nil;
    }
    //设置参数列表
    for (NSInteger i = 0; i < objs.count; i++) {
        id obj = objs[i];
        if ([obj isKindOfClass:[NSNull class]]) {
            continue;
        }
        [invocation setArgument:&obj atIndex:i+2];
    }
    [invocation invoke];
    //获取返回值
    id returnValue = nil;
    if (signature.methodReturnLength != 0 && signature.methodReturnLength) {
        [invocation getReturnValue:&signature];
    }
    return returnValue;
}
@end
