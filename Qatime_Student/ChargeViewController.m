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
    
//    _priceArray = @[@"50",@"108",@"158",@"208",@"258",@"308"];
//    _actuallyPriceArray = @[@"34.30",@"74.10",@"108.40",@"142.70",@"177.01",@"211.31"];
    
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

}



/**下单充值*/
- (void)charge{
    
    if (_chargePrice) {
        
        [self loadingHUDStartLoadingWithTitle:nil];
        [self POSTSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/recharges",Request_Header,_idNumber] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:@{@"amount":_chargePrice,@"pay_type":@"itunes"} completeSuccess:^(id  _Nullable responds) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
            if ([dic[@"status"]isEqualToNumber:@1]) {
                
                [self loadingHUDStopLoadingWithTitle:nil];
                Recharge *mod = [Recharge yy_modelWithJSON:dic[@"data"]];
                mod.idNumber = dic[@"data"][@"id"];
                
                ConfirmRechargeViewController *controller = [[ConfirmRechargeViewController alloc]initWithRechage:mod andProduct:_product];
                [self.navigationController pushViewController:controller animated:YES];
                
            }else{
                
                [self loadingHUDStopLoadingWithTitle:@"充值失败!"];
                
            }
        }];
        
    }else{
        [self loadingHUDStopLoadingWithTitle:@"请选择充值金额"];
    }
    
}


/* 检查支付结果*/
- (void)CheckPayStatus{
    
//    ConfirmChargeViewController *conVC = [ConfirmChargeViewController new];
//    [self.navigationController pushViewController:conVC animated:YES];
    
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
