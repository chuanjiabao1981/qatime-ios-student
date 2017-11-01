//
//  ShareView.m
//  Qatime_Student
//
//  Created by Shin on 2017/10/30.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ShareView.h"
#import "UIButton+EnlargeTouchArea.h"

@implementation ShareView

+(instancetype)sharedView{
    static ShareView *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _shareLabel = [[UILabel alloc]init];
        [self addSubview:_shareLabel];
        _shareLabel.font = TITLEFONTSIZE;
        _shareLabel.textColor = [UIColor blackColor];
        _shareLabel.text = @"分享到";
        _shareLabel.sd_layout
        .leftSpaceToView(self, 20*ScrenScale)
        .centerYEqualToView(self)
        .autoHeightRatio(0);
        [_shareLabel setSingleLineAutoResizeWithMaxWidth:300];
        
        _wechatBtn = [[UIButton alloc]init];
        [self addSubview:_wechatBtn];
        [_wechatBtn setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
        _wechatBtn.sd_layout
        .rightSpaceToView(self, 20*ScrenScale)
        .centerYEqualToView(_shareLabel)
        .heightRatioToView(_shareLabel, 1.0)
        .widthEqualToHeight();
        [_wechatBtn setEnlargeEdge:20];
      
    }
    return self;
}

@end
