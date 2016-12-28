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
#import "RDVTabBarController.h"
#import "BuyBar.h"

#import "UIImageView+WebCache.h"
#import "UIViewController_HUD.h"
#import "UIViewController+HUD.h"

#import "OrderViewController.h"
#import "AppDelegate.h"



#import "NELivePlayerViewController.h"


@interface TutoriumInfoViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    
    NSString  *_token;
    NSString *_idNumber;

    
    /* 保存课程列表的array*/
    NSMutableArray *_classListArray;
    
    
    /* token*/
    NSString *_remember_token;
    
    
    /* 购买bar*/
    BuyBar *_buyBar;
    
    
    /* 保存本页面数据*/
    NSMutableDictionary *_dataDic;
    
    
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
        _remember_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"];

        NSLog(@"%@",_remember_token);
        
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated{
    
    [self.rdv_tabBarController setTabBarHidden:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.rdv_tabBarController setTabBarHidden: YES];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
    [self.view addSubview:_navigationBar];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastpage) forControlEvents:UIControlEventTouchUpInside];
    
    _tutoriumInfoView = [[TutoriumInfoView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64-TabBar_Height)];
    [self .view addSubview:_tutoriumInfoView];
    
    /* 购买bar*/
    
        _buyBar= [[BuyBar alloc]initWithFrame:CGRectMake(0, self.view.height_sd-49, self.view.width_sd, 49)];
    
        [self.view addSubview:_buyBar];
        
    
    
    _tutoriumInfoView.scrollView.delegate = self;
    _tutoriumInfoView.classesListTableView.scrollEnabled =YES;
    
    _tutoriumInfoView.segmentControl.selectionIndicatorHeight=2;
    _tutoriumInfoView.segmentControl.selectedSegmentIndex=0;
    
    
    typeof(self) __weak weakSelf = self;
    [ _tutoriumInfoView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.tutoriumInfoView.scrollView scrollRectToVisible:CGRectMake(self.view.width_sd * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-64-49) animated:YES];
    }];
    
    self.tutoriumInfoView.scrollView.delegate = self;
    self.tutoriumInfoView.scrollView.bounces=NO;
    self.tutoriumInfoView.scrollView.alwaysBounceVertical=NO;
    self.tutoriumInfoView.scrollView.alwaysBounceHorizontal=NO;
    
    [  self.tutoriumInfoView.scrollView scrollRectToVisible:CGRectMake(0, 0, self.view.width_sd, self.view.height_sd) animated:YES];
    
    _tutoriumInfoView.classesListTableView.delegate = self;
    _tutoriumInfoView.classesListTableView.dataSource = self;
    
    _tutoriumInfoView.classesListTableView.bounces = YES;
    
    
    /* 根据传递过来的id 进行网络请求model*/
    /* 初始化三个model*/
    _classModel = [[RecommandClasses alloc]init];
    _teacherModel = [[RecommandTeacher alloc]init];
    _classInfoTimeModel = [[ClassesInfo_Time alloc]init];
    
    _classListArray = @[].mutableCopy;
    
    [self requestClassesInfoWith:_classID];
    
    
    [self loadingHUDStopLoadingWithTitle:@"加载完成!"];
    
    /* 注册重新加载页面数据的通知*/
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPage) name:@"RefreshTutoriumInfo" object:nil];

    
}



