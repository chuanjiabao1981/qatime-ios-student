//
//  VideoClassInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/11.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassInfoViewController.h"
#import "NavigationBar.h"
#import "VideoClassListTableViewCell.h"
#import "VideoClassInfo.h"
#import "CYLTableViewPlaceHolder.h"
#import "HaveNoClassView.h"
#import "VideoClassBuyBar.h"
#import "UIViewController+AFHTTP.h"
#import "YYModel.h"
#import "UIControl+RemoveTarget.h"
#import "VideoClass.h"
#import "YYModel.h"
#import "VideoClassPlayerViewController.h"
#import "OrderViewController.h"
#import "Features.h"
#import "TeacherFeatureTagCollectionViewCell.h"
#import "UIViewController+HUD.h"
#import "TeachersPublicViewController.h"
#import "UIViewController+Token.h"
#import "VideoPlayerViewController.h"
#import "SnailQuickMaskPopups.h"
#import "ShareViewController.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "ClassMembersViewController.h"
#import "ChatViewController.h"

typedef enum : NSUInteger {
    PullToRefresh,
    PushToLoadMore,
    
} RefreshType;

/**
 顶部视图的折叠/展开状态
 
 - LeadingViewStateFold: 折叠
 - LeadingViewStateUnfold: 展开
 */
typedef NS_ENUM(NSUInteger, LeadingViewState) {
    LeadingViewStateFold,
    LeadingViewStateUnfold,
};

@interface VideoClassInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CYLTableViewPlaceHolderDelegate,VideoClassBuyBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    
    
    /**数据源*/
    NSMutableArray <VideoClass *>*_classArray;
    
    /**课程ID*/
    NSString *_classID;
    
    /**model*/
    VideoClassInfo *_classInfo;
    
    /**教师详情*/
    Teacher *_teacher;
    
    /**课程特色 数组*/
    NSMutableArray *_classFeaturesArray;
    
//    BOOL _isBought;
    
    CGFloat _buttonWidth;
    
    ShareViewController *_share;
    SnailQuickMaskPopups *_pops;
    
    LeadingViewState _leadingViewState;
    
}

@property (nonatomic, strong) NavigationBar *navigationBar;;

/**主视图*/
@property (nonatomic, strong) VideoClassInfoView *videoClassInfoView ;

/**购买栏*/
@property (nonatomic, strong) VideoClassBuyBar *buyBar ;


@end

@implementation VideoClassInfoViewController


- (instancetype)initWithClassID:(NSString *)classID{
    
    self = [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
    }
    return self;
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [CommonMenuView clearMenu];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self makeMenu];
    self.tabBarController.tabBar.hidden = YES;
}

/**导航栏*/
- (void)setupNavigation{
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview: _navigationBar];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar.rightButton setImage:[UIImage imageNamed:@"moreMenu"] forState:UIControlStateNormal];
    //    self.navigationBar.rightButton.hidden = YES;
    [_navigationBar.rightButton addTarget:self action:@selector(moreMenu) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)makeMenu{
    
    NSDictionary *dict1 = @{@"imageName" : @"icon_button_affirm",
                            @"itemName" : @"进入聊天"
                            };
    NSDictionary *dict2 = @{@"imageName" : @"icon_button_record",
                            @"itemName" : @"成员列表"
                            };
    NSArray *menuArray = @[dict1,dict2];
    
    if (!_freeClass) {
        if (_isBought) {
            if (_isFinished) {
                menuArray = @[dict2];
            }else{
                menuArray = @[dict1,dict2];
            }
        }else{
            if (_tasteOver) {
                menuArray = @[dict2];
            }else{
                if (_onlyTaste) {
                    //如果加入了试听
                    menuArray = @[dict1,dict2];
                }else{
                    menuArray = @[dict2];
                }
            }
        }
    }else{
        if (_isBought) {
            //已经加入了免费课
            menuArray = @[dict1,dict2];
        }else{
            menuArray = @[dict2];
        }
    }
    
    __weak __typeof(&*self)weakSelf = self;
    /**
     *  创建普通的MenuView，frame可以传递空值，宽度默认120，高度自适应
     */
    [CommonMenuView createMenuWithFrame:CGRectZero target:self dataArray:menuArray itemsClickBlock:^(NSString *str, NSInteger tag) {
        [weakSelf doSomething:(NSString *)str tag:(NSInteger)tag]; // do something
    } backViewTap:^{
        weakSelf.navigationBar.rightButton .selected = NO;; // 这里的目的是，让rightButton点击，可再次pop出menu
    }];
}
/** 更多菜单 */
- (void)moreMenu{
    
    [self popMenu:CGPointMake(self.navigationBar.rightButton.centerX_sd,self.navigationBar.bottom_sd)];
}
- (void)popMenu:(CGPoint)point{
    if (self.navigationBar.rightButton.selected == NO) {
        [CommonMenuView showMenuAtPoint:point];
        self.navigationBar.rightButton.selected = YES;
    }else{
        [CommonMenuView hidden];
        self.navigationBar.rightButton.selected = NO;
    }
}

