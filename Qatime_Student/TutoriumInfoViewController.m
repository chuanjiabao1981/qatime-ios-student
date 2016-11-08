//
//  TutoriumInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "TutoriumInfoViewController.h"
#import "NavigationBar.h"

@interface TutoriumInfoViewController ()<UIScrollViewDelegate>{
    
    NavigationBar *_navigationBar;
    
    
}

@end

@implementation TutoriumInfoViewController

- (instancetype)initWithClassID:(NSString *)classID
{
    self = [super init];
    if (self) {
        
        _classID = [NSString string];
        _classID = classID;
        
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
    [self.view addSubview:_navigationBar];
    
    _tutoriumInfoView = [[TutoriumInfoView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64-63)];
    [self .view addSubview:_tutoriumInfoView];
    
    _tutoriumInfoView.scrollView.delegate = self;
    
    
    _tutoriumInfoView.segmentControl.selectionIndicatorHeight=2;
    _tutoriumInfoView.segmentControl.selectedSegmentIndex=0;
    
    
    typeof(self) __weak weakSelf = self;
    [ _tutoriumInfoView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.tutoriumInfoView.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.view.bounds) * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-64-49) animated:YES];
    }];

        self.tutoriumInfoView.scrollView.delegate = self;
         self.tutoriumInfoView.scrollView.bounces=NO;
         self.tutoriumInfoView.scrollView.alwaysBounceVertical=NO;
          self.tutoriumInfoView.scrollView.alwaysBounceHorizontal=NO;
        
        [  self.tutoriumInfoView.scrollView scrollRectToVisible:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) animated:YES];
        
}

// 滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [_tutoriumInfoView.segmentControl setSelectedSegmentIndex:page animated:YES];
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
