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



@interface VideoViewController ()<ZFPlayerControlViewDelagate,ZFPlayerDelegate,UIScrollViewDelegate>

{
    
    NavigationBar *_navigationBar;
    
    ZFPlayerModel *_playerModel;
    
    /* token*/
    
    NSString *_remember_token;
    
    /* 课程model*/
    
    VideoClassInfo *_videoClassInfo;
    
    /* 通知消息model*/
    NoticeAndMembers *_noticeAndMembers;
    
    
    
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
    
    [_videoInfoView.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) animated:YES];
    
 
    
    
    /* 根据token和传来的id 发送课程内容请求。*/
    [self requestClassInfo];
    
    

 
}

#pragma mark- 请求课程和和内容
- (void)requestClassInfo{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_remember_token forHTTPHeaderField:@"Remember-Token"];
    
    [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses/%d/realtime",25] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *status = [NSString stringWithFormat:@"%@",[dic valueForKey:@"status"]];
        
        NSLog(@"%@",dic);
        
        
        if (![status isEqualToString:@"1"]) {
            
        }else{
//        使用yymodel解
        _noticeAndMembers = [NoticeAndMembers yy_modelWithDictionary:dic[@"data"]];
        
        
        
        
        
        
        
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
                
                _videoClassInfo = [VideoClassInfo yy_modelWithDictionary:dataDic];
                _videoClassInfo.classID = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"id"]];
                
                _videoClassInfo.classDescription = [NSString  stringWithFormat:@"%@",[dataDic valueForKey:@"description"]];
                
                
                
                
            }
            
            
            
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        
        
        
    }];

    
    
    
    
    
}





/* 返回按钮*/
- (void)zf_playerBackAction{
    
    [self.playerView resetPlayer];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
