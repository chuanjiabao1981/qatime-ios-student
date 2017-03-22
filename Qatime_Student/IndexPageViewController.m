//
//  IndexPageViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "IndexPageViewController.h"
#import "RecommandClassCollectionViewCell.h"
#import "IndexHeaderPageView.h"
#import "YZSquareMenu.h"

#import "TutoriumViewController.h"
#import "NoticeIndexViewController.h"
#import "YZSquareMenuCell.h"
#import "RecommandTeacher.h"
#import "UIImageView+WebCache.h"
#import "RecommandClasses.h"
#import "YYModel.h"
#import "TeachersPublicViewController.h"
#import "UIViewController+HUD.h"
#import "NIMSDK.h"
#import "YYModel.h"
#import "TLCityPickerDelegate.h"
#import "TLCityPickerController.h"
#import "City.h"
#import "ChineseString.h"
#import "TutoriumList.h"
#import "TutoriumInfoViewController.h"
#import "NIMSDK.h"
#import "MJRefresh.h"
#import "QRCodeController.h"
#import "LCTabBar.h"
#import "TodayLiveCollectionViewCell.h"
#import "QualityTableViewCell.h"

#import "LivePlayerViewController.h"
#import "UIViewController+AFHTTP.h"


@interface IndexPageViewController ()<UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,CLLocationManagerDelegate,TLCityPickerDelegate,UIGestureRecognizerDelegate,NIMLoginManagerDelegate,NIMConversationManagerDelegate,LCTabBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    /* token*/
    NSString *_token;
    NSString *_idNumber;
    //    IndexHeaderPageView *headerView ;
    
    NSArray *menuImages;
    NSArray *menuTitiels;
    
    //    UIScrollView *contentScrollView;
    
    
    /* 页数*/
    NSInteger page;
    /* 每页条数*/
    NSInteger per_page;
    
    
    /* kee*/
    /* 推荐教师kee*/
    NSString *_kee_teacher;
    /* 推荐课程kee*/
    NSString *_kee_class;
    /* banner页kee*/
    NSString *_kee_banner;
    
    /* 推荐教师的存放数组*/
    
    /* 推荐老师按section的存放数组*/
    NSMutableArray *_teachers;
    
    /* 推荐课程存放数组*/
    NSMutableArray *_classes;
    
    /* banner图片保存的数组*/
    NSMutableArray *_banners;
    
    /* 今日直播 课程的model数组*/
    NSMutableArray *_todayLives;
    
    /* 最新发布 课程的model数组*/
    NSMutableArray *_newestRelease;
    
    /* 最近开课 课程的model数组*/
    NSMutableArray *_newestStart;
    
    
    
    /* 头视图的尺寸*/
    CGSize headerSize;
    
    UIButton *_location;
    
    /* 所有的城市信息*/
    NSMutableArray *_cities;
    
    /* 定位城市*/
    NSString *_localCity;
    
    //新首页
    /* 近期开课 更多 按钮*/
    UIControl *_moreCurrentClassButton;
    
    /* 新课发布 更多 按钮*/
    UIControl *_moreNewClassButton;
    
    
}

/* 定位管理器*/
@property (nonatomic, strong) CLLocationManager* locationManager;


@end

@implementation IndexPageViewController

