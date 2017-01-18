//
//  VideoPlayerViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/1/18.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPlayer.h"

@interface ReplayVideoPlayerViewController : UIViewController

@property(nonatomic,strong) ZFPlayerView *videoPlayer ;

@property (nonatomic, assign) UIInterfaceOrientation  orientation;

-(instancetype)initWithURL:(NSString *)urlStr andTitle:(NSString *)title;


@end
