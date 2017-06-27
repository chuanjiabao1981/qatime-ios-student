//
//  SetNewPasswordViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "SetNewPasswordViewController.h"
#import "UIAlertController+Blocks.h"
#import "UIViewController+HUD.h"
#import "SafeViewController.h"
#import "AuthenticationViewController.h"

@interface SetNewPasswordViewController (){
    
    NSString *_compareStr;
    
    NSString *_token;
    NSString *_idNumber;
    
}



@end

@implementation SetNewPasswordViewController

/* 对比前一页面传来的密码*/
-(instancetype)initWithType:(SetPayPassordType)type andPassword:(NSString *)password{
    
    self = [super init];
    if (self) {
        
        _compareStr = [NSString stringWithFormat:@"%@",password];
        self.pageType = type;
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }

    
    [self.passwordText addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.finishButton.hidden = YES;
    self.findPayPasswordButton .hidden = YES;
    
    _nextButton = [[UIButton alloc]init];
    [_nextButton setTitle:@"完成" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _nextButton.layer.borderWidth = 1;
    _nextButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    [self.view addSubview:_nextButton];
    _nextButton.sd_layout
    .leftSpaceToView(self.view,20)
    .rightSpaceToView(self.view,20)
    .topSpaceToView(self.setPayPasswordView.imageArr[5],100)
    .heightRatioToView(self.view,0.07);
    _nextButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
    
    
    [_nextButton addTarget:self action:@selector(requestPayPassord) forControlEvents:UIControlEventTouchUpInside];
    
    
//    _findPassword =[[UIButton alloc]init];
//    [_findPassword setTitle:@"忘记支付密码?" forState:UIControlStateNormal];
//    _findPassword.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    
//    [self.view addSubview:_findPassword];
//    
//    _findPassword.sd_layout
//    .topSpaceToView(self.setPayPasswordView.imageArr[5],100)
//    .rightEqualToView(self.setPayPasswordView.imageArr[5])
//    .heightIs(30)
//    .widthIs(300);
    
    
//    [_findPassword addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}



/* 文字变化*/
- (void)textDidChange:(UITextField *)textField{
    
    if (textField == self.passwordText) {
        
        if (textField.text.length>6) {
            textField.text = [textField.text substringToIndex:6];
        }
        if (textField.text.length == 6) {
            
            if ([textField.text isEqualToString:_compareStr]) {
                
//                [_nextButton setTitle:@"完成" forState:UIControlStateNormal];
                [_nextButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
                _nextButton.layer.borderWidth = 1;
                _nextButton.layer.borderColor = BUTTONRED.CGColor;

                
            }else{
                
                [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"两次输入密码不一致!" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    self.passwordText.text = @"";
                    [self.passwordText becomeFirstResponder];
                    
                    for (UIImageView *image in self.setPayPasswordView.imageArr) {
                        [image setImage:nil];
                    }
                    
                    [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"PayPasswordTurnZero" object:nil];
                    
                }];
                
            }
            
            
        }
    }
    
    
}

/* 请求服务器,设置支付密码*/
- (void)requestPayPassord{
    
    [self HUDStartWithTitle:@"正在设置"];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/payment/cash_accounts/%@/password",Request_Header,_idNumber] parameters:@{@"ticket_token":[[NSUserDefaults standardUserDefaults]valueForKey:@"ticket_token"],@"pament_password":self.passwordText.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        [self loginStates:dic];
        
        if ([dic[@"status"]isEqualToNumber:@1]) {
            /* 设置支付密码成功*/
            [self HUDStopWithTitle:@"设置成功!"];
            [self performSelector:@selector(setPaymentSuccess) withObject:nil afterDelay:1];
            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"have_paypassword"];
            
            /**设置支付密码成功了*/
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SetPayPasswordSuccess" object:nil];
            
        }else{
            /* 设置失败,*/
            [self HUDStopWithTitle:@"密码设置失败,请核对信息!"];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


/* 设置成功后 ,返回到安全管理页面*/
- (void)setPaymentSuccess{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isMemberOfClass:[SafeViewController class]]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PopToRoot" object:nil];
            [self.navigationController popToViewController:controller animated:YES];
            
        }
    
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
