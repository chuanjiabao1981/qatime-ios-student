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
#import "RDVTabBarController.h"
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


@interface IndexPageViewController ()<UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,CLLocationManagerDelegate,TLCityPickerDelegate,UIGestureRecognizerDelegate,NIMLoginManagerDelegate,NIMConversationManagerDelegate>{
    
    
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
    
    
    /* 头视图的尺寸*/
    CGSize headerSize;
    
    UIButton *_location;
    
    /* 所有的城市信息*/
    NSMutableArray *_cities;
    
    /* 定位城市*/
    NSString *_localCity;
    
    
}

/* 定位管理器*/
@property (nonatomic, strong) CLLocationManager* locationManager;


@end

@implementation IndexPageViewController

- (void)loadView{
    [super loadView];
    
    [self loadingHUDStartLoadingWithTitle:@"正在加载数据"];
    
    /* 导航栏加载*/
    _navigationBar = ({
        NavigationBar *_ = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        
        [self .view addSubview:_];
        [_.rightButton setImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
      
        
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
    
    _badge = [[UIImageView alloc]initWithFrame:CGRectMake(_navigationBar.rightButton.width_sd-5*ScrenScale,-5*ScrenScale, 10*ScrenScale,10*ScrenScale )];
    [_badge setImage:[UIImage imageNamed:@"Badge"]];
    [_navigationBar.rightButton addSubview:_badge];
    _badge.hidden = YES;
    
    [_navigationBar.rightButton addTarget:self action:@selector(enterNoticeCenter) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNewNotice) name:@"ReceiveNewNotice" object:nil];
    
}



- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }

    
    menuImages = @[[UIImage imageNamed:@"语文"],[UIImage imageNamed:@"数学"],[UIImage imageNamed:@"英语"],[UIImage imageNamed:@"物理"],[UIImage imageNamed:@"化学"],[UIImage imageNamed:@"生物"],[UIImage imageNamed:@"历史"],[UIImage imageNamed:@"地理"],[UIImage imageNamed:@"政治"],[UIImage imageNamed:@"科学"]];
    menuTitiels = @[@"语文",@"数学",@"英语",@"物理",@"化学",@"生物",@"历史",@"地理",@"政治",@"科学"];
    
    /* 头视图*/
    _headerView = [[IndexHeaderPageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, self.view.height_sd*3.1/5.0)];
    
    _headerView.teacherScrollView.tag =0;
    
    /* 注册推荐教师滚动视图*/
    [_headerView.teacherScrollView registerClass:[YZSquareMenuCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    
    /* 头视图的10个科目按钮加手势*/
    for (int i=0; i<_headerView.squareMenuArr.count; i++) {
        
        _headerView.squareMenuArr[i].tag=10+i;
        
        UITapGestureRecognizer *taps =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userSelectedSubject:)];
        
        [_headerView.squareMenuArr[i] addGestureRecognizer:taps];
        
    }
    
    /* 推荐教师滚动视图 指定代理*/
    _headerView.teacherScrollView.delegate = self;
    _headerView.teacherScrollView.dataSource = self;
    
    /* 主页的collection*/
    _indexPageView = [[IndexPageView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64-49) ];
    headerSize = CGSizeMake(self.view.width_sd, 600);
    
    /* 指定代理*/
    
    _indexPageView.recommandClassCollectionView.delegate = self;
    _indexPageView.recommandClassCollectionView.dataSource = self;
    
    /* collectionView 注册cell、headerID*/
    
    [_indexPageView.recommandClassCollectionView registerClass:[RecommandClassCollectionViewCell class] forCellWithReuseIdentifier:@"RecommandCell"];
    
    
    [_indexPageView.recommandClassCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCell"];
    
    _indexPageView.recommandClassCollectionView.tag =1;
    
    [self.view addSubview:_indexPageView];
    
    if (!([[NSUserDefaults standardUserDefaults]objectForKey:@"SubjectChosen"]==NULL)) {
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SubjectChosen"];
        
    }
    
    
#pragma mark- 变量初始化
    page = 1;
    per_page =10;
    
    
#pragma mark- 初始数据请求
    
    /* 请求kee*/
    _kee_teacher = [NSString string];
    _kee_class = [NSString string];
    
    //    _recommandTeachers =@[].mutableCopy;
    
    
    _teachers =@[].mutableCopy;
    _classes = @[].mutableCopy;
    
    /* 请求kee 并存本地*/
    [self requestKee];
    
    /* 初次请求成功后，直接申请推荐教师和推荐课程*/
    
    /* 请求推荐教师详情*/
    
    
    /* 添加headerview尺寸变化的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sizeToFitHeight) name:@"SizeChange" object:nil];
    
    /* 请求基础信息*/
    [self requestBasicInformation];
    
    /* 全部课程按钮*/
    [_headerView.recommandAllButton addTarget:self action:@selector(choseAllTutorium) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.allArrowButton addTarget:self action:@selector(choseAllTutorium) forControlEvents:UIControlEventTouchUpInside];
    
    /* 另一线程在后台请求未读消息和系统消息*/
    [self checkNotice];
    
    
    /* 接收地址选择页面传来的地址*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLoacal:) name:@"UseLocal" object:nil];
    
}

/* 请求通知是否有wei*/
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
    
    
}

/* 请求全部课程*/
- (void)choseAllTutorium{
    
    self.rdv_tabBarController.selectedIndex = 1;
    
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
        
        //        NSLog(@"%@",keeDic);
        
        NSString *state=[NSString stringWithFormat:@"%@",keeDic[@"status"]];
        
        if ([state isEqualToString:@"0"]) {
            
            /* 登陆过期提示*/
            
        }else{
            
            
            NSArray *keeArr=[NSArray arrayWithArray:[keeDic valueForKey:@"data"]];
            //            NSLog(@"%@",keeArr);
            
            if (keeArr) {
                
                _kee_teacher =[NSString stringWithFormat:@"%@",[keeArr[0] valueForKey:@"kee"]];
                _kee_class =[NSString stringWithFormat:@"%@",[keeArr[1] valueForKey:@"kee"]];
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
            
            
            /* 另一异步线程请求推荐课程*/
            
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

#pragma mark- 请求推荐课程方法
- (void)requestClasses:(NSString * _Nullable)location{
    
    _classes = @[].mutableCopy;
    
    NSString *position = nil;
    if (location == nil) {
        position = @"";
    }else{
        
        position =location;
    }
    
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/recommend/positions/%@/items",Request_Header,_kee_class] parameters:@{@"page":[NSString stringWithFormat:@"%ld", page],@"per_page":[NSString stringWithFormat:@"%ld", per_page],@"city_name":position} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *classDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        //        NSLog( @"%@",classDic);
        
        NSString *state =[NSString stringWithFormat:@"%@",classDic[@"status"]];
        
        NSArray *classArr=@[].mutableCopy;
        
        if ([state isEqualToString:@"0"]) {
            /* 请求错误，重新发请求*/
            
            
            
        }else{
            
            classArr = [classDic valueForKey:@"data"];
            
            if (classArr.count==0) {
                
                /* 没有任何数据的情况,加载空数据*/
                
                [self refreshNoClassData];
                
            }else{
                
                for ( int i =0; i<classArr.count; i++) {
                    
                    NSDictionary *classinfo =[NSDictionary dictionaryWithDictionary:[classArr[i] valueForKey:@"live_studio_course"]];
                    RecommandClasses *reclass=[RecommandClasses yy_modelWithDictionary:classinfo];
//                    reclass.title =[classArr[i] valueForKey:@"title"];
//                    reclass.index =[[classArr[i] valueForKey:@"index"] integerValue];
                    if ([[classArr[i] valueForKey:@"reason"]isEqual:[NSNull null]]) {
                        reclass.reason = @"";
                    }else{
                        reclass.reason =[classArr[i] valueForKey:@"reason"];
                    }
                    reclass.logo_url =[classArr[i] valueForKey:@"logo_url"];
                    reclass.classID =[[classArr[i] valueForKey:@"live_studio_course"]valueForKey:@"id"];
                    
                    [_classes addObject:reclass];
                    
                }
                
                [self reloadData];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"SizeChange" object:nil];
            }
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}



#pragma mark- 推荐教师请求方法
- (void)requestTeachers:(NSString * _Nullable)location{
    
    _teachers = @[].mutableCopy;
    
    NSString *position = nil;
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
                        retech.teacherName =@"推荐教师";
                    }if (retech.avatar_url ==nil) {
                        retech.avatar_url =@"";
                    }
                    
                    [_teachers addObject:retech];
                    
                }
                
                
                [self reloadData];
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}



/**
 加载推荐教师的空数据
 */
- (void)refreshNoTeacherData{
    
    //    NSLog(@"%@", _teachers);
    _teachers = @[].mutableCopy;
    
    [_headerView.teacherScrollView reloadData];
    
}


/**
 加载推荐辅导班的空数据
 */
- (void)refreshNoClassData{
    
    _classes = @[].mutableCopy;
    
    [_indexPageView.recommandClassCollectionView reloadData];
    
}

/**
 重新读取数据
 */
- (void)reloadData{
    
    /* collectionView重新加载数据*/
    [_headerView.teacherScrollView reloadData];
    
    [_indexPageView.recommandClassCollectionView reloadData];
    
    [self loadingHUDStopLoadingWithTitle:@"数据加载完成"];
    
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
    
    self.rdv_tabBarController.selectedIndex = 1;
    
    /* 发送消息 让第二个页面在初始化后 进行筛选*/
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UserChoseSubject" object:subjectStr];
    
    
}






#pragma mark- collectionview datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger items=0;
    
    if (collectionView.tag==0) {
        
        if (_teachers) {
            if (_teachers.count > 0) {
                items =_teachers.count;
                
            }else if (_teachers.count==0){
                items = 10;
            }
        }
        
    }
    
    if (collectionView .tag ==1){
        
        if (_classes) {
            if (_classes.count>=6) {
                items = 6;
            }else if(_classes.count>0&&_classes.count<6){
                items = _classes.count;
            }else if (_classes.count==0){
                items = 6;
            }
        }
    }
    
    return items;
    
}

#pragma mark- collectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSInteger sec=0;
    
    if (collectionView.tag==0) {
        sec = 1;
    }
    if(collectionView.tag==1){
        sec =1;
        
    }
    
    return sec;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize layoutSize = CGSizeZero ;
    
    
    if (collectionView.tag==0){
        layoutSize = CGSizeMake(CGRectGetWidth(self.view.frame)/5-10, CGRectGetWidth(self.view.frame)/5);
    }
    
    if (collectionView .tag ==1){
        
        layoutSize = CGSizeMake((self.view.width_sd-36)/2, (self.view.width_sd-36)/2);
        
    }
    
    
    return layoutSize;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell *cell=[[UICollectionViewCell alloc]init];
    
    
    static NSString * CellIdentifier = @"CollectionCell";
    static NSString * recommandIdentifier = @"RecommandCell";
    
    
    /* 教师推荐的横滑视图*/
    if (collectionView .tag==0) {
        
        YZSquareMenuCell * squarecell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        squarecell.iconImage.layer.masksToBounds = YES;
        squarecell.iconImage.layer.cornerRadius = squarecell.iconImage.frame.size.width/2.f ;
        
        squarecell.sd_indexPath = indexPath;
        
        if (_teachers.count ==0) {
            
            [squarecell.iconTitle setText:@"名师推荐"];
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
                
                [squarecell.iconTitle setText:tech.teacherName];
            }else{
                
                [squarecell.iconTitle setText:@"推荐教师"];
                
            }
            
            
            
        }
        
        cell = squarecell;
        
    }
    
    /* 辅导课程推荐 视图*/
    
    if (collectionView .tag==1) {
        
        RecommandClassCollectionViewCell *reccell=[collectionView dequeueReusableCellWithReuseIdentifier:recommandIdentifier forIndexPath:indexPath];
        
        reccell.sd_indexPath = indexPath;
        
        
        if (_classes .count >indexPath.row) {
            
            reccell.model = _classes[indexPath.row];
            reccell.sd_indexPath = indexPath;
            reccell.saledLabel.hidden = NO;
            
        }else if (_classes .count==0){
            
            reccell.model = [[RecommandClasses alloc]init];
            
            [reccell.classImage setImage:[UIImage imageNamed:@"school"]];
            reccell.className.text = @"当前无课程";
            
            reccell.saledLabel.hidden = YES;
            
        }
        
        if (reccell.isNewest==YES) {
            reccell.reason.text = @" 最新 ";
            reccell.reason.backgroundColor = [UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0];
        }
        if (reccell.isHottest == YES) {
            reccell.reason.text = @" 最热 ";
            reccell.reason.backgroundColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.6 alpha:1.0];
        }
        
        
        cell=reccell ;
        
    }
    
    return cell;
    
}


