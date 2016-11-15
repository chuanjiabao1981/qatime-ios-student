//
//  VideoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/10.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "VideoViewController.h"
#import "UIViewController+ZFPlayerRotation.h"
#import "UITabBarController+ZFPlayerRotation.h"
#import "UINavigationController+ZFPlayerRotation.h"
#import "NavigationBar.h"

#import <MediaPlayer/MediaPlayer.h>
#import "RDVTabBarController.h"
#import "VideoClassInfo.h"
#import "YYModel.h"
#import "NoticeAndMembers.h"
#import "Notice.h"
#import "Members.h"
#import "NoticeTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "ClassesListTableViewCell.h"
#import "ClassList.h"
#import "Teacher.h"
#import "Chat_Account.h"
#import "Classes.h"
#import "UIImageView+WebCache.h"





@interface VideoViewController ()<ZFPlayerControlViewDelagate,ZFPlayerDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

{
    
    NavigationBar *_navigationBar;
    
    ZFPlayerModel *_playerModel;
    
    /* token*/
    
    NSString *_remember_token;
    
    /* 课程model*/
    
    VideoClassInfo *_videoClassInfo;
    
    /* 通知消息model*/
    NoticeAndMembers *_noticeAndMembers;
    
    
    /*消息model*/
    Notice *_notices;
    /* 存放消息的数组*/
    NSMutableArray  <Notice *>*_noticesArr;
    
    
    /* 成员model*/
    
    Members *_members;
    /* 存放member的数组*/
    NSMutableArray <Members *>*_membersArr;
    
    /* 课程 model*/
    Classes *_classes;
    
    /* 保存课程model的数组*/
    NSMutableArray *_classesArr;
    
    /* teacher model*/
    Teacher *_teacher;
    
    /* 聊天账号信息model*/
    Chat_Account *_chat_Account;
    
    
    
    
    
    /* tableView的header高度*/
    
    CGFloat headerHeight;
    
    
    
    
    
    ClassList *_classList;
    
}

@end

@implementation VideoViewController

- (instancetype)initWithClassID:(NSString *)classID
{
    self = [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
    _navigationBar = [[NavigationBar alloc]init];
    [self.view addSubview:_navigationBar];
    
    _navigationBar.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(64);
    
    /* 取出token*/
    
    _remember_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"];
    //    测试用id
    _classID = @"25" ;
    
    
    
    self.playerView = [[ZFPlayerView alloc] init];
    self.playerView.hasPreviewView = YES;
    
    //测试代码  另一个视频播放器
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
    [self.view addSubview:self.playerView];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(64);
        make.left.right.equalTo(self.view);
        
        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    
    
    // 指定控制层（可自定义）
    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    self.playerView.controlView = controlView;
    
    
    _playerModel = [[ZFPlayerModel alloc]init];
    _playerModel.videoURL =[NSURL URLWithString:@"http://baobab.wdjcdn.com/14571455324031.mp4"];
    
    
    // 设置视频model
    self.playerView.playerModel = _playerModel;
    // 设置代理
    self.playerView.delegate= self;
    
    [self.playerView autoPlayTheVideo];
    
    
    
    
    
    
    
    
    
#pragma mark- 课程信息视图
    _videoInfoView = [[VideoInfoView alloc]init];
    [self.view addSubview:_videoInfoView];
    _videoInfoView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.playerView,0)
    .bottomSpaceToView(self.view,0);
    
    _videoInfoView.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*4, [UIScreen mainScreen].bounds.size.height -  [UIScreen mainScreen].bounds.size.width*9/16.0f-64-30-4);
    
    
    typeof(self) __weak weakSelf = self;
    [ _videoInfoView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.videoInfoView.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.view.bounds) * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-64-49) animated:YES];
    }];
    
    _videoInfoView.scrollView.delegate = self;
    _videoInfoView.segmentControl.selectedSegmentIndex =0;
    _videoInfoView.segmentControl.selectionIndicatorHeight =2.0f;
    _videoInfoView.scrollView.bounces=NO;
    _videoInfoView.scrollView.alwaysBounceVertical=NO;
    _videoInfoView.scrollView.alwaysBounceHorizontal=NO;
    
    [_videoInfoView.scrollView scrollRectToVisible:CGRectMake(-CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) animated:YES];
    
    _videoInfoView.noticeTabelView.tag =1;
    _videoInfoView.noticeTabelView .delegate = self;
    _videoInfoView.noticeTabelView.dataSource = self;
    

    
    _classList = [[ClassList alloc]init];
    [_videoInfoView.view3 addSubview:_classList];
    _classList.sd_layout
    .leftEqualToView(_videoInfoView.view3)
    .rightEqualToView(_videoInfoView.view3)
    .topEqualToView(_videoInfoView.view3)
    .bottomEqualToView(_videoInfoView.view3);
    
    
    
    
    _classList.classListTableView.delegate =self;
    _classList.classListTableView.dataSource =self;
    _classList.classListTableView.tag =2;
    
    
    /* view3控制器tableview的头视图*/
    
    
    