- (void)loadView{
    [super loadView];
    
    [self loadingHUDStartLoadingWithTitle:NSLocalizedString(@"正在加载数据", nil)];
    
    /* 导航栏加载*/
    _navigationBar = ({
        NavigationBar *_ = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        [self .view addSubview:_];
        [_.rightButton setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
        UIImageView *logoImage = [[UIImageView alloc]init];
        [_ addSubview:logoImage];
        logoImage.sd_layout
        .topSpaceToView(_,25)
        .bottomSpaceToView(_,10)
        .centerXEqualToView(_)
        .widthIs((_.height_sd-10-25)*1080/208);
        [logoImage setImage:[UIImage imageNamed:@"Logo_white"]];
        
        [_.leftButton setImage:nil forState:UIControlStateNormal];
        [_.leftButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
        
        _location = [UIButton new];
        [_location setTitle:@"全国" forState:UIControlStateNormal];
        [_location setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_location.titleLabel setFont:[UIFont systemFontOfSize:15*ScrenScale]];
        
        [_ addSubview:_location];
        _location.sd_layout
        .leftSpaceToView(_.leftButton,0)
        .topEqualToView(_.leftButton)
        .bottomEqualToView(_.leftButton)
        .rightSpaceToView(logoImage,0);
        
        [_location setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_location addTarget:self action:@selector(choseLocation) forControlEvents:UIControlEventTouchUpInside];
        [_.leftButton addTarget:self action:@selector(choseLocation) forControlEvents:UIControlEventTouchUpInside];
        
        _;
    });
    
    [_navigationBar.rightButton addTarget:self action:@selector(enterScanPage) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    //初始化变量
    page = 1;
    per_page =10;
    
    _kee_teacher = [NSString string];
    _kee_class = [NSString string];
    
    _teachers =@[].mutableCopy;
    _classes = @[].mutableCopy;
    
    _todayLives = @[].mutableCopy;
    
    _newestRelease = @[].mutableCopy;
    
    _newestStart = @[].mutableCopy;
    
    
    //加载头视图
    _headerView = [[IndexHeaderPageView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd*3.1/5.0)];
    //    [self.view addSubview:_headerView];
    _headerView.todayLiveScrollView.delegate = self;
    _headerView.todayLiveScrollView.dataSource = self;
    _headerView.todayLiveScrollView.tag = 1;        //今日直播 tag = 1
    
    /* 头视图的 今日直播 注册cell*/
    [_headerView.todayLiveScrollView registerClass:[TodayLiveCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    /* 主页视图
     三部分的tableview组成
     1.精选内容
     2.sectionfooter:老师推荐
     3.近期开课+sectionheader
     4.新科发布+sectionheader
     */
    
    _indexPageView  = [[IndexPageView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64-49) style:UITableViewStyleGrouped];
    _indexPageView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_indexPageView];
    _indexPageView.backgroundColor = [UIColor whiteColor];
    _indexPageView.tableHeaderView = _headerView;
    _indexPageView.tag = 10;
    
    _indexPageView.dataSource = self;
    _indexPageView.delegate = self;
    headerSize = CGSizeMake(self.view.width_sd, _headerView.fancyView.bottom_sd);
    _indexPageView.tableHeaderView.size = headerSize;
    _indexPageView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self requestDataWithLocation:_location.titleLabel.text];
        
    }];
    
    
    
    //推荐教师视图
    
    UICollectionViewFlowLayout *teacherLayout = [[UICollectionViewFlowLayout alloc]init];
    teacherLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _recommandTeacherScrollView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 100) collectionViewLayout:teacherLayout];
    
    _recommandTeacherScrollView.showsHorizontalScrollIndicator = NO;
    _recommandTeacherScrollView.tag = 2;        //推荐教师 tag = 2
    _recommandTeacherScrollView.delegate = self;
    _recommandTeacherScrollView.dataSource = self;
    
    /* 推荐教师视图 注册cell */
    [_recommandTeacherScrollView registerClass:[YZSquareMenuCell class] forCellWithReuseIdentifier:@"RecommandCell"];
    
    
    if (!([[NSUserDefaults standardUserDefaults]objectForKey:@"SubjectChosen"]==NULL)) {
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SubjectChosen"];
        
    }
    
    
    /* 请求kee 并存本地*/
    [self requestKee];
    
    /* 请求今日直播数据*/
    [self requestTodayLive];
    
    /* 请求近期开课和最新发布内容*/
    [self requestNewest];
    
    /* 请求基础信息*/
    [self requestBasicInformation];
    
    /* 另一线程在后台请求未读消息和系统消息*/
    [self checkNotice];
    
    //请求所有tags
    [self getTags];
    
    /* 接收地址选择页面传来的地址*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLoacal:) name:@"UseLocal" object:nil];
    
    
}

#pragma mark- 请求今日直播数据
- (void)requestTodayLive{
    
    _todayLives = @[].mutableCopy;
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/lessons/today",Request_Header] withHeaderInfo:nil andHeaderfield:nil parameters:nil completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            for (NSDictionary *dics in dic[@"data"]) {
                RecommandClasses *mod = [RecommandClasses yy_modelWithJSON:dics];
                mod = [RecommandClasses yy_modelWithJSON:dics[@"course"]];
                mod.classID = dics[@"course"][@"id"];
                mod.live_time = dics[@"live_time"];
                [_todayLives addObject:mod];
            }
            
            [_headerView.todayLiveScrollView reloadData];
        }
        
    }];
    
    
}

#pragma mark- 请求最新发布和最近开课数据
- (void)requestNewest{
    
    _newestRelease = @[].mutableCopy;
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses/rank/published_rank,start_rank?count=2",Request_Header] withHeaderInfo:nil andHeaderfield:nil parameters:nil completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"status"]isEqualToNumber:@1]) {
            //返回的data字段里是两个数组,key对应的是返回的数组
            NSArray *published_rank = dic[@"data"][@"published_rank"];  //最新发布
            NSArray *start_rank = dic[@"data"][@"start_rank"];          //最近开课
            
            for (NSDictionary *dics in published_rank) {
                
                TutoriumListInfo *mod = [TutoriumListInfo yy_modelWithJSON:dics];
                mod.classID = dics[@"id"];
                [_newestRelease addObject:mod];
                
            }
            [_indexPageView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            
            for (NSDictionary *dics in start_rank) {
                
                TutoriumListInfo *mod = [TutoriumListInfo yy_modelWithJSON:dics];
                mod.classID = dics[@"id"];
                [_newestStart addObject:mod];
                
            }
            
            [_indexPageView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
            
        }else{
            
            
        }
        
    }];
    
}


//直接进入直播页
- (void)showNIMPage:(NSNotification *)notification{
    
    LivePlayerViewController *livew = [[LivePlayerViewController alloc]init];
    [self.navigationController pushViewController:livew animated:YES];
    
}

/* 请求通知是否有未读消息*/
- (void)checkNotice{
    
    dispatch_queue_t check = dispatch_queue_create("check", DISPATCH_QUEUE_SERIAL);
    dispatch_async(check, ^{
        
        /* 请求云信的未读数量*/
        [[[NIMSDK sharedSDK]loginManager]addDelegate:self];
        
        NSDictionary *chatDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"chat_account"];
        
        [[NIMSDK sharedSDK].loginManager autoLogin:chatDic[@"accid"] token:chatDic[@"token"]];
        //        [[[NIMSDK sharedSDK]loginManager]login:chatDic[@"accid"] token:chatDic[@"token"] completion:^(NSError * _Nullable error) {
        //
        //
        //
        //        }];
        
        [[[NIMSDK sharedSDK]conversationManager]addDelegate:self];
        
        if ([[[NIMSDK sharedSDK]conversationManager]allUnreadCount]>0) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ReceiveNewNotice" object:nil];
            
        }
        
        /* 请求系统公告消息*/
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager GET:[NSString stringWithFormat:@"%@/api/v1/users/%@/notifications",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                /* 请求成功*/
                NSMutableArray *dataArr = [NSMutableArray arrayWithArray:dic[@"data"]];
                if (dataArr.count != 0) {
                    for (NSDictionary *notice in dataArr) {
                        
                        if (notice[@"read"]) {
                            
                            if ([notice[@"read"] boolValue]== NO ) {
                                
                                
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"ReceiveNewNotice" object:nil];
                                return ;
                            }
                        }
                        
                        
                    }
                    
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    });
    
}


