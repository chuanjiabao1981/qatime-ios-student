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
#import "UIControl+EnloargeTouchArea.h"



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
        _cycleScrollView =[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame)*1/3.7) imageURLStringsGroup:@[]];
        [self addSubview:_cycleScrollView];
        [_cycleScrollView updateLayout];
        
        //年级筛选滑动视图
        _gradeMenu = [[UIScrollView alloc]init];
        
        _gradeMenu.showsHorizontalScrollIndicator = NO;
        
        NSArray *gradeArr= @[NSLocalizedString(@"高三", nil),NSLocalizedString(@"高二", nil),NSLocalizedString(@"高一", nil),NSLocalizedString(@"初三", nil),NSLocalizedString(@"初二", nil),NSLocalizedString(@"初一", nil),NSLocalizedString(@"六年级", nil),NSLocalizedString(@"五年级", nil),NSLocalizedString(@"四年级", nil),NSLocalizedString(@"三年级", nil),NSLocalizedString(@"二年级", nil),NSLocalizedString(@"一年级", nil)];
        
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
        _gradeMenu.sd_layout
        .leftSpaceToView(self, 0)
        .topSpaceToView(_cycleScrollView, 0)
        .rightSpaceToView(self, 0)
        .heightIs(60*ScrenScale);
        
        [_gradeMenu setupAutoContentSizeWithRightView:[_buttons lastObject] rightMargin:5];
    
        //所有教师和回放课程视图
        UIView *allTeachersAndReplyView = [[UIView alloc]init];
        [self addSubview:allTeachersAndReplyView];
        allTeachersAndReplyView.sd_layout
        .leftSpaceToView(self, 0)
        .topSpaceToView(_gradeMenu, 0)
        .rightSpaceToView(self, 0)
        .heightIs(40);
        [allTeachersAndReplyView updateLayout];
        
        UIView *lineTop = [[UIView alloc]init];
        [allTeachersAndReplyView addSubview:lineTop];
        lineTop.backgroundColor = SEPERATELINECOLOR_2;
        lineTop.sd_layout
        .leftSpaceToView(allTeachersAndReplyView, 0)
        .rightSpaceToView(allTeachersAndReplyView, 0)
        .topSpaceToView(allTeachersAndReplyView, 0)
        .heightIs(0.5);
        
        UIView *lineBottom = [[UIView alloc]init];
        [allTeachersAndReplyView addSubview:lineBottom];
        lineBottom.backgroundColor = SEPERATELINECOLOR_2;
        lineBottom.sd_layout
        .leftSpaceToView(allTeachersAndReplyView, 0)
        .rightSpaceToView(allTeachersAndReplyView, 0)
        .bottomSpaceToView(allTeachersAndReplyView, 0)
        .heightIs(0.5);
        
        UIView *lineMiddle = [[UIView alloc]init];
        [allTeachersAndReplyView addSubview:lineMiddle];
        lineMiddle.backgroundColor = SEPERATELINECOLOR_2;
        lineMiddle.sd_layout
        .topSpaceToView(allTeachersAndReplyView, 10*ScrenScale)
        .bottomSpaceToView(allTeachersAndReplyView, 10*ScrenScale)
        .centerXEqualToView(allTeachersAndReplyView)
        .widthIs(0.5);
        
        
        //两个按钮
        _allTeachersBtn = [[UIControl alloc]init];
        [allTeachersAndReplyView addSubview:_allTeachersBtn];
        _allTeachersBtn.sd_layout
        .leftSpaceToView(allTeachersAndReplyView, 0)
        .topSpaceToView(lineTop, 0)
        .bottomSpaceToView(lineBottom, 0)
        .rightSpaceToView(lineMiddle, 0);
        [_allTeachersBtn updateLayout];
        UILabel *title1 = [[UILabel alloc]init];
        [_allTeachersBtn addSubview:title1];
        title1.text = @"全部老师";
        title1.font = TEXT_FONTSIZE;
        title1.textColor = BUTTONRED;
        title1.sd_layout
        .centerYEqualToView(_allTeachersBtn)
        .autoHeightRatio(0);
        [title1 setSingleLineAutoResizeWithMaxWidth:200];
        [title1 updateLayout];
        UIImageView *icon1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"allteacher"]];
        [_allTeachersBtn addSubview:icon1];
        icon1.sd_layout
        .rightSpaceToView(title1, 10*ScrenScale)
        .centerYEqualToView(title1)
        .heightRatioToView(title1, 0.8)
        .widthEqualToHeight();
        [icon1 updateLayout];
        icon1.sd_resetLayout
        .leftSpaceToView(_allTeachersBtn, (_allTeachersBtn.width_sd-title1.width_sd-10*ScrenScale-icon1.width_sd)/2.f)
        .centerYEqualToView(title1)
        .heightRatioToView(title1, 0.7)
        .widthEqualToHeight();
        [icon1 updateLayout];
        title1.sd_resetLayout
        .leftSpaceToView(icon1, 10*ScrenScale)
        .centerYEqualToView(icon1)
        .autoHeightRatio(0);
        [title1 setSingleLineAutoResizeWithMaxWidth:200];
        [title1 updateLayout];
        
        
        _reviewBtn = [[UIControl alloc]init];
        [allTeachersAndReplyView addSubview:_reviewBtn];
        _reviewBtn.sd_layout
        .leftSpaceToView(lineMiddle, 0)
        .topSpaceToView(lineTop, 0)
        .bottomSpaceToView(lineBottom, 0)
        .rightSpaceToView(allTeachersAndReplyView, 0);
        [_reviewBtn updateLayout];
        UILabel *title2 = [[UILabel alloc]init];
        [_reviewBtn addSubview:title2];
        title2.text = @"精彩回放";
        title2.font = TEXT_FONTSIZE;
        title2.textColor = BUTTONRED;
        title2.sd_layout
        .centerYEqualToView(_allTeachersBtn)
        .autoHeightRatio(0);
        [title2 setSingleLineAutoResizeWithMaxWidth:200];
        [title2 updateLayout];
        UIImageView *icon2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"replay"]];
        [_reviewBtn addSubview:icon2];
        icon2.sd_layout
        .rightSpaceToView(title1, 10*ScrenScale)
        .centerYEqualToView(title1)
        .heightRatioToView(title1, 0.8)
        .widthEqualToHeight();
        [icon2 updateLayout];
        icon2.sd_resetLayout
        .leftSpaceToView(_reviewBtn, (_reviewBtn.width_sd-title1.width_sd-10*ScrenScale-icon2.width_sd)/2.f)
        .centerYEqualToView(title2)
        .heightRatioToView(title2, 0.7)
        .widthEqualToHeight();
        [icon2 updateLayout];
        title2.sd_resetLayout
        .leftSpaceToView(icon2, 10*ScrenScale)
        .centerYEqualToView(icon2)
        .autoHeightRatio(0);
        [title2 setSingleLineAutoResizeWithMaxWidth:200];
        [title2 updateLayout];

        
        //今日直播的 栏
        UIView *todayLiveView = [[UIView alloc]init];
        [self addSubview:todayLiveView];
        
        todayLiveView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(allTeachersAndReplyView, 0)
        .heightIs(40);
        
        //@"今日直播"
        UILabel *todayLiveLabel = [[UILabel alloc]init];
        todayLiveLabel.text = NSLocalizedString(@"今日直播", nil);
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
        _todayLiveScrollView.showsHorizontalScrollIndicator =  NO;
        _todayLiveScrollView.showsVerticalScrollIndicator = NO;
        _todayLiveScrollView.backgroundColor =[UIColor whiteColor];
        [self addSubview:_todayLiveScrollView];
        _todayLiveScrollView.sd_layout
        .leftSpaceToView(self, 0)
        .topSpaceToView(todayLiveView, 0)
        .rightSpaceToView(self, 0)
        .heightIs(_cycleScrollView.height_sd*1);
        
        
        //分割线2
        UIView *line2 =[[UIView alloc]init];
        line2.backgroundColor =[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
        [self addSubview:line2];
        
        line2.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_todayLiveScrollView, 10)
        .heightIs(10);
        
        //推荐教师
        //推荐教室的 栏
        UIView *recommandView = [[UIView alloc]init];
        [self addSubview:recommandView];
        
        recommandView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(line2, 0)
        .heightIs(40);
        
        //@"今日直播"
        UILabel *recommandLabel = [[UILabel alloc]init];
        recommandLabel.text = NSLocalizedString(@"推荐教师", nil);
        recommandLabel.font = [UIFont systemFontOfSize:17*ScrenScale];
        recommandLabel.textColor = [UIColor blackColor];
        [recommandView addSubview:recommandLabel];
        recommandLabel.sd_layout
        .topSpaceToView(recommandView,10)
        .bottomSpaceToView(recommandView,10)
        .leftSpaceToView(recommandView,12);
        [recommandLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        UICollectionViewFlowLayout *teacherLayout = [[UICollectionViewFlowLayout alloc]init];
        teacherLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _recommandTeachersView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width_sd, 100) collectionViewLayout:teacherLayout];
        _recommandTeachersView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_recommandTeachersView];
        _recommandTeachersView.showsHorizontalScrollIndicator = NO;
        _recommandTeachersView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(recommandView, 0)
        .heightIs(100);
        
        //划一道优雅的分割线
        UIView *line3 = [[UIView alloc]init];
        [self addSubview:line3];
        line3.backgroundColor =[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];

        line3.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_recommandTeachersView, 10)
        .heightIs(10);

        
        //精选内容 栏
        _fancyView = [[UIView alloc]init];
        _fancyView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_fancyView];
        _fancyView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(line3, 0)
        .heightIs(40);
        
        
        //@"精选内容"
        UILabel *fancyLabel = [[UILabel alloc]init];
        fancyLabel.text = NSLocalizedString(@"精选内容", nil);
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
        [_moreFancyButton setEnlargeEdge:20];
        
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
        fancys.text = NSLocalizedString(@"更多", nil);
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
        
        [self setupAutoHeightWithBottomView:_fancyView bottomMargin:0];
        
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
