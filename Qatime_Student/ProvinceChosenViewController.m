//
//  ProvinceChosenViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/6.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ProvinceChosenViewController.h"
#import "NavigationBar.h"
#import "UIViewController+HUD.h"
#import "YYModel.h"
#import "Province.h"
#import "City.h"

#import "ProinceTableViewCell.h"


@interface ProvinceChosenViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
    NavigationBar *_navigationBar;
    
    NSArray *_provinceArray ;
    
    NSMutableArray *_provinceModelArr;
    
    
    
}

@end

@implementation ProvinceChosenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationBar=({
    
        NavigationBar *_ = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        [self.view addSubview:_];
        [_.leftButton setImage:[UIImage imageNamed:@"backArrow"]forState:UIControlStateNormal];
        _.titleLabel.text = NSLocalizedString(@"选择地区", nil);
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        _;
    });
    
    [self loadingHUDStartLoadingWithTitle:NSLocalizedString(@"加载数据", nil)];
    
    //请求省份信息
    [self loadProvinceInfo];
    
    
}

/* 制作省份/城市数据信息*/
- (void)loadProvinceInfo{
    
    _provinceModelArr = @[].mutableCopy;
 
    _provinceArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"province"];
    
    //制作省份数据
    for (NSDictionary *province in _provinceArray) {
        Province *mod = [Province yy_modelWithJSON:province];
        mod.provinceID = province[@"id"];
        [_provinceModelArr addObject:mod];
    }
  
//    加载视图
    [self setUpViews];
    [self loadingHUDStopLoadingWithTitle:nil];
    
    
}

//加载视图
- (void)setUpViews{
    
    _provinceHeader = [[ProvinceHeaderView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, 64)];
    [self.view addSubview:_provinceHeader];
    
    _provinceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 128, self.view.width_sd, self.view.height_sd-128) style:UITableViewStylePlain];
    [self.view addSubview:_provinceTableView];
    
    _provinceTableView.delegate = self;
    _provinceTableView.dataSource = self;
    
    
}

#pragma mark- tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _provinceModelArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    ProinceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[ProinceTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (_provinceModelArr.count>indexPath.row) {
        
        cell.model = _provinceModelArr[indexPath.row];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    }
   
    return  cell;
    
}



#pragma mark- tableview delegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"全部地区";
    
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