/**
 根据城市定位,请求当地数据
 
 @param location 城市信息
 */
- (void)requestDataWithLocation:(NSString * _Nullable)location{
    
    /* 请求刷新各种数据*/
    [self requestBanner:location];
    [self requestClasses:location];
    [self requestTeachers:location];
    [self requestTodayLive];    //今日直播不区分地区
    [self requestNewest];       //最近课程不区分地区
    
    [_indexPageView.mj_header endRefreshingWithCompletionBlock:^{
       
        
        
    }];
    
    
}

/* 请求全部课程*/
- (void)choseAllTutorium{
    
    /* 发送消息 让第二个页面在初始化后 进行筛选*/
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UserChoseSubject" object:nil];
    
}



#pragma mark- 请求kee
- (void)requestKee{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/recommend/positions",Request_Header ] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *keeDic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *state=[NSString stringWithFormat:@"%@",keeDic[@"status"]];
        
        if ([state isEqualToString:@"0"]) {
            
            /* 登陆过期提示*/
            
        }else{
            
            
            NSArray *keeArr=[NSArray arrayWithArray:[keeDic valueForKey:@"data"]];
            //            NSLog(@"%@",keeArr);
            
            if (keeArr) {
                
                _kee_teacher =[NSString stringWithFormat:@"%@",[keeArr[0] valueForKey:@"kee"]];
                _kee_class =[NSString stringWithFormat:@"%@",[keeArr[3] valueForKey:@"kee"]];
                _kee_banner = [ NSString stringWithFormat:@"%@",[keeArr[2] valueForKey:@"kee"]];
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:_kee_teacher forKey:@"kee_teacher"];
            [[NSUserDefaults standardUserDefaults]setObject:_kee_class forKey:@"kee_class"];
            [[NSUserDefaults standardUserDefaults]setObject:_kee_banner forKey:@"kee_banner"];
            
            
            
            /* 异步线程请求推荐教师*/
            dispatch_queue_t teacher = dispatch_queue_create("teacher", DISPATCH_QUEUE_SERIAL);
            dispatch_async(teacher, ^{
                
                /* 请求推荐教师数据*/
                [self requestTeachers:nil];
                
            });
            
            
            /* 另一异步线程请求精品课程*/
            
            dispatch_queue_t classes = dispatch_queue_create("teacher", DISPATCH_QUEUE_SERIAL);
            dispatch_async(classes, ^{
                
                /* 请求推荐课程数据*/
                [self requestClasses:nil];
                
            });
            
            /* 另一异步线程请求banner图片*/
            dispatch_queue_t banner = dispatch_queue_create("banner", DISPATCH_QUEUE_SERIAL);
            dispatch_async(banner, ^{
                
                /* 请求推荐课程数据*/
                [self requestBanner:nil];
                
            });
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark- 请求banner页方法
- (void)requestBanner:( NSString * _Nullable )location{
    
    _banners = @[].mutableCopy;
    
    NSString *position = nil;
    if (location == nil) {
        position = @"";
    }else{
        
        position =location;
    }
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/recommend/positions/%@/items",Request_Header,_kee_banner] parameters:@{@"city_name":position,@"city_name":position} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        //        NSLog(@"%@",dic);
        
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            
            NSDictionary *dataDic = dic[@"data"];
            
            for (NSDictionary *dic in dataDic) {
                
                [_banners addObject:dic[@"logo_url"]];
            }
            if (_banners.count>0) {
                
                _headerView.cycleScrollView.imageURLStringsGroup  = _banners;
            }
            
            
        }else{
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}

#pragma mark- 请求精品课程方法
- (void)requestClasses:(NSString * _Nullable)location{
    
    _classes = @[].mutableCopy;
    
    //先加载地区信息
    NSString *position = nil;
    if (location == nil) {
        position = @"";
    }else{
        
        position =location;
    }
    
    //请求精选课程数据
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/recommend/positions/%@/items",Request_Header,_kee_class] withHeaderInfo:nil andHeaderfield:nil parameters:@{@"page":[NSString stringWithFormat:@"%ld", page],@"per_page":[NSString stringWithFormat:@"%ld", per_page],@"city_name":position}  completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            NSArray *arr = [NSArray arrayWithArray:dic[@"data"]];
            
            if (arr.count==0) {
                /* 没有任何数据的情况,加载空数据*/
                [self refreshNoClassData];
                
            }else{
                
                for (NSDictionary *dics in arr) {
                    
                    RecommandClasses *mod ;
                    mod = [RecommandClasses yy_modelWithJSON:dics[@"live_studio_course"]];
                    mod.tag_one = dics[@"tag_one"];
                    mod.tag_two = dics[@"tag_two"];
                    mod.classID =dics[@"live_studio_course"][@"id"];
                    [_classes addObject:mod];
                    
                }
                
            }
            [_indexPageView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SizeChange" object:nil];
            
        }else{
            //请求错误
            
        }
        
    }];
    
}


