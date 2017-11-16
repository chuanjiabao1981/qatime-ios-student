//
//  OneOnOneTutoriumInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/31.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "OneOnOneTutoriumInfoViewController.h"
#import "NavigationBar.h"
#import "UIViewController+AFHTTP.h"
#import "YYModel.h"
#import "InteractionLesson.h"
#import "UITableView+CYLTableViewPlaceHolder.h"
#import "Teacher.h"
#import "OneOnOneLessonTableViewCell.h"
#import "OneOnOneTeacherTableViewCell.h"
#import "UIViewController+HUD.h"
#import "OrderViewController.h"
#import "TeachersPublicViewController.h"
#import "InteractionViewController.h"
#import "Features.h"
#import "TeacherFeatureTagCollectionViewCell.h"
#import "WorkFlowTableViewCell.h"
#import "UIViewController+Token.h"
#import "VideoPlayerViewController.h"
#import "InteractionReplayPlayerViewController.h"
#import "UIControl+RemoveTarget.h"
#import "SnailQuickMaskPopups.h"
#import "ShareViewController.h"
#import "WXApiObject.h"
#import "WXApi.h"

/**
 顶部视图的折叠/展开状态
 
 - LeadingViewStateFold: 折叠
 - LeadingViewStateUnfold: 展开
 */
typedef NS_ENUM(NSUInteger, LeadingViewState) {
    LeadingViewStateFold,
    LeadingViewStateUnfold,
};


@interface OneOnOneTutoriumInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,OneOnOneTeacherTableViewCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    UIView *_buyView;
    
    /**购买按钮*/
    UIButton *_buyButton;
    
    /** 分享按钮 */
    UIButton *_shareButton;
    
    /* 保存本页面数据*/
    NSMutableDictionary *_dataDic;
    
    /* 优惠码*/
    NSString *_promotionCode;
    
    /**教师组*/
    NSMutableArray <Teacher *>*_teachersArray;
    
    /**课程列表*/
    NSMutableArray <InteractionLesson *>*_classArray;
    
    /**课程model*/
    OneOnOneClass *_classMod;
    
    /**课程特色数组*/
    NSMutableArray *_classFeaturesArray;
    
    NSString *_lesson;
    
    BOOL _isBought;
    
    CGFloat _buttonWidth;
    
    ShareViewController *_share;
    SnailQuickMaskPopups *_pops;
    
    LeadingViewState _leadingViewState;

}

@end

@implementation OneOnOneTutoriumInfoViewController


- (instancetype)initWithClassID:(NSString *)classID
{
    self = [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
    }
    return self;
}


- (instancetype)initWithClassID:(NSString *)classID andPromotionCode:(NSString *)promotionCode{
    
    self = [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
        _promotionCode =[NSString stringWithFormat:@"%@",promotionCode];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _buttonWidth = self.view.width_sd/4-15*ScrenScale;
    
    _leadingViewState = LeadingViewStateUnfold;
    //初始化数据
    _teachersArray = @[].mutableCopy;
    _classArray = @[].mutableCopy;
    
    _classFeaturesArray = @[].mutableCopy;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fold) name:@"Fold" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unFold) name:@"Unfold" object:nil];
    
    //加载数据
    [self requestData];
    //加载导航栏
    [self setupNavigation];
    
    [self HUDStartWithTitle:@"正在加载"];
    
    //微信分享功能的回调通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sharedFinish:) name:@"SharedFinish" object:nil];
    
    
    
    
}
/**请求一对一辅导班详情*/
- (void)requestData{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/interactive_courses/%@/detail",Request_Header,_classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            _dataDic = [dic[@"data"] copy];
            //页面赋值
            _classMod = [OneOnOneClass yy_modelWithJSON:dic[@"data"][@"interactive_course"]];
            _classMod.classID = dic[@"data"][@"interactive_course"][@"id"];
            _classMod.descriptions = dic[@"data"][@"interactive_course"][@"description"];
            _classMod.attributeDescriptions = [[NSMutableAttributedString alloc]initWithData:[dic[@"data"][@"interactive_course"][@"description"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            //标题
            _navigationBar.titleLabel.text = _classMod.name;
            
            //特色
            for (NSString *key in _dataDic[@"interactive_course"][@"icons"]) {
                
                if (![key isEqualToString:@"cheap_moment"]) {
                    if ([_dataDic[@"interactive_course"][@"icons"][key]boolValue]==YES) {
                        Features *mod = [[Features alloc]init];
                        mod.include = [_dataDic[@"icons"][key] boolValue];
                        mod.content = key;
                        [_classFeaturesArray addObject:mod];
                    }
                }
            }
            
            //课时名称
            for (NSDictionary *lesson in dic[@"data"][@"interactive_course"][@"interactive_lesson"]) {
                if ([lesson[@"status"]isEqualToString:@"teaching"]) {
                    _lesson = lesson[@"name"];
                }
            }
            
            [self.view addSubview:self.myView];
            [self setupBuyBar];
            //赋值
            self.myView.model = _classMod;
            //教师
            if (_classMod.teachers.count!=0) {
                
                for (NSDictionary *dics in _classMod.teachers) {
                    Teacher *mod = [Teacher yy_modelWithJSON:dics];
                    mod.teacherID = dics[@"id"];
                    [_teachersArray addObject:mod];
                }
            }else{
            }
            
            //课程
            if (_classMod.interactive_lessons.count!=0) {
                for (NSDictionary *dics in _classMod.interactive_lessons) {
                    InteractionLesson *mod = [InteractionLesson yy_modelWithJSON:dics];
                    mod.classID = dics[@"id"];
                    [_classArray addObject:mod];
                }
            }else{
                
            }
            
            /* 判断课程状态*/
            [self switchClassData:dic];
            
            //加载子控制器
            [self setupChildControllers];
            [self HUDStopWithTitle:nil];
        }else{
            //数据错误
        }
        [self HUDStopWithTitle:nil];
    }failure:^(id  _Nullable erros) {
    }];
    
}

