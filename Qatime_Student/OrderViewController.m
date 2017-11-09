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
#import "VideoClassInfo.h"
#import "UIViewController+AFHTTP.h"
#import "DCPaymentView.h"
#import "ChargeViewController.h"
#import "IndexPageViewController.h"
#import "UIViewController+Token.h"

typedef enum : NSUInteger {
    AutoWrite,  //扫码自动填写的优惠码
    ManullyWrite,   //手动填写的优惠码
} PromotionCodeWriteType;

@interface OrderViewController (){
    
    NavigationBar *_navigationBar;
    /* 保存一个比较用的价格*/
    CGFloat price;
    
    /* 是否可以使用余额*/
    BOOL balanceEnable;
    
    /* 订单成功后,收到的数据,传入下一页*/
    NSMutableDictionary *dataDic;
    
    /* 优惠码*/
    NSString *_promotionCode;
    
    /* 是否隐藏"使用优惠码"按钮*/
    BOOL hidePromotionCodeButton;
    
    /**订单类型*/
    ClassOrderType _orderType;
    
    /**不可退款提示*/
    UIView *_warning;
    
    /**产品名称*/
    NSString *_productName;
    
    /**当前价格*/
    NSString *_amount;
    
}

@end

@implementation OrderViewController

-(instancetype)initWithClassID:(NSString *)classID andClassType:(ClassOrderType)type  andProductName:(NSString *)productName {
    
    self= [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        _orderType = type;
        _productName = [NSString stringWithFormat:@"%@",productName];
        
    }
    return self;
    
}

-(instancetype)initWithClassID:(NSString *)classID andPromotionCode:(NSString *)promotionCode andClassType:(ClassOrderType)type  andProductName:(NSString *)productName {
    
    self= [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
        _promotionCode = [NSString stringWithFormat:@"%@",promotionCode];
        _orderType = type;
        _productName = [NSString stringWithFormat:@"%@",productName];
        
        hidePromotionCodeButton = YES;
        
    }
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = ({
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
        _.titleLabel.text = @"订单确认";
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_];
        _;
    });
    
    _orderView = ({
        
        OrderView *_=[[OrderView alloc]initWithFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd-Navigation_Height)];
        
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
    
    
    /* 初始化*/
    dataDic = @{}.mutableCopy;
    
    /* 请求课程详细信息数据*/
    [self requestClassInfo];
    
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //判断是否需要有不可退款提示
    [self checkRefundWarning];
    
}

/**是否有不可退款提示*/
- (void)checkRefundWarning{
    
    if (_orderType == VideoClassType) {
        
        _warning = [[UIView alloc]init];
        [self.view addSubview:_warning];
        _warning.frame = CGRectMake(0, Navigation_Height, self.view.width_sd, 0);
        UIImageView *warningImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"发送失败"]];
        [_warning addSubview: warningImage];
        UILabel *warningLabel = [[UILabel alloc]init];
        [_warning addSubview:warningLabel];
        warningLabel.text = @"购买提醒:此订单类型暂不支持退款!";
        warningLabel.font = TEXT_FONTSIZE;
        warningLabel.textColor = TITLERED;
        
        warningImage.sd_layout
        .leftSpaceToView(_warning, 10)
        .centerYEqualToView(_warning)
        .heightIs(20)
        .widthEqualToHeight();
        [warningImage updateLayout];
        
        warningLabel.sd_layout
        .leftSpaceToView(warningImage, 5)
        .centerYEqualToView(warningImage)
        .autoHeightRatio(0);
        [warningLabel setSingleLineAutoResizeWithMaxWidth:400];
        [warningLabel updateLayout];
        
        warningImage.sd_resetLayout
        .leftSpaceToView(_warning, (_warning.width_sd-warningImage.width_sd-warningLabel.width_sd)*0.5)
        .centerYEqualToView(_warning)
        .heightIs(20)
        .widthEqualToHeight();
        [warningImage updateLayout];
        
        UIView *line = [[UIView alloc]init];
        [_warning addSubview:line];
        line.backgroundColor = SEPERATELINECOLOR;
        line.sd_layout
        .leftSpaceToView(_warning, 0)
        .rightSpaceToView(_warning, 0)
        .bottomSpaceToView(_warning, 0)
        .heightIs(0.5);
        
        _warning.frame = CGRectMake(0, Navigation_Height, self.view.width_sd, 40);
        _orderView.frame = CGRectMake(0, Navigation_Height+40, self.view.width_sd, self.view.height_sd-Navigation_Height - 40);
        
    }else{
        
    }
    
}