#pragma mark- 推荐教师请求方法
- (void)requestTeachers:(NSString * _Nullable)location{
    
    _teachers = @[].mutableCopy;
    
    NSString *position;
    if (location == nil) {
        position = @"";
    }else{
        
        position =location;
    }
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/recommend/positions/%@/items",Request_Header,_kee_teacher] parameters:@{/*@"page":[NSString stringWithFormat:@"%ld", page],@"per_page":[NSString stringWithFormat:@"%ld", per_page],*/@"city_name":position} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *teacherDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        //        NSLog( @"%@",teacherDic);
        
        NSString *state =[NSString stringWithFormat:@"%@",teacherDic[@"status"]];
        
        NSArray *teacherarr=@[].mutableCopy;
        
        
        if ([state isEqualToString:@"0"]) {
            /* 请求错误，重新发请求*/
            
        }else{
            
            teacherarr = [teacherDic valueForKey:@"data"];
            
            if (teacherarr.count==0) {
                /* 没有数据,加载空数据*/
                
                [self refreshNoTeacherData];
                
            }else{
                
                for ( int i =0; i<teacherarr.count; i++) {
                    
                    RecommandTeacher *retech=[RecommandTeacher yy_modelWithJSON:teacherarr[i][@"teacher"]];
                    
                    retech.teacherID = [teacherarr[i][@"teacher"] valueForKey:@"id"];
                    retech.teacherName =[teacherarr[i][@"teacher"] valueForKey:@"name"];
                    
                    if (retech.teacherID ==nil) {
                        retech.teacherID =@"";
                    }if (retech.teacherName ==nil) {
                        retech.teacherName =NSLocalizedString(@"推荐教师", nil);
                    }if (retech.avatar_url ==nil) {
                        retech.avatar_url =@"";
                    }
                    
                    [_teachers addObject:retech];
                    
                }
                
            }
            [_recommandTeacherScrollView reloadData];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}



/**
 加载推荐教师的空数据
 */
- (void)refreshNoTeacherData{
    
    _teachers = @[].mutableCopy;
    
    [self reloadData];
}


/**
 加载推荐辅导班的空数据
 */
- (void)refreshNoClassData{
    
    _classes = @[].mutableCopy;
    
    [self reloadData];
    
}

/**
 重新读取数据
 */
- (void)reloadData{
    
    /* collectionView重新加载数据*/
    //    [_headerView.teacherScrollView reloadData];
    //    [_indexPageView.recommandClassCollectionView reloadData];
    
    [self loadingHUDStopLoadingWithTitle:NSLocalizedString(@"数据加载完成", nil)];
    
    
    //    [_indexPageView.recommandClassCollectionView.mj_header endRefreshing];
    
}


#pragma mark- 用户选择科目
- (void)userSelectedSubject:(UITapGestureRecognizer *)sender{
    
    __block  NSString *subjectStr = [NSString string];
    
    switch (sender.view.tag) {
        case 10:
            
            subjectStr=@"语文";
            
            break;
        case 11:
            subjectStr=@"数学";
            
            break;
            
        case 12:
            subjectStr=@"英语";
            
            break;
            
        case 13:
            subjectStr=@"物理";
            
            break;
            
        case 14:
            subjectStr=@"化学";
            
            break;
            
        case 15:
            
            subjectStr=@"生物";
            
            break;
            
        case 16:
            subjectStr=@"历史";
            
            break;
            
        case 17:
            subjectStr=@"地理";
            
            break;
            
        case 18:
            subjectStr=@"政治";
            
            break;
            
        case 19:
            subjectStr=@"科学";
            
            break;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:subjectStr forKey:@"SubjectChosen"];
    
    
    
    /* 发送消息 让第二个页面在初始化后 进行筛选*/
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UserChoseSubject" object:subjectStr];
    
    
    
    
}



#pragma mark- collection datasource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger items = 0;
    
    if (collectionView.tag == 1) {
        
        if (_todayLives.count==0) {
            items = 10;
        }else{
            items = _todayLives.count;
        }
    }else if (collectionView.tag == 2){
        
        if (_teachers.count == 0) {
            items = 5;
        }else{
            items = _teachers.count;
        }
        
    }
    
    
    return items;
    
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell=[[UICollectionViewCell alloc]init];
    
    static NSString * CellIdentifier = @"CollectionCell";
    static NSString * recommandIdentifier = @"RecommandCell";
    
    /* 今日直播的横滑视图*/
    if (collectionView.tag == 1) {
        
        TodayLiveCollectionViewCell * liveCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (_todayLives.count>indexPath.row) {
            liveCell.model = _todayLives[indexPath.row];
        }else{
            [liveCell.classImageView setImage:[UIImage imageNamed:@"school"]];
            liveCell.classNameLabel.text = @"今日直播课程";
            liveCell.stateLabel.text = @"12:00-13:00 开始";
            
        }
        
        cell = liveCell;
        
    }
    
    
    /* 教师推荐的横滑视图*/
    if (collectionView .tag==2) {
        
        YZSquareMenuCell * squarecell = [collectionView dequeueReusableCellWithReuseIdentifier:recommandIdentifier forIndexPath:indexPath];
        
        squarecell.iconImage.layer.masksToBounds = YES;
        squarecell.iconImage.layer.cornerRadius = squarecell.iconImage.frame.size.width/2.f ;
        
        squarecell.sd_indexPath = indexPath;
        
        if (_teachers.count ==0) {
            
            [squarecell.iconTitle setText:NSLocalizedString(@"名师推荐", nil)];
            [squarecell.iconImage setImage: [UIImage imageNamed:@"老师"]];
            
        }else if(_teachers.count>indexPath.row) {
            
            RecommandTeacher *tech = _teachers[indexPath.row];
            
            /* 加载获取到的数据*/
            if (tech.avatar_url !=nil) {
                
                [squarecell.iconImage sd_setImageWithURL:[NSURL URLWithString:tech.avatar_url ]];
            }else{
                [squarecell.iconImage setImage:[UIImage imageNamed:@"老师"]];
                
            }
            
            
            if (tech.teacherName!=nil) {
                
                [squarecell.iconTitle setText:NSLocalizedString(tech.teacherName, nil)];
            }else{
                
                [squarecell.iconTitle setText:NSLocalizedString(@"推荐教师", nil)];
                
            }
            
            
            
        }
        
        cell = squarecell;
        
    }
    
    
    return cell;
    
}


