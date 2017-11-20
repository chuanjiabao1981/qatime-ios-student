//
//  ChatListViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/10/30.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ChatListViewController.h"
#import "NetWorkTool.h"
#import <NIMSDK/NIMSDK.h>
#import "ChatViewController.h"

typedef enum : NSUInteger {
    RefreshStatePushLoadMore,
    RefreshStatePullRefresh,
} RefreshState;

@interface ChatListViewController ()<UITableViewDelegate ,UITableViewDataSource,NIMLoginManagerDelegate,NIMConversationManagerDelegate,NIMChatManagerDelegate>{
    
    /* 我的辅导班列表*/
    NSMutableArray *_myClassArray;
    
    /* 聊天列表*/
    NSMutableArray <ChatList *>*_chatListArr;
    
    /* 最近会话的数组*/
    NSMutableArray *_recentArr;
    
}

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeData];
    [self setupMainView];
    
    /* 如果用户加入新的试听课程,或者是用户是第一次进入程序,向远程服务器拉取聊天历史记录*/
    /* 判断是不是第一次登陆*/
    
    [[[NIMSDK sharedSDK]loginManager]addDelegate:self];
    
    NSDictionary *chatDic = [[NSUserDefaults standardUserDefaults]valueForKey:@"chat_account"];
    
    [[NIMSDK sharedSDK].loginManager autoLogin:chatDic[@"accid"] token:chatDic[@"token"]];
    
    [[[NIMSDK sharedSDK]conversationManager]addDelegate:self];
    [[[NIMSDK sharedSDK]chatManager]addDelegate:self];
    
    /* 获取我的辅导班列表*/
    [_mainView.mj_header beginRefreshing];
    
}

- (void)makeData{
    
    _myClassArray = @[].mutableCopy;
    _chatListArr = @[].mutableCopy;
    _recentArr = @[].mutableCopy;
    
}

- (void)setupMainView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    _mainView = [[UITableView alloc]init];
    _mainView.tableHeaderView = [[UIView alloc]init];
    _mainView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    _mainView.delegate = self;
    _mainView.dataSource = self;
    _mainView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestMyClass:RefreshStatePullRefresh];
        [_mainView.mj_footer resetNoMoreData];
    }];
}

