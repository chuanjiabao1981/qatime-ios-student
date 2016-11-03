//
//  PersonalViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "PersonalViewController.h"

@interface PersonalViewController ()

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _personalView = [[PersonalView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64-63)];
    [self.view addSubview:_personalView];
    
    
    /* 退出登录按钮*/
    [_personalView.logOutButton  addTarget: self action:@selector(userLogOut) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    

}

#pragma mark- 用户退出登录
- (void)userLogOut{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您真的确定退出？" preferredStyle:UIAlertControllerStyleAlert];
    /* 确定退出*/
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
         NSString *userFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"User.data"];
        
        [[NSFileManager defaultManager]removeItemAtPath:userFilePath error:nil];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"id"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"remember_token"];
        
        /* 发消息 给appdelegate*/
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userLogOut" object:nil];
        
        
        
        
        
        
    }];
    UIAlertAction *actionCancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alert dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }];
    
    
    [alert addAction:actionCancel];
    [alert addAction:actionSure];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
    
    
    
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
