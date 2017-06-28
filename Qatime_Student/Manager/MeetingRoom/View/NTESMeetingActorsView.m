//
//  NTESMeetingActorsView.m
//  NIMEducationDemo
//
//  Created by fenric on 16/4/9.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESMeetingActorsView.h"
#import "NTESMeetingRolesManager.h"
#import "UIView+NTES.h"
#import "NTESGLView.h"
#import <NIMAVChat/NIMAVChat.h>
#import "NTESVideoFSViewController.h"



#define NTESMeetingMaxActors 2

@interface NTESMeetingActorsView()<NIMNetCallManagerDelegate>
{
    NSMutableArray *_actorViews;
    NSMutableArray *_actors;
    NSMutableArray *_backgroundViews;
}

@property (nonatomic, weak) CALayer *localVideoLayer;
@property (nonatomic, strong) NTESVideoFSViewController *videoVc;
@property (nonatomic, strong) UIButton *fullScreenBtn;



@end

@implementation NTESMeetingActorsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _actorViews = [NSMutableArray array];
        _backgroundViews = [NSMutableArray array];
        _videoVc = [[NTESVideoFSViewController alloc]init];
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backgroundImage = [UIImage imageNamed:@"PlayerHolder"];
        _fullScreenBtn.hidden = YES;
        
        UIImageView *background = [[UIImageView alloc] initWithImage:backgroundImage];
        [self addSubview:background];
        [_backgroundViews addObject:background];
        
        UIImageView *background2 = [[UIImageView alloc] initWithImage:backgroundImage];
        [self addSubview:background2];
        [_backgroundViews addObject:background2];
        
        
        //教师的摄像头
        _teacherCamera = [[IJKFloatingView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenWidth/16*9)];
        _teacherCamera.canMove = NO;
        _teacherCamera.contentMode = UIViewContentModeScaleAspectFill;
        _teacherCamera.backgroundColor = [UIColor clearColor];
        [_teacherCamera render:nil width:0 height:0];
        [self addSubview:_teacherCamera];
        [_actorViews addObject:_teacherCamera];
        
        //个人摄像头
        _selfCamera = [[IJKFloatingView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth/4, UIScreenWidth/4/9*16)];
        _selfCamera.canMove = YES;
        _selfCamera.contentMode = UIViewContentModeScaleAspectFill;
        _selfCamera.backgroundColor = [UIColor clearColor];
        [_selfCamera render:nil width:0 height:0];
        [self addSubview:_selfCamera];
        [_actorViews addObject:_selfCamera];
        
        [self updateActors];
        [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
    }
    return self;
}


- (void)dealloc{
    
    [[NIMAVChatSDK sharedSDK].netCallManager removeDelegate:self];
}

//本地摄像头准备就绪
- (void)onLocalPreviewReady:(CALayer *)layer{
    
    [self startLocalPreview:layer];
    _localVideoLayer = layer;

}

- (void)onRemoteYUVReady:(NSData *)yuvData width:(NSUInteger)width height:(NSUInteger)height from:(NSString *)user{
    
    NSUInteger viewIndex = [_actors indexOfObject:user];
    
    //判断是否全屏
    if(_isFullScreen)
    {
        if(viewIndex == 0)
        {
            [_videoVc onRemoteYUVReady:yuvData width:width height:height from:user];
        }
    }
    else
    {
        if (viewIndex != NSNotFound && viewIndex < NTESMeetingMaxActors) {
            
            IJKFloatingView *view = _actorViews[viewIndex];
            [view render:yuvData width:width height:height];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"TeacherCameraData" object:nil];
            if(viewIndex == 0)
            {
                if(_showFullScreenBtn)
                {
                    _fullScreenBtn.hidden = NO;
                }
                else
                {
//                    [view setFrame:CGRectMake(0, 0, UIScreenWidth/4, UIScreenWidth/4/9*16)];
                    _fullScreenBtn.hidden = YES;
                }
            }else{
                [view render:yuvData width:width height:height];
            }
        }
    }
}

-(void)setShowFullScreenBtn:(BOOL)showFullScreenBtn
{
    _showFullScreenBtn = showFullScreenBtn;
    if(!showFullScreenBtn)
    {
        _fullScreenBtn.hidden = !showFullScreenBtn;
    }
    //退出全屏
    if (self.isFullScreen&&!showFullScreenBtn ) {
        [_videoVc onExitFullScreen];
    }
}

-(void)goFullScreen
{
    [self.viewController presentViewController:_videoVc animated:NO completion:^{
        self.isFullScreen = YES;
    }];
}

- (void)startLocalPreview:(CALayer *)layer
{
    [self stopLocalPreview];
    
    _localVideoLayer = layer;

    IJKFloatingView *localView = _actorViews[1];
    [localView render:nil width:0 height:0];
    [localView.layer addSublayer:_localVideoLayer];
    [self layoutLocalPreviewLayer];
}


-(void)stopLocalPreview
{
    if (_localVideoLayer) {
        [_localVideoLayer removeFromSuperlayer];
    }
}

- (void)layoutLocalPreviewLayer
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat rotateDegree;
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateDegree = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateDegree = M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotateDegree = M_PI_2 * 3.0;
            break;
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationUnknown:
            rotateDegree = 0;
            break;
    }
    
    [_localVideoLayer setAffineTransform:CGAffineTransformMakeRotation(rotateDegree)];
    IJKFloatingView *localView = _actorViews[1];
    localView.frame = CGRectMake(0, 0, UIScreenWidth/4, UIScreenWidth/4/9*16);
    localView.canMove = YES;
    _localVideoLayer.frame = localView.bounds;
    
    //发送本地摄像头准备就绪的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SelfCameraReady" object:nil];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < NTESMeetingMaxActors; i ++) {
        UIView *view = _actorViews[i];
        view.width = [UIScreen mainScreen].bounds.size.width;
        view.height = [UIScreen mainScreen].bounds.size.width/16*9.f;
        view.top = i < 2 ? 0 : self.height / 2;
        view.left = (i + 1) % 2 ? 0 : [UIScreen mainScreen].bounds.size.width;
//        if(i==0){
//            
//            _fullScreenBtn.frame = CGRectMake(view.frame.size.width-7-30, view.frame.size.height-7-30, 30, 30);
//            [_fullScreenBtn setImage: [UIImage imageNamed:@"chatroom_video_fullscreen"] forState:UIControlStateNormal];
//            [_fullScreenBtn addTarget:self action:@selector(goFullScreen) forControlEvents:UIControlEventTouchUpInside];
//            [view addSubview:_fullScreenBtn];
//        }
        UIImageView *backgound = _backgroundViews[i];
        backgound.frame = view.frame;
    }
}

- (void)updateActors{
    
    //本地摄像头
    if ([NTESMeetingRolesManager defaultManager].myRole.videoOn==NO) {
        [[NTESMeetingRolesManager defaultManager].myRole setVideoOn:YES];
        
        if (_localVideoLayer) {
            
            [self onLocalPreviewReady:_localVideoLayer];
        }
        
    }else{
        if (_localVideoLayer) {
            
            [self onLocalPreviewReady:_localVideoLayer];
        }
    }
    
}

-(NSUInteger)localViewIndex
{
    NSString *myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
    if (_actors.count) {
        return [_actors indexOfObject:myUid];
    }
    else {
        return NSNotFound;
    }
}

@end