#pragma mark -- 专属菜单点击 回调事件(自定义)
- (void)doSomething:(NSString *)str tag:(NSInteger)tag{
    __block UIViewController *controller ;
    if ([str isEqualToString:@"进入聊天"]) {
        controller = [[ChatViewController alloc]initWithClass:_classID andClassType:LiveCourseType];
    }else if ([str isEqualToString:@"成员列表"]){
        controller = [[ClassMembersViewController alloc]initWithClassID:_classID andCourseType:LiveCourse];
    }
    
    self.navigationBar.rightButton.selected = NO;
    [self.navigationController pushViewController:controller animated:YES];
    
    [CommonMenuView hidden];
}


/**加载主视图*/
- (void)setupMainView{
    
    _videoClassInfoView = [[VideoClassInfoView alloc]initWithFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd - Navigation_Height - TabBar_Height)];
    [self.view addSubview:_videoClassInfoView];
    
    _videoClassInfoView.scrollView.delegate = self;
    
    _videoClassInfoView.classFeature.dataSource = self;
    _videoClassInfoView.classFeature.delegate = self;
    [_videoClassInfoView.classFeature registerClass:[TeacherFeatureTagCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    typeof(self) __weak weakSelf = self;
    [_videoClassInfoView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.videoClassInfoView.scrollView scrollRectToVisible:CGRectMake(weakSelf.view.width_sd*index, 0, weakSelf.view.width_sd, weakSelf.videoClassInfoView.scrollView.height_sd) animated:YES];
    }];
    
    [self.view bringSubviewToFront:_navigationBar];
}

/**加载购买栏*/
- (void)setupBuyBar{
    _buyBar = [[VideoClassBuyBar alloc]initWithFrame: CGRectMake(0, self.view.height_sd-TabBar_Height, self.view.width_sd, TabBar_Height)];
    [self.view addSubview:_buyBar];
    
    _buyBar.delegate = self;
    
}

/** 加载子控制器 */
- (void)setupControllers{
    
    _infoVC = [[VideoClassInfo_InfoViewController alloc]initWithClassInfo:_classInfo];
    [self addChildViewController:_infoVC];
    [_videoClassInfoView.scrollView addSubview:_infoVC.view];
    _infoVC.view.sd_layout
    .leftSpaceToView(_videoClassInfoView.scrollView, 0)
    .topSpaceToView(_videoClassInfoView.scrollView, 0)
    .bottomSpaceToView(_videoClassInfoView.scrollView, 0)
    .widthRatioToView(_videoClassInfoView.scrollView, 1.0);
    [_infoVC.view updateLayout];
    
    _teacherVC = [[VideoClassInfo_TeacherViewController alloc]initWithTeacher:_teacher];
    [self addChildViewController:_teacherVC];
    [_videoClassInfoView.scrollView addSubview:_teacherVC.view];
    _teacherVC.view.sd_layout
    .leftSpaceToView(_infoVC.view, 0)
    .topEqualToView(_infoVC.view)
    .bottomEqualToView(_infoVC.view)
    .widthRatioToView(_infoVC.view, 1.0);
    [_teacherVC.view updateLayout];
    
    _classVC = [[VideoClassInfo_ClassListViewController alloc]initWithClasses:_classArray bought:_isBought];
    [self addChildViewController:_classVC];
    [_videoClassInfoView.scrollView addSubview:_classVC.view];
    _classVC.view.sd_layout
    .leftSpaceToView(_teacherVC.view, 0)
    .topEqualToView(_infoVC.view)
    .bottomEqualToView(_infoVC.view)
    .widthRatioToView(_infoVC.view, 1.0);
    [_classVC.view updateLayout];
    
    [_videoClassInfoView.scrollView setupAutoContentSizeWithRightView:_classVC.view rightMargin:0];
    [_videoClassInfoView.scrollView setupAutoContentSizeWithBottomView:_infoVC.view bottomMargin:0];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化
    _classArray = @[].mutableCopy;
    _classFeaturesArray = @[].mutableCopy;
    _leadingViewState = LeadingViewStateUnfold;
    _buttonWidth = self.view.width_sd/4-15*ScrenScale;
    _leadingViewState = LeadingViewStateUnfold;
    //加载导航栏
    [self setupNavigation];
    
    [self HUDStartWithTitle:nil];
    
    //请求数据
    [self requestData];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:@"UserLoginAgain" object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        [self getToken];
        [self requestData];
    }];
    
    //微信分享功能的回调通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sharedFinish:) name:@"SharedFinish" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fold) name:@"Fold" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unFold) name:@"Unfold" object:nil];
    
}

