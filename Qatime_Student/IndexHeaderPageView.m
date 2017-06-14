//
//  IndexHeaderPageView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "IndexHeaderPageView.h"
#import "YZSquareMenuCell.h"
#import "TodayLiveCollectionViewCell.h"



@interface IndexHeaderPageView (){
    
    UIView *_squareButton;  //放按钮的视图
    NSArray *menuImages;
    NSArray *menuTitiels;
}

@end


@implementation IndexHeaderPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        /* banner页布局*/
        _cycleScrollView =[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame)*316/1190) imageURLStringsGroup:@[]];
        [self addSubview:_cycleScrollView];
        
        //年级筛选滑动视图
        _gradeMenu = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _cycleScrollView.bottom_sd, self.width_sd, 60*ScrenScale)];
        _gradeMenu.showsHorizontalScrollIndicator = NO;
        
        NSArray *gradeArr= @[@"高三",@"高二",@"高一",@"初三",@"初二",@"初一",@"六年级",@"五年级",@"四年级",@"三年级",@"二年级",@"一年级"];
        _buttons = @[].mutableCopy;
        
        //遍历按钮.
        NSInteger index =0;
        for (NSString *grade in gradeArr) {
            UIButton *btn = [[UIButton alloc]init];
            [btn setTitle:grade forState:UIControlStateNormal];
            [btn setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16*ScrenScale];
            btn.tag = index;
            [_gradeMenu addSubview:btn];
            
            btn.sd_layout
            .topSpaceToView(_gradeMenu,10)
            .bottomSpaceToView(_gradeMenu,10)
            .leftSpaceToView(_gradeMenu, self.width_sd/6*index)
            .widthIs(self.width_sd/6);
            [btn updateLayout];
            
            [_buttons addObject:btn];
            index++;
        }
        [self addSubview:_gradeMenu];
        
        [_gradeMenu setupAutoContentSizeWithRightView:[_buttons lastObject] rightMargin:5];
        
        /* 分割线1*/
        UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_gradeMenu.frame), CGRectGetWidth(self.bounds), 10.0)];
        line1.backgroundColor =[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
        [self addSubview:line1];
        
        //今日直播的 栏
        UIView *todayLiveView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame), self.width_sd, 40)];
        [self addSubview:todayLiveView];
        
        //@"今日直播"
        UILabel *todayLiveLabel = [[UILabel alloc]init];
        todayLiveLabel.text = @"今日直播";
        todayLiveLabel.font = [UIFont systemFontOfSize:17*ScrenScale];
        todayLiveLabel.textColor = [UIColor blackColor];
        [todayLiveView addSubview:todayLiveLabel];
        todayLiveLabel.sd_layout
        .topSpaceToView(todayLiveView,10)
        .bottomSpaceToView(todayLiveView,10)
        .leftSpaceToView(todayLiveView,12);
        [todayLiveLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        //今日直播 滑动视图
        UICollectionViewFlowLayout *liveFlowLayout = [[UICollectionViewFlowLayout alloc]init];
        liveFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _todayLiveScrollView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, todayLiveView.bottom_sd, self.width_sd,_cycleScrollView.height_sd*1.2) collectionViewLayout:liveFlowLayout];
        _todayLiveScrollView.backgroundColor =[UIColor whiteColor];
        [self addSubview:_todayLiveScrollView];
        
        
        //分割线2
        UIView *line2 =[[UIView alloc]initWithFrame:CGRectMake(0, _todayLiveScrollView.bottom_sd+10, CGRectGetWidth(self.bounds), 10.0)];
        line2.backgroundColor =[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
        [self addSubview:line2];
        
        
        //精选内容 栏
        _fancyView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame), self.width_sd, 40)];
        _fancyView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_fancyView];
        
        //@"精选内容"
        UILabel *fancyLabel = [[UILabel alloc]init];
        fancyLabel.text = @"精选内容";
        fancyLabel.font = [UIFont systemFontOfSize:17*ScrenScale];
        fancyLabel.textColor = [UIColor blackColor];
        [_fancyView addSubview:fancyLabel];
        fancyLabel.sd_layout
        .topSpaceToView(_fancyView,10)
        .bottomSpaceToView(_fancyView,10)
        .leftSpaceToView(_fancyView,12);
        [fancyLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        //@"精选内容  更多按钮"
        _moreFancyButton = [[UIControl alloc]init];
        [_fancyView addSubview:_moreFancyButton];
        
        UIImageView  *arrow  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightArrow"]];
        [_moreFancyButton addSubview:arrow];
        arrow.userInteractionEnabled = YES;
        arrow.sd_layout
        .rightSpaceToView(_moreFancyButton,0)
        .centerYEqualToView(_moreFancyButton)
        .heightRatioToView(_moreFancyButton,0.5)
        .widthEqualToHeight();
        
        UILabel *fancys = [[UILabel alloc]init];
        fancys.userInteractionEnabled = YES;
        [_moreFancyButton addSubview:fancys];
        fancys.textColor = TITLECOLOR;
        fancys.text = @"更多";
        fancys.font = [UIFont systemFontOfSize:12*ScrenScale];
        fancys.sd_layout
        .rightSpaceToView(arrow,0)
        .topEqualToView(arrow)
        .bottomEqualToView(arrow);
        [fancys setSingleLineAutoResizeWithMaxWidth:200];
        
        _moreFancyButton.sd_layout
        .rightSpaceToView(_fancyView,12)
        .centerYEqualToView(fancyLabel)
        .topEqualToView(fancyLabel)
        .bottomEqualToView(fancyLabel)
        .widthIs(60);
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeHeight:) name:@"TodayHeight" object:nil];
        
    }
    return self;
}

- (void)changeHeight:(NSNotification *)notification{
    
    TodayLiveCollectionViewCell *cell = notification.object;
    _todayLiveScrollView.sd_layout
    .heightIs(cell.height_sd);
    
}







@end
