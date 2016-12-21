//
//  GuideViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/21.
//  Copyright © 2016年 WWTD. All rights reserved.
//


/**
 引导页
 */
#import "GuideViewController.h"
#import "LoginViewController.h"


@interface GuideViewController ()<UIScrollViewDelegate>{
    
    // 创建页码控制器
    UIPageControl *pageControl;
    // 判断是否是第一次进入应用
    BOOL flag;
    
    //页数
    NSInteger pageNumber;
    
}

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    pageNumber = 3;
    
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width_sd, self.view.height_sd)];
    for (int i=0; i<pageNumber; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d",i+1]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width_sd * i, 0, self.view.width_sd, self.view.height_sd)];
        // 在最后一页创建按钮
        if (i == pageNumber-1) {
            // 必须设置用户交互 否则按键无法操作
            imageView.userInteractionEnabled = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(self.view.width_sd / 3, self.view.height_sd * 7 / 8, self.view.width_sd / 3, self.view.height_sd / 16);
            [button setTitle:@"点击进入" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.borderWidth = 2;
            button.layer.cornerRadius = 5;
            button.clipsToBounds = YES;
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            [button addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
        }
        imageView.image = image;
        [myScrollView addSubview:imageView];
    }
    myScrollView.bounces = NO;
    myScrollView.pagingEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.contentSize = CGSizeMake(self.view.width_sd* 3, self.view.height_sd);
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.width_sd / 3, self.view.height_sd * 15 / 16, self.view.width_sd / 3, self.view.height_sd / 16)];
    // 设置页数
    pageControl.numberOfPages = pageNumber;
    // 设置页码的点的颜色
    /* 默认色*/
//    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    // 设置当前页码的点颜色
    /* 默认色*/
//    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    [self.view addSubview:pageControl];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 计算当前在第几页
    pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
}

// 点击按钮保存数据并切换根视图控制器
- (void) go:(UIButton *)sender{
    flag = YES;
    NSUserDefaults *useDef = [NSUserDefaults standardUserDefaults];
    // 保存用户数据
    [useDef setBool:flag forKey:@"notFirst"];
    [useDef synchronize];
    // 切换根视图控制器
    self.view.window.rootViewController = [[LoginViewController alloc] init];
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