//查看教师详情
- (void)watchTeachers{
    
    TeachersPublicViewController *controller = [[TeachersPublicViewController alloc]initWithTeacherID:_teacher.teacherID];
    [self.navigationController pushViewController:controller animated:YES];
    
}


/**请求数据*/
- (void)requestData{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/video_courses/%@/detail",Request_Header,_classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            _classInfo = [VideoClassInfo yy_modelWithJSON:dic[@"data"][@"video_course"]];
            _classInfo.classID = dic[@"data"][@"video_course"][@"id"];
            _classInfo.ticket = dic[@"data"][@"ticket"];
            
            if (![_classInfo.ticket isEqual:[NSNull null]]&&[_classInfo.ticket[@"status"]isEqualToString:@"active"]) {
                
                _isBought = YES;
                
            }else{
                
                _isBought = NO;
                
            }
            
            //特色
            for (NSString *key in dic[@"data"][@"video_course"][@"icons"]) {
                if (![key isEqualToString:@"cheap_moment"]) {
                    if ([dic[@"data"][@"video_course"][@"icons"][key]boolValue]==YES) {
                        Features *mod = [[Features alloc]init];
                        mod.include = [dic[@"data"][@"video_course"][@"icons"][key] boolValue];
                        mod.content = key;
                        [_classFeaturesArray addObject:mod];
                    }
                }
            }

            //加载主页
            [self setupMainView];
            _videoClassInfoView.model = _classInfo;
            
            _teacher = [Teacher yy_modelWithJSON:_classInfo.teacher];
            _teacher.teacherID = _classInfo.teacher[@"id"];
            
            //课程列表
            for (NSDictionary *dics in _classInfo.video_lessons) {
                VideoClass *mod = [VideoClass yy_modelWithJSON:dics];
                mod.video = [Video yy_modelWithJSON:dics[@"video"]];
                
                [_classArray addObject:mod];
            }
            
            //加载购买栏
            [self setupBuyBar];
            
            //标题
            _navigationBar.titleLabel.text = _classInfo.name;
            
            //如果是需要购买的课程
            if ([_classInfo.sell_type isEqualToString:@"charge"]) {
                _freeClass = NO;
                //如果已经购买,直接进入学习
                if (_isBought == YES) {
                    _buyBar.leftButton.hidden = YES;
                    _buyBar.rightButton.layer.borderColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0].CGColor;
                    _buyBar.rightButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0];
                    [_buyBar.rightButton setTitle:@"观看" forState:UIControlStateNormal];
                    [_buyBar.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    _buyBar.rightButton.sd_resetLayout
                    .rightSpaceToView(_buyBar, 10*ScrenScale)
                    .topSpaceToView(_buyBar, 10*ScrenScale)
                    .bottomSpaceToView(_buyBar, 10*ScrenScale)
                    .widthIs(_buttonWidth);
                    [_buyBar.rightButton updateLayout];
                    
                    [_buyBar.rightButton removeAllTargets];
                    [_buyBar.rightButton addTarget:self action:@selector(enterStudy:) forControlEvents:UIControlEventTouchUpInside];
                    
                    //如果未购买
                }else{
                    //如果是可以试听的
                    _onlyTaste = YES;
                    if (_classInfo.taste_count.integerValue>0) {
                        _buyBar.leftButton.layer.borderColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0].CGColor;
                        _buyBar.leftButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0];
                        [_buyBar.leftButton setTitle:@"进入试听" forState:UIControlStateNormal];
                        [_buyBar.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [_buyBar.leftButton removeAllTargets];
                        [_buyBar.leftButton addTarget:self action:@selector(enterTaste:) forControlEvents:UIControlEventTouchUpInside];
                        [_buyBar.rightButton removeAllTargets];
                        [_buyBar.rightButton addTarget:self action:@selector(enterStudy:) forControlEvents:UIControlEventTouchUpInside];
                    }else{
                        //不能试听
//                        _buyBar.leftButton.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
//                        _buyBar.leftButton.backgroundColor = SEPERATELINECOLOR_2;
//                        [_buyBar.leftButton setTitle:@"试听结束" forState:UIControlStateNormal];
//                        [_buyBar.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        _buyBar.leftButton.hidden = YES;
                        _buyBar.rightButton.sd_resetLayout
                        .rightSpaceToView(_buyBar, 10*ScrenScale)
                        .topSpaceToView(_buyBar, 10*ScrenScale)
                        .bottomSpaceToView(_buyBar, 10*ScrenScale)
                        .widthIs(_buttonWidth);
                        [_buyBar updateLayout];
                        
                        [_buyBar.rightButton removeAllTargets];
                        [_buyBar.rightButton addTarget:self action:@selector(enterStudy:) forControlEvents:UIControlEventTouchUpInside];
                        
                    }
                }
                
            }else if ([_classInfo.sell_type isEqualToString:@"free"]){
                //如果是免费课
                _freeClass = YES;
                _buyBar.leftButton.hidden = YES;
                if (_isBought == YES) {
                    _buyBar.rightButton.layer.borderColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0].CGColor;
                    _buyBar.rightButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0];
                    [_buyBar.rightButton setTitle:@"观看" forState:UIControlStateNormal];
                    [_buyBar.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }else{
                    _buyBar.rightButton.layer.borderColor = NAVIGATIONRED.CGColor;
                    _buyBar.rightButton.backgroundColor = [UIColor whiteColor];
                    [_buyBar.rightButton setTitle:@"立即学习" forState:UIControlStateNormal];
                    [_buyBar.rightButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
                }
                
                [_buyBar.rightButton removeAllTargets];
                [_buyBar.rightButton addTarget:self action:@selector(enterStudy:) forControlEvents:UIControlEventTouchUpInside];
                
                _buyBar.rightButton.sd_resetLayout
                .rightSpaceToView(_buyBar, 10*ScrenScale)
                .topSpaceToView(_buyBar, 10*ScrenScale)
                .bottomSpaceToView(_buyBar, 10*ScrenScale)
                .widthIs(_buttonWidth);
                [_buyBar.rightButton updateLayout];
                
            }
            //加载子控制器
            [self setupControllers];
            
            [self HUDStopWithTitle:nil];
        }else{
            [self HUDStopWithTitle:nil];
        }
        
        [self updateMenu];
        
    }failure:^(id  _Nullable erros) {
        
    }];
    
}

