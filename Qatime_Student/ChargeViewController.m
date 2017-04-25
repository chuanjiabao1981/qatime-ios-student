//
//  ChargeViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChargeViewController.h"
#import "NavigationBar.h"
#import "WXApi.h"
 
#import "UIViewController+HUD.h"
#import "NSString+TimeStamp.h"
#import "ConfirmChargeViewController.h"
#import "UIAlertController+Blocks.h"

#import "ChargeCollectionViewCell.h"
#import "ConfirmChargeViewController.h"
#import "UIViewController+AFHTTP.h"

@interface ChargeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    
    NavigationBar *_navigationBar;
    
    /* 支付方式*/
    NSString *_payType;
    
    NSString *_token;
    NSString *_idNumber;
    
    /* 申请后获取到的数据*/
    NSMutableDictionary *_dataDic;
    
    /**价格表*/
    NSArray *_priceArray;
    
    NSString *_chargePrice;
    
    
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
    
    /**加载主视图*/
    [self setupMainView];
    
    /* 初始化*/
    _payType = @"".mutableCopy;
    _dataDic = @{}.mutableCopy;
    
    _priceArray = @[@"50",@"108",@"158",@"208",@"258",@"308"];
    
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

/**加载主视图*/
- (void)setupMainView{
    
    _chargeView = [[ChargeView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
    [self.view addSubview:_chargeView];
    _chargeView.chargeMenu.delegate = self;
    _chargeView.chargeMenu.dataSource = self;
    
    [_chargeView.chargeMenu registerClass:[ChargeCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];

    [_chargeView.chargeButton addTarget:self action:@selector(charge) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark- UICollectionView datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _priceArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"CollectionCell";
    ChargeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (_priceArray.count>indexPath.row) {
        cell.title.text = [NSString stringWithFormat:@"%@元",_priceArray[indexPath.row]];
    }
    
    return cell;
}


#pragma mark- UICollectionView delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    for (ChargeCollectionViewCell *cell in _chargeView.chargeMenu.visibleCells) {
        cell.title.layer.borderColor = TITLECOLOR.CGColor;
        cell.title.textColor = TITLECOLOR;
        cell.title.backgroundColor = [UIColor whiteColor];
    }
    
    ChargeCollectionViewCell *cell = (ChargeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.title.layer.borderColor = NAVIGATIONRED.CGColor;
    cell.title.textColor = [UIColor whiteColor];
    cell.title.backgroundColor = NAVIGATIONRED;
    
    _chargePrice = [NSString stringWithFormat:@"%@",_priceArray[indexPath.row]];

}

//item间距
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(20, 10, 20, 10);
}

//行距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 20;
}


/**下单充值*/
- (void)charge{
    
    [self POSTSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/recharges",Request_Header,_idNumber] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:@{@"amount":_chargePrice} completeSuccess:^(id  _Nullable responds) {
        
    }];
    
    
}


/* 检查支付结果*/
- (void)CheckPayStatus{
    
    ConfirmChargeViewController *conVC = [ConfirmChargeViewController new];
    [self.navigationController pushViewController:conVC animated:YES];
    
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