/* 请求课程详细信息*/
- (void)requestClassInfo{
    
    [self HUDStopWithTitle:nil];
    
    
    if (_classID!=nil) {
        
        NSString *course ;
        if (_orderType == LiveClassType) {
            course = [NSString stringWithFormat:@"courses"];
        }else if (_orderType == InteractionType){
            course = [NSString stringWithFormat:@"interactive_courses"];
        }else if (_orderType == VideoClassType){
            course = [NSString stringWithFormat:@"video_courses"];
        }else if (_orderType == ExclusiveType){
            course = [NSString stringWithFormat:@"customized_groups"];
        }
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:[self getToken] forHTTPHeaderField:@"Remember-Token"];
        [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/%@/%@/detail",Request_Header,course,_classID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            [self loginStates:dic];
            if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                
                id mod;
                
                if (_orderType == LiveClassType) {
                    /* 数据请求成功*/
                    mod = (TutoriumListInfo *)[TutoriumListInfo yy_modelWithJSON:dic[@"data"][@"course"]];
                    [(TutoriumListInfo *)mod setClassID:dic[@"data"][@"course"][@"id"]];
                    _orderView.classType.text = @"直播课";
                    //页面赋值
                    [_orderView setupLiveClassData:mod];
                    
                    //价格
                    price = [[(TutoriumListInfo *)mod current_price]floatValue];
                    
                }else if (_orderType == InteractionType){
                    
                    mod = (OneOnOneClass *)[OneOnOneClass yy_modelWithJSON:dic[@"data"][@"interactive_course"]];
                    [(OneOnOneClass *)mod setClassID:dic[@"data"][@"interactive_course"][@"id"]];
                    
                    _orderView.classType.text = @"一对一课";
                    //页面赋值
                    [_orderView setupInteractionData:mod];
                    
                    //价格
                    price = [[(OneOnOneClass *)mod price]floatValue];
                }else if (_orderType == VideoClassType){
                    
                    /* 数据请求成功*/
                    mod = (TutoriumListInfo *)[TutoriumListInfo yy_modelWithJSON:dic[@"data"][@"video_course"]];
                    [(VideoClassInfo *)mod setClassID:dic[@"data"][@"video_course"][@"id"]];
                    _orderView.classType.text = @"视频课";
                    //页面赋值
                    [_orderView setupLiveClassData:mod];
                    //价格
                    price = [[(TutoriumListInfo *)mod price]floatValue];
                    
                }else if (_orderType == ExclusiveType){
                    /* 数据请求成功*/
                    mod = (TutoriumListInfo *)[TutoriumListInfo yy_modelWithJSON:dic[@"data"][@"customized_group"]];
                    [(VideoClassInfo *)mod setClassID:dic[@"data"][@"customized_group"][@"id"]];
                    _orderView.classType.text = @"专属课";
                    //页面赋值
                    [_orderView setupExclusiveClassData:mod];
                    
                    //价格
                    price = [[(TutoriumListInfo *)mod current_price]floatValue];
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
            
            [self stopHUD];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }
    
    
    
}

#pragma mark- 请求余额
- (void)requestBalance{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[self getToken] forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/cash",Request_Header,[self getStudentID]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        [self loginStates:dic];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 余额请求成功*/
            _orderView.balance.text = [NSString stringWithFormat:@"当前余额¥%@元",dic[@"data"][@"balance"]];
            
            if (price>=0) {
                /* 判断余额是否可用*/
                if ([dic[@"data"][@"balance"] floatValue]>price) {
                    
                    balanceEnable = YES;
                    [_orderView.balanceButton addTarget:self action:@selector(chooseBalance:) forControlEvents:UIControlEventTouchUpInside];
                    
                }else{
                    
                    /* 按钮直接不可用*/
                    
                    balanceEnable = NO;
                    
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
        
        //新的优惠码验证逻辑 必须传优惠码 和 课程价格
        _promotionCode =_orderView.promotionText.text;
        [self POSTSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/coupons/%@/verify",Request_Header,_promotionCode] withHeaderInfo:nil andHeaderfield:nil parameters:@{@"amount":[NSString stringWithFormat:@"%f",price]} completeSuccess:^(id  _Nullable responds) {
            
            NSError *error = [NSError new];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:&error];
            if ([dic[@"status"] isEqualToNumber:@1]) {
                
                _orderView.promotionNum.text = [NSString stringWithFormat:@"已优惠 ¥%@",dic[@"data"][@"coupon_amount"]];
                //付款金额也要修改
                _orderView.totalMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[dic[@"data"][@"total_amount"]floatValue]-[dic[@"data"][@"coupon_amount"]floatValue]];
                
            }else{
                [self HUDStopWithTitle:@"输入的优惠码不正确"];
                
            }
            
        } failure:^(id  _Nullable erros) {
            
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
                [self HUDStopWithTitle:@"输入的优惠码不正确"];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }else{
        
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请输入优惠码" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
        }];
    }
    
}