/** 刷新右侧菜单的视图 */
- (void)updateMenu{
    
//    NSDictionary *dict1 = @{@"imageName" : @"icon_button_affirm",
//                            @"itemName" : @"进入聊天"
//                            };
    NSDictionary *dict2 = @{@"imageName" : @"icon_button_record",
                            @"itemName" : @"成员列表"
                            };
    
    NSArray *menuArray ;
    
    if (!_freeClass) {
        if (_isBought) {
            if (_isFinished) {
                menuArray = @[dict2];
            }else{
                menuArray = @[/*dict1,*/dict2];
            }
        }else{
            if (_tasteOver) {
                menuArray = @[dict2];
            }else{
                if (_onlyTaste) {
                    //如果加入了试听
                    menuArray = @[/*dict1,*/dict2];
                }else{
                    menuArray = @[dict2];
                }
            }
        }
    }else{
        if (_isBought) {
            //已经加入了免费课
            menuArray = @[/*dict1,*/dict2];
        }else{
            menuArray = @[dict2];
        }
    }
    
    if (menuArray) {
        [CommonMenuView updateMenuItemsWith:menuArray];
    }
    
}


/**
 回调方法 试听
 
 @param sender 购买栏左侧按钮
 */
- (void)enterTaste:(UIButton *)sender{
    
    [self HUDStartWithTitle:nil];
    if ([_classInfo.sell_type isEqualToString:@"charge"]) {
        
        if (_classInfo.taste_count>0) {
            
            //去掉不支持试听的课程
            NSMutableArray <VideoClass *>*classesArray = @[].mutableCopy;
            for (VideoClass *mod in _classArray) {
                if (mod.tastable == YES) {
                    [classesArray addObject:mod];
                }
            }
            //进入试听
            VideoClassPlayerViewController *controller = [[VideoClassPlayerViewController alloc]initWithClasses:classesArray andTeacher:_teacher andVideoClassInfos:_classInfo andURLString:classesArray[0].video.name_url andIndexPath:nil];
            [self.navigationController pushViewController:controller animated:YES];
            [self HUDStopWithTitle:nil];
        }else{
            //没反应
            [self HUDStopWithTitle:@"暂时不能试听"];
        }
        
    }else if ([_classInfo.sell_type isEqualToString:@"free"]){
        
        //进入试听
        VideoClassPlayerViewController *controller = [[VideoClassPlayerViewController alloc]initWithClasses:_classArray andTeacher:_teacher andVideoClassInfos:_classInfo andURLString:_classArray[0].video.name_url andIndexPath:nil];
        [self.navigationController pushViewController:controller animated:YES];
        [self HUDStopWithTitle:nil];

    }
    
}

