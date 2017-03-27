//
//  NoticeIndexViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/16.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "NoticeIndexViewController.h"

#import "TutoriumList.h"
#import "YYModel.h"
#import "ChatListTableViewCell.h"
#import "NoticeListTableViewCell.h"
#import <NIMSDK/NIMSDK.h>

#import "ChatViewController.h"
#import "UIViewController+HUD.h"
#import "HaveNoClassView.h"
#import "SystemNotice.h"

#import "ChatList.h"
#import "UIAlertController+Blocks.h"
#import "UIViewController+Login.h"
#import "UIViewController+AFHTTP.h"
#import "MJRefresh.h"
#import "TutoriumInfoViewController.h"

typedef enum : NSUInteger {
    RefreshStatePushLoadMore,
    RefreshStatePullRefresh,
    RefreshStateNone,
} RefreshState;



@interface NoticeIndexViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,NIMConversationManagerDelegate,NIMLoginManagerDelegate,UIGestureRecognizerDelegate,JTSegmentControlDelegate,NIMChatManagerDelegate>{
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    /* 我的辅导班列表*/
    NSMutableArray *_myClassArray;
    
    /* 聊天列表*/
    NSMutableArray <ChatList *>*_chatListArr;
    
    /* 最近会话的数组*/
    NSMutableArray *_recentArr;
    
    /* 通知信息数组*/
    NSMutableArray *_noticeArray;
    
    /* 是否查看了系统消息*/
    BOOL checkedNotices ;
    
    /*未读消息总数量*/
    NSInteger unreadCont;
    
    
    /* 下拉刷新页数*/
    NSInteger noticePage;
    
    
    /* 未读消息数组*/
    NSMutableArray *unreadArr;
    
    
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
        //        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        //        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_];
        _;
    });
    
    _noticeIndexView = ({
        NoticeIndexView *_=[[NoticeIndexView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64-TabBar_Height)];
        
        _.segmentControl.delegate = self;
        
        _.scrollView.scrollEnabled = NO;
        
        _.scrollView.delegate = self;
        _.scrollView.tag=1;
        
        _.chatListTableView.delegate = self;
        _.chatListTableView.dataSource = self;
        _.chatListTableView.tag=2;
        
        _.noticeTableView.delegate = self;
        _.noticeTableView.dataSource = self;
        _.noticeTableView.tag = 3;
        
        [_.scrollView scrollRectToVisible:CGRectMake(-self.view.width_sd, 0, self.view.width_sd, self.view.height_sd) animated:YES];
        
        [self.view addSubview:_];
        
        _;
        
    });
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.navigationController setNavigationBarHidden:YES];
    
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
    
    noticePage = 1;
    unreadCont = 0;
    
    
    NSLog(@"%@",[[[NIMSDK sharedSDK]teamManager]allMyTeams]);
    
    /* 如果用户加入新的试听课程,或者是用户是第一次进入程序,向远程服务器拉取聊天历史记录*/
    /* 判断是不是第一次登陆*/
    
    /* 获取我的辅导班列表*/
    [self requestMyClass:RefreshStateNone];
    
    /* 请求通知消息,收到的消息存到本地数据库,文件名:notice.db*/
    [self requestNotices:RefreshStateNone];
    
    [[[NIMSDK sharedSDK]loginManager]addDelegate:self];
    
    NSDictionary *chatDic = [[NSUserDefaults standardUserDefaults]valueForKey:@"chat_account"];
    
    [[NIMSDK sharedSDK].loginManager autoLogin:chatDic[@"accid"] token:chatDic[@"token"]];
    
    [[[NIMSDK sharedSDK]conversationManager]addDelegate:self];
    [[[NIMSDK sharedSDK]chatManager]addDelegate:self];
    
    
    /* 消息变为已读的通知*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(markRead:) name:@"MarkAllRead" object:nil];
    
    /* 用户重新登录后的通知*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAgain) name:@"UserLoginAgain" object:nil];
    
    
    /* 下拉刷新功能*/
    
    _noticeIndexView.chatListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        /* 辅导班列表下拉重载*/
        [self requestMyClass:RefreshStatePullRefresh];
        
    }];
    
    _noticeIndexView.noticeTableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        /* 系统消息下拉重载*/
        [self requestNotices:RefreshStatePullRefresh];
    }];
    
    
    /* 上滑加载功能*/
    
    _noticeIndexView.noticeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        /* 系统消息上滑加载更多*/
        [self requestNotices:RefreshStatePushLoadMore];
        
    }];
    
    
}

