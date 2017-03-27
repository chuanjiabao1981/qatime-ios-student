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

#import "BuyBar.h"

#import "UIImageView+WebCache.h"
#import "UIViewController_HUD.h"
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


@interface TutoriumInfoViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,TTGTextTagCollectionViewDelegate>{
    
    NavigationBar *_navigationBar;
    
    
    NSString  *_token;
    NSString *_idNumber;
    
    
    /* 保存课程列表的array*/
    NSMutableArray *_classListArray;
    
    
    /* token*/
    //    NSString *_remember_token;
    
    
    /* 购买bar*/
    BuyBar *_buyBar;
    
    
    /* 保存本页面数据*/
    NSMutableDictionary *_dataDic;
    
    
    /* 优惠码*/
    NSString *_promotionCode;
    
    /* 标签图的config*/
    TTGTextTagConfig *_config;
    
}

@end

@implementation TutoriumInfoViewController

- (instancetype)initWithClassID:(NSString *)classID
{
    self = [super init];
    if (self) {
        
        _classID = [NSString string];
        _classID = classID;
        
        /* 取出token*/
        //        _remember_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"];
        
        //        NSLog(@"%@",_remember_token);
        
    }
    return self;
}


- (instancetype)initWithClassID:(NSString *)classID andPromotionCode:(NSString *)promotionCode{
    
    self = [super init];
    if (self) {
        
        _classID = [NSString string];
        _classID = classID;
        
        _promotionCode =[NSString stringWithFormat:@"%@",promotionCode];
        
        /* 取出token*/
        //        _remember_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"];
        
        //        NSLog(@"%@",_remember_token);
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [self.view addSubview:_navigationBar];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastpage) forControlEvents:UIControlEventTouchUpInside];
    
    _tutoriumInfoView = [[TutoriumInfoView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64-TabBar_Height)];
    [self.view addSubview:_tutoriumInfoView];
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    
    /* 购买bar*/
    
    _buyBar= [[BuyBar alloc]initWithFrame:CGRectMake(0, self.view.height_sd-49, self.view.width_sd, 49)];
    
    [self.view addSubview:_buyBar];
    
    if (![self isLogin]) {
        [_buyBar.listenButton addTarget:self action:@selector(loginAgain) forControlEvents:UIControlEventTouchUpInside];
        [_buyBar.applyButton addTarget:self action:@selector(loginAgain) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    _tutoriumInfoView.scrollView.delegate = self;
    _tutoriumInfoView.delegate = self;
    _tutoriumInfoView.view1.delegate = self;
    _tutoriumInfoView.view2.delegate = self;
    

    _tutoriumInfoView.segmentControl.selectionIndicatorHeight=2;
    _tutoriumInfoView.segmentControl.selectedSegmentIndex=0;
    
    _tutoriumInfoView.classTagsView.delegate = self;
    _tutoriumInfoView.teacherTagsView.delegate = self;
    
    //教师头像增加点击手势
    UITapGestureRecognizer *tap_Teacher = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(watchTeachers)];
    [_tutoriumInfoView.teacherHeadImage addGestureRecognizer:tap_Teacher];
    
    
    //标签设置
    _config = [[TTGTextTagConfig alloc]init];
    _config.tagTextColor = TITLECOLOR;
    _config.tagBackgroundColor = [UIColor whiteColor];
    _config.tagBorderColor = [UIColor colorWithRed:0.88 green:0.60 blue:0.60 alpha:1.00];
    _config.tagShadowColor = [UIColor clearColor];
    _config.tagCornerRadius = 0;
    _config.tagExtraSpace = CGSizeMake(15, 5);
    _config.tagTextFont = TEXT_FONTSIZE;
    
    //测试数据
    //    [_tutoriumInfoView.tagsView addTags:@[@"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",@"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",@"on", @"constraints", @"placed", @"on", @"those", @"views"] withConfig:_config];
    
    
    typeof(self) __weak weakSelf = self;
    [ _tutoriumInfoView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.tutoriumInfoView.scrollView scrollRectToVisible:CGRectMake(self.view.width_sd * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-64-49) animated:YES];
    }];
    
    self.tutoriumInfoView.scrollView.delegate = self;
    self.tutoriumInfoView.scrollView.bounces=NO;
    self.tutoriumInfoView.scrollView.alwaysBounceVertical=NO;
    self.tutoriumInfoView.scrollView.alwaysBounceHorizontal=NO;
    
    [self.tutoriumInfoView.scrollView scrollRectToVisible:CGRectMake(0, 0, self.view.width_sd, self.view.height_sd) animated:YES];
    
    _tutoriumInfoView.classesListTableView.delegate = self;
    _tutoriumInfoView.classesListTableView.dataSource = self;
    _tutoriumInfoView.classesListTableView.bounces = YES;
    
    /* 根据传递过来的id 进行网络请求model*/
    /* 初始化三个model*/
    _classModel = [[RecommandClasses alloc]init];
    _teacherModel = [[RecommandTeacher alloc]init];
    _classInfoTimeModel = [[ClassesInfo_Time alloc]init];
    _classListArray = @[].mutableCopy;
    
    /* 请求教师数据*/
    
    /* 请求数据*/
    [self requestClassesInfoWith:_classID];
    
    /* 注册重新加载页面数据的通知*/
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPage) name:@"RefreshTutoriumInfo" object:nil];
    
    /* 注册登录成功重新加载数据的通知*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestAgain) name:@"UserLoginAgain" object:nil];
    
}



/* 登录成功后,再次加载数据*/
- (void)requestAgain{
    
    [_buyBar.listenButton removeTarget:self action:@selector(loginAgain) forControlEvents:UIControlEventTouchUpInside];
    [_buyBar.applyButton removeTarget:self action:@selector(loginAgain) forControlEvents:UIControlEventTouchUpInside];
    
    /* 再次尝试提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    
    /* 请求数据*/
    [self requestClassesInfoWith:_classID];
    
}


