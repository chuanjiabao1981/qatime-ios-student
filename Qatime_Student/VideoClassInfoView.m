//
//  VideoClassInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/11.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassInfoView.h"
#import "UIColor+HcdCustom.h"
#import "NSString+ChangeYearsToChinese.h"

#define SCREENWIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREENHEIGHT CGRectGetHeight(self.frame)
@implementation VideoClassInfoView

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
        
        //课程特色
        UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc]init];
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
        .topSpaceToView(_saleNumber,5)
        .heightIs(1.0f);
        
        
        /* 滑动控制器*/
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"课程介绍",@"教师资料",@"课时安排"]];
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
        _segmentControl.selectionIndicatorHeight = 2;
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
        
        _scrollView.contentSize = CGSizeMake(self.width_sd*3,_scrollView.height_sd);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.bounces = NO;
        
        /* 分割线2*/
        UIView *line2 =[[UIView alloc]init];
        [self addSubview:line2];
        line2.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(_segmentControl,0).heightIs(0.8f);
        
        /* 分出三个view，放不同的label，用作布局参考*/
        
        _view1 =[[UIScrollView alloc]init];
        
        [_scrollView addSubview:_view1];
        
        _view1.sd_layout
        .leftSpaceToView(_scrollView,0)
        .widthIs(self.width_sd)
        .topSpaceToView(_scrollView, 0)
        .bottomSpaceToView(_scrollView, 0);
        _view1.backgroundColor = [UIColor whiteColor];
        _view1.contentSize = CGSizeMake(self.width_sd, 500);
        
        _view2 =[[UIScrollView alloc]init];
        [_scrollView addSubview:_view2];
        _view2.sd_layout
        .leftSpaceToView(_view1,0)
        .widthIs(SCREENWIDTH)
        .topSpaceToView(_scrollView, 0)
        .bottomSpaceToView(_scrollView, 0);
        _view2.backgroundColor = [UIColor whiteColor];
        
        _view2.contentSize = CGSizeMake(self.width_sd,500);
        
        _view3 =[[UIView alloc]init];
        [_scrollView addSubview:_view3];
        _view3.sd_layout
        .leftSpaceToView(_view2,0)
        .widthIs(SCREENWIDTH)
        .topSpaceToView(_scrollView, 0)
        .bottomSpaceToView(_scrollView, 0);
        _view3.backgroundColor = [UIColor whiteColor];
        
        /* -课程介绍页- */
        UILabel *desLabel = [[UILabel alloc]init];
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
        
        /* 视频时长*/
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
        
        
        //课程目标
        UILabel *taget = [[UILabel alloc]init];
        [_view1 addSubview:taget];
        taget.textColor = [UIColor blackColor];
        taget.font = TITLEFONTSIZE;
        taget.text = @"课程目标";
        taget.sd_layout
        .leftEqualToView(desLabel)
        .topSpaceToView(_liveTimeLabel,20)
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
        
        
        //学习须知
        UILabel *notice = [[UILabel alloc]init];
        [_view1 addSubview:notice];
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
        
        beforeLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:@"1、视频课是以学生自主观看视频进行独立学习的课程模式。\n2、视频课一经购买后永久有效，不限观看时间和观看次数；方便学生进行重复学习。\n3、视频课属一次性销售课程，不能重复购买，亦不支持（暂时）退款。\n4、视频课禁止下载或转录！"  attributes:attribute];
        
        beforeLabel.sd_layout
        .topSpaceToView(before,10)
        .leftEqualToView(before)
        .rightSpaceToView(_view1,20)
        .autoHeightRatio(0);
        
        
        //观看
        UILabel *during = [[UILabel alloc]init];
        during.text = @"观看";
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
        duringLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:@"1、视频课观看无需使用客户端，网页即可播放。\n2、上课途中如突遇屏幕卡顿，视频缓冲等情况，请检查网络状态后刷新页面。\n3、观看过程中请做好笔记，能够帮助学生快速掌握视频中的知识。\n4、学习结束后请尽量关闭视频，以免过多占用网络资源影响您浏览其他内容。" attributes:attribute];
        duringLabel.sd_layout
        .topSpaceToView(during,10)
        .leftEqualToView(beforeLabel)
        .rightSpaceToView(_view1,20)
        .autoHeightRatio(0);
        
        //sdautolayout 自适应scrollview的contentsize 方法
        [_view1 setupAutoContentSizeWithBottomView:duringLabel bottomMargin:20];
        
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
        _classesListTableView.sd_layout
        .leftSpaceToView(_view3,0)
        .rightSpaceToView(_view3,0)
        .topSpaceToView(_view3,0)
        .bottomSpaceToView(_view3,0);
        
        [_scrollView setupAutoContentSizeWithRightView:_view3 rightMargin:0];
        [_scrollView setupAutoContentSizeWithBottomView:_view1 bottomMargin:0];
        
        
    }
    return self;
}


/**页面赋值*/
-(void)setModel:(VideoClassInfo *)model{
    
    _model = model;
    _className.text = model.name;
    
    if (model.price.floatValue!=0) {
        
        _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    }else{
        _priceLabel.text = @"免费";
    }
    _saleNumber.text = [NSString stringWithFormat:@"学习人数 %@",model.buy_tickets_count];
    
    _gradeLabel.text = model.grade;
    _subjectLabel.text = model.subject;
    _classCount.text = [NSString stringWithFormat:@"共%@课",model.video_lessons_count];
//    _liveTimeLabel.text = [NSString stringWithFormat:@"视频总长%@",model.视频长度];
    _classTarget.text = model.objective;
    _suitable.text = model.suit_crowd;
    //简介富文本
    _classDescriptionLabel.attributedText = [[NSMutableAttributedString alloc]initWithData:[model.description dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    [_teacherHeadImage sd_setImageWithURL:[NSURL URLWithString:model.teacher[@"avatar_url"]]];
    _teacherNameLabel.text = model.teacher[@"name"];
   
    if ([model.teacher[@"gender"] isEqual:[NSNull null]]) {
        
    }else{
        
        if ([model.teacher[@"gender"]isEqualToString:@"male"]) {
            [_genderImage setImage:[UIImage imageNamed:@"男"]];
        }else if([model.teacher[@"gender"]isEqualToString:@"female"]) {
            [_genderImage setImage:[UIImage imageNamed:@"女"]];
        }
    }
    
    _workPlaceLabel.text = [NSString stringWithFormat:@"%@",model.teacher[@"school"]];
    _workYearsLabel.text = [NSString stringWithFormat:@"%@",[model.teacher[@"teaching_years"] changeEnglishYearsToChinese]];
    _teacherInterviewLabel.attributedText = [[NSMutableAttributedString alloc]initWithData:[model.teacher[@"desc"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
}


@end
