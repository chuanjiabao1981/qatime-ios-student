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
        [self addSubview:_segmentControl];
        _segmentControl.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topEqualToView(self)
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
        
        //视频列表
        _classVideoListTableView = [[UITableView alloc]init];
        [_scrollView addSubview:_classVideoListTableView];
        _classVideoListTableView.sd_layout
        .leftSpaceToView(_scrollView, 0)
        .topSpaceToView(_scrollView, 0)
        .bottomSpaceToView(_scrollView, 0)
        .widthIs(self.width_sd);
        
        //课程信息详情
        _infoView = [[VideoClass_Player_InfoView alloc]init];
        [_scrollView addSubview:_infoView];
        _infoView.sd_layout
        .leftSpaceToView(_classVideoListTableView, 0)
        .rightSpaceToView(self, 0)
        .topEqualToView(_classVideoListTableView)
        .bottomEqualToView(_classVideoListTableView);
        
    }
    return self;
}

/**赋值*/
- (void)setModel:(VideoClassInfo *)model{
    
    _model = model;
    
    _infoView.className.text = model.name;
    _infoView.gradeLabel.text = model.grade;
    _infoView.subjectLabel.text = model.subject;
    _infoView.classCount.text = [NSString stringWithFormat:@"共%@课",model.lessons_count];
//    _infoView.liveTimeLabel.text = [NSString stringWithFormat:@"视频总长:%@",model.视频时长];
    _infoView.classTarget.text = model.objective;
    _infoView.suitable.text = model.suit_crowd;
    
    //教师信息
    [_infoView.teacherHeadImage sd_setImageWithURL:[NSURL URLWithString:model.publicize]];
    _infoView.teacherNameLabel.text = model.teacher[@"name"];
    if ([model.teacher[@"gender"]isEqualToString:@"male"]) {
        [_infoView.genderImage setImage:[UIImage imageNamed:@"male"]];
    }else if ([model.teacher[@"gender"]isEqualToString:@"female"]){
        [_infoView.genderImage setImage:[UIImage imageNamed:@"female"]];
    }
    _infoView.workPlaceLabel.text = model.teacher[@"school"];
    _infoView.workYearsLabel.text = [model.teacher[@"work_years"] changeEnglishYearsToChinese];
    _infoView.teacherInterviewLabel.attributedText = [[NSMutableAttributedString alloc]initWithData:[model.teacher[@"desc"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }  documentAttributes:nil error:nil];

}


@end