/* 读取消息后,该页面接受通知消息,tablecell的badge数量变化*/
- (void)markRead:(NSNotification *)notification{
    
    
    
    
}


/* 再次登录成功后获取消息*/
- (void)refreshAgain{
    
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
    
    noticePage = 1;
    unreadCont = 0;
    
    
    NSLog(@"%@",[[[NIMSDK sharedSDK]teamManager]allMyTeams]);
    
    /* 如果用户加入新的试听课程,或者是用户是第一次进入程序,向远程服务器拉取聊天历史记录*/
    /* 判断是不是第一次登陆*/
    
    /* 获取我的辅导班列表*/
    [self requestMyClass:RefreshStateNone];
    
    /* 请求通知消息,收到的消息存到本地数据库,文件名:notice.db*/
    [self requestNotices:RefreshStateNone];
    
    [[[NIMSDK sharedSDK]loginManager]addDelegate:self];
    
    NSDictionary *chatDic = [[NSUserDefaults standardUserDefaults]valueForKey:@"chat_account"];
    
    [[NIMSDK sharedSDK].loginManager autoLogin:chatDic[@"accid"] token:chatDic[@"token"]];
    
    [[[NIMSDK sharedSDK]conversationManager]addDelegate:self];
    [[[NIMSDK sharedSDK]chatManager]addDelegate:self];

}


