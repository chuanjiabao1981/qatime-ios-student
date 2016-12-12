//
//  TutoriumViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "TutoriumViewController.h"
#import "TutoriumCollectionViewCell.h"
#import "MJRefresh.h"
#import "TutoriumList.h"
#import "YYModel.h"
#import "UIImageView+WebCache.h"
#import "RDVTabBarController.h"
#import "NSString+UTF8Coding.h"
#import "HcdDateTimePickerView.h"
//#import "MBProgressHUD.h"
#import "UIViewController_HUD.h"

#import "TutoriumInfoViewController.h"

@interface TutoriumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>{
    
    /* 筛选条件的字段*/
    /* 筛选年级*/
    NSString *_filterGrade;
    
    /* 筛选科目*/
    NSString *_filterSubject;
    /* 数据请求类型*/
    /* 0 为全部请求， 1 为筛选类型请求*/
    NSInteger filterStatus;
    /* 多项筛选*/
    
    /* 价格开始区间*/
    NSString *_price_floor;
    /* 价格结束区间*/
    NSString *_price_ceil;
    
    /* 开课日期结束  开始日期*/
    NSString *_class_date_floor;
    
    /*开课日期结束  结束日期*/
    NSString *_class_date_ceil;
    
    /* 课时总数开始区间*/
    
    NSString *_preset_lesson_count_floor;
    
    /* 课时总数结束区间*/
    
    NSString *_preset_lesson_count_ceil;
    
    
    /* 辅导班状态*/
    NSString *_class_status;
    
    /* 排序筛选*/
    NSString *sort_By;
    
    
    /* 日期选择器*/
    
    HcdDateTimePickerView *_datePicker;
    
    
    
    /* 保存筛选数据的字典*/
    NSMutableDictionary *_filterDic;
    /* 保存筛选字符串*/
    NSString *_requestUrl;
    NSString *_requestResaultURL;
    /* 临时保存筛选key的数组*/
    NSMutableArray *_filterArr;
    
    
    
    /* 返回页码*/
    NSInteger page;
    
    /* 返回每页的条目*/
    NSInteger per_Page;
    
    
    /* 数据model*/
    TutoriumList *_tutroiumList;
    
    /* 保存缓存数据的数组*/
    NSMutableArray <TutoriumList *> *listArr;
    
    /* 保存页面缓存的字典*/
    NSDictionary *listDic;
    
    
    
    /* 本地取出保存的缓存数据状态*/
    NSDictionary *savedDic;
    NSArray *list;
    TutoriumList *listInfo;
    TutoriumListInfo *infoModel;
    
    
    /* 本地沙盒缓存路径*/
    NSString *_tutoriumListFilePath;
    
    
    
    /* 筛选功能*/
    UIPickerView *_timePickerView;
    UIPickerView *_gradePickerView;
    UIPickerView *_subjectPickerView;
    NSMutableArray *_gradeFilterArr;
    NSArray *_subjectArr;
    
    
    /* pickerview的标题*/
    NSArray *_timeFilterStr;
    
    
    
    /* 模糊背景*/
    UIVisualEffectView *effectView;
    
    
    /* token*/
    NSString *_remember_token;
    
    
    
    /* 下拉还是上滑   0为下拉重载  1为上滑刷新*/
    
    NSInteger pull;
    

    
    
}
@end

@implementation TutoriumViewController


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
    
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

//    [self.rdv_tabBarController setTabBarHidden:NO];
    
    [self loadingHUDStartLoadingWithTitle:@"正在加载"];
    
    /* 取出token*/
    _remember_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"];
    
    
    /* 字段初始化*/
    _filterGrade = [NSString string];
    _filterSubject = [NSString string];
    
    sort_By = [NSString string];
    
    /* 多选字段初始化*/
    _price_floor =[NSString string];
    _price_ceil = [NSString string];
    _class_date_floor =[NSString string];
    _class_date_ceil =[NSString string];
    _preset_lesson_count_floor =[NSString string];
    _preset_lesson_count_ceil =[NSString string];
    _class_status =[NSString string];
    
    /* 筛选请求接口初始化字段*/
    
    _requestUrl =[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses?"];
    
    
    _filterDic = [NSMutableDictionary dictionaryWithObjects:@[_filterGrade,_filterSubject, sort_By,_price_floor,_price_ceil,_class_date_floor,_class_date_ceil,_preset_lesson_count_floor,_preset_lesson_count_ceil,_class_status] forKeys:@[@"grade",@"subject",@"sort_by",@"price_floor",@"price_ceil",@"class_date_floor",@"class_date_ceil",@"preset_lesson_count_floor",@"preset_lesson_count_ceil",@"status"]];
    
    
    
    
        
    if ([[NSFileManager defaultManager]fileExistsAtPath:_tutoriumListFilePath]) {
        
        NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:_tutoriumListFilePath]];
        page  = [[dic valueForKey:@"page"]integerValue ];
        NSLog(@"%ld",page);
        
    }else{
        
        page = 1;
    }
        per_Page = 10;
        listArr= [[NSMutableArray alloc]init];
        infoModel = [[TutoriumListInfo alloc]init];
        
        /* 本地缓存的沙盒路径*/
        _tutoriumListFilePath=[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Tutorium_List"];
        
        
#pragma mark- 筛选条件状态存储
      
        //    [self saveFilterStatus:_filterDic];
        
        _requestResaultURL = [NSString string];
        _filterArr = [NSMutableArray array];
        
        [[NSFileManager defaultManager]removeItemAtPath:_tutoriumListFilePath error:nil];
#pragma mark- 接受数据加载完成的消息
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData:) name:@"DataLoaded" object:nil];
#pragma mark- 加载model数据
    
    /* 在初始化阶段 如果用户在首页选择了科目*/
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"SubjectChosen"]);
    
    if (!([[NSUserDefaults standardUserDefaults]objectForKey:@"SubjectChosen"]== NULL)) {
        
        /* 初次请求数据 ，请求课程列表的所有数据 */
       
        NSString *sub =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"SubjectChosen"]];
        
        
        
        [_filterDic setValue:sub forKey:@"subject"];
        
        
        
        [self sendFilterStatus:_filterDic];
        
        [_tutoriumView.subjectButton setTitle:sub forState:UIControlStateNormal];
        
    }else{
    
    
        /* 如果本地存在缓存数据*/
        if ([[NSFileManager defaultManager]fileExistsAtPath:_tutoriumListFilePath]){
            
            savedDic=[NSDictionary dictionaryWithDictionary: [NSKeyedUnarchiver unarchiveObjectWithFile:_tutoriumListFilePath]];
            
        }else{
            
            /* 初次请求数据 ，请求课程列表的所有数据 */
            [self requestDataWithGrade:@"" andSubject:@"" andPage:page andPerPage:per_Page withPull:0];
            
        }
    }
    