/* 根据初始化传值进来的id 进行网络请求*/
- (void)requestClassesInfoWith:(NSString *)classid{
    
    [self loadingHUDStartLoadingWithTitle:@"正在加载信息"];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_remember_token forHTTPHeaderField:@"Remember-Token"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses/%@",Request_Header,classid] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        /* 拿到数据字典*/
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"%@",dic);
        
        
        NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
        
        _dataDic=[NSMutableDictionary dictionaryWithDictionary:dic[@"data"]];
        
        /* 课程页面信息赋值*/
        _tutoriumInfoView.className.text = _dataDic[@"name"];
        [_tutoriumInfoView.classImage sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"publicize"]] placeholderImage:[UIImage imageNamed:@"school"]];
        _tutoriumInfoView.saleNumber.text = [NSString stringWithFormat:@"%@", _dataDic[@"buy_tickets_count"]];
        _tutoriumInfoView.priceLabel.text = [NSString stringWithFormat:@"¥%@",_dataDic[@"price"]];
        
        if ([_dataDic[@"status"]isEqualToString:@"teaching"]||[_dataDic[@"status"]isEqualToString:@"pause"]||[_dataDic[@"status"]isEqualToString:@"closed"]) {
            _tutoriumInfoView.recuitState.text = @"已开课";
            _tutoriumInfoView.deadLine.text = [NSString stringWithFormat:@"[进度%@/%@]",_dataDic[@"completed_lesson_count"],_dataDic[@"lesson_count"]];
            _tutoriumInfoView.onlineVideoLabel.text =@"已开课";
            
        }else if ([_dataDic[@"status"]isEqualToString:@"missed"]||[_dataDic[@"status"]isEqualToString:@"init"]||[_dataDic[@"status"]isEqualToString:@"ready"]){
            _tutoriumInfoView.recuitState.text = @"未开课";
            _tutoriumInfoView.onlineVideoLabel.text =@"未开课";
            
            _tutoriumInfoView.deadLine.text = [NSString stringWithFormat:@"[距开课%@/天]",[self intervalSinceNow:_dataDic[@"live_start_time"] ]];
            
            
        }else if ([_dataDic[@"status"]isEqualToString:@"finished"]||[_dataDic[@"status"]isEqualToString:@"billing"]||[_dataDic[@"status"]isEqualToString:@"competed"]){
            
            _tutoriumInfoView.recuitState.text = @"已结课";
            _tutoriumInfoView.onlineVideoLabel.text =@"已结课";
            
        }
        
        _tutoriumInfoView.liveStartTimeLabel.text = _dataDic[@"live_start_time"];
        _tutoriumInfoView.liveEndTimeLabel.text = _dataDic[@"live_end_time"];
        
        
        
        if ([status isEqualToString:@"0"]) {
            /* 获取token错误  需要重新登录*/
        }else{
            
            /* 判断课程状态*/
            
            [self switchClassData:_dataDic];
            
            /* 手动解析teacherModel*/
            NSDictionary *teacherDic =_dataDic[@"teacher"];
            NSLog(@"%@",teacherDic);
            
            /* teacherModel赋值与界面数据更新*/
            
            _teacherModel.teacherID = [teacherDic valueForKey:@"id"];
            _teacherModel.teacherName =[teacherDic valueForKey:@"name"];
            _teacherModel.school =[teacherDic valueForKey:@"school"];
            _teacherModel.subject = [teacherDic valueForKey:@"subject"];
            _teacherModel.teaching_years =[teacherDic valueForKey:@"teaching_years"];
            _teacherModel.describe =[teacherDic valueForKey:@"desc"];
            
            /* 判断性别是否为空对象    预留性别判断接口*/
            if ([teacherDic valueForKey:@"gender"]!=[NSNull null]) {
                
                if ([_teacherModel.gender isEqualToString:@"male"]) {
                    
                    
                }if ([_teacherModel.gender isEqualToString:@"female"]){
                    
                }
                _teacherModel.gender = [teacherDic valueForKey:@"gender"];
                
            }else{
                
                 _teacherModel.gender = @"";
            }
            
            
            NSLog(@"%@,%@,%@,%@,%@,%@,%@", _teacherModel .teacherID, _teacherModel.teacherName,_teacherModel.school , _teacherModel.subject, _teacherModel.teaching_years , _teacherModel.describe,_teacherModel.gender);
            
            
            [_tutoriumInfoView.teacherNameLabel setText: _teacherModel.teacherName];
            [_tutoriumInfoView.workPlaceLabel setText:[NSString stringWithFormat:@"%@",_teacherModel.school]];
            [_tutoriumInfoView.teacherInterviewLabel setText:[NSString stringWithFormat:@"%@",_teacherModel.describe]];
            [_tutoriumInfoView.classImage sd_setImageWithURL:[NSURL URLWithString:_teacherModel.avatar_url] placeholderImage:[UIImage imageNamed:@"school"]];
            [_tutoriumInfoView.teacherHeadImage sd_setImageWithURL:[NSURL URLWithString:_teacherModel.avatar_url ]];
            
            /* 判断教学年限*/
           
            [_tutoriumInfoView.workYearsLabel setText:@"10-20年"];
            
            
            /* 手动解析classModel*/
            
            _classModel = [RecommandClasses yy_modelWithDictionary:_dataDic];
            _classModel.classID = _dataDic[@"id"];
            _classModel.describe = _dataDic[@"description"];
            

            
            /* 课程页面的label赋值*/
            [_tutoriumInfoView.subjectLabel setText:_classModel.subject];
            [_tutoriumInfoView.gradeLabel setText:_classModel.grade];
            [_tutoriumInfoView.classCount setText:_classModel.lesson_count];
            
            [_tutoriumInfoView.classDescriptionLabel setText:_classModel.describe];
            
            
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}




