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
#import "UIControl+RemoveTarget.h"
#import "NSNull+Json.h"
#import "UIAlertController+Blocks.h"
#import "DCPaymentView.h"
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
        
        NSDictionary *data = _dataDic.mutableCopy;
        for (NSString *key in data) {
            
            if ([[data[key]description]isEqualToString:@"0(NSNull)"]) {
                [_dataDic setValue:@"" forKey:key];
            }
        }
        
        
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
        
        [_orderInfoView.payButton removeAllTargets];
        [_orderInfoView.payButton addTarget:self action:@selector(requestForRefund) forControlEvents:UIControlEventTouchUpInside];
        
    }else if ([_dataDic[@"status"]isEqualToString:@"unpaid"]){
        /* 未付款的*/
        [_orderInfoView.statusImage setImage:[UIImage imageNamed:@"正在交易"]];
        [_orderInfoView.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_orderInfoView.payButton setTitle:@"付款" forState:UIControlStateNormal];
        [_orderInfoView.payButton removeAllTargets];
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
        [_orderInfoView.payButton removeAllTargets];
        [_orderInfoView.payButton addTarget:self action:@selector(requestForBuyAgain) forControlEvents:UIControlEventTouchUpInside];
        
        _orderInfoView.payTime.text = @"未支付";
    }else if ([_dataDic[@"status"]isEqualToString:@"completed"]){
        /* 完成交易的*/
        [_orderInfoView.statusImage setImage:[UIImage imageNamed:@"交易完成"]];
         _orderInfoView.cancelButton.hidden = YES;
        _orderInfoView.payButton.sd_resetLayout
        .leftSpaceToView(_orderInfoView,20)
        .rightSpaceToView(_orderInfoView,20)
        .topSpaceToView(_orderInfoView.amount,20)
        .heightRatioToView(_orderInfoView,0.065);
        [_orderInfoView.payButton updateLayout];
        [_orderInfoView.payButton setTitle:@"申请退款" forState:UIControlStateNormal];
        [_orderInfoView.payButton removeAllTargets];
        [_orderInfoView.payButton addTarget:self action:@selector(requestForRefund) forControlEvents:UIControlEventTouchUpInside];
        
        if ([_dataDic[@"product_type"]isEqualToString:@"LiveStudio::VideoCourse"]){
            _orderInfoView.tips.hidden = NO;
            _orderInfoView.payButton.hidden = YES;
            _orderInfoView.cancelButton .hidden = YES;
        }

        
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
        [_orderInfoView.payButton removeAllTargets];
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

        [_orderInfoView.payButton setTitle:@"重新购买" forState:UIControlStateNormal];
        [_orderInfoView.payButton removeAllTargets];
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
        
        
        infos =[NSString stringWithFormat:@"%@/%@%@/共%@课/%@",type,_product[@"subject"],_product[@"grade"],_product[@"preset_lesson_count"],_product[@"teacher_name"]];

    }else{
        
        infos =[NSString stringWithFormat:@"%@%@/共%@课/%@",_product[@"subject"],_product[@"grade"],_product[@"preset_lesson_count"],_product[@"teacherName"]];
    }
    
    _orderInfoView.subName.text = infos;
    _orderInfoView.name.text = _product[@"name"];
    _orderInfoView.creatTime.text = [_dataDic[@"created_at"] timeStampToDate];
    _orderInfoView.payTime.text = _dataDic[@"pay_at"]==nil?@"未支付":[_dataDic[@"pay_at"] timeStampToDate];
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


/**订单支付*/
- (void)requestForPay{
    
    NSDictionary *pay = @{
                          @"id":_dataDic[@"orderID"],
                          @"amount":_dataDic[@"amount"],
                          @"created_at":_dataDic[@"created_at"],
                          @"pay_type":@"account",
                          @"updated_at":_dataDic[@"updated_at"]
                          };
    PayConfirmViewController *controller =[[PayConfirmViewController alloc]initWithData:pay];
    [self.navigationController pushViewController:controller animated:YES];

}

/* 加工数据,并且转入支付页面*/
- (void)confirmRequestOrder{

    
}


/* 再次购买*/
- (void)requestForBuyAgain{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定重新够买该课程?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }] ;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self loadingHUDStopLoadingWithTitle:@"正在加载订单信息"];
        
        
        NSString *course;
        ClassOrderType classType;
        NSString *classID;
        NSString *couponCode;
        if ([_dataDic[@"product_type"]isEqualToString:@"LiveStudio::Course"]) {
            course = @"courses";
            classType = LiveClassType;
            classID = [NSString stringWithFormat:@"%@",_dataDic[@"product"][@"id"]];
        }else if ([_dataDic[@"product_type"]isEqualToString:@"LiveStudio::InteractiveCourse"]){
            course = @"interactive_courses";
            classType = InteractionType;
            classID = [NSString stringWithFormat:@"%@",_dataDic[@"product_interactive_course"][@"id"]];
        }else if ([_dataDic[@"product_type"]isEqualToString:@"LiveStudio::VideoCourse"]){
            course = @"video_courses";
            classType = VideoClassType;
            classID = [NSString stringWithFormat:@"%@",_dataDic[@"product_video_course"][@"id"]];
        }
        
        if (![_dataDic[@"coupon_code"]isEqualToString:@""]) {
            couponCode = [NSString stringWithFormat:@"%@",_dataDic[@"coupon_code"]];
        }
        
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
            [manager POST:[NSString stringWithFormat:@"%@/api/v1/live_studio/%@/%@/orders",Request_Header,course,classID] parameters:@{@"pay_type":@"account",@"coupon_code":couponCode==nil?@"":couponCode} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                [self loginStates:dic];
                if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                    /* 订单申请成功*/
                    OrderViewController *orderVC = [[OrderViewController alloc]initWithClassID:classID andClassType:classType];
                    [self.navigationController pushViewController:orderVC animated:YES];
                    
                }else{
                    
                    if ([dic[@"error"][@"code"]isEqualToNumber:@3002]) {
                        
                        if ([dic[@"error"][@"msg"] rangeOfString:@"已经"].location!= NSNotFound) {
                            
                            [self loadingHUDStopLoadingWithTitle:@"您已经购买过该课程"];
                        }else if ([dic[@"error"][@"msg"] rangeOfString:@"目前"].location!= NSNotFound){
                            [self loadingHUDStopLoadingWithTitle:@"课程目前不对外招生"];
                        }
                        
                    }else{
                        
                        [self loadingHUDStopLoadingWithTitle:@"该课程已过期"];
                    }
                    
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
    
    Paid *mod = [Paid yy_modelWithJSON:_dataDic];
    mod.orderID = _dataDic[@"orderID"];
    
    if ([mod.product_type isEqualToString:@"LiveStudio::VideoCourse"]) {
        [self loadingHUDStopLoadingWithTitle:@"视频课不可退款"];
    }else{
        
        DrawBackViewController *back = [[DrawBackViewController alloc]initWithPaidOrder:mod];
        [self.navigationController pushViewController:back animated:YES];
    }
    
}

/* 取消退款申请*/
- (void)requestForCancelRefund{
    
    [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"是否取消退款申请?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex!=0) {
            
            [self PUTSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/orders/%@/cancel",Request_Header,_dataDic[@"orderID"]] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
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
