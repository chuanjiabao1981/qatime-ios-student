//
//  VideoClassInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/11.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassInfoViewController.h"
#import "NavigationBar.h"

@interface VideoClassInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    
    NavigationBar *_navigationBar;
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
    
    //加载导航栏
    [self setupNavigation];
    
    
    
    
}

#pragma mark- UITableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    return  cell;

    
}


#pragma mark- UITableView delegate

#pragma mark- UIScrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 2) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger pages = scrollView.contentOffset.x / pageWidth;
        
        [_videoClassInfoView.segmentControl setSelectedSegmentIndex:pages animated:YES];
        
      
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
