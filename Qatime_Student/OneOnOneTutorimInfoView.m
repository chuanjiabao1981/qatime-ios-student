//
//  OneOnOneTutorimInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/31.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "OneOnOneTutorimInfoView.h"
#import "UIImageView+WebCache.h"

@interface OneOnOneTutorimInfoView ()

@end

@implementation OneOnOneTutorimInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        /* 课程名称*/
        _className = [[UILabel alloc]init];
        [self addSubview:_className];
        _className.sd_layout
        .leftSpaceToView(self,10)
        .rightSpaceToView(self, 10)
        .topSpaceToView(self,20)
        .autoHeightRatio(0);
        [_className setTextColor:[UIColor blackColor]];
        [_className setFont:TITLEFONTSIZE];
        
        //课程特色
        UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc]init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 0;
        _classFeature = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _classFeature.backgroundColor = [UIColor whiteColor];
        [self addSubview:_classFeature];
        _classFeature.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_className, 10)
        .heightIs(20);

        
        /* 价格*/
        _priceLabel=[[UILabel alloc]init];
        [self addSubview:_priceLabel];
        _priceLabel.sd_layout
        .topSpaceToView(_classFeature,10)
        .leftEqualToView(_className)
        .autoHeightRatio(0);
        [_priceLabel setSingleLineAutoResizeWithMaxWidth:500];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        [_priceLabel setTextColor:NAVIGATIONRED];
        [_priceLabel setFont:[UIFont systemFontOfSize:16*ScrenScale]];

        /* 分割线1*/
        UIView *line1 = [[UIView alloc]init];
        [self addSubview:line1];
        line1.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .topSpaceToView(_priceLabel,10)
        .heightIs(1.0f);
        [line1 updateLayout];
        /* 滑动控制器*/
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"课程介绍",@"教师组",@"上课安排"]];
        [self addSubview:_segmentControl];
        _segmentControl.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(line1,5)
        .heightIs(30);
        [_segmentControl updateLayout];
        
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.borderType = HMSegmentedControlTypeText;
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentControl.selectionIndicatorColor = NAVIGATIONRED ;
        _segmentControl.borderType = HMSegmentedControlBorderTypeTop | HMSegmentedControlBorderTypeBottom;
        _segmentControl.borderWidth = 0.5;
        _segmentControl.borderColor = SEPERATELINECOLOR_2;
        _segmentControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15*ScrenScale]};
        _segmentControl.selectionIndicatorHeight = 2;
        [_segmentControl updateLayout];
        
        /* 大滑动页面*/
        _scrollView = [[UIScrollView alloc]init];
        [self addSubview: _scrollView ];
        _scrollView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_segmentControl,0)
        .heightIs(self.height_sd-_segmentControl.bottom_sd);
        
        [_scrollView updateLayout];
        _scrollView.contentSize = CGSizeMake(self.width_sd*3,_scrollView.height_sd );
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        
        /* 分割线2*/
        UIView *line2 =[[UIView alloc]init];
        [self addSubview:line2];
        line2.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(_segmentControl,0).heightIs(0.8f);
        
        /* 分出三个view，放不同的label，用作布局参考*/
        
        _view1 =[[UIScrollView alloc]init];
        
        [_scrollView addSubview:_view1];
        
        _view1.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topEqualToView(_scrollView).bottomEqualToView(_scrollView);
        _view1.backgroundColor = [UIColor whiteColor];
        _view1.contentSize = CGSizeMake(self.width_sd, 500);
        
        
        /** -课程介绍页- */
        UILabel *desLabel = [[UILabel alloc]init];
        desLabel.font = TITLEFONTSIZE;
        [_view1 addSubview:desLabel];
        desLabel.textColor = [UIColor blackColor];
        desLabel.text = @"基本属性";
        desLabel.sd_layout
        .leftSpaceToView(_view1,10)
        .topSpaceToView(_view1,10)
        .autoHeightRatio(0);
        [desLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        
        /* 年级*/
        UIImageView *book1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [_view1 addSubview:book1];
        
        book1.sd_layout
        .leftEqualToView(desLabel);
        
        _gradeLabel =[[UILabel alloc]init];
        _gradeLabel.font = TEXT_FONTSIZE;
        _gradeLabel.textColor = TITLECOLOR;
        [_view1 addSubview:_gradeLabel];
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
        [_view1 addSubview:book2];
        book2.sd_layout
        .centerXEqualToView(_view1)
        .topEqualToView(book1)
        .bottomEqualToView(book1)
        .widthEqualToHeight();
        
        _subjectLabel = [[UILabel alloc]init];
        _subjectLabel.font = TEXT_FONTSIZE;
        _subjectLabel.textColor = TITLECOLOR;
        [_view1 addSubview:_subjectLabel];
        _subjectLabel.sd_layout
        .topEqualToView(_gradeLabel)
        .bottomEqualToView(_gradeLabel)
        .leftSpaceToView(book2,5);
        [_subjectLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        
        
        /**总分钟数*/
        _totalMinutesLabel = [[UILabel alloc]init];
        _totalMinutesLabel.font = TEXT_FONTSIZE;
        _totalMinutesLabel.textColor = TITLECOLOR;
        [_view1 addSubview:_totalMinutesLabel];
        _totalMinutesLabel.sd_layout
        .leftEqualToView(_gradeLabel)
        .topSpaceToView(_gradeLabel, 10)
        .autoHeightRatio(0);
        [_totalMinutesLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        UIImageView *book3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [_view1 addSubview:book3];
        book3.sd_layout
        .leftEqualToView(book1)
        .rightEqualToView(book1)
        .centerYEqualToView(_totalMinutesLabel)
        .heightRatioToView(_totalMinutesLabel, 0.6);
        
        //每节课的时长
        
        _minutesLabel = [[UILabel alloc]init];
        _minutesLabel.font = TEXT_FONTSIZE;
        _minutesLabel.textColor = TITLECOLOR;
        [_view1 addSubview:_minutesLabel];
        _minutesLabel.sd_layout
        .leftEqualToView(_subjectLabel)
        .topSpaceToView(_subjectLabel, 10)
        .autoHeightRatio(0);
        [_minutesLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        UIImageView *book4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [_view1 addSubview:book4];
        book4.sd_layout
        .leftEqualToView(book2)
        .rightEqualToView(book2)
        .centerYEqualToView(_minutesLabel)
        .heightRatioToView(_minutesLabel, 0.6);
        
        
        //总课时
        _classCount= [[UILabel alloc]init];
        _classCount.font = TEXT_FONTSIZE;
        _classCount.textColor = TITLECOLOR;
        [_view1 addSubview:_classCount];
        _classCount.sd_layout
        .leftEqualToView(_totalMinutesLabel)
        .topSpaceToView(_totalMinutesLabel, 10)
        .autoHeightRatio(0);
        [_classCount setSingleLineAutoResizeWithMaxWidth:100];
        
        UIImageView *book5 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [_view1 addSubview:book5] ;
        book5.sd_layout
        .leftEqualToView(book3)
        .rightEqualToView(book3)
        .centerYEqualToView(_classCount)
        .heightRatioToView(_classCount, 0.6);
        
        //适合人群
        UILabel *suit = [[UILabel alloc]init];
        [_view1 addSubview:suit];
        suit.font = TITLEFONTSIZE;
        suit.textColor = [UIColor blackColor];
        suit.text = @"适合人群";
        suit.sd_layout
        .leftEqualToView(book5)
        .topSpaceToView(_classCount,20)
        .autoHeightRatio(0);
        [suit setSingleLineAutoResizeWithMaxWidth:100];
        
        _suitable = [[UILabel alloc]init];
        _suitable.font = TEXT_FONTSIZE;
        _suitable.textColor = TITLECOLOR;
        _suitable.textAlignment = NSTextAlignmentLeft;
        [_view1 addSubview:_suitable];
        _suitable.sd_layout
        .leftEqualToView(suit)
        .topSpaceToView(suit,10)
        .autoHeightRatio(0)
        .rightSpaceToView(_view1,20);
        
        
        //课程目标
        UILabel *taget = [[UILabel alloc]init];
        [_view1 addSubview:taget];
        taget.textColor = [UIColor blackColor];
        taget.font = TITLEFONTSIZE;
        taget.text = @"课程目标";
        taget.sd_layout
        .leftEqualToView(suit)
        .topSpaceToView(_suitable,20)
        .autoHeightRatio(0);
        [taget setSingleLineAutoResizeWithMaxWidth:100];
        
        _classTarget = [[UILabel alloc]init];
        [_view1 addSubview:_classTarget];
        _classTarget.font = TEXT_FONTSIZE;
        _classTarget.textColor = TITLECOLOR;
        
        _classTarget.sd_layout
        .topSpaceToView(taget,10)
        .leftEqualToView(taget)
        .rightSpaceToView(_view1,20)
        .autoHeightRatio(0);
        
        
        
        /* 辅导简介*/
        _descriptions=[[UILabel alloc]init];
        _descriptions.font = TITLEFONTSIZE;
        [_view1 addSubview:_descriptions];
        _descriptions.sd_layout
        .leftEqualToView(suit)
        .topSpaceToView(_classTarget,20)
        .autoHeightRatio(0);
        [_descriptions setSingleLineAutoResizeWithMaxWidth:100];
        [_descriptions setText:@"详细说明"];
        
        _classDescriptionLabel =[UILabel new];
        _classDescriptionLabel.font = TITLEFONTSIZE;
        _classDescriptionLabel.isAttributedContent = YES;
        [_view1 addSubview:_classDescriptionLabel];
        _classDescriptionLabel.sd_layout
        .leftEqualToView(_descriptions)
        .topSpaceToView(_descriptions,20)
        .autoHeightRatio(0)
        .rightSpaceToView(_view1,20);
        
        //上课流程
        UILabel *workFlow = [[UILabel alloc]init];
        [_view1 addSubview:workFlow];
        workFlow.text = @"上课流程";
        workFlow.textColor = [UIColor blackColor];
        workFlow.font = TITLEFONTSIZE;
        workFlow.sd_layout
        .leftEqualToView(_descriptions)
        .topSpaceToView(_classDescriptionLabel,20)
        .autoHeightRatio(0);
        [workFlow setSingleLineAutoResizeWithMaxWidth:100];
        
        _workFlowView = [[WorkFlowView alloc]init];
        _workFlowView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _workFlowView.backgroundColor = [UIColor whiteColor];
        [_view1 addSubview:_workFlowView];
        _workFlowView.sd_layout
        .leftSpaceToView(_view1, 50*ScrenScale)
        .rightSpaceToView(_view1, 50*ScrenScale)
        .topSpaceToView(workFlow, 20*ScrenScale)
        .heightIs((self.view1.width_sd - 100*ScrenScale)*4);
        
        
        //学习须知
        UILabel *notice = [[UILabel alloc]init];
        [_view1 addSubview:notice];
        notice.text = @"学习须知";
        notice.textColor = [UIColor blackColor];
        notice.font = TITLEFONTSIZE;
        notice.sd_layout
        .leftEqualToView(_descriptions)
        .topSpaceToView(_workFlowView,20)
        .autoHeightRatio(0);
        [notice setSingleLineAutoResizeWithMaxWidth:100];
        
        //说明的富文本设置
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = 5;
        NSDictionary *attribute = @{NSFontAttributeName:TEXT_FONTSIZE,
                                    NSParagraphStyleAttributeName:style};
        
        //上课前
        UILabel *before = [[UILabel alloc]init];
        before.text = @"上课前";
        before.font = TITLEFONTSIZE;
        [_view1 addSubview:before];
        before.sd_layout
        .leftEqualToView(notice)
        .topSpaceToView(notice,10)
        .autoHeightRatio(0);
        [before setSingleLineAutoResizeWithMaxWidth:100];
        
        UILabel *beforeLabel = [[UILabel alloc]init];
        [_view1 addSubview:beforeLabel];
        beforeLabel.font = TEXT_FONTSIZE;
        beforeLabel.textColor = TITLECOLOR;
        beforeLabel.textAlignment = NSTextAlignmentLeft;
        beforeLabel.isAttributedContent = YES;
        
        beforeLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:@"1、做好课程预习，预先了解本课所讲内容，更好的吸收课程精华；\n2、准备好相关的学习工具（如：纸、笔等）并在上课前调试好电脑，使用手机请保持电量充足。\n3、选择安静的学习环境，并将与学习无关的事物置于远处；选择安静的环境避免影响听课。\n4、三年级以下的同学请在家长帮助下学习。\n5、遇到网页不能打开或者不能登陆等情况请及时联系客服。"  attributes:attribute];
        
        beforeLabel.sd_layout
        .topSpaceToView(before,10)
        .leftEqualToView(before)
        .rightSpaceToView(_view1,20)
        .autoHeightRatio(0);
        
        
        //上课中
        UILabel *during = [[UILabel alloc]init];
        during.text = @"上课中";
        during.font = TITLEFONTSIZE;
        
        [_view1 addSubview:during];
        during.sd_layout
        .leftEqualToView(beforeLabel)
        .topSpaceToView(beforeLabel,20)
        .autoHeightRatio(0);
        [during setSingleLineAutoResizeWithMaxWidth:100];
        
        UILabel *duringLabel = [[UILabel alloc]init];
        [_view1 addSubview:duringLabel];
        duringLabel.font = TEXT_FONTSIZE;
        duringLabel.textColor = TITLECOLOR;
        duringLabel.textAlignment = NSTextAlignmentLeft;
        duringLabel.isAttributedContent = YES;
        duringLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:@"1、时刻保持注意力集中，认真听讲才能更好的提升学习；\n2、课程中遇到听不懂的问题及时通过聊天或互动申请向老师提问，老师收到后会给予解答；\n3、积极响应老师的授课，完成老师布置的课上任务；\n4、禁止在上课中闲聊或发送一切与本课无关的内容，如有发现，一律禁言；\n5、上课途中如突遇屏幕卡顿，直播中断等特殊情况，请刷新后等待直播恢复；超过15分钟未恢复去请致电客服。" attributes:attribute];
        
        duringLabel.sd_layout
        .topSpaceToView(during,10)
        .leftEqualToView(beforeLabel)
        .rightSpaceToView(_view1,20)
        .autoHeightRatio(0);
        
        //上课后
        UILabel *after = [[UILabel alloc]init];
        after.text = @"上课后";
        after.font = TITLEFONTSIZE;
        
        [_view1 addSubview:after];
        after.sd_layout
        .leftEqualToView(during)
        .topSpaceToView(duringLabel,20)
        .autoHeightRatio(0);
        [after setSingleLineAutoResizeWithMaxWidth:100];
        
        UILabel *afterLabel = [[UILabel alloc]init];
        [_view1 addSubview:afterLabel];
        afterLabel.font = TEXT_FONTSIZE;
        afterLabel.textColor = TITLECOLOR;
        afterLabel.textAlignment = NSTextAlignmentLeft;
        afterLabel.isAttributedContent = YES;
        afterLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:@"1、直播结束后请大家仍可以在直播教室内进行聊天和讨论，老师也会适时解答；\n2、请同学按时完成老师布置的作业任务。" attributes:attribute];
        afterLabel.sd_layout
        .topSpaceToView(after,10)
        .leftEqualToView(duringLabel)
        .rightSpaceToView(_view1,20)
        .autoHeightRatio(0);
        
        UILabel *_replay = [[UILabel alloc]init];
        _replay.text = @"回放说明";
        _replay.font = TITLEFONTSIZE;
        
        [_view1 addSubview:_replay];
        _replay.sd_layout
        .leftEqualToView(during)
        .topSpaceToView(afterLabel,20)
        .autoHeightRatio(0);
        [_replay setSingleLineAutoResizeWithMaxWidth:100];
        
        UILabel *_replayLabel = [[UILabel alloc]init];
        [_view1 addSubview:_replayLabel];
        _replayLabel.font = TEXT_FONTSIZE;
        _replayLabel.textColor = TITLECOLOR;
        _replayLabel.textAlignment = NSTextAlignmentLeft;
        _replayLabel.isAttributedContent = YES;
        _replayLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:@"1、购买课程后方可观看回放。\n2、直播课回放学生可以免费观看最多10天，同一天不限定观看次数。\n3、直播结束后最晚于24小时内上传回放。\n4、回放内容不完全等于直播内容，请尽量观看直播学习。\n5、回放内容仅供学生学习使用，未经允许不得进行录制。" attributes:attribute];
        _replayLabel.sd_layout
        .topSpaceToView(_replay,10)
        .leftEqualToView(afterLabel)
        .rightSpaceToView(_view1,20)
        .autoHeightRatio(0);
        
        //sdautolayout 自适应scrollview的contentsize 方法
        [_view1 setupAutoContentSizeWithBottomView:_replayLabel bottomMargin:40];
        
        /* 教师组成员 。。。view2*/
        _teachersGroupTableView = [[UITableView alloc]init];
        [_scrollView addSubview:_teachersGroupTableView];
        _teachersGroupTableView.sd_layout
        .leftSpaceToView(_view1, 0)
        .topEqualToView(_view1)
        .bottomEqualToView(_view1)
        .widthRatioToView(_view1, 1.0);
        
        /**课程列表*/
        _classListTableView = [[UITableView alloc]init];
        _classListTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width_sd, CGFLOAT_MIN)];
        _classListTableView.tableFooterView = [[UIView alloc]init];
        [_scrollView addSubview:_classListTableView];
        _classListTableView.sd_layout
        .leftSpaceToView(_teachersGroupTableView, 0)
        .topEqualToView(_teachersGroupTableView)
        .bottomEqualToView(_teachersGroupTableView)
        .widthRatioToView(_teachersGroupTableView, 1.0);
        
        [_scrollView setupAutoContentSizeWithRightView:_classListTableView rightMargin:0];

        
    }

    return self;
}

//model 直接赋值方法
- (void)setModel:(OneOnOneClass *)model{
    
    _model = model;
    
    _className.text = model.name;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
    _gradeLabel.text = model.grade;
    _subjectLabel.text = model.subject;
    
    _totalMinutesLabel.text = @"共450分钟";
    _minutesLabel.text = @"45分钟/课";
    _classCount.text = [NSString stringWithFormat:@"共%@课",model.lessons_count];
    
    _suitable.text = model.suit_crowd;
    _classTarget.text = model.objective;

    _classDescriptionLabel.attributedText = model.attributeDescriptions;
    
    
}




@end