#pragma mark- collectionview delegate
/* cell的四边间距*/
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    //分别为上、左、下、右
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if (collectionView.tag ==0) {
        insets = UIEdgeInsetsZero;
        
    }
    
    
    if (collectionView.tag==1) {
        insets =UIEdgeInsetsMake(0, 12, 0, 12);
    }
    
    return insets;
}



#pragma mark- collection的点击事件

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag ==0) {
        
        if (_teachers.count==0) {
            
            /* 数据请求错误*/
            
            [self loadingHUDStopLoadingWithTitle:@"该地区没有推荐教师"];
            
            
        }else{
            
            NSString *teacherId=[NSString string];
            
            RecommandTeacher *teach =_teachers[indexPath.row];
            
            teacherId = teach.teacherID;
            
            TeachersPublicViewController *public =[[TeachersPublicViewController alloc]initWithTeacherID:teacherId];
            [self.navigationController pushViewController:public animated:YES];
            
            
        }
        
        
    }
    /* 推荐课程点击事件*/
    if (collectionView.tag ==1) {
        
        if (_classes.count == 0) {
            [self loadingHUDStopLoadingWithTitle:@"该地区没有推荐课程"];
        }else{
            
            RecommandClassCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            
            TutoriumInfoViewController *viewcontroller = [[TutoriumInfoViewController alloc]initWithClassID:cell.model.classID];
            [self.navigationController pushViewController:viewcontroller animated:YES];
        }
        
        
        
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *cellID = @"headerCell";
    UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (collectionView.tag==1) {
        //从缓存中获取 Headercell
        
        [header addSubview:_headerView];
        
    }
    return header;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size;
    
    if (collectionView.tag==1) {
        
        return headerSize;
    }else if (collectionView.tag==0){
        
        return CGSizeMake(0, 0);
    }
    
    return  size;
    
}

