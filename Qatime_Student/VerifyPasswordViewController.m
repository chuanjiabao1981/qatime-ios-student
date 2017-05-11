//
//  VerifyPasswordViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/20.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VerifyPasswordViewController.h"
#import "NavigationBar.h"
#import "VerifyPasswordView.h"
#import "UIViewController+HUD.h"
#import "BindingMailViewController.h"


@interface VerifyPasswordViewController (){
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    NSMutableArray <UIImageView *>*_imageArr;
    
    NSString *_ticketToken;
    
    VerifyType _verifyType;
    
}
@property (nonatomic, strong) VerifyPasswordView *mainView ;

@end

@implementation VerifyPasswordViewController

-(instancetype)initWithType:(VerifyType)verifyType{
    
    self = [super init];
    if (self) {
       
        _verifyType = verifyType;
        
    }
    return self;
}



- (void)setupNavigation{
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    _navigationBar.titleLabel.text = @"验证密码";
}


- (void)setupMainView{
    
    _mainView = [[VerifyPasswordView alloc]initWithFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd-Navigation_Height)];
    [self.view addSubview:_mainView];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    [self setupMainView];
    
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
    
    /* 赋值*/
    _imageArr = [NSMutableArray arrayWithArray:_mainView.imageArr];
    
    for (int i = 0; i<_imageArr.count; i++) {
        
        UITapGestureRecognizer *press = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterPress)];
        
        [_imageArr[i] addGestureRecognizer:press];
        
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
            
            [self requestTicketToken:textfield.text];
        }
        
    }
    
}

/* 请求ticket token*/
- (void)requestTicketToken:(NSString *)password{
    
    [self loadingHUDStartLoadingWithTitle:@"验证密码"];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/students/%@/verify_current_password",Request_Header,_idNumber] parameters:@{@"current_password":_passwordText.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        [self loginStates:dic];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            /* 获取成功*/
            if (dic[@"data"]!=nil) {
                
                _ticketToken = [NSString stringWithFormat:@"%@",dic[@"data"]];
                
                [self loadingHUDStopLoadingWithTitle:nil];
                
                [self performSelector:@selector(nextPage) withObject:nil afterDelay:1];
            }
            
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

//进入家长手机修改页面  或者 邮箱绑定页面
- (void)nextPage{
    
    if (_verifyType == ParentPhoneType) {
        
        ParentViewController *controller = [[ParentViewController alloc]initWithPhone:[[NSUserDefaults standardUserDefaults] valueForKey:@"parent_phone"] andTicketToken:_ticketToken];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (_verifyType == BindingEmail){
        
        BindingMailViewController *controller = [[BindingMailViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
        
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
