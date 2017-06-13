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
#import "GuestBindingViewController.h"

#import "UIAlertController+Blocks.h"



@interface ChangePhoneViewController ()<UITextInputDelegate>{
    
    NavigationBar *_navigationBar;
    
    NSString *keyCode;
    
    NSString *_token;
    NSString *_idNumber;
    
    /**是否是游客*/
    BOOL is_Guest;
    
    
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
    _navigationBar.titleLabel.text = @"绑定新手机";
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
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"is_Guest"]) {
        is_Guest = [[NSUserDefaults standardUserDefaults]boolForKey:@"is_Guest"];
    }

    _changePhoneView = [[ChangPhoneView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    [self.view addSubview:_changePhoneView];
    
    [_changePhoneView.finishButton addTarget:self action:@selector(requestChangePasswrod) forControlEvents:UIControlEventTouchUpInside];
    
    [_changePhoneView.phoneNumber addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_changePhoneView.keyCode addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [_changePhoneView.getKeyButton addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];

}


/* 检查输入字符*/
-(void)textDidChange:(id<UITextInput>)textInput{
   
    /* 手机号框*/
    
    if ([self isMobileNumber:_changePhoneView.phoneNumber.text]) {
        
        if ([_changePhoneView.getKeyButton.titleLabel.text isEqualToString:@"获取校验码"]) {
            _changePhoneView.getKeyButton.enabled = YES;
            [_changePhoneView.getKeyButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
            [_changePhoneView.getKeyButton setBackgroundColor:[UIColor whiteColor]];
            _changePhoneView.getKeyButton.layer.borderColor = NAVIGATIONRED.CGColor;
            
            [_changePhoneView.getKeyButton addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            
        }
        
    }else{
        
        _changePhoneView.getKeyButton.enabled = NO;
        [_changePhoneView.getKeyButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_changePhoneView.getKeyButton removeTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
        
        [_changePhoneView.getKeyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_changePhoneView.getKeyButton setBackgroundColor:[UIColor lightGrayColor]];
        _changePhoneView.getKeyButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    if (_changePhoneView.phoneNumber.text.length > 11) {
        _changePhoneView.phoneNumber.text = [_changePhoneView.phoneNumber.text substringToIndex:11];
        [UIAlertController showAlertInViewController:self withTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入11位手机号", nil) cancelButtonTitle:NSLocalizedString(@"确定", nil) destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {}];
    }
    
    
    if (_changePhoneView.phoneNumber.text.length>0&&_changePhoneView.keyCode.text.length>0) {
        
        _changePhoneView.finishButton.enabled = YES;
        [_changePhoneView.finishButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
        [_changePhoneView.finishButton setBackgroundColor: [UIColor whiteColor]];
        _changePhoneView.finishButton.layer.borderColor = NAVIGATIONRED.CGColor;
        
    }else{
        _changePhoneView.finishButton.enabled = NO;
        
        [_changePhoneView.finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_changePhoneView.finishButton setBackgroundColor: [UIColor lightGrayColor]];
        _changePhoneView.finishButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
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
        
        [self HUDStartWithTitle:@"正在发送申请"];
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager .requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager PUT:[NSString stringWithFormat:@"%@/api/v1/users/%@/login_mobile",Request_Header,_idNumber] parameters:@{@"login_mobile":_changePhoneView.phoneNumber.text,@"captcha_confirmation":_changePhoneView.keyCode.text} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            [self loginStates:dic];
            
            if ([dic[@"status"] isEqual:[NSNumber numberWithInteger:1]]) {
                /* 修改成功*/
                [self HUDStopWithTitle:@"修改成功!"];
                
                if (is_Guest==YES) {
                    
                    [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"绑定成功!\n是否要完善其他信息?" cancelButtonTitle:@"前往完善" destructiveButtonTitle:nil otherButtonTitles:@[@"取消"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                       
                        if (buttonIndex == 0) {
                            //前往绑定信息去
                            GuestBindingViewController *controller = [[GuestBindingViewController alloc]initWithPhoneNumber:_changePhoneView.phoneNumber.text];
                            [self.navigationController pushViewController:controller animated:YES];
                            
                        }else{
                            
                            
                        }
                    }];
                    
                }else{
                    
                    [self performSelector:@selector(returnToRoot) withObject:nil afterDelay:1];
                }
                
            }else{
                /* 修改失败*/
                [self HUDStopWithTitle:@"修改失败!"];
                
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

#pragma mark- 获取验证码的按钮点击事件
- (void)getCheckCode:(UIButton *)sender{
    
    if (sender.enabled ==YES) {
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"%@/api/v1/captcha",Request_Header] parameters:@{@"send_to":_changePhoneView.phoneNumber.text,@"key":@"send_captcha"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            [self loginStates:dic];
            if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                
                [self HUDStopWithTitle:@"发送申请成功!"];
                
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
            [button setBackgroundColor:[UIColor lightGrayColor]];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [button setEnabled:NO];

            
        });
        deadline--;
        
        /* 倒计时结束 关闭线程*/
        if(deadline<=0){
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [button setTitle:NSLocalizedString(@"获取校验码", nil) forState:UIControlStateNormal];
                [button setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor whiteColor]];
                button.layer.borderColor = NAVIGATIONRED.CGColor;
                
                [button setEnabled:YES];
            });
        }
    });
    dispatch_resume(_timer);
    
}


- (void)returnToRoot{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