#pragma mark- headerView自适应高度方法
- (void)sizeToFitHeight{
    
    CGRect rect = CGRectMake(0, 0, self.view.width_sd, _headerView.conmmandView.centerY_sd+_headerView.conmmandView.height_sd/2);
    
    headerSize = CGSizeMake(self.view.width_sd, rect.size.height);
    
    [_indexPageView.recommandClassCollectionView reloadData];
    [_indexPageView.recommandClassCollectionView setNeedsLayout];
    [_indexPageView.recommandClassCollectionView setNeedsDisplay];
    
}

#pragma mark- 获取程序所有的基础信息
- (void)requestBasicInformation{
    
    [self loadingHUDStartLoadingWithTitle:@"正在获取基础信息"];
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/app_constant",Request_Header] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
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
            
            [self loadingHUDStopLoadingWithTitle:@"基础信息获取成功!"];
            
        }else{
            
            [self loadingHUDStopLoadingWithTitle:@"基础信息获取失败!"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

/* 收到新消息*/
- (void)receiveNewNotice{
    
    _badge.hidden = NO;
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


/* 进入消息中心*/
- (void)enterNoticeCenter{
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Login"]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Login"]==YES) {
            
            NoticeIndexViewController *noticeVC = [[NoticeIndexViewController alloc]init];
            [self.navigationController pushViewController:noticeVC animated:YES];
            _badge.hidden = YES;
        }else{
            [self loginAgain];
        }
        
    }else{
        [self loginAgain];
    }
    
    
    
}

