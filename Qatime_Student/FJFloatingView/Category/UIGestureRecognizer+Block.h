//
//  UIGestureRecognizer+Block.h
//  demo
//
//  Created by fjf on 16/5/12.
//  Copyright © 2016年 fangjf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NVMGestureBlock)(id gestureRecognizer);

@interface UIGestureRecognizer (Block)
+(instancetype)nvm_gestureRecognizerWithActionBlock:(NVMGestureBlock)block;
@end
