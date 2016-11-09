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
        [_deadLine setText:@" [距开课100天] "];
        [_deadLine setTextColor:[UIColor whiteColor]];
        [_deadLine setBackgroundColor:USERGREEN];
        
        
        
        /* 招生状态*/
        
        _recuitState = [[UILabel alloc]init];
        [self addSubview:_recuitState];
        _recuitState.sd_layout.rightSpaceToView(_deadLine,0).bottomEqualToView(_deadLine).heightRatioToView(_deadLine,1.0f);
        [_recuitState setSingleLineAutoResizeWithMaxWidth:100];
        [_recuitState setText:@" 招生中"];
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
        [saleNum setText:@"100"];
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
        _segmentControl.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(line1,0).heightRatioToView(_className,2.0f);
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.borderType = HMSegmentedControlTypeText;
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
       
        
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
        
        UIView *view1 =[[UIView alloc]init];
        [_scrollView addSubview:view1];
        view1.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topEqualToView(_scrollView).bottomEqualToView(_scrollView);
        view1.backgroundColor = [UIColor whiteColor];
        
        UIView *view2 =[[UIView alloc]init];
        [_scrollView addSubview:view2];
        view2.sd_layout.leftSpaceToView(view1,0).widthIs(SCREENWIDTH).topEqualToView(_scrollView).bottomEqualToView(_scrollView);
        view2.backgroundColor = [UIColor whiteColor];
        
        
        UIView *view3 =[[UIView alloc]init];
        [_scrollView addSubview:view3];
        view3.sd_layout.leftSpaceToView(view2,0).widthIs(SCREENWIDTH).topEqualToView(_scrollView).bottomEqualToView(_scrollView);
        view3.backgroundColor = [UIColor whiteColor];
        
        
        /* 辅导班概况 的所有label*/
        
        UILabel *subject =[[UILabel alloc]init];
        [view1 addSubview:subject];
        subject.sd_layout.topSpaceToView(view1,20).leftSpaceToView(view1,20).autoHeightRatio(0);
        [subject setSingleLineAutoResizeWithMaxWidth:100.0f];
        [subject setText:@"科目"];
        
        _subjectLabel = [[UILabel alloc]init];
        [view1 addSubview:_subjectLabel];
        _subjectLabel.sd_layout.topEqualToView(subject).leftSpaceToView(subject,20).autoHeightRatio(0);
        [_subjectLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_subjectLabel setText:@"科目"];
        
        /* 年级*/
        
        UILabel *grade = [[UILabel alloc]init];
        [view1 addSubview:grade];
        grade.sd_layout.leftSpaceToView(view1,SCREENWIDTH/2).topEqualToView(subject).autoHeightRatio(0);
        [grade setSingleLineAutoResizeWithMaxWidth:100.0f];
        [grade setText:@"年级"];
        
        _gradeLabel =[[UILabel alloc]init];
        [view1 addSubview:_gradeLabel];
        _gradeLabel.sd_layout.leftSpaceToView(grade,20).topEqualToView(subject).autoHeightRatio(0);
        [_gradeLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_gradeLabel setText:@"年级"];

        /* 课时*/
        UILabel *counted =[[UILabel alloc]init];
        [view1 addSubview:counted];
        counted.sd_layout.leftEqualToView(subject).topSpaceToView(subject,20).autoHeightRatio(0);
        [counted setSingleLineAutoResizeWithMaxWidth:100.0f];
        [counted setText:@"共"];
        
        _classCount=[[UILabel alloc]init];
        [view1 addSubview:_classCount];
        _classCount.sd_layout.leftSpaceToView(counted,0).topEqualToView(counted).autoHeightRatio(0);
        [_classCount setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_classCount setText:@"***"];
        
        UILabel *classes=[[UILabel alloc]init];
        [view1 addSubview:classes];
        classes.sd_layout.leftSpaceToView(_classCount,0).topEqualToView(counted).autoHeightRatio(0);
        [classes setSingleLineAutoResizeWithMaxWidth:100.0f];
        [classes setText:@"课时"];

        
        /* 在线直播*/
        _onlineVideoLabel =[[UILabel alloc]init];
        [view1 addSubview:_onlineVideoLabel];
        _onlineVideoLabel.sd_layout.leftEqualToView(grade).topEqualToView(counted).autoHeightRatio(0);
        [_onlineVideoLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_onlineVideoLabel setText:@"在线直播"];
        
        
        /* 直播时间*/
        
        _liveStartTimeLabel = [[UILabel alloc]init];
        [view1 addSubview:_liveStartTimeLabel];
        _liveStartTimeLabel.sd_layout.leftEqualToView(counted).topSpaceToView(counted,20).autoHeightRatio(0);
        [_liveStartTimeLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_liveStartTimeLabel setText:@"2016-11-10"];

        UILabel *_to =[[UILabel alloc]init];
        [view1 addSubview:_to];
        _to.sd_layout.leftSpaceToView(_liveStartTimeLabel,2).topEqualToView(_liveStartTimeLabel).autoHeightRatio(0);
        [_to setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_to setText:@"至"];
        
        _liveEndTimeLabel = [[UILabel alloc]init];
        [view1 addSubview:_liveEndTimeLabel];
        _liveEndTimeLabel.sd_layout.leftSpaceToView(_to,2).topEqualToView(_liveStartTimeLabel).autoHeightRatio(0);
        [_liveEndTimeLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_liveEndTimeLabel setText:@"2016-11-10"];

        
        
        /* 辅导简介*/
        UILabel *description=[[UILabel alloc]init];
        [view1 addSubview:description];
        description.sd_layout.leftEqualToView(subject).topSpaceToView(_to,20).autoHeightRatio(0);
        [description setSingleLineAutoResizeWithMaxWidth:100.0f];
        [description setText:@"辅导简介"];

        _classDescriptionLabel =[[UILabel alloc]init];
        [view1 addSubview:_classDescriptionLabel];
        _classDescriptionLabel.sd_layout.leftEqualToView(description).topSpaceToView(description,20).autoHeightRatio(0).rightSpaceToView(view1,20);
        [_classDescriptionLabel setText:@"sdfasdf;dsjfl;aksdjfl;kajsdfl;kjd案例可使肌肤撒；地方就爱上了贷款；发牢骚；的看法阿里斯顿；会计法；斯蒂芬极乐空间；来得及发拉卡斯加对方；来的斯洛伐克骄傲；是打飞机了；是看得见；了解；拉伸的解放了；卡斯加对方；年教室里；大框架；爱睡懒觉了；可擦拭；地方叫阿里；斯柯达积分；爱上当减肥了；卡斯加对方；加上；的离开房间；爱的解放了；卡死的缴费；来说的缴费；拉斯柯达积分；爱上当减肥；拉斯柯达积分了；奥斯卡的风景"];
        
        
        /* 教师简介 。。。view2*/
        _teacherNameLabel = [[UILabel alloc]init];
        [view2 addSubview:_teacherNameLabel];
        _teacherNameLabel.sd_layout.leftSpaceToView(view2,20).topSpaceToView(view2,20).autoHeightRatio(0);
        [_teacherNameLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        _teacherNameLabel.font = [UIFont systemFontOfSize:20];
        [_teacherNameLabel setText:@"教师姓名"];
        
        /* 执教年数*/
        UILabel *workYears = [[UILabel alloc]init];
        [view2 addSubview:workYears];
        workYears.sd_layout.leftEqualToView(_teacherNameLabel).topSpaceToView(_teacherNameLabel,20).autoHeightRatio(0);
        [workYears setSingleLineAutoResizeWithMaxWidth:200];
        [workYears setText:@"执教年数"];
        
        _workYearsLabel = [[UILabel alloc]init];
        [view2 addSubview:_workYearsLabel];
        _workYearsLabel.sd_layout.leftSpaceToView(workYears,20).topEqualToView(workYears).autoHeightRatio(0);
        [_workYearsLabel setSingleLineAutoResizeWithMaxWidth:200];
        _workYearsLabel.text = @"10-20年" ;
        
        
        /* 所在学校*/
        UILabel *schools =[[UILabel alloc]init];
        [view2 addSubview:schools];
        schools.sd_layout.leftEqualToView(_teacherNameLabel).topSpaceToView(workYears,20).autoHeightRatio(0);
        [schools setSingleLineAutoResizeWithMaxWidth:200];
        [schools setText:@"所在学校"];
        
        _workPlaceLabel =[[UILabel alloc]init];
        [view2 addSubview:_workPlaceLabel];
        _workPlaceLabel.sd_layout.leftSpaceToView(schools,20).topEqualToView(schools).autoHeightRatio(0);
        [_workPlaceLabel setSingleLineAutoResizeWithMaxWidth:200];
        _workPlaceLabel.text = @"北京市第十四中学" ;


        /* 教师简介*/
        UILabel *descrip =[[UILabel alloc]init];
        [view2 addSubview:descrip];
        descrip.sd_layout.leftEqualToView(_teacherNameLabel).topSpaceToView(_workPlaceLabel,20).autoHeightRatio(0);
        [descrip setSingleLineAutoResizeWithMaxWidth:200];
        descrip.text = @"教师简介";
        
        _teacherInterviewLabel =[[UILabel alloc]init];
        [view2 addSubview:_teacherInterviewLabel];
        _teacherInterviewLabel.sd_layout.leftSpaceToView(view2,20).rightSpaceToView(view2,20).topSpaceToView(descrip,20).autoHeightRatio(0);
        
        _teacherInterviewLabel.text = @"爱上了贷款骄傲圣诞节和罚款老师讲的好伐啦USD和覅无二UI一起入卡上美女报酬率一u 阿萨德可减肥哈鲁舍看来就恢复阿里苏打粉爱屋恩法拉克是接电话覅却快乐就哈市了独眼额牛的回复v983yh聚纠纷lkhq98yr9328r拍984人阿萨德；了疯狂就去哦夫妻发生发脾气欧文我围绕去偶尔p984rpqwhei4y5pt8oypodfasdfq]wef]dfoiasdf" ;
        
        
        

        
        
        /* 辅导课列表*/
        _classesListTableView = [[UITableView alloc]init];
        [view3 addSubview:_classesListTableView];
        _classesListTableView.sd_layout.leftSpaceToView(view3,0).rightSpaceToView(view3,0).topSpaceToView(view3,0).bottomSpaceToView(view3,0);
        
        
        
        
        
        
        
    }
    return self;
}

@end
