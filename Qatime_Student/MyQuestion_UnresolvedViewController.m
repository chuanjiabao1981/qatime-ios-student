//
//  MyQuestion_UnresolvedViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MyQuestion_UnresolvedViewController.h"



@interface MyQuestion_UnresolvedViewController ()
//<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray *_questionsArray;
    
}

@end

@implementation MyQuestion_UnresolvedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeData];
    [self setupView];
    
}

- (void)makeData{

    _mainView = [[UITableView alloc]init];
    [self.view addSubview:_mainView];
//    _mainView.delegate = self;
//    _mainView.dataSource = self;
    
    
}

- (void)setupView{
    
    
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
