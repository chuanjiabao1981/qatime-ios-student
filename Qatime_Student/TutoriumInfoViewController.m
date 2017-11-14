//
//  TutoriumInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "TutoriumInfoViewController.h"
#import "NavigationBar.h"
#import "ClassesListTableViewCell.h"
#import "YYModel.h"

#import "UIImageView+WebCache.h"
#import "UIViewController+HUD.h"
#import "UIViewController+HUD.h"

#import "OrderViewController.h"
#import "AppDelegate.h"
#import "NSString+ChangeYearsToChinese.h"

#import "UIAlertController+Blocks.h"

#import "LivePlayerViewController.h"
#import "ReplayVideoPlayerViewController.h"
#import "VideoPlayerViewController.h"
#import "UIViewController+AFHTTP.h"

#import "Replay.h"
#import "UIControl+RemoveTarget.h"
#import "YYTextLayout.h"
#import "TeachersPublicViewController.h"
#import "InteractionViewController.h"
#import "TeacherFeatureTagCollectionViewCell.h"
#import "Features.h"
#import "WorkFlowTableViewCell.h"
#import "ClassTimeViewController.h"

#import "UIViewController+Token.h"
#import "SnailQuickMaskPopups.h"
#import "ShareViewController.h"


/**
 顶部视图的折叠/展开状态
 
 - LeadingViewStateFold: 折叠
 - LeadingViewStateUnfold: 展开
 */
typedef NS_ENUM(NSUInteger, LeadingViewState) {
    LeadingViewStateFold,
    LeadingViewStateUnfold,
};

@interface TutoriumInfoViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,TTGTextTagCollectionViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{

    /* 保存本页面数据*/
    NSMutableDictionary *_dataDic;
    
    CGFloat _buttonWidth;
    
    TutoriumListInfo *_tutorimInfo;
    
    ShareViewController *_share;
    SnailQuickMaskPopups *_pops;
    
    BOOL _isGuest;
    
    LeadingViewState _leadingViewState;

}

@end

@implementation TutoriumInfoViewController

- (instancetype)initWithClassID:(NSString *)classID
{
    self = [super init];
    if (self) {
        
        _classID = [NSString string];
        _classID = classID;
        
        
    }
    return self;
}


