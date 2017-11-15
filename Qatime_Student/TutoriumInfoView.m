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
#import "NSString+ChangeYearsToChinese.h"
#import "NSNull+Json.h"
#import "NSString+TimeStamp.h"
#import "HMSegmentedControl+Category.h"
#define SCREENWIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREENHEIGHT CGRectGetHeight(self.frame)

@interface TutoriumInfoView (){
    
    
}

@end

@implementation TutoriumInfoView

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
        .topSpaceToView(self, 0)
        .rightSpaceToView(self, 0);
        
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
        
        //课程状态
        _status = [[UILabel alloc]init];
        [_headView addSubview:_status];
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
        [_headView addSubview:_classFeature];
        _classFeature.sd_layout
        .leftSpaceToView(_headView, 0)
        .rightSpaceToView(_headView, 0)
        .topSpaceToView(_status, 10)
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
        [line1 updateLayout];
        
        /* 滑动控制器*/
        _segmentControl = [HMSegmentedControl segmentControlWithTitles:@[@"课程介绍",@"教师资料",@"上课安排"]];
        [self addSubview:_segmentControl];
        _segmentControl.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(line1,5)
        .heightIs(30);
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
        _scrollView.contentSize = CGSizeMake(100,100);
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
       
        typeof(self) __weak weakSelf = self;
        _segmentControl.indexChangeBlock = ^(NSInteger index) {
            [weakSelf.scrollView scrollRectToVisible:CGRectMake(weakSelf.scrollView.width_sd * index, 0, weakSelf.scrollView.width_sd, weakSelf.scrollView.height_sd) animated:YES];
        };
    }
    return self;
}

-(void)setExclusiveModel:(ExclusiveInfo *)exclusiveModel{

    _exclusiveModel = exclusiveModel;
    _className.text = exclusiveModel.name;
    _saleNumber.text = [NSString stringWithFormat:@"报名人数 : %@/%@",exclusiveModel.users_count,exclusiveModel.max_users];
    /* 已开课的状态*/
    if ([exclusiveModel.status isEqualToString:@"teaching"]||[exclusiveModel.status isEqualToString:@"pause"]||[exclusiveModel.status isEqualToString:@"closed"]) {
        /* 已开课*/
        _priceLabel.text = [NSString stringWithFormat:@"¥%@ (插班价)",exclusiveModel.current_price];
        _status.text = [NSString stringWithFormat:@" %@ [进度%@/%@] ",@"开课中",exclusiveModel.closed_events_count,exclusiveModel.events_count];
        _status.backgroundColor = [UIColor colorWithRed:0.14 green:0.80 blue:0.99 alpha:1.00];
    }else if ([exclusiveModel.status isEqualToString:@"missed"]||[exclusiveModel.status isEqualToString:@"init"]||[exclusiveModel.status isEqualToString:@"ready"]){
        /* 未开课*/
        _priceLabel.text = [NSString stringWithFormat:@"¥%@ (插班价)",exclusiveModel.current_price];
        _status.text = [NSString stringWithFormat:@" %@ [距开课%@天]",@" 招生中",[self intervalSinceNow:exclusiveModel.start_at]];
        _status.backgroundColor = [UIColor colorWithRed:0.08 green:0.59 blue:0.09 alpha:1.00];
    }else if ([exclusiveModel.status isEqualToString:@"finished"]||[exclusiveModel.status isEqualToString:@"billing"]||[exclusiveModel.status isEqualToString:@"completed"]){
        /* 结束了的*/
        _priceLabel.text = [NSString stringWithFormat:@" "];
        _status.text = [NSString stringWithFormat:@" %@ [进度%@/%@]",@"已结束",exclusiveModel.events_count,exclusiveModel.events_count];
        _status.backgroundColor = SEPERATELINECOLOR_2;
    }else if ([exclusiveModel.status isEqualToString:@"published"]){
        //招生中的课程
        /* 未开课*/
        _priceLabel.text = [NSString stringWithFormat:@"¥%@",exclusiveModel.price];

        if (exclusiveModel.start_at) {
            if ([exclusiveModel.start_at isEqualToString:@""]||[exclusiveModel.end_at isEqualToString:@""]) {
                _status.text = @" 招生中 ";
                _status.backgroundColor = [UIColor colorWithRed:0.08 green:0.59 blue:0.09 alpha:1.00];
            }else{
                NSInteger leftDay = [[self intervalSinceNow: [exclusiveModel.start_at changeTimeStampToDateString]]integerValue];
                NSString *leftDays;
                if (leftDay>=1) {
                    leftDays = [NSString stringWithFormat:@" 招生中 [距开课%ld天] ",leftDay];
                }else {
                    leftDays = @" 即将开课 ";
                }
                _status.text = leftDays;
                _status.backgroundColor = [UIColor colorWithRed:0.08 green:0.59 blue:0.09 alpha:1.00];
            }
        }else{
            _priceLabel.text = [NSString stringWithFormat:@"¥%@ (插班价)",exclusiveModel.current_price];
            _status.text = @" 招生中 ";
            _status.backgroundColor = [UIColor colorWithRed:0.08 green:0.59 blue:0.09 alpha:1.00];
        }
    }
}

/* 计算开课的时间差*/
- (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSString *timeString=@"";
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:theDate];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];

    //获取当前时间
    NSDate *adate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: adate];
    NSDate *localeDate = [adate  dateByAddingTimeInterval: interval];

    double intervalTime = [fromDate timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate];
    long lTime = labs((long)intervalTime);
    NSInteger iSeconds =  lTime % 60;
    NSInteger iMinutes = (lTime / 60) % 60;
    NSInteger iHours = labs(lTime/3600);
    NSInteger iDays = lTime/60/60/24;
    NSInteger iMonth =lTime/60/60/24/12;
    NSInteger iYears = lTime/60/60/24/384;
    NSLog(@"相差%ld年%ld月 或者 %ld日%ld时%ld分%ld秒", iYears,iMonth,(long)iDays,(long)iHours,(long)iMinutes,(long)iSeconds);
    if (iHours<1 && iMinutes>0)
    {
        timeString=[NSString stringWithFormat:@"%ld分",(long)iMinutes];
    }else if (iHours>0&&iDays<1 && iMinutes>0) {
        timeString=[NSString stringWithFormat:@"%ld时%ld分",(long)iHours,(long)iMinutes];
    }
    else if (iHours>0&&iDays<1) {
        timeString=[NSString stringWithFormat:@"%ld时",(long)iHours];
    }else if (iDays>0 && iHours>0)
    {
        timeString=[NSString stringWithFormat:@"%ld天%ld时",(long)iDays,(long)iHours];
    }
    else if (iDays>0)
    {
        timeString=[NSString stringWithFormat:@"%ld天",(long)iDays];
    }
    return timeString;
}

@end
