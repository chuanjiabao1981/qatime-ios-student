//
//  ParentViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ParentViewController.h"
#import "UIViewController+HUD.h"

#import "UIAlertController+Blocks.h"

@interface ParentViewController (){
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
}

@end

@implementation ParentViewController

- (instancetype)initWithPhone:(NSString *)phone
{
    self = [super init];
    if (self) {
        
        
        _parentPhone = [NSString stringWithFormat:@"%@",phone];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [self.view addSubview:_navigationBar];
    
    _navigationBar.titleLabel.text = @"家长手机";
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }

    
    _parentView = [[ParentView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    [self.view addSubview:_parentView];
    
    _parentView.parentPhoneLabel.text = _parentPhone;
//    _parentView.getCodeButton.enabled = YES;
    _parentView.finishButton.enabled = NO;
    _parentView.password.secureTextEntry = YES;
    
    
    [_parentView.parentPhoneText addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
     [_parentView.password addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
     [_parentView.keyCodeText addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
//    [_parentView.getCodeButton addTarget:self action:@selector(requestKeyCode:) forControlEvents:UIControlEventTouchUpInside];
    
    [_parentView.finishButton addTarget:self action:@selector(requestChangeParentPhone) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
}

-(void)textDidChange:(id<UITextInput>)textInput{
    
    if (![_parentView.parentPhoneText.text isEqualToString:@""]) {
        _parentView.getCodeButton.enabled = YES;
        [_parentView.getCodeButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        [ _parentView.getCodeButton addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
        _parentView.getCodeButton.layer.borderColor = BUTTONRED.CGColor;
        
    }else{
         _parentView.getCodeButton.enabled = NO;
        [ _parentView.getCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [ _parentView.getCodeButton removeTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
        _parentView.getCodeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    if (_parentView.parentPhoneText.text.length > 11) {
        _parentView.parentPhoneText.text = [_parentView.parentPhoneText.text substringToIndex:11];
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请输入11位手机号" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {}];
    }
    
    if (_parentView.parentPhoneText.text.length>0&&_parentView.keyCodeText.text.length>0&&_parentView.password.text.length>0) {
        _parentView.finishButton.enabled = YES;
        [_parentView.finishButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        _parentView.finishButton.layer.borderColor = BUTTONRED.CGColor;
        
    }else{
        _parentView.finishButton.enabled = NO;
        [_parentView.finishButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _parentView.finishButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
    }
}


#pragma mark- 向服务器请求修改家长手机号码
- (void)requestChangeParentPhone{
    
    
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    if (_parentView.keyCodeText.text ==nil||[_parentView.keyCodeText.text isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入验证码!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
            
        }] ;
        
        
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }else{
        
        [self loadingHUDStartLoadingWithTitle:@"正在加载"];
        [manager PUT:[NSString stringWithFormat:@"%@/api/v1/students/%@/parent_phone",Request_Header, _idNumber] parameters:@{@"current_password":_parentView.password.text,@"parent_phone":_parentView.parentPhoneText.text,@"captcha_confirmation":_parentView.keyCodeText.text} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            [self loginStates:dic];
            NSLog(@"%@",dic);
            
            if ([dic[@"status"] isEqual:[NSNumber numberWithInteger:1]]) {
                
                [self loadingHUDStopLoadingWithTitle:@"修改成功!"];
                [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeParentPhoneSuccess" object:_parentView.parentPhoneText.text];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
     
    }
    
}
#pragma mark- 请求验证码
- (void)getCheckCode:(UIButton *)sender{
    
    if (sender.enabled == YES) {
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        if (_parentView.parentPhoneText.text ==nil||[_parentView.parentPhoneText.text isEqualToString:@""]) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入手机号!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }] ;
            
            
            [alert addAction:sure];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        if (_parentView.password.text ==nil||[_parentView.password.text isEqualToString:@""]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入登录密码!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }] ;
            
            [alert addAction:sure];
            
            [self presentViewController:alert animated:YES completion:nil];

        }else{
            
            [manager POST:[NSString stringWithFormat:@"%@/api/v1/captcha",Request_Header] parameters:@{@"send_to":_parentView.parentPhoneText.text,@"key":@"send_captcha"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self loadingHUDStopLoadingWithTitle:@"发送成功"];
                [self deadLineTimer:sender];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self loadingHUDStopLoadingWithTitle:@"发送失败"];
                
            }];
            
        }
    }
    
}




#pragma mark- 倒计时方法封装
/* 倒计时方法封装*/
- (void)deadLineTimer:(UIButton *)button{
    
    /* 按钮倒计时*/
    __block int deadline=CheckCodeTime;
    
    /* 子线程 倒计时*/
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    /* 执行时间为1秒*/
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *strTime = [NSString stringWithFormat:@"重发验证码(%d)",deadline];
            
            [button setTitle:strTime forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            [button setEnabled:NO];
            
        });
        deadline--;
        
        /* 倒计时结束 关闭线程*/
        if(deadline<=0){
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [button setTitle:@"获取校验码" forState:UIControlStateNormal];
                [button setTitleColor:BUTTONRED forState:UIControlStateNormal];
                
                [button setEnabled:YES];
                
            });
        }
    });
    dispatch_resume(_timer);
    
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
