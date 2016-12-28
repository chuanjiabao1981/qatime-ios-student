//
//  AboutUsViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/30.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "AboutUsViewController.h"

#import "NavigationBar.h"

#import "RDVTabBarController.h"
#import "AboutUsTableViewCell.h"

@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NavigationBar *_navigationBar;
    
}

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [self.view addSubview:_navigationBar];
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    

    _aboutUsView  = [[AboutUsView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    [self.view addSubview:_aboutUsView];
   
    _aboutUsView.menuTableView.delegate = self;
    _aboutUsView.menuTableView.dataSource = self;
    
    
    
}

#pragma mark- tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    AboutUsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[AboutUsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
        cell.imageView.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        switch (indexPath.row) {
            case 0:
                cell.name.text = @"客服电话";
                cell.context.text = @"0353-2135828";
                cell.context.textColor = [UIColor blueColor];
                cell.context.attributedText = [[NSAttributedString alloc]initWithString:@"0353-2135828" attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:1],NSUnderlineColorAttributeName:[UIColor blueColor]}];
                
                break;
            case 1:
                
                cell.name.text = @"客服QQ";
                cell.context.text = @"2436219060";
                
                break;
            default:
                break;
        }
        
        
    }
    
    return  cell;
    

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==0) {
        
        
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"0353-2135828"];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        
//        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"0353-2135828"];
//        //            NSLog(@"str======%@",str);
//        
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str] options:nil completionHandler:^(BOOL success) {
//           NSLog(@"%d",success);
//        }];
//        
//        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  60;
}




- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
    
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