//    _videoInfoView.noticeTabelView.tableHeaderView = headv;
    
    
    
    
    _infoHeaderView = [[InfoHeaderView alloc]initWithFrame:CGRectMake(0, 0, _videoInfoView.view3.frame.size.width, 800)];
    
    /* 加入高度变化的监听*/
    [self addObserver:self forKeyPath:@"headerHeight" options:NSKeyValueObservingOptionNew context:nil];
    
    
    _classList.classListTableView.tableHeaderView = _infoHeaderView;

    
    
    
    /* 根据token和传来的id 发送课程内容请求。*/
    [self requestClassInfo];
    _notices = [[Notice alloc]init];
    _noticesArr = @[].mutableCopy;
    _members = [[Members alloc]init];
    _membersArr = @[].mutableCopy;
    _classesArr = @[].mutableCopy;
    
    
    
    
}





#pragma mark- 请求课程和和内容
- (void)requestClassInfo{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_remember_token forHTTPHeaderField:@"Remember-Token"];
    
    [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses/%d/realtime",34] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *status = [NSString stringWithFormat:@"%@",[dic valueForKey:@"status"]];
        
        NSLog(@"%@",dic);
        
        
        if (![status isEqualToString:@"1"]) {
            
        }else{
            //        使用yymodel解
            _noticeAndMembers = [NoticeAndMembers yy_modelWithDictionary:dic[@"data"]];
            NSLog(@"%@,@%@",_noticeAndMembers.announcements,_noticeAndMembers.members);
            
            _noticesArr=[_noticeAndMembers valueForKey:@"announcements"];
            
            NSLog(@"%@",_noticesArr);
            
            
            _membersArr = [_noticeAndMembers valueForKey:@"members"];
            NSLog(@"%@",_membersArr);
            
            [self updateViewsNotice];
            
            
        }
        
        
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_remember_token forHTTPHeaderField:@"Remember-Token"];
        [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses/%d/play_info",25] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSString *status = [NSString stringWithFormat:@"%@",[dic valueForKey:@"status"]];
            
            NSDictionary *dataDic=[NSDictionary dictionaryWithDictionary:dic[@"data"]];
            
            NSLog(@"%@",dic);
            
            if (![status isEqualToString:@"1"]) {
                /* 请求错误*/
                
            }else{
                
                /* 解析 课程 数据*/
                _videoClassInfo = [VideoClassInfo yy_modelWithDictionary:dataDic];
//                _classes = [Classes yy_modelWithJSON:dataDic[@"lessons"]];
                
                /* 解析 教师 数据*/
                _teacher = [Teacher yy_modelWithDictionary:dataDic[@"teacher"]];
                /* 解析 聊天账号 数据*/
                _chat_Account = [Chat_Account yy_modelWithDictionary:[dataDic[@"teacher"]valueForKey:@"chat_account"]];
                
                /* 保存课程信息*/
                _classesArr = dataDic[@"lessons"];
                
                NSLog(@"%@",_videoClassInfo);
                _videoClassInfo.classID = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"id"]];
                
                _videoClassInfo.classDescription = [NSString  stringWithFormat:@"%@",[dataDic valueForKey:@"description"]];
                
                /* 课程图的信息赋值*/
                _infoHeaderView.classNameLabel.text = _videoClassInfo.name;
                _infoHeaderView.gradeLabel.text = _videoClassInfo.grade;
                _infoHeaderView.completed_conunt.text = _videoClassInfo.completed_lesson_count;
                _infoHeaderView.classCount.text = _videoClassInfo.lesson_count;
                _infoHeaderView.subjectLabel.text = _videoClassInfo.subject;
                _infoHeaderView.onlineVideoLabel.text = _videoClassInfo.status;
                _infoHeaderView.liveStartTimeLabel.text = _videoClassInfo.live_start_time;
                _infoHeaderView.liveEndTimeLabel.text = _videoClassInfo.live_end_time;
                _infoHeaderView.classDescriptionLabel.text = _videoClassInfo.classDescription;
                
                
                /* 教师信息 赋值*/
                _infoHeaderView.teacherNameLabel.text =_teacher.name;
                _infoHeaderView.teaching_year.text = _teacher.teaching_years;
                _infoHeaderView.workPlace .text = _teacher.school;
                [_infoHeaderView.teacherHeadImage sd_setImageWithURL:[NSURL URLWithString:_teacher.avatar_url]];
//                _infoHeaderView.selfInterview.text = _teacher.desc;
                 _infoHeaderView.selfInterview.text = @"类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上类上";
               
                [_infoHeaderView layoutIfNeeded];
                
                                
              
                /* 自动赋值高度*/
                
                NSNumber *height =[NSNumber numberWithFloat: _infoHeaderView.layoutLine.frame.origin.y];
                
                [self setValue:height forKey:@"headerHeight"];
                
                
                
                [self updateViewsInfos];
                
                
                
                
            }
            
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        
        
    }];
    
    
    
    
    
    
}


