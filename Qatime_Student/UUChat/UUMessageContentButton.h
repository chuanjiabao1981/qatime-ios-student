//
//  UUMessageContentButton.h
//  BloodSugarForDoc
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTextView.h"
#import "YYLabel.h"


@interface UUMessageContentButton : UIButton

@property(nonatomic,strong) YYLabel *title ;

@property(nonatomic,retain) YYTextView *contentTextView ;


//bubble imgae
@property (nonatomic, strong) UIImageView *backImageView;

//audio
@property (nonatomic, retain) UIView *voiceBackView;
@property (nonatomic, retain) UILabel *second;
@property (nonatomic, retain) UIImageView *voice;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;


@property (nonatomic, assign) BOOL isMyMessage;



- (void)benginLoadVoice;

- (void)didLoadVoice;

-(void)stopPlay;

@end
