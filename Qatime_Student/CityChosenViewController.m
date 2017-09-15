//
//  CityChosenViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/6.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "CityChosenViewController.h"
#import "NavigationBar.h"
#import "ProinceTableViewCell.h"
#import "YYModel.h"
#import "SignUpInfoViewController.h"

#import "PersonalInfoEditViewController.h"
#import "BindingViewController.h"

@interface CityChosenViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    NSString *_province;
    
    NSArray *_cityArr;
    
    NSMutableArray *_cityModelArray;
    
}

@end

@implementation CityChosenViewController


/**  传个省份信息进来 */
- (instancetype)initWithChosenProvince:(NSString *)province andDataArr:(NSArray <City *>*)dataArr{
    self = [super init];
    
    if (self) {
        
        _province = [NSString stringWithFormat:@"%@",province];
        
        _cityArr = [NSArray arrayWithArray:dataArr];
        
    }
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationBar = ({
        NavigationBar *_ = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        _.titleLabel.text = @"地区选择";
        [self.view addSubview:_];
        _;
    });
    
    _cityTableView = ({
        UITableView *_ = [[UITableView alloc]initWithFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd-Navigation_Height) style:UITableViewStylePlain];
        _.delegate = self;
        _.dataSource = self;
        [self.view addSubview:_];
        _;
    });

}



#pragma mark- tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _cityArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    ProinceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[ProinceTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (_cityArr.count>indexPath.row) {
        cell.cityModel = _cityArr[indexPath.row];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    }
    
    
    return  cell;
    
    
}


#pragma mark- tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProinceTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //发消息 改变地区信息
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeLocation" object:@{@"province":_province,@"city":cell.cityModel.name}];
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isMemberOfClass:[PersonalInfoEditViewController class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
        }else if ([controller isMemberOfClass:[SignUpInfoViewController class]]){
            
            [self.navigationController popToViewController:controller animated:YES];
            
        }else if ([controller isMemberOfClass:[BindingViewController class]]){
            [self.navigationController popToViewController:controller animated:YES];
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"PopToRoot" object:nil];
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
