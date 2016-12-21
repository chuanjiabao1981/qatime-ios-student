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
#import "NoticeListTableViewCell.h"
#import "NIMSDK.h"

#import "ChatViewController.h"
#import "UIViewController+HUD.h"
#import "HaveNoClassView.h"
#import "SystemNotice.h"

#import "ChatList.h"


@interface NoticeIndexViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,NIMConversationManagerDelegate,NIMLoginManagerDelegate>{
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    /* 我的辅导班列表*/
    NSMutableArray *_myClassArray;
    
    /* 聊天列表*/
    NSMutableArray *_chatListArr;
    
    /* 最近会话的数组*/
    NSMutableArray *_recentArr;
    
    /* 通知信息数组*/
    NSMutableArray *_noticeArray;
    
    
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
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
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
            [weakSelf.noticeIndexView.scrollView scrollRectToVisible:CGRectMake(self.view.width_sd * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-64) animated:YES];
        }];
        [_.scrollView scrollRectToVisible:CGRectMake(-self.view.width_sd, 0, self.view.width_sd, self.view.height_sd) animated:YES];
        
        [self.view addSubview:_];
        
        _;
        
    });
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
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
    _noticeArray = @[].mutableCopy;
    _chatListArr = @[].mutableCopy;
    
    
    NSLog(@"%@",[[[NIMSDK sharedSDK]teamManager]allMyTeams]);
    
    /* 如果用户加入新的试听课程,或者是用户是第一次进入程序,向远程服务器拉取聊天历史记录*/
    /* 判断是不是第一次登陆*/
    
    /* 获取我的辅导班列表*/
    [self requestMyClass];
    
    /* 请求通知消息*/
    [self requestNotices];
    
    [[[NIMSDK sharedSDK]loginManager]addDelegate:self];
    
    NSDictionary *chatDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"chat_account"];
    
    [[NIMSDK sharedSDK].loginManager autoLogin:chatDic[@"accid"] token:chatDic[@"token"]];
    
    [[[NIMSDK sharedSDK]conversationManager]addDelegate:self];
    
    
    /* 消息变为已读的通知*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(markRead:) name:@"MarkAllRead" object:nil];
    
}

/* 读取消息后,该页面接受通知消息,tablecell的badge数量变化*/
- (void)markRead:(NSNotification *)notification{
    
    
    
    
}


