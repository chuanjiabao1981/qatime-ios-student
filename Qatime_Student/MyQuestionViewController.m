//
//  MyQuestionViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MyQuestionViewController.h"
#import "NavigationBar.h"

@interface MyQuestionViewController ()<UIScrollViewDelegate>{
    
    NavigationBar *_navigationBar;
    
}

@end

@implementation MyQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self makeData];
    [self setupViews];
    
}

- (void)makeData{
    
}

- (void)setupViews{
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    _navigationBar.titleLabel.text = @"我的提问";
    
    _mainView = [[MyQuestionView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .topSpaceToView(_navigationBar, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
    _unresolvedController = [[MyQuestion_UnresolvedViewController alloc]init];
    _resolvedController = [[MyQuestion_ResolvedViewController alloc]init];
    
    [self addChildViewController:_unresolvedController];
    [self addChildViewController:_resolvedController];
    
    [_mainView.scrollView addSubview:_unresolvedController.view];
    _unresolvedController.view.sd_layout
    .leftSpaceToView(_mainView.scrollView, 0)
    .topSpaceToView(_mainView.scrollView, 0)
    .bottomSpaceToView(_mainView.scrollView, 0)
    .widthRatioToView(_mainView.scrollView, 1.0f);
    
    [_mainView.scrollView addSubview:_resolvedController.view];
    _resolvedController.view.sd_layout
    .leftSpaceToView(_unresolvedController.view, 0)
    .topSpaceToView(_mainView.scrollView, 0)
    .bottomSpaceToView(_mainView.scrollView, 0)
    .widthRatioToView(_mainView.scrollView, 1.0f);
    
    _mainView.scrollView.delegate = self;
    
    [_mainView.scrollView setupAutoContentSizeWithRightView:_resolvedController.view rightMargin:0];
    [_mainView.scrollView setupAutoContentSizeWithBottomView:_unresolvedController.view bottomMargin:0];
    
    typeof(self) __weak weakSelf = self;
    _mainView.segmentControl.indexChangeBlock = ^(NSInteger index) {
        [weakSelf.mainView.scrollView scrollRectToVisible:CGRectMake(index*weakSelf.mainView.scrollView.width_sd, 0, weakSelf.mainView.scrollView.width_sd, weakSelf.mainView.scrollView.height_sd) animated:YES];
    };
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _mainView.scrollView) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger pages = scrollView.contentOffset.x / pageWidth;
        
        [_mainView.segmentControl setSelectedSegmentIndex:pages animated:YES];
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
