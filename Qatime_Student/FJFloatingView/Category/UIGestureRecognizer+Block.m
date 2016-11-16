//
//  UIGestureRecognizer+Block.m
//  demo
//
//  Created by fjf on 16/5/12.
//  Copyright © 2016年 fangjf. All rights reserved.
//

#import <objc/runtime.h>
#import "UIGestureRecognizer+Block.h"

static const int target_key;
@implementation UIGestureRecognizer (Block)
+(instancetype)nvm_gestureRecognizerWithActionBlock:(NVMGestureBlock)block {
    return [[self alloc]initWithActionBlock:block];
}

- (instancetype)initWithActionBlock:(NVMGestureBlock)block {
    self = [self init];
    [self addActionBlock:block];
    [self addTarget:self action:@selector(invoke:)];
    return self;
}

- (void)addActionBlock:(NVMGestureBlock)block {
    if (block) {
        objc_setAssociatedObject(self, &target_key, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void)invoke:(id)sender {
    NVMGestureBlock block = objc_getAssociatedObject(self, &target_key);
    if (block) {
        block(sender);
    }
}
@end
