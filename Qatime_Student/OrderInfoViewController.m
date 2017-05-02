//
//  OrderInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "NavigationBar.h"
#import "NSString+TimeStamp.h"
#import "UIViewController+AFHTTP.h"
#import "UIAlertController+Blocks.h"
#import "UIViewController+HUD.h"

#import "ConfirmChargeViewController.h"
#import "OrderViewController.h"
#import "DrawBackViewController.h"
#import "NSDate+ChangeUTC.h"
#import "NSString+TimeStamp.h"
#import "WXApi.h"
#import "YYModel.h"
#import "PayConfirmViewController.h"

#import "Paid.h"
#import "Unpaid.h"
#import "Canceld.h"



@interface OrderInfoViewController (){
    
    NavigationBar *_navigationBar;
    
    /* 状态图*/
    UIImage *_statusImage;
    
    /* 三个model,判断订单类型*/
    Unpaid *_unPaid;
    Paid *_paid;
    Canceld *_canceld;
    
    /* 保存数据的dic*/
    NSMutableDictionary *_dataDic;
    
    /**保存订单产品内容的字典*/
    NSMutableDictionary *_product;
    
    NSString *_token;
    NSString *_idNumber;
    
    /* 余额*/
    CGFloat balance;
    
    
}

@end

@implementation OrderInfoViewController


/**传实例初始化方法*/
-(instancetype)initWithOrderInfos:(id)orderInfo{
    
    self = [super init];
    if (self) {
      
        _dataDic = [self entityToDictionary:orderInfo].mutableCopy;
        
        if ([_dataDic[@"product_type"]isEqualToString:@"LiveStudio::Course"]) {
            
            _product = [_dataDic[@"product"] mutableCopy];
        }else if ([_dataDic[@"product_type"]isEqualToString:@"LiveStudio::VideoCourse"]){
            _product = [_dataDic[@"product_video_course"] mutableCopy];
        }else if ([_dataDic[@"product_type"]isEqualToString:@"LiveStudio::InteractiveCourse"]){
            _product = [_dataDic[@"product_interactive_course"] mutableCopy];
        }
        
    }
    
    return self;
}

- (void)loadView{
    [super loadView];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
    [self.view addSubview:_navigationBar];
    
}

