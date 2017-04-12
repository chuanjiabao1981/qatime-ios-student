//
//  VideoClassInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/11.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassInfoViewController.h"
#import "NavigationBar.h"
#import "VideoClassListTableViewCell.h"
#import "VideoClassInfo.h"
#import "CYLTableViewPlaceHolder.h"
#import "HaveNoClassView.h"

@interface VideoClassInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CYLTableViewPlaceHolderDelegate>{
    
    NavigationBar *_navigationBar;
    
    /**数据源*/
    NSMutableArray <VideoClassInfo *>*_classArray;
    
}
/**主视图*/
@property (nonatomic, strong) VideoClassInfoView *videoClassInfoView ;

@end

@implementation VideoClassInfoViewController

/**导航栏*/
- (void)setupNavigation{
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview: _navigationBar];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
}

/**加载主视图*/
- (void)setupMainView{
    
    _videoClassInfoView = [[VideoClassInfoView alloc]initWithFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd - Navigation_Height)];
    [self.view addSubview:_videoClassInfoView];
    
    _videoClassInfoView.classesListTableView.delegate = self;
    _videoClassInfoView.classesListTableView.dataSource = self;
    _videoClassInfoView.classesListTableView.tag = 1;
    
    _videoClassInfoView.scrollView.delegate = self;
    _videoClassInfoView.scrollView.tag = 2;
    
    typeof(self) __weak weakSelf = self;
    [_videoClassInfoView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.videoClassInfoView.scrollView scrollRectToVisible:CGRectMake(weakSelf.view.width_sd*index, 0, weakSelf.view.width_sd, weakSelf.videoClassInfoView.scrollView.height_sd) animated:YES];
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    _classArray = @[].mutableCopy;
    
    //加载导航栏
    [self setupNavigation];
    
    
    
    
}

#pragma mark- UITableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _classArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
     VideoClassListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[VideoClassListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (_classArray.count>indexPath.row) {
        
        cell.model = _classArray[indexPath.row];
    }
    
    return  cell;

}


#pragma mark- UITableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView cellHeightForIndexPath:indexPath model:_classArray[indexPath.row] keyPath:@"model" cellClass:[VideoClassListTableViewCell class] contentViewWidth:self.view.width_sd];
}


#pragma mark- UIScrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 2) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger pages = scrollView.contentOffset.x / pageWidth;
        
        [_videoClassInfoView.segmentControl setSelectedSegmentIndex:pages animated:YES];
    }
}

/**无课程占位图*/
- (UIView *)makePlaceHolderView{
    HaveNoClassView *view = [[HaveNoClassView alloc]init];
    view.titleLabel.text = @"当前无课程";
    return view;
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
