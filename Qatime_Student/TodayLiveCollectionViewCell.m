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
        
        //状态label
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.font = [UIFont systemFontOfSize:13*ScrenScale];
        _stateLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_stateLabel];
        _stateLabel.sd_layout
        .topSpaceToView(_classImageView,2)
        .centerXEqualToView(_classImageView)
        .autoHeightRatio(0);
        [_stateLabel setSingleLineAutoResizeWithMaxWidth:300];
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
    
    _stateLabel.text = [NSString stringWithFormat:@"%@ - %@ %@",[model.live_start_time substringFromIndex:11],[model.live_end_time substringFromIndex:11],[self statusChange:model.status]];
    
    
}

- (NSString *)statusChange:(NSString *)status{
    
    NSString *str  = @"".mutableCopy;
    
    if ([status isEqualToString:@"teaching"]) {
        
        str = @"正在直播";
    }else if ([status isEqualToString:@""]){
        
        
    }else if ([status isEqualToString:@""]){
        
    }
    
    return str;
}


- (BOOL)diskImageExistsForURL:(NSURL *)url {
    NSString *key = [manager cacheKeyForURL:url];
    return [manager.imageCache diskImageExistsWithKey:key];
}


@end