#pragma mark- collectionview delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSInteger sec=0;
    
    if (collectionView.tag==2) {
        sec = 1;
    }
    if(collectionView.tag==1){
        sec =1;
        
    }
    
    return sec;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize layoutSize = CGSizeZero ;
    
    
    if (collectionView.tag==2){
        layoutSize = CGSizeMake(CGRectGetWidth(self.view.frame)/5-10, CGRectGetWidth(self.view.frame)/5);
    }
    
    if (collectionView .tag ==1){
        
        layoutSize = CGSizeMake((self.view.width_sd-36)/2, (self.view.width_sd-36)/2);
        
    }
    
    
    return layoutSize;
}


/* cell的四边间距*/
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    //分别为上、左、下、右
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if (collectionView.tag==1) {
        insets =UIEdgeInsetsMake(20, 12, 20, 12);
    }
    
    if (collectionView.tag ==2) {
        insets = UIEdgeInsetsMake(20, 0, 0, 0);
        
    }
    
    
    
    return insets;
}



#pragma mark- collection的点击事件

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    /* 推荐课程点击事件*/
    if (collectionView.tag ==1) {
        
        if (_classes.count == 0) {
            [self loadingHUDStopLoadingWithTitle:NSLocalizedString(@"该地区没有推荐课程", nil)];
        }else{
            
            RecommandClassCollectionViewCell *cell = (RecommandClassCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            
            TutoriumInfoViewController *viewcontroller = [[TutoriumInfoViewController alloc]initWithClassID:cell.model.classID];
            
            viewcontroller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewcontroller animated:YES];
        }
    }
    
    if (collectionView.tag ==2) {
        
        if (_teachers.count==0) {
            
            /* 数据请求错误*/
            
            [self loadingHUDStopLoadingWithTitle:NSLocalizedString(@"该地区没有推荐教师", nil)];
            
            
        }else{
            
            NSString *teacherId=[NSString string];
            
            RecommandTeacher *teach =_teachers[indexPath.row];
            
            teacherId = teach.teacherID;
            
            TeachersPublicViewController *public =[[TeachersPublicViewController alloc]initWithTeacherID:teacherId];
            
            public.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:public animated:YES];
            
            
        }
        
        
    }
    
}


#pragma mark- tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 4;
            
            break;
            
        case 1:
            rows = 2;
            break;
        case 2:
            rows = 2;
            break;
    }
    return rows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    QualityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[QualityTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        
    }
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    switch (indexPath.section) {
        case 0:{
            
            if (_classes.count == 0) {
                
                [cell.classImage setImage:[UIImage imageNamed:@"school"]];
                cell.className.text = @"精品课程";
                cell.teacherName.text = @"老师";
                cell.gradeAndSubject.text = @"科目";
                
                cell.left_StateLabel.hidden = YES;
                cell.right_StateLabel.hidden = YES;
                
            }else if (_classes.count>indexPath.row) {
                cell.recommandModel = _classes[indexPath.row];
                cell.left_StateLabel.hidden = NO;
                cell.right_StateLabel.hidden = NO;
            }
        }
            break;
            
        case 1:{
            
            if (_newestStart.count == 0) {
                
            }else if (_newestStart.count>indexPath.row) {
                cell.classModel = _newestStart[indexPath.row];
                cell.left_StateLabel.hidden = YES;
                cell.right_StateLabel.hidden = YES;
                
            }
        }
            break;
        case 2:{
            
            if (_newestRelease.count == 0) {
                
            }else if (_newestRelease.count>indexPath.row) {
                cell.classModel = _newestRelease[indexPath.row];
                cell.left_StateLabel.hidden = YES;
                cell.right_StateLabel.hidden = YES;
                
            }
            
        }
            break;
    }
    
    return  cell;
    
}


