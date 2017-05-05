//
//  VideoClassPlayerViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassPlayerViewController.h"
#import "VideoClassPlayerView.h"
#import "VideoClassProgressTableViewCell.h"
#import "VideoClassFullScreenListTableViewCell.h"


//屏幕模式
typedef enum : NSUInteger {
    PortraitMode,
    FullScreenMode,
} ScreenMode;

@interface VideoClassPlayerViewController ()<ZFPlayerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    
    /**播放器的底视图*/
    UIView *_playerView;
    
    /**播放器控制层*/
    ZFPlayerControlView *_controlView;
    
    //播放器模型
    ZFPlayerModel *_playerModel;
    
    /**课程数据*/
    NSMutableArray <VideoClass *>*_classListArray;
    
    /**教师详情数据*/
    Teacher *_teacher;
    
    /**课程详情信息*/
    VideoClassInfo *_classInfo;
    
    /**屏幕模式*/
    ScreenMode _screenMode;
    
    /**播放源数组*/
//    NSMutableArray *datas;
    
    /**初始化的播放源*/
    NSString *_urlString;
    
}
/**主视图*/
@property (nonatomic, strong) VideoClassPlayerView *mainView ;


@end

@implementation VideoClassPlayerViewController

//初始化方法
-(instancetype)initWithClasses:(__kindof NSArray<VideoClass *> *)classes andTeacher:(Teacher *)teacher andVideoClassInfos:(VideoClassInfo *)classInfo andURLString:(NSString * _Nullable)URLString{
    
    self = [super init];
    if (self) {
        
        _classListArray = [NSMutableArray arrayWithArray:classes];
        _teacher = teacher;
        _classInfo = classInfo;
        
        if (URLString ==nil) {
            
            _urlString = [NSString stringWithFormat:@"%@",_classListArray[0].video.name_url];
            
        }else{
            _urlString = [NSString stringWithFormat:@"%@",URLString];
        }
        
    }
    return self;
    
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _screenMode = PortraitMode;
    
//    datas = @[].mutableCopy;
//    
//    for (VideoClass *videos in _classListArray) {
//        
//        [datas addObject:videos.video.name_url];
//    }
    
    //加载播放器
    [self setupVideoPlayer];
    
    //加载主视图
    [self setupMainView];
    
    //旋转监听
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    [self.videoPlayer addObserver:self forKeyPath:@"isFullScreen" options:NSKeyValueObservingOptionNew context:nil];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    
    if ([change[@"new"] integerValue]==0) {
        
        NSLog(@"切回竖屏模式");
    }else{
        NSLog(@"切换至全屏模式");
    }
    
}


/**播放器设置*/
- (void)setupVideoPlayer{
    
    _playerView = [[UIView alloc]init];
    [self.view addSubview:_playerView];
    [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(_playerView.mas_width).multipliedBy(9.0f/16.0f);
        
    }];
    
    self.videoPlayer = [[ZFPlayerView alloc] init];
    [_playerView addSubview:self.videoPlayer];
    [self.videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(_playerView);
    }];
    // 初始化控制层view
    // 考虑自定义
    _controlView = [[ZFPlayerControlView alloc] init];
    [self.videoPlayer addSubview:_controlView];
    [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.videoPlayer);
    }];
    
    _controlView.classList.delegate = self;
    _controlView.classList.dataSource = self;
    _controlView.classList.tag = 3;
    
    
    // 初始化播放模型
    _playerModel = [[ZFPlayerModel alloc]init];
    _playerModel.fatherView = _playerView;
    _playerModel.videoURL = [NSURL URLWithString:_urlString];
    _playerModel.title = @"视频课程啊";
    [self.videoPlayer playerControlView:_controlView playerModel:_playerModel];
    
    // 设置代理
    self.videoPlayer.delegate = self;
    // 自动播放
    [self.videoPlayer autoPlayTheVideo];
    
    // 下载功能，如需要此功能设置这里
    self.videoPlayer.hasDownload = YES;
    // 预览图
    self.videoPlayer.hasPreviewView = YES;
    
}


/**加载主视图*/
- (void)setupMainView{
    
    _mainView = [[VideoClassPlayerView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_playerView, 0)
    .bottomSpaceToView(self.view, 0);
    
    _mainView.classVideoListTableView.delegate = self;
    _mainView.classVideoListTableView.dataSource = self;
    _mainView.classVideoListTableView.tag = 1;
    
    _mainView.scrollView.delegate = self;
    _mainView.scrollView.tag = 2;
    
    _mainView.model = _classInfo;
    
    typeof(self) __weak weakSelf = self;
    _mainView.segmentControl.indexChangeBlock = ^(NSInteger index) {
        [weakSelf.mainView.scrollView scrollRectToVisible:CGRectMake(weakSelf.view.width_sd*index, 0, weakSelf.view.width_sd, weakSelf.mainView.scrollView.height_sd) animated:YES];
    };
    
}



#pragma mark- UITableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _classListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableCell;
    
    if (tableView.tag == 1) {
        
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"cell";
        VideoClassProgressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[VideoClassProgressTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        if (_classListArray.count>indexPath.row) {
            cell.numbers.text = [NSString stringWithFormat:@"%ld",indexPath.row];
            cell.model = _classListArray[indexPath.row];
        }
        tableCell = cell;
    }
    
    if (tableView.tag == 3) {
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"tableCell";
        VideoClassFullScreenListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[VideoClassFullScreenListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tableCell"];
        }
        
        if (_classListArray.count>indexPath.row) {
            cell.numbers.text = [NSString stringWithFormat:@"%ld",indexPath.row];
            cell.model = _classListArray[indexPath.row];
        }
        tableCell = cell;

    }
    
    
    return  tableCell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
}


#pragma mark- UITableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.width_sd tableView:tableView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    VideoClassProgressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    _playerModel.videoURL = [NSURL URLWithString:cell.model.video.name_url];
    _playerModel.title = cell.model.name;
    
    [self.videoPlayer resetToPlayNewVideo:_playerModel];
    
    if (tableView.tag == 1) {
        
    }else{
        
        [self.videoPlayer interfaceOrientation:UIInterfaceOrientationPortrait];
        [self.videoPlayer interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }

}


#pragma mark- UIScrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 2) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        [_mainView.segmentControl setSelectedSegmentIndex:page animated:YES];
    }
}


//返回按钮的回调
- (void)zf_playerBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//切换清晰度的回调
- (void)zf_playerChooseSharpness:(UIButton *)sender{
    
    if ([sender.titleLabel.text isEqualToString:@"标清"]) {
        //切换至标清播放源
    }else if ([sender.titleLabel.text isEqualToString:@"高清"]){
        //切换至高清播放源
    }
}

//点击课程列表
- (void)zf_playerDownload:(NSString *)url{
    
}

-(void)dealloc{
    
    [self.videoPlayer removeObserver:self forKeyPath:@"isFullScreen"];
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
