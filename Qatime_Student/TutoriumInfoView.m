//
//  TutoriumInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "TutoriumInfoView.h"
#import "UIColor+HcdCustom.h"
#import "UICollectionViewLeftAlignedLayout.h"

#define SCREENWIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREENHEIGHT CGRectGetHeight(self.frame)

//#define SCREENWIDTHx2 (CGRectGetWidth(self.frame)*2)
//#define SCREENWIDTHx3 (CGRectGetWidth(self.frame)*3)



@interface TutoriumInfoView (){
    
    
    
}

@end

@implementation TutoriumInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        
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
        
        
       //课程状态
        _status = [[UILabel alloc]init];
        [self addSubview:_status];
        _status.font = TEXT_FONTSIZE;
        _status.textColor = [UIColor whiteColor];
        _status.sd_layout
        .leftEqualToView(_className)
        .topSpaceToView(_className, 10)
        .autoHeightRatio(0);
        [_status setSingleLineAutoResizeWithMaxWidth:200];
    
        
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
        .topSpaceToView(_status, 10)
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
        
        /* 报名人数*/
        _saleNumber = [[UILabel alloc]init];
        _saleNumber.font = [UIFont systemFontOfSize:16*ScrenScale];
        _saleNumber.textColor = TITLECOLOR;
        _saleNumber.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_saleNumber];
        _saleNumber.sd_layout
        .bottomEqualToView(_priceLabel)
        .rightSpaceToView(self,10)
        .autoHeightRatio(0);
        [_saleNumber setSingleLineAutoResizeWithMaxWidth:200];
        
        /* 分割线1*/
        
        UIView *line1 = [[UIView alloc]init];
        [self addSubview:line1];
        
        line1.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .topSpaceToView(_saleNumber,10)
        .heightIs(1.0f);
        [line1 updateLayout];
        
        /* 滑动控制器*/
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"课程介绍",@"教师资料",@"上课安排"]];
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
        _segmentControl.borderWidth = 0.6;
        _segmentControl.borderColor = SEPERATELINECOLOR_2;
        _segmentControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15*ScrenScale]};
        [_segmentControl updateLayout];
        
        /* 大滑动页面*/
        _scrollView = [[UIScrollView alloc]init];
        [self addSubview: _scrollView ];
        _scrollView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_segmentControl,0)
        .bottomSpaceToView(self, 0);
        
        [_scrollView updateLayout];
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*3,_scrollView.height_sd );
        
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [_scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), 200) animated:NO];
        _scrollView.backgroundColor = [UIColor whiteColor];
        
        /* 分割线2*/
        UIView *line2 =[[UIView alloc]init];
        [self addSubview:line2];
        line2.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(_segmentControl,0).heightIs(0.8f);
        
        /* 分出三个view，放不同的label，用作布局参考*/
        
        _view1 =[[UIScrollView alloc]init];
        
        [_scrollView addSubview:_view1];
        
        _view1.sd_layout
        .leftSpaceToView(_scrollView,0)
        .rightSpaceToView(_scrollView,0)
        .topEqualToView(_scrollView)
        .bottomSpaceToView(_scrollView, 0);
        _view1.backgroundColor = [UIColor whiteColor];
        _view1.contentSize = CGSizeMake(self.width_sd, 500);
        
        _view2 =[[UIScrollView alloc]init];
        [_scrollView addSubview:_view2];
        _view2.sd_layout
        .leftSpaceToView(_view1,0)
        .widthIs(SCREENWIDTH)
        .topEqualToView(_scrollView)
        .bottomSpaceToView(_scrollView, 0);
        _view2.backgroundColor = [UIColor whiteColor];
        
        _view2.contentSize = CGSizeMake(self.width_sd,500);
        
        _view3 =[[UIView alloc]init];
        [_scrollView addSubview:_view3];
        _view3.sd_layout
        .leftSpaceToView(_view2,0)
        .widthIs(SCREENWIDTH)
        .topEqualToView(_scrollView)
        .bottomSpaceToView(_scrollView, 0);
        _view3.backgroundColor = [UIColor whiteColor];
        
        [_scrollView setupAutoContentSizeWithRightView:_view3 rightMargin:0];
        [_scrollView setupAutoContentSizeWithBottomView:_view3 bottomMargin:0];
        
        /* -课程介绍页- */
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
        
        /* 课时*/
        UIImageView *book3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [_view1 addSubview:book3];
        book3.sd_layout
        .leftEqualToView(book1);
        
        _classCount=[[UILabel alloc]init];
        _classCount.font = TEXT_FONTSIZE;
        _classCount.textColor = TITLECOLOR;
        [_view1 addSubview:_classCount];
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
        
        /* 直播时间*/
        UIImageView *clock  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [_view1 addSubview:clock];
        clock.sd_layout
        .leftEqualToView(book3);
        
        _liveTimeLabel = [[UILabel alloc]init];
        [_view1 addSubview:_liveTimeLabel];
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
        
        
        /* 标签*/
        UILabel *tags = [[UILabel alloc]init];
        tags.text = @"课程标签";
        tags.textColor = [UIColor blackColor];
        tags.font = TITLEFONTSIZE;
        [_view1 addSubview:tags];
        tags.sd_layout
        .leftEqualToView(desLabel)
        .topSpaceToView(clock,20)
        .autoHeightRatio(0);
        [tags setSingleLineAutoResizeWithMaxWidth:100.0f];
        [tags updateLayout];
        
        
        //课程标签
        _classTagsView = [[TTGTextTagCollectionView alloc]init];
        _classTagsView.alignment = TTGTagCollectionAlignmentLeft;
        _classTagsView.enableTagSelection = NO;
        [_view1 addSubview:_classTagsView];
        _classTagsView.sd_layout
        .leftEqualToView(clock)
        .rightSpaceToView(_view1,20)
        .topSpaceToView(tags,10)
        .heightIs(200);
        
        //课程目标
        UILabel *taget = [[UILabel alloc]init];
        [_view1 addSubview:taget];
        taget.textColor = [UIColor blackColor];
        taget.font = TITLEFONTSIZE;
        taget.text = @"课程目标";
        taget.sd_layout
        .leftEqualToView(tags)
        .topSpaceToView(_classTagsView,20)
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
        
        
        //适合人群
        UILabel *suit = [[UILabel alloc]init];
        [_view1 addSubview:suit];
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
        [_view1 addSubview:_suitable];
        _suitable.sd_layout
        .leftEqualToView(suit)
        .topSpaceToView(suit,10)
        .autoHeightRatio(0)
        .rightSpaceToView(_view1,20);
        
        
        /* 辅导简介*/
        _descriptions=[[UILabel alloc]init];
        _descriptions.font = TITLEFONTSIZE;
        [_view1 addSubview:_descriptions];
        _descriptions.sd_layout
        .leftEqualToView(suit)
        .topSpaceToView(_suitable,20)
        .autoHeightRatio(0);
        [_descriptions setSingleLineAutoResizeWithMaxWidth:100];
        [_descriptions setText:@"辅导简介"];
        
        _classDescriptionLabel =[UILabel new];
        _classDescriptionLabel.font = TITLEFONTSIZE;
        _classDescriptionLabel.isAttributedContent = YES;
        [_view1 addSubview:_classDescriptionLabel];
        _classDescriptionLabel.sd_layout
        .leftEqualToView(_descriptions)
        .topSpaceToView(_descriptions,20)
        .autoHeightRatio(0)
        .rightSpaceToView(_view1,20);
        
        //学习流程
        UILabel *workFlow = [[UILabel alloc]init];
        [_view1 addSubview:workFlow];
        workFlow.text = @"学习流程";
        workFlow.textColor = [UIColor blackColor];
        workFlow.font = TITLEFONTSIZE;
        workFlow.sd_layout
        .leftEqualToView(_descriptions)
        .topSpaceToView(_classDescriptionLabel,20)
        .autoHeightRatio(0);
        [workFlow setSingleLineAutoResizeWithMaxWidth:100];
        
        _workFlowView = [[OneOnOneWorkFlowView alloc]init];
        _workFlowView.backgroundColor = [UIColor whiteColor];
        [_view1 addSubview:_workFlowView];
        _workFlowView.sd_layout
        .leftSpaceToView(_view1, 0)
        .rightSpaceToView(_view1, 0)
        .topSpaceToView(workFlow, 0)
        .heightEqualToWidth();
        
        [_workFlowView.line updateLayout];
        [_workFlowView clearAutoHeigtSettings];
        _workFlowView.sd_layout
        .heightIs(_workFlowView.line.bottom_sd);
        [_workFlowView updateLayout];
        
        
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
        
        
        //sdautolayout 自适应scrollview的contentsize 方法
        [_view1 setupAutoContentSizeWithBottomView:afterLabel bottomMargin:20];
        
        
        /* 教师简介 。。。view2*/
        
        /* 教师头像*/
        _teacherHeadImage = [[UIImageView alloc]init];
        _teacherHeadImage.userInteractionEnabled = YES;
        [_view2 addSubview:_teacherHeadImage];
        
        _teacherHeadImage.sd_layout
        .leftSpaceToView(_view2,10)
        .topSpaceToView(_view2,10)
        .widthIs(80)
        .heightEqualToWidth();
        _teacherHeadImage.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        
        //教师名
        _teacherNameLabel = [[UILabel alloc]init];
        _teacherNameLabel.font = TITLEFONTSIZE;
        [_view2 addSubview:_teacherNameLabel];
        _teacherNameLabel.sd_layout
        .leftSpaceToView(_teacherHeadImage,10)
        .centerYEqualToView(_teacherHeadImage)
        .autoHeightRatio(0);
        [_teacherNameLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 性别图标*/
        _genderImage  = [[UIImageView alloc]init];
        [_view2 addSubview:_genderImage];
        _genderImage .sd_layout
        .leftSpaceToView(_teacherNameLabel,10)
        .centerYEqualToView(_teacherNameLabel)
        .heightRatioToView(_teacherNameLabel,0.6)
        .widthEqualToHeight();
        
        
        /* 所在学校*/
        UILabel *schools =[[UILabel alloc]init];
        schools.font = TITLEFONTSIZE;
        [_view2 addSubview:schools];
        schools.sd_layout
        .leftEqualToView(_teacherHeadImage)
        .topSpaceToView(_teacherHeadImage,20)
        .autoHeightRatio(0);
        [schools setSingleLineAutoResizeWithMaxWidth:200];
        [schools setText:@"所在学校"];
        
        _workPlaceLabel =[[UILabel alloc]init];
        _workPlaceLabel.font = TEXT_FONTSIZE;
        _workPlaceLabel.textColor = TITLECOLOR;
        
        [_view2 addSubview:_workPlaceLabel];
        _workPlaceLabel.sd_layout
        .leftSpaceToView(_view2,20)
        .topSpaceToView(schools,10)
        .autoHeightRatio(0);
        [_workPlaceLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        /* 执教年数*/
        UILabel *workYears = [[UILabel alloc]init];
        workYears.font = TITLEFONTSIZE;
        [_view2 addSubview:workYears];
        workYears.sd_layout
        .leftEqualToView(schools)
        .topSpaceToView(_workPlaceLabel,20)
        .autoHeightRatio(0);
        [workYears setSingleLineAutoResizeWithMaxWidth:200];
        [workYears setText:@"执教年限"];
        
        _workYearsLabel = [[UILabel alloc]init];
        _workYearsLabel.font = TEXT_FONTSIZE;
        _workYearsLabel.textColor = TITLECOLOR;
        [_view2 addSubview:_workYearsLabel];
        _workYearsLabel.sd_layout
        .leftEqualToView(_workPlaceLabel)
        .topSpaceToView(workYears,10)
        .autoHeightRatio(0);
        [_workYearsLabel setSingleLineAutoResizeWithMaxWidth:200];

        
        //目前不做的教师标签
        UILabel *teacherTag = [[UILabel alloc]init];
        teacherTag.font = TITLEFONTSIZE;
        teacherTag.text = @"教师标签";
        [_view2 addSubview:teacherTag];
        teacherTag.sd_layout
        .leftEqualToView(workYears)
        .topSpaceToView(_workYearsLabel,20)
        .autoHeightRatio(0);
        [teacherTag setSingleLineAutoResizeWithMaxWidth:100];
        teacherTag.hidden = YES;
        
        //教师标签
        _teacherTagsView = [[TTGTextTagCollectionView alloc]init];
        _teacherTagsView.alignment = TTGTagCollectionAlignmentLeft;
        _teacherTagsView.enableTagSelection = NO;
        [_view2 addSubview:_teacherTagsView];
        _teacherTagsView.sd_layout
        .leftEqualToView(_workYearsLabel)
        .rightSpaceToView(_view2,20)
        .topSpaceToView(teacherTag,10)
        .heightIs(200);
        _teacherTagsView.hidden = YES;
        
        
        
        /* 教师简介*/
        _descrip =[[UILabel alloc]init];
        _descrip.font = TITLEFONTSIZE;
        [_view2 addSubview:_descrip];
        _descrip.sd_layout
        .leftEqualToView(workYears)
        .topSpaceToView(_workYearsLabel,20)
        .autoHeightRatio(0);
        [_descrip setSingleLineAutoResizeWithMaxWidth:200];
        _descrip.text = @"自我介绍";
        
        _teacherInterviewLabel =[UILabel new];
        _teacherInterviewLabel.font = TEXT_FONTSIZE;
        _teacherInterviewLabel.textColor = TITLECOLOR;
        _teacherInterviewLabel.isAttributedContent = YES;
        [_view2 addSubview:_teacherInterviewLabel];
        _teacherInterviewLabel.sd_layout
        .leftSpaceToView(_view2,20)
        .rightSpaceToView(_view2,20)
        .topSpaceToView(_descrip,20)
        .autoHeightRatio(0);
        
        //view2 滚动内容自适应
        [_view2 setupAutoContentSizeWithBottomView:_teacherInterviewLabel bottomMargin:20];
        
        /* 辅导课列表*/
        _classesListTableView = [[UITableView alloc]init];
        _classesListTableView.tableFooterView = [[UIView alloc]init];
        
        [_view3 addSubview:_classesListTableView];
        
        _classesListTableView.sd_layout.leftSpaceToView(_view3,0).rightSpaceToView(_view3,0).topSpaceToView(_view3,0).bottomSpaceToView(_view3,0);
        
        
        //scrollview横向自适应
//        [_scrollView setupAutoContentSizeWithRightView:_view3 rightMargin:0];
//        [_scrollView setupAutoContentSizeWithBottomView:_view3 bottomMargin:10];
        
        //视图自适应
//        [self setupAutoContentSizeWithBottomView:_scrollView bottomMargin:10];
        
        
    }
    return self;
}

@end
