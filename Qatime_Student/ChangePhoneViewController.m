//
//  ChangePhoneViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/1.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChangePhoneViewController.h"
 
#import "UIViewController+HUD.h"
#import "UIViewController+HUD.h"
 
#import "UIAlertController+Blocks.h"


@interface ChangePhoneViewController ()<UITextInputDelegate>{
    
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
      
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    _navigationBar.titleLabel.text = @"验证绑定手机";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
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
    
    [_changePhoneView.phoneNumber addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_changePhoneView.getKeyButton addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    
    
}


/* 检查输入字符*/
-(void)textDidChange:(id<UITextInput>)textInput{
   
    if ([self isNumText:_changePhoneView.phoneNumber.text]) {
        
    }else{
        
       [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请输入正确的手机号." cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {}];
        _changePhoneView.phoneNumber.text = [_changePhoneView.phoneNumber.text substringToIndex:_changePhoneView.phoneNumber.text.length];
    }

    if (_changePhoneView.phoneNumber.text.length > 11) {
        _changePhoneView.phoneNumber.text = [_changePhoneView.phoneNumber.text substringToIndex:11];
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请输入11位手机号" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {}];
    }
    
}

//是否是纯数字
- (BOOL)isNumText:(NSString *)str{
    NSString * regex = @"^[0-9]*$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
}



/* 请求发送数据*/
- (void)requestChangePasswrod{
    
    if ([_changePhoneView.keyCode.text isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入验证码!" preferredStyle:UIAlertControllerStyleAlert];
      
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    
    if ([self isMobileNumber:_changePhoneView.phoneNumber.text ]) {
        
        [self loadingHUDStartLoadingWithTitle:@"正在发送申请"];
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager .requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager PUT:[NSString stringWithFormat:@"%@/api/v1/users/%@/login_mobile",Request_Header,_idNumber] parameters:@{@"login_mobile":_changePhoneView.phoneNumber.text,@"captcha_confirmation":_changePhoneView.keyCode.text} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            [self loginStates:dic];
            
            if ([dic[@"status"] isEqual:[NSNumber numberWithInteger:1]]) {
                /* 修改成功*/
                [self loadingHUDStopLoadingWithTitle:@"修改成功!"];
                
                sleep(2);
                
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else{
                /* 修改失败*/
                [self loadingHUDStopLoadingWithTitle:@"修改失败!"];
                
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

#pragma mark- 获取验证码的按钮点击事件
- (void)getCode:(UIButton *)sender{
    
    if (sender.enabled ==YES) {
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"%@/api/v1/captcha",Request_Header] parameters:@{@"send_to":_changePhoneView.phoneNumber.text,@"key":@"send_captcha"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            [self loginStates:dic];
            if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                
                [self loadingHUDStopLoadingWithTitle:@"发送申请成功!"];
                
            }else{
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"信息错误!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }] ;
                [alert addAction:sure];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            [self deadLineTimer:sender];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
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
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [button setEnabled:NO];
            
        });
        deadline--;
        
        /* 倒计时结束 关闭线程*/
        if(deadline<=0){
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [button setTitle:@"获取校验码" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                [button setEnabled:YES];
                
                
            });
        }
    });
    dispatch_resume(_timer);
    

}





- (void)returnLastPage{
//    返回上一页
    
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
