//
//  VideoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/10.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPlayer.h"
#import "UIViewController+ZFPlayer.h"
#import "VideoInfoView.h"

@interface VideoViewController : UIViewController

@property(nonatomic,strong) ZFPlayerView *playerView ;
//@property(nonatomic,strong) ZFPlayerView *anotherPlayerView ;


/* 课程id*/
@property(nonatomic,strong) NSString *classID ;



/* 视频信息页面*/
@property(nonatomic,strong) VideoInfoView *videoInfoView ;



-(instancetype)initWithClassID:(NSString *)classID;



@end