#pragma mark- tableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.view.width_sd/3.5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QualityTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    TutoriumInfoViewController *controller;
    
    switch (indexPath.section) {
        case 0:{
            
            if (_classes.count==0) {
                
                [self loadingHUDStopLoadingWithTitle:@"当前地区无精选内容"];
                
            }else{
            
                controller = [[TutoriumInfoViewController alloc]initWithClassID:cell.recommandModel.classID];
            }
            
        }
            break;
            
        case 1:{
            
            controller = [[TutoriumInfoViewController alloc]initWithClassID:cell.classModel.classID];
        }
            
            break;
            
        case 2:{
            controller = [[TutoriumInfoViewController alloc]initWithClassID:cell.classModel.classID];
        }
            
            break;
    }
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    
    UILabel *label = [UILabel new];
    
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:17*ScrenScale];
    [view addSubview:label];
    label.sd_layout
    .leftSpaceToView(view,12)
    .topSpaceToView(view,10)
    .autoHeightRatio(0);
    [label setSingleLineAutoResizeWithMaxWidth:100];
    
    UILabel *more = [[UILabel alloc]init];
    more.userInteractionEnabled = YES;
    more.textColor = TITLECOLOR;
    more.font = [UIFont systemFontOfSize:12*ScrenScale];
    more.text = @"更多";
    
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightArrow"]];
    arrow.userInteractionEnabled = YES;
    
    
    if (section == 1) {
        
        label.text = @"近期开课";
        
        _moreCurrentClassButton = [[UIControl alloc]init];
        [view addSubview:_moreCurrentClassButton];
        _moreCurrentClassButton.sd_layout
        .rightSpaceToView(view,12)
        .topEqualToView(label)
        .bottomEqualToView(label)
        .widthRatioToView(label,1.0);
        
        
        [_moreCurrentClassButton addSubview:more];
        [_moreCurrentClassButton addSubview:arrow];
        
        arrow.sd_layout
        .rightSpaceToView(_moreCurrentClassButton,0)
        .centerYEqualToView(_moreCurrentClassButton)
        .heightRatioToView(_moreCurrentClassButton,0.5)
        .widthEqualToHeight();
        
        more.sd_layout
        .rightSpaceToView(arrow,0)
        .topEqualToView(arrow)
        .bottomEqualToView(arrow);
        [more setSingleLineAutoResizeWithMaxWidth:100];
        
    }else if(section == 2){
        
        label.text = @"新课发布";
        
        _moreNewClassButton = [[UIControl alloc]init];
        [view addSubview:_moreNewClassButton];
        _moreNewClassButton.sd_layout
        .rightSpaceToView(view,12)
        .topEqualToView(label)
        .bottomEqualToView(label)
        .widthRatioToView(label,1.0);
        
        [_moreNewClassButton addSubview:more];
        [_moreNewClassButton addSubview:arrow];
        
        arrow.sd_layout
        .rightSpaceToView(_moreNewClassButton,0)
        .centerYEqualToView(_moreNewClassButton)
        .heightRatioToView(_moreNewClassButton,0.5)
        .widthEqualToHeight();
        
        more.sd_layout
        .rightSpaceToView(arrow,0)
        .topEqualToView(arrow)
        .bottomEqualToView(arrow);
        [more setSingleLineAutoResizeWithMaxWidth:100];
    }

    return view;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view;
    
    if (section==0) {
        
        UIView *content = [[UIView alloc]init];
        content.backgroundColor = [UIColor whiteColor];
        UILabel *recTeach = [[UILabel alloc]init];
        recTeach.text = @"推荐教师";
        recTeach.font = [UIFont systemFontOfSize:17*ScrenScale];
        [content addSubview:recTeach];
        recTeach.sd_layout
        .topSpaceToView(content,10)
        .leftSpaceToView(content,12)
        .autoHeightRatio(0);
        [recTeach setSingleLineAutoResizeWithMaxWidth:100];
        
        [recTeach updateLayout];
        
        [content addSubview:_recommandTeacherScrollView];
        _recommandTeacherScrollView.backgroundColor = [UIColor whiteColor];
        _recommandTeacherScrollView.frame = CGRectMake(0, CGRectGetMaxY(recTeach.frame)+10, self.view.width_sd,80 ) ;
        view = content;
        
    }
    
    return view;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    NSInteger height=0;
    if (section == 0) {
        height = 130;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSInteger height =0;
    
    if (section == 1) {
        height = 40;
    }else if (section ==2){
        
        height = 40;
    }
    
    return height;
}



#pragma mark- 获取程序所有的基础信息
- (void)requestBasicInformation{
    
    [self loadingHUDStartLoadingWithTitle:NSLocalizedString(@"正在获取基础信息", nil)];
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/app_constant",Request_Header] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        [self loginStates:dic];
        
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"BasicInformation"];
            
            NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:dic[@"data"]];
            [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"grades"] forKey:@"grade"];
            [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"cities"] forKey:@"city"];
            [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"provinces"] forKey:@"province"];
            [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"schools"] forKey:@"school"];
            
            /* 把所有的城市信息提出来*/
            
            _cities = [NSMutableArray arrayWithArray:dataDic[@"cities"]];
            
            dispatch_queue_t city = dispatch_queue_create("city", DISPATCH_QUEUE_SERIAL);
            dispatch_async(city, ^{
                
                /* 写入完成后开始加工数据*/
                
                [self makeCityList:_cities];
                
                
            });
            
            