/* 获取辅导班聊天列表*/
- (void)requestMyClass:(RefreshState)state{
    
    switch (state) {
        case RefreshStatePullRefresh:{
            _myClassArray = @[].mutableCopy;
            _chatListArr = [NSMutableArray array];
        }
            break;
        case RefreshStatePushLoadMore:{
            
        }
            break;
    }
    
    //请求直播课聊天会话列表
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[self getToken] forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/courses",Request_Header,[self getStudentID]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        [self loginStates:dic];
        
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            
            /* 请求云信近期聊天会话*/
            _recentArr =  [NSMutableArray arrayWithArray:[[[NIMSDK sharedSDK]conversationManager]allRecentSessions]];
            
            /**再请求一次一对一聊天数据*/
            [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/interactive_courses",Request_Header,[self getStudentID]] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
                
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                if ([dataDic[@"status"]isEqualToNumber:@1]) {
                    if ([dic[@"data"] count ] ==0 && [dataDic[@"data"]count]==0) {
                        [_mainView cyl_reloadData];
                    }else{
                        if (_myClassArray) {
                            /* 获取近期会话的未读消息等数据*/
                            NSMutableArray *dicArr =[NSMutableArray arrayWithArray: dic[@"data"]];
                            
                            [dicArr addObjectsFromArray:[NSMutableArray arrayWithArray:dataDic[@"data"]]];
                            
                            //在这儿再请求一次近期小班课
                            [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/customized_groups",Request_Header,[self getStudentID]] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil withProgress:^(NSProgress * _Nullable progress) {} completeSuccess:^(id  _Nullable responds) {
                                
                                NSDictionary *clasDic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                                if ([clasDic[@"status"]isEqualToNumber:@1]) {
                                    [dicArr addObjectsFromArray:clasDic[@"data"]];
                                    
                                    //制作chatlist数组
                                    for (NSDictionary *tutorium in dicArr) {
                                        /**
                                         用teachers字段进行区分课程类型
                                         */
                                        if (![[tutorium allKeys]containsObject:@"teachers"]) {
                                            //不包含就是直播课/小班课
                                            if ([[tutorium allKeys]containsObject:@"customized_group"]) {
                                                //小班课
                                                //这儿得好好研究研究怎么改改
                                                ExclusiveInfo *exclusive = [ExclusiveInfo yy_modelWithJSON:tutorium[@"customized_group"]];
                                                exclusive.classID =tutorium[@"customized_group"][@"id"];
                                                exclusive.notify = YES;
                                                exclusive.notifyState =[[[NIMSDK sharedSDK]teamManager]notifyStateForNewMsg:exclusive.chat_team_id];
                                                [_myClassArray addObject:exclusive];
                                            }else{
                                                TutoriumListInfo *info = [TutoriumListInfo yy_modelWithJSON:tutorium];
                                                info.classID = tutorium[@"id"];
                                             
                                                info.notify = [[[NIMSDK sharedSDK]teamManager]notifyStateForNewMsg:info.chat_team_id];
                                                
                                                info.notifyState = [[[NIMSDK sharedSDK]teamManager]notifyStateForNewMsg:info.chat_team_id];
                                                
                                                /* 已购买的或者试听尚未结束的 ,加入聊天列表*/
                                                if ([info.taste_count integerValue]<[info.preset_lesson_count integerValue]||info.is_bought == YES) {
                                                    [_myClassArray addObject:info];
                                                }
                                            }
                                            
                                        }else{
                                            //包含就是一对一
                                            InteractiveCourse  *mod = [InteractiveCourse yy_modelWithJSON:tutorium ];
                                            mod.classID = tutorium[@"id"];
                                            mod.notify = [[[NIMSDK sharedSDK]teamManager]notifyStateForNewMsg:mod.chat_team_id];
                                            mod.notifyState = [[[NIMSDK sharedSDK]teamManager]notifyStateForNewMsg:mod.chat_team_id];
                                            [_myClassArray addObject:mod];
                                        }
                                    }
                                    
                                    if (_myClassArray&&_recentArr) {
                                        
                                        /* 把badge结果遍历给chatlist的cell*/
                                        
                                        //同时也是制作chatlist的方法. 2017.7.5重写
                                        for (id obj in _myClassArray) {
                                            
                                            if ([obj isMemberOfClass:[TutoriumListInfo class]]) {
                                                
                                                ChatList *mod = [[ChatList alloc]init];
                                                mod.tutorium = (TutoriumListInfo *)obj;
                                                mod.name = [(TutoriumListInfo *)obj valueForKeyPath:@"name"];
                                                mod.classType = LiveCourseType;
                                                //根据该条课程类型和teamid,来查找该team里的未读消息数量
                                                for (NIMRecentSession *session in _recentArr) {
                                                    if ([session.session.sessionId isEqualToString:[(TutoriumListInfo *)obj valueForKeyPath:@"chat_team_id"]]) {
                                                        mod.badge = session.unreadCount;
                                                        mod.lastTime = session.lastMessage.timestamp;
                                                    }
                                                    if (mod.badge>0) {
                                                        self.unreadChatMessageCountPlus(mod.badge);
                                                    }
                                                }
                                                [(NSMutableArray *)_chatListArr addObject:mod];
                                                
                                            }else if ([obj isMemberOfClass:[InteractiveCourse class]]){
                                                ChatList *mod = [[ChatList alloc]init];
                                                mod.interaction = (InteractiveCourse *)obj;
                                                mod.name = [(InteractiveCourse *)obj valueForKeyPath:@"name"];
                                                mod.classType = InteractionCourseType;
                                                
                                                for (NIMRecentSession *session in _recentArr) {
                                                    if ([session.session.sessionId isEqualToString:[(InteractiveCourse *)obj valueForKeyPath:@"chat_team_id"]]) {
                                                        mod.badge = session.unreadCount;
                                                        mod.lastTime = session.lastMessage.timestamp;
                                                    }
                                                    
                                                }
                                                if (mod.badge>0) {
                                                    self.unreadChatMessageCountPlus(mod.badge);
                                                }
                                                [(NSMutableArray *)_chatListArr addObject:mod];
                                                
                                            }else if ([obj isMemberOfClass:[ExclusiveInfo class]]){
                                                ChatList *mod = [[ChatList alloc]init];
                                                mod.exclusive = (ExclusiveInfo *)obj;
                                                mod.name = [(ExclusiveInfo *)obj valueForKeyPath:@"name"];
                                                mod.classType = ExclusiveCourseType;
                                                [(NSMutableArray *)_chatListArr addObject:mod];
                                            }
                                        }
                                        
                                        /**
                                         在这儿进行一次_chatListArr的排序
                                         根据数组里的每一个元素(ChatList类型)的lastTime属性进行比较
                                         */
                                        NSMutableArray *tempArr = _chatListArr.mutableCopy;
                                        _chatListArr = (NSMutableArray *)[tempArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                                            
                                            ChatList *mod1 = (ChatList *)obj1;
                                            ChatList *mod2 = (ChatList *)obj2;
                                            
                                            if (mod1.lastTime<mod2.lastTime) {
                                                
                                                // 按时间戳降序排列
                                                return NSOrderedDescending;
                                            }else{
                                                
                                                // 相同不变
                                                return NSOrderedSame;
                                            }
                                        }].mutableCopy;
                                        
                                        for (ChatList *mod in _chatListArr) {
                                            NSLog(@"%f",mod.lastTime);
                                        }
                                    }
                                    if (state == RefreshStatePushLoadMore) {
                                        [_mainView.mj_header endRefreshing];
                                        [_mainView cyl_reloadData];
                                        
                                    }else{
                                        [self HUDStopWithTitle:nil];
                                        [self HUDStopWithTitle:nil];
                                        
                                        [_mainView.mj_header endRefreshing];
                                        [_mainView cyl_reloadData];
                                    }
                                }else{
                                    /* 数据错误*/
                                    
                                    [self HUDStopWithTitle:@"加载失败,请稍后重试!"];
                                    [_mainView.mj_header endRefreshing];
                                    [_mainView cyl_reloadData];
                                }
                                
                            } failure:^(id  _Nullable erros) {
                                [_mainView.mj_header endRefreshing];
                                [_mainView cyl_reloadData];
                            }];
                            
                        }
                    }
                }
                
            }failure:^(id  _Nullable erros) {
                [_mainView.mj_header endRefreshing];
                [_mainView cyl_reloadData];
            }];
            
        }else{
            /* 数据错误*/
            [self HUDStopWithTitle:@"加载失败,请稍后重试!"];
            [_mainView.mj_header endRefreshing];
            [_mainView cyl_reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_mainView.mj_header endRefreshing];
        [_mainView cyl_reloadData];
    }];
}



