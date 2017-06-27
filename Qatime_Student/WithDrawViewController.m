//
//  WithDrawViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "WithDrawViewController.h"
#import "NavigationBar.h"


#import "UIViewController+HUD.h"
#import "DCPaymentView.h"
#import "UIViewController+AFHTTP.h"
#import "UIAlertController+Blocks.h"
#import "AuthenticationViewController.h"
#import "WXApi.h"
#import "WithdrawConfirmViewController.h"


@interface WithDrawViewController ()<UITextFieldDelegate,WXApiDelegate>{
    
    NavigationBar *_navigationBar;
    
    /* 选择支付方式*/
    //    BOOL choseAlipay;
    //    BOOL choseTransfer;
    
    NSString *_payType;
    NSString *_token;
    NSString *_idNumber;
    
    /*余额*/
    NSString *_balance;
    
    //tickettoken
    NSString *_ticketToken;
    
}

@end

@implementation WithDrawViewController


-(instancetype)initWithEnableAmount:(NSString *)amount{
    
    self = [super init];
    if (self) {
        
        _balance = [NSString stringWithFormat:@"%@",amount];
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = ({
        
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        _.titleLabel.text= @"提现申请";
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_];
        _;
        
    });
    
    
    _withDrawView = ({
        
        WithDrawView *_=[[WithDrawView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
        _.moneyText.placeholder = [NSString stringWithFormat:@"请输入提现金额(¥%.2f可用)",_balance.floatValue];
        
        [_.nextStepButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
        _.moneyText.delegate = self;
        
        [self.view addSubview:_];
        _;
        
    });
    
    
    /* 初始化*/
    _payType = @"weixin";
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    
    //微信验证回调
    
    [[NSNotificationCenter defaultCenter]addObserverForName:@"WechatLoginSucess" object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
       
        NSString *code = [note object];
        //发送提现请求
        [self requestWithDraw:code];
        
    }];
    
    
}


/* 下一步*/
- (void)nextStep{
    
    if ([_withDrawView.moneyText.text isEqualToString:@""]) {
        
        [self HUDStopWithTitle:@"请输入提现金额!"];
        
        
    }else{
        
        /* 输入金额正确,而且选择提现方式的前提下,发起提现申请,先查余额*/
        if (![_withDrawView.moneyText.text isEqualToString:@""]) {
            
            
            [self compareWithBalance:_balance];
            
        }
        
    }
}



/* 比较余额*/
- (void)compareWithBalance:(NSString *)balance{
    
    /* 提现金额大于等于余额 可以提现*/
    if ([_withDrawView.moneyText.text floatValue]<=[balance floatValue] ) {
        
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"have_paypassword"]) {
            if([[NSUserDefaults standardUserDefaults]boolForKey:@"have_paypassword"]==NO) {
                /* 没有支付密码,需要用户设置支付密码*/
                [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"您尚未设置支付密码!\n请先设置支付密码" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            }else{
                
                [DCPaymentView showPayAlertWithTitle:@"请输入支付密码" andDetail:@"提现申请" andAmount:_withDrawView.moneyText.text.floatValue completeHandle:^(NSString *inputPwd) {
                    
                    /* 验证ticket_token*/
                    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/withdraws/ticket_token",Request_Header,_idNumber]  withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:@{@"password":inputPwd} completeSuccess:^(id  _Nullable responds) {
                        
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                        [self loginStates:dic];
                        if ([dic[@"status"]isEqualToNumber:@1]) {
                            
                            _ticketToken = [NSString stringWithFormat:@"%@",dic[@"data"]];
                            
                            //验证完支付密码之后,直接拉起微信请求
                            [self requestWechat];
                            
                        }else{
                            
                            ///////
                            
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
                                            
                                            
                                        }
                                        
                                    }];
                                }else if ([dic[@"error"][@"code"]integerValue]==2008){
                                    //新设置密码,未过24小时
                                    [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"新设置的支付密码未满24小时，为保证账户安全暂不可用。 " cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                        
                                        [self returnLastPage];
                                        
                                    }];
                                    
                                    
                                }else if([dic[@"error"][@"code"]integerValue]==2006){
                                    [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"您尚未设置支付密码!\n请先设置支密码" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                        
                                        [self.navigationController popViewControllerAnimated:YES];
                                        
                                    }];
                                    
                                }
                            }
                            
                        }
                    }];
                    
                }];
                
                
            }
        }
        
        
        
    }else{
        
        [UIAlertController showAlertInViewController:self withTitle:@"提示"  message:@"余额不足!" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
        }];
        
    }
    
}



/* 判断输入的金额数字是否正确*/

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    NSCharacterSet *cs;
    
    if ([textField isEqual:_withDrawView.moneyText]) {
        NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
        if (NSNotFound == nDotLoc && 0 != range.location) {
            cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.\n"] invertedSet];
        }
        else {
            cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\n"] invertedSet];
        }
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            
            [self HUDStopWithTitle:@"只能输入数字和小数点"];
            return NO;
        }
        if (NSNotFound != nDotLoc && range.location > nDotLoc + 2) {
            [self HUDStopWithTitle:@"小数点后最多两位"];
            return NO;
        }
    }
    
    return  YES;
}

/** 拉起微信请求 */
- (void)requestWechat{
    
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ]  ;
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    
    [WXApi sendAuthReq:req viewController:self delegate:self];
    
}

/** 发起提现请求 传code进去 */
- (void)requestWithDraw:(NSString *)code{
    
    [self POSTSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/withdraws",Request_Header,_idNumber] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:@{@"amount":_withDrawView.moneyText.text,@"pay_type":@"weixin",@"ticket_token":_ticketToken,@"app_type":@"student_app",@"access_code":code} completeSuccess:^(id  _Nullable responds) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
        //申请提现成功.
            
            WithdrawConfirmViewController *contorller = [[WithdrawConfirmViewController alloc]initWithData:dic[@"data"]];
            [self.navigationController pushViewController:contorller animated:YES];
            
        }else{
            
            [self HUDStopWithTitle:@"申请提现失败,请稍后重试"];
        }
        
        
    } failure:^(id  _Nullable erros) {
        
        [self HUDStopWithTitle:@"网络正忙,请稍后重试"];
        
    }];
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
