//
//  VideoInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//


#import "VideoInfoView.h"

#define SCREENWIDTH self.frame.size.width
#define VIEWHEIGHT  self.frame.size.height

@interface VideoInfoView (){
    
    
}

@end


@implementation VideoInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        /* 滑动控制器*/
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"公告",@"聊天",@"直播详情",@"成员列表"]];
        [self addSubview:_segmentControl];
        
        
        
        _segmentControl.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(self,5).heightIs(30);
//        [_segmentControl setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 30)];
        
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.borderType = HMSegmentedControlTypeText;
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;

        /* 大滑动页面*/
        _scrollView = [[UIScrollView alloc]init];

        [self addSubview: _scrollView ];
        
//        _scrollView setFrame:CGRectMake(0, CGRectGetMaxY(_segmentControl.frame), , <#CGFloat height#>)
        _scrollView.sd_layout.
        leftEqualToView(self).
        rightEqualToView(self).
        topSpaceToView(_segmentControl,0).
        bottomSpaceToView(self,0);

        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
//        [_scrollView scrollRectToVisible:CGRectMake(0, 0, CGRectGetWidth(self.frame), _scrollView.size.height) animated:NO];

        
        
        UIView *view1= [[UIView alloc]init];
        [_scrollView addSubview:view1];
//        view1.backgroundColor = [UIColor redColor];
        view1.sd_layout
        .topEqualToView(_scrollView)
        .bottomEqualToView(_scrollView)
        .leftEqualToView(_scrollView)
        .widthRatioToView(self,1.0f);
        
        _view2= [[UIView alloc]init];
        [_scrollView addSubview:_view2];
//        view2.backgroundColor = [UIColor orangeColor];

        _view2.sd_layout
        .topEqualToView(_scrollView)
        .bottomEqualToView(_scrollView)
        .leftSpaceToView(view1,0)
        .widthRatioToView(self,1.0f);
        
        _view3= [[UIView alloc]init];
        [_scrollView addSubview:_view3];
//        view3.backgroundColor = [UIColor yellowColor];

        _view3.sd_layout
        .topEqualToView(_scrollView)
        .bottomEqualToView(_scrollView)
         .leftSpaceToView(_view2,0)
        .widthRatioToView(self,1.0f);
        
        _view4= [[UIView alloc]init];
        [_scrollView addSubview:_view4];
//        view4.backgroundColor = [UIColor greenColor];

        _view4.sd_layout
        .topEqualToView(_scrollView)
        .bottomEqualToView(_scrollView)
         .leftSpaceToView(_view3,0)
        .widthRatioToView(self,1.0f);
        
        /* 公告栏*/
        _noticeTabelView = [[UITableView alloc]init];
        [view1 addSubview:_noticeTabelView];
        
        _noticeTabelView.sd_layout
        .topEqualToView(view1)
        .bottomEqualToView(view1)
        .leftEqualToView(view1)
        .rightEqualToView(view1);
        _noticeTabelView.tableFooterView = [[UIView alloc]init];
        
        
