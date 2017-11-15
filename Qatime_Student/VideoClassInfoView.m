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
        
        self.backgroundColor = [UIColor whiteColor];
        
        _headView = [[UIView alloc]init];
        [self addSubview:_headView];
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0);
        
        /* 课程名称*/
        _className = [[UILabel alloc]init];
        [_headView addSubview:_className];
        _className.sd_layout
        .leftSpaceToView(_headView,10)
        .rightSpaceToView(_headView, 10)
        .topSpaceToView(_headView,20)
        .autoHeightRatio(0);
        [_className setTextColor:[UIColor blackColor]];
        [_className setFont:TITLEFONTSIZE];
        
        //课程特色
        UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc]init];
        _classFeature = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _classFeature.backgroundColor = [UIColor whiteColor];
        [_headView addSubview:_classFeature];
        _classFeature.sd_layout
        .leftSpaceToView(_headView, 0)
        .rightSpaceToView(_headView, 0)
        .topSpaceToView(_className, 10)
        .heightIs(20);
        
        /* 价格*/
        _priceLabel=[[UILabel alloc]init];
        [_headView addSubview:_priceLabel];
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
        [_headView addSubview:_saleNumber];
        _saleNumber.sd_layout
        .bottomEqualToView(_priceLabel)
        .rightSpaceToView(_headView,10)
        .autoHeightRatio(0);
        [_saleNumber setSingleLineAutoResizeWithMaxWidth:200];
        
        [_headView setupAutoHeightWithBottomView:_saleNumber bottomMargin:10];
        
        /* 分割线1*/
        UIView *line1 = [[UIView alloc]init];
        [self addSubview:line1];
        
        line1.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .topSpaceToView(_headView,0)
        .heightIs(1.0f);
        
        
        /* 滑动控制器*/
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"课程介绍",@"教师资料",@"课时安排"]];
        [self addSubview:_segmentControl];
        _segmentControl.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(line1,0)
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
    
        
//        /* 辅导课列表*/
//        _classesListTableView = [[UITableView alloc]init];
//
//        _classesListTableView.tableFooterView = [[UIView alloc]init];
//
//        [_view3 addSubview:_classesListTableView];
//        _classesListTableView.sd_layout
//        .leftSpaceToView(_view3,0)
//        .rightSpaceToView(_view3,0)
//        .topSpaceToView(_view3,0)
//        .bottomSpaceToView(_view3,0);
//
//        [_scrollView setupAutoContentSizeWithRightView:_view3 rightMargin:0];
//        [_scrollView setupAutoContentSizeWithBottomView:_view1 bottomMargin:0];
        
        
    }
    return self;
}


/**页面赋值*/
-(void)setModel:(VideoClassInfo *)model{
    
    _model = model;
    _className.text = model.name;
    
    if ([model.sell_type isEqualToString:@"charge"]) {
        _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    }else if ([model.sell_type isEqualToString:@"free"]){
        
        _priceLabel.text = @"免费";
    }
    _saleNumber.text = [NSString stringWithFormat:@"学习人数 %@",model.buy_tickets_count];
    
//    [_teacherHeadImage sd_setImageWithURL:[NSURL URLWithString:model.teacher[@"avatar_url"]]];
//    _teacherNameLabel.text = model.teacher[@"name"];
//   
//    if ([model.teacher[@"gender"] isEqual:[NSNull null]]) {
//        
//    }else{
//        if ([model.teacher[@"gender"]isEqualToString:@"male"]) {
//            [_genderImage setImage:[UIImage imageNamed:@"男"]];
//        }else if([model.teacher[@"gender"]isEqualToString:@"female"]) {
//            [_genderImage setImage:[UIImage imageNamed:@"女"]];
//        }
//    }
//    
//    _workPlaceLabel.text = [NSString stringWithFormat:@"%@",model.teacher[@"school"]];
//    _workYearsLabel.text = [NSString stringWithFormat:@"%@",[model.teacher[@"teaching_years"] changeEnglishYearsToChinese]];
//    _teacherInterviewLabel.attributedText = [[NSMutableAttributedString alloc]initWithData:[model.teacher[@"desc"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
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