/* 高度变化的监听回调*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSLog(@"%@",change);
    headerHeight = [[change valueForKey:@"new"] floatValue];
    
    [_infoHeaderView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), headerHeight)];
    
    _classList.classListTableView.tableHeaderView =_infoHeaderView;
    
    _classList.classListTableView.tableHeaderView.height_sd =headerHeight;
    
    NSLog(@"%@", [_classList.classListTableView.tableHeaderView valueForKey:@"frame"]);
    
    
    NSLog(@"%f", _infoHeaderView.layoutLine.autoHeight);
    
    NSLog(@"%@",[_infoHeaderView.workPlace valueForKey:@"frame"]);
    NSLog(@"%@",[_infoHeaderView.layoutLine valueForKey:@"frame"]);

    
    
    
    [self updateViewsInfos];
    
    
}

/* 刷新视图*/

- (void)updateViewsNotice{
    
    [_videoInfoView.noticeTabelView reloadData];
    [_videoInfoView.noticeTabelView setNeedsDisplay];
    [_videoInfoView.noticeTabelView setNeedsLayout];

}

- (void)updateViewsInfos{
    
    
    [_classList.classListTableView reloadData];
    [_classList.classListTableView  setNeedsDisplay];
    [_classList.classListTableView  setNeedsLayout];
    
    
    
    
}




#pragma mark- tableview的代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    NSLog(@"rows:%lu",(unsigned long)_noticesArr.count);
    
    
    NSInteger rows=0;
    
    if (tableView.tag==1) {
        
        if (_noticesArr.count==0) {
            rows = 0;
        }else{
            
            rows=_noticesArr.count;
        }
    }
    
   if (tableView.tag ==2) {
       if (_classesArr.count==0) {
           rows = 0;
       }else{
           
           rows=_classesArr.count;
       }

      
           
       
       
    }

    NSLog(@"%ld",rows);
    
    return rows;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
//    NSInteger heights = 0;
    
    
    if (tableView.tag==1) {
        Notice *model =[Notice yy_modelWithJSON:_noticesArr[indexPath.row]];
        // 获取cell高度
     return  [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[NoticeTableViewCell class] contentViewWidth: [UIScreen mainScreen].bounds.size.width];
        
    }
    
    
    if (tableView.tag ==2) {
        if (_classesArr.count ==0) {
            
        }else{
            
            Classes *mod =[Classes yy_modelWithJSON: _classesArr[indexPath.row]];
            // 获取cell高度
            return  [tableView cellHeightForIndexPath:indexPath model:mod keyPath:@"classModel" cellClass:[ClassesListTableViewCell class] contentViewWidth: [UIScreen mainScreen].bounds.size.width];
            
        }
        
    }
    return 0;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    
    static NSString *cellIdenfier = @"cell";
    
    static NSString *cellID = @"cellID";
    
    
    UITableViewCell *tableCell = [[UITableViewCell alloc]init];
    
    if (tableView.tag == 1) {
        NoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[NoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            
            if (_noticesArr.count==0) {
                
            }else{
                
                Notice *mod =[Notice yy_modelWithJSON: _noticesArr[indexPath.row]];
                NSLog(@"%@",_noticesArr[indexPath.row]);
                
                cell.model = mod;
                cell.sd_tableView = tableView;
                cell.sd_indexPath = indexPath;
                
            }
        }
        
        return cell;
    }
    
    
    if (tableView.tag ==2) {
        
        /* cell的重用队列*/
        
        ClassesListTableViewCell * idcell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (idcell==nil) {
            idcell=[[ClassesListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
            
            if (_classesArr.count==0) {
                
            }else{
                
                Classes *mod =[Classes yy_modelWithJSON: _classesArr[indexPath.row]];
                NSLog(@"%@",_classesArr[indexPath.row]);
                
                idcell.classModel = mod;
                idcell.sd_tableView = tableView;
                idcell.sd_indexPath = indexPath;
                
            }
        }
        return idcell;
        

    }
    
    return  tableCell;
    
}
















/* 返回按钮*/
- (void)zf_playerBackAction{
    
    [self.playerView resetPlayer];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
}

//  是否支持自动转屏
- (BOOL)shouldAutorotate
{
    // 调用ZFPlayerSingleton单例记录播放状态是否锁定屏幕方向
    return !ZFPlayerShared.isLockScreen;
}

// 支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


//全屏播放视频后，播放器的适配和全屏旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        //        self.fd_interactivePopDisabled = NO;
        //if use Masonry,Please open this annotation
        
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(64);
        }];
        
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        //        self.fd_interactivePopDisabled = YES;
        //if use Masonry,Please open this annotation
        
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
        }];
        
    }
}












#pragma mark- 视频之外的部分
// 滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [_videoInfoView.segmentControl setSelectedSegmentIndex:page animated:YES];
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
