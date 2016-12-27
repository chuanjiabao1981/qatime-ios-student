//
//  PlayerView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/27.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "FJFloatingView.h"
#import "NELivePlayerControl.h"
#import "NELivePlayerController.h"


@interface PlayerView : FJFloatingView

@property(nonatomic, strong) NELivePlayerController <NELivePlayer> *liveplayerBoard;


@end
