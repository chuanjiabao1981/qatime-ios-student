//
//  OrderViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/12.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "OrderViewController.h"
#import "NavigationBar.h"

#import "TutoriumList.h"
#import "YYModel.h"
#import "UIImageView+WebCache.h"


#import "UIViewController+HUD.h"
#import "PayConfirmViewController.h"
#import "UIAlertController+Blocks.h"
#import "WXApi.h"

#import "UIViewController+AFHTTP.h"


typedef enum : NSUInteger {
    AutoWrite,  //扫码自动填写的优惠码
    ManullyWrite,   //手动填写的优惠码
} PromotionCodeWriteType;



@interface OrderViewController (){
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    /* 保存一个比较用的价格*/
    
    CGFloat price;
    
    /* 是否可以使用余额*/
    BOOL balanceEnable;
    
    /* 支付方式*/
    NSString *_payType;
    
    /* 订单成功后,收到的数据,传入下一页*/
    NSDictionary *dataDic;
    
    
    /* 优惠码*/
    NSString *_promotionCode;
    
    /* 是否隐藏"使用优惠码"按钮*/
    BOOL hidePromotionCodeButton;
    
}

@end

@implementation OrderViewController

-(instancetype)initWithClassID:(NSString *)classID{
    
    self= [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
    }
    return self;
    
}

-(instancetype)initWithClassID:(NSString *)classID andPromotionCode:(NSString *)promotionCode{
    
    self= [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
        _promotionCode = [NSString stringWithFormat:@"%@",promotionCode];
        
        hidePromotionCodeButton = YES;
        
    }
    return self;
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = ({
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        _.titleLabel.text = @"订单确认";
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_];
        _;
    });
    
    
    _orderView = ({
        
        OrderView *_=[[OrderView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
        
        [_.wechatButton addTarget:self action:@selector(chooseWechat:) forControlEvents:UIControlEventTouchUpInside];
        [_.alipayButton addTarget:self action:@selector(chooseAlipay:) forControlEvents:UIControlEventTouchUpInside];
        [_.balanceButton addTarget:self action:@selector(chooseBalance:) forControlEvents:UIControlEventTouchUpInside];
        [_.applyButton addTarget:self action:@selector(applyOrder) forControlEvents:UIControlEventTouchUpInside];
        
        [_.promotionButton addTarget:self action:@selector(enterPromotionCode:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_.sureButton addTarget:self action:@selector(checkPromotionCode) forControlEvents:UIControlEventTouchUpInside];
        
        /* 一个点击空白处取消响应的方法*/
        UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textResignFirstResponder)];
        [_ addGestureRecognizer:tap];
        
        [self.view addSubview:_];
        
        /* 是包含优惠码,是否显示和不显示使用优惠码按钮*/
        if (hidePromotionCodeButton == YES) {
            
            _.promotionButton.hidden = YES;
        }else{
            
        }
        
        if (_promotionCode && hidePromotionCodeButton == YES) {
            
            _.promotionText.text = _promotionCode;
            
            [self performSelector:@selector(checkDefaultPromotionCode) withObject:nil];
            
        }else{
            
        }
        
        
        _;
    });
    
    
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    
    /* 初始化*/
    _payType = @"".mutableCopy;
    dataDic = @{}.mutableCopy;
    
    /* 默认选择微信支付*/
    _orderView.wechatButton.selected = YES;
    
    _payType = @"weixin";
    [_orderView.wechatButton setImage:[UIImage imageNamed:@"redDot"] forState:UIControlStateNormal];
    
    
    /* 请求课程详细信息数据*/
    [self requestClassInfo];
    
    
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}