//        #pragma mark- view3的滚动视图
//        /* 课程、教师详细信息页面*/
//
//        _infoScrollView =[[UIScrollView alloc]init];
//        
//        [view3 addSubview:_infoScrollView];
////        _infoScrollView.backgroundColor = [UIColor lightGrayColor];
//        _infoScrollView .sd_layout
//        .leftEqualToView(view3)
//        .rightEqualToView(view3)
//        .topEqualToView(view3)
//        .heightRatioToView(view3,1.0f);
//        _infoScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 2000);
//        
//        
//        #pragma mark- view3的辅导班的详情页面
//        
//        /* 1、辅导班详情页面*/
////        _classInfoView = [[UIView alloc]init];
////        [_infoScrollView addSubview:_classInfoView];
////        _classInfoView.sd_layout
////        .leftEqualToView(_infoScrollView)
////        .rightEqualToView(_infoScrollView)
////        .topEqualToView(_infoScrollView)
////        .heightRatioToView(view3,1.0f);
//        
//        
//        /* view3中的课程简介*/
//        /* 辅导班概况 的所有label*/
//        
//        
//        /* 课程名*/
//        _classNameLabel = [[UILabel alloc]init];
//        [_infoScrollView addSubview: _classNameLabel];
//        _classNameLabel.sd_layout
//        .leftSpaceToView(_infoScrollView,20)
//        .rightSpaceToView(_infoScrollView,20)
//        .topSpaceToView(_infoScrollView,10)
//        .heightIs(30);
//        _classNameLabel.textColor = [UIColor blackColor];
//        _classNameLabel.text = @"sdfasdfsdf";
//        
//        
//        
//        
//        /* 年级*/
//        
////        UILabel *grade = [[UILabel alloc]init];
////        [_infoScrollView addSubview:grade];
////        grade.sd_layout
////        .topSpaceToView(_infoScrollView,10)
////        .leftSpaceToView(_infoScrollView,20)
////        .autoHeightRatio(0);;
////        [grade setSingleLineAutoResizeWithMaxWidth:100.0f];
////        [grade setText:@"年级"];
////        
//        _gradeLabel =[[UILabel alloc]init];
//        [_gradeLabel setText:@"年级"];
//        [_infoScrollView addSubview:_gradeLabel];
//        _gradeLabel.sd_layout.leftEqualToView(_classNameLabel).topSpaceToView(_classNameLabel,20).autoHeightRatio(0);
//        [_gradeLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
//        
//        
//        
//        /* 课时 进度*/
//        UILabel *counted =[[UILabel alloc]init];
//        [_infoScrollView addSubview:counted];
//        counted.sd_layout.leftSpaceToView(_infoScrollView,[UIScreen mainScreen].bounds.size.width/2).topSpaceToView(_classNameLabel,20).autoHeightRatio(0);
//        [counted setSingleLineAutoResizeWithMaxWidth:100.0f];
//        [counted setText:@"进度"];
//        
//        _completed_conunt=[[UILabel alloc]init];
//        [_infoScrollView addSubview:_completed_conunt];
//        _completed_conunt.sd_layout.leftSpaceToView(counted,0).topEqualToView(counted).autoHeightRatio(0);
//        [_completed_conunt setSingleLineAutoResizeWithMaxWidth:100.0f];
//        [_completed_conunt setText:@"***"];
//        
//        UILabel *cut=[[UILabel alloc]init];
//        [_infoScrollView addSubview:cut];
//        cut.sd_layout.leftSpaceToView(_completed_conunt,0).topEqualToView(_completed_conunt).autoHeightRatio(0);
//        [cut setSingleLineAutoResizeWithMaxWidth:100.0f];
//        [cut setText:@"/"];
//        
//        
//        _classCount=[[UILabel alloc]init];
//        [_infoScrollView addSubview:_classCount];
//        _classCount.sd_layout.leftSpaceToView(cut,0).topEqualToView(_completed_conunt).autoHeightRatio(0);
//        [_classCount setSingleLineAutoResizeWithMaxWidth:100.0f];
//        [_classCount setText:@"***"];
//        
//
//        
//        /* 科目*/
//        UILabel *subject =[[UILabel alloc]init];
//        [_infoScrollView addSubview:subject];
//        subject.sd_layout.topSpaceToView(_gradeLabel,20).leftEqualToView(_gradeLabel).autoHeightRatio(0);
//        [subject setSingleLineAutoResizeWithMaxWidth:100.0f];
//        [subject setText:@"科目"];
//        
//        _subjectLabel = [[UILabel alloc]init];
//        [_infoScrollView addSubview:_subjectLabel];
//        _subjectLabel.sd_layout.topEqualToView(subject).leftSpaceToView(subject,20).autoHeightRatio(0);
//        [_subjectLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
//        [_subjectLabel setText:@"科目"];
//
//        
//        /* 在线直播*/
//        _onlineVideoLabel =[[UILabel alloc]init];
//        [_infoScrollView addSubview:_onlineVideoLabel];
//        _onlineVideoLabel.sd_layout.leftEqualToView(counted).topEqualToView(subject).autoHeightRatio(0);
//        [_onlineVideoLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
//        [_onlineVideoLabel setText:@"在线直播"];
//        
//        
//        /* 直播时间*/
//        
//        _liveStartTimeLabel = [[UILabel alloc]init];
//        [_infoScrollView addSubview:_liveStartTimeLabel];
//        _liveStartTimeLabel.sd_layout.leftEqualToView(subject).topSpaceToView(subject,20).autoHeightRatio(0);
//        [_liveStartTimeLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
//        [_liveStartTimeLabel setText:@"2016-11-10"];
//        
//        UILabel *_to =[[UILabel alloc]init];
//        [_infoScrollView addSubview:_to];
//        _to.sd_layout.leftSpaceToView(_liveStartTimeLabel,2).topEqualToView(_liveStartTimeLabel).autoHeightRatio(0);
//        [_to setSingleLineAutoResizeWithMaxWidth:100.0f];
//        [_to setText:@"至"];
//        
//        _liveEndTimeLabel = [[UILabel alloc]init];
//        [_infoScrollView addSubview:_liveEndTimeLabel];
//        _liveEndTimeLabel.sd_layout.leftSpaceToView(_to,2).topEqualToView(_liveStartTimeLabel).autoHeightRatio(0);
//        [_liveEndTimeLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
//        [_liveEndTimeLabel setText:@"2016-11-10"];
//        
//        
//        
//        /* 辅导简介*/
//        UILabel *description=[[UILabel alloc]init];
//        [_infoScrollView addSubview:description];
//        description.sd_layout.leftEqualToView(subject).topSpaceToView(_to,20).autoHeightRatio(0);
//        [description setSingleLineAutoResizeWithMaxWidth:100.0f];
//        [description setText:@"辅导简介"];
//        
//        _classDescriptionLabel =[[UILabel alloc]init];
//        [_infoScrollView addSubview:_classDescriptionLabel];
//        _classDescriptionLabel.sd_layout
//        .leftEqualToView(description)
//        .topSpaceToView(description,20)
//        .autoHeightRatio(0)
//        .rightSpaceToView(_infoScrollView,20);
//        _classDescriptionLabel.numberOfLines = 0;
//        [_classDescriptionLabel setText:@"sdfasdf;dsjfl;aksdjfl;kajsdfl;kjd案例可使肌肤撒；地方就爱上了贷款；发牢骚；的看法阿里斯顿；会计法；斯蒂芬极乐空间；来得及发拉卡斯加对方；来的斯洛伐克骄傲；是打飞机了；是看得见；了解；拉伸的解放了；卡斯加对方；年教室里；大框架；爱睡懒觉了；可擦拭；地方叫阿里；斯柯达积分；爱上当减肥了；卡斯加对方；加上；的离开房间；爱的解放了；卡死的缴费；来说的缴费；拉斯柯达积分；爱上当减肥；拉斯柯达积分了；奥斯卡的风景说大法师打发"];
//        
//       
//        
//        
//        
//        #pragma mark- view3的下拉view  教师详情页
//        
//        /* 教师头像*/
//        _teacherHeadImage = [[UIImageView alloc]init];
//        [_infoScrollView addSubview:_teacherHeadImage];
//        
//        /* 教师姓名*/
//        _teacherNameLabel =[[UILabel alloc]init];
//        _teacherNameLabel.font = [UIFont systemFontOfSize:22];
//        [_infoScrollView addSubview:_teacherNameLabel];
//        
//        _teacherNameLabel.sd_layout
//        .leftSpaceToView(_infoScrollView,20)
//        .topSpaceToView(_classDescriptionLabel,20)
//        .autoHeightRatio(0);
//        [_teacherNameLabel setSingleLineAutoResizeWithMaxWidth:100];
//        _teacherNameLabel.text = @"教师姓名";
//        
//
//        
//        
//        
//        
//        /* 性别*/
//        _genderImage  = [[UIImageView alloc]init];
//        [_infoScrollView addSubview:_genderImage];
//        
//        _genderImage.sd_layout
//        .leftSpaceToView(_teacherNameLabel,5)
//        .topEqualToView(_teacherNameLabel)
//        .heightRatioToView(_teacherNameLabel,1.0f)
//        .widthEqualToHeight();
//        
//        
//        /* 教龄*/
//        UILabel *teachYear = [[UILabel alloc]init];
//        teachYear.textColor = [UIColor blackColor];
//        teachYear.text = @"执教年数";
////        teachYear.font = [UIFont systemFontOfSize:16];
//        [_infoScrollView addSubview:teachYear];
//
//        
//        teachYear.sd_layout
//        .leftEqualToView(_teacherNameLabel)
//        .topSpaceToView(_teacherNameLabel,20)
//        .autoHeightRatio(0);
//        [teachYear setSingleLineAutoResizeWithMaxWidth:100];
//        teachYear.text = @"执教年限";
//        
//        
//        _teaching_year= [[UILabel alloc]init];
////        _teaching_year.font = [UIFont systemFontOfSize:16];
//        [_infoScrollView addSubview:_teaching_year];
//
//        
//        _teaching_year.sd_layout
//        .leftSpaceToView(teachYear,20)
//        .topEqualToView(teachYear)
//        .autoHeightRatio(0);
//        [_teaching_year setSingleLineAutoResizeWithMaxWidth:300];
//
//        
//        
//
//        
//        UILabel *schools=[[UILabel alloc]init];
////        schools.font = [UIFont systemFontOfSize:16];
//        
//        [_infoScrollView addSubview:schools];
//        
//        
//        schools.sd_layout
//        .leftEqualToView(teachYear)
//        .topSpaceToView(teachYear,20)
//        .autoHeightRatio(0);
//        [schools setSingleLineAutoResizeWithMaxWidth:300];
//        schools.text = @"所在学校" ;
//        
//        
//        
//        _workPlace= [[UILabel alloc]init];
////        _workPlace.font = [UIFont systemFontOfSize:16];
//        
//        [_infoScrollView addSubview:_workPlace];
//
//        _workPlace.sd_layout
//        .leftSpaceToView(schools,10)
//        .topEqualToView(schools)
//        .autoHeightRatio(0);
//        [_workPlace setSingleLineAutoResizeWithMaxWidth:300];
//        
//        
//        
//        
//        /* 自我介绍标题*/
//        UILabel *selfIntroLabel =[[UILabel alloc]init];
//        selfIntroLabel.text =@"教师简介";
////        selfIntroLabel.font =[UIFont systemFontOfSize:20];
//        
//        [_infoScrollView addSubview:selfIntroLabel];
//        
//        
//        /* 自我介绍*/
//        _selfInterview= [[UILabel alloc]init];
//        
//        [_infoScrollView addSubview:_selfInterview];
//        /* 布局*/
//       
//        
//        
//        
////        [_infoScrollView sd_addSubviews:@[_teacherHeadImage,_teacherNameLabel,_genderImage,teachYear,_teaching_year,schools,_workPlace,selfIntroLabel,_selfInterview]];
////
//        
//        
//        
//        
//        
//        
//        
//        
//        /* 自我介绍部分的布局*/
//
//        
//        selfIntroLabel.sd_layout
//        .leftEqualToView(schools)
//        .topSpaceToView(schools,20)
//        .autoHeightRatio(0);
//        [selfIntroLabel setSingleLineAutoResizeWithMaxWidth:100];
//        
//        
//        _selfInterview.sd_layout
//        .leftEqualToView(selfIntroLabel)
//        .topSpaceToView(selfIntroLabel,20)
//        .rightSpaceToView(_infoScrollView,20)
//        .autoHeightRatio(0);
//        _selfInterview .text = @"aasdfjadlskfja;lsdkjf;alsdfasdfkljdflkajsd家；了但是会计法is的减肥了可骄傲的谁离开房间阿里贷款积分垃圾的说法了解 老师的；快放假啊；is地方了我看及诶诶UR已提交客户可垃圾和水电费啊实打实的减肥哈士大夫按时；代理费静安寺；的离开房间安顿；是skdjf" ;
//        _selfInterview.numberOfLines =0;
//        [_selfInterview sizeToFit];
//        
        

        
        #pragma mark- 下半部分的课程列表视图
//        _classListTableView = [[UITableView alloc]init];
//        [_view3 addSubview:_classListTableView];
//        _classListTableView.sd_layout
//        .topEqualToView(_view3)
//        .leftEqualToView(_view3)
//        .rightEqualToView(_view3)
//        .bottomEqualToView(_view3);
        
        
//        InfoHeaderView *infoHeaderView = [[InfoHeaderView alloc]init];
//        
//        
//        [view3 addSubview:infoHeaderView];
//        infoHeaderView.sd_layout
//        .leftEqualToView(view3)
//        .rightEqualToView(view3)
//        .topEqualToView(view3)
//        .bottomEqualToView(view3);
//        
        
        
        
        
        
        
        
    }
    return self;
}



@end
