//
//  ExclusiveInfo_InfoFootView.m
//  Qatime_Student
//
//  Created by Shin on 2017/11/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusiveInfo_InfoFootView.h"

@implementation ExclusiveInfo_InfoFootView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //学习须知
        UILabel *notice = [[UILabel alloc]init];
        [self addSubview:notice];
        notice.text = @"学习须知";
        notice.textAlignment = NSTextAlignmentCenter;
        notice.textColor = [UIColor blackColor];
        notice.font = TITLEFONTSIZE;
        notice.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 20*ScrenScale)
        .autoHeightRatio(0);
        
        //说明的富文本设置
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = 5;
        NSDictionary *attribute = @{NSFontAttributeName:TEXT_FONTSIZE,
                                    NSParagraphStyleAttributeName:style};
        
        //上课前
        UILabel *before = [[UILabel alloc]init];
        before.text = @"上课前";
        before.font = TITLEFONTSIZE;
        [self addSubview:before];
        before.sd_layout
        .leftSpaceToView(self, 15*ScrenScale)
        .topSpaceToView(notice,20*ScrenScale)
        .autoHeightRatio(0);
        [before setSingleLineAutoResizeWithMaxWidth:100];
        
        _beforeLabel = [[UILabel alloc]init];
        [self addSubview:_beforeLabel];
        _beforeLabel.font = TEXT_FONTSIZE;
        _beforeLabel.textColor = TITLECOLOR;
        _beforeLabel.textAlignment = NSTextAlignmentLeft;
        _beforeLabel.isAttributedContent = YES;
        
        _beforeLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:@"1、做好课程预习，预先了解本课所讲内容，更好的吸收课程精华；\n2、准备好相关的学习工具（如：纸、笔等）并在上课前调试好电脑，使用手机请保持电量充足。\n3、选择安静的学习环境，并将与学习无关的事物置于远处；选择安静的环境避免影响听课。\n4、三年级以下的同学请在家长帮助下学习。\n5、遇到网页不能打开或者不能登陆等情况请及时联系客服。"  attributes:attribute];
        
        _beforeLabel.sd_layout
        .topSpaceToView(before,10)
        .leftEqualToView(before)
        .rightSpaceToView(self,20)
        .autoHeightRatio(0);
        
        
        //上课中
        UILabel *during = [[UILabel alloc]init];
        during.text = @"上课中";
        during.font = TITLEFONTSIZE;
        
        [self addSubview:during];
        during.sd_layout
        .leftEqualToView(_beforeLabel)
        .topSpaceToView(_beforeLabel,20)
        .autoHeightRatio(0);
        [during setSingleLineAutoResizeWithMaxWidth:100];
        
        _duringLabel = [[UILabel alloc]init];
        [self addSubview:_duringLabel];
        _duringLabel.font = TEXT_FONTSIZE;
        _duringLabel.textColor = TITLECOLOR;
        _duringLabel.textAlignment = NSTextAlignmentLeft;
        _duringLabel.isAttributedContent = YES;
        _duringLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:@"1、时刻保持注意力集中，认真听讲才能更好的提升学习；\n2、课程中遇到听不懂的问题及时通过聊天或互动申请向老师提问，老师收到后会给予解答；\n3、积极响应老师的授课，完成老师布置的课上任务；\n4、禁止在上课中闲聊或发送一切与本课无关的内容，如有发现，一律禁言；\n5、上课途中如突遇屏幕卡顿，直播中断等特殊情况，请刷新后等待直播恢复；超过15分钟未恢复去请致电客服。" attributes:attribute];
        
        _duringLabel.sd_layout
        .topSpaceToView(during,10)
        .leftEqualToView(_beforeLabel)
        .rightSpaceToView(self,20)
        .autoHeightRatio(0);
        
        //上课后
        UILabel * _after = [[UILabel alloc]init];
        _after.text = @"上课后";
        _after.font = TITLEFONTSIZE;
        
        [self addSubview:_after];
        _after.sd_layout
        .leftEqualToView(during)
        .topSpaceToView(_duringLabel,20)
        .autoHeightRatio(0);
        [_after setSingleLineAutoResizeWithMaxWidth:100];
        
        _afterLabel = [[UILabel alloc]init];
        [self addSubview:_afterLabel];
        _afterLabel.font = TEXT_FONTSIZE;
        _afterLabel.textColor = TITLECOLOR;
        _afterLabel.textAlignment = NSTextAlignmentLeft;
        _afterLabel.isAttributedContent = YES;
        _afterLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:@"1、直播结束后请大家仍可以在直播教室内进行聊天和讨论，老师也会适时解答；\n2、请同学按时完成老师布置的作业任务。" attributes:attribute];
        _afterLabel.sd_layout
        .topSpaceToView(_after,10)
        .leftEqualToView(_duringLabel)
        .rightSpaceToView(self,20)
        .autoHeightRatio(0);
        
        UILabel *_replay = [[UILabel alloc]init];
        _replay.text = @"回放说明";
        _replay.font = TITLEFONTSIZE;
        _replay.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_replay];
        _replay.sd_layout
        .topSpaceToView(_afterLabel, 20*ScrenScale)
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .autoHeightRatio(0);
        
        _replayLabel = [[UILabel alloc]init];
        [self addSubview:_replayLabel];
        _replayLabel.font = TEXT_FONTSIZE;
        _replayLabel.textColor = TITLECOLOR;
        _replayLabel.textAlignment = NSTextAlignmentLeft;
        _replayLabel.isAttributedContent = YES;
        _replayLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:@"1、购买课程后方可观看回放。\n2、直播课回放学生可以免费观看最多10天，同一天不限定观看次数。\n3、直播结束后最晚于24小时内上传回放。\n4、回放内容不完全等于直播内容，请尽量观看直播学习。\n5、回放内容仅供学生学习使用，未经允许不得进行录制。" attributes:attribute];
        _replayLabel.sd_layout
        .topSpaceToView(_replay,20*ScrenScale)
        .leftEqualToView(_duringLabel)
        .rightSpaceToView(self,20)
        .autoHeightRatio(0);
        
        [self setupAutoHeightWithBottomView:_replayLabel bottomMargin:20*ScrenScale];
    }
    return self;
}
@end