/** 加载子控制器 */
- (void)setupChildControllers{
    
    _infoVC = [[InteractiveInfo_InfoViewController alloc]initWithOneOnOneClass:_classMod];
    _teacherVC = [[InteractiveInfo_TeacherViewController alloc]initWithTeachers:_teachersArray];
    _classVC = [[InteractiveInfo_ClassListViewController alloc]initWithLessons:_classArray bought:_isBought];
    
    [self addChildViewController:_infoVC];
    [self addChildViewController:_teacherVC];
    [self addChildViewController:_classVC];
    [_myView.scrollView updateLayout];
    [_myView.scrollView addSubview:_infoVC.view];
    [_myView.scrollView addSubview:_teacherVC.view];
    [_myView.scrollView addSubview:_classVC.view];
    
    _infoVC.view.sd_layout
    .leftSpaceToView(_myView.scrollView, 0)
    .topSpaceToView(_myView.scrollView, 0)
    .bottomSpaceToView(_myView.scrollView, 0)
    .widthRatioToView(_myView.scrollView, 1.0);
    [_infoVC.view updateLayout];
    
    _teacherVC.view.sd_layout
    .leftSpaceToView(_infoVC.view , 0)
    .topSpaceToView(_myView.scrollView, 0)
    .bottomSpaceToView(_myView.scrollView, 0)
    .widthRatioToView(_infoVC.view , 1.0);
    [_teacherVC.view updateLayout];
    
    _classVC.view.sd_layout
    .leftSpaceToView(_teacherVC.view, 0)
    .topSpaceToView(_myView.scrollView, 0)
    .bottomSpaceToView(_myView.scrollView, 0)
    .widthRatioToView(_infoVC.view, 1.0);
    [_classVC.view updateLayout];
    
    [_myView.scrollView setupAutoContentSizeWithBottomView:_infoVC.view bottomMargin:0];
    [_myView.scrollView setupAutoContentSizeWithRightView:_teacherVC.view rightMargin:414];
    
    [self.view bringSubviewToFront:_navigationBar];
    
    //回放的回调
    typeof(self) __weak weakSelf = self;
    _classVC.replayBlock = ^(UITableView *tableView, NSIndexPath *indexPath) {
        [weakSelf replay:tableView indexPath:indexPath];
    };
    
}


