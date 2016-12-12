//
//  OrderViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/12.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "OrderViewController.h"
#import "NavigationBar.h"

#import "TutoriumList.h"
#import "YYModel.h"
#import "UIImageView+WebCache.h"
#import "RDVTabBarController.h"

@interface OrderViewController (){
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    
}

@end

@implementation OrderViewController

-(instancetype)initWithClassID:(NSString *)classID{
    
    self= [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
    }
    return self;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = ({
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        
        _.titleLabel.text = @"订单确认";
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_];
        _;
    });
    
    
    _orderView = ({
    
        OrderView *_=[[OrderView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
        
        
        [self.view addSubview:_];
        _;
    });
    
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }

    
    /* 请求课程详细信息数据*/
    [self requestClassInfo];
    
    
    
    
    
}
/* 请求课程详细信息*/
- (void)requestClassInfo{
    
    if (_token&&_idNumber) {
        
        if (_classID!=nil) {
           
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
            [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/students/%@/courses/%@",_idNumber,_classID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                    /* 数据请求成功*/
                    TutoriumListInfo *mod = [TutoriumListInfo yy_modelWithJSON:dic[@"data"]];
                    
                    /* 成功后赋值*/
                    _orderView.className.text = mod.name;
                    [_orderView.classImage sd_setImageWithURL:[NSURL URLWithString:mod.publicize]];
                    _orderView.subjectLabel.text = mod.subject;
                    _orderView.gradeLabel.text = mod.grade;
                    _orderView.teacheNameLabel.text = mod.teacher_name;
                    _orderView.classTimeLabel.text = [NSString stringWithFormat:@"共%@课",mod.preset_lesson_count];
                    
                    /* 日期转化*/
                    NSDateFormatter *format = [[NSDateFormatter alloc]init];
                    format.dateFormat = @"yyyy-MM-dd HH:mm";
                    NSDate *startDate = [format dateFromString:mod.live_start_time];
                    NSDate *endDate = [format dateFromString:mod.live_end_time];
                    NSDateFormatter *strFormat= [[NSDateFormatter alloc]init];
                    strFormat.dateFormat = @"yyyy年MM月dd日";
                    
                    _orderView.startTimeLabel.text = [strFormat stringFromDate:startDate];
                    _orderView.endTimeLabel.text = [strFormat stringFromDate:endDate];
                    
                    if ([mod.status isEqualToString:@"teaching"]) {
                        _orderView.statusLabel.text = @"开课中";
                    }
                    
                    _orderView.typeLabel.text = @"在线直播";
                    
                    _orderView.priceLabel.text = [NSString stringWithFormat:@"%@元",mod.price];
                    
                    _orderView.totalMoneyLabel.text =[NSString stringWithFormat:@"%@",mod.price];

                    
                    
                    
                    
                    
                    
                    
                    
                    
                }else{
                    /* 拉取订单信息失败*/
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"获取订单信息失败,请重试!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self returnLastPage];
                    }] ;
                    [alert addAction:sure];
                    
                    [self presentViewController:alert animated:YES completion:nil];

                    
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
        
        }
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
