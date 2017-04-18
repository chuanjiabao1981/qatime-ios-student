//
//  VideoClassPlayerView.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassPlayerView.h"
#import "NSString+ChangeYearsToChinese.h"

@interface VideoClassPlayerView ()

@end

@implementation VideoClassPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //滑动控制器
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"课时安排",@"课程详情"]];
        _segmentControl.borderType = HMSegmentedControlBorderTypeBottom;
        _segmentControl.borderWidth = 0.5;
        _segmentControl.borderColor = SEPERATELINECOLOR;
        _segmentControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15*ScrenScale]};
        _segmentControl.selectionIndicatorColor = NAVIGATIONRED;
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.borderType = HMSegmentedControlTypeText;
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentControl.selectionIndicatorHeight =2;
        [self addSubview:_segmentControl];
        _segmentControl.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .heightIs(30);
        
        //滑动视图
        _scrollView = [[UIScrollView alloc]init];
        [self addSubview:_scrollView];
        _scrollView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_segmentControl, 0)
        .bottomSpaceToView(self, 0);
        _scrollView.contentSize = CGSizeMake(self.width_sd*2, self.height_sd - _segmentControl.height_sd);
        _scrollView.pagingEnabled = YES;
        
        //视频列表
        _classVideoListTableView = [[UITableView alloc]init];
        _classVideoListTableView.tableFooterView = [[UIView alloc]init];
        [_scrollView addSubview:_classVideoListTableView];
        _classVideoListTableView.sd_layout
        .leftSpaceToView(_scrollView, 0)
        .topSpaceToView(_scrollView, 0)
        .bottomSpaceToView(_scrollView, 0)
        .rightSpaceToView(_scrollView, 0);
        
        //课程信息详情
        _infoView = [[VideoClass_Player_InfoView alloc]init];
        [_scrollView addSubview:_infoView];
        _infoView.sd_layout
        .leftSpaceToView(_classVideoListTableView, 0)
        .topEqualToView(_classVideoListTableView)
        .bottomEqualToView(_classVideoListTableView)
        .widthRatioToView(_classVideoListTableView, 1.0);
        
        [_scrollView setupAutoContentSizeWithRightView:_infoView rightMargin:0];
        [_scrollView setupAutoContentSizeWithBottomView:_classVideoListTableView bottomMargin:0];
        
        
        
    }
    return self;
}

/**赋值*/
- (void)setModel:(VideoClassInfo *)model{
    
    _model = model;
    
    _infoView.className.text = model.name;
    _infoView.gradeLabel.text = model.grade;
    _infoView.subjectLabel.text = model.subject;
    _infoView.classCount.text = [NSString stringWithFormat:@"共%@课",model.video_lessons_count];
    _infoView.liveTimeLabel.text = [NSString stringWithFormat:@"视频总长:%@",model.total_duration];
    _infoView.classTarget.text = model.objective;
    _infoView.suitable.text = model.suit_crowd;
    
    //教师信息
    [_infoView.teacherHeadImage sd_setImageWithURL:[NSURL URLWithString:model.publicize]];
    _infoView.teacherNameLabel.text = model.teacher[@"name"];
    if ([model.teacher[@"gender"]isEqualToString:@"male"]) {
        [_infoView.genderImage setImage:[UIImage imageNamed:@"男"]];
    }else if ([model.teacher[@"gender"]isEqualToString:@"female"]){
        [_infoView.genderImage setImage:[UIImage imageNamed:@"女"]];
    }
    _infoView.workPlaceLabel.text = [NSString stringWithFormat:@"%@",model.teacher[@"school"]];
    _infoView.workYearsLabel.text = [model.teacher[@"work_years"] changeEnglishYearsToChinese];
    _infoView.teacherInterviewLabel.attributedText = [[NSMutableAttributedString alloc]initWithData:[model.teacher[@"desc"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }  documentAttributes:nil error:nil];

}


@end
