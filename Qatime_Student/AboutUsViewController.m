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
#import "UIAlertController+Blocks.h"

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
    
    _navigationBar.titleLabel.text = @"关于我们";
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
                cell.context.text = ServersPhone;
                cell.context.textColor = [UIColor blueColor];
                cell.context.attributedText = [[NSAttributedString alloc]initWithString:ServersPhone attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:1],NSUnderlineColorAttributeName:[UIColor blueColor]}];
                
                break;
            case 1:
                
                cell.name.text = @"客服QQ";
                cell.context.text = ServerQQ;
                
                break;
            default:
                break;
        }
        
        
    }
    
    return  cell;
    

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==0) {
        
//        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"是否拨打电话0353-2135828?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//           
//            if (buttonIndex!=0) {
        
//                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://0353-2135828"];
                
//                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
        
        
        
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",ServersPhone];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",ServersPhone]]];
//            }
//        }];
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