/* 根据初始化传值进来的id 进行网络请求*/
- (void)requestClassesInfoWith:(NSString *)classid{
    
    [self loadingHUDStartLoadingWithTitle:@"正在加载信息"];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses/%@",Request_Header,classid] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        /* 拿到数据字典*/
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        [self loginStates:dic];
        
        NSLog(@"%@",dic);
        
        NSString *teacherID = [NSString stringWithFormat:@"%@",dic[@"data"][@"teacher"][@"id"]];
        
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            /* 成功后访问教师数据*/
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager GET:[NSString stringWithFormat:@"%@/api/v1/teachers/%@/profile",Request_Header,teacherID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *teacherDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                if ([teacherDic[@"status"]isEqualToNumber:@1]) {
                    
                    NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
                    
                    _dataDic=[NSMutableDictionary dictionaryWithDictionary:dic[@"data"]];
                    
                    /* 课程页面信息赋值*/
                    _tutoriumInfoView.className.text = _dataDic[@"name"];
                    [_tutoriumInfoView.classImage sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"publicize"]] placeholderImage:[UIImage imageNamed:@"school"]];
                    _tutoriumInfoView.saleNumber.text = [NSString stringWithFormat:@"%@", _dataDic[@"buy_tickets_count"]];
                    
                    /* 已经开课->插班价*/
                    if ([_dataDic[@"status"]isEqualToString:@"teaching"]||[_dataDic[@"status"]isEqualToString:@"pause"]||[_dataDic[@"status"]isEqualToString:@"closed"]) {
                        
                        _tutoriumInfoView.priceLabel.text = [NSString stringWithFormat:@"¥%@(插班价)",_dataDic[@"current_price"]];
                    }else{
                        /* 未开课 总价*/
                        _tutoriumInfoView.priceLabel.text = [NSString stringWithFormat:@"¥%@",_dataDic[@"price"]];
                    }
                    
                    /* 已开课的状态*/
                    if ([_dataDic[@"status"]isEqualToString:@"teaching"]||[_dataDic[@"status"]isEqualToString:@"pause"]||[_dataDic[@"status"]isEqualToString:@"closed"]) {
                        _tutoriumInfoView.recuitState.text = @"已开课";
                        
                        _tutoriumInfoView.deadLine.text = [NSString stringWithFormat:@"[进度%@/%@]",_dataDic[@"completed_lesson_count"],_dataDic[@"lesson_count"]];
                        
                        
                    }else if ([_dataDic[@"status"]isEqualToString:@"missed"]||[_dataDic[@"status"]isEqualToString:@"init"]||[_dataDic[@"status"]isEqualToString:@"ready"]){
                        _tutoriumInfoView.recuitState.text = @"未开课";
                        //            _tutoriumInfoView.onlineVideoLabel.text =@"未开课";
                        
                        _tutoriumInfoView.deadLine.text = [NSString stringWithFormat:@"[距开课%@天]",[self intervalSinceNow:_dataDic[@"live_start_time"] ]];
                        
                        
                    }else if ([_dataDic[@"status"]isEqualToString:@"finished"]||[_dataDic[@"status"]isEqualToString:@"billing"]||[_dataDic[@"status"]isEqualToString:@"completed"]){
                        
                        _tutoriumInfoView.recuitState.text = @"已结束";
                        //            _tutoriumInfoView.onlineVideoLabel.text =@"已结束";
                        
                        
                        
                    }else if ([_dataDic[@"status"]isEqualToString:@"published"]){
                        
                        //            _tutoriumInfoView.onlineVideoLabel.text =@"招生中";
                        
                        
                        if (_dataDic[@"live_start_time"]) {
                            if ([_dataDic[@"live_start_time"]isEqualToString:@""]||[_dataDic[@"live_start_time"]isEqualToString:@" "]) {
                                _tutoriumInfoView.deadLine.text = @"招生中";
                                
                                _tutoriumInfoView.recuitState.text = @"";
                            }else{
                                
                                NSInteger leftDay = [[self intervalSinceNow:_dataDic[@"live_start_time"] ]integerValue];
                                
                                NSString *leftDays;
                                if (leftDay>=1) {
                                    leftDays = [NSString stringWithFormat:@"[距开课%ld天]",leftDay];
                                }else if (leftDay>0&&leftDay<1){
                                    leftDays = @"[即将开课]";
                                    
                                }
                                _tutoriumInfoView.recuitState.text = @"招生中";
                                _tutoriumInfoView.deadLine.text = leftDays;
                            }
                        }
                        
                        
                    }
                    //直播时间赋值
                    _tutoriumInfoView.liveTimeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",[_dataDic[@"live_start_time"]length]>=10?[_dataDic[@"live_start_time"] substringToIndex:10]:_dataDic[@"live_start_time"],[_dataDic[@"live_end_time"] length]>=10?[_dataDic[@"live_end_time"] substringToIndex:10]:_dataDic[@"live_end_time"]];
                   
                    //课程目标
                    _tutoriumInfoView.classTarget.text = _dataDic[@"objective"]==[NSNull null]?@"无":_dataDic[@"objective"];
                    
                    //适合人群
                    _tutoriumInfoView.suitable.text = _dataDic[@"suit_crowd"]==[NSNull null]?@"无":_dataDic[@"suit_crowd"];
                    
                    
                    if ([status isEqualToString:@"0"]) {
                        /* 获取token错误  需要重新登录*/
                        
                    }else{
                        
                        /* 判断课程状态*/
                        
                        [self switchClassData:_dataDic];
                        
                        /* 手动解析teacherModel*/
                        
                        NSLog(@"%@",teacherDic);
                        
                        /* teacherModel赋值与界面数据更新*/
                        _teacherModel.teacherID = teacherDic[@"data"][@"id"];
                        _teacherModel.teacherName =teacherDic[@"data"][@"name"];
                        _teacherModel.school =teacherDic[@"data"][@"school"];
                        _teacherModel.subject = teacherDic[@"data"][@"subject"];
                        _teacherModel.teaching_years =teacherDic[@"data"][@"teaching_years"];
                        
                        /* 教师描述的数据是html富文本,使用系统解析*/
                        _teacherModel.attributedDescribe = [[NSAttributedString alloc] initWithData:[teacherDic[@"data"][@"desc"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                        
                        _teacherModel.describe =teacherDic[@"data"][@"desc"];
                        
                        _teacherModel.gender =teacherDic[@"data"][@"gender"];
                        _teacherModel.avatar_url =teacherDic[@"data"][@"avatar_url"];
                        
                        /* 判断性别是否为空对象    预留性别判断接口*/
                        if (teacherDic[@"data"][@"gender"]!=[NSNull null]) {
                            if ([_teacherModel.gender isEqualToString:@"male"]) {
                                [_tutoriumInfoView.genderImage setImage:[UIImage imageNamed:@"男"]];
                            }if ([_teacherModel.gender isEqualToString:@"female"]){
                                [_tutoriumInfoView.genderImage setImage:[UIImage imageNamed:@"女"]];
                            }
                            _teacherModel.gender = [teacherDic[@"data"] valueForKey:@"gender"];
                            
                        }else{
                            
                            _teacherModel.gender = @"";
                        }
                        
                        [_tutoriumInfoView.teacherNameLabel setText: _teacherModel.teacherName];
                        [_tutoriumInfoView.workPlaceLabel setText:[NSString stringWithFormat:@"%@",_teacherModel.school]];
                        /* 教师简介富文本赋值*/
                        //                        [_tutoriumInfoView.teacherInterviewLabel setText:[NSString stringWithFormat:@"%@",_teacherModel.describe]];
                        
                        _tutoriumInfoView.teacherInterviewLabel.attributedText = _teacherModel.attributedDescribe;
                        //                        _tutoriumInfoView.teacherInterviewLabel.attributedString = [[NSAttributedString alloc]initWithHTMLData:[_teacherModel.describe dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
                        
                        [_tutoriumInfoView.teacherHeadImage sd_setImageWithURL:[NSURL URLWithString:_teacherModel.avatar_url ]];
                        
                        
                        /* 判断教学年限*/
                        _tutoriumInfoView.workYearsLabel.text = [_teacherModel.teaching_years changeEnglishYearsToChinese];
                        
                        
                        
                        /** 手动解析classModel*/
                        _classModel = [RecommandClasses yy_modelWithDictionary:_dataDic];
                        _classModel.classID = _dataDic[@"id"];
                        _classModel.describe = _dataDic[@"description"];
                        
                        /* 课程描述的富文本*/
                        _classModel.attributedDescribe = [[NSMutableAttributedString alloc]initWithData:[_dataDic[@"description"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                        
                        //                        [_classModel.attributedDescribe addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} range:NSMakeRange(0, 17)];
                        
                        /* 课程页面的label赋值*/
                        [_tutoriumInfoView.subjectLabel setText:_classModel.subject];
                        [_tutoriumInfoView.gradeLabel setText:_classModel.grade];
                        [_tutoriumInfoView.classCount setText:[NSString stringWithFormat:@"共%@课",  _classModel.lesson_count]];
                        //                        [_tutoriumInfoView.classDescriptionLabel setText:_classModel.describe];
                        //
                        _tutoriumInfoView.classDescriptionLabel.attributedText = _classModel.attributedDescribe;
                        //                         _tutoriumInfoView.classDescriptionLabel.attributedString = [[NSAttributedString alloc]initWithHTMLData:[_classModel.describe dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
                        
                        
                        //给视图赋值tag的内容
                        
                        if (_classModel.tag_list.count!=0) {
                            
                            [_tutoriumInfoView.classTagsView addTags:_classModel.tag_list withConfig:_config];
                        }else{
                            
                            _config.tagBorderColor = [UIColor whiteColor];
                            _config.tagTextColor = TITLECOLOR;
                            [_tutoriumInfoView.classTagsView addTag:@"无" withConfig:_config];
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
                    [self autoScrollHeight];
                    
                    [self loadingHUDStopLoadingWithTitle:@"加载完成!"];
                    
                }else{
                    /* 返回的教师数据是错误的*/
                    
                    
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

//查看教师详情
- (void)watchTeachers{
    
    TeachersPublicViewController *controller = [[TeachersPublicViewController alloc]initWithTeacherID:_dataDic[@"teacher"][@"id"] ];
    [self.navigationController pushViewController:controller animated:YES];
    
}


#pragma mark- 判断课程状态
- (void)switchClassData:(NSDictionary *)data{
    /* 先判断is_tasting(正在试听) / is_bought(已购买) / tasted() 的状态*/
    
    if ([_dataDic[@"is_bought"]boolValue]==NO) {
        
        /* 还没购买的情况下*/
        if ([_dataDic[@"is_tasting"]boolValue]==YES) {
            /* 如果已经加入试听,而且该课程可以试听*/
            if ([_dataDic[@"is_tasting"]boolValue]==YES) {
                /* 还没有试听*/
                [_buyBar.listenButton setTitle:@"进入试听" forState:UIControlStateNormal];
                [_buyBar.listenButton setBackgroundColor:NAVIGATIONRED];
                [_buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                if (![data[@"status"] isEqualToString:@"finished"]&&![data[@"status"] isEqualToString:@"competed"]){
                    
                    [_buyBar.listenButton addTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
                    
                }else{
                    /* 课程已结束*/
                    [_buyBar.listenButton addTarget:self action:@selector(addClosedListen) forControlEvents:UIControlEventTouchUpInside];
                    
                }
                
            }else{
                
                
            }
            
            
        }else{
            /* 还没有加入试听*/
            
            /* 如果课程还没结束*/
            
            if (![data[@"status"] isEqualToString:@"finished"]&&![data[@"status"] isEqualToString:@"competed"]){
                
                [_buyBar.listenButton addTarget:self action:@selector(addListen) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                /* 课程已结束*/
                [_buyBar.listenButton addTarget:self action:@selector(addClosedListen) forControlEvents:UIControlEventTouchUpInside];
                
            }
        }
        
        /* 购买按钮的点击事件*/
        [_buyBar.applyButton addTarget:self action:@selector(buyClass) forControlEvents:UIControlEventTouchUpInside];
        
        
    }else{
        /* 已经够买的情况下*/
        _buyBar.applyButton.hidden = YES;
        
        [_buyBar.listenButton sd_clearAutoLayoutSettings];
        _buyBar.listenButton.sd_resetLayout
        .leftSpaceToView(_buyBar,10)
        .topSpaceToView(_buyBar,10)
        .bottomSpaceToView(_buyBar,10)
        .rightSpaceToView(_buyBar,10);
        [_buyBar updateLayout];
        
        [_buyBar.listenButton setTitle:@"开始学习" forState:UIControlStateNormal];
        _buyBar.listenButton.backgroundColor = NAVIGATIONRED;
        [_buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        [_buyBar.listenButton addTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    if ([_dataDic[@"preset_lesson_count"]integerValue]==[_dataDic[@"completed_lesson_count"]integerValue]) {
        
        /* 不可以试听*/
        [_buyBar.listenButton setTitle:@"试听结束" forState:UIControlStateNormal];
        [_buyBar.listenButton setBackgroundColor:[UIColor colorWithRed:0.84 green:0.47 blue:0.44 alpha:1.0]];
        [_buyBar.listenButton removeTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
        _buyBar.listenButton.enabled = NO;
    }
    
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
- (void)addListen{
    
    if (_dataDic) {
        if ([_dataDic[@"taste_count"]integerValue]>0) {
            /* 可以试听的情况*/
            
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
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
                    
                    [self loadingHUDStopLoadingWithTitle:@"加入成功"];
                    
                    
                    /* 发送全局通知,发送加入试听课程通知*/
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"AddNewClass" object:_dataDic];
                    
                }else{
                    
                    /* 重新登录*/
                    
                    //                    [self loadingHUDStopLoadingWithTitle:@"登录超时,请重新登录!"];
                    //
                    //                    [self performSelector:@selector(loginAgain) withObject:nil afterDelay:2];
                    
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            
        }else{
            
            [self loadingHUDStopLoadingWithTitle:@"该课程不支持试听"];
        }
    }
    
}

#pragma mark- 立即试听
- (void)listen{
    
    if ([_dataDic[@"is_bought"]boolValue]==YES) {
        
        LivePlayerViewController *neVC = [[LivePlayerViewController alloc]initWithClassID:_dataDic[@"id"]];
        
        [self.navigationController pushViewController:neVC animated:YES];
    }else{
        
        if ([_dataDic[@"taste_count"]integerValue]>0) {
            LivePlayerViewController *neVC = [[LivePlayerViewController alloc]initWithClassID:_dataDic[@"id"]];
            
            [self.navigationController pushViewController:neVC animated:YES];
            
            
        }else{
            [self loadingHUDStopLoadingWithTitle:@"试听次数用尽"];
        }
    }
    
}


#pragma mark- 立即报名的 购买课程方法
- (void)buyClass{
    
    if (_dataDic) {
        
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
        
        //        [self loadingHUDStopLoadingWithTitle:@"请前往网页报名"];
        
    }
    
    
}

#pragma mark- 收集订单信息,并传入下一页,开始提交订单
- (void)requestOrder{
    
    OrderViewController *orderVC;
    
    if (_promotionCode) {
        
        orderVC = [[OrderViewController alloc]initWithClassID:_classID andPromotionCode:_promotionCode];
    }else{
        
        orderVC= [[OrderViewController alloc]initWithClassID:_classID];
    }
    
    
    [self.navigationController pushViewController:orderVC animated:YES];
    
}


- (void)updateTableView{
    
    [_tutoriumInfoView.classesListTableView reloadData];
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    if (scrollView == _tutoriumInfoView.view1) {
//        
//        if (_tutoriumInfoView.contentOffset.y >= _tutoriumInfoView.segmentControl.top_sd) {
//            scrollView.scrollEnabled = YES;
//            _tutoriumInfoView.scrollEnabled = NO;
//            
//        }else{
//            scrollView.scrollEnabled = NO;
//            _tutoriumInfoView.scrollEnabled = YES;
//        }
//    }
    
    
}




#pragma mark- tabelView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    NSInteger rows=0;
    
    if (_classListArray.count ==0) {
        rows =0;
    }else{
        
        
        rows =_classListArray.count;
    }
    
    return rows;
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    ClassesListTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[ClassesListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    /* 教师课程安排的数据  如果为0的情况 。。。。预留判断*/
    if (_classListArray.count>indexPath.row) {
        
        ClassesInfo_Time *mod = _classListArray[indexPath.row];
        cell.model = mod;
        
        if ([_dataDic[@"is_bought"]boolValue]==YES) {
            
            if (cell.model.replayable == NO) {
                
                cell.replay.hidden = YES;
                
            }else{
                cell.replay.hidden = NO;
            }
            
        }else{
            cell.replay.hidden = YES;
            
        }
        
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        
    }
    
    return  cell;
    
}

#pragma mark- tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat heights = 0;
    
    if (_classListArray.count ==0) {
        heights =10;
    }else{
        
        ClassesInfo_Time *model = _classListArray[indexPath.row];
        // 获取cell高度
        heights =[tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ClassesListTableViewCell class] contentViewWidth: [UIScreen mainScreen].bounds.size.width];
        
    }
    
    return heights;
    
}





/* 点击课程表,进入回放的点击事件*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassesListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([_dataDic[@"is_bought"]boolValue]==YES) {
        
        if (cell.model.replayable == YES) {
            
            [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/lessons/%@/replay",Request_Header,cell.model.classID] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                
                if ([dic[@"status"]isEqualToNumber:@1]) {
                    
                    if ([dic[@"data"][@"replayable"]boolValue]== YES) {
                        
                        if ([dic[@"data"][@"left_replay_times"]integerValue]>0) {
                            
                            if (dic[@"data"][@"replay"]==nil) {
                                
                            }else{
                                NSMutableArray *decodeParm = [[NSMutableArray alloc] init];
                                [decodeParm addObject:@"hardware"];
                                [decodeParm addObject:@"videoOnDemand"];
                                
                                VideoPlayerViewController *video  = [[VideoPlayerViewController alloc]initWithURL:[NSURL URLWithString:dic[@"data"][@"replay"][@"orig_url"]] andDecodeParm:decodeParm andTitle:dic[@"data"][@"name"]];
                                [self presentViewController:video animated:YES completion:^{
                                    
                                }];
                            }
                            
                        }else{
                            
                            [self loadingHUDStopLoadingWithTitle:@"回放次数已耗尽"];
                            
                        }
                        
                    }else{
                        [self loadingHUDStopLoadingWithTitle:@"暂无回放视频"];
                    }
                }else{
                    [self loadingHUDStopLoadingWithTitle:@"服务器繁忙,请稍后重试"];
                }
                
            }];
        }
        
        
    }else{
        
        //        [self loadingHUDStopLoadingWithTitle:@"您尚未购买该课程!"];
        /* 未购买,不提示*/
        
    }
}


#pragma mark- tagview delegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize{
    
    if (textTagCollectionView == _tutoriumInfoView.classTagsView) {
        [textTagCollectionView clearAutoHeigtSettings];
       textTagCollectionView.sd_layout
        .heightIs(contentSize.height);
    }else if(textTagCollectionView == _tutoriumInfoView.teacherTagsView){
        
        
    }
}



/* 刷新页面*/
- (void)refreshPage{
    
    [_buyBar.listenButton removeAllTargets];
    [_buyBar.applyButton removeAllTargets];
    
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
- (void)autoScrollHeight{
//    //富文本尺寸适配
    [_tutoriumInfoView.classDescriptionLabel updateLayout];
    [_tutoriumInfoView.teacherInterviewLabel updateLayout];
//
//    /* 使用YYText的YYTextLayout来计算富文本的size*/
//    /* 课程信息的 高度自适应*/
//    CGSize classDesc_size = [YYTextLayout layoutWithContainerSize:CGSizeMake(_tutoriumInfoView.classDescriptionLabel.width_sd, CGFLOAT_MAX) text:_classModel.attributedDescribe].textBoundingSize;
//    
//    /* 课程简介 富文本label先适配自动布局高度*/
//    [_tutoriumInfoView.classDescriptionLabel sd_clearAutoLayoutSettings];
//    _tutoriumInfoView.classDescriptionLabel.sd_layout
//    .leftEqualToView(_tutoriumInfoView.descriptions)
//    .topSpaceToView(_tutoriumInfoView.descriptions,20)
//    .rightSpaceToView(_tutoriumInfoView.view1,20)
//    .heightIs(classDesc_size.height+20);
//    
//    [_tutoriumInfoView.classDescriptionLabel updateLayout];
//    
//    
//    /* 教师简介的  高度自适应*/
//    CGSize teacherDesc_size = [YYTextLayout layoutWithContainerSize:CGSizeMake(_tutoriumInfoView.teacherInterviewLabel.width_sd, CGFLOAT_MAX) text:_teacherModel.attributedDescribe].textBoundingSize;
//    
//    /* 教师简介 富文本label适配自动布局高度*/
//    [_tutoriumInfoView.teacherInterviewLabel sd_clearAutoLayoutSettings];
//    _tutoriumInfoView.teacherInterviewLabel.sd_layout
//    .leftSpaceToView(_tutoriumInfoView.view2,20)
//    .rightSpaceToView(_tutoriumInfoView.view2,20)
//    .topSpaceToView(_tutoriumInfoView.descrip,20)
//    .heightIs(teacherDesc_size.height+20);
//    
//    [_tutoriumInfoView.teacherInterviewLabel updateLayout];
    
}



- (void)returnLastpage{
    
    
    if (_promotionCode) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
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