/* 请求课程详细信息*/
- (void)requestClassInfo{
    
    if (_token&&_idNumber) {
        
        if (_classID!=nil) {
            
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
            [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses/%@",Request_Header,_classID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                [self loginStates:dic];
                if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                    /* 数据请求成功*/
                    TutoriumListInfo *mod = [TutoriumListInfo yy_modelWithJSON:dic[@"data"]];
                    
                    /* 成功后赋值*/
                    _orderView.className.text = mod.name;
                    [_orderView.classImage sd_setImageWithURL:[NSURL URLWithString:mod.publicize]];
                    _orderView.subjectLabel.text = mod.subject;
                    _orderView.gradeLabel.text = mod.grade;
                    _orderView.teacheNameLabel.text = mod.teacher_name;
                    _orderView.classTimeLabel.text = [NSString stringWithFormat:@"共%@课",mod.preset_lesson_count];
                    
                    /* 日期转化*/
                    NSDateFormatter *format = [[NSDateFormatter alloc]init];
                    format.dateFormat = @"yyyy-MM-dd HH:mm";
                    NSDate *startDate = [format dateFromString:mod.live_start_time];
                    NSDate *endDate = [format dateFromString:mod.live_end_time];
                    NSDateFormatter *strFormat= [[NSDateFormatter alloc]init];
                    strFormat.dateFormat = @"yyyy-MM-dd";
                    
                    _orderView.startTimeLabel.text = [strFormat stringFromDate:startDate];
                    _orderView.endTimeLabel.text = [strFormat stringFromDate:endDate];
                    
                    if ([mod.status isEqualToString:@"teaching"]) {
                        _orderView.statusLabel.text = @"开课中";
                    }
                    
                    _orderView.typeLabel.text = @"在线直播";
                    
                    if ([mod.current_price containsString:@"."]) {
                        
                        _orderView.priceLabel.text = [NSString stringWithFormat:@"¥%@元",mod.current_price];
                        
                        _orderView.totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@",mod.current_price];
                        
                        price = mod.current_price.floatValue;
                    }else{
                        _orderView.priceLabel.text = [NSString stringWithFormat:@"¥%@.00元",mod.current_price];
                        
                        _orderView.totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@.00",mod.current_price];
                        
                        price = mod.current_price.floatValue;
                        
                    }
                    
                    
                    /* 请求一次余额 ,判断是否可以用余额支付*/
                    [self requestBalance];
                    
                    
                }else{
                    /* 拉取订单信息失败*/
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该课程暂时不可购买!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self returnLastPage];
                    }] ;
                    [alert addAction:sure];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            
        }
    }
    
    
}

#pragma mark- 请求余额
- (void)requestBalance{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/cash",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        [self loginStates:dic];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 余额请求成功*/
            _orderView.balanceLabel.text = [NSString stringWithFormat:@"(¥%@)",dic[@"data"][@"balance"]];
            
            if (price>=0) {
                /* 判断余额是否可用*/
                if ([dic[@"data"][@"balance"] floatValue]>price) {
                    
                    balanceEnable = YES;
                    [_orderView.balanceButton addTarget:self action:@selector(chooseBalance:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                }else{
                    
                    /* 按钮直接不可用*/
                    
                    balanceEnable = NO;
                    
                    //                    _orderView.balanceButton.enabled = NO;
                    
                    [_orderView.balanceButton addTarget:self action:@selector(chooseBalance:) forControlEvents:UIControlEventTouchUpInside];
                    
                    ///////////////////////////////////////////////////////
                    
                }
                
            }
            
            
        }else{
            /* 余额请求失败,余额不可用*/
            /* 余额啥的都不可用*/
            _orderView.balanceLabel.hidden = YES;
            _orderView.balanceButton.hidden = YES;
            _orderView.balance.hidden = YES;
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


/* 点击输入支付码*/
- (void)enterPromotionCode:(UIButton *)sender{
    
    [UIView animateWithDuration:0.5 animations:^{
        sender.alpha = 0;
    }];
    
    [self performSelector:@selector(promotionButtonHides:) withObject:sender afterDelay:0.6];
    
}

- (void)promotionButtonHides:(id)sender{
    
    _orderView.promotionButton.hidden = YES;
    
}


/* 校验优惠码*/
- (void)checkPromotionCode{
    
    [_orderView.promotionText resignFirstResponder];
    
    if (![_orderView.promotionText.text isEqualToString:@""]) {
        //验证优惠码
     
        _promotionCode =_orderView.promotionText.text;
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"%@/api/v1/payment/coupons/%@/verify",Request_Header,_promotionCode] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
            NSError *error = [NSError new];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            if ([dic[@"status"] isEqualToNumber:@1]) {
                
                _orderView.promotionNum.text = [NSString stringWithFormat:@"已优惠 ¥%@",dic[@"data"][@"price"]];
                
            }else{
                [self loadingHUDStopLoadingWithTitle:@"输入的优惠码不正确"];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];

    }else{
        
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请输入优惠码" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
        }];
    }
    
}


