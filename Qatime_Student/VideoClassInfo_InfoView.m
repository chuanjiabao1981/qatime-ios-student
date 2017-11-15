
//
//  VideoClassInfo_InfoView.m
//  Qatime_Student
//
//  Created by Shin on 2017/11/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassInfo_InfoView.h"
#import "NSString+HTML.h"
#import "NSAttributedString+YYText.h"
#import "NSMutableAttributedString+NIM.h"

@implementation VideoClassInfo_InfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentSize = CGSizeMake(self.width_sd, 100);
        
        /* -课程介绍页- */
        UILabel *desLabel = [[UILabel alloc]init];
        desLabel.font = TITLEFONTSIZE;
        [self addSubview:desLabel];
        desLabel.textColor = [UIColor blackColor];
        desLabel.text = @"基本属性";
        desLabel.sd_layout
        .leftSpaceToView(self,10)
        .topSpaceToView(self,10)
        .autoHeightRatio(0);
        [desLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 年级*/
        UIImageView *book1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book1];
        
        book1.sd_layout
        .leftEqualToView(desLabel);
        
        _gradeLabel =[[UILabel alloc]init];
        _gradeLabel.font = TEXT_FONTSIZE;
        _gradeLabel.textColor = TITLECOLOR;
        [self addSubview:_gradeLabel];
        _gradeLabel.sd_layout
        .leftSpaceToView(book1,5)
        .topSpaceToView(desLabel,10)
        .autoHeightRatio(0);
        [_gradeLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_gradeLabel updateLayout];
        
        book1.sd_layout
        .heightRatioToView(_gradeLabel,0.6)
        .centerYEqualToView(_gradeLabel)
        .widthEqualToHeight();
        [book1 updateLayout];
        
        /* 科目*/
        UIImageView *book2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book2];
        book2.sd_layout
        .centerXEqualToView(self)
        .topEqualToView(book1)
        .bottomEqualToView(book1)
        .widthEqualToHeight();
        
        _subjectLabel = [[UILabel alloc]init];
        _subjectLabel.font = TEXT_FONTSIZE;
        _subjectLabel.textColor = TITLECOLOR;
        [self addSubview:_subjectLabel];
        _subjectLabel.sd_layout
        .topEqualToView(_gradeLabel)
        .bottomEqualToView(_gradeLabel)
        .leftSpaceToView(book2,5);
        [_subjectLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        
        /* 课时*/
        UIImageView *book3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book3];
        book3.sd_layout
        .leftEqualToView(book1);
        
        _classCount=[[UILabel alloc]init];
        _classCount.font = TEXT_FONTSIZE;
        _classCount.textColor = TITLECOLOR;
        [self addSubview:_classCount];
        _classCount.sd_layout
        .leftEqualToView(_gradeLabel)
        .topSpaceToView(_gradeLabel,10)
        .autoHeightRatio(0);
        [_classCount setSingleLineAutoResizeWithMaxWidth:150];
        
        book3.sd_layout
        .centerYEqualToView(_classCount)
        .heightRatioToView(_classCount,0.6)
        .widthEqualToHeight();
        [book3 updateLayout];
        
        /* 视频时长*/
        UIImageView *clock  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:clock];
        clock.sd_layout
        .leftEqualToView(book3);
        
        _liveTimeLabel = [[UILabel alloc]init];
        [self addSubview:_liveTimeLabel];
        _liveTimeLabel.font = TEXT_FONTSIZE;
        _liveTimeLabel.textColor = TITLECOLOR;
        _liveTimeLabel.sd_layout
        .leftEqualToView(_classCount)
        .topSpaceToView(_classCount,10)
        .autoHeightRatio(0);
        [_liveTimeLabel setSingleLineAutoResizeWithMaxWidth:300];
        
        clock.sd_layout
        .centerYEqualToView(_liveTimeLabel)
        .heightRatioToView(_liveTimeLabel,0.6)
        .widthEqualToHeight();
        [clock updateLayout];
        
        
        //课程目标
        UILabel *taget = [[UILabel alloc]init];
        [self addSubview:taget];
        taget.textColor = [UIColor blackColor];
        taget.font = TITLEFONTSIZE;
        taget.text = @"课程目标";
        taget.sd_layout
        .leftEqualToView(desLabel)
        .topSpaceToView(_liveTimeLabel,20)
        .autoHeightRatio(0);
        [taget setSingleLineAutoResizeWithMaxWidth:100];
        
        _classTarget = [[UILabel alloc]init];
        [self addSubview:_classTarget];
        _classTarget.font = TEXT_FONTSIZE;
        _classTarget.textColor = TITLECOLOR;
        
        _classTarget.sd_layout
        .topSpaceToView(taget,10)
        .leftEqualToView(taget)
        .rightSpaceToView(self,20)
        .autoHeightRatio(0);
        
        
        //适合人群
        UILabel *suit = [[UILabel alloc]init];
        [self addSubview:suit];
        suit.font = TITLEFONTSIZE;
        suit.textColor = [UIColor blackColor];
        suit.text = @"适合人群";
        suit.sd_layout
        .leftEqualToView(taget)
        .topSpaceToView(_classTarget,20)
        .autoHeightRatio(0);
        [suit setSingleLineAutoResizeWithMaxWidth:100];
        
        _suitable = [[UILabel alloc]init];
        _suitable.font = TEXT_FONTSIZE;
        _suitable.textColor = TITLECOLOR;
        _suitable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_suitable];
        _suitable.sd_layout
        .leftEqualToView(suit)
        .topSpaceToView(suit,10)
        .autoHeightRatio(0)
        .rightSpaceToView(self,20);
        
        
        /* 辅导简介*/
        _descriptions=[[UILabel alloc]init];
        _descriptions.font = TITLEFONTSIZE;
        [self addSubview:_descriptions];
        _descriptions.sd_layout
        .leftEqualToView(suit)
        .topSpaceToView(_suitable,20)
        .autoHeightRatio(0);
        [_descriptions setSingleLineAutoResizeWithMaxWidth:100];
        [_descriptions setText:@"详细说明"];
        
        _classDescriptionLabel =[UILabel new];
        _classDescriptionLabel.font = TITLEFONTSIZE;
        _classDescriptionLabel.isAttributedContent = YES;
        [self addSubview:_classDescriptionLabel];
        _classDescriptionLabel.sd_layout
        .leftEqualToView(_descriptions)
        .topSpaceToView(_descriptions,20)
        .autoHeightRatio(0)
        .rightSpaceToView(self,20);
        
        //学习须知
        UILabel *notice = [[UILabel alloc]init];
        [self addSubview:notice];
        notice.text = @"学习须知";
        notice.textColor = [UIColor blackColor];
        notice.font = TITLEFONTSIZE;
        notice.sd_layout
        .leftEqualToView(_descriptions)
        .topSpaceToView(_descriptions,20)
        .autoHeightRatio(0);
        [notice setSingleLineAutoResizeWithMaxWidth:100];
        
        //说明的富文本设置
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = 5;
        NSDictionary *attribute = @{NSFontAttributeName:TEXT_FONTSIZE,
                                    NSParagraphStyleAttributeName:style};
        
        //购买
        UILabel *before = [[UILabel alloc]init];
        before.text = @"购买";
        before.font = TITLEFONTSIZE;
        [self addSubview:before];
        before.sd_layout
        .leftEqualToView(notice)
        .topSpaceToView(notice,10)
        .autoHeightRatio(0);
        [before setSingleLineAutoResizeWithMaxWidth:100];
        
        UILabel *beforeLabel = [[UILabel alloc]init];
        [self addSubview:beforeLabel];
        beforeLabel.font = TEXT_FONTSIZE;
        beforeLabel.textColor = TITLECOLOR;
        beforeLabel.textAlignment = NSTextAlignmentLeft;
        beforeLabel.isAttributedContent = YES;
        
        beforeLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:@"1、视频课是以学生自主观看视频进行独立学习的课程模式。\n2、视频课一经购买后永久有效，不限观看时间和观看次数；方便学生进行重复学习。\n3、视频课属一次性销售课程，不能重复购买，亦不支持（暂时）退款。\n4、视频课禁止下载或转录！"  attributes:attribute];
        
        beforeLabel.sd_layout
        .topSpaceToView(before,10)
        .leftEqualToView(before)
        .rightSpaceToView(self,20)
        .autoHeightRatio(0);
        
        
        //观看
        UILabel *during = [[UILabel alloc]init];
        during.text = @"观看";
        during.font = TITLEFONTSIZE;
        
        [self addSubview:during];
        during.sd_layout
        .leftEqualToView(beforeLabel)
        .topSpaceToView(beforeLabel,20)
        .autoHeightRatio(0);
        [during setSingleLineAutoResizeWithMaxWidth:100];
        
        UILabel *duringLabel = [[UILabel alloc]init];
        [self addSubview:duringLabel];
        duringLabel.font = TEXT_FONTSIZE;
        duringLabel.textColor = TITLECOLOR;
        duringLabel.textAlignment = NSTextAlignmentLeft;
        duringLabel.isAttributedContent = YES;
        duringLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:@"1、视频课观看无需使用客户端，网页即可播放。\n2、上课途中如突遇屏幕卡顿，视频缓冲等情况，请检查网络状态后刷新页面。\n3、观看过程中请做好笔记，能够帮助学生快速掌握视频中的知识。\n4、学习结束后请尽量关闭视频，以免过多占用网络资源影响您浏览其他内容。" attributes:attribute];
        duringLabel.sd_layout
        .topSpaceToView(during,10)
        .leftEqualToView(beforeLabel)
        .rightSpaceToView(self,20)
        .autoHeightRatio(0);
        
        //sdautolayout 自适应scrollview的contentsize 方法
        [self setupAutoContentSizeWithBottomView:duringLabel bottomMargin:20];
        
    }
    return self;
}

