//
//  NTESMeetingActorsView.h
//  NIMEducationDemo
//
//  Created by fenric on 16/4/9.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IJKFloatingView.h"
@interface NTESMeetingActorsView : UIView

@property (nonatomic) BOOL isFullScreen;

@property (nonatomic) BOOL showFullScreenBtn;

@property (nonatomic, strong) IJKFloatingView *teacherCamera ;
@property (nonatomic, strong) IJKFloatingView *selfCamera ;
@property (nonatomic, assign) BOOL videoStart ;

- (void)updateActors;

-(void)stopLocalPreview;

@end