/* 验证扫码扫来的优惠码*/
- (void)checkDefaultPromotionCode{
    
    if (_promotionCode) {
        //验证优惠码
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"%@/api/v1/payment/coupons/%@/verify",Request_Header,_promotionCode] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *error = [NSError new];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            if ([dic[@"status"] isEqualToNumber:@1]) {
                
                _orderView.promotionNum.text = [NSString stringWithFormat:@"已优惠 ¥%@",dic[@"data"][@"price"]];
                
            }else{
                [self loadingHUDStopLoadingWithTitle:@"输入的优惠码不正确"];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }else{
        
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请输入优惠码" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
        }];
    }

}



/* 使用微信支付*/
- (void)chooseWechat:(UIButton *)sender{
    
    if (sender.selected ==NO) {
        sender.selected =YES;
        _payType = @"weixin";
        [sender setImage:[UIImage imageNamed:@"redDot"] forState:UIControlStateNormal];
        
        
        _orderView.alipayButton.selected = NO;
        [_orderView.alipayButton setImage:nil forState:UIControlStateNormal];
        if (_orderView.balanceButton.enabled ==YES) {
            _orderView.balanceButton.selected = NO;
            [_orderView.balanceButton setImage:nil forState:UIControlStateNormal];
            
        }else{
            
        }
        
    }else{
        sender.selected = NO;
        [sender setImage:nil forState:UIControlStateNormal];
        
    }
    
}

/* 使用支付宝支付*/
- (void)chooseAlipay:(UIButton *)sender{
    
    if (sender.selected ==NO) {
        sender.selected =YES;
        _payType = @"alipay";
        [sender setImage:[UIImage imageNamed:@"redDot"] forState:UIControlStateNormal];
        
        _orderView.wechatButton.selected = NO;
        [_orderView.wechatButton setImage:nil forState:UIControlStateNormal];
        if (_orderView.balanceButton.enabled ==YES) {
            _orderView.balanceButton.selected = NO;
            [_orderView.balanceButton setImage:nil forState:UIControlStateNormal];
            
        }else{
            
        }
        
    }else{
        sender.selected = NO;
        [sender setImage:nil forState:UIControlStateNormal];
        
    }
    
    
}


/* 在可以使用余额的情况下 使用余额支付*/
- (void)chooseBalance:(UIButton *)sender{
    
    if (sender.selected ==NO) {
        sender.selected =YES;
        _payType = @"account";
        [sender setImage:[UIImage imageNamed:@"redDot"] forState:UIControlStateNormal];
        _orderView.wechatButton.selected = NO;
        [_orderView.wechatButton setImage:nil forState:UIControlStateNormal];
        _orderView.alipayButton.selected = NO;
        [_orderView.alipayButton setImage:nil forState:UIControlStateNormal];
        
        
    }else{
        sender.selected = NO;
        //        _payType = @"";
        [sender setImage:nil forState:UIControlStateNormal];
        
    }
    
    
}
#pragma mark- 准备提交订单
- (void)applyOrder{
    
    /* 在没有选择任何支付方式的情况下*/
    if (_orderView.wechatButton.selected==NO&&_orderView.balanceButton.selected==NO&&_orderView.alipayButton.selected == NO) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择支付方式!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        /* 选择了支付方式,就直接提交订单*/
        [self finishAndCommit];
        
    }
    
    
    
    //    if (balanceEnable==NO) {
    //
    //            }else{
    //        if (_orderView.wechatButton.selected==NO&&_orderView.alipayButton.selected==NO&&_orderView.balanceButton.selected==NO) {
    //            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择支付方式!" preferredStyle:UIAlertControllerStyleAlert];
    //            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //            }] ;
    //            [alert addAction:sure];
    //
    //            [self presentViewController:alert animated:YES completion:nil];
    //
    //        }else{
    //
    //            /* 就直接提交订单*/
    //            [self finishAndCommit];
    //
    //        }
    //
    //    }
    
}

