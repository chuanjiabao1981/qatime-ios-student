//
//  MyWalletView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/6.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWalletView : UIView
/* 余额*/
@property(nonatomic,strong) UILabel *balance ;

/* 累计消费*/
@property(nonatomic,strong) UILabel *total ;

/* 充值按钮*/

@property(nonatomic,strong) UIButton *rechargeButton ;

/* 提现按钮*/

@property(nonatomic,strong) UIButton *widthDrawButon ;

/* 菜单*/
@property(nonatomic,strong) UITableView *menuTableView ;

/* 客服电话*/
//@property(nonatomic,strong) ;


@end