#pragma mark- tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _chatListArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdenfier = @"cell";
    ChatListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[ChatListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (_chatListArr.count>indexPath.row) {
        cell.model = _chatListArr[indexPath.row];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        
        if (cell.noticeOn==YES) {
            cell.closeNotice.hidden = YES;
            if (cell.model.badge>0) {
                cell.badge.hidden = NO;
            }else if(cell.model.badge==0){
                cell.badge.hidden = YES;
            }
        }else if(cell.noticeOn==NO){
            cell.closeNotice.hidden = NO;
            cell.badge.hidden = YES;
        }
    }
    return  cell;
}


#pragma mark- tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  70*ScrenScale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __block ChatViewController *chatVC;
    ChatListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.model.tutorium.name==nil) {
        if (cell.model.interaction.name!=nil) {
            chatVC = [[ChatViewController alloc]initWithClass:cell.model.interaction andClassType:cell.model.classType];
        }else if (cell.model.exclusive.name !=nil){
            [self HUDStartWithTitle:nil];
            [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/customized_groups/%@/play",Request_Header,cell.model.exclusive.classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil withProgress:^(NSProgress * _Nullable progress) {} completeSuccess:^(id  _Nullable responds) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                if ([dic[@"status"]isEqualToNumber:@1]) {
                    [self HUDStopWithTitle:nil];
                    cell.model.exclusive.chat_team_id = dic[@"data"][@"customized_group"][@"chat_team"][@"team_id"];
                    chatVC = [[ChatViewController alloc]initWithClass:cell.model.exclusive andClassType:cell.model.classType];
                    chatVC.hidesBottomBarWhenPushed = YES;
                    self.pushBlock(chatVC);
                }else{
                    [self HUDStopWithTitle:@"请稍后再试"];
                }
                
            } failure:^(id  _Nullable erros) {
                [self HUDStopWithTitle:@"请检查网络"];
            }];
        }
    }else{
        if (cell.model.tutorium.name!=nil) {
            
            chatVC = [[ChatViewController alloc]initWithClass:cell.model.tutorium andClassType:cell.model.classType];
        }
    }
    chatVC.hidesBottomBarWhenPushed = YES;
    self.pushBlock(chatVC);
    NIMSession *recentSession = [NIMSession session:cell.model.tutorium.chat_team_id type:NIMSessionTypeTeam];
    
    [[[NIMSDK sharedSDK]conversationManager]markAllMessagesReadInSession:recentSession];
    
    cell.badge.hidden = YES;
    if (cell.model.badge >0) {
        self.unreadChatMessageCountMinus(cell.model.badge);
    }
    [_chatListArr[indexPath.row] setValue:@0 forKey:@"badge"];
    
}

