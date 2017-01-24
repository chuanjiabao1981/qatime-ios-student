//
//  WithDrawViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "WithDrawViewController.h"
#import "NavigationBar.h"
#import "WithDrawInfoViewController.h"

#import "UIViewController+HUD.h"
#import "DCPaymentView.h"
#import "UIViewController+AFHTTP.h"
#import "UIAlertController+Blocks.h"
#import "AuthenticationViewController.h"

@interface WithDrawViewController ()<UITextFieldDelegate>{
    
    NavigationBar *_navigationBar;
    
    /* 选择支付方式*/
//    BOOL choseAlipay;
//    BOOL choseTransfer;
    
    NSString *_payType;
    NSString *_token;
    NSString *_idNumber;
    
    /*余额*/
    NSString *_balance;
    

    
}

@end

@implementation WithDrawViewController

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
        
        [_.alipayButton addTarget:self action:@selector(selectedAlipay:) forControlEvents:UIControlEventTouchUpInside];
        [_.transferButton addTarget:self action:@selector(selectedTransfer:) forControlEvents:UIControlEventTouchUpInside];
        
        [_.nextStepButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
        _.moneyText.delegate = self;
        
        [self.view addSubview:_];
        _;
    
    });
    
    
    /* 初始化*/
    _payType = [NSString string];
    _balance = [NSString string];
    
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }

    
}


/* 下一步*/
- (void)nextStep{
    
    __block NSString *ticket_token;
    
    
    if ([_withDrawView.moneyText.text isEqualToString:@""]) {
      
        [self loadingHUDStopLoadingWithTitle:@"请输入提现金额!"];
      

    }else{
        
        if (_withDrawView.alipayButton.selected ==NO&&_withDrawView.transferButton.selected == NO) {
            
            [self loadingHUDStopLoadingWithTitle:@"请选择提现方式!"];
            
        }else{
            
            /* 输入金额正确,而且选择提现方式的前提下,发起提现申请,先查余额*/
            if (![_withDrawView.moneyText.text isEqualToString:@""]&&(_withDrawView.transferButton.selected==YES||_withDrawView.alipayButton.selected ==YES)) {
                
                
                if ([[NSUserDefaults standardUserDefaults]objectForKey:@"balance"]) {
                    
                    _balance = [[NSUserDefaults standardUserDefaults]objectForKey:@"balance"];
                    
                    [self compareWithBalance:_balance];
                    
                    
                }else{
                    /* 如果本地没有保存余额数据,向服务器请求余额数据*/
                    
                    
                }
                
            }
        }
        
    }
}



#pragma mark- 请求余额数据

- (void)requestBalance{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/cash",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            _balance = dic[@"data"][@"balance"];
            
            [self compareWithBalance:_balance];
            
        }else{
            
            [self loadingHUDStopLoadingWithTitle:@"获取余额数据错误!"];
            
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}


/* 比较余额*/
- (void)compareWithBalance:(NSString *)balance{
    
    /* 提现金额大于等于余额 可以提现*/
    if ([_withDrawView.moneyText.text floatValue]<=[balance floatValue] ) {
        
        if (_withDrawView.transferButton.selected==YES) {
            
            _payType = @"bank";
        }else if (_withDrawView.alipayButton.selected ==YES){
            
            _payType = @"alipay";
        }
        
        [DCPaymentView showPayAlertWithTitle:@"请输入支付密码" andDetail:@"提现申请" andAmount:_withDrawView.moneyText.text.floatValue completeHandle:^(NSString *inputPwd) {
            
            /* 验证ticket_token*/
            [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/withdraws/ticket_token",Request_Header,_idNumber]  withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:@{@"password":inputPwd} completeSuccess:^(id  _Nullable responds) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                if ([dic[@"status"]isEqualToNumber:@1]) {
                    /* 支付密码验证成功,进入下一页*/
                    WithDrawInfoViewController *infoVC = [[WithDrawInfoViewController alloc]initWithAmount:_withDrawView.moneyText.text andPayType:_payType andTicketToken:dic[@"data"]];
                    
                    [self.navigationController pushViewController:infoVC animated:YES];
                    
                    
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
                            
                            
                        }
                    }
                    
                }
            }];
            
        }];
        
        
    }else{
        
        [UIAlertController showAlertInViewController:self withTitle:@"提示"  message:@"余额不足!" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
        }];
        
    }
    
    
}



/* 选择支付宝*/
- (void)selectedAlipay:(UIButton *)sender{
    
    if (sender.selected == YES) {
        sender.selected = NO;
        [sender setImage:nil forState:UIControlStateNormal];
        
        
    }else{
        sender.selected = YES;
        [sender setImage:[UIImage imageNamed:@"redDot"] forState:UIControlStateNormal];
        _withDrawView.transferButton.selected = NO;
        [_withDrawView.transferButton setImage:nil forState:UIControlStateNormal];
        
    }
    
    
    
}
/* 选择转账*/
- (void)selectedTransfer:(UIButton *)sender{
    
    if (sender.selected == YES) {
        sender.selected = NO;
        [sender setImage:nil forState:UIControlStateNormal];
        
        
    }else{
        sender.selected = YES;
        [sender setImage:[UIImage imageNamed:@"redDot"] forState:UIControlStateNormal];
        _withDrawView.alipayButton.selected = NO;
        [_withDrawView.alipayButton setImage:nil forState:UIControlStateNormal];
        
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
            
            [self loadingHUDStopLoadingWithTitle:@"只能输入数字和小数点"];
            return NO;
        }
        if (NSNotFound != nDotLoc && range.location > nDotLoc + 2) {
            [self loadingHUDStopLoadingWithTitle:@"小数点后最多两位"];
            return NO;
        }
    }
    
    return  YES;
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
