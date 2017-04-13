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


@interface VideoClassPlayerViewController ()<ZFPlayerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    
    //播放器模型
    ZFPlayerModel *_playerModel;
    
    /**课程数据*/
    NSMutableArray *_classListArray;
    
}
/**主视图*/
@property (nonatomic, strong) VideoClassPlayerView *mainView ;



@end

@implementation VideoClassPlayerViewController

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
    
    //加载播放器
    [self setupVideoPlayer];
    
    //加载主视图
    [self setupMainView];
    
    //
    
}

/**播放器设置*/
- (void)setupVideoPlayer{
    
    self.videoPlayer = [[ZFPlayerView alloc] init];
    [self.view addSubview:self.videoPlayer];
    [self.videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.videoPlayer.mas_width).multipliedBy(9.0f/16.0f);
    }];
    // 初始化控制层view
    // 考虑自定义
    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    [self.videoPlayer addSubview:controlView];
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.videoPlayer);
    }];
    
    // 初始化播放模型
    _playerModel = [[ZFPlayerModel alloc]init];
    _playerModel.videoURL = [NSURL URLWithString:@""];
    _playerModel.title = @"";
    [self.videoPlayer playerControlView:controlView playerModel:_playerModel];
    
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
    .topSpaceToView(_videoPlayer, 0)
    .bottomSpaceToView(self.view, 0);
    
    _mainView.classVideoListTableView.delegate = self;
    _mainView.classVideoListTableView.dataSource = self;
    _mainView.classVideoListTableView.tag = 1;
    
    _mainView.scrollView.delegate = self;
    _mainView.scrollView.tag = 2;
    
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
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    VideoClassProgressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[VideoClassProgressTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (_classListArray.count>indexPath.row) {
        cell.model = _classListArray[indexPath.row];
    }
    
    
    return  cell;
}


#pragma mark- UITableView delegate

-(CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath cellContentViewWidth:(CGFloat)width tableView:(UITableView *)tableView{
    
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.width_sd tableView:tableView];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark- UIScrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 2) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        [_mainView.segmentControl setSelectedSegmentIndex:page animated:YES];
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
