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
#import "UIAlertController+Blocks.h"

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
    
    _changePasswordView.passwordText.secureTextEntry = YES;
    _changePasswordView.newsPasswordText.secureTextEntry = YES;
    _changePasswordView.comparePasswordText.secureTextEntry = YES;
    
    
    
    [_changePasswordView.passwordText addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_changePasswordView.newsPasswordText addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_changePasswordView.comparePasswordText addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    /* 忘记密码按钮*/
    [_changePasswordView.forgetPassword addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    /* 完成按钮*/
    
    [_changePasswordView.finishButton addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
}


- (void)textDidChange:(id)sender{
    
    UITextField *textField = (UITextField *)sender;
    
    /* 验证是否有中文字符*/
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @".{0,}[\u4E00-\u9FA5].{0,}"];
    if ([regextestmobile evaluateWithObject:textField.text]==YES) {
        
        [textField.text substringFromIndex:textField.text.length];
        
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请勿输入中文!" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {}];
        
    }
    
    if ([regextestmobile evaluateWithObject:textField.text]==YES) {
        
        [textField.text substringFromIndex:textField.text.length];
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请勿输入中文!" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {}];
    }
    
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

-(BOOL)checkPassWord:(NSString *)password{
    
    //6-16位数字和字母组成
    //    ^[A-Za-z0-9]{6,16}$
    NSString *regex = @"^[A-Za-z0-9]{6,16}";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:password]) {
        return YES ;
    }else
        return NO;
}


#pragma mark- 发送修改密码请求
- (void) finish{
    
    /* 先验证是否输入了密码*/
    if ([_changePasswordView.passwordText.text isEqualToString:@""]) {
      [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请输入登录密码!" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {}];
        
    }else{
        
        /* 检查密码是否符合要求*/
        if ([self checkPassWord:_changePasswordView.newsPasswordText.text]==NO) {
            /* 密码不符合要求*/
            [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请输入6-16位数字字母组合密码!" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {}];
            
        }else{
            
            if (passwordSame == NO) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次输入不一致!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }] ;
                [alert addAction:sure];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            
            if (![_changePasswordView.passwordText.text isEqualToString:@""]&&passwordSame == YES) {
                
                [self loadingHUDStartLoadingWithTitle:@"正在修改密码"];
                AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                manager.responseSerializer =[AFHTTPResponseSerializer serializer];
                [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
                [manager PUT:[NSString stringWithFormat:@"%@/api/v1/users/%@/password",Request_Header,_idNumber] parameters:@{@"current_password":_changePasswordView.passwordText.text,@"password":_changePasswordView.newsPasswordText.text,@"password_confirmation":_changePasswordView.comparePasswordText.text} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    
                    if ([dic[@"status"] isEqual:[NSNumber numberWithInteger:1]]) {
                        [self loadingHUDStopLoadingWithTitle:@"密码修改成功"];
                        
                        [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
                        
                        
                    }else{
                        
                        [self loadingHUDStopLoadingWithTitle:@"您的信息有误!"];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
                
            }
        }
    }
    
    
}


#pragma mark- 找回密码页面
- (void)findPassword{
    
    FindPasswordViewController *find = [[FindPasswordViewController alloc]initWithFindPassword];
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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_changePasswordView.passwordText resignFirstResponder];
    [_changePasswordView.newsPasswordText resignFirstResponder];
    [_changePasswordView.comparePasswordText resignFirstResponder];
    
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
