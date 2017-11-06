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
#import "Interactive.h"
#import "CYLTableViewPlaceHolder.h"
#import "UIViewController+Token.h"
#import "ExclusiveInfo.h"

typedef enum : NSUInteger {
    RefreshStatePushLoadMore,
    RefreshStatePullRefresh,
    RefreshStateNone,
} RefreshState;


@interface NoticeIndexViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,NIMConversationManagerDelegate,NIMLoginManagerDelegate,UIGestureRecognizerDelegate,JTSegmentControlDelegate,NIMChatManagerDelegate>{
    
    NavigationBar *_navigationBar;
    
    __block NSInteger _totalUnreadCount;
    
}

@end

@implementation NoticeIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNDGRAY;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.navigationController setNavigationBarHidden:YES];
    [self makeData];
    [self setupMainView];
    
    /* 消息变为已读的通知*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(markRead:) name:@"MarkAllRead" object:nil];
    
    /* 用户重新登录后的通知*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAgain) name:@"UserLoginAgain" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAgain) name:@"UserLogin" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAgain) name:@"WechatLoginSucess" object:nil];
    
    
    //监听未读消息数量
    
//    [self addObserver:self forKeyPath:@"unreadCountStr" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showNIMPage:) name:@"PushIM" object:nil];
    
}

- (void)makeData{
    
    _totalUnreadCount = 0;
}

- (void)setupMainView{
    _navigationBar = ({
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
        _.titleLabel.text = @"消息中心";
        [self.view addSubview:_];
        _;
    });
    
    _noticeIndexView = ({
        NoticeIndexView *_=[[NoticeIndexView alloc]initWithFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd-Navigation_Height-TabBar_Height)];
        _.segmentControl.delegate = self;
        _.scrollView.delegate = self;
        _.scrollView.tag=1;
        [self.view addSubview:_];
        _;
    });
    
    typeof(self) __weak weakSelf = self;
    
    _chatList = [[ChatListViewController alloc]init];
    [_noticeIndexView.scrollView addSubview:_chatList.view];
    _chatList.view.sd_layout
    .leftSpaceToView(_noticeIndexView.scrollView, 0)
    .topSpaceToView(_noticeIndexView.scrollView, 0)
    .bottomSpaceToView(_noticeIndexView.scrollView, 0)
    .widthRatioToView(_noticeIndexView.scrollView, 1.0);
    _chatList.pushBlock = ^(UIViewController *controller) {
        [weakSelf.navigationController pushViewController:controller animated:YES];
    };

    _chatList.unreadChatMessageCountPlus = ^(NSInteger unreadCount) {
        _totalUnreadCount += unreadCount;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ReceiveNewNotice" object:nil];
    };
    
    _chatList.unreadChatMessageCountMinus = ^(NSInteger unreadCount) {
        _totalUnreadCount -= unreadCount;
        if (unreadCount<=0) {
            _totalUnreadCount = 0;
            //同时得隐藏item的badge
            weakSelf.tabBarItem.badgeValue = nil;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AllMessageRead" object:nil];
        }
    };
    
    _noticeList = [[NoticeListViewController alloc]init];
    [_noticeIndexView.scrollView addSubview:_noticeList.view];
    _noticeList.view.sd_layout
    .leftSpaceToView(_chatList.view, 0)
    .topEqualToView(_chatList.view)
    .bottomEqualToView(_chatList.view)
    .widthRatioToView(_chatList.view, 1.0);
     [_noticeIndexView.scrollView setupAutoContentSizeWithRightView:_noticeList.view rightMargin:0];
    _noticeList.pushBlock = ^(UIViewController *controller) {
        [weakSelf.navigationController pushViewController:controller animated:YES];
    };
    
    //有未读消息 -> 增加未读消息数量
    _noticeList.unreadSystemNoticeCountPlus = ^(NSInteger unreadCount) {
        //跟这儿加载一下badge.
        [weakSelf.noticeIndexView.segmentControl showBridgeWithShow:YES index:1];
        _totalUnreadCount += unreadCount;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ReceiveNewNotice" object:nil];
    };
    
    //未读消息数量减少
    _noticeList.unreadSystemNoticeCountMinus = ^(NSInteger unreadCount) {
        _totalUnreadCount -= unreadCount;
        if (unreadCount<=0) {
            _totalUnreadCount = 0;
            [weakSelf.noticeIndexView.segmentControl showBridgeWithShow:NO index:1];
            //同时得隐藏item的badge
            weakSelf.tabBarItem.badgeValue = nil;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AllMessageRead" object:nil];
        }
    };
}

- (void)showNIMPage:(NSNotification *)notification{
    
    ChatViewController *controller = [notification object];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}


/* 读取消息后,该页面接受通知消息,tablecell的badge数量变化*/
- (void)markRead:(NSNotification *)notification{
    
    
}


/* 再次登录成功后获取消息*/
- (void)refreshAgain{
    
    [[[NIMSDK sharedSDK]loginManager]addDelegate:self];
    
    NSDictionary *chatDic = [[NSUserDefaults standardUserDefaults]valueForKey:@"chat_account"];
    [[NIMSDK sharedSDK].loginManager autoLogin:chatDic[@"accid"] token:chatDic[@"token"]];
    [[[NIMSDK sharedSDK]conversationManager]addDelegate:self];
    [[[NIMSDK sharedSDK]chatManager]addDelegate:self];
    
}


/* segment的滑动回调*/
-(void)didSelectedWithSegement:(JTSegmentControl *)segement index:(NSInteger)index{
    
    typeof(self) __weak weakSelf = self;
    
    [weakSelf.noticeIndexView.scrollView scrollRectToVisible:CGRectMake(self.view.width_sd * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-Navigation_Height) animated:YES];
    
    if (index == 0) {
        [_noticeIndexView.segmentControl showBridgeWithShow:NO index:1];
    }
    if (index == 1) {
//        [_noticeIndexView.segmentControl showBridgeWithShow:NO index:1];
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView ==  _noticeIndexView.scrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        _noticeIndexView.segmentControl .selectedIndex = page;
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
