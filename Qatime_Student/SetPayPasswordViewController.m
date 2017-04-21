//
//  SetPayPasswordViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "SetPayPasswordViewController.h"
#import "NavigationBar.h"

#import "SetNewPasswordViewController.h"
#import "UIViewController+HUD.h"
#import "AuthenticationViewController.h"
#import "SafeViewController.h"

@interface SetPayPasswordViewController (){
    
    /* 保存密码图框的 数组*/
    NSMutableArray <UIImageView *>*_imageArr;
    
    NSString *_token;
    NSString *_idNumber;
    
}

@end

@implementation SetPayPasswordViewController

-(instancetype)initWithPageType:(SetPayPassordType)type{
    
    self = [super init];
    if (self) {
        
        _pageType = type;
    }
    return self;
    
    
}

-(void)loadView{
    
    [super loadView];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
    [self.view addSubview:_navigationBar];
    
    _setPayPasswordView = [[SetPayPasswordView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
   
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }

    
    /* 隐藏的但是真实存在的输入框*/
    _passwordText = [[UITextField alloc]initWithFrame:CGRectMake(-30, 100, 1, 30)];
    _passwordText.alpha = 1;
    _passwordText.layer.borderColor = [UIColor clearColor].CGColor;
    _passwordText.layer.borderWidth = 1;
    [self.view addSubview:_passwordText];
    [_passwordText becomeFirstResponder];
    _passwordText.keyboardType = UIKeyboardTypeNumberPad;
    
    [_passwordText addTarget:self action:@selector(changeLetters:) forControlEvents:UIControlEventEditingChanged];
    
     [self.view addSubview:_setPayPasswordView];
    
       
    /* 赋值*/
    _imageArr = [NSMutableArray arrayWithArray:_setPayPasswordView.imageArr];
    
    for (int i = 0; i<_imageArr.count; i++) {
        
        UITapGestureRecognizer *press = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterPress)];
        
        [_imageArr[i] addGestureRecognizer:press];
        
    }
    
    /* 根据不同类型的页面 进行不同的设置*/
    switch (_pageType) {
        case VerifyPassword:{
            _navigationBar.titleLabel.text = @"验证支付密码";
            
            _setPayPasswordView.findPayPasswordButton.hidden = NO;
            
            [_setPayPasswordView.findPayPasswordButton addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
            _setPayPasswordView.finishButton.hidden = YES;
            
        }
            
            break;
            
        case SetNewPassword:{
            _navigationBar.titleLabel.text = @"设置新支付密码";
            _setPayPasswordView.findPayPasswordButton.hidden = YES;
            _setPayPasswordView.finishButton.hidden = YES;
            
        }
            break;
            
        case CompareNewPassword:{
            _navigationBar.titleLabel.text = @"确认新支付密码";
            _setPayPasswordView.findPayPasswordButton.hidden = YES;
            _setPayPasswordView.finishButton.hidden = YES;
            
        }
            break;
    }
    
    /* 两次密码输入错误的时候跳转回前一页面,输入框清零*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnZero) name:@"PayPasswordTurnZero" object:nil];
    
    
}

/* 数据清零*/
- (void)turnZero{
    
    for (UIImageView *image in _imageArr) {
        [image setImage:nil];
    }
    
    _passwordText.text = @"";
    [_passwordText becomeFirstResponder];
    
}

/* 点击图片框,输入框成为第一响应者*/
- (void)enterPress{
    
    [_passwordText becomeFirstResponder];
    
}

/* 用户输入或改变输入字符的方法*/
- (void)changeLetters:(UITextField *)textfield{
    
    if (textfield.text.length >6) {
        textfield.text =  [textfield.text substringToIndex:6];
        
    }
    
    
    if (textfield.text.length<=6) {
        
        for (NSInteger i = 0; i<6; i++) {
            [_imageArr[i] setImage:nil];
        }
        
        
        for (NSInteger i=0; i<textfield.text.length; i++) {
            
            [_imageArr[i] setImage:[UIImage imageNamed:@"blackdot"]];
            
        }
        
        if (textfield.text.length == 6) {
            if (_pageType == SetNewPassword) {
                
                /*进入下一页*/
                [self bringPasswordToNextPage:textfield.text];
                
                
            }else if (_pageType == VerifyPassword){
                
                /* 进入下一页*/
                [self requestTicketToken:textfield.text];
                
            }
            
            
        }
        
        
        
    }
    
}


/* 忘记密码*/
- (void)findPassword{
    
    AuthenticationViewController *chek = [[AuthenticationViewController alloc]init];
    [self.navigationController pushViewController:chek animated:YES];
    
}

/* 请求ticket token*/
- (void)requestTicketToken:(NSString *)password{
    
    [self loadingHUDStartLoadingWithTitle:@"核对密码"];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/payment/cash_accounts/%@/password/ticket_token",Request_Header,_idNumber] parameters:@{@"current_pament_password":_passwordText.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        [self loginStates:dic];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            /* 获取成功*/
            if (dic[@"data"]!=nil) {
                [[NSUserDefaults standardUserDefaults]setValue:dic[@"data"] forKey:@"ticket_token"];
            }
            [self loadingHUDStopLoadingWithTitle:nil];
            
            [self performSelector:@selector(changeNewPassword) withObject:nil afterDelay:1];
            
            
            
        }else{
            /* 获取失败*/
            [self loadingHUDStopLoadingWithTitle:@"密码错误!"];
            _passwordText.text = @"";
            for (UIImageView *image in _imageArr) {
                [image setImage:nil];
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

/* 修改密码*/
- (void)changeNewPassword{
    
    SetPayPasswordViewController *new = [[SetPayPasswordViewController alloc]initWithPageType:SetNewPassword];
    [self.navigationController pushViewController:new animated:YES];
    
    
}


/* 把已输入的密码传入下一页*/
- (void)bringPasswordToNextPage:(NSString *)password{
    
    SetNewPasswordViewController *new = [[SetNewPasswordViewController alloc]initWithType:CompareNewPassword andPassword:_passwordText.text];
    [self.navigationController pushViewController:new animated:YES];
    
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_passwordText resignFirstResponder];
}


/* 返回到安全管理页*/
- (void)returnLastPage{
    
    for (UIViewController *control in self.navigationController.viewControllers) {
        
        if ([control isMemberOfClass:[SafeViewController class]]) {
            
            [self.navigationController popToViewController:control animated:YES];
            return;
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    
    
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
