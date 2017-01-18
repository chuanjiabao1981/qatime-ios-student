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


@class NELivePlayerControl;
@interface VideoPlayerViewController : UIViewController

@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) NSString *decodeType;
@property(nonatomic, strong) NSString *mediaType;
@property(nonatomic, strong) id<NELivePlayer> liveplayer;



- (id)initWithURL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm andTitle:(NSString *)title;

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm andTitle:(NSString *)title completion:(void(^)())completion;

@property(nonatomic, strong) IBOutlet NELivePlayerControl *mediaControl;

@end