#pragma mark- 加载年级信息
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager GET:@"http://testing.qatime.cn/api/v1/app_constant/grades" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSArray * grade = [[NSArray alloc]initWithArray:[[[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil] valueForKey:@"data"]valueForKey:@"grades"]];
            
            /* 年级信息归档*/
            [[NSUserDefaults standardUserDefaults]setObject:grade forKey:@"grade"];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    
    
    
#pragma mark- 导航栏
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.titleLabel setText:@"辅导班"];
//    _navigationBar.backgroundColor = [UIColor colorWithRed:190/255.0f green:11/255.0f blue:11/255.0f alpha:1.0f];
    
    
    _tutoriumView = [[TutoriumView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64-49)];
    [self .view addSubview:_tutoriumView];
    
    /* 瀑布流视图的代理*/
    _tutoriumView.classesCollectionView.delegate = self;
    _tutoriumView.classesCollectionView.dataSource = self;
    
    
    /* 瀑布流展示注册*/
    /* collectionView 注册cell、headerID、footerId*/
    [_tutoriumView.classesCollectionView registerClass:[TutoriumCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    
#pragma mark- collection 下拉加载  上滑刷新
    /* collection下拉加载  上滑刷新*/
    
    /* 下拉的block*/
    _tutoriumView.classesCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        /* 在有筛选条件的情况下 进行下拉数据的重载*/
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"FilterURL"]) {
            
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"FilterURL"]);
            
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager.requestSerializer setValue:_remember_token forHTTPHeaderField:@"Remember-Token"];
            [manager GET:[[NSUserDefaults standardUserDefaults]objectForKey:@"FilterURL"] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                /* 先判断token*/
                if (![self isTokenRight:responseObject]) {
                    
                    /* 需要重新登录*/
                    [self needUpdateToken];
                    
                }else{

                    
                
                listDic =@{};
                [listArr removeAllObjects];
                
                /* 使用YYModel解析创建model  get回来的数据是个数组内含字典 引入tag值来确定数组下标*/
                _tutroiumList = [TutoriumList yy_modelWithJSON:responseObject];
                
                
                NSLog(@"%@,%@",_tutroiumList.status,_tutroiumList.data);
                
                
                
                /* 缓存数据源添加获取的Model*/
                [listArr addObject:_tutroiumList];
                
                NSLog(@"%@",listArr[0].data);
                NSLog(@"%ld",listArr.count);
                
                listDic = @{@"page":@"1",
                            @"per_page":@"1",
                            @"filterGrade":@"",
                            @"filterSubject":@"",
                            @"filterStatus":@"1",
                            @"listArr":listArr
                            };
                
                /* 测试代码*/
                TutoriumList *tu =[[TutoriumList alloc]init];
                tu = listDic[@"listArr"];
                
                //        NSLog(@"%@",tu.tutoriumListInfo);
                
                /* 获取到的数据缓存到本地*/
                /* 保存的数据中含有自定义对象，保存到沙盒*/
                [NSKeyedArchiver archiveRootObject:listDic toFile:_tutoriumListFilePath];
                
                /* 本地状态变化*/
                //        savedDic =[NSDictionary dictionaryWithDictionary: listDic];
                
                
                
                /* 加载数据完成后  视图重新加载数据*/
                [[NSNotificationCenter defaultCenter]postNotificationName:@"DataLoaded" object:nil];
                
                [self loadData:nil];
                
                NSLog(@"加载数据完成。");
                }
                
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            
            
            
        }else{
            
            
            /* 在没有筛选数据的情况，进行下拉加载*/
            NSDictionary *dic=[NSDictionary dictionaryWithDictionary: [NSKeyedUnarchiver unarchiveObjectWithFile:_tutoriumListFilePath]];
            
            NSLog(@"%@",dic);
            NSLog(@"%ld",page);
            
            [self requestDataWithGrade:dic[@"filterGrade"] andSubject:dic[@"filterSubject"] andPage:[[dic  valueForKey:@"page"]integerValue]  andPerPage:per_Page withPull:0];
            
        }
        [_tutoriumView.classesCollectionView.mj_header endRefreshing];
        
    }];
    
    /* 上滑的block*/
    _tutoriumView.classesCollectionView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [_tutoriumView.classesCollectionView.mj_footer endRefreshing];
        
        page ++;
        
        NSLog(@"%ld",page);
        
        /* 上滑 请求更多数据*/
        [self requestDataWithGrade:_filterGrade andSubject:_filterSubject andPage:page andPerPage:per_Page withPull:1];
        
        
    }];
    
    
    
