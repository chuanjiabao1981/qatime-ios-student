//
//  DJFloatingVoiceView.h
//  DeJiaIM
//
//  Created by fjf on 16/5/16.
//  Copyright © 2016年 tsningning. All rights reserved.
//

#import <UIKit/UIKit.h>

#define    FJ_FLOATING_VOICE_VIEW_SIZE  68
@interface FJFloatingView : UIView

@property(nonatomic,assign) BOOL canMove ;
@property(nonatomic,strong) UIPanGestureRecognizer *pan ;
@property(nonatomic,assign) BOOL becomeMainPlayer ;


@end