#pragma mark- 写完城市信息plist之后,开始定位
            
            if (YES) {
                
                [self getLocation];
                
                if ([CLLocationManager locationServicesEnabled]  //确定用户的位置服务启用
                    &&[CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
                    //位置服务是在设置中禁用
                }
            }
            
            [self loadingHUDStopLoadingWithTitle:NSLocalizedString(@"基础信息获取成功", nil)];
            
        }else{
            
            [self loadingHUDStopLoadingWithTitle:NSLocalizedString(@"基础信息获取失败", nil)];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


#pragma mark- 获取系统支持的tags (课程标签)
- (void)getTags{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/app_constant/tags",Request_Header] withHeaderInfo:nil andHeaderfield:nil parameters:nil completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            [[NSUserDefaults standardUserDefaults] setValue:dic[@"data"] forKey:@"Tags"];
            
        }
        
    }];
    
}


/* 是否可以进入消息中心*/
- (void)shouldEnterNoticeCenter{
    
    /* 没登录的情况下,直接跳转至登录页面*/
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Login"]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Login"]==NO) {
            [self loginAgain];
        }else{
            
        }
    }else{
        
        [self loginAgain];
        
    }
    
}

//
///* 进入消息中心*/
//- (void)enterNoticeCenter{
//
//    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Login"]) {
//        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Login"]==YES) {
//
//            NoticeIndexViewController *noticeVC = [[NoticeIndexViewController alloc]init];
//            [self.navigationController pushViewController:noticeVC animated:YES];
////            _badge.hidden = YES;
//        }else{
//            [self loginAgain];
//        }
//
//    }else{
//        [self loginAgain];
//    }
//
//}

//进入扫描页面
- (void)enterScanPage{
    
    QRCodeController *qrcontroller = [[QRCodeController alloc]init];
    qrcontroller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qrcontroller animated:YES];
    
    
}



#pragma mark- 定位
- (void)getLocation{
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    /** 由于IOS8中定位的授权机制改变 需要进行手动授权
     * 获取授权认证，两个方法：
     * [self.locationManager requestWhenInUseAuthorization];
     * [self.locationManager requestAlwaysAuthorization];
     */
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        NSLog(@"requestWhenInUseAuthorization");
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //开始定位，不断调用其代理方法
    [self.locationManager startUpdatingLocation];
    self.locationManager.delegate = self;
    
    NSLog(@"start gps");
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

#pragma mark Location and Delegate


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             
             _localCity = [NSString stringWithFormat:@"%@", placemark.subLocality];
             
             /* 定位信息存本地*/
             [[NSUserDefaults standardUserDefaults]setValue:placemark.administrativeArea forKey:@"Location_Province"];
             [[NSUserDefaults standardUserDefaults]setValue:_localCity forKey:@"Location"]; //保存区地址
             [[NSUserDefaults standardUserDefaults]setValue:placemark.locality forKey:@"Location_City"]; //保存市地址
             
             /*
              定位完成后,跟本地信息进行比较,如果有工作站,就提示用户切换到当前城市,没有就不提示*/
             
             [self checkCityListWithInformationChange:placemark];
             
             
             if (!_localCity) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 _localCity = placemark.administrativeArea;
                 
             }
             
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
    
    // 2.停止定位
    [manager stopUpdatingLocation];
}



/**
 根据定位到的用户位置信息,查询后台地理信息数据,判断是否切换城市地区
 
 @param loaction 地址位置的str
 */
- (void)checkCityListWithInformationChange:(CLPlacemark *)loaction{
    
    if (_localCity) {
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"city"]) {
            
            NSArray *citys = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"city"]];
            
            for (NSDictionary *cityDic in citys) {
                
                if ([loaction.subLocality isEqualToString:cityDic[@"name"]]) {
                    if ([cityDic[@"workstations_count"] integerValue] !=0) {
                        
                        /* 在定位城市地址当地有工作产的情况下*/
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:@"%@%@,%@",NSLocalizedString(@"当前定位地点在", nil), loaction.subLocality,NSLocalizedString(@"是否切换至该地区?", nil)] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }] ;
                        UIAlertAction *sure = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            [_location setTitle:loaction.subLocality forState:UIControlStateNormal];
                            
                            /* 请求当前所在地区的数据*/
                            [self requestDataWithLocation:loaction.locality];
                            
                            //定位信息存本地
                            [[NSUserDefaults standardUserDefaults]setValue:loaction.locality forKey:@"Location"];
                            [[NSUserDefaults standardUserDefaults]setValue:loaction.administrativeArea forKey:@"Location_Province"];
                            
                            [[NSUserDefaults standardUserDefaults]setValue:loaction.locality forKey:@"Location_City"];
                            
                            
                        }] ;
                        
                        [alert addAction:cancel];
                        [alert addAction:sure];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    }else{
                        
                    }
                    
                }else if([loaction.locality isEqualToString:cityDic[@"name"]]){
                    
                    /* 如果最第一级的城市位置没有的话,对应上一级*/
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:@"%@%@,%@",NSLocalizedString(@"当前定位地点在", nil), loaction.subLocality,NSLocalizedString(@"是否切换至该地区?", nil)] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }] ;
                    UIAlertAction *sure = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [_location setTitle:loaction.locality forState:UIControlStateNormal];
                        
                        /* 请求当前所在地区的数据*/
                        [self requestDataWithLocation:loaction.locality];
                        
                        //定位信息存本地
                        [[NSUserDefaults standardUserDefaults]setValue:loaction.locality forKey:@"Location"];
                        [[NSUserDefaults standardUserDefaults]setValue:loaction.administrativeArea forKey:@"Location_Province"];
                        
                        [[NSUserDefaults standardUserDefaults]setValue:loaction.locality forKey:@"Location_City"];
                        
                    }] ;
                    
                    [alert addAction:cancel];
                    [alert addAction:sure];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
                
            }
            
        }
    }
    
}

