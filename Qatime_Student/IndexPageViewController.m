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

#import "RecommandTeacher.h"

#import "UIImageView+WebCache.h"

#import "RecommandClasses.h"
#import "YYModel.h"

#import "TeachersPublicViewController.h"
#import "UIViewController+HUD.h"

#import "NIMSDK.h"

@interface IndexPageViewController ()<UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>{
    
    
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
    
    /* 推荐教师的存放数组*/
    NSMutableArray *_recommandTeachers;
    
    /* 推荐老师按section的存放数组*/
    NSMutableArray *_teachers;
    
    
    /* 推荐课程存放数组*/
    NSMutableArray *_classes;
    
    
    /* token*/
    NSString *_remember_token;
    
    /* 头视图的尺寸*/
    CGSize headerSize;
    
}

@end

@implementation IndexPageViewController

- (void)loadView{
    [super loadView];
    
    [self loadingHUDStartLoadingWithTitle:@"正在加载数据"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /* 导航栏加载*/
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64)];
    [self .view addSubview:_navigationBar];
    [_navigationBar.rightButton setImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
    [_navigationBar.rightButton addTarget:self action:@selector(enterNoticeCenter) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 取出token*/
    _remember_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"];

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
    
    _recommandTeachers =@[].mutableCopy;
    
    
    _teachers =@[].mutableCopy;
    _classes = @[].mutableCopy;
    
    /* 请求kee 并存本地*/
    [self requestKee];
    
    /* 初次请求成功后，直接申请推荐教师和推荐课程*/
    
    /* 请求推荐教师详情*/
        
    /* 添加headerview尺寸变化的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sizeToFitHeight) name:@"SizeChange" object:nil];
    
    
    
    
    /* 云信sdk的登录回调*/
//    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    
    
    
}



#pragma mark- 请求kee
- (void)requestKee{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/recommend/positions",Request_Header ] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSDictionary *keeDic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"%@",keeDic);
        
        NSString *state=[NSString stringWithFormat:@"%@",keeDic[@"status"]];
        
        if ([state isEqualToString:@"0"]) {
            
            /* 登陆过期提示*/
            
        }else{
            
            
            NSArray *keeArr=[NSArray arrayWithArray:[keeDic valueForKey:@"data"]];
            NSLog(@"%@",keeArr);
            
            _kee_teacher =[NSString stringWithFormat:@"%@",[keeArr[0] valueForKey:@"kee"]];
            _kee_class =[NSString stringWithFormat:@"%@",[keeArr[1] valueForKey:@"kee"]];
            
            [[NSUserDefaults standardUserDefaults]setObject:_kee_teacher forKey:@"kee_teacher"];
            [[NSUserDefaults standardUserDefaults]setObject:_kee_class forKey:@"kee_class"];
            
            NSLog(@"%@,%@",_kee_teacher,_kee_class);
            
            
            /* 异步线程请求推荐教师*/
            dispatch_queue_t teacher = dispatch_queue_create("teacher", DISPATCH_QUEUE_SERIAL);
            dispatch_async(teacher, ^{
                
                /* 请求推荐教师数据*/
                [self requestTeachers];
                
            });
            
            
            /* 另一异步线程请求推荐课程*/
            
            dispatch_queue_t classes = dispatch_queue_create("teacher", DISPATCH_QUEUE_SERIAL);
            dispatch_async(classes, ^{
                
                /* 请求推荐课程数据*/
                [self requestClasses];
                
            });

            
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

#pragma mark- 请求推荐课程方法
- (void)requestClasses{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/recommend/positions/%@/items?page=%ld&per_page=%ld",Request_Header,_kee_class,page,per_page] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *classDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog( @"%@",classDic);
        
        NSString *state =[NSString stringWithFormat:@"%@",classDic[@"status"]];
        
        NSArray *classArr=@[].mutableCopy;
        
        
        if ([state isEqualToString:@"0"]) {
            /* 请求错误，重新发请求*/
            
        }else{
            
            classArr = [classDic valueForKey:@"data"];
            
            
            for ( int i =0; i<classArr.count; i++) {
                
                NSDictionary *classinfo =[NSDictionary dictionaryWithDictionary:[classArr[i] valueForKey:@"live_studio_course"]];
                RecommandClasses *reclass=[RecommandClasses yy_modelWithDictionary:classinfo];
              
                reclass.classID =[[classArr[i] valueForKey:@"live_studio_course"]valueForKey:@"id"];
                
                [_classes addObject:reclass];
                
                
               
                
            }
            
            
            [self reloadData];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SizeChange" object:nil];
            
            
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    

    
    
}



#pragma mark- 推荐教师请求方法
- (void)requestTeachers{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/recommend/positions/%@/items?page=%ld&per_page=%ld",Request_Header,_kee_teacher,page,per_page] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *teacherDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog( @"%@",teacherDic);
        
        NSString *state =[NSString stringWithFormat:@"%@",teacherDic[@"status"]];
        
        NSArray *teacherarr=@[].mutableCopy;
        
        
        if ([state isEqualToString:@"0"]) {
            /* 请求错误，重新发请求*/
            
        }else{
            
            teacherarr = [teacherDic valueForKey:@"data"];
            
            for ( int i =0; i<teacherarr.count; i++) {
                
                RecommandTeacher *retech=[[RecommandTeacher alloc]init];
                
                retech.teacherID = [teacherarr[i][@"teacher"] valueForKey:@"id"];
                retech.teacherName =[teacherarr[i][@"teacher"] valueForKey:@"name"];
                retech.avatar_url =[teacherarr[i][@"teacher"] valueForKey:@"avatar_url"];
                
                if (retech.teacherID ==NULL) {
                    retech.teacherID =@"";
                }if (retech.teacherName ==NULL) {
                    retech.teacherName =@"";
                }if (retech.avatar_url ==NULL) {
                    retech.avatar_url =@"";
                }
                
                [_teachers addObject:retech];
                
                NSLog(@"\n%@---%@---%@",retech.teacherID,retech.teacherName,retech.avatar_url);
            }
            
            [_recommandTeachers addObject:_teachers];
            
            [self reloadData];
            
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


- (void)reloadData{
    
    /* collectionView重新加载数据*/
    [_headerView.teacherScrollView reloadData];
    [_headerView.teacherScrollView setNeedsDisplay];
    
    [_indexPageView.recommandClassCollectionView reloadData];
    [_indexPageView.recommandClassCollectionView setNeedsDisplay];
    
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




#pragma mark- collectionview的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger items=0;
    
    if (collectionView.tag==0) {
        items =10;
    }
    
    if (collectionView .tag ==1){
        
        items = 6;
    }
    
    
    return items;
    
}

#pragma mark- collection的section

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSInteger sec=0;
    
    if (collectionView.tag==0) {
        sec = _recommandTeachers.count;
    }
    if(collectionView.tag==1){
        sec =1;
        
    }
    
    return sec;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CGSize layoutSize = CGSizeZero ;
    
    
    if (collectionView.tag==0){
        layoutSize = CGSizeMake(CGRectGetWidth(self.view.frame)/5-10, CGRectGetWidth(self.view.frame)/5-10);
    }
    
    if (collectionView .tag ==1){
        
        layoutSize = CGSizeMake((CGRectGetWidth(self.view.bounds)-40)/2, (CGRectGetWidth(self.view.bounds)-40)/2);
        
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
        
        
        if (_recommandTeachers.count ==0) {
            
        [squarecell.iconTitle setText:@"名师推荐"];
            
        
        [squarecell.iconImage setImage: [UIImage imageNamed:@"老师"]];
            
        }else{
            
            _teachers = _recommandTeachers[indexPath.section];
            RecommandTeacher *tech=[[RecommandTeacher alloc]init];
            tech = _teachers[indexPath.row];
            
            /* 加载获取到的数据*/
            [squarecell.iconImage sd_setImageWithURL:[NSURL URLWithString:tech.avatar_url ]];
            [squarecell.iconTitle setText:tech.teacherName];
            
        }
        
        cell = squarecell;
        
    }
    
    
    
    /* 辅导课程推荐 视图*/
    
    if (collectionView .tag==1) {
        
        RecommandClassCollectionViewCell *reccell=[collectionView dequeueReusableCellWithReuseIdentifier:recommandIdentifier forIndexPath:indexPath];
        
        
        if (_classes .count ==0) {
            
            [reccell.classImage setImage:[UIImage imageNamed:@"school"]];
        }else{
            RecommandClasses *cellmod = [[RecommandClasses alloc]init];
            cellmod = _classes[indexPath.row];
            
            
            [reccell.classImage sd_setImageWithURL:[NSURL URLWithString:cellmod.publicize]];
            
            [reccell.className setText:[NSString stringWithFormat:@"%@",cellmod.name]];
            [reccell.grade setText:[NSString stringWithFormat:@"%@",cellmod.grade]];
            [reccell.subjectName setText:[NSString stringWithFormat:@"%@",cellmod.subject]];
            [reccell.saleNumber setText:[NSString stringWithFormat:@"%@",cellmod.buy_tickets_count]];
            
            
        }
        

        
        cell=reccell ;
        
    }
    
    
    
    return cell;
    
}



/* cell的四边间距*/
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    //分别为上、左、下、右
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if (collectionView.tag ==0) {
        insets = UIEdgeInsetsZero;
        
    }
    
 
    if (collectionView.tag==1) {
        insets =UIEdgeInsetsMake(10, 15, 10, 10);
    }
    
    return insets;
}



#pragma mark- collection的点击事件

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag ==0) {
        
       
        
        if (_recommandTeachers.count==0) {
            
            /* 数据请求错误*/
            
        }else{
            
            
            NSString *teacherId=[NSString string];
            
            NSArray *teArr= [NSArray arrayWithArray:_recommandTeachers[indexPath.section]];
            RecommandTeacher *teach =teArr[indexPath.row];
            
            teacherId = teach.teacherID;
            
            TeachersPublicViewController *public =[[TeachersPublicViewController alloc]initWithTeacherID:teacherId];
            [self.navigationController pushViewController:public animated:YES];
            
            
        }
        
        
    }
    /* 推荐课程,预留点击事件*/
    if (collectionView.tag ==1) {
        
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

/* 进入消息中心*/
- (void)enterNoticeCenter{
    
    NoticeIndexViewController *noticeVC = [[NoticeIndexViewController alloc]init];
    [self.navigationController pushViewController:noticeVC animated:YES];
    
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