#pragma mark- 判断课程状态
- (void)switchClassData:(NSDictionary *)data{
    /* 先判断is_tasting / is_bought / tasted 的状态*/
    
    if ([_dataDic[@"is_bought"]boolValue]==NO) {
        
        /* 还没购买的情况下*/
        if ([_dataDic[@"is_tasting"]boolValue]==YES) {
            /* 如果已经加入试听*/
            if ([_dataDic[@"tasted"]boolValue]==NO) {
                /* 还没有试听*/
                [_buyBar.listenButton setTitle:@"进入试听" forState:UIControlStateNormal];
                [_buyBar.listenButton setBackgroundColor:BUTTONRED];
                [_buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                if (![data[@"status"] isEqualToString:@"finished"]&&![data[@"status"] isEqualToString:@"competed"]){
                    
                    [_buyBar.listenButton addTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
                    
                }else{
                    /* 课程已结束*/
                    [_buyBar.listenButton addTarget:self action:@selector(addClosedListen) forControlEvents:UIControlEventTouchUpInside];
                    
                }

                
                
            }else{
                /* 已经试听了*/
                [_buyBar.listenButton setTitle:@"试听结束" forState:UIControlStateNormal];
                [_buyBar.listenButton setBackgroundColor:[UIColor colorWithRed:0.84 green:0.47 blue:0.44 alpha:1.0]];
                
                _buyBar.listenButton.enabled = NO;
                
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
        _buyBar.listenButton.sd_layout
        .leftSpaceToView(_buyBar,10)
        .topSpaceToView(_buyBar,10)
        .bottomSpaceToView(_buyBar,10)
        .rightSpaceToView(_buyBar,10);
        
        [_buyBar.listenButton setTitle:@"开始学习" forState:UIControlStateNormal];
        _buyBar.listenButton.backgroundColor = BUTTONRED;
        [_buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_buyBar.listenButton addTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    
    
}

#pragma mark- 加入到已关闭的试听
- (void)addClosedListen{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该课程已结束,是否继续试听?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }] ;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self addListen];
        
    }] ;
    
    [alert addAction:cancel];
    [alert addAction:sure];
    
    [self presentViewController:alert animated:YES completion:nil];

    
}



#pragma mark- 加入试听
- (void)addListen{
    
    [self loadingHUDStartLoadingWithTitle:@"正在加入试听"];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_remember_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses/%@/taste",Request_Header,_dataDic[@"id"]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 请求成功*/
            
            [_buyBar.listenButton removeTarget:self action:@selector(addListen) forControlEvents:UIControlEventTouchUpInside];
            
            [_buyBar.listenButton setTitle:@"进入试听" forState:UIControlStateNormal];
            [_buyBar.listenButton setBackgroundColor:BUTTONRED];
            [_buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

            
            [_buyBar.listenButton addTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
            
            [self loadingHUDStopLoadingWithTitle:@"加入成功"];
            
            
            /* 发送全局通知,发送加入试听课程通知*/
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AddNewClass" object:_dataDic];
            
            
        }else{
            
            /* 重新登录*/
            
            [self loginAgain];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

    
}

#pragma mark- 立即试听
- (void)listen{
     
    NELivePlayerViewController *neVC = [[NELivePlayerViewController alloc]initWithClassID:_dataDic[@"id"]];
    
            [self.navigationController pushViewController:neVC animated:YES];
    
}


#pragma mark- 立即报名的 购买课程方法
- (void)buyClass{
    
    if (_dataDic) {
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

        }
        
    }
    
    
}

#pragma mark- 收集订单信息,并传入下一页,开始提交订单
- (void)requestOrder{
    
    OrderViewController *orderVC = [[OrderViewController alloc]initWithClassID:_dataDic[@"id"]];
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


#pragma mark- tabelView的代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    NSInteger rows=0;
    
    if (_classListArray.count ==0) {
        rows =0;
    }else{
        
        
        rows =_classListArray.count;
    }
    
    return rows;
    
}

/* 自适应高度计算*/
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    ClassesListTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[ClassesListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
                /* 教师课程安排的数据  如果为0的情况 。。。。预留判断*/
        if (_classListArray.count==0) {
            
            
        }else{

            ClassesInfo_Time *mod = _classListArray[indexPath.row];
            cell.model = mod;
            
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        }
        
    }

    
    return  cell;
    
}

/* 刷新页面*/
- (void)refreshPage{
    
    [self requestClassesInfoWith:_classID];
    
    
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


#pragma mark- 根据课程详细内容 ,scrollview 的content 自适应高度
- (void)autoScrollHeight{
    
    [_tutoriumInfoView.classDescriptionLabel updateLayout];
    [_tutoriumInfoView.teacherInterviewLabel updateLayout];
    
    NSLog(@"%@",[_tutoriumInfoView.classDescriptionLabel valueForKey:@"frame"]);
    NSLog(@"%@",[_tutoriumInfoView.teacherInterviewLabel valueForKey:@"frame"]);

    
    CGFloat classDesc_height = _tutoriumInfoView.classDescriptionLabel.frame.origin.y+_tutoriumInfoView.classDescriptionLabel.frame.size.height;
    
    CGFloat teacherDesc_height =  _tutoriumInfoView.teacherInterviewLabel.frame.origin.y+_tutoriumInfoView.teacherInterviewLabel.frame.size.height;
    
    
    if (classDesc_height>teacherDesc_height) {
        
        [_tutoriumInfoView setContentSize:CGSizeMake(self.view.width_sd, classDesc_height+40+TabBar_Height)];
    }else {
         [_tutoriumInfoView setContentSize:CGSizeMake(self.view.width_sd, teacherDesc_height+40+TabBar_Height)];
        
    }
    
    
     _tutoriumInfoView.classesListTableView.sd_resetLayout
    .leftSpaceToView(_tutoriumInfoView.view3,0)
    .rightSpaceToView(_tutoriumInfoView.view3,0)
    .topSpaceToView(_tutoriumInfoView.view3,0)
    .heightIs(_tutoriumInfoView.contentSize.height);
    
    
}



- (void)returnLastpage{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.rdv_tabBarController.tabBar setHidden:NO];
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
