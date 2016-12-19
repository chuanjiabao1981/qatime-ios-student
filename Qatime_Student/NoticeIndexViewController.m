//
//  NoticeIndexViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/16.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "NoticeIndexViewController.h"
#import "RDVTabBarController.h"
#import "TutoriumList.h"
#import "YYModel.h"
#import "ChatListTableViewCell.h"
#import "NoticeTableViewCell.h"
#import "NIMSDK.h"

#import "ChatViewController.h"
#import "UIViewController+HUD.h"

@interface NoticeIndexViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,NIMConversationManagerDelegate,NIMLoginManagerDelegate>{
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    /* 我的辅导班列表*/
    NSMutableArray *_myClassArray;
    
    
    
    
    
    
    
    
    
}

@end

@implementation NoticeIndexViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    _navigationBar = ({
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        _.titleLabel.text = @"消息中心";
        [_.leftButton setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_];
        _;
    });
    
    _noticeIndexView = ({
        NoticeIndexView *_=[[NoticeIndexView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
        
        _.scrollView.delegate = self;
        _.scrollView.tag=1;
        
        _.chatListTableView.delegate = self;
        _.chatListTableView.dataSource = self;
        _.chatListTableView.tag=2;
        
        _.noticeTableView.delegate = self;
        _.noticeTableView.dataSource = self;
        _.noticeTableView.tag = 3;
        
        /* 滑动效果*/
        typeof(self) __weak weakSelf = self;
        [ _.segmentControl setIndexChangeBlock:^(NSInteger index) {
            [weakSelf.noticeIndexView.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.view.bounds) * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-64) animated:YES];
        }];
        [_.scrollView scrollRectToVisible:CGRectMake(-CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) animated:YES];
        
        [self.view addSubview:_];
        
        _;
        
    });

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    
    /* 初始化*/
    _myClassArray = @[].mutableCopy;
    
    
    
    
    NSLog(@"%@",[[[NIMSDK sharedSDK]teamManager]allMyTeams]);
    
//    [[NIMSDK sharedSDK]teamManager ]fetchTeamInfo:<#(nonnull NSString *)#> completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
        
//    }];
    /* 如果用户加入新的试听课程,或者是用户是第一次进入程序,向远程服务器拉取聊天历史记录*/
    /* 判断是不是第一次登陆*/
    
           /* 获取我的辅导班列表*/
        [self requestMyClass];
        
    
}

/* 获取辅导班列表*/
- (void)requestMyClass{
    
    [self loadingHUDStartLoadingWithTitle:@"正在刷新聊天列表"];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/courses",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            if (_myClassArray) {
                NSMutableArray *dicArr =[NSMutableArray arrayWithArray: dic[@"data"]];
                
                for (NSDictionary *dic in dicArr) {
                    TutoriumListInfo *mod = [TutoriumListInfo yy_modelWithJSON:dic];
//                    mod.classID =[NSString stringWithFormat:@"%@",dic[@"data"][@"id"]];
                    
                    [_myClassArray addObject:mod];
                    
                    
                    /* 从本地获取历史消息记录*/
//                    [NIMSDK sharedSDK].conversationManager
                    
                }
                
            }
            
         [self loadingHUDStopLoadingWithTitle:@"加载完成!"];
        }else{
            /* 数据错误*/
            
        [self loadingHUDStopLoadingWithTitle:@"数据失败!"];
        }
        
        [_noticeIndexView.chatListTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


#pragma mark- tableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows=1;
   
    switch (tableView.tag) {
        case 2:
            if (_myClassArray.count == 0) {
                rows = 1;
            }else{
                rows = _myClassArray.count;
                
            }
            
            break;
            
        case 3:
            
            break;

    }
    
    return rows;
}


#pragma mark- tableView delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [UITableViewCell new];
    
    switch (tableView.tag) {
       
        case 2:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            ChatListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[ChatListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                cell.sd_tableView = tableView;
                
            }
            if (_myClassArray) {
                if (_myClassArray.count>indexPath.row) {
                    
                    cell.model = _myClassArray[indexPath.row];
                }
            }
            
            return  cell;
        }
            
            break;
            
        case 3:
        {
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            NoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[NoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                cell.sd_tableView = tableView;
                
            }
            
            return  cell;
            

            
        }
            
            break;
            
    }
    
    return cell;
}

#pragma mark- tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSInteger height;
    switch (tableView.tag) {
        case 2:{
            if (_myClassArray.count>indexPath.row) {
                
                TutoriumListInfo *mod = _myClassArray[indexPath.row];
                height = [tableView cellHeightForIndexPath:indexPath model:mod keyPath:@"model" cellClass:[ChatListTableViewCell class] contentViewWidth:self.view.width_sd];
            }
        }
            break;
            
        case 3:{
            
        }
            break;
    }
    
    return height;
}


/* 选择聊天室*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (tableView.tag == 2) {
        
        ChatListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        ChatViewController *chatVC = [[ChatViewController alloc]initWithClass:cell.model];
        [self .navigationController pushViewController:chatVC animated:YES];
    }
    
    
    
    
    
    
}




#pragma mark- scrollView delegate
// segment的滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _noticeIndexView.scrollView) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        
        [_noticeIndexView.segmentControl setSelectedSegmentIndex:page animated:YES];
        
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
