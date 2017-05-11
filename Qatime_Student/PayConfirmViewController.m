//
//  PayConfirmViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/13.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "PayConfirmViewController.h"

#import "NSString+TimeStamp.h"
#import "UIViewController+HUD.h"
#import "WXApi.h"
//#import "CheckChargeViewController.h"
#import "DCPaymentView.h"
#import "UIAlertController+Blocks.h"
#import "AuthenticationViewController.h"
#import "UIViewController+AFHTTP.h"
#import "TutoriumInfoViewController.h"
#import "MyOrderViewController.h"
#import "CheckOrderViewController.h"

@interface PayConfirmViewController (){
    
    NavigationBar *_navigationBar;
    
    /* 订单信息*/
    NSMutableDictionary *_dataDic;
    
    NSString *_token;
    NSString *_idNumber;
    
    /* 订单支付token*/
    NSString *_ticketToken;
    
}

@end

@implementation PayConfirmViewController

-(instancetype)initWithData:(NSDictionary *)dataDic{
   
    self = [super init];
    if (self) {
        
        _dataDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
        
    }

    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = ({
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        _.titleLabel.text = @"支付确认";
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_];
        _;
    });
    
    _payConfirmView = ({
    
        PayConfirmView *_=[[PayConfirmView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
        
        if (_dataDic) {
            
            _.number.text = _dataDic[@"id"];
            _.time.text = [_dataDic[@"created_at"] timeStampToDate];
            _.type.text = @"余额支付";
            _.money.text = [NSString stringWithFormat:@"¥%@",_dataDic[@"amount"]];
            
            [_.finishButton addTarget:self action:@selector(payForOrder) forControlEvents:UIControlEventTouchUpInside];
        }else{
            
            /* 数据拉取失败*/
            [self loadingHUDStopLoadingWithTitle:@"获取数据失败!"];

            [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
        }
        
        [self.view addSubview:_];
        _;
    
    });
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    /* 注册微信支付成功或失败的通知*/
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CheckPayStatus) name:@"ChargeSucess" object:nil];
    
}

#pragma mark- 支付订单
- (void)payForOrder{

    /* 余额支付*/
    [self payWithBalance];
    
}


#pragma mark- 余额支付
- (void)payWithBalance{
    
    [DCPaymentView showPayAlertWithTitle:@"请输入支付密码" andDetail:_dataDic[@"productName"] andAmount:[_dataDic[@"amount"]  floatValue] completeHandle:^(NSString *inputPwd) {
        
        [self loadingHUD];
        
        /* 输入完成后,先访问服务器,获取tickettoken,然后在用tickettoken去请求支付*/
        NSLog(@"%@",inputPwd);
        
        [self POSTSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/orders/%@/pay/ticket_token",Request_Header,_dataDic[@"id"]] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:@{@"password":inputPwd} completeSuccess:^(id  _Nullable responds) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
            
            [self loginStates:dic];
            if ([dic[@"status"]isEqualToNumber:@1]) {
                /* 获取ticket token成功*/
                NSLog(@"%@", dic[@"data"]);
                
                _ticketToken = [NSString stringWithFormat:@"%@",dic[@"data"]];
                
                [self POSTSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/orders/%@/pay",Request_Header,_dataDic[@"id"]] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:@{@"ticket_token":_ticketToken} completeSuccess:^(id  _Nullable responds) {
                   
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                    [self loginStates:dic];
                    if ([dic[@"status"]isEqualToNumber:@1]) {
                        /* 付款成功*/
                        NSLog(@"%@",dic[@"data"]);
                        
                        [self stopHUD];
                        [self loadingHUDStopLoadingWithTitle:@"支付成功"];
                        
                        [[NSNotificationCenter defaultCenter ]postNotificationName:@"RefreshTutoriumInfo" object:nil];
                        
                        [self CheckPayStatus:dic[@"data"][@"id"] andAmount:dic[@"data"][@"amount"]];
                        
                        
                    }else{
                        /* 付款失败*/
                        [self stopHUD];
                         NSLog(@"%@",dic[@"data"]);
                         [self loadingHUDStopLoadingWithTitle:@"购买失败!"];
                        [self performSelector:@selector(returnInfoPage) withObject:nil afterDelay:1];
                    }
                    
                    
                }];
                
            }else{
                /* 验证信息错误*/
//                "code" :2005
//                "msg":"APIErrors::PasswordInvalid"  密码错误
//
//                "code": 2008,
//                "msg": "APIErrors::PasswordDissatisfy"
                if (dic[@"error"]) {
                    if ([dic[@"error"][@"code"]integerValue]==2005) {
                        //支付密码错误
                        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"支付密码错误" cancelButtonTitle:@"重试" destructiveButtonTitle:nil otherButtonTitles:@[@"找回支付密码"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                            
                            if (buttonIndex!=0) {
                                
                                [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"新设置或修改后将在24小时内不能使用支付密码,是否继续?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"继续"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                    if (buttonIndex!=0) {
                                        
                                        AuthenticationViewController *controller = [[AuthenticationViewController alloc]init];
                                        [self.navigationController pushViewController:controller animated:YES];
                                    }
                                    
                                }];
                            }else if(buttonIndex == 0){
                                
                                [self payWithBalance];
                            }
                            
                        }];
                    }else if ([dic[@"error"][@"code"]integerValue]==2008){
                        //新设置密码,未过24小时
                        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"新设置的支付密码未满24小时，为保证账户安全暂不可用。 " cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                           
                        }];
                        
                    }
                }
            }
            
        }];
        
    }];
}


#pragma mark- 访问服务器,查询支付是否成功
- (void)CheckPayStatus:(NSString *)inNumber andAmount:(NSString *)amount{
    
    [NSThread sleepForTimeInterval:2];
    
    CheckOrderViewController *controller = [[CheckOrderViewController alloc]initWithIDNumber:inNumber andAmount:amount];
    [self.navigationController pushViewController:controller animated:YES];
    
}


- (void)returnLastPage{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)returnInfoPage{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isMemberOfClass:[TutoriumInfoViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }else if ([controller isMemberOfClass:[MyOrderViewController class]]){
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
