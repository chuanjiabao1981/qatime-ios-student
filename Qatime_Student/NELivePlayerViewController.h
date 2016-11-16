//
//  NELivePlayerViewController.h
//  NELivePlayerDemo
//
//  Created by NetEase on 15-10-10.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "NELivePlayer.h"
#import "NELivePlayerController.h"

#import "RDVTabBarController.h"

#import "UIViewController+ZFPlayer.h"
#import "VideoInfoView.h"
#import "InfoHeaderView.h"




@class NELivePlayerControl;
@interface NELivePlayerViewController : UIViewController <NELivePlayer>

/* 播放器 的属性 */
@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) NSString *decodeType;
@property(nonatomic, strong) NSString *mediaType;
@property(nonatomic, strong) NELivePlayerController <NELivePlayer> *liveplayer;

/* 数据界面层的属性*/

/* 课程id*/
@property(nonatomic,strong) NSString *classID ;



/* 视频信息页面*/
@property(nonatomic,strong) VideoInfoView *videoInfoView ;

@property(nonatomic,strong) InfoHeaderView *infoHeaderView ;





/**
 数据界面信息 初始化方法

 @param classID 课程id
 @return 返回初始化对象
 */

-(instancetype)initWithClassID:(NSString *)classID;





/* 播放器的初始化方法*/

- (id)initWithURL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm;

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm completion:(void(^)())completion;

@property(nonatomic, strong) IBOutlet NELivePlayerControl *mediaControl;

@end