#pragma mark- 提交课程订单
- (void)finishAndCommit{
    
    if (_classID&&_token) {
        if ([_payType isEqualToString:@"weixin"]) {
            
            //            if ([WXApi isWXAppInstalled]==YES) {
            //                [self loadingHUDStartLoadingWithTitle:@"提交订单"];
            
            [self postOrderInfo];
            
            //            }else{
            ////                [self loadingHUDStopLoadingWithTitle:@"尚未安装微信"];
            //                [self loadingHUDStopLoadingWithTitle:@"尚未安装微信"];
            //
            //            }
            
            
        }else if ([_payType isEqualToString:@"account"]){
            
            if (balanceEnable == YES) {
                
                [self postOrderInfo];
                
                
            }else{
                
                [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"余额不足,不可使用余额支付." cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    
                }];
                
            }
            
        }else if ([_payType isEqualToString:@"alipay"]){
            
            [self loadingHUDStopLoadingWithTitle:@"暂不支持"];
            
        }
    }
    
    if (![_payType isEqualToString:@""]) {
        if (_classID&&_token) {
            
        }
        
    }
}

#pragma mark- 发送请求->用户提交订单
- (void)postOrderInfo{
    
    //增加优惠码dictionary.
    NSDictionary *dic ;
    NSString *coupon_code;
    if ([_orderView.promotionText.text isEqualToString:@""]) {
        
        dic = @{@"pay_type":_payType};
    }else{
        coupon_code = _orderView.promotionText.text;
        dic = @{@"pay_type":_payType,@"coupon_code":coupon_code};
        
    }
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses/%@/orders",Request_Header,_classID] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        [self loginStates:dic];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 下单成功*/
            
            [self loadingHUDStopLoadingWithTitle:@"下单成功，请使用网页端支付"];
            
            [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1.5];
            
            
            //            [self loadingHUDStopLoadingWithTitle:nil];
            //
            //            dataDic = [NSDictionary dictionaryWithDictionary:dic[@"data"]];
            //            /* 下单成功,发送下单成功通知*/
            //            [[NSNotificationCenter defaultCenter]postNotificationName:@"OrderSuccess" object:nil ];
            //            [self performSelector:@selector(turnToPayPage) withObject:nil afterDelay:0];
            
        }else{
            
            [self loadingHUDStopLoadingWithTitle:@"订单申请失败!"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}



#pragma mark- 跳转到支付确认页面
- (void)turnToPayPage{
    
    //    if (dataDic) {
    //
    //        PayConfirmViewController *confirm = [[PayConfirmViewController alloc]initWithData:dataDic];
    //
    //        [self.navigationController pushViewController:confirm animated:YES];
    //
    //
    //    }
    
    
}

#pragma mark- 键盘监听

- (void)keyboardWillShow:(NSNotification *)notification {
    
    // 获取通知的信息字典
    NSDictionary *userInfo = [notification userInfo];
    
    // 获取键盘弹出后的rect
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        self.view.frame = CGRectMake(0, -keyboardRect.size.height, self.view.width_sd, self.view.height_sd);
        
        
    }];
    
    
    
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    // 获取通知信息字典
    NSDictionary* userInfo = [notification userInfo];
    
    // 获取键盘隐藏动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
         self.view.frame = CGRectMake(0, 0, self.view.width_sd, self.view.height_sd);
     
        
    }];
    
    
}



- (void)textResignFirstResponder{
    [_orderView.promotionText resignFirstResponder];
    
}


- (void)returnLastPage{
    
    if (_promotionCode) {
        
//        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
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
