//
//  ChargeViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChargeViewController.h"
#import "NavigationBar.h"
//#import "WXApi.h"

#import "UIViewController+HUD.h"
#import "NSString+TimeStamp.h"
#import "UIAlertController+Blocks.h"

#import "ChargeCollectionViewCell.h"
//#import "ConfirmChargeViewController.h"
#import "UIViewController+AFHTTP.h"
#import "YYModel.h"
#import "ConfirmRechargeViewController.h"
#import "ItunesProduct.h"
<<<<<<< HEAD
#import "CheckChargeViewController.h"

//在内购项目中创的商品单号
//#define Product_50 @"Charge_50"//50
//#define Product_108 @"Charge_108" //108
//#define Product_158 @"Charge_158" //158
//#define Product_208 @"Charge_208" //208
//#define Product_258 @"Charge_258" //258
//#define Product_308 @"Charge_308" //308
=======
>>>>>>> 内购充值

@interface ChargeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    /* 支付方式*/
    NSString *_payType;
    
    NSString *_token;
    NSString *_idNumber;
    
    /* 申请后获取到的数据*/
    NSMutableDictionary *_dataDic;
    
    
    /**可充值产品*/
    NSMutableArray <ItunesProduct *>*_productArray;
    
    /**价格表*/
//    NSArray *_priceArray;
//    NSArray *_actuallyPriceArray;
    
    NSString *_chargePrice;
    
    ItunesProduct *_product;
    
<<<<<<< HEAD
    int buyType;
    
=======
>>>>>>> 内购充值
}

@end

@implementation ChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**token*/
    [self getToken];
    
    /**加载导航栏*/
    [self setupNavigation];
    
    /**获取充值信息*/
    [self getRecharge];
    
    /**加载主视图*/
    [self setupMainView];
    
    /* 初始化*/
    _payType = @"".mutableCopy;
    _dataDic = @{}.mutableCopy;
    _productArray = @[].mutableCopy;
    
<<<<<<< HEAD

=======
//    _priceArray = @[@"50",@"108",@"158",@"208",@"258",@"308"];
//    _actuallyPriceArray = @[@"34.30",@"74.10",@"108.40",@"142.70",@"177.01",@"211.31"];
>>>>>>> 内购充值
    
}

/**token*/
- (void)getToken{
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
}

/**导航栏*/
- (void)setupNavigation{
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
    [self.view addSubview: _navigationBar];
    _navigationBar.titleLabel.text = @"充值选择";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
}

- (void)getRecharge{
    
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/itunes_products",Request_Header] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            for (NSDictionary *dics in dic[@"data"]) {
                
                ItunesProduct *mod = [ItunesProduct yy_modelWithJSON:dics];
                [_productArray addObject:mod];
            }
            
            [_chargeView.chargeMenu reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
        
        
    }];
    
}