#pragma mark- 筛选功能
    
    /* 按时间、价格选择*/
    [_tutoriumView.timeButton addTarget:self action:@selector(sortByTimeAndPrice) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 按年级筛选*/
    [_tutoriumView .gradeButton addTarget:self action:@selector(sortByGrade) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 按科目筛选*/
    [_tutoriumView.subjectButton addTarget:self action:@selector(sortBySubject) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    /* 多项筛选*/
    [_tutoriumView.filtersButton addTarget:self action:@selector(sortByMulti) forControlEvents:UIControlEventTouchUpInside];
    _multiFilterView = [[MultiFilterView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)*2/5.0f)];
    
    /* 多项筛选按钮和文本框功能实现*/
    /* 重置按钮功能实现*/
    [_multiFilterView.resetButton addTarget:self action:@selector(resetMultiFilter) forControlEvents:UIControlEventTouchUpInside];
    /* 确定按钮功能实现*/
    [_multiFilterView.finishButton addTarget:self action:@selector(finishMultiFilter) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 日期选择 的左右两个按钮 点出来日期选择器*/
    _multiFilterView.startTime.tag =1;
    _multiFilterView.endTime.tag =2;
    [_multiFilterView.startTime addTarget:self action:@selector(choseClassTime:) forControlEvents:UIControlEventTouchUpInside];
    [_multiFilterView.endTime addTarget:self action:@selector(choseClassTime:) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 已开课和招生中 两个按钮的点击事件*/
    _multiFilterView.class_Begin.tag=3;
    _multiFilterView.class_Begin.selected = NO;
    [_multiFilterView.class_Begin addTarget:self action:@selector(choseClassStatus:) forControlEvents:UIControlEventTouchUpInside];
    _multiFilterView.recuit.tag=4;
    _multiFilterView.recuit.selected = NO;
    [_multiFilterView.recuit addTarget:self action:@selector(choseClassStatus:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    //增加监听，当键盘出现或改变时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
     
                                               object:nil];
    
    
    
    //增加监听，当键退出时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];
    
    
    
    /* 初始化完成后 用户选择科目后的跳转情况*/
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userSelectedSubject:) name:@"UserChoseSubject" object:nil];
    
    
    
    
}




/* 界面加载完成后用户再次筛选后的 消息方法*/
- (void)userSelectedSubject:(NSNotification *)notification{
    
    NSString *subj =[NSString stringWithFormat:@"%@",[notification object]];
    
    
    
    [_filterDic setValue:subj forKey:@"subject"];
    [self sendFilterStatus:_filterDic];
    
    [_tutoriumView.subjectButton setTitle:subj forState:UIControlStateNormal];
    
    
    
    
}





#pragma mark- 选择招生和开课状态按钮点击事件
- (void)choseClassStatus:(UIButton *)sender{
    
    if (sender.selected==NO) {
        [sender setBackgroundColor:[UIColor lightGrayColor]];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sender.selected = YES;
        
        
        
    }else{
        
        [sender setBackgroundColor:[UIColor clearColor]];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        sender.selected = NO;
    }
    
    
    
    
    
    
}



#pragma mark- 选择课程开始结束日期时间
- (void)choseClassTime:(UIButton *)sender{
    
    
    [_multiFilterView.lowPrice resignFirstResponder];
    [_multiFilterView.highPrice resignFirstResponder];
//    [_multiFilterView.class_Low resignFirstResponder];
//    [_multiFilterView.class_High resignFirstResponder];
    
    
    __block MultiFilterView *weakView = _multiFilterView;
    
    switch (sender.tag) {
        case 1:
            
            _datePicker = [[HcdDateTimePickerView alloc]initWithDatePickerMode:DatePickerDateMode defaultDateTime:[NSDate date]];
            [_datePicker setMinYear:2014];
            [_datePicker setMaxYear:2018];
            [_datePicker showHcdDateTimePicker];
            _datePicker .clickedOkBtn =  ^(NSString * datetimeStr){
                NSLog(@"%@", datetimeStr);
                [weakView.startTime  setTitle:datetimeStr forState:UIControlStateNormal ];;
            };
            
            
            break;
            
        case 2:
            
            _datePicker = [[HcdDateTimePickerView alloc]initWithDatePickerMode:DatePickerDateMode defaultDateTime:[NSDate date]];
            [_datePicker setMinYear:2014];
            [_datePicker setMaxYear:2018];
            [_datePicker showHcdDateTimePicker];
            _datePicker .clickedOkBtn =  ^(NSString * datetimeStr){
                NSLog(@"%@", datetimeStr);
                [weakView.endTime  setTitle:datetimeStr forState:UIControlStateNormal ];;
            };
            
            
            
        default:
            break;
    }
    if (_datePicker) {
        [self.view addSubview:_datePicker];
        [_datePicker showHcdDateTimePicker];
    }
    
    
    
    
}



#pragma mark- 确定多项选择
- (void)finishMultiFilter{
    
    /* 筛选条件变量赋值*/
    _price_floor =_multiFilterView.lowPrice.text;
    _price_ceil =_multiFilterView.highPrice.text;
    _class_date_floor =_multiFilterView.startTime.titleLabel.text;
    
    _class_date_ceil =_multiFilterView.endTime.titleLabel.text;
    
//    _preset_lesson_count_floor =_multiFilterView.class_Low.text;
//    
//    _preset_lesson_count_ceil =_multiFilterView.class_High.text;
    [_filterDic setValue:_multiFilterView.lowPrice.text forKey:@"price_floor"];
    [_filterDic setValue:_multiFilterView.highPrice.text  forKey:@"price_ceil"];
    [_filterDic setValue:_multiFilterView.startTime.titleLabel.text  forKey:@"class_date_floor"];
    
    [_filterDic setValue:_multiFilterView.endTime.titleLabel.text  forKey:@"class_date_ceil"];
//    [_filterDic setValue:_multiFilterView.class_Low.text forKey:@"preset_lesson_count_floor"];
//    [_filterDic setValue:_multiFilterView.class_High.text forKey:@"preset_lesson_count_ceil"];
    
    if ([_multiFilterView.class_Begin isSelected]&&[_multiFilterView.recuit isSelected]) {
        
        [_filterDic setValue:@"all" forKey:@"status"];
        
    }
    if (![_multiFilterView.class_Begin isSelected]&&[_multiFilterView.recuit isSelected]) {
        [_filterDic setValue:@"preview" forKey:@"status"];
        
    }
    if ([_multiFilterView.class_Begin isSelected]&&![_multiFilterView.recuit isSelected]) {
        [_filterDic setValue:@"teaching" forKey:@"status"];
    }
    if (![_multiFilterView.class_Begin isSelected]&&![_multiFilterView.recuit isSelected]) {
        
        [_filterDic setValue:@"" forKey:@"status"];
        
    }
    
    
    NSLog(@"%@",_filterDic);
    
    [self sendFilterStatus:_filterDic];
    
    [self textfileRespond];
    [effectView removeFromSuperview];
    [_multiFilterView removeFromSuperview];
    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
    
    
    
}


#pragma mark- 重置多项选择界面
- (void)resetMultiFilter{
    
    [self textfileRespond];
    
    [_multiFilterView.startTime setTitle:@"请选择时间" forState:UIControlStateNormal];
    [_multiFilterView.endTime setTitle:@"请选择时间" forState:UIControlStateNormal];
    
    [_multiFilterView.class_Begin setSelected:NO];
    [_multiFilterView.class_Begin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _multiFilterView.class_Begin.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [_multiFilterView.class_Begin setBackgroundColor:[UIColor clearColor]];
    
    
    [_multiFilterView.recuit setSelected:NO];
    [_multiFilterView.recuit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _multiFilterView.recuit.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [_multiFilterView.recuit setBackgroundColor:[UIColor clearColor]];
    
    
    
}
/* 文本框情况，取消响应*/
- (void)textfileRespond{
    
    [_multiFilterView.lowPrice resignFirstResponder];
    [_multiFilterView.lowPrice setText:@""];
    [_multiFilterView.highPrice resignFirstResponder];
    [_multiFilterView.highPrice setText:@""];
//    [_multiFilterView.class_Low resignFirstResponder];
//    [_multiFilterView.class_Low setText:@""];
//    [_multiFilterView.class_High resignFirstResponder];
//    [_multiFilterView.class_High setText:@""];
    
}



#pragma mark- 多条件筛选视图弹出和取消
- (void)sortByMulti{
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
    UIBlurEffect *effect=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    effectView=[[UIVisualEffectView alloc]initWithFrame:self.view.bounds];
    [effectView setEffect:effect];
    [self.view addSubview:effectView];
    
    [self.view addSubview:_multiFilterView];
    [UIView animateWithDuration:0.3 animations:^{
        
        [_multiFilterView setFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)*3/5.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)*2/5.0f)];
    }];
    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
    
    [self textfileRespond];
    
    [effectView removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [_multiFilterView setFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)*2/5.0f)];
    }];
}