/**
 回调方法  进入学习
 
 @param sender 购买栏右侧方法
 */
- (void)enterStudy:(UIButton *)sender{
    
    [self HUDStartWithTitle:@"加载中"];
    
    if ([_classInfo.sell_type isEqualToString:@"charge"]) {
        
        //已购买的判断逻辑改了,有ticket并且是active才算购买了
        if (_isBought == YES) {
            //进入学习
            VideoClassPlayerViewController *controller = [[VideoClassPlayerViewController alloc]initWithClasses:_classArray andTeacher:_teacher andVideoClassInfos:_classInfo andURLString:nil andIndexPath:nil];
            [self.navigationController pushViewController:controller animated:YES];
            [self HUDStopWithTitle:nil];
        }else{
            //购买下单
            OrderViewController *controller = [[OrderViewController alloc]initWithClassID:_classID andClassType:VideoClassType andProductName:_classInfo.name];
            [self.navigationController pushViewController:controller animated:YES];
            [self HUDStopWithTitle:nil];
        }
    }else if ([_classInfo.sell_type isEqualToString:@"free"]){
        
        if (_isBought == YES) {
            
            //进入学习
            VideoClassPlayerViewController *controller = [[VideoClassPlayerViewController alloc]initWithClasses:_classArray andTeacher:_teacher andVideoClassInfos:_classInfo andURLString:nil andIndexPath:nil];
            [self.navigationController pushViewController:controller animated:YES];
            [self HUDStopWithTitle:nil];
        }else{
            
            [self POSTSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/video_courses/%@/deliver_free",Request_Header,_classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                if ([dic[@"status"]isEqualToNumber:@1]) {
                    
                    [self HUDStopWithTitle:@"该课程已添加至“我的视频课”"];
                    [self performSelector:@selector(enterStudy) withObject:nil afterDelay:2];
                    
                }else{
                    
                    [self performSelector:@selector(enterStudy) withObject:nil afterDelay:2];
                    
                }
                
            }failure:^(id  _Nullable erros) {
            }];
        }
        
    }
    
}

- (void)enterStudy{
    
    VideoClassPlayerViewController *controller = [[VideoClassPlayerViewController alloc]initWithClasses:_classArray andTeacher:_teacher andVideoClassInfos:_classInfo andURLString:nil andIndexPath:nil];
    [self HUDStopWithTitle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark- UIScrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger pages = scrollView.contentOffset.x / pageWidth;
    
    [_videoClassInfoView.segmentControl setSelectedSegmentIndex:pages animated:YES];
    
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



/**无课程占位图*/
- (UIView *)makePlaceHolderView{
    HaveNoClassView *view = [[HaveNoClassView alloc]init];
    view.titleLabel.text = @"当前无课程";
    return view;
}




/** 回调方法 : 分享 */
-(void)shareVideoClass:(UIButton *)sender{
    
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
                                           @"title":_classInfo.name,
                                           @"description":@"视频课程",
                                           @"link":[NSString stringWithFormat:@"%@/live_studio/video_courses/%@",Request_Header,_classID]
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
        [_videoClassInfoView.headView updateLayout];
        CGFloat bottomHeigh;
        if (_buyBar.hidden) {
            bottomHeigh = 0;
        }else{
            bottomHeigh = TabBar_Height;
        }
        [UIView animateWithDuration:0.3 animations:^{
            _videoClassInfoView.sd_layout
            .topSpaceToView(_navigationBar, -_videoClassInfoView.headView.height_sd);
            [_videoClassInfoView updateLayout];
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
            _videoClassInfoView.sd_layout
            .topSpaceToView(_navigationBar, 0);
            [_videoClassInfoView updateLayout];
        }];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeUnfold" object:nil];
    }else{
        NSLog(@"错误了2.....");
    }
}



- (void)returnLastPage{
    
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