#pragma mark- 判断课程状态
- (void)switchClassData:(NSDictionary *)dic{
    
    if (dic[@"data"][@"interactive_course"]) {//一对一都不是免费课
        if (![dic[@"data"][@"ticket"]isEqual:[NSNull null]]) {//已试听过或已购买过
            //如果课程未结束
            if (![dic[@"data"][@"interactive_course"][@"status"]isEqualToString:@"completed"]) {
                if (dic[@"data"][@"ticket"][@"type"]) {
                    if ([dic[@"data"][@"ticket"][@"type"]isEqualToString:@"LiveStudio::BuyTicket"]) {//已购买,显示开始学习按钮
                        _isBought = YES;
                        /* 已经购买的情况下*/
                        [_buyButton setTitle:@"开始学习" forState:UIControlStateNormal];
                        _buyButton.backgroundColor = NAVIGATIONRED;
                        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [_buyButton addTarget:self action:@selector(enterClass) forControlEvents:UIControlEventTouchUpInside];
                        
                    }else{//未购买,显示进入试听按钮 购买按钮照常使用
                        _isBought = NO;
                        [_buyButton removeAllTargets];
                        [_buyButton setTitle:@"立即报名" forState:UIControlStateNormal];
                        _buyButton.backgroundColor = [UIColor whiteColor];
                        [_buyButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
                        [_buyButton addTarget:self action:@selector(buyClass:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }else{//课程已经结束了
                //整个购买栏直接隐藏吧
                _buyView.hidden = YES;
                self.myView.sd_layout
                .bottomSpaceToView(self.view, 0);
                [self.myView updateLayout];
            }
            
        }else{//需要购买
            [_buyButton setTitle:@"立即报名" forState:UIControlStateNormal];
            [_buyButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
            [_buyButton removeAllTargets];
            [_buyButton addTarget:self action:@selector(buyClass:) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([dic[@"data"][@"course"][@"off_shelve"]boolValue]==YES) {//已下架
            //已经下架
            _buyView.hidden = YES;
            self.myView.sd_layout
            .bottomSpaceToView(self.view, 0);
            [self.myView updateLayout];
            _myView.priceLabel.text = @"已下架";
        }else{
              
        }
    }
}


/**进入教师详情页*/
- (void)selectedTeacher:(NSString *)teacherID{
    
    TeachersPublicViewController *controller = [[TeachersPublicViewController alloc]initWithTeacherID:teacherID];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}

/**进入互动课程*/
- (void)enterClass{
    /**
     直接进入一对一互动直播
     */
    NIMChatroom *chatRoom = [[NIMChatroom alloc]init];
    chatRoom.roomId = _dataDic[@"interactive_course"][@"chat_team"][@"team_id"] ;
    
    InteractionViewController *controller = [[InteractionViewController alloc]initWithChatroom:chatRoom andClassID:_classID andChatTeamID:_dataDic[@"interactive_course"][@"chat_team"][@"team_id"] andLessonName:_lesson==nil?@"暂无直播":_lesson];
    [self.navigationController pushViewController:controller animated:YES];
    
}

/**购买课程*/
- (void)buyClass:(UIButton *)sender{
    
    OrderViewController *orderVC;
    
    if (_promotionCode) {
        
        orderVC = [[OrderViewController alloc]initWithClassID:_classID andPromotionCode:_promotionCode andClassType:InteractionType andProductName:_dataDic[@"name"]];
    }else{
        
        orderVC= [[OrderViewController alloc]initWithClassID:_classID andClassType:InteractionType andProductName:_dataDic[@"name"]];
    }
    
    
    [self.navigationController pushViewController:orderVC animated:YES];

}



/**加载主视图*/
- (void)setupMainViews{
    
    [self.view addSubview:self.myView];
    
    [self.myView updateLayout];
    
}

-(OneOnOneTutorimInfoView *)myView{
    
    if (!_myView) {
        _myView =[[OneOnOneTutorimInfoView alloc]initWithFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd-Navigation_Height-TabBar_Height)];
        
        typeof(self) __weak weakSelf = self;
        _myView.segmentControl.indexChangeBlock = ^(NSInteger index) {
            [weakSelf.myView.scrollView scrollRectToVisible:CGRectMake(weakSelf.view.width_sd*index, 0, weakSelf.view.width_sd, weakSelf.myView.scrollView.height_sd) animated:YES];
        };
        _myView.scrollView.delegate = self;
        _myView.classFeature.dataSource = self;
        _myView.classFeature.delegate = self;
        [_myView.classFeature registerClass:[TeacherFeatureTagCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    }
    return _myView;
}


/**加载导航栏和购买bar*/
- (void)setupNavigation{
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), Navigation_Height)];
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [self.view addSubview:_navigationBar];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastpage) forControlEvents:UIControlEventTouchUpInside];
    
}
/**购买按钮*/
- (void)setupBuyBar{
    
    /* 购买bar*/
    _buyView = [[UIView alloc]init];
    _buyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_buyView];
    _buyView.sd_layout
    .leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(TabBar_Height);
    
    [self.view bringSubviewToFront:_buyView];
    
    UIView *lines = [[UIView alloc]init];
    lines.backgroundColor = SEPERATELINECOLOR_2;
    [_buyView addSubview:lines];
    lines.sd_layout
    .leftSpaceToView(_buyView, 0)
    .rightSpaceToView(_buyView, 0)
    .topSpaceToView(_buyView, 0)
    .heightIs(0.5);
    _buyButton = [[UIButton alloc]init];
    
    _buyButton.layer.borderColor = NAVIGATIONRED.CGColor;
    _buyButton.layer.borderWidth = 1;
    [_buyView addSubview:_buyButton];
    _buyButton.sd_layout
    .rightSpaceToView(_buyView, 10*ScrenScale)
    .bottomSpaceToView(_buyView, 10*ScrenScale)
    .topSpaceToView(_buyView, 10*ScrenScale)
    .widthIs(_buttonWidth);
    _buyButton.sd_cornerRadius = @2;
    [_buyButton updateLayout];
    
    if (![self isLogin]) {
        [_buyButton addTarget:self action:@selector(loginAgain) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _shareButton  = [[UIButton alloc]init];
    [_shareButton setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateNormal];
    [_buyView addSubview:_shareButton];
    _shareButton.sd_layout
    .leftSpaceToView(_buyView, 15*ScrenScale)
    .topSpaceToView(_buyView, 10*ScrenScale)
    .bottomSpaceToView(_buyView, 10*ScrenScale)
    .widthEqualToHeight();
    [_shareButton updateLayout];
    [_shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark- UIScrollView delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _myView.scrollView) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        
        [_myView.segmentControl setSelectedSegmentIndex:page animated:YES];
    }
    
}

#pragma mark- UICollectionView datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger num;
    
    if (_classFeaturesArray.count==0) {
        num = 3;
    }else{
        num = _classFeaturesArray.count;
    }
    
    return num;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"CollectionCell";
    TeacherFeatureTagCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (_classFeaturesArray.count>indexPath.row) {
        
        cell.model = _classFeaturesArray[indexPath.row];
        [cell updateLayoutSubviews];
    }
    
    return cell;
    
}

#pragma mark- UICollectionView delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

/* item尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake(self.view.width_sd/3.0,20);
}





/**无数据占位图*/
- (UIView *)makePlaceHolderView{
    
    return [UIView new];
}

- (BOOL)enableScrollWhenPlaceHolderViewShowing{
    
    return YES;
}

/** 分享功能 */
/** 分享功能 */
- (void)share{
    _share = [[ShareViewController alloc]init];
    _share.view.frame = CGRectMake(0, 0, self.view.width_sd, TabBar_Height*1.5);
    _pops = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackTranslucent aView:_share.view];
    _pops.presentationStyle = PresentationStyleBottom;
    [_pops presentWithAnimated:YES completion:^(BOOL finished, SnailQuickMaskPopups * _Nonnull popups) {}];
    [_share.sharedView.wechatBtn addTarget:self action:@selector(wechatShare:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)wechatShare:(UIButton *)sender{
    [_pops dismissWithAnimated:YES completion:^(BOOL finished, SnailQuickMaskPopups * _Nonnull popups) {
    }];
    if (![WXApi isWXAppInstalled]) {
        [self HUDStopWithTitle:@"您尚未安装微信"];
        return;
    }
    //在这儿传个参数.
    [_share sharedWithContentDic:@{
                                   @"type":@"link",
                                   @"content":@{
                                           @"title":_classMod.name,
                                           @"description":@"一对一课程",
                                           @"link":[NSString stringWithFormat:@"%@/live_studio/interactive_courses/%@",Request_Header,_classID]
                                           }
                                   }];
    
}

- (void)sharedFinish:(NSNotification *)notification{
    
    SendMessageToWXResp *resp = [notification object];
    if (resp.errCode == 0) {
        [self HUDStopWithTitle:@"分享成功"];
    }else if (resp.errCode == -1){
        [self HUDStopWithTitle:@"分享失败"];
    }else if (resp.errCode == -2){
        [self HUDStopWithTitle:@"取消分享"];
    }
}

/** 折叠 */
- (void)fold{
    if (_leadingViewState == LeadingViewStateUnfold) {
        //折叠
        _leadingViewState = LeadingViewStateFold;
        [_myView.headView updateLayout];
        CGFloat bottomHeigh;
        if (_buyView.hidden) {
            bottomHeigh = 0;
        }else{
            bottomHeigh = TabBar_Height;
        }
        [UIView animateWithDuration:0.3 animations:^{
            _myView.sd_layout
            .topSpaceToView(_navigationBar, -_myView.headView.height_sd);
            [_myView updateLayout];
        }];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeFold" object:nil];
    }else{
        NSLog(@"错误了......");
    }
}

/** 展开 */
- (void)unFold{
    if (_leadingViewState == LeadingViewStateFold) {
        //展开
        _leadingViewState = LeadingViewStateUnfold;
        [UIView animateWithDuration:0.3 animations:^{
            _myView.sd_layout
            .topSpaceToView(_navigationBar, 0);
            [_myView updateLayout];
        }];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeUnfold" object:nil];
    }else{
        NSLog(@"错误了2.....");
    }
}

//回放方法
- (void)replay:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    OneOnOneLessonTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (_isBought ==YES) {
        if (cell.model.replayable == YES) {
            //一对一课回放详情
            //            [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/scheduled_lessons/%@/replay",Request_Header,cell.model.classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
            //
            //                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
            //
            //                if ([dic[@"status"]isEqualToNumber:@1]) {
            //
            //                    if ([dic[@"data"][@"replayable"]boolValue]== YES) {
            //                        if (dic[@"data"][@"replay"]==nil) {
            //
            //                        }else{
            //                            NSMutableArray *decodeParm = [[NSMutableArray alloc] init];
            //                            [decodeParm addObject:@"software"];
            //                            [decodeParm addObject:@"videoOnDemand"];
            //
            //                            InteractionReplayPlayerViewController *video  = [[InteractionReplayPlayerViewController alloc]initWithURL:[NSURL URLWithString:dic[@"data"][@"replay"][@"orig_url"]] andDecodeParm:decodeParm andTitle:dic[@"data"][@"name"]];
            //                            [self presentViewController:video animated:YES completion:^{
            //
            //                            }];
            //                        }
            //
            //                    }else{
            //                        [self HUDStopWithTitle:@"服务器繁忙"];
            //                    }
            //
            //                }else{
            //                    [self HUDStopWithTitle:@"暂无回放视频"];
            //                }
            //
            //            }failure:^(id  _Nullable erros) {
            //
            //            }];
            
            
            [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/interactive_lessons/%@/replay",Request_Header,cell.model.classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                if ([dic[@"status"]isEqualToNumber:@1]) {
                    
                    if ([dic[@"data"][@"replayable"]boolValue]== YES) {
                        if (dic[@"data"][@"replay"]==nil) {
                            
                        }else{
                            NSMutableArray *decodeParm = [[NSMutableArray alloc] init];
                            [decodeParm addObject:@"software"];
                            [decodeParm addObject:@"videoOnDemand"];
                            
                            VideoPlayerViewController *video  = [[VideoPlayerViewController alloc]initWithURL:[NSURL URLWithString:dic[@"data"][@"replay"][@"orig_url"]] andDecodeParm:decodeParm andTitle:dic[@"data"][@"name"]];
                            [self presentViewController:video animated:YES completion:^{
                                
                            }];
                        }
                        
                        
                        NSArray *replayArr = dic[@"data"][@"replay"];
                        NSURL *playingURL = [NSURL URLWithString:replayArr[indexPath.row][@"shd_url"]];
                        InteractionReplayPlayerViewController *controller = [[InteractionReplayPlayerViewController alloc]initWithURL:playingURL andTitle:dic[@"data"][@"name"] andReplayArray:replayArr andPlayingIndex:indexPath];
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                }
                
            } failure:^(id  _Nullable erros) {
                
            }];
            
        }else{
            
        }
    }
    
}


/**返回上一页*/
- (void)returnLastpage{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