- (instancetype)initWithClassID:(NSString *)classID andPromotionCode:(NSString *)promotionCode{
    
    self = [super init];
    if (self) {
        
        _classID = [NSString string];
        _classID = classID;
        
        _promotionCode =[NSString stringWithFormat:@"%@",promotionCode];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     self.tabBarController.tabBar.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self makeData];
    
    [self setupViews];
    
    /* 请求数据*/
    [self requestClassesInfoWith:_classID];
    
    /* 注册重新加载页面数据的通知*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPage) name:@"RefreshTutoriumInfo" object:nil];
    
    /* 注册登录成功重新加载数据的通知*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestAgain) name:@"UserLoginAgain" object:nil];
    
    //微信分享功能的回调通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sharedFinish:) name:@"SharedFinish" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fold) name:@"Fold" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unFold) name:@"Unfold" object:nil];
    
}

/** 初始化数据 */
- (void)makeData{
    /* 根据传递过来的id 进行网络请求model*/
    /* 初始化三个model*/
    _classModel = [[RecommandClasses alloc]init];
    _teacherModel = [[RecommandTeacher alloc]init];
    _classInfoTimeModel = [[ClassesInfo_Time alloc]init];
    _classListArray = @[].mutableCopy;
    _classFeaturesArray = @[].mutableCopy;
    
   _buttonWidth = self.view.width_sd/4-15*ScrenScale;
    _isBought = NO;
    
    _isGuest = [[NSUserDefaults standardUserDefaults]valueForKey:@"is_Guest"];
    
    _leadingViewState = LeadingViewStateUnfold;
}

/** 加载视图 */
- (void)setupViews{
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), Navigation_Height)];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [self.view addSubview:_navigationBar];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastpage) forControlEvents:UIControlEventTouchUpInside];
    _tutoriumInfoView = [[TutoriumInfoView alloc]initWithFrame:CGRectMake(0, Navigation_Height, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-Navigation_Height-TabBar_Height)];
    [self.view addSubview:_tutoriumInfoView];
    
    [self.view bringSubviewToFront:_navigationBar];
    /* 购买bar*/
    _buyBar= [[BuyBar alloc]initWithFrame:CGRectMake(0, self.view.height_sd-49, self.view.width_sd, 49)];
    [_buyBar.shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buyBar];
    _buyBar.hidden = YES;
    if (![self isLogin]) {
        [_buyBar.listenButton addTarget:self action:@selector(loginAgain) forControlEvents:UIControlEventTouchUpInside];
        [_buyBar.applyButton addTarget:self action:@selector(loginAgain) forControlEvents:UIControlEventTouchUpInside];
    }
    _tutoriumInfoView.scrollView.delegate = self;
    _tutoriumInfoView.classFeature.delegate = self;
    _tutoriumInfoView.classFeature.dataSource = self;
    
    //注册cell
    [_tutoriumInfoView.classFeature registerClass:[TeacherFeatureTagCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    //加载课程特色标签
    [self setupTagText];
    
}

/** 加载子控制器 */
- (void)setupControllers{
    
    _infoVC = [[TutoriumInfo_InfoViewController alloc]initWithTutorium:_tutorimInfo];
    _teacherVC = [[TutoriumInfo_TeacherViewController alloc]initWithTeacher:_teacherModel];
    _classVC = [[TutoriumInfo_ClassListViewController alloc]initWithClasses:_classListArray bought:_isBought];
    
    [self addChildViewController:_infoVC];
    [self addChildViewController:_teacherVC];
    [self addChildViewController:_classVC];
    [_tutoriumInfoView.scrollView updateLayout];
    [_tutoriumInfoView.scrollView addSubview:_infoVC.view];
    [_tutoriumInfoView.scrollView addSubview:_teacherVC.view];
    [_tutoriumInfoView.scrollView addSubview:_classVC.view];
    
    _infoVC.view.sd_layout
    .leftSpaceToView(_tutoriumInfoView.scrollView, 0)
    .topSpaceToView(_tutoriumInfoView.scrollView, 0)
    .bottomSpaceToView(_tutoriumInfoView.scrollView, 0)
    .widthRatioToView(_tutoriumInfoView.scrollView, 1.0);
    [_infoVC.view updateLayout];
    
    _teacherVC.view.sd_layout
    .leftSpaceToView(_infoVC.view , 0)
    .topSpaceToView(_tutoriumInfoView.scrollView, 0)
    .bottomSpaceToView(_tutoriumInfoView.scrollView, 0)
    .widthRatioToView(_infoVC.view , 1.0);
    [_teacherVC.view updateLayout];
    
    _classVC.view.sd_layout
    .leftSpaceToView(_teacherVC.view, 0)
    .topSpaceToView(_tutoriumInfoView.scrollView, 0)
    .bottomSpaceToView(_tutoriumInfoView.scrollView, 0)
    .widthRatioToView(_infoVC.view, 1.0);
    [_classVC.view updateLayout];
    
    [_tutoriumInfoView.scrollView setupAutoContentSizeWithBottomView:_infoVC.view bottomMargin:0];
    [_tutoriumInfoView.scrollView setupAutoContentSizeWithRightView:_teacherVC.view rightMargin:414];
    
}

//课程特色标签
- (void)setupTagText{
    
    //标签设置
    _config = [[TTGTextTagConfig alloc]init];
    _config.tagTextColor = TITLECOLOR;
    _config.tagBackgroundColor = [UIColor whiteColor];
    _config.tagBorderColor = [UIColor colorWithRed:0.88 green:0.60 blue:0.60 alpha:1.00];
    _config.tagShadowColor = [UIColor clearColor];
    _config.tagCornerRadius = 0;
    _config.tagExtraSpace = CGSizeMake(15, 5);
    _config.tagTextFont = TEXT_FONTSIZE;
    
}


/* 登录成功后,再次加载数据*/
- (void)requestAgain{
    
    [_buyBar.listenButton removeTarget:self action:@selector(loginAgain) forControlEvents:UIControlEventTouchUpInside];
    [_buyBar.applyButton removeTarget:self action:@selector(loginAgain) forControlEvents:UIControlEventTouchUpInside];
   
    /* 请求数据*/
    [self refreshPage];
    
}


/** 根据初始化传值进来的id 进行网络请求*/
- (void)requestClassesInfoWith:(NSString *)classid{
    
    [self HUDStartWithTitle:nil];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[self getToken] forHTTPHeaderField:@"Remember-Token"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses/%@/detail",Request_Header,classid] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        /* 拿到数据字典*/
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        [self loginStates:dic];
        
        NSString *teacherID = [NSString stringWithFormat:@"%@",dic[@"data"][@"course"][@"teacher"][@"id"]];
        
        _chatTeamID = [NSString stringWithFormat:@"%@",dic[@"data"][@"course"][@"chat_team_id"]];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            /* 成功后访问教师数据*/
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager GET:[NSString stringWithFormat:@"%@/api/v1/teachers/%@/profile",Request_Header,teacherID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *teacherDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                if ([teacherDic[@"status"]isEqualToNumber:@1]) {
                    
                    //页面model
                    _tutorimInfo = [TutoriumListInfo yy_modelWithJSON:dic[@"data"][@"course"]];
                    _tutorimInfo.classID = dic[@"data"][@"id"][@"course"];
                    _tutorimInfo.describe = dic[@"data"][@"course"][@"description"];
                    NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
                    
                    _dataDic=[NSMutableDictionary dictionaryWithDictionary:dic[@"data"][@"course"]];
                    /* 课程页面信息赋值*/
                    _tutoriumInfoView.className.text = _tutorimInfo.name;
                    _tutoriumInfoView.saleNumber.text = [NSString stringWithFormat:@"报名人数 %@", _tutorimInfo.buy_tickets_count];
                    
                    //课程特色
                    for (NSString *key in _dataDic[@"icons"]) {
                        if (![key isEqualToString:@"cheap_moment"]) {
                            if ([_dataDic[@"icons"][key]boolValue]==YES) {
                                Features *mod = [[Features alloc]init];
                                mod.include = [_dataDic[@"icons"][key] boolValue];
                                mod.content = key;
                                [_classFeaturesArray addObject:mod];
                            }
                        }
                        
                    }
                    
                    /* 已经开课->插班价*/
                    if ([_tutorimInfo.status isEqualToString:@"teaching"]||[_tutorimInfo.status isEqualToString:@"pause"]||[_tutorimInfo.status isEqualToString:@"closed"]) {
                        
                        _tutoriumInfoView.priceLabel.text = [NSString stringWithFormat:@"¥%@(插班价)",_tutorimInfo.current_price];
                        
                    }else{
                        /* 未开课 总价*/
                        _tutoriumInfoView.priceLabel.text = [NSString stringWithFormat:@"¥%@",_tutorimInfo.price];
                    }
                    
                    /* 已开课的状态*/
                    if ([_tutorimInfo.status isEqualToString:@"teaching"]||[_tutorimInfo.status isEqualToString:@"pause"]||[_tutorimInfo.status isEqualToString:@"closed"]) {
                        _tutoriumInfoView.status.text = [NSString stringWithFormat:@" %@ [进度%@/%@] ",@"开课中",_tutorimInfo.completed_lessons_count,_tutorimInfo.lessons_count];
                        _tutoriumInfoView.status.backgroundColor = [UIColor colorWithRed:0.14 green:0.80 blue:0.99 alpha:1.00];
                    }else if ([_tutorimInfo.status isEqualToString:@"missed"]||[_tutorimInfo.status isEqualToString:@"init"]||[_tutorimInfo.status isEqualToString:@"ready"]){
                        
                        _tutoriumInfoView.status.text = [NSString stringWithFormat:@" %@ [距开课%@天]",@" 招生中",[self intervalSinceNow:_tutorimInfo.live_start_time ]];
                        _tutoriumInfoView.status.backgroundColor = [UIColor colorWithRed:0.08 green:0.59 blue:0.09 alpha:1.00];
                    }else if ([_tutorimInfo.status isEqualToString:@"finished"]||[_tutorimInfo.status isEqualToString:@"billing"]||[_tutorimInfo.status isEqualToString:@"completed"]){
                        _tutoriumInfoView.status.text = [NSString stringWithFormat:@" %@ [进度%@/%@]",@"已结束",_tutorimInfo.lessons_count,_tutorimInfo.lessons_count];
                        _tutoriumInfoView.status.backgroundColor = SEPERATELINECOLOR_2;
                        //如果课程已结束,buybar不显示.什么都不显示了
                        if (_buyBar) {
                            _buyBar.hidden = YES;
                            _tutoriumInfoView.frame = CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd-Navigation_Height);
                        }
                    }else if ([_tutorimInfo.status isEqualToString:@"published"]){
                        _buyBar.hidden = NO;
                        if (_dataDic[@"live_start_time"]) {
                            if ([_tutorimInfo.live_start_time isEqualToString:@""]||[_tutorimInfo.live_start_time isEqualToString:@" "]) {
                                _tutoriumInfoView.status.text = @"招生中";
                                _tutoriumInfoView.status.backgroundColor = [UIColor colorWithRed:0.08 green:0.59 blue:0.09 alpha:1.00];
                                
                            }else{
                                
                                NSInteger leftDay = [[self intervalSinceNow:_dataDic[@"live_start_time"] ]integerValue];
                                
                                NSString *leftDays;
                                if (leftDay>=1) {
                                    leftDays = [NSString stringWithFormat:@" 招生中距 [开课%ld天]",leftDay];
                                }else {
                                    leftDays = @" 即将开课 ";
                                    
                                }
                                _tutoriumInfoView.status.text = leftDays;
                                _tutoriumInfoView.status.backgroundColor = [UIColor colorWithRed:0.08 green:0.59 blue:0.09 alpha:1.00];
                            }
                        }
                    }
                    //直播时间赋值
//                    _tutoriumInfoView.liveTimeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",[_dataDic[@"live_start_time"]length]>=10?[_dataDic[@"live_start_time"] substringToIndex:10]:_dataDic[@"live_start_time"],[_dataDic[@"live_end_time"] length]>=10?[_dataDic[@"live_end_time"] substringToIndex:10]:_dataDic[@"live_end_time"]];
                    
                    //课程目标
//                    _tutoriumInfoView.classTarget.text = _dataDic[@"objective"]==[NSNull null]?@"无":_dataDic[@"objective"];
                    
                    //适合人群
//                    _tutoriumInfoView.suitable.text = _dataDic[@"suit_crowd"]==[NSNull null]?@"无":_dataDic[@"suit_crowd"];
                    
                    
                    if ([status isEqualToString:@"0"]) {
                        /* 获取token错误  需要重新登录*/
                        
                    }else{
                        
                        /* 判断课程状态*/
                        [self switchClassData:dic];
                        
                        /* 手动解析teacherModel*/
//                        NSLog(@"%@",teacherDic);
                        _teacherModel = [RecommandTeacher yy_modelWithJSON:teacherDic[@"data"]];
                        _teacherModel.teacherID = teacherID;
                        _teacherModel.teacherName =teacherDic[@"data"][@"name"];
                        /* 教师描述的数据是html富文本,使用系统解析*/
                        _teacherModel.attributedDescribe = [[NSAttributedString alloc] initWithData:[teacherDic[@"data"][@"desc"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                        _teacherModel.describe =teacherDic[@"data"][@"desc"];
                        
                        /** 手动解析classModel*/
                        _classModel = [RecommandClasses yy_modelWithDictionary:_dataDic];
                        _classModel.classID = _dataDic[@"id"];
                        _classModel.describe = _dataDic[@"description"];
                        
                        /* 课程描述的富文本*/
                        _classModel.attributedDescribe = [[NSMutableAttributedString alloc]initWithData:[_dataDic[@"description"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                        
                        //                        [_classModel.attributedDescribe addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} range:NSMakeRange(0, 17)];
                        
                        /* 课程页面的label赋值*/
//                        [_tutoriumInfoView.subjectLabel setText:_classModel.subject];
//                        [_tutoriumInfoView.gradeLabel setText:_classModel.grade];
//                        [_tutoriumInfoView.classCount setText:[NSString stringWithFormat:@"共%@课",  _classModel.lessons_count]];
                        //                        [_tutoriumInfoView.classDescriptionLabel setText:_classModel.describe];
                        //
//                        _tutoriumInfoView.classDescriptionLabel.attributedText = _classModel.attributedDescribe;
                        //                         _tutoriumInfoView.classDescriptionLabel.attributedString = [[NSAttributedString alloc]initWithHTMLData:[_classModel.describe dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
                        
                        //给视图赋值tag的内容
                        
                        if (_classModel.tag_list.count!=0) {
                            
//                            [_tutoriumInfoView.classTagsView addTags:_classModel.tag_list withConfig:_config];
                        }else{
                            
                            _config.tagBorderColor = [UIColor whiteColor];
                            _config.tagTextColor = TITLECOLOR;
//                            [_tutoriumInfoView.classTagsView addTag:@"无" withConfig:_config];
                        }
                        
                        /* 课程列表的手动解析model*/
                        NSMutableArray *classList = _dataDic[@"lessons"];
                        
                        NSLog(@"%@",classList);
                        for (int i=0; i<classList.count; i++) {
                            
                            _classInfoTimeModel = [ClassesInfo_Time yy_modelWithDictionary:classList[i]];
                            _classInfoTimeModel.classID =[ classList[i]valueForKey:@"id" ];
                            
                            [_classListArray addObject:_classInfoTimeModel];
                            
                            [self updateTableView];
                        }
                    }
                    
                    /* 赋值完毕,开始进行自适应高度*/
                    
                    [_tutoriumInfoView.classFeature reloadData];
                    
                    if (_classFeaturesArray.count>3) {
                        _tutoriumInfoView.classFeature.sd_resetLayout
                        .leftSpaceToView(_tutoriumInfoView, 0)
                        .rightSpaceToView(_tutoriumInfoView, 0)
                        .topSpaceToView(_tutoriumInfoView.status, 10)
                        .heightIs(40);
                        [_tutoriumInfoView.classFeature updateLayout];
                        [_tutoriumInfoView.classFeature layoutIfNeeded];
                    }
                    
                    _tutoriumInfoView.classFeature.sd_layout
                    .heightIs(_tutoriumInfoView.classFeature.contentSize.height);
                    [_tutoriumInfoView.classFeature updateLayout];
                    
                    [_tutoriumInfoView.headView setupAutoHeightWithBottomView:_tutoriumInfoView.saleNumber bottomMargin:10];
                    [_tutoriumInfoView.headView updateLayout];
                    //加载子控制器
                    [self setupControllers];
                    [self HUDStopWithTitle:nil];
                    
                }else{
                    /* 返回的教师数据是错误的*/
                    [self HUDStopWithTitle:@"请稍后重试"];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self HUDStopWithTitle:@"请检查网络"];
        
    }];
    
}

//查看教师详情
- (void)watchTeachers{
    
    TeachersPublicViewController *controller = [[TeachersPublicViewController alloc]initWithTeacherID:(NSString *)_dataDic[@"teacher"][@"id"] ];
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark- 判断课程状态
- (void)switchClassData:(NSDictionary *)dic{
    
    if ([dic[@"data"][@"course"][@"sell_type"]isEqualToString:@"charge"]) {//非免费课
        if (![dic[@"data"][@"ticket"]isEqual:[NSNull null]]) {//已试听过或已购买过
            //如果课程未结束
            if (![dic[@"data"][@"course"][@"status"]isEqualToString:@"completed"]) {
                if (dic[@"data"][@"ticket"][@"type"]) {
                    if ([dic[@"data"][@"ticket"][@"type"]isEqualToString:@"LiveStudio::BuyTicket"]) {//已购买,显示开始学习按钮
                        _isBought = YES;
                        /* 已经购买的情况下*/
                        _buyBar.applyButton.hidden = YES;
                        _buyBar.listenButton.hidden = NO;
//                        [_buyBar.listenButton sd_clearAutoLayoutSettings];
                        _buyBar.listenButton.sd_resetLayout
                        .topSpaceToView(_buyBar,10*ScrenScale)
                        .bottomSpaceToView(_buyBar,10*ScrenScale)
                        .rightSpaceToView(_buyBar,10*ScrenScale)
                        .widthIs(_buttonWidth);
                        [_buyBar.listenButton updateLayout];
                        [_buyBar.listenButton setTitle:@"开始学习" forState:UIControlStateNormal];
                        _buyBar.listenButton.backgroundColor = NAVIGATIONRED;
                        [_buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [_buyBar.listenButton addTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
                        _buyBar.hidden = NO;
                    }else{//未购买,显示进入试听按钮 购买按钮照常使用
                        _buyBar.hidden = NO;
                        _isBought = NO;
                        [_buyBar.applyButton removeAllTargets];
                        [_buyBar.applyButton addTarget:self action:@selector(buyClass) forControlEvents:UIControlEventTouchUpInside];
                        if ([dic[@"data"][@"ticket"][@"used_count"] integerValue] >= [dic[@"data"][@"ticket"][@"buy_count"]integerValue] ) {
                            //试听结束,显示试听结束按钮
                            /* 不可以试听*/
                            [_buyBar.listenButton setTitle:@"试听结束" forState:UIControlStateNormal];
                            [_buyBar.listenButton setBackgroundColor:[UIColor colorWithRed:0.84 green:0.47 blue:0.44 alpha:1.0]];
                            [_buyBar.listenButton removeTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
                            _buyBar.listenButton.enabled = NO;
                        }else{
                            [_buyBar.listenButton setTitle:@"进入试听" forState:UIControlStateNormal];
                            [_buyBar.listenButton setBackgroundColor:NAVIGATIONRED];
                            [_buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            [_buyBar.listenButton addTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
                        }
                    }
                }
            }else{//课程已经结束了
                //整个购买栏直接隐藏吧
                _buyBar.hidden = YES;
            }
            
        }else{//需要加入试听或购买
            if ([dic[@"data"][@"course"][@"tastable"]boolValue]==YES) {//可以加入试听
                //显示加入试听,和立即购买两个按钮
                _buyBar.hidden = NO;
                _buyBar.listenButton.hidden = NO;
                [_buyBar.listenButton removeAllTargets];
                [_buyBar.listenButton setTitle:@"加入试听" forState:UIControlStateNormal];
                [_buyBar.listenButton setBackgroundColor:[UIColor whiteColor]];
                [_buyBar.listenButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
                [_buyBar.listenButton addTarget:self action:@selector(addListen) forControlEvents:UIControlEventTouchUpInside];
                _buyBar.applyButton.hidden = NO;
                [_buyBar.applyButton removeAllTargets];
                [_buyBar.applyButton setTitle:@"立即报名" forState:UIControlStateNormal];
                [_buyBar.applyButton setBackgroundColor:[UIColor whiteColor]];
                [_buyBar.applyButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
                [_buyBar.applyButton addTarget:self action:@selector(buyClass) forControlEvents:UIControlEventTouchUpInside];
            }else{
                //不能试听,只能购买
                _buyBar.hidden = NO;
                _buyBar.listenButton.hidden = YES;
                [_buyBar.applyButton removeAllTargets];
                _buyBar.applyButton.sd_resetLayout
                .rightSpaceToView(_buyBar, 10*ScrenScale)
                .topSpaceToView(_buyBar, 10*ScrenScale)
                .bottomSpaceToView(_buyBar, 10*ScrenScale)
                .widthIs(_buttonWidth);
                [_buyBar.applyButton updateLayout];
                [_buyBar.applyButton addTarget:self action:@selector(buyClass) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        if ([dic[@"data"][@"course"][@"off_shelve"]boolValue]==YES) {//已下架
            //已经下架
            _buyBar.hidden = YES;
            _tutoriumInfoView.priceLabel.text = @"已下架";
        }else{
            _buyBar.hidden = NO;
        }
        
    }else if ([dic[@"data"][@"course"][@"sell_type"]isEqualToString:@"free"]){//免费课
        //免费呀
        _buyBar.hidden = NO;
        _tutoriumInfoView.priceLabel.text = @"免费";
        
        if (dic[@"data"][@"ticket"]) {
            if (![dic[@"data"][@"ticket"]isEqual:[NSNull null]]) {//已购买(已加入到我的视频课列表里了)
                _isBought = YES;
                if (![dic[@"data"][@"course"][@"status"]isEqualToString:@"completed"]) {
                    //课程没结束又购买了
                    //可以直接进入学习
                    _buyBar.applyButton.hidden = YES;
                    _buyBar.listenButton.hidden = NO;
                    [_buyBar.listenButton removeAllTargets];
                    _buyBar.listenButton.sd_resetLayout
                    .topSpaceToView(_buyBar,10*ScrenScale)
                    .bottomSpaceToView(_buyBar,10*ScrenScale)
                    .rightSpaceToView(_buyBar,10*ScrenScale)
                    .widthIs(_buttonWidth);
                    [_buyBar.listenButton updateLayout];
                    [_buyBar.listenButton setTitle:@"开始学习" forState:UIControlStateNormal];
                    _buyBar.listenButton.backgroundColor = NAVIGATIONRED;
                    [_buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [_buyBar.listenButton addTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
                    
                }else{
                    //课程已经结束了,干掉购买蓝
                    _buyBar.hidden = YES;
                }
                
            }else{
                _isBought  = NO;
                //未购买,立即报名 报完名变成进入学习 未曾拥有过不隐藏购买栏,只是提示下架而已
                if ([dic[@"data"][@"course"][@"off_shelve"]boolValue]==YES) {
                    //已经下架
                    _buyBar.hidden = YES;
                    _tutoriumInfoView.priceLabel.text = @"已下架";
                }else{
                    _buyBar.hidden = NO;
                    _buyBar.listenButton.hidden = YES;
                    _buyBar.applyButton.sd_resetLayout
                    .topSpaceToView(_buyBar,10*ScrenScale)
                    .bottomSpaceToView(_buyBar,10*ScrenScale)
                    .rightSpaceToView(_buyBar,10*ScrenScale)
                    .widthIs(_buttonWidth);
                    [_buyBar.applyButton updateLayout];
                    [_buyBar.applyButton removeAllTargets];
                    [_buyBar.applyButton addTarget:self action:@selector(addFreeClass) forControlEvents:UIControlEventTouchUpInside];
                }
                
            }
        }else{
            _isBought  = NO;
            _buyBar.hidden = NO;
            //未购买,立即报名 报完名变成进入学习 未曾拥有过不隐藏购买栏,只是提示下架而已
            if ([dic[@"data"][@"course"][@"off_shelve"]boolValue]==YES) {
                //已经下架
                [_buyBar.listenButton removeAllTargets];
                _buyBar.applyButton.hidden = YES;
                [_buyBar.listenButton setTitle:@"已下架" forState:UIControlStateNormal];
                [_buyBar.listenButton setBackgroundColor:TITLECOLOR];
                [_buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _buyBar.listenButton.sd_resetLayout
                .topSpaceToView(_buyBar,10*ScrenScale)
                .bottomSpaceToView(_buyBar,10*ScrenScale)
                .rightSpaceToView(_buyBar,10*ScrenScale)
                .widthIs(_buttonWidth);
                [_buyBar.listenButton updateLayout];
            }else{
                _buyBar.hidden = NO;
                _buyBar.listenButton.hidden = YES;
                _buyBar.applyButton.sd_resetLayout
                .topSpaceToView(_buyBar,10*ScrenScale)
                .bottomSpaceToView(_buyBar,10*ScrenScale)
                .rightSpaceToView(_buyBar,10*ScrenScale)
                .widthIs(_buttonWidth);
                [_buyBar.applyButton updateLayout];
                [_buyBar.applyButton removeAllTargets];
                [_buyBar.applyButton addTarget:self action:@selector(addFreeClass) forControlEvents:UIControlEventTouchUpInside];
            }

        }
        
    }
    
}

/** 加入免费课程 */
- (void)addFreeClass{
    
    [self POSTSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses/%@/deliver_free",Request_Header,_classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            //加入成功
            [_buyBar.applyButton removeAllTargets];
            [_buyBar.applyButton setTitle:@"开始学习" forState:UIControlStateNormal];
            [_buyBar.applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_buyBar.applyButton setBackgroundColor:BUTTONRED];
            [_buyBar.applyButton addTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
            _isBought = YES;
            [self HUDStopWithTitle:@"已添加至\"我的直播课\""];
        }
        
    } failure:^(id  _Nullable erros) {
       
        [self HUDStopWithTitle:@"请检查网络"];
        
    }];
}

#pragma mark- 加入到已关闭的试听
- (void)addClosedListen{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该课程已结束,是否继续试听?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }] ;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        /* 加入试听*/
        [self addListen];
        
    }] ;
    
    [alert addAction:cancel];
    [alert addAction:sure];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}



#pragma mark- 加入试听
/** 加入试听 */
- (void)addListen{
    
    if (_dataDic) {
        if ([_dataDic[@"taste_count"]integerValue]>0) {
            /* 可以试听的情况*/
            
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager.requestSerializer setValue:[self getToken] forHTTPHeaderField:@"Remember-Token"];
            [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses/%@/taste",Request_Header,_dataDic[@"id"]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                [self loginStates:dic];
                
                if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                    /* 请求成功*/
                    
                    [_buyBar.listenButton removeTarget:self action:@selector(addListen) forControlEvents:UIControlEventTouchUpInside];
                    
                    [_buyBar.listenButton setTitle:@"进入试听" forState:UIControlStateNormal];
                    [_buyBar.listenButton setBackgroundColor:NAVIGATIONRED];
                    [_buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    [_buyBar.listenButton addTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self HUDStopWithTitle:@"加入成功"];
                    
                    
                    /* 发送全局通知,发送加入试听课程通知*/
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"AddNewClass" object:_dataDic];
                    
                }else{
                    
                    /* 重新登录*/
                    
                    //                    [self HUDStopWithTitle:@"登录超时,请重新登录!"];
                    //
                    //                    [self performSelector:@selector(loginAgain) withObject:nil afterDelay:2];
                    
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            
        }else{
            
            [self HUDStopWithTitle:@"该课程不支持试听"];
        }
    }
    
}

#pragma mark- 立即进入试听
- (void)listen{
    
    if (_isBought==YES) {
        
        LivePlayerViewController *neVC = [[LivePlayerViewController alloc]initWithClassID:_dataDic[@"id"]];
        
        [self.navigationController pushViewController:neVC animated:YES];
    }else{
        
        if ([_dataDic[@"taste_count"]integerValue]>0) {
            LivePlayerViewController *neVC = [[LivePlayerViewController alloc]initWithClassID:_dataDic[@"id"]];
            
            [self.navigationController pushViewController:neVC animated:YES];
            
            
        }else{
            [self HUDStopWithTitle:@"试听次数用尽"];
        }
    }
    
    
}


#pragma mark- 立即报名的 购买课程方法

/** 立即报名 购买课程 */
- (void)buyClass{
    
    if (_dataDic) {
        
        if (![_dataDic[@"status"] isEqualToString:@"completed"]&&![_dataDic[@"status"] isEqualToString:@"finished"]&&![_dataDic[@"status"] isEqualToString:@"billing"]) {
            
            //砍掉
            if ([_dataDic[@"status"] isEqualToString:@"teaching"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该辅导已开课,是否继续购买?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }] ;
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self requestOrder];
                    
                }] ;
                
                [alert addAction:cancel];
                [alert addAction:sure];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }else{
                [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"是否确定购买该课程?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    if (buttonIndex!=0) {
                        [self requestOrder];
                    }
                    
                }];
            }
        }else{
            
            [self HUDStopWithTitle:@"当前课程不支持购买"];
            
        }
        
    }
    
}

#pragma mark- 收集订单信息,并传入下一页,开始提交订单
- (void)requestOrder{
    
    OrderViewController *orderVC;
    
    if (_promotionCode) {
        
        orderVC = [[OrderViewController alloc]initWithClassID:_classID andPromotionCode:_promotionCode andClassType:LiveClassType andProductName:_dataDic[@"name"]];
    }else{
        
        orderVC= [[OrderViewController alloc]initWithClassID:_classID andClassType:LiveClassType andProductName:_dataDic[@"name"]];
    }
    
    [self.navigationController pushViewController:orderVC animated:YES];
    
}


- (void)updateTableView{
    
//    [_tutoriumInfoView.classesListTableView reloadData];
    
    [_navigationBar .titleLabel setText:_classModel.name];
    
}

// 滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _tutoriumInfoView.scrollView) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        
        [_tutoriumInfoView.segmentControl setSelectedSegmentIndex:page animated:YES];
    }
}


#pragma mark- tagview delegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize{
    
//    if (textTagCollectionView == _tutoriumInfoView.classTagsView) {
//        [textTagCollectionView clearAutoHeigtSettings];
//        textTagCollectionView.sd_layout
//        .heightIs(contentSize.height);
//    }else if(textTagCollectionView == _tutoriumInfoView.teacherTagsView){
//
//
//    }
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


/* 刷新页面*/
- (void)refreshPage{
    
    [_buyBar.listenButton removeAllTargets];
    [_buyBar.applyButton removeAllTargets];
    
    _classListArray = @[].mutableCopy;
    _classFeaturesArray = @[].mutableCopy;
    
    [self requestClassesInfoWith:_classID];
    
}


/* 计算开课的时间差*/
- (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSString *timeString=@"";
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
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


#pragma mark- 根据课程详细内容 ,scrollview 的content 自适应高度

- (void)returnLastpage{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isMemberOfClass:[ClassTimeViewController class]]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PopToRoot" object:nil];
        }
    }
    
    
    if (_promotionCode) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

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
                                           @"title":_classModel.name,
                                           @"description":@"直播课程",
                                           @"link":[NSString stringWithFormat:@"%@/live_studio/courses/%@",Request_Header,_classID]
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
        [_tutoriumInfoView.headView updateLayout];
        CGFloat bottomHeigh;
        if (_buyBar.hidden) {
            bottomHeigh = 0;
        }else{
            bottomHeigh = TabBar_Height;
        }
        [UIView animateWithDuration:0.3 animations:^{
            _tutoriumInfoView.sd_layout
            .topSpaceToView(_navigationBar, -_tutoriumInfoView.headView.height_sd);
            [_tutoriumInfoView updateLayout];

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
            _tutoriumInfoView.sd_layout
            .topSpaceToView(_navigationBar, 0);
            [_tutoriumInfoView updateLayout];
        }];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeUnfold" object:nil];
    }else{
        NSLog(@"错误了2.....");
    }
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