/* 制作城市信息plist文件*/
- (void)makeCityList:(NSMutableArray *)cityList{
    
    //    [self loadingHUDStartLoadingWithTitle:@"更新城市信息"];
    
    /* 保存城市名称的数据*/
    NSMutableArray *cityName = @[].mutableCopy;
    
    /* 保存排序后城市名称的数组*/
    NSMutableArray *sortCityName = @[].mutableCopy;
    
    /* 第一步,遍历出所有城市的名称*/
    for (NSDictionary *cityDic in cityList) {
        
        [cityName addObject:cityDic[@"name"]];
        
    }
    
    /* 第二步,城市名称分组并排序*/
    sortCityName  = [ChineseString LetterSortArray:cityName];
    
    /* 同时,把字母顺序也排出来*/
    NSMutableArray *titles = [ChineseString IndexArray:cityName];
    
    /* 第三步,用每一个排序好后的城市名字,遍历城市列表,制作字典*/
    /* 城市字典变量*/
    NSMutableDictionary *_cityDic=nil;
    
    /* 分组的->字典变量*/
    NSMutableDictionary *widthDic = @{}.mutableCopy;
    
    
    /* 大数组*/
    
    NSMutableArray *cityData = @[].mutableCopy;
    for (NSInteger i = 0; i<titles.count; i++) {
        /* 22次*/
        
        NSMutableArray *citys = @[].mutableCopy;
        
        for (NSInteger n = 0; n<[sortCityName[i] count]; n++) {
            
            /* 根据每个数组的元素个数,不定循环次数*/
            
            /* 从每一个组里,把城市名字提出来*/
            NSString *city =sortCityName[i][n];
            
            /* 最低一层要保存的数组*/
            
            /* 遍历城市列表*/
            for (NSDictionary *cityItem in cityList) {
                
                if ([city isEqualToString:cityItem[@"name"]]) {
                    
                    /* 如果城市名相同,直接制作字典*/
                    
                    _cityDic =[NSMutableDictionary dictionaryWithDictionary: @{
                                                                               @"city_key":[NSString stringWithFormat:@"%@",cityItem[@"id"]],
                                                                               @"city_name":city,
                                                                               @"short_name":city,
                                                                               @"province_id":[NSString stringWithFormat:@"%@",cityItem[@"province_id"]],
                                                                               @"workstations_count":[NSString stringWithFormat:@"%@",cityItem[@"workstations_count"]]
                                                                               }];
                    
                }
                
            }
            [citys addObject:_cityDic];
            
        }
        
        widthDic = [NSMutableDictionary dictionaryWithDictionary:@{@"citys":citys,@"initial":titles[i]}];
        //        NSLog(@"%@",widthDic);
        
        [cityData addObject:widthDic];
    }
    
    
    /* 最后,把"全国"这一条数据做进去*/
    NSDictionary *contr = @{@"citys":@[@{@"city_key":@"000",@"city_name":@"全国",@"province_id":@"00",@"short_name":@"全国"}],@"initial":@"全国",@"workstations_count":@"99"};
    
    [cityData insertObject:contr atIndex:0];
    
    /* 大的城市数据表已经组合完成,现在存入本地*/
    
    
    NSString *cityFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"City.plist"];
    
    [cityData writeToFile:cityFilePath atomically:YES];
    
    //    NSLog(@"%@",cityData);
}


/* 地址选择*/
- (void)choseLocation{
    
    TLCityPickerController *locationController = [[TLCityPickerController alloc]initWithLoacatedCity:_location.titleLabel.text];
    
    locationController.delegate = self;
    
    if (_cities) {
        for (NSDictionary *city in _cities) {
            
            if ([_localCity isEqualToString:city[@"name"]]) {
                
                locationController.locationCityID = [NSString stringWithFormat:@"%@",city[@"id"]];
            }
            
        }
    }
    
    locationController.hotCitys = @[@"1",@"266"];
    
    locationController.hidesBottomBarWhenPushed = YES;
    [self .navigationController pushViewController:locationController animated:YES];
    
    
}

- (void) cityPickerController:(TLCityPickerController *)cityPickerViewController
                didSelectCity:(TLCity *)city{
    
    [_location setTitle:city.cityName forState:UIControlStateNormal];
    [cityPickerViewController.navigationController popViewControllerAnimated:YES];
    
    [self requestDataWithLocation:city.cityName];
    
    [self loadingHUDStopLoadingWithTitle:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"已切换到", nil),city.cityName]];
    
}

- (void) cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController{
    
    [cityPickerViewController.navigationController popViewControllerAnimated:YES];
}



/* 接到上一页传来的地址信息,修改该页面的地址信息*/
- (void)changeLoacal:(NSNotification *)notification{
    
    NSString *local = notification.object;
    [_location setTitle:local forState:UIControlStateNormal];
    
    
}



#pragma mark- 下拉刷新方法 ->下拉刷新要执行的操作

- (void)refreshIndexPage{
    
    [self requestDataWithLocation:_location.titleLabel.text];
    
    
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