/* 在可以使用余额的情况下 使用余额支付*/
- (void)chooseBalance:(UIButton *)sender{
    
    if (sender.selected ==NO) {
        sender.selected =YES;
        
        [sender setImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
        
    }else{
        sender.selected = NO;
        
        [sender setImage:[UIImage imageNamed:@"unselectedCircle"] forState:UIControlStateNormal];
        
    }
    
}

#pragma mark- 准备提交订单
- (void)applyOrder{
    
    [self finishAndCommit];
    
}

#pragma mark- 提交课程订单
- (void)finishAndCommit{
    
    if (balanceEnable == YES) {
        
        [self postOrderInfo];
        
    }else{
        
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"余额不足,是否前往充值?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"前往充值"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex!=0) {
                ChargeViewController *controller = [[ChargeViewController alloc]init];
                [self.navigationController pushViewController:controller animated:YES];
                
            }
            
        }];
        
    }
    
}

#pragma mark- 发送请求->用户提交订单
- (void)postOrderInfo{
    
    //增加优惠码dictionary.
    NSDictionary *dic ;
    NSString *coupon_code;
    if ([_orderView.promotionText.text isEqualToString:@""]) {
        
        dic = @{@"pay_type":@"account"};
    }else{
        coupon_code = _orderView.promotionText.text;
        dic = @{@"pay_type":@"account",@"coupon_code":coupon_code};
    }
    
    NSString *course;
    if (_orderType == LiveClassType) {
        course = [NSString stringWithFormat:@"courses"];
    }else if (_orderType == InteractionType){
        course = [NSString stringWithFormat:@"interactive_courses"];
    }else if (_orderType == VideoClassType){
        course = [NSString stringWithFormat:@"video_courses"];
    }else if (_orderType == ExclusiveType){
        course = [NSString stringWithFormat:@"customized_groups"];
    }
    
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[self getToken] forHTTPHeaderField:@"Remember-Token"];
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/live_studio/%@/%@/orders",Request_Header,course,_classID] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        [self loginStates:dic];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 下单成功*/
            [self HUDStopWithTitle:nil];
            
            dataDic = [NSMutableDictionary dictionaryWithDictionary:dic[@"data"]];
            [dataDic setValue:_productName forKey:@"productName"];
            PayConfirmViewController *controller = [[PayConfirmViewController alloc]initWithData:dataDic];
            [self.navigationController pushViewController:controller animated:YES];
            
        }else{
            
            if ([dic[@"error"][@"code"]isEqualToNumber:@3002]) {
                if ([dic[@"error"][@"msg"] rangeOfString:@"目前不对外招生"].location != NSNotFound ) {
                    [self HUDStopWithTitle:@"该课程目前不对外招生"];
                }else if ([dic[@"error"][@"msg"] rangeOfString:@"您已经购买过该课程"].location != NSNotFound ){
                    [self HUDStopWithTitle:@"您已经购买过该课程"];
                }else{
                    
                    [self HUDStopWithTitle:@"购买失败"];
                }
            }
            else{
                [self HUDStopWithTitle:@"购买失败"];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self HUDStopWithTitle:@"请检查网络"];
    }];
    
}



#pragma mark- 跳转到支付确认页面
- (void)turnToPayPage{
    
    
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
        
        self.view.frame = CGRectMake(0, -keyboardRect.size.height/2, self.view.width_sd, self.view.height_sd);
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
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            if ([controller isMemberOfClass:[IndexPageViewController class]]) {
                
                [self.navigationController popToViewController:controller animated:YES];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PopToRoot" object:nil];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
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
