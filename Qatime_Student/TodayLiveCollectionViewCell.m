//
//  TodayLiveCollectionViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

//  今日直播cell

#import "TodayLiveCollectionViewCell.h"

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "UIColor+HcdCustom.h"


@interface TodayLiveCollectionViewCell (){
    
    SDWebImageManager *manager;
}

@end

@implementation TodayLiveCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        //课程图
        _classImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_classImageView];
        _classImageView.sd_layout
        .topSpaceToView(self.contentView,0)
        .leftSpaceToView(self.contentView,0)
        .rightSpaceToView(self.contentView,0)
        .heightIs(self.contentView.width_sd*10/16.0);
        
        //课程名
        _classNameLabel = [[UILabel alloc]init];
        _classNameLabel.textColor = [UIColor whiteColor];
        _classNameLabel.textAlignment = NSTextAlignmentLeft;
        _classNameLabel.font = [UIFont systemFontOfSize:13*ScrenScale];
        _classNameLabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        [_classImageView addSubview:_classNameLabel];
        _classNameLabel.sd_layout
        .bottomEqualToView(_classImageView)
        .leftEqualToView(_classImageView)
        .rightEqualToView(_classImageView)
        .autoHeightRatio(0);
        
        //直播时间
        _liveTimeLabel = [[UILabel alloc]init];
        _liveTimeLabel.font = [UIFont systemFontOfSize:13*ScrenScale];
        _liveTimeLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_liveTimeLabel];
        _liveTimeLabel.sd_layout
        .topSpaceToView(_classImageView,2)
        .leftSpaceToView(self.contentView,0)
        .autoHeightRatio(0);
        [_liveTimeLabel setSingleLineAutoResizeWithMaxWidth:200];
        [_liveTimeLabel updateLayout];
        
        //状态label
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.font = [UIFont systemFontOfSize:13*ScrenScale];
        _stateLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_stateLabel];
        _stateLabel.sd_layout
        .topEqualToView(_liveTimeLabel)
        .bottomEqualToView(_liveTimeLabel)
        .leftSpaceToView(_liveTimeLabel,5);
        [_stateLabel setSingleLineAutoResizeWithMaxWidth:200];
        [_stateLabel updateLayout];
        
        
        [self setupAutoHeightWithBottomView:_stateLabel bottomMargin:0];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"TodayHeight" object:self];
        
    }
    return self;

}

-(void)setModel:(RecommandClasses *)model{
    
    _model = model;
    
    /* 如果本地已经保留了图片缓存*/
    if ([self diskImageExistsForURL:[NSURL URLWithString:model.publicize]]==YES) {
        [_classImageView sd_setImageWithURL:[NSURL URLWithString:model.publicize]];
    }else{
        /* 如果本地没有缓存,加载网络图片,渐变动画*/
        [_classImageView sd_setImageWithURL:[NSURL URLWithString:model.publicize] placeholderImage:[UIImage imageNamed:@"school"] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            _classImageView.alpha = 0.0;
            [UIView transitionWithView:_classImageView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                if (image) {
                    
                    [_classImageView setImage:image];
                }else{
                    [_classImageView setImage:[UIImage imageNamed:@"school"]];
                }
                _classImageView.alpha = 1.0;
            } completion:NULL];
            
        }];
    }

    _classNameLabel.text = model.name;
    
    _liveTimeLabel .text = model.live_time;
    _stateLabel.text = [self statusChange:model.status];
    
    _liveTimeLabel.sd_layout
    .leftSpaceToView(self.contentView,(self.contentView.width_sd-(_liveTimeLabel.width_sd+_stateLabel.width_sd))/2);
    [_liveTimeLabel updateLayout];
    
}

- (NSString *)statusChange:(NSString *)status{
    
    NSString *str  = @"".mutableCopy;
    
    if ([status isEqualToString:@"teaching"]||[status isEqualToString:@"pause"]) {
        str = @"正在直播";
        _stateLabel.textColor = [UIColor colorWithHexString:@"#ff5842"];
    }else if ([status isEqualToString:@"init"]||[status isEqualToString:@"ready"]||[status isEqualToString:@"init"]){
        str = @"尚未直播";
        _stateLabel.textColor = [UIColor colorWithHexString:@"#4873ff"];
    }else if ([status isEqualToString:@"closed"]||[status isEqualToString:@"finished"]||[status isEqualToString:@"missed"]||[status isEqualToString:@"billing"]||[status isEqualToString:@"completed"]){
        str = @"直播结束";
        _stateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }

    return str;
}


- (BOOL)diskImageExistsForURL:(NSURL *)url {
    NSString *key = [manager cacheKeyForURL:url];
    return [manager.imageCache diskImageExistsWithKey:key];
}


@end