//
//  AboutUsFoot.m
//  Qatime_Student
//
//  Created by Shin on 2017/11/6.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "AboutUsFoot.h"

@implementation AboutUsFoot

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //版本号
        _versionLabel = [[UILabel alloc]init];
        _versionLabel.font = TEXT_FONTSIZE;
        _versionLabel.textColor = TITLECOLOR;
        _versionLabel.text = [NSString stringWithFormat:@"当前版本: V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        [self addSubview:_versionLabel];
        _versionLabel.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(self, 60*ScrenScale)
        .autoHeightRatio(0);
        [_versionLabel setSingleLineAutoResizeWithMaxWidth:4000];
        [self setupAutoHeightWithBottomView:_versionLabel bottomMargin:20*ScrenScale];
    }
    return self;
}

@end