#pragma mark- 按时间、价格筛选按钮点击事件
- (void)sortByTimeAndPrice{
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
    _timePickerView=[[UIPickerView alloc]init];
    _timePickerView.delegate = self;
    _timePickerView.dataSource = self;
    _timePickerView.backgroundColor = [UIColor whiteColor];
    
    
    _timeFilterStr  =@[@"按时间",@"按价格-低到高",@"按价格-高到低",@"按购买人数"];
    /* 顶视图*/
    UIView *barView=[[UIView alloc]init];
    [barView setBackgroundColor:[UIColor redColor]];
    /* 确认按钮*/
    UIButton *yedButton = [[UIButton alloc]init];
    
    [yedButton setTitle:@"确定" forState:UIControlStateNormal];
    [yedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBlurEffect *effect=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    effectView=[[UIVisualEffectView alloc]initWithFrame:self.view.bounds];
    [effectView setEffect:effect];
    [self.view addSubview:effectView];
    
    /* 点击确定按钮  原按钮字符变化，并发筛选请求数据*/
    [yedButton addTarget: self action:@selector(selectedTimeFilter:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [effectView addSubview:_timePickerView];
    _timePickerView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).heightRatioToView(self.view,0.25f);
    [effectView addSubview:barView];
    
    
    
    barView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(_timePickerView,0).heightRatioToView(_timePickerView,0.2f);
    [barView addSubview:yedButton];
    yedButton.sd_layout.rightSpaceToView(barView,5).topSpaceToView(barView,0).bottomSpaceToView(barView,0).widthRatioToView(barView,0.25);
    
    
    
}


#pragma mark- 按年级筛选
- (void)sortByGrade{
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
    _gradePickerView=[[UIPickerView alloc]init];
    _gradePickerView.delegate = self;
    _gradePickerView.dataSource = self;
    _gradePickerView.backgroundColor = [UIColor whiteColor];
    
    
    _gradeFilterArr =  [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"grade"]];
    
    [_gradeFilterArr insertObject:@"全部年级" atIndex:0];
    
    /* 顶视图*/
    UIView *barView=[[UIView alloc]init];
    [barView setBackgroundColor:[UIColor redColor]];
    /* 确认按钮*/
    UIButton *yedButton = [[UIButton alloc]init];
    
    [yedButton setTitle:@"确定" forState:UIControlStateNormal];
    [yedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBlurEffect *effect=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    effectView=[[UIVisualEffectView alloc]initWithFrame:self.view.bounds];
    [effectView setEffect:effect];
    [self.view addSubview:effectView];
    
    /* 点击确定按钮  原按钮字符变化，并发筛选请求数据*/
    [yedButton addTarget: self action:@selector(selectedGradeFilter:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [effectView addSubview:_gradePickerView];
    _gradePickerView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).heightRatioToView(self.view,0.25f);
    [effectView addSubview:barView];
    
    
    
    barView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(_gradePickerView,0).heightRatioToView(_gradePickerView,0.2f);
    [barView addSubview:yedButton];
    yedButton.sd_layout.rightSpaceToView(barView,5).topSpaceToView(barView,0).bottomSpaceToView(barView,0).widthRatioToView(barView,0.25);
    
    
    
}

#pragma mark- 按科目筛选
- (void)sortBySubject{
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
    _subjectPickerView=[[UIPickerView alloc]init];
    _subjectPickerView.delegate = self;
    _subjectPickerView.dataSource = self;
    _subjectPickerView.backgroundColor = [UIColor whiteColor];
    
    
    _subjectArr=@[@"全部",@"语文",@"数学",@"英语",@"物理",@"化学",@"地理",@"政治",@"历史",@"科学",@"生物"];
    
    /* 顶视图*/
    UIView *barView=[[UIView alloc]init];
    [barView setBackgroundColor:[UIColor redColor]];
    /* 确认按钮*/
    UIButton *yedButton = [[UIButton alloc]init];
    
    [yedButton setTitle:@"确定" forState:UIControlStateNormal];
    [yedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBlurEffect *effect=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    effectView=[[UIVisualEffectView alloc]initWithFrame:self.view.bounds];
    [effectView setEffect:effect];
    [self.view addSubview:effectView];
    
    /* 点击确定按钮  原按钮字符变化，并发筛选请求数据*/
    [yedButton addTarget: self action:@selector(selectedSubjectFilter:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [effectView addSubview:_subjectPickerView];
    _subjectPickerView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).heightRatioToView(self.view,0.25f);
    [effectView addSubview:barView];
    
    
    
    barView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(_subjectPickerView,0).heightRatioToView(_subjectPickerView,0.2f);
    [barView addSubview:yedButton];
    yedButton.sd_layout.rightSpaceToView(barView,5).topSpaceToView(barView,0).bottomSpaceToView(barView,0).widthRatioToView(barView,0.25);
    
    
}







#pragma mark- pickerView的代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
    
}

/* pickerView的行数*/
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSInteger rows = 0;
    
    if (pickerView == _timePickerView) {
        
        rows =  4;
        
    }
    if (pickerView == _gradePickerView) {
        
        rows = _gradeFilterArr.count;
    }
    if (pickerView == _subjectPickerView) {
        rows = _subjectArr.count;
    }
    
    return rows;
}

/* 每个选项的title*/
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    NSString *rowsTitle = [NSString string];
    if (pickerView == _timePickerView) {
        rowsTitle =_timeFilterStr[row];
    }
    if (pickerView == _gradePickerView ) {
        rowsTitle = _gradeFilterArr[row];
    }
    if (pickerView == _subjectPickerView) {
        rowsTitle = _subjectArr[row];
    }
    
    
    return rowsTitle;
    
}

/* 选择后*/
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    /* 按时间价格*/
    if (pickerView == _timePickerView) {
        
        NSLog(@"%@",_timeFilterStr[row]);
        //    标题更改
        switch (row) {
            case 0:
                [_tutoriumView.timeButton setTitle:[NSString stringWithFormat:@"%@∨",_timeFilterStr[row]] forState:UIControlStateNormal];
                break;
            case 1:
                [_tutoriumView.timeButton setTitle:[NSString stringWithFormat:@"按价格↑"] forState:UIControlStateNormal];
                break;
            case 2:
                [_tutoriumView.timeButton setTitle:[NSString stringWithFormat:@"按价格↓"] forState:UIControlStateNormal];
                break;
            case 3:
                [_tutoriumView.timeButton setTitle:[NSString stringWithFormat:@"%@∨",_timeFilterStr[row]] forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
    }
    
    /* 按年级筛选*/
    if (pickerView == _gradePickerView ) {
        
        [_tutoriumView.gradeButton setTitle:[NSString stringWithFormat:@"%@",_gradeFilterArr[row]] forState:UIControlStateNormal];
        
        
    }
    
    /* 按科目筛选*/
    if (pickerView == _subjectPickerView) {
        [_tutoriumView.subjectButton setTitle:[NSString stringWithFormat:@"%@",_subjectArr[row]] forState:UIControlStateNormal];
    }
    
}

#pragma mark- 用户筛选完时间-价格条件后的点击事件
- (void)selectedTimeFilter:(UIButton *)sender{
    
    [effectView removeFromSuperview];
    
    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
    
    
    sort_By  = _tutoriumView.timeButton.titleLabel.text;
    
    if ([sort_By isEqualToString:@"按时间∨"]) {
        
        sort_By = @"created_at";
        
        
    }else if ([sort_By isEqualToString:@"按价格↑"]) {
        sort_By = @"price.asc";
        
    }else if ([sort_By isEqualToString:@"按价格↓"]){
        sort_By = @"price";
        
    }else if ( [sort_By isEqualToString:@"按购买人数"]){
        
        sort_By = @"buy_count";
    }
    
    
    [_filterDic setValue:sort_By forKey:@"sort_by"];
    
    
    
    /* 发送筛选请求*/
    [self sendFilterStatus:_filterDic];
    
    
    
    
    
}



#pragma mark- 用户筛选完年级条件后的点击事件
- (void)selectedGradeFilter:(UIButton *)sender{
    
    [effectView removeFromSuperview];
    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
    
    /* 获取当前年级信息 发送筛选*/
    _filterGrade = _tutoriumView.gradeButton.titleLabel.text;
    
    [_filterDic setValue:_filterGrade forKey:@"grade"];
    
    NSLog(@"%@",_filterDic);
    [self sendFilterStatus:_filterDic];
    
    
    
    
}



#pragma mark- 发送筛选请求
- (void)sendFilterStatus:(NSDictionary *)filterstatusDic{
    
    
    [self loadingHUDStartLoadingWithTitle:@"正在加载"];
    
    page = 0;
    
    /* url字符转换*/
    NSLog(@"%@",_filterDic);
    
    NSString *appendStr=[NSString string];
    appendStr = @"";
    
    
    /* 遍历筛选字典filterDic的key和value，得到正确筛选条件的dic*/
    /* 因遍历时不能对字典进行增删改，故复制出一份字典用作遍历*/
    
    NSMutableDictionary *filterDic_Copy = [NSMutableDictionary dictionaryWithDictionary:_filterDic];
    
    for (NSString *keys in filterDic_Copy) {
        
        if ( [[_filterDic valueForKey:keys]isEqualToString:@"按科目∨"]||[[_filterDic valueForKey:keys]isEqualToString:@"按年级∨"]||[[_filterDic valueForKey:keys]isEqualToString:@"按时间∨"]||[[_filterDic valueForKey:keys]isEqualToString:@"全部"]||[[_filterDic valueForKey:keys]isEqualToString:@"全部年级"]||[[_filterDic valueForKey:keys]isEqualToString:@"请选择时间"]) {
            
            
            NSLog(@"%@,%@",keys,[_filterDic valueForKey:keys]);
            
            [_filterDic setValue:@"" forKey:keys];
            
            
            
        }
        
    }
    
    
    /* 用遍历方式，写请求字符*/
    for (NSString *keys in _filterDic) {
        if (![[_filterDic valueForKey:keys]isEqualToString:@""]) {
            
            NSString *values=[NSString encodeString:[_filterDic valueForKey:keys]];
            NSLog(@"%@",values);
            
            appendStr = [appendStr stringByAppendingFormat:@"%@=%@&",keys,values];
            
            
        }
        
    }
    
    
    
    NSLog(@"%@",appendStr);
    
    _requestResaultURL =[_requestUrl stringByAppendingFormat:@"%@",appendStr];
    
    /* 得到最终筛选的结果地址url*/
    _requestResaultURL =[_requestResaultURL substringToIndex:[_requestResaultURL length]-1];
    
    
    /* 下拉刷新专用的存储状态*/
    [[NSUserDefaults standardUserDefaults]setObject:_requestResaultURL forKey:@"FilterURL"];
    
    
    
    
    NSLog(@"%@",_requestResaultURL);
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue:_remember_token forHTTPHeaderField:@"Remember-Token"];
    
    [manager GET:_requestResaultURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        listDic =@{};
        [listArr removeAllObjects];
        
        /* 使用YYModel解析创建model  get回来的数据是个数组内含字典 引入tag值来确定数组下标*/
        _tutroiumList = [TutoriumList yy_modelWithJSON:responseObject];
        
        
        
        
        NSLog(@"%@,%@",_tutroiumList.status,_tutroiumList.data);
        
        
        
        /* 缓存数据源添加获取的Model*/
        [listArr addObject:_tutroiumList];
        
        NSLog(@"%@",listArr[0].data);
        NSLog(@"%ld",listArr.count);
        
        listDic = @{@"page":@"1",
                    @"per_page":@"1",
                    @"filterGrade":@"",
                    @"filterSubject":@"",
                    @"filterStatus":@"1",
                    @"listArr":listArr
                    };
        
        /* 测试代码*/
        TutoriumList *tu =[[TutoriumList alloc]init];
        tu = listDic[@"listArr"];
        
        //        NSLog(@"%@",tu.tutoriumListInfo);
        
        /* 获取到的数据缓存到本地*/
        
        /* 保存的数据中含有自定义对象，保存到沙盒*/
        [NSKeyedArchiver archiveRootObject:listDic toFile:_tutoriumListFilePath];
        
        /* 本地状态变化*/
        //        savedDic =[NSDictionary dictionaryWithDictionary: listDic];
        
        
        
        /* 加载数据完成后  视图重新加载数据*/
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DataLoaded" object:nil];
        
        [self loadData:nil];
        
        NSLog(@"加载数据完成。");
        
        [self loadingHUDStopLoadingWithTitle:@"加载完成"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}



#pragma mark- 用户筛选完科目条件后的点击事件
- (void)selectedSubjectFilter:(UIButton *)sender{
    
    [effectView removeFromSuperview];
    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
    
    /* 获取当前科目筛选信息 发送筛选*/
    _filterSubject = _tutoriumView.subjectButton.titleLabel.text;
    
    [_filterDic setValue:_filterSubject forKey:@"subject"];
    
    NSLog(@"%@",_filterDic);
    [self sendFilterStatus:_filterDic];
    
    
}






#pragma mark- collection的代理方法
/* item数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSDictionary *dic =[NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:_tutoriumListFilePath]];
    
    TutoriumList *_list=[[TutoriumList alloc]init];
    _list = [dic valueForKey:@"listArr"][section];
    
    NSLog(@"%ld",_list.data.count);
    
    return _list.data.count;
    
}
/* item重用队列*/
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"CollectionCell";
    TutoriumCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    /* 直接本地保存的存储状态，然后解析并加载数据*/
    
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:_tutoriumListFilePath]) {
        
        
        NSLog(@"数据本地化存储完成");
        savedDic = [NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:_tutoriumListFilePath]];
        
        
        /* 手动 解析model第二层数据*/
        list=savedDic[@"listArr"];
        NSLog(@"%@",list);
        listInfo = list[indexPath.section];
        
        NSLog(@"%@",listInfo.data);
        
        infoModel = [TutoriumListInfo yy_modelWithDictionary:listInfo.data[indexPath.row]];
        infoModel.classID =[listInfo.data[indexPath.row]valueForKey:@"id"];
        
        
        NSLog(@"%@",infoModel.classID);
        
    }else{
        
        /* 如果本地没有保存的数据 ，重新发送请求*/
        [self requestDataWithGrade:@"" andSubject:@"" andPage:1 andPerPage:10 withPull:0];
        
        
    }
    
    /* 在解析正确的情况下*/
    if (listInfo) {
        
        /* cell按照model 加载图片*/
        
        /* 服务器后台没有数据，使用静态图片*/
        //    [cell.classImage sd_setImageWithURL:[NSURL URLWithString:infoModel.publicize]];
        [cell.classImage setImage:[UIImage imageNamed:@"school"]];
        
        
        /* cell按照开课时间  计算和加载距离开课日期*/
        //创建日期格式化对象
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        
        //创建了两个日期对象
        /* 视频开始时间*/
        NSDate *startDate=[dateFormatter dateFromString:infoModel.preview_time];
        
        /* 当前时间*/
        NSDate *nowDate=[NSDate date];
        //取两个日期对象的时间间隔：
        //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
        
        NSTimeInterval time=[nowDate timeIntervalSinceDate:startDate];
        
        int days=((int)time)/(3600*24);
        //    int hours=((int)time)%(3600*24)/3600;
        NSString *dateContent=[[NSString alloc] initWithFormat:@"距离开课%i天",days];
        
        
        /* cell 的距开始天数 赋值*/
        [cell.timeToStart setText:dateContent];
        
        /* cell 教师姓名 赋值*/
        [cell.teacherName setText:infoModel.teacher_name];
        
        /* cell 科目赋值*/
        
        [cell.subjectName setText:infoModel.subject];
        
        /* cell 年级赋值*/
        [cell.grade setText:infoModel.grade];
        
        /* cell 价格赋值*/
        [ cell.price setText:[NSString stringWithFormat:@"¥%@.00",infoModel.price]];
        
        /* cell 已购买的用户 赋值*/
        [cell.saleNumber setText:infoModel.buy_tickets_count];
        
        /* cell 的课程id属性*/
        cell.classID = @"" ;
        
        [cell.className setText: infoModel.name];
        
    }
    return cell;
    
    
}





