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
#import "ParentViewController.h"


@interface VerifyPasswordViewController (){
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;

    NSString *_ticketToken;
    
    
}
@property (nonatomic, strong) VerifyPasswordView *mainView ;

@end

@implementation VerifyPasswordViewController


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
    
    [_mainView.passwordText addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_mainView.nextButton addTarget:self action:@selector(requestTicketToken:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)textDidChange:(UITextField *)textField{
    
    if ([textField.text isEqualToString:@""]) {
        
        _mainView.nextButton.enabled = NO;
        _mainView.nextButton.layer.borderColor = TITLECOLOR.CGColor;
        [_mainView.nextButton setBackgroundColor:TITLECOLOR];
        [_mainView.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
        _mainView.nextButton.enabled = YES;
        _mainView.nextButton.layer.borderColor = NAVIGATIONRED.CGColor;
        [_mainView.nextButton setBackgroundColor:[UIColor whiteColor]];
        [_mainView.nextButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
    }
    
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
    
    /* 两次密码输入错误的时候跳转回前一页面,输入框清零*/
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnZero) name:@"PayPasswordTurnZero" object:nil];
    
}


/* 请求ticket token*/
- (void)requestTicketToken:(NSString *)password{
    
    [self HUDStartWithTitle:@"验证密码"];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/students/%@/verify_current_password",Request_Header,_idNumber] parameters:@{@"current_password":_mainView.passwordText.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        [self loginStates:dic];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            /* 获取成功*/
            if (dic[@"data"]!=nil) {
                
                _ticketToken = [NSString stringWithFormat:@"%@",dic[@"data"]];
                
                [self HUDStopWithTitle:nil];
                
                [self performSelector:@selector(nextPage:) withObject:_ticketToken afterDelay:1];
            }
            
        }else{
            /* 获取失败*/
            [self HUDStopWithTitle:@"密码错误!"];
            _mainView.passwordText.text = @"";
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

//进入家长手机修改页面  或者 邮箱绑定页面
- (void)nextPage:(NSString *)ticketToken{
    
   ParentViewController* controller = [[ParentViewController alloc]initWithPhone:[[NSUserDefaults standardUserDefaults]valueForKey:@"parent_phone"] andTicketToken:ticketToken];
    
    [self.navigationController pushViewController:controller animated:YES];
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
