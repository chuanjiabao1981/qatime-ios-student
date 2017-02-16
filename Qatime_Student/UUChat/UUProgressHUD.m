//
//  UUProgressHUD.m
//  1111
//
//  Created by shake on 14-8-6.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUProgressHUD.h"

@interface UUProgressHUD ()
{
    NSTimer *myTimer;
    int angle;
    
    UILabel *timeLabel;   //录音时间
    
}
@property (nonatomic, strong, readonly) UIWindow *overlayWindow;

@end

@implementation UUProgressHUD

@synthesize overlayWindow;

+ (UUProgressHUD*)sharedView {
    static dispatch_once_t once;
    static UUProgressHUD *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[UUProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

                sharedView.backgroundColor = [UIColor clearColor];
    });
    return sharedView;
}

+ (void)show {

    [[UUProgressHUD sharedView] show];
}

- (void)level:(NSNotification *)notification{
    
    if (_canHearVolum==YES) {
        
        NSString *levelStr = [notification object];
        CGFloat level = levelStr.floatValue;
        
        
        if (level<10) {
            
            [_statusImageView setImage:[UIImage imageNamed:@"v-0"]];
            
        }else if (level>120){
            [_statusImageView setImage:[UIImage imageNamed:@"v-7"]];
            
        }else if (level>10&&level<110){
            
            NSLog(@"改变的格数:%ld",(NSInteger)level/14);
            
            [_statusImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"v-%ld",(NSInteger)level/14]]];
        }
    }
    
    
    
}

- (void)show {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(level:) name:@"Volum" object:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.superview)
            [self.overlayWindow addSubview:self];
        
        //hud框
        if ((!_HUDView)) {
            _HUDView = [[UIView alloc]init];
            _HUDView.backgroundColor =[[UIColor blackColor]colorWithAlphaComponent:0.5];
            
            [self addSubview:_HUDView];
            _HUDView.sd_layout
            .centerXEqualToView(self)
            .centerYEqualToView(self)
            .widthIs(self.width_sd/2)
            .heightEqualToWidth();
            _HUDView.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*4];
            
            
        }
        
        //时间
        if (!timeLabel){
            timeLabel = [[UILabel alloc]init];
            timeLabel.backgroundColor = [UIColor clearColor];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            timeLabel.text = @"0";
            timeLabel.font = [UIFont systemFontOfSize:16*ScrenScale];
            timeLabel.textColor = [UIColor whiteColor];
            [_HUDView addSubview:timeLabel];
            timeLabel.frame = CGRectMake(0, 15, _HUDView.width_sd, 25);
            
        }
        
        //录音状态
        if (!self.subTitleLabel){
            self.subTitleLabel = [[UILabel alloc]init];
            self.subTitleLabel.backgroundColor = [UIColor clearColor];
            self.subTitleLabel.text = @"手指上滑,取消发送";
            self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
            self.subTitleLabel.font = [UIFont boldSystemFontOfSize:15*ScrenScale];
            self.subTitleLabel.textColor = [UIColor whiteColor];
            _canHearVolum = YES;
            [_HUDView addSubview:_subTitleLabel];
            
            [_HUDView updateLayout];
            _subTitleLabel.sd_layout
            .leftSpaceToView(_HUDView,15)
            .rightSpaceToView(_HUDView,15)
            .bottomSpaceToView(_HUDView,10)
            .heightIs(_HUDView.height_sd/7.5);
            _subTitleLabel.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
            
        }
        
        //状态图片
        if (!self.statusImageView) {
            self.statusImageView = [[UIImageView alloc]init];
            [self.statusImageView setImage:[UIImage imageNamed:@"v-0"]];
            
            [_HUDView addSubview:self.statusImageView];
            _statusImageView.sd_layout
            .leftSpaceToView(_HUDView,_HUDView.width_sd/6)
            .topSpaceToView(timeLabel,5)
            .bottomSpaceToView(_subTitleLabel,5)
            .rightSpaceToView(_HUDView,_HUDView.width_sd/6);
            
        }
        
        
        //计时器
        if (myTimer)
            [myTimer invalidate];
        myTimer = nil;
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                   target:self
                                                 selector:@selector(startAnimation)
                                                 userInfo:nil
                                                  repeats:YES];
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.alpha = 1;
                         }
                         completion:^(BOOL finished){
                         }];
        [self setNeedsDisplay];
    });
}
-(void) startAnimation
{
    angle -= 3;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.09];
    UIView.AnimationRepeatAutoreverses = YES;
    float second = [timeLabel.text floatValue];
    if (second >= 50.0f) {
        timeLabel.textColor = [UIColor redColor];
    }else{
        timeLabel.textColor = [UIColor whiteColor];
    }
    timeLabel.text = [NSString stringWithFormat:@"%.1f",second+0.1];
    [UIView commitAnimations];
}

+ (void)changeSubTitle:(NSString *)str
{
    [[UUProgressHUD sharedView] setState:str];
}

- (void)setState:(NSString *)str
{
    
    if ([str isEqualToString:@"松开手指,取消发送"]) {
        _canHearVolum = NO;
        _subTitleLabel.backgroundColor = [UIColor colorWithRed:0.64 green:0.21 blue:0.21 alpha:1.0];
        [_statusImageView setImage:[UIImage imageNamed:@"repeal"]];

    }else if ([str isEqualToString:@"手指上滑,取消发送"]){
        
        _canHearVolum = YES;
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        
        [_statusImageView setImage:[UIImage imageNamed:@"v-0"]];
        
 
        
    }else{
        _canHearVolum = YES;
        _subTitleLabel.backgroundColor = [UIColor clearColor];

    }
    
    self.subTitleLabel.text = str;
    
}

+ (void)dismissWithSuccess:(NSString *)str {
    [[UUProgressHUD sharedView] dismiss:str];
}

+ (void)dismissWithError:(NSString *)str {
    [[UUProgressHUD sharedView] dismiss:str];
}

- (void)dismiss:(NSString *)state {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [myTimer invalidate];
        myTimer = nil;
        
        CGFloat timeLonger;
        if ([state isEqualToString:@"录音时间太短"]) {
            _canHearVolum = NO;
            _subTitleLabel.backgroundColor = [UIColor clearColor];
            
            [_statusImageView setImage:[UIImage imageNamed:@"recordTimeShort"]];

            timeLonger = 1;
        }else{
            timeLonger = 0.6;
        }
        _subTitleLabel.text = state;
        [UIView animateWithDuration:timeLonger
                              delay:0
                            options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             if(self.alpha == 0) {
                                 [timeLabel removeFromSuperview];
                                 timeLabel = nil;

                                 [self.subTitleLabel removeFromSuperview];
                                 self.subTitleLabel = nil;
                                 
                                 [self.statusImageView removeFromSuperview];
                                 self.statusImageView = nil;
                                 
                                 NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
                                 [windows removeObject:overlayWindow];
                                 overlayWindow = nil;
                                 
                                 [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                                     if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                                         [window makeKeyWindow];
                                         *stop = YES;
                                     }
                                 }];
                             }
                         }];
    });
}

- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.userInteractionEnabled = NO;
        [overlayWindow makeKeyAndVisible];
    }
    return overlayWindow;
}


@end
