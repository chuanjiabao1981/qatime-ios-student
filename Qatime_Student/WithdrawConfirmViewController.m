//
//  WithdrawConfirmViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/12.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "WithdrawConfirmViewController.h"
#import "NavigationBar.h"
#import "NSString+TimeStamp.h"
#import "UIViewController+HUD.h"
#import "MyWalletViewController.h"


@interface WithdrawConfirmViewController (){
    
    NSDictionary *_dataDic;
    
    NavigationBar *_navigationBar;
}


@end

@implementation WithdrawConfirmViewController

-(instancetype)initWithData:(NSDictionary *)datadic{
    
    self  =[super init];
    if (self) {
        
        
        _dataDic = [NSDictionary dictionaryWithDictionary:datadic];
        
        
    }
    return  self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self HUDStopWithTitle:@"申请成功!"];
    
    _navigationBar = ({
    
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        
        _.titleLabel.text = @"交易确认";
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_];
        _;
    
    });
    
    _withdrawConfirmView=({
        WithdrawConfirmView *_=[[WithdrawConfirmView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
        
        if (_dataDic) {
            _.orderNumber.text = _dataDic[@"transaction_no"];
            _.time.text = [_dataDic[@"created_at"] timeStampToDate] ;
            
            if ([_dataDic[@"pay_type"]isEqualToString:@"bank"]) {
                _.method.text = @"银行账户";
            }else if ([_dataDic[@"pay_type"]isEqualToString:@"alipay"]){
                
                _.method.text = @"支付宝";
            }
            _.money.text = [NSString stringWithFormat:@"¥%@",_dataDic[@"amount"]];
//            _.fee.text = @"¥0.0" ;
            
            [_.finishButton addTarget:self action:@selector(requestWithDrawSucess) forControlEvents:UIControlEventTouchUpInside];
            
            
        }else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"数据错误!" preferredStyle:UIAlertControllerStyleAlert];
          
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }] ;
            
            
            [alert addAction:sure];
            
            [self presentViewController:alert animated:YES completion:nil];

            
            
        }
        
        
        
        
        [self.view addSubview:_];
        _;
    });
    
    
    
}

/* 请求成功,弹提示框*/
- (void)requestWithDrawSucess{
    
//    [self HUDStopWithTitle:@"提现申请成功!"];
    
    [self performSelector:@selector(pop) withObject:nil afterDelay:1];
    
    
}

- (void)pop{
    
    MyWalletViewController *mywVC = [MyWalletViewController new];
    UIViewController *controller = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[mywVC class]]) {
            
            controller = vc;
        }
    }
    
    [self.navigationController popToViewController:controller animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PopToRoot" object:nil];
 
}


- (void)returnLastPage{
    
    MyWalletViewController *mywVC = [MyWalletViewController new];
    UIViewController *controller = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[mywVC class]]) {
            
            controller = vc;
            [self.navigationController popToViewController:controller animated:YES];
       
        }else{
            
//            [self.navigationController popViewControllerAnimated:YES];
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