/**页面赋值*/
-(void)setModel:(VideoClassInfo *)model{
    
    _model = model;
    _gradeLabel.text = model.grade;
    _subjectLabel.text = model.subject;
    _classCount.text = [NSString stringWithFormat:@"共%@课",model.video_lessons_count];
    _liveTimeLabel.text = [self getMMSSFromSS:[NSString stringWithFormat:@"视频总长%@",model.total_duration]];
    _classTarget.text = model.objective;
    _suitable.text = model.suit_crowd;
    NSMutableAttributedString *attDesc;
    if (model.descriptions) {
        if ([[NSString getPureStringwithHTMLString:model.descriptions]isEqualToString:model.descriptions]) {
            //不包html富文本
            _classDescriptionLabel.text = model.descriptions;
            _classDescriptionLabel.isAttributedContent = NO;
        }else{
            attDesc = [[NSMutableAttributedString alloc]initWithData:[model.descriptions?[@"" stringByAppendingString:model.descriptions]:@" " dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            if ([attDesc.yy_font.familyName isEqualToString:@"Times New Roman"]&& attDesc.yy_font.pointSize == 12) {
                attDesc.yy_font = [UIFont fontWithName:@".SF UI Text" size:16*ScrenScale];
                attDesc.yy_color = TITLECOLOR;
            }else if ([attDesc.yy_font.familyName isEqualToString:@"Times New Roman"]&&attDesc.yy_font.pointSize != 12){
                attDesc.yy_font = [UIFont fontWithName:@".SF UI Text" size:attDesc.yy_font.pointSize];
                attDesc.yy_color = TITLECOLOR;
            }
            //判断是否有字号,没有的话加上.
            _classDescriptionLabel.attributedText = attDesc;
            _classDescriptionLabel.isAttributedContent = YES;
        }
    }
    [_classDescriptionLabel updateLayout];
    
}

//传入 秒  得到 xx:xx:xx
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    NSString *format_time;
    if (seconds>60) {
        
        //format of hour
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
        //format of minute
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
        //format of second
        NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
        //format of time
        format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    }else{
        format_time = [NSString stringWithFormat:@"00:00:%02ld",seconds];
    }
    
    return format_time;
}

@end