#pragma mark- 定位
- (void)getLocation{
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    /** 由于IOS8中定位的授权机制改变 需要进行手动授权
     * 获取授权认证，两个方法：
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
             [[NSUserDefaults standardUserDefaults]setValue:_localCity forKey:@"Location"];
             
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
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前定位地点在%@,是否切换?",loaction.subLocality] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }] ;
                        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            [_location setTitle:loaction.subLocality forState:UIControlStateNormal];
                            
                            /* 请求当前所在地区的数据*/
                            [self requestDataWithLocation:loaction.locality];
                            
                            
                        }] ;
                        
                        [alert addAction:cancel];
                        [alert addAction:sure];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    }else{
                        
                    }
                    
                }else if([loaction.locality isEqualToString:cityDic[@"name"]]){
                    
                    /* 如果最第一级的城市位置没有的话,对应上一级*/
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前定位地点在%@,是否切换?",loaction.locality] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }] ;
                    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [_location setTitle:loaction.locality forState:UIControlStateNormal];
                        
                        /* 请求当前所在地区的数据*/
                        [self requestDataWithLocation:loaction.locality];
                        
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
   
    
    [self .navigationController pushViewController:locationController animated:YES];
    
    
}

- (void) cityPickerController:(TLCityPickerController *)cityPickerViewController
                didSelectCity:(TLCity *)city{
    
    [_location setTitle:city.cityName forState:UIControlStateNormal];
    [cityPickerViewController.navigationController popViewControllerAnimated:YES];
    
    [self requestDataWithLocation:city.cityName];
    
    [self loadingHUDStopLoadingWithTitle:[NSString stringWithFormat:@"已切换到%@",city.cityName]];
    
}

- (void) cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController{
    
    [cityPickerViewController.navigationController popViewControllerAnimated:YES];
}

/* 接到上一页传来的地址信息,修改该页面的地址信息*/
- (void)changeLoacal:(NSNotification *)notification{
    
    NSString *local = notification.object;
    [_location setTitle:local forState:UIControlStateNormal];
    
    
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
