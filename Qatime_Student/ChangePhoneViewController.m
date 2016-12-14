//
//  ChangePhoneViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/1.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "RDVTabBarController.h"
#import "UIViewController+HUD.h"
#import "UIViewController_HUD.h"
#import "RDVTabBarController.h"


@interface ChangePhoneViewController (){
    
    NavigationBar *_navigationBar;
    
    NSString *keyCode;
    
    NSString *_token;
    NSString *_idNumber;
    
    
}

@end

@implementation ChangePhoneViewController


- (instancetype)initWithKeyCode:(NSString *)code
{
    self = [super init];
    if (self) {
        
        keyCode  = [NSString stringWithFormat:@"%@",code];
        
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    _navigationBar.titleLabel.text = @"验证手机";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:_navigationBar];
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }

    
    _changePhoneView = [[ChangPhoneView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    [self.view addSubview:_changePhoneView];
    
    [_changePhoneView.finishButton addTarget:self action:@selector(requestChangePasswrod) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

/* 请求发送数据*/
- (void)requestChangePasswrod{
    
    [self loadingHUDStartLoadingWithTitle:@"正在发送申请"];
    
    if ([_changePhoneView.keyCode.text isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入验证码!" preferredStyle:UIAlertControllerStyleAlert];
      
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    
    if ([self isMobileNumber:_changePhoneView.phoneNumber.text ]) {
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager .requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager PUT:[NSString stringWithFormat:@"%@/api/v1/users/%@/login_mobile",Request_Header,_idNumber] parameters:@{@"login_mobile":_changePhoneView.phoneNumber.text,@"captcha_confirmation":_changePhoneView.keyCode.text} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            if ([dic[@"status"] isEqual:[NSNumber numberWithInteger:1]]) {
                /* 修改成功*/
                [self loadingHUDStopLoadingWithTitle:@"修改成功!"];
                
                sleep(2);
                
                [self.rdv_tabBarController setTabBarHidden:NO];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else{
                
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
        
        
        
        
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的电话号码!" preferredStyle:UIAlertControllerStyleAlert];
      
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        


        
        
    }
    
    
    
}

// 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(1[0-9]|3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}


- (void)returnLastPage{
//    返回上一页
    
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
