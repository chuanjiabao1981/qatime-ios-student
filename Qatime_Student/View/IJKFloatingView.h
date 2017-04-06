//
//  IJKFloatingView.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/30.
//  Copyright © 2017年 WWTD. All rights reserved.
//

//  能放ijk播放器的floatingview

#import "NTESGLView.h"



#define    FJ_FLOATING_VOICE_VIEW_SIZE  68

@interface IJKFloatingView : NTESGLView

@property(nonatomic,assign) BOOL canMove ;
@property(nonatomic,strong) UIPanGestureRecognizer *pan ;
@property(nonatomic,assign) BOOL becomeMainPlayer ;

@end