/* 加载订单信息图*/
- (void)setUpViews{
    _orderInfoView = [[OrderInfoView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
    [self.view addSubview:_orderInfoView];
    

    /* 判断订单状态...信息赋值*/
    if ([_dataDic[@"status"]isEqualToString:@"shipped"]) {
        /* 交易完成的*/
        [_orderInfoView.statusImage setImage:[UIImage imageNamed:@"交易完成"]];
        _orderInfoView.cancelButton.hidden = YES;
        _orderInfoView.payButton.sd_resetLayout
        .leftSpaceToView(_orderInfoView,20)
        .rightSpaceToView(_orderInfoView,20)
        .topSpaceToView(_orderInfoView.amount,20)
        .heightRatioToView(_orderInfoView,0.065);
        [_orderInfoView.payButton updateLayout];
        [_orderInfoView.payButton setTitle:@"申请退款" forState:UIControlStateNormal];
        
        [_orderInfoView.payButton addTarget:self action:@selector(requestForRefund) forControlEvents:UIControlEventTouchUpInside];
        
    }else if ([_dataDic[@"status"]isEqualToString:@"unpaid"]){
        /* 未付款的*/
        [_orderInfoView.statusImage setImage:[UIImage imageNamed:@"正在交易"]];
        [_orderInfoView.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_orderInfoView.payButton setTitle:@"付款" forState:UIControlStateNormal];
        
        [_orderInfoView.payButton addTarget:self action:@selector(requestForPay) forControlEvents:UIControlEventTouchUpInside];
        
    }else if ([_dataDic[@"status"]isEqualToString:@"canceled"]){
        /* 已取消的*/
        [_orderInfoView.statusImage setImage:[UIImage imageNamed:@"交易关闭"]];
         _orderInfoView.cancelButton.hidden = YES;
        _orderInfoView.payButton.sd_resetLayout
        .leftSpaceToView(_orderInfoView,20)
        .rightSpaceToView(_orderInfoView,20)
        .topSpaceToView(_orderInfoView.amount,20)
        .heightRatioToView(_orderInfoView,0.065);
        [_orderInfoView.payButton updateLayout];
        [_orderInfoView.payButton setTitle:@"重新下单" forState:UIControlStateNormal];
        
        [_orderInfoView.payButton addTarget:self action:@selector(requestForBuyAgain) forControlEvents:UIControlEventTouchUpInside];
    }else if ([_dataDic[@"status"]isEqualToString:@"completed"]){
        /* 完成交易的*/
        [_orderInfoView.statusImage setImage:[UIImage imageNamed:@"交易完成"]];
         _orderInfoView.cancelButton.hidden = YES;
        _orderInfoView.payButton.sd_layout
        .leftSpaceToView(_orderInfoView,20);
        [_orderInfoView.payButton updateLayout];
        [_orderInfoView.payButton setTitle:@"申请退款" forState:UIControlStateNormal];
        
        [_orderInfoView.payButton addTarget:self action:@selector(requestForRefund) forControlEvents:UIControlEventTouchUpInside];
        
    }else if ([_dataDic[@"status"]isEqualToString:@"refunding"]){
        /* 正在退款的*/
        [_orderInfoView.statusImage setImage:[UIImage imageNamed:@"退款中"]];
         _orderInfoView.cancelButton.hidden = YES;
        _orderInfoView.payButton.sd_resetLayout
        .leftSpaceToView(_orderInfoView,20)
        .rightSpaceToView(_orderInfoView,20)
        .topSpaceToView(_orderInfoView.amount,20)
        .heightRatioToView(_orderInfoView,0.065);
        [_orderInfoView.payButton updateLayout];

        [_orderInfoView.payButton setTitle:@"取消退款" forState:UIControlStateNormal];
        
        [_orderInfoView.payButton addTarget:self action:@selector(requestForCancelRefund) forControlEvents:UIControlEventTouchUpInside];
        
    }else if ([_dataDic[@"status"]isEqualToString:@"refunded"]){
        /* 退款完成的*/
        [_orderInfoView.statusImage setImage:[UIImage imageNamed:@"已退款"]];
         _orderInfoView.cancelButton.hidden = YES;
        _orderInfoView.payButton.sd_resetLayout
        .leftSpaceToView(_orderInfoView,20)
        .rightSpaceToView(_orderInfoView,20)
        .topSpaceToView(_orderInfoView.amount,20)
        .heightRatioToView(_orderInfoView,0.065);
        [_orderInfoView.payButton updateLayout];

        [_orderInfoView.payButton setTitle:@"重新下单" forState:UIControlStateNormal];
        
        [_orderInfoView.payButton addTarget:self action:@selector(requestForBuyAgain) forControlEvents:UIControlEventTouchUpInside];
        
    }

    _orderInfoView.orderNumber.text = _dataDic[@"orderID"];
    
    NSString *infos;
    NSString *type;
    //如果有课程类型属性
    if (_dataDic[@"product_type"]) {
        if ([_dataDic[@"product_type"] isEqualToString:@"LiveStudio::Course"]) {
            type = [NSString stringWithFormat:@"直播课"];

        }else if ([_dataDic[@"product_type"]isEqualToString:@"LiveStudio::InteractiveCourse"]){
            type = [NSString stringWithFormat:@"一对一"];
        }else if ([_dataDic[@"product_type"]isEqualToString:@"LiveStudio::VideoCourse"]){
            type = [NSString stringWithFormat:@"视频课"];
        }
        
        
        infos =[NSString stringWithFormat:@"%@/%@%@/共%@课/%@",type,_product[@"subject"],_product[@"grade"],_product[@"preset_lesson_count"],_product[@"teacherName"]];

    }else{
        
        infos =[NSString stringWithFormat:@"%@%@/共%@课/%@",_product[@"subject"],_product[@"grade"],_product[@"preset_lesson_count"],_product[@"teacherName"]];
    }
    
    _orderInfoView.subName.text = infos;
    _orderInfoView.name.text = _product[@"name"];
    _orderInfoView.creatTime.text = _dataDic[@"created_at"];
    _orderInfoView.payTime.text = _dataDic[@"pay_at"]==nil?@"":_dataDic[@"pay_at"];
    _orderInfoView.payType.text = @"余额支付";
    _orderInfoView.amount.text = [NSString stringWithFormat:@"¥%@",_dataDic[@"amount"]];
    
    [_orderInfoView.cancelButton addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
//    [_orderInfoView.payButton addTarget:self action:@selector(payOrder) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    _navigationBar.titleLabel.text = @"订单详情";
    
   
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }

    
    /* 加载数据和视图*/
    [self setUpViews];
    
    /* 加载余额信息*/
    [self requestBalance];
        
}


/* 加载余额信息*/
- (void) requestBalance{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/cash",Request_Header,_idNumber] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            balance = [dic[@"data"][@"balance"] floatValue];
            
        }else{
            
            
        }
        
    }];

}