/* section数量*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:_tutoriumListFilePath]) {
        
        
        NSDictionary *dic =[NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:_tutoriumListFilePath]];
        
        NSLog(@"%ld",[[dic valueForKey:@"listArr"] count]);
        
        return [[dic valueForKey:@"listArr"] count];
        
    }
    
    
    return 1;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((CGRectGetWidth(self.view.bounds)-40)/2, (CGRectGetWidth(self.view.bounds)-40)/2);
}

/* 最小行间距*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
    
}
/* 最小列间距*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
    
}
/* 上下左右的间距*/
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}




#pragma mark- item被选中的回调方法
/* item被选中的回调方法*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TutoriumListInfo *mod;
    if (listArr.count==0) {
        
    }else{
        
        TutoriumList *modlist=[TutoriumList new];
        modlist = listArr[indexPath.section];
        
        mod = [TutoriumListInfo yy_modelWithDictionary:modlist.data[indexPath.row]];
        mod.classID =[listInfo.data[indexPath.row]valueForKey:@"id"];
        NSLog(@"%@",infoModel.classID);
    }
    
    TutoriumInfoViewController *tutoriumInfo =[[TutoriumInfoViewController alloc]initWithClassID:mod.classID];
    
    
    [self.navigationController pushViewController:tutoriumInfo animated:YES];
    self.rdv_tabBarController.tabBar.hidden = YES;
    
    
}



#pragma mark- 拿到model后的加载数据 刷新页面的 方法
- (void)loadData:(nullable NSNotification *)notification{
    
    [_tutoriumView.classesCollectionView removeFromSuperview];
    
    [_tutoriumView.classesCollectionView reloadData];
    [_tutoriumView.classesCollectionView setNeedsLayout];
    [_tutoriumView.classesCollectionView setNeedsDisplay];
    
    [_tutoriumView addSubview:_tutoriumView.classesCollectionView ];
    NSLog(@"重新刷新collection完成");
    
}



#pragma mark- 请求数据和重新请求数据方法  --  下拉刷新和上滑刷新专用
- (void)requestDataWithGrade:(NSString *)grade andSubject:(NSString *)subject andPage:(NSInteger)pageNumber andPerPage:(NSInteger)perPage  withPull:(NSInteger)pullState{
    
    /* 加载框*/
    
    [self loadingHUDStartLoadingWithTitle:@"正在加载数据"];
    
    /* 发请求获取课程列表*/
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue:_remember_token forHTTPHeaderField:@"Remember-Token"];
    
    NSString *requestStrURL=[NSString string];
    
    if ([grade isEqualToString:@""]&&[subject isEqualToString:@""]) {
        
        requestStrURL = [NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses?page=%ld&per_page=%ld",pageNumber,perPage];
        
    }
    else if (![grade isEqualToString:@""]&&[subject isEqualToString:@""]) {
        requestStrURL = [NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses?page=%ld&per_page=%ld&grade=%@",pageNumber,perPage,grade];
    }
    else if ([grade isEqualToString:@""]&&![subject isEqualToString:@""]) {
        requestStrURL = [NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses?page=%ld&per_page=%ld&subject=%@",pageNumber,perPage,subject];
    }
    else if (![grade isEqualToString:@""]&&![subject isEqualToString:@""]) {
        requestStrURL = [NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses?page=%ld&per_page=%ld&subject=%@&grade=%@",pageNumber,perPage,subject,grade];
    }
    
    
    
    /* 如果是下拉重载，而且页数大于等于1*/
    if (pullState ==0&&page>=1) {
        
        for (int i=1; i<=page; i++) {
            
            
            [manager GET:requestStrURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                
                /* 先判断token*/
                if (![self isTokenRight:responseObject]) {
                    
                    /* 需要重新登录*/
                    [self needUpdateToken];
                    
                }else{
                
                /* 使用YYModel解析创建model  get回来的数据是个数组内含字典 引入tag值来确定数组下标*/
                _tutroiumList = [TutoriumList yy_modelWithJSON:responseObject];
                
                NSLog(@"%@,%@",_tutroiumList.status,_tutroiumList.data);
                
                /* 缓存数据源添加获取的Model*/
                
                
                [listArr removeAllObjects];
                [listArr addObject:_tutroiumList];
                
                
                
                NSLog(@"%@",listArr[0].data);
                NSLog(@"%ld",listArr.count);
                
                listDic = @{@"page":[NSNumber numberWithInteger:pageNumber],
                            @"per_page":[NSNumber numberWithInteger:perPage],
                            @"filterGrade":grade,
                            @"filterSubject":subject,
                            @"filterStatus":[NSNumber numberWithInteger:filterStatus],
                            @"listArr":listArr
                            };
                
                /* 测试代码*/
                TutoriumList *tu =[[TutoriumList alloc]init];
                tu = listDic[@"listArr"];
                
                
                //        NSLog(@"%@",tu.tutoriumListInfo);
                
                /* 获取到的数据缓存到本地*/
                /* 保存的数据中含有自定义对象，保存到沙盒*/
                [NSKeyedArchiver archiveRootObject:listDic toFile:_tutoriumListFilePath];
                
                /* 本地状态变化*/
                //        savedDic =[NSDictionary dictionaryWithDictionary: listDic];
                
                
                
                /* 加载数据完成后  视图重新加载数据*/
                [[NSNotificationCenter defaultCenter]postNotificationName:@"DataLoaded" object:nil];
                
                [self loadData:nil];
                
                NSLog(@"加载数据完成。");
                }
                
                [self loadingHUDStopLoadingWithTitle:@"数据加载成功"];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                
            }];
            
        }
    }
    
    
    /* 如果是上滑加载更多数据*/
    else if (pullState==1){
        page++;
        
        [manager GET:requestStrURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            /* 先判断token*/
            if (![self isTokenRight:responseObject]) {
                
                /* 需要重新登录*/
                [self needUpdateToken];
                
            }else{
                
            /* 使用YYModel解析创建model  get回来的数据是个数组内含字典 引入tag值来确定数组下标*/
            _tutroiumList = [TutoriumList yy_modelWithJSON:responseObject];
            
            NSLog(@"%@,%@",_tutroiumList.status,_tutroiumList.data);
            
            /* 缓存数据源添加获取的Model*/
            
            
            [listArr addObject:_tutroiumList];
            
            
            
            
            NSLog(@"%@",listArr[0].data);
            NSLog(@"%ld",listArr.count);
            
            listDic = @{@"page":[NSNumber numberWithInteger:pageNumber],
                        @"per_page":[NSNumber numberWithInteger:perPage],
                        @"filterGrade":grade,
                        @"filterSubject":subject,
                        @"filterStatus":[NSNumber numberWithInteger:filterStatus],
                        @"listArr":listArr
                        };
            
            /* 测试代码*/
            TutoriumList *tu =[[TutoriumList alloc]init];
            tu = listDic[@"listArr"];
            
            
            //        NSLog(@"%@",tu.tutoriumListInfo);
            
            /* 获取到的数据缓存到本地*/
            /* 保存的数据中含有自定义对象，保存到沙盒*/
            [NSKeyedArchiver archiveRootObject:listDic toFile:_tutoriumListFilePath];
            
            /* 本地状态变化*/
            //        savedDic =[NSDictionary dictionaryWithDictionary: listDic];
            
            
            /* 加载数据完成后  视图重新加载数据*/
            [[NSNotificationCenter defaultCenter]postNotificationName:@"DataLoaded" object:nil];
            
            [self loadData:nil];
            
            NSLog(@"加载数据完成。");
            [self loadingHUDStopLoadingWithTitle:@"数据加载成功"];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }
    
    
}

//#pragma mark- 缓存数据源添加数据方法
///* 缓存数据源添加数据*/
//
//- (void)listArrayIncreaseData:(NSDictionary *)data{
//
//
//
//
//}
//
//
//#pragma mark- 存储本地筛选状态
//- (void)saveFilterStatus:(NSDictionary *)filterStatusDic{
//
//
//    [[NSUserDefaults standardUserDefaults]setObject:filterStatusDic forKey:@"FilterStatus"];
//
//
//}



/* 键盘出现*/

- (void)keyboardWillShow:(NSNotification *)aNotification{
    
    //获取键盘高度
    
    NSDictionary *info = [aNotification userInfo];
    
    //获取动画时间
    
    float duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //获取动画开始状态的frame
    
    CGRect beginRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    //获取动画结束状态的frame
    
    CGRect endRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    //计算高度差
    
    float offsety =  endRect.origin.y - beginRect.origin.y ;
    
    NSLog(@"键盘高度:%f 高度差:%f\n",beginRect.origin.y,offsety);
    
    //下面的动画，整个View上移动
    
    CGRect fileRect = self.view.frame;
    
    fileRect.origin.y += offsety;
    
    [UIView animateWithDuration:duration animations:^{
        
        self.view.frame = fileRect;
        
    }];
    
    
}

/* 键盘隐藏*/
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    [self.view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    
}



/* 判断token是否正确，请求数据的时候 登录是否成功*/
- (BOOL)isTokenRight:(id)responds{
    
    NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
   
    NSString *status =[NSString stringWithFormat:@"%@",dic[@"status"]];
    if ([status isEqualToString:@"1"]) {
        
        return YES;
        
    }else {
        
        return NO;
    }
    
    
}



/* 登录错误。token需要更新*/
- (void)needUpdateToken{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录过期,请重新登录！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    
        /* 给appdelegate发送消息  用户退出登录  跳转到登录界面*/
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userLogOut" object:nil];
        
        /* 清除所有用户文件*/
         NSString *userFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"User.data"];
        
        if (userFilePath) {
            
        [[NSFileManager defaultManager]removeItemAtPath:userFilePath error:nil];
        }
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"id"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"remember_token"];
        
        
    }];
    
    [alert addAction:action];
    
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
    
}


