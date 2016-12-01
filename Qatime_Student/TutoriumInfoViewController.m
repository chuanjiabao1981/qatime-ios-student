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

#import "UIImageView+WebCache.h"
#import "UIViewController_HUD.h"
#import "UIViewController+HUD.h"


@interface TutoriumInfoViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    
    /* 保存课程列表的array*/
    NSMutableArray *_classListArray;
    
    
    /* token*/
    NSString *_remember_token;
    

    
    
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




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
    [self.view addSubview:_navigationBar];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastpage) forControlEvents:UIControlEventTouchUpInside];
    
    
    _tutoriumInfoView = [[TutoriumInfoView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64-63)];
    [self .view addSubview:_tutoriumInfoView];
    
    _tutoriumInfoView.scrollView.delegate = self;
    _tutoriumInfoView.classesListTableView.scrollEnabled =NO;
    
    _tutoriumInfoView.segmentControl.selectionIndicatorHeight=2;
    _tutoriumInfoView.segmentControl.selectedSegmentIndex=0;
    
    
    typeof(self) __weak weakSelf = self;
    [ _tutoriumInfoView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.tutoriumInfoView.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.view.bounds) * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-64-49) animated:YES];
    }];

        self.tutoriumInfoView.scrollView.delegate = self;
         self.tutoriumInfoView.scrollView.bounces=NO;
         self.tutoriumInfoView.scrollView.alwaysBounceVertical=NO;
          self.tutoriumInfoView.scrollView.alwaysBounceHorizontal=NO;
        
        [  self.tutoriumInfoView.scrollView scrollRectToVisible:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) animated:YES];
    
    
    
    _tutoriumInfoView.classesListTableView.delegate = self;
    _tutoriumInfoView.classesListTableView.dataSource = self;
    
    _tutoriumInfoView.classesListTableView.bounces = NO;
    
    
    /* 根据传递过来的id 进行网络请求model*/
    /* 初始化三个model*/
    _classModel = [[RecommandClasses alloc]init];
    _teacherModel = [[RecommandTeacher alloc]init];
    _classInfoTimeModel = [[ClassesInfo_Time alloc]init];
    
    
    
    _classListArray = @[].mutableCopy;
    
    
    
    [self requestClassesInfoWith:_classID];
    
    
    [self loadingHUDStopLoadingWithTitle:@"加载完成!"];
    
    
}

/* 根据初始化传值进来的id 进行网络请求*/
- (void)requestClassesInfoWith:(NSString *)classid{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_remember_token forHTTPHeaderField:@"Remember-Token"];
    
    
    [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses/%@",classid] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        /* 拿到数据字典*/
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"%@",dic);
        
        
        NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
        
        NSDictionary *dataDic=[NSDictionary dictionaryWithDictionary:dic[@"data"]];
        NSLog(@"%@",dataDic);
        
        if ([status isEqualToString:@"0"]) {
            /* 获取token错误  需要重新登录*/
        }else{
            
            /* 手动解析teacherModel*/
            NSDictionary *teacherDic =dataDic[@"teacher"];
            NSLog(@"%@",teacherDic);
            
            /* teacherModel赋值与界面数据更新*/
            
            _teacherModel .teacherID = [teacherDic valueForKey:@"id"];
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
            [_tutoriumInfoView.workYearsLabel setText:[NSString stringWithFormat:@"%@",_teacherModel.teaching_years]];
            [_tutoriumInfoView.classImage sd_setImageWithURL:[NSURL URLWithString:_teacherModel.avatar_url]];
            
            
            
//            NSLog(@"%@",[teacherDic valueForKey:@"gender"]);
            
            
            /* 手动解析classModel*/
            
            _classModel = [RecommandClasses yy_modelWithDictionary:dataDic];
            _classModel.classID =dataDic[@"id"];
            _classModel.describe = dataDic[@"description"];
            
//            NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",_classModel.classID,_classModel.name,_classModel.subject,_classModel.grade,_classModel.teacher_name,_classModel.price,_classModel.chat_team_id,_classModel.buy_tickets_count,_classModel.preset_lesson_count,_classModel.completed_lesson_count,_classModel.live_start_time,_classModel.live_end_time,_classModel.publicize);
            
            /* 课程页面的label赋值*/
            [_tutoriumInfoView.subjectLabel setText:_classModel.subject];
            [_tutoriumInfoView.gradeLabel setText:_classModel.grade];
            [_tutoriumInfoView.classCount setText:_classModel.lesson_count];
            
            [_tutoriumInfoView.onlineVideoLabel setText:_classModel.status];
            
            [_tutoriumInfoView.classDescriptionLabel setText:_classModel.describe];
            
            
            /* 课程列表的手动解析model*/
            
            NSMutableArray *classList=dataDic[@"lessons"];
           
           
            NSLog(@"%@",classList);
            for (int i=0; i<classList.count; i++) {
                
                _classInfoTimeModel = [ClassesInfo_Time yy_modelWithDictionary:classList[i]];
                _classInfoTimeModel.classID =[ classList[i]valueForKey:@"id" ];
                NSLog(@"%@",_classInfoTimeModel.classID);
                
                [_classListArray addObject:_classInfoTimeModel];
                
                
                
                [self updateTableView];
                
                
                
                
            }
  
        }
     
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
    
    
    
}


- (void)updateTableView{
    
    [_tutoriumInfoView.classesListTableView reloadData];
    [_tutoriumInfoView.classesListTableView setNeedsDisplay];
    [_tutoriumInfoView.classesListTableView setNeedsLayout];
    
    [_navigationBar .titleLabel setText:_classModel.name];
    
}

// 滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [_tutoriumInfoView.segmentControl setSelectedSegmentIndex:page animated:YES];
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
//        [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width];
        
        
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
            
//            ClassesInfo_Time  *mod=[[ClassesInfo_Time alloc]init];
//            mod = _classListArray[indexPath.row];
//            
//            [cell.className setText:mod.name];
//            [cell.classDate setText:mod.class_date];
//            [cell.classTime setText:mod.live_time];
////             直播状态 后期需要确认接口后判断状态
//            [cell.status setText:mod.status];
//            if ([mod.status isEqualToString:@"preview"]) {
//                
//                [cell.imageView setImage:[UIImage imageNamed:@"circle_green"]];
//            }else{
//                [cell.imageView setImage:[UIImage imageNamed:@"circle_gray"]];
            
//            }
            ClassesInfo_Time *mod = _classListArray[indexPath.row];
            cell.model = mod;
            cell.sd_tableView = tableView;
            cell.sd_indexPath = indexPath;
            
            
        }
        
        
    }
//    [cell setupAutoHeightWithBottomView:cell.classDate bottomMargin:20];
    
    return  cell;
    
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