/* 取消订单*/
- (void)cancelOrder{
    
    [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"确定取消该订单?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
       
        if (buttonIndex!=0) {
            [self loadingHUDStartLoadingWithTitle:@"正在取消"];
            [self PUTSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/orders/%@/cancel",Request_Header,_dataDic[@"orderNumber"]] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:nil
                completeSuccess:^(id  _Nullable responds) {
                   
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                    [self loginStates:dic];
                    if ([dic[@"status"]isEqualToNumber:@1]) {
                        /* 取消成功*/
                        [self loadingHUDStopLoadingWithTitle:@"取消成功"];
                        [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"DeleteOrder" object:nil];
                        
                    }else{
                        /* 取消失败*/
                        [self loadingHUDStopLoadingWithTitle:@"服务正忙,请稍后重试"];
                        [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
                    }
                    
                    
                }];
            
        }
    }];
    
}


/* 请求付款*/
- (void)requestForPay{
    
    [self loadingHUDStopLoadingWithTitle:@"请使用网页端支付"];
    
//    if ([_dataDic[@"payType"]isEqualToString:@"weixin"]) {
//        /* 使用微信支付*/
//        if ([WXApi isWXAppInstalled]==YES) {
//            
//            [self confirmRequestOrder];
//        }else{
//            [self loadingHUDStopLoadingWithTitle:@"尚未安装微信"];
//        }
//        
//    }else if ([_dataDic[@"payType"]isEqualToString:@"account"]){
//        
//        /* 使用余额支付*/
//        if (balance>=[_dataDic[@"amount"]floatValue]) {
//            
//            [self confirmRequestOrder];
//        }else{
//            [self loadingHUDStopLoadingWithTitle:@"余额不足,请充值!"];
//        }
//        
//        
//    }else if ([_dataDic[@"payType"]isEqualToString:@"alipay"]){
//        /* 暂不支持支付宝*/
//        [self loadingHUDStopLoadingWithTitle:@"暂不支持支付宝"];
//        
//    }
    

   


}