/* 获取辅导班聊天列表*/
- (void)requestMyClass:(RefreshState)state{
    
    switch (state) {
        case RefreshStatePullRefresh:{
            
            _myClassArray = @[].mutableCopy;
            _chatListArr = @[].mutableCopy;
            
        }
            break;
            
        case RefreshStatePushLoadMore:{
            
        }
            break;
            
        case RefreshStateNone:{
            
            [self loadingHUDStartLoadingWithTitle:@"正在刷新聊天列表"];
        }
            break;
    }
    
    
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/courses",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        [self loginStates:dic];
        
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            
            /* 请求近期聊天会话*/
            _recentArr =  [NSMutableArray arrayWithArray:[[[NIMSDK sharedSDK]conversationManager]allRecentSessions]];
            
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
                        
                        info.notify = [[[NIMSDK sharedSDK]teamManager]notifyForNewMsg:info.classID];
                        
                        NSLog(@"%d",info.notify);
                        
                        info.notify =  [[[NIMSDK sharedSDK]teamManager]notifyForNewMsg:info.chat_team_id];
                        
                        /* 试听已经结束的*/
                        
                        if ([info.taste_count integerValue]<[info.preset_lesson_count integerValue]||info.is_bought == YES) {
                            
                            [_myClassArray addObject:info];
                        }
                        
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
                                    
                                    unreadCont +=session.unreadCount;
                                    
                                }
                                
                                
                            }
                            [_chatListArr addObject:mod];
                            
                        }
                    }
                }
            }
            
            
            if (state == RefreshStatePushLoadMore) {
                
                [_noticeIndexView.chatListTableView.mj_header endRefreshing];
                [_noticeIndexView.chatListTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                
            }else{
                [self loadingHUDStopLoadingWithTitle:@"加载完成"];
                [_noticeIndexView.chatListTableView.mj_header endRefreshing];
                [_noticeIndexView.chatListTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        }else{
            /* 数据错误*/
            
            [self loadingHUDStopLoadingWithTitle:@"数据失败!"];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


/* 请求通知消息*/
- (void)requestNotices:(RefreshState)state{
    
    
    switch (state) {
        case RefreshStatePullRefresh:{
            
            noticePage = 1;
            _noticeArray = @[].mutableCopy;
            
            [_noticeIndexView.noticeTableView.mj_footer resetNoMoreData];
            
        }
            break;
            
        case RefreshStatePushLoadMore:{
            noticePage++;
            
        }
            break;
            
        case RefreshStateNone:{
            
        }
            break;
    }
    
    unreadArr = @[].mutableCopy;
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/users/%@/notifications?page=%ld",Request_Header,_idNumber,noticePage] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        [self loginStates:dic];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 请求成功*/
            NSMutableArray *dataArr = [NSMutableArray arrayWithArray:dic[@"data"]];
            if (dataArr.count == 0) {
                
                if (state!=RefreshStatePushLoadMore) {
                    
                    /* 没有数据*/
                    /* 没有加入聊天的情况*/
                    HaveNoClassView *noNotice = [[HaveNoClassView  alloc]init];
                    noNotice.titleLabel.text = @"当前无通知";
                    noNotice.frame  = CGRectMake(0, 0, self.view.width_sd,_noticeIndexView.scrollView.height_sd);
                    
                    [_noticeIndexView.noticeTableView addSubview:noNotice];
                    _noticeIndexView.noticeTableView.scrollEnabled = NO;
                }else{
                    
                    [_noticeIndexView.noticeTableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                
            }else{
                /* 有数据的情况下*/
                
                for (NSDictionary *dics in dataArr) {
                    SystemNotice *notice = [SystemNotice yy_modelWithJSON:dics];
                    
                    //筛掉订单类型的信息
                    if ([notice.notificationable_type isEqualToString:@"payment/order"]||[notice.action_name isEqualToString:@"refund_success"]||[notice.action_name isEqualToString:@"refund_fail"]) {
                        
                    }else{
                        
                        //其他类型的信息进行加载处理
                        if ([notice.notificationable_type isEqualToString:@"action_record"]) {
                            
                            [notice.notice_content insertString:@"                " atIndex:0];
                        }else{
                            
                            [notice.notice_content insertString:@"          " atIndex:0];
                        }
                        
                        notice.noticeID = dics[@"id"];
                        [_noticeArray addObject:notice];
                    }
                    
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    for (SystemNotice *notice in _noticeArray) {
                        if (notice.read==NO) {
                            
                            [_noticeIndexView.segmentControl showBridgeWithShow:YES index:1];
                            
                            /* 未读消息添加到这个数组*/
                            [unreadArr addObject:notice.noticeID];
                            
                        }
                        
                    }
                });
                
                
                /* 根据不同类型的数据请求方式,加载结果不同,判断hud和数据刷新*/
                if (state == RefreshStatePushLoadMore) {
                    [_noticeIndexView.noticeTableView.mj_header endRefreshing];
                    [_noticeIndexView.noticeTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                    
                }else{
                    [self loadingHUDStopLoadingWithTitle:@"加载完成"];
                    [_noticeIndexView.noticeTableView.mj_header endRefreshing];
                    [_noticeIndexView.noticeTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                }
                
            }
            
        }else{
            /* 请求失败*/
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    noticePage++;
    
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
                
                //                cell.badge.hidden = YES;
            }
            
            if (_chatListArr.count>indexPath.row) {
                cell.model = _chatListArr[indexPath.row];
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                if (cell.noticeOn==YES) {
                    cell.closeNotice.hidden = YES;
                }else if(cell.noticeOn==NO){
                    cell.closeNotice.hidden = NO;
                }
                
                //                UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(resignNotice:)];
                //
                //                [cell addGestureRecognizer:press];
                
                if (cell.model.badge>0) {
                    cell.badge.hidden = NO;
                }else if(cell.model.badge==0){
                    cell.badge.hidden = YES;
                }
                
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
                
                if (cell.model.read == YES) {
                    cell.content.textColor = [UIColor lightGrayColor];
                    //                    cell.time.textColor = [UIColor lightGrayColor];
                }else{
                    cell.content.textColor = [UIColor blackColor];
                    //                    cell.time.textColor = [UIColor blackColor];
                    
                }
                
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
        chatVC.hidesBottomBarWhenPushed = YES;
        [self .navigationController pushViewController:chatVC animated:YES];
        
        NIMSession *recentSession = [NIMSession session:cell.model.tutorium.chat_team_id type:NIMSessionTypeTeam];
        
        [[[NIMSDK sharedSDK]conversationManager]markAllMessagesReadInSession:recentSession];
        
        cell.badge.hidden = YES;
        
        unreadCont -= cell.badgeNumber;
        
        [_chatListArr[indexPath.row] setValue:@0 forKey:@"badge"];
        
    }else if (tableView.tag == 3){
        
        NoticeListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        UIViewController *controller ;
        
        if ([cell.model.notificationable_type isEqualToString:@"live_studio/course"]) {
            //教师公告
            
            controller = [[TutoriumInfoViewController alloc]initWithClassID:[cell.model.link substringFromIndex:19]];
            
            
        }else if ([cell.model.notificationable_type isEqualToString:@"live_studio/lesson"]){
            //辅导班开课通知
            
            controller = [[TutoriumInfoViewController alloc]initWithClassID:[cell.model.link substringFromIndex:19]];
            
        }else if ([cell.model.notificationable_type isEqualToString:@"payment/order"]){
            //订单信息
            
        }
        
        if (controller) {
            
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
        
    }
    
    
}

/* 聊天室的滑动编辑*/
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 2 ) {
        return YES;
    }
    return NO;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 2) {
        
        ChatListTableViewCell *cell = [_noticeIndexView.chatListTableView cellForRowAtIndexPath:indexPath];
        
        NSString *title ;
        
        if (cell.noticeOn == YES) {
            
            title= @"不再提醒";
        }else{
            title = @"恢复提醒";
        }
        
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            if (cell.noticeOn == YES) {
                
                [[[NIMSDK sharedSDK]teamManager]updateNotifyState:NO inTeam:cell.model.tutorium.chat_team_id completion:^(NSError * _Nullable error) {
                    
                    if (error == nil) {
                        cell.closeNotice.hidden = NO;
                        cell.noticeOn = NO;
                        cell.model.tutorium.notify = NO;
                        
                        _chatListArr[indexPath.row].tutorium.notify = NO;
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }
                    
                }];
                
            }else{
                
                [[[NIMSDK sharedSDK]teamManager]updateNotifyState:YES inTeam:cell.model.tutorium.chat_team_id completion:^(NSError * _Nullable error) {
                    
                    if (error == nil) {
                        cell.closeNotice.hidden = YES;
                        cell.noticeOn = YES;
                        cell.model.tutorium.notify = YES;
                        _chatListArr[indexPath.row].tutorium.notify = YES;
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }
                    
                }];
                
                
            }
            
            
            
        }];
        return @[action];
    }
    
    return @[];
}


/* 接收消息和badge变化*/
-(void)onRecvMessages:(NSArray<NIMMessage *> *)messages{
    
    for (NIMMessage *message in messages) {
        
        NSInteger index = 0;
        for (ChatList *chat in _chatListArr) {
            index++;
            if ([message.session.sessionId isEqualToString:chat.tutorium.chat_team_id]){
                chat.badge+=1;
                
                unreadCont +=1;
                
                [_noticeIndexView.chatListTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                
            }
        }
        
    }
    
    /* badge的判断和增加*/
    
    if (_noticeIndexView.segmentControl.selectedIndex == 1) {
        [_noticeIndexView.segmentControl showBridgeWithShow:YES index:0];
    }else{
        [_noticeIndexView.segmentControl showBridgeWithShow:NO index:0];
    }
    
}
- (BOOL)fetchMessageAttachment:(NIMMessage *)message error:(NSError **)error{
    
    NSInteger index = 0;
    for (ChatList *chat in _chatListArr) {
        index++;
        if ([message.session.sessionId isEqualToString:chat.tutorium.chat_team_id]){
            
            chat.badge+=1;
            unreadCont +=1;
            
            [_noticeIndexView.chatListTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        
    }
    
    if (_noticeIndexView.segmentControl.selectedIndex == 1) {
        [_noticeIndexView.segmentControl showBridgeWithShow:YES index:0];
    }else{
        [_noticeIndexView.segmentControl showBridgeWithShow:NO index:0];
    }
    
    return YES;
}


/* segment的滑动回调*/
-(void)didSelectedWithSegement:(JTSegmentControl *)segement index:(NSInteger)index{
    
    typeof(self) __weak weakSelf = self;
    
    [weakSelf.noticeIndexView.scrollView scrollRectToVisible:CGRectMake(self.view.width_sd * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-64) animated:YES];
    
    if (index == 0) {
        [_noticeIndexView.segmentControl showBridgeWithShow:NO index:0];
    }
    
    if (index==1) {
        
        if (unreadArr) {
            
            if (unreadArr.count>0) {
                
                if (checkedNotices==NO) {
                    checkedNotices = YES;
                    
                    /* 异步线程发送已读消息请求*/
                    dispatch_queue_t notice = dispatch_queue_create("notice", DISPATCH_QUEUE_SERIAL);
                    dispatch_sync(notice, ^{
                        
                        
                        __block NSMutableString *idsStr = [NSMutableString string];
                        for (NSString *ids in unreadArr) {
                            
                            [idsStr appendString:[NSString stringWithFormat:@"%@ ",ids]];
                        }
                        
                        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
                        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
                        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
                        [manager PUT:[NSString stringWithFormat:@"%@/api/v1/users/%@/notifications/batch_read",Request_Header,_idNumber] parameters:@{@"ids":idsStr} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            
                            NSError *error = [[NSError alloc]init];
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
                            if ([dic[@"status"]isEqualToNumber:@1]) {
                                
                                [_noticeIndexView.segmentControl showBridgeWithShow:NO index:1];
                                
                            }else{
                                
                                
                            }
                            
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            
                            NSLog(@"%@", error.description);
                            
                            
                        }];
                    
                        
                    });
                    
                }else{
                    
                }
                
                
            }
            
            
        }else{
            [_noticeIndexView.segmentControl showBridgeWithShow:NO index:0];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AllMessageRead" object:nil];
            
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