/**加载主视图*/
- (void)setupMainView{
    
    _chargeView = [[ChargeView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
    [self.view addSubview:_chargeView];
    [_chargeView.chargeMenu registerClass:[ChargeCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    _chargeView.chargeMenu.delegate = self;
    _chargeView.chargeMenu.dataSource = self;
    
    [_chargeView.chargeButton addTarget:self action:@selector(charge) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark- UICollectionView datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _productArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"CollectionCell";
    ChargeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (_productArray.count>indexPath.row) {
        cell.model = _productArray[indexPath.row];
    }
    
    return cell;
}


#pragma mark- UICollectionView delegate
//item间距
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(20, 10, 20, 10);
}

//行距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 20;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    for (ChargeCollectionViewCell *cell in _chargeView.chargeMenu.visibleCells) {
        
        cell.contentView.layer.borderColor = TITLECOLOR.CGColor;
        cell.chosenImage.hidden = YES;
    }
    
    ChargeCollectionViewCell *cell = (ChargeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.contentView.layer.borderColor = NAVIGATIONRED.CGColor;
    cell.chosenImage.hidden = NO;
    
    _product = _productArray[indexPath.row];
    _chargePrice = [NSString stringWithFormat:@"%@",_product.price];
<<<<<<< HEAD
    
=======
>>>>>>> 内购充值

}



/**下单充值*/
- (void)charge{
    
    if (_chargePrice) {
        
<<<<<<< HEAD
        [self payForRecharge];
        
    }else{
        [self loadingHUDStopLoadingWithTitle:@"请选择充值金额"];
    }
    
}

#pragma mark- 重中之重 !  支付方法
/**拉起苹果支付*/
- (void)payForRecharge{
    
    [self loadingHUDStartLoadingWithTitle:nil];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
//    switch (_product.price.integerValue) {
//        case 50:
//            buyType = Charge_50;
//            break;
//        case 108:
//            buyType = Charge_108;
//            break;
//        case 158:
//            buyType = Charge_158;
//            break;
//        case 208:
//            buyType = Charge_208;
//            break;
//        case 258:
//            buyType = Charge_258;
//            break;
//        case 308:
//            buyType = Charge_308;
//            break;
//    }
    
    
    [self buy];
    
}


-(void)buy{
    
    
    if ([SKPaymentQueue canMakePayments]) {
        [self RequestProductData];
        NSLog(@"允许程序内付费购买");
    }else
    {
        NSLog(@"不允许程序内付费购买");
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您的手机没有打开程序内付费购买"
                                                           delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
        
        [alerView show];
        
    }
}
-(void)RequestProductData
{
    NSLog(@"---------请求对应的产品信息------------");
    NSArray *product = nil;
    product = [[NSArray alloc]initWithObjects:_product.product_id, nil];
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate=self;
    [request start];
    
}

////<SKProductsRequestDelegate> 请求协议
//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", (int)[myProduct count]);
    SKPayment *payment ;
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
        payment =[SKPayment paymentWithProduct:product];
        NSLog(@"---------发送购买请求------------");
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
}
- (void)requestProUpgradeProductData
{
    NSLog(@"------请求升级数据---------");
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
}
//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
    
}

-(void) requestDidFinish:(SKRequest *)request{
    
    [self loadingHUDStopLoadingWithTitle:nil];
    NSLog(@"----------反馈信息结束--------------");
    
}

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----PurchasedTransaction----");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
}

//<SKPaymentTransactionObserver> 千万不要忘记绑定，代码如下：
//----监听购买结果
//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    NSLog(@"-----paymentQueue--------");
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:{//交易完成
                [self completeTransaction:transaction];
                NSLog(@"-----交易完成 --------");
                
                //跳转到下一页去向服务器进行验证
                CheckChargeViewController *controller = [[CheckChargeViewController alloc]initWithTransaction:transaction andProduct:_product];
=======
        [self loadingHUDStartLoadingWithTitle:nil];
        [self POSTSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/recharges",Request_Header,_idNumber] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:@{@"amount":_chargePrice,@"pay_type":@"itunes"} completeSuccess:^(id  _Nullable responds) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
            if ([dic[@"status"]isEqualToNumber:@1]) {
                
                [self loadingHUDStopLoadingWithTitle:nil];
                Recharge *mod = [Recharge yy_modelWithJSON:dic[@"data"]];
                mod.idNumber = dic[@"data"][@"id"];
                
                ConfirmRechargeViewController *controller = [[ConfirmRechargeViewController alloc]initWithRechage:mod andProduct:_product];
>>>>>>> 内购充值
                [self.navigationController pushViewController:controller animated:YES];
                
            } break;
            case SKPaymentTransactionStateFailed://交易失败
            { [self failedTransaction:transaction];
                NSLog(@"-----交易失败 --------");
                UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"购买失败，请重新尝试购买"
                                                                    delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
                
                [alerView2 show];
                
            }break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                NSLog(@"-----已经购买过该商品 --------");
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"-----商品添加进列表 --------");
                break;
            default:
                break;
        }
    }
}


/**购买成功了*/
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"-----completeTransaction--------");
    
    // Your application should implement these two methods.
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            [self recordTransaction:bookid];
            [self provideContent:bookid];
        }
    }
    
    // Remove the transaction from the payment queue.
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"购买失败，请重试"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
        [alertView show];
    }else{
        
        [self loadingHUDStopLoadingWithTitle:@"用户取消交易"];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}
-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
    
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@" 交易恢复处理");
    
}

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
}

#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@",  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    switch([(NSHTTPURLResponse *)response statusCode]) {
        case 200:
        case 206:
            break;
        case 304:
            break;
        case 400:
            break;
        case 404:
            break;
        case 416:
            break;
        case 403:
            break;
        case 401:
        case 500:
            break;
        default:
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"test");
}


/**服务器验证支付情况*/
- (void)verifyPayment:(SKPaymentTransaction *)transaction{
    
    
    
}






/* 检查支付结果*/
- (void)CheckPayStatus{

    
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
