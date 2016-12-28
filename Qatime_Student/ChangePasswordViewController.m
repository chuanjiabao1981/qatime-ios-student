//
//  ChangePasswordViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/5.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "NavigationBar.h"
#import "FindPasswordViewController.h"
#import "UIViewController+HUD.h"
#import "UIViewController_HUD.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>
{
    NavigationBar *_navigationBar;
    
    /* 两次输入的密码是否一致*/
    BOOL passwordSame;
    
    NSString *_token;
    NSString *_idNumber;
}

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _navigationBar  = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [self.view addSubview:_navigationBar];
    
    _navigationBar.titleLabel.text = @"修改密码";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
 
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    

    
    
    
    _changePasswordView= [[ChangePasswordView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    [self.view addSubview:_changePasswordView];
    
    
    /* 添加密码输入框的监听*/
//    [_changePasswordView.newsPasswordText addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    
    
    _changePasswordView.newsPasswordText.delegate = self;
    _changePasswordView.comparePasswordText.delegate = self;
    
    
    [_changePasswordView.newsPasswordText addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_changePasswordView.comparePasswordText addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    /* 忘记密码按钮*/
    [_changePasswordView.forgetPassword addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    /* 完成按钮*/
    
    [_changePasswordView.finishButton addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
}


- (void) textDidChange:(id)sender{
    
    UITextField *textField = (UITextField *)sender;
    
    
    if (textField == _changePasswordView.newsPasswordText) {
        
        if (textField. text.length>=5) {
            
            [self rightPassword:textField];
            
        }else{
            
            [self wrongPassword:textField];
        }
    }
    else if (textField == _changePasswordView.comparePasswordText) {
        
        if ([textField.text isEqualToString:_changePasswordView.newsPasswordText.text]) {
            
            [self rightPassword:textField];
            passwordSame = YES;
            
        }else{
            
            [self wrongPassword:textField];
            passwordSame = NO;
        }
        
        
    }

    
    
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
     if ([string isEqualToString:@""]) return YES;
    
    

    return YES;
    
    
}


#pragma mark- 发送找回密码请求
- (void) finish{
    
    if ([_changePasswordView.passwordText.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入密码!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];

    }
    if (passwordSame == NO) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次输入不一致!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];

    }
    
    
    if (![_changePasswordView.passwordText.text isEqualToString:@""]&&passwordSame == YES) {
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager PUT:[NSString stringWithFormat:@"%@/api/v1/users/%@/password",Request_Header,_idNumber] parameters:@{@"current_password":_changePasswordView.passwordText.text,@"password":_changePasswordView.newsPasswordText.text,@"password_confirmation":_changePasswordView.comparePasswordText.text} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            if ([dic[@"status"] isEqual:[NSNumber numberWithInteger:1]]) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码修改成功!" preferredStyle:UIAlertControllerStyleAlert];
              
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                     [self.navigationController popViewControllerAnimated:YES];
                }] ;
                [alert addAction:sure];
                [self presentViewController:alert animated:YES completion:nil];
                
                
                
            }else{
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您输入的信息有误!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }] ;
                [alert addAction:sure];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            
                        
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
    }
    
}


#pragma mark- 找回密码页面
- (void)findPassword{
    
    FindPasswordViewController *find = [FindPasswordViewController new];
    [self.navigationController pushViewController:find animated:YES];
    
}


#pragma mark- textfield delegate




/* 密码提示图片改变*/
- (void)rightPassword:(UITextField *)textField{
    
    if (textField == _changePasswordView.newsPasswordText) {
        
        [_changePasswordView.passwordImage setImage:[UIImage imageNamed:@"yes"]];
    }else if (textField == _changePasswordView.comparePasswordText){
        
        [_changePasswordView.comparePasswordImage setImage:[UIImage imageNamed:@"yes"]];
    }
}
- (void)wrongPassword:(UITextField *)textField{
    
    if (textField == _changePasswordView.newsPasswordText) {
        
        [_changePasswordView.passwordImage setImage:[UIImage imageNamed:@"wrong"]];
    }else if (textField == _changePasswordView.comparePasswordText){
        
        [_changePasswordView.comparePasswordImage setImage:[UIImage imageNamed:@"wrong"]];
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