/* 聊天室的滑动编辑*/
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setEditing:NO animated:YES];
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatListTableViewCell *cell = [_mainView cellForRowAtIndexPath:indexPath];
    
    NSString *title ;
    
    if (cell.noticeOn == YES) {
        
        title= @"不再提醒";
    }else{
        title = @"恢复提醒";
    }
    
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSString *sendID;
        if (cell.model.tutorium.name == nil) {
            sendID = cell.model.interaction.chat_team_id;
        }else{
            sendID = cell.model.tutorium.chat_team_id;
        }
        
        if (cell.noticeOn == YES) {
            
            [[[NIMSDK sharedSDK]teamManager]updateNotifyState:NO inTeam:sendID completion:^(NSError * _Nullable error) {
                
                if (error == nil) {
                    cell.closeNotice.hidden = NO;
                    cell.noticeOn = NO;
                    cell.model.tutorium.name==nil?[cell.model.interaction setNotify:NO]:[cell.model.tutorium setNotify:NO];
                    cell.model.tutorium.notifyState = NIMTeamNotifyStateNone;
                    _chatListArr[indexPath.row].tutorium.name==nil?[_chatListArr[indexPath.row].interaction setNotify:NO]:[_chatListArr[indexPath.row].tutorium setNotify:NO];
                    _chatListArr[indexPath.row].tutorium.name==nil?[_chatListArr[indexPath.row].interaction setNotifyState: NIMTeamNotifyStateNone]:[_chatListArr[indexPath.row].tutorium setNotifyState:NIMTeamNotifyStateNone];
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }else{
                    
                    NSLog(@"%@", error);
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self HUDStopWithTitle:@"修改失败"];
                }
                
            }];
            
        }else{
            
            [[[NIMSDK sharedSDK]teamManager]updateNotifyState:YES inTeam:sendID completion:^(NSError * _Nullable error) {
                
                if (error == nil) {
                    cell.closeNotice.hidden = YES;
                    cell.noticeOn = YES;
                    
                    cell.model.tutorium.name==nil?[cell.model.interaction setNotify:YES]:[cell.model.tutorium setNotify:YES];
                    cell.model.tutorium.notifyState = NIMTeamNotifyStateAll;
                    _chatListArr[indexPath.row].tutorium.name==nil?[_chatListArr[indexPath.row].interaction setNotify:YES]:[_chatListArr[indexPath.row].tutorium setNotify:YES];
                    _chatListArr[indexPath.row].tutorium.name==nil?[_chatListArr[indexPath.row].interaction setNotifyState: NIMTeamNotifyStateAll]:[_chatListArr[indexPath.row].tutorium setNotifyState:NIMTeamNotifyStateAll];
                    
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }else{
                    
                    NSLog(@"%@", error);
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self HUDStopWithTitle:@"修改失败"];
                    
                }
                
            }];
        }
        
    }];
    return @[action];
}

/* 接收消息和badge变化*/
-(void)onRecvMessages:(NSArray<NIMMessage *> *)messages{
    
    for (NIMMessage *message in messages) {
        NSInteger index = 0;
        for (ChatList *chat in _chatListArr) {
            index++;
            if ([message.session.sessionId isEqualToString:chat.tutorium.chat_team_id]){
                chat.badge+=1;
                chat.lastTime = message.timestamp;
                [_mainView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
    self.unreadChatMessageCountPlus(messages.count);
    //进行一次排序
    NSMutableArray *tempArr = _chatListArr.mutableCopy;
    _chatListArr = (NSMutableArray *)[tempArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        ChatList *mod1 = (ChatList *)obj1;
        ChatList *mod2 = (ChatList *)obj2;
        
        if (mod1.lastTime<mod2.lastTime) {
            
            // 按时间戳降序排列
            return NSOrderedDescending;
        }else{
            
            // 相同不变
            return NSOrderedSame;
        }
    }].mutableCopy;
    
    [_mainView cyl_reloadData];
    [_mainView setNeedsDisplay];
    
    /* badge的判断和增加*/
    
}
- (BOOL)fetchMessageAttachment:(NIMMessage *)message error:(NSError **)error{
    
    NSInteger index = 0;
    for (ChatList *chat in _chatListArr) {
        index++;
        if ([message.session.sessionId isEqualToString:chat.tutorium.chat_team_id]){
            chat.badge+=1;
            self.unreadChatMessageCountPlus(1);
            [_mainView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }

    return YES;
}



- (UIView *)makePlaceHolderView{
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"暂无数据"];
    return view;
}

- (BOOL)enableScrollWhenPlaceHolderViewShowing{
    return YES;
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