//- (MBProgressHUD *)loadingHUD{
//    
//    
//    MBProgressHUD *hud=[MBProgressHUD HUDForView:self.view];
//    
//    
//    return hud;
//    
//}
//
//-(MBProgressHUD *)endHUD{
//    
//    MBProgressHUD *hud=[MBProgressHUD HUDForView:self.view];
//    
//    
//    return hud;
//
//}
//
//
//
//- (void)setLoadingHUD:(MBProgressHUD *)loadingHUD{
//    
//    
//    
//}
//
//- (void)setEndHUD:(MBProgressHUD *)endHUD{
//    
//    
//}
//
//
//
//
//
///* HUD框 正在加载*/
//- (void)loadingHUDStartLoadingWithTitle:(NSString *)hudTitle{
//    
//    
//    /* HUD框 提示正在登陆*/
//    self.loadingHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    self.loadingHUD.mode = MBProgressHUDModeDeterminate;
//    self.loadingHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
//    [self.loadingHUD.label setText:hudTitle];
//    
//    self.loadingHUD.mode = MBProgressHUDModeIndeterminate;
//    
//    
//}
//
//
//
///* HUD框 加载完成*/
//- (void)loadingHUDStopLoadingWithTitle:(NSString *)hudTitle{
//    
//    [self.loadingHUD hideAnimated:YES ];
//    
//    self.endHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//
//    self.endHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
//    
//    [self.endHUD.label setText:hudTitle];
//    
//    self.endHUD.mode = MBProgressHUDModeText;
//    
//    [self.endHUD showAnimated:YES];
//    
//    [self.endHUD hideAnimated:YES afterDelay:1 ];
//
//    
//}



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