/* 加工数据,并且转入支付页面*/
- (void)confirmRequestOrder{
    
//    if (_unPaid) {
//      
//        
//    }else{
//        _unPaid = [Unpaid yy_modelWithDictionary:_dataDic];
//        _unPaid.preset_lesson_count = @"";
//        _unPaid.teacher_name = _dataDic[@"teacherName"];
//        _unPaid.price = _dataDic[@"amount"];
//        _unPaid.nonce_str = @"";
//        _unPaid.appid = @"";
//        _unPaid.pay_type = _dataDic[@"payType"];
//        _unPaid.timestamp = @"";
//        _unPaid.orderID = _dataDic[@"orderNumber"];
//        _unPaid.created_at = _dataDic[@"creatTime"];
//        _unPaid.updated_at = _dataDic[@"creatTime"];
//        _unPaid.pay_at = @"";
//        _unPaid.prepay_id = @"";
//        _unPaid.app_pay_params = @{};
//    }
//    
//    
//    
//    
//    PayConfirmViewController *confirm = [[PayConfirmViewController alloc]initWithData:@{
//                                                                                        @"id":_unPaid.orderID==nil?@"":_unPaid.orderID,
//                                                                                        @"pay_at":_unPaid.pay_at==nil?@"":_unPaid.pay_at,
//                                                                                        @"amount":_unPaid.price==nil?@"":_unPaid.price,
//                                                                                        @"created_at":_unPaid.created_at==nil?@"":_unPaid.created_at,
//                                                                                        @"source":@"app",
//                                                                                        @"pay_type":_unPaid.pay_type==nil?@"":_unPaid.pay_type,
//                                                                                        
//                                                                                        @"nonce_str":_unPaid.nonce_str==nil?@"":_unPaid.nonce_str,
//                                                                                        @"app_pay_str":@"",
//                                                                                        @"updated_at":_unPaid.updated_at==nil?@"":_unPaid.updated_at,
//                                                                                        @"prepay_id":_unPaid.prepay_id==nil?@"":_unPaid.prepay_id,
//                                                                                        @"app_pay_params":_unPaid.app_pay_params==nil?@"":_unPaid.app_pay_params,
//                                                                                        @"status":_unPaid.status==nil?@"":_unPaid.status}];
//    
//    [self.navigationController pushViewController:confirm animated:YES];
//
    
}


/* 再次购买*/
- (void)requestForBuyAgain{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定重新够买该课程?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }] ;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self loadingHUDStopLoadingWithTitle:@"正在加载订单信息"];
    
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
            [manager POST:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses/%@/orders",Request_Header,_dataDic[@"productID"]] parameters:@{@"pay_type":_dataDic[@"payType"]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                [self loginStates:dic];
                if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                    /* 订单申请成功*/
                    OrderViewController *orderVC = [[OrderViewController alloc]initWithClassID:_dataDic[@"productID"] andClassType:LiveClassType];
                    [self.navigationController pushViewController:orderVC animated:YES];
                    
                }else{
                    
                    [self loadingHUDStopLoadingWithTitle:@"订单创建失败,请重试!"];
                    
                    [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
        
    }] ;
    
    [alert addAction:cancel];
    [alert addAction:sure];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

/* 申请退款*/
- (void)requestForRefund{
    
    DrawBackViewController *back = [[DrawBackViewController alloc]initWithPaidOrder:_paid];
    [self.navigationController pushViewController:back animated:YES];
    

    
}

/* 取消退款申请*/
- (void)requestForCancelRefund{
    
    [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"是否取消退款申请?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex!=0) {
            
            [self PUTSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/refunds/%@/cancel",Request_Header,_idNumber,_paid.orderID] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                [self loginStates:dic];
                if ([dic[@"status"]isEqualToNumber:@1]) {
                    [self loadingHUDStopLoadingWithTitle:@"取消成功!"];
                    [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
                    
                }else{
                    [self loadingHUDStopLoadingWithTitle:@"取消失败!"];
                    [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
                    

                }
                
            }];
        }
    }];
    
    
}
//反解model->字典
- (NSDictionary *) entityToDictionary:(id)entity
{
    
    Class clazz = [entity class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        objc_property_t prop=properties[i];
        const char* propertyName = property_getName(prop);
        
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        
        //        const char* attributeName = property_getAttributes(prop);
        //        NSLog(@"%@",[NSString stringWithUTF8String:propertyName]);
        //        NSLog(@"%@",[NSString stringWithUTF8String:attributeName]);
        
        id value =  [entity performSelector:NSSelectorFromString([NSString stringWithUTF8String:propertyName])];
        if(value ==nil)
            [valueArray addObject:[NSNull null]];
        else {
            [valueArray addObject:value];
        }
        //        NSLog(@"%@",value);
    }
    
    free(properties);
    
    NSDictionary* returnDic = [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
    NSLog(@"%@", returnDic);
    
    return returnDic;
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
