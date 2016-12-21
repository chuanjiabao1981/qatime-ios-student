//
//  TutoriumInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "TutoriumInfoView.h"

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
        
        self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)*1.5);
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        
        /* 课程图*/
        _classImage = [[UIImageView alloc]init];
        [self addSubview:_classImage];
        _classImage.sd_layout.topSpaceToView(self,0).leftEqualToView(self).rightEqualToView(self).heightRatioToView(self,1.8/5.0f);
        [_classImage setImage:[UIImage imageNamed:@"school"]];
        
        
        /* 距开课时间*/
        _deadLine = [[UILabel alloc]init];
        [self addSubview:_deadLine];
        _deadLine.sd_layout.rightEqualToView(_classImage).bottomEqualToView(_classImage).autoHeightRatio(0);
        [_deadLine setSingleLineAutoResizeWithMaxWidth:200];
        [_deadLine setText:@""];
        [_deadLine setTextColor:[UIColor whiteColor]];
        [_deadLine setBackgroundColor:USERGREEN];
        
        
        /* 招生状态*/
        
        _recuitState = [[UILabel alloc]init];
        [self addSubview:_recuitState];
        _recuitState.sd_layout.rightSpaceToView(_deadLine,0).bottomEqualToView(_deadLine).heightRatioToView(_deadLine,1.0f);
        [_recuitState setSingleLineAutoResizeWithMaxWidth:100];
        [_recuitState setText:@""];
        [_recuitState setTextColor:[UIColor whiteColor]];
        [_recuitState setBackgroundColor:USERGREEN];
        
        /* 课程名称*/

        _className = [[UILabel alloc]init];
        [self addSubview:_className];
        _className.sd_layout.rightSpaceToView(self,10).leftSpaceToView(self,10).topSpaceToView(_classImage,5).autoHeightRatio(0);
        _className.textAlignment = NSTextAlignmentLeft;
        [_className setText:@"课程名称"];
        [_className setTextColor:[UIColor blackColor]];
        [_className setFont:[UIFont systemFontOfSize:20]];
        
        /* 价格*/
        _priceLabel=[[UILabel alloc]init];
        [self addSubview:_priceLabel];
        _priceLabel.sd_layout. topSpaceToView(_className,5).leftEqualToView(_className).autoHeightRatio(0);
        [_priceLabel setSingleLineAutoResizeWithMaxWidth:100];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        [_priceLabel setText:@"¥0.00"];
        [_priceLabel setTextColor:[UIColor redColor]];
        [_priceLabel setFont:[UIFont systemFontOfSize:18]];
        
        /* 报名人数*/

        _saleNumber = [[UILabel alloc]init];
        [self addSubview:_saleNumber];
        _saleNumber.sd_layout. bottomEqualToView(_priceLabel).rightSpaceToView(self,10).autoHeightRatio(0);
        [_saleNumber setSingleLineAutoResizeWithMaxWidth:100];
        _saleNumber.textAlignment = NSTextAlignmentLeft;
        [_saleNumber setText:@"100"];
        [_saleNumber setTextColor:[UIColor blackColor]];
        [_saleNumber setFont:[UIFont systemFontOfSize:18]];
        
        /* 报名人数 label*/
        
        UILabel *saleNum = [[UILabel alloc]init];
        [self addSubview:saleNum];
        saleNum.sd_layout. bottomEqualToView(_priceLabel).rightSpaceToView(_saleNumber,10).autoHeightRatio(0);
        [saleNum setSingleLineAutoResizeWithMaxWidth:100];
        saleNum.textAlignment = NSTextAlignmentLeft;
        [saleNum setTextColor:[UIColor blackColor]];
        [saleNum setFont:[UIFont systemFontOfSize:18]];
        [saleNum setText:@"报名人数"];
        
        /* 分割线1*/
        UIView *line1 = [[UIView alloc]init];
        [self addSubview:line1];
        line1.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(saleNum,5).heightIs(1.f);
        
        

        /* 滑动控制器*/
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"辅导概况",@"教师资料",@"课程安排"]];
        [self addSubview:_segmentControl];
        _segmentControl.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(line1,0).heightRatioToView(self,0.05);
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.borderType = HMSegmentedControlTypeText;
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentControl.borderType = HMSegmentedControlBorderTypeTop | HMSegmentedControlBorderTypeBottom;
        _segmentControl.borderWidth = 0.6;
        _segmentControl.borderColor = TITLECOLOR;
       
        
        /* 大滑动页面*/
        _scrollView = [[UIScrollView alloc]init];
        [self addSubview: _scrollView ];
        _scrollView.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(_segmentControl,0).heightRatioToView(self,1);
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*3, CGRectGetHeight(self.frame));
       _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [_scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), 200) animated:NO];
        
        /* 分割线2*/
        UIView *line2 =[[UIView alloc]init];
        [self addSubview:line2];
        line2.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(_segmentControl,0).heightIs(0.8f);
        
        
        /* 分出三个view，放不同的label，用作布局参考*/
        
        _view1 =[[UIView alloc]init];
        [_scrollView addSubview:_view1];
        _view1.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topEqualToView(_scrollView).bottomEqualToView(_scrollView);
        _view1.backgroundColor = [UIColor whiteColor];
        
        _view2 =[[UIView alloc]init];
        [_scrollView addSubview:_view2];
        _view2.sd_layout.leftSpaceToView(_view1,0).widthIs(SCREENWIDTH).topEqualToView(_scrollView).bottomEqualToView(_scrollView);
        _view2.backgroundColor = [UIColor whiteColor];
        
        
        _view3 =[[UIView alloc]init];
        [_scrollView addSubview:_view3];
        _view3.sd_layout.leftSpaceToView(_view2,0).widthIs(SCREENWIDTH).topEqualToView(_scrollView).bottomEqualToView(_scrollView);
        _view3.backgroundColor = [UIColor whiteColor];
        
        
        /* 辅导班概况 的所有label*/
        
        
        /* 科目*/
       
        _subjectLabel = [[UILabel alloc]init];
        [_view1 addSubview:_subjectLabel];
        _subjectLabel.sd_layout
        .topSpaceToView(_view1,20)
        .leftSpaceToView(_view1,20)
        .autoHeightRatio(0);
        [_subjectLabel setSingleLineAutoResizeWithMaxWidth:100.0f];

        
        UIView *circle1=[[UIView alloc]init];
        circle1.backgroundColor = TITLERED;
        [_view1 addSubview:circle1];
        circle1.sd_layout
        .rightSpaceToView(_subjectLabel,5)
        .centerYEqualToView(_subjectLabel)
        .heightRatioToView(_subjectLabel,0.3)
        .widthEqualToHeight();
        circle1.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
       
        /* 年级*/
        
        _gradeLabel =[[UILabel alloc]init];
        [_view1 addSubview:_gradeLabel];
        _gradeLabel.sd_layout
        .leftSpaceToView(_view1,self.width_sd/2)
        .topEqualToView(_subjectLabel)
        .autoHeightRatio(0);
        [_gradeLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        
        UIView *circle2=[[UIView alloc]init];
        circle2.backgroundColor = TITLERED;
        [_view1 addSubview:circle2];
        circle2.sd_layout
        .rightSpaceToView(_gradeLabel,5)
        .centerYEqualToView(_gradeLabel)
        .heightRatioToView(_gradeLabel,0.3)
        .widthEqualToHeight();
        circle2.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        

        /* 课时*/
        UILabel *counted =[[UILabel alloc]init];
        [_view1 addSubview:counted];
        counted.sd_layout.leftEqualToView(_subjectLabel).topSpaceToView(_subjectLabel,20).autoHeightRatio(0);
        [counted setSingleLineAutoResizeWithMaxWidth:100.0f];
        [counted setText:@"共"];
        
        UIView *circle3=[[UIView alloc]init];
        circle3.backgroundColor = TITLERED;
        [_view1 addSubview:circle3];
        circle3.sd_layout
        .rightSpaceToView(counted,5)
        .centerYEqualToView(counted)
        .heightRatioToView(counted,0.3)
        .widthEqualToHeight();
        circle3.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];

        
        
        _classCount=[[UILabel alloc]init];
        [_view1 addSubview:_classCount];
        _classCount.sd_layout.leftSpaceToView(counted,0).topEqualToView(counted).autoHeightRatio(0);
        [_classCount setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_classCount setText:@""];
        
        UILabel *classes=[[UILabel alloc]init];
        [_view1 addSubview:classes];
        classes.sd_layout.leftSpaceToView(_classCount,0).topEqualToView(counted).autoHeightRatio(0);
        [classes setSingleLineAutoResizeWithMaxWidth:100.0f];
        [classes setText:@"课时"];

        
        /* 在线直播*/
        _onlineVideoLabel =[[UILabel alloc]init];
        [_view1 addSubview:_onlineVideoLabel];
        _onlineVideoLabel.sd_layout.leftEqualToView(_gradeLabel).topEqualToView(counted).autoHeightRatio(0);
        [_onlineVideoLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_onlineVideoLabel setText:@"在线直播"];
        
        UIView *circle4=[[UIView alloc]init];
        circle4.backgroundColor = TITLERED;
        [_view1 addSubview:circle4];
        circle4.sd_layout
        .rightSpaceToView(_onlineVideoLabel,5)
        .centerYEqualToView(_onlineVideoLabel)
        .heightRatioToView(_onlineVideoLabel,0.3)
        .widthEqualToHeight();
        circle4.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];

        
        
        /* 直播时间*/
        
        _liveStartTimeLabel = [[UILabel alloc]init];
        [_view1 addSubview:_liveStartTimeLabel];
        _liveStartTimeLabel.sd_layout.leftEqualToView(counted).topSpaceToView(counted,20).autoHeightRatio(0);
        [_liveStartTimeLabel setSingleLineAutoResizeWithMaxWidth:300.0f];
        
        
        
        UIView *circle5=[[UIView alloc]init];
        circle5.backgroundColor = TITLERED;
        [_view1 addSubview:circle5];
        circle5.sd_layout
        .rightSpaceToView(_liveStartTimeLabel,5)
        .centerYEqualToView(_liveStartTimeLabel)
        .heightRatioToView(_liveStartTimeLabel,0.3)
        .widthEqualToHeight();
        circle5.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];

        UILabel *_to =[[UILabel alloc]init];
        [_view1 addSubview:_to];
        _to.sd_layout.leftSpaceToView(_liveStartTimeLabel,2).topEqualToView(_liveStartTimeLabel).autoHeightRatio(0);
        [_to setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_to setText:@"至"];
        
        _liveEndTimeLabel = [[UILabel alloc]init];
        [_view1 addSubview:_liveEndTimeLabel];
        _liveEndTimeLabel.sd_layout.leftSpaceToView(_to,2).topEqualToView(_liveStartTimeLabel).autoHeightRatio(0);
        [_liveEndTimeLabel setSingleLineAutoResizeWithMaxWidth:300.0f];
        [_liveEndTimeLabel setText:@""];

        
        
        /* 辅导简介*/
        UILabel *description=[[UILabel alloc]init];
        [_view1 addSubview:description];
        description.sd_layout.leftEqualToView(_subjectLabel).topSpaceToView(_to,20).autoHeightRatio(0);
        [description setSingleLineAutoResizeWithMaxWidth:100.0f];
        [description setText:@"辅导简介"];
        
        
        UIView *circle6=[[UIView alloc]init];
        circle6.backgroundColor = TITLERED;
        [_view1 addSubview:circle6];
        circle6.sd_layout
        .rightSpaceToView(description,5)
        .centerYEqualToView(description)
        .heightRatioToView(description,0.3)
        .widthEqualToHeight();
        circle6.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];


        _classDescriptionLabel =[[UILabel alloc]init];
        [_view1 addSubview:_classDescriptionLabel];
        _classDescriptionLabel.sd_layout.leftEqualToView(description).topSpaceToView(description,20).autoHeightRatio(0).rightSpaceToView(_view1,20);
        [_classDescriptionLabel setText:@""];
        
        
        /* 教师简介 。。。view2*/
        _teacherNameLabel = [[UILabel alloc]init];
        [_view2 addSubview:_teacherNameLabel];
        _teacherNameLabel.sd_layout.leftSpaceToView(_view2,20).topSpaceToView(_view2,20).autoHeightRatio(0);
        [_teacherNameLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        _teacherNameLabel.font = [UIFont systemFontOfSize:20];
        [_teacherNameLabel setText:@"教师姓名"];
        
        /* 执教年数*/
        UILabel *workYears = [[UILabel alloc]init];
        [_view2 addSubview:workYears];
        workYears.sd_layout.leftEqualToView(_teacherNameLabel).topSpaceToView(_teacherNameLabel,20).autoHeightRatio(0);
        [workYears setSingleLineAutoResizeWithMaxWidth:200];
        [workYears setText:@"执教年数"];
        
        _workYearsLabel = [[UILabel alloc]init];
        [_view2 addSubview:_workYearsLabel];
        _workYearsLabel.sd_layout.leftSpaceToView(workYears,20).topEqualToView(workYears).autoHeightRatio(0);
        [_workYearsLabel setSingleLineAutoResizeWithMaxWidth:200];
        _workYearsLabel.text = @"" ;
        
        
        /* 所在学校*/
        UILabel *schools =[[UILabel alloc]init];
        [_view2 addSubview:schools];
        schools.sd_layout.leftEqualToView(_teacherNameLabel).topSpaceToView(workYears,20).autoHeightRatio(0);
        [schools setSingleLineAutoResizeWithMaxWidth:200];
        [schools setText:@"所在学校"];
        
        _workPlaceLabel =[[UILabel alloc]init];
        [_view2 addSubview:_workPlaceLabel];
        _workPlaceLabel.sd_layout.leftSpaceToView(schools,20).topEqualToView(schools).autoHeightRatio(0);
        [_workPlaceLabel setSingleLineAutoResizeWithMaxWidth:200];
        _workPlaceLabel.text = @"" ;


        /* 教师简介*/
        UILabel *descrip =[[UILabel alloc]init];
        [_view2 addSubview:descrip];
        descrip.sd_layout.leftEqualToView(_teacherNameLabel).topSpaceToView(_workPlaceLabel,20).autoHeightRatio(0);
        [descrip setSingleLineAutoResizeWithMaxWidth:200];
        descrip.text = @"教师简介";
        
        _teacherInterviewLabel =[[UILabel alloc]init];
        [_view2 addSubview:_teacherInterviewLabel];
        _teacherInterviewLabel.sd_layout.leftSpaceToView(_view2,20).rightSpaceToView(_view2,20).topSpaceToView(descrip,20).autoHeightRatio(0);
        
        _teacherInterviewLabel.text = @"" ;
        
        /* 教师头像*/
        _teacherHeadImage = [[UIImageView alloc]init];
        [_view2 addSubview:_teacherHeadImage];
        _teacherHeadImage.sd_layout
        .topEqualToView(_teacherNameLabel)
        .rightSpaceToView(_view2,10)
        .bottomSpaceToView(schools,10)
        .widthEqualToHeight();
        
        
        
        /* 辅导课列表*/
        _classesListTableView = [[UITableView alloc]init];
        _classesListTableView.tableFooterView = [[UIView alloc]init];
        
        
        [_view3 addSubview:_classesListTableView];
        _classesListTableView.sd_layout.leftSpaceToView(_view3,0).rightSpaceToView(_view3,0).topSpaceToView(_view3,0).bottomSpaceToView(_view3,0);
        
        
        
        
    }
    return self;
}

@end
