//
//  DrawBackViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/9.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "DrawBackViewController.h"
#import "NavigationBar.h"
#import "UIViewController+HUD.h"
#import "UIViewController+AFHTTP.h"
#import "UIAlertController+Blocks.h"
#import "YYModel.h"
#import "MyOrderViewController.h"
#import "MMPickerView.h"

@interface DrawBackViewController ()<UITextViewDelegate,UITextInputDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    /* 订单信息*/
    Paid *_paidOrder;
    /* 取消订单数据的字典*/
    NSMutableDictionary *_dataDic;
    
    /* 订单号*/
    NSString *_orderNumber ;
    
    //退款理由
    NSString *_reason;
    
}

@end

@implementation DrawBackViewController

-(instancetype)initWithPaidOrder:(Paid *)paidOrder{
    self = [super init];
    if (self) {
        
        _paidOrder = paidOrder;
        
    }
    return self;
    
}

-(instancetype)initWithRefundOrder:(Refund *)refundOrder{
    
    self = [super init];
    if (self) {
        
        _paidOrder = [[Paid alloc]init] ;
        _paidOrder.orderID = refundOrder.idNumber;
        
    }
    return self;
    
}

-(instancetype)initWithOrderNumber:(NSString *)orderNumber{
    self = [super init];
    if (self) {
        
        _orderNumber = [NSString stringWithFormat:@"%@",orderNumber];
        
    }
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0,0, self.view.width_sd, 64)];
    [self.view addSubview:_navigationBar];
    _navigationBar.titleLabel.text = @"退款申请";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    _dataDic = @{}.mutableCopy;
    
    /* 请求数据*/
    [self requestDrawback];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}


/* 判断两个按钮应该是什么状态的方法*/

- (void)switchButtonStatus{
    
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length>=20) {
        [textView.text substringToIndex:20];
        [self HUDStopWithTitle:@"最多输入20个字"];
    }
}

/* 请求退款信息数据*/
- (void)requestDrawback{
    [self HUDStartWithTitle:@"正在加载数据"];
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/refunds/info",Request_Header,_idNumber] parameters:@{@"order_id":_paidOrder.orderID} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        [self loginStates:dic];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            /* 请求数据成功*/
            _dataDic = [dic[@"data"] mutableCopy];
            
            [self setupView];
            
            [self stopHUD];
            
        }else{
            /* 请求数据失败*/
            [self HUDStopWithTitle:@"服务器繁忙,请稍后重试"];
            
            [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

/* 加载视图*/
- (void)setupView{
    
    
    //主视图
    _drawBackView = [[DrawBackView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
    [self.view addSubview:_drawBackView];
    
    [_drawBackView.arrow addTarget:self action:@selector(chooseReason) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phone)];
    [_drawBackView.phoneTips addGestureRecognizer:phoneTap];
    
    
    if (_dataDic) {
        _drawBackView.number.text = _paidOrder.orderID;
        
        NSDictionary *product;
        //直播课
        if ([_paidOrder.product_type isEqualToString:@"LiveStudio::Course"]) {
            
            product = [NSDictionary dictionaryWithDictionary:_paidOrder.product];
            
        }else if ([_paidOrder.product_type isEqualToString:@"LiveStudio::VideoCourse"]){
            product = [NSDictionary dictionaryWithDictionary:_paidOrder.product_video_course];
        }else if ([_paidOrder.product_type isEqualToString:@"LiveStudio::InteractiveCourse"]){
            
            product = [NSDictionary dictionaryWithDictionary:_paidOrder.product_interactive_course];
        }else{
            product = [NSDictionary dictionaryWithDictionary:_paidOrder.product_customized_group];
        }
        _drawBackView.className.text = product[@"name"];
        if ([_paidOrder.product_type isEqualToString:@"LiveStudio::Goup"]) {
             _drawBackView.progress.text =  [NSString stringWithFormat:@"%ld",[product[@"events_count"]integerValue] -[product[@"closed_events_count"]integerValue]];
        }else{
            _drawBackView.progress.text =  [NSString stringWithFormat:@"%ld",[product[@"preset_lesson_count"]integerValue] -[product[@"completed_lesson_count"]integerValue]];
        }
        _drawBackView.price.text = [NSString stringWithFormat:@"¥%@",_dataDic[@"amount"]];
        _drawBackView.enableDrawbackPrice.text = [NSString stringWithFormat:@"¥%@",_dataDic[@"refund_amount"]];
        _drawBackView.paidPrice.text = [NSString stringWithFormat:@"%ld",[_dataDic[@"amount"] integerValue]-[_dataDic[@"refund_amount"] integerValue]];
        
        _drawBackView.drawBackWay.text = @"退至余额";
        
    }
    
    [_drawBackView.finishButton addTarget:self action:@selector(requestToRefund) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark- 选择退款理由
- (void)chooseReason{
    
    //弹出退款理由选择框 理由传到view和请求里
    
    
    if (!_reason) {
        _reason = @"买错了,不想买了";
        _drawBackView.reason.text = @"买错了,不想买了";
    }
    [MMPickerView showPickerViewInView:self.view withStrings:@[@"买错了,不想买了",@"对课程内容不满意",@"对授课老师不满意",@"没有时间学习",@"其他"] withOptions:nil completion:^(NSString *selectedString) {
        
        _reason = selectedString;
        _drawBackView.reason.text = selectedString;
        
    }];
    
}



#pragma mark- 发送申请退款请求
- (void)requestToRefund{
    
    if (_dataDic) {
        if ([_dataDic[@"refund_amount"]floatValue]!=0) {
            
            if (!_reason) {
                
                [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请选择退款原因" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            }else{
                
                [self HUDStartWithTitle:@"正在提交申请"];
                [self POSTSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/refunds",Request_Header,_idNumber] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:@{@"order_id":_paidOrder.orderID,@"reason":_reason} completeSuccess:^(id  _Nullable responds) {
                    
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                    [self loginStates:dic];
                    
                    if ([dic[@"status"]isEqualToNumber:@1]) {
                        [self HUDStopWithTitle:@"申请成功!"];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"RefundSuccess" object:dic[@"data"][@"transaction_no"]];
                        
                        [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
                        
                        
                    }else{
                        [self HUDStopWithTitle:@"服务器正忙,请稍后再试."];
                        [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
                    }
                    
                    NSLog(@"%@", dic);
                    
                }];
                
            }
            
            
        }else{
            
            [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"可退金额为0" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {}];
            
        }
    }
    
    
}

/**拨打客服电话*/
- (void)phone{
    
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-838-8010"];
    // NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

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
        
        self.view.frame = CGRectMake(0, -keyboardRect.size.height+60, self.view.width_sd, self.view.height_sd) ;
        
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



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_drawBackView.reason resignFirstResponder];
    
}

/* 返回上一页*/
- (void)returnLastPage{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isMemberOfClass:[MyOrderViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
    
    //    [self.navigationController popViewControllerAnimated:YES];
    
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
