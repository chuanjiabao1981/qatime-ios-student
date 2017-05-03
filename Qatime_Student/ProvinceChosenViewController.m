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

#import "CityChosenViewController.h"


@interface ProvinceChosenViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
    NavigationBar *_navigationBar;
    
    //省信息
    NSArray *_provinceArray ;
    //省model数组
    NSMutableArray *_provinceModelArr;
    
    //市信息
    NSArray *_cityArray;
    //市model数组
    NSMutableArray *_cityModelArr;
    
}

@end

@implementation ProvinceChosenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar=({
    
        NavigationBar *_ = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        [self.view addSubview:_];
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"]forState:UIControlStateNormal];
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
    
    //省信息初始化
    _provinceModelArr = @[].mutableCopy;
    _provinceArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"province"];
    
    //市信息初始化
    _cityModelArr = @[].mutableCopy;
    _cityArray = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults]valueForKey:@"city"]];
    
    
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
    
    _provinceHeader = [[ProvinceHeaderView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd*0.07)];
    [self.view addSubview:_provinceHeader];
    
    _provinceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+_provinceHeader.height_sd, self.view.width_sd, self.view.height_sd-(64+_provinceHeader.height_sd)) style:UITableViewStylePlain];
    [self.view addSubview:_provinceTableView];
    
    _provinceTableView.delegate = self;
    _provinceTableView.dataSource = self;
    
    //加载位置
    _provinceHeader.currentProvince.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"Location_Province"]==nil?@"":[[NSUserDefaults standardUserDefaults]valueForKey:@"Location_Province"];
    
    _provinceHeader.currentCity.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"Location_City"]==nil?@"":[[NSUserDefaults standardUserDefaults]valueForKey:@"Location_City"];
    
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


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return self.view.height_sd*0.065;
}


//header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"全部地区";
    label.textColor = [UIColor blackColor];
    label.font = TITLEFONTSIZE;
    [view addSubview:label];
    label.sd_layout
    .leftSpaceToView(view,20)
    .centerYEqualToView(view)
    .autoHeightRatio(0);
    [label setSingleLineAutoResizeWithMaxWidth:200];
    return view;
    
}
//点击cell

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /**
     数据逻辑:
     "市"信息包含"省"信息的id,使用省的id去遍历市级信息,进入次级页面.
     */
    
    ProinceTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    for (NSDictionary *cityDic in _cityArray) {
        
        City *mod = [City yy_modelWithJSON:cityDic];
        mod.cityID = cityDic[@"id"];
        if ([[NSString stringWithFormat:@"%@",cell.model.provinceID] isEqualToString:mod.province_id]) {
            [_cityModelArr addObject:mod];
        }
    }
    
    _controller = [[CityChosenViewController alloc]initWithChosenProvince:cell.model.name andDataArr:_cityModelArr];
    [self.navigationController pushViewController:_controller animated:YES];
    
    
    
    
    
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