/* 获取辅导班聊天列表*/
- (void)requestMyClass{
    
    [self loadingHUDStartLoadingWithTitle:@"正在刷新聊天列表"];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/courses",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            
            
            dispatch_queue_t recent = dispatch_queue_create("recent", DISPATCH_QUEUE_SERIAL);
            dispatch_sync(recent, ^{
                
                /* 请求近期聊天会话*/
                _recentArr =  [NSMutableArray arrayWithArray:[[[NIMSDK sharedSDK]conversationManager]allRecentSessions]];
            });
            
            if ([dic[@"data"] count ] ==0) {
                /* 没有加入聊天的情况*/
                HaveNoClassView *noChat = [[HaveNoClassView  alloc]init];
                noChat.titleLabel.text = @"当前无课程";
                
                noChat.frame = CGRectMake(0, 0, self.view.width_sd,_noticeIndexView.scrollView.height_sd);
                [_noticeIndexView.chatListTableView addSubview:noChat];
                
            }else{
                
                if (_myClassArray) {
                    
                    /* 获取近期会话的未读消息等数据*/
                    NSMutableArray *dicArr =[NSMutableArray arrayWithArray: dic[@"data"]];
                    
                    for (NSDictionary *tutorium in dicArr) {
                        
                        TutoriumListInfo *info = [TutoriumListInfo yy_modelWithJSON:tutorium];
                        info.classID = tutorium[@"id"];
                        
                        [_myClassArray addObject:info];
                    }
                    
                        
                        if (_myClassArray&&_recentArr) {
                            
                            /* 把badge结果遍历给chatlist的cell*/
                            for (TutoriumListInfo *info in _myClassArray) {
                                
                                ChatList *mod = [[ChatList alloc]init];
                                mod.tutorium = info;
                                mod.name = info.name;
                                for (NIMRecentSession *session in _recentArr) {
                                    
                                    NSLog(@"%@........%@",session.session.sessionId,info.chat_team_id);
                                    
                                    if ([session.session.sessionId isEqualToString:info.chat_team_id]) {
                                        
                                        mod.badge = session.unreadCount;
                                    }
                                    
                                }
                                [_chatListArr addObject:mod];
                                
                            }
                        }
                }
            }
            
        }else{
            /* 数据错误*/
            
            [self loadingHUDStopLoadingWithTitle:@"数据失败!"];
        }
        
        [self loadingHUDStopLoadingWithTitle:@"加载完成"];
        [_noticeIndexView.chatListTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


/* 请求通知消息*/
- (void)requestNotices{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/users/%@/notifications",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 请求成功*/
            NSMutableArray *dataArr = [NSMutableArray arrayWithArray:dic[@"data"]];
            if (dataArr.count == 0) {
                /* 没有数据*/
                /* 没有加入聊天的情况*/
                HaveNoClassView *noNotice = [[HaveNoClassView  alloc]init];
                noNotice.titleLabel.text = @"当前无通知";
                noNotice.frame  = CGRectMake(0, 0, self.view.width_sd,_noticeIndexView.scrollView.height_sd);
                
                [_noticeIndexView.noticeTableView addSubview:noNotice];
            }else{
                /* 有数据的情况下*/
                for (NSDictionary *dics in dataArr) {
                    
                    SystemNotice *notice = [SystemNotice yy_modelWithJSON:dics];
                    notice.noticeID = dics[@"id"];
                    [_noticeArray addObject:notice];
                    
                }
            }
            
        }else{
            /* 请求失败*/
            
        }
        
        [_noticeIndexView.noticeTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}



#pragma mark- tableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows=1;
    
    switch (tableView.tag) {
        case 2:
            if (_chatListArr.count == 0) {
                rows = 1;
            }else{
                rows = _chatListArr.count;
                
            }
            
            break;
            
        case 3:{
            if (_noticeArray.count == 0) {
                rows = 1;
            }else{
                rows = _noticeArray.count;
                
            }
            
        }
            
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
            }
            
            if (_chatListArr.count>indexPath.row) {
                cell.model = _chatListArr[indexPath.row];
                cell.sd_tableView = tableView;
                cell.sd_indexPath = indexPath;
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                
            }
            
            return  cell;
        }
            
            break;
            
        case 3:
        {
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            NoticeListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[NoticeListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            
            
            if (_noticeArray.count>indexPath.row) {
                
                cell.model = _noticeArray[indexPath.row];
              
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
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
            if (_chatListArr.count>indexPath.row) {
                
                ChatList *mod = _chatListArr[indexPath.row];
                height = [tableView cellHeightForIndexPath:indexPath model:mod keyPath:@"model" cellClass:[ChatListTableViewCell class] contentViewWidth:self.view.width_sd];
            }
        }
            break;
            
        case 3:{
            if (_noticeArray.count>indexPath.row) {
                
                SystemNotice *mod = _noticeArray[indexPath.row];
                height = [tableView cellHeightForIndexPath:indexPath model:mod keyPath:@"model" cellClass:[NoticeListTableViewCell class] contentViewWidth:self.view.width_sd];
                
            }
            
            
        }
            break;
    }
    
    return height;
}


/* 选择聊天室*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 2) {
        
        ChatListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        ChatViewController *chatVC = [[ChatViewController alloc]initWithClass:cell.model.tutorium];
        [self .navigationController pushViewController:chatVC animated:YES];
        
        NIMSession *recentSession = [NIMSession session:cell.model.tutorium.chat_team_id type:NIMSessionTypeTeam];
        
        [[[NIMSDK sharedSDK]conversationManager]markAllMessagesReadInSession:recentSession];
        
        cell.badge.hidden = YES;
        
        
        [_chatListArr[indexPath.row] setValue:@0 forKey:@"badge"];
        

        
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
