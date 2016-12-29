//
//  MyWalletView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/6.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MyWalletView.h"

@interface MyWalletView (){
   
    UILabel *balan;
    UILabel *tot;
    UIView *line;
}

@end

@implementation MyWalletView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 余额*/
        _balance = [[UILabel alloc]init];
        _balance.textColor = [UIColor blackColor];
        [_balance setFont:[UIFont systemFontOfSize:40*ScrenScale]];
        
        balan  = [[UILabel alloc]init];
        balan.textColor = TITLECOLOR;
        balan.font=[UIFont systemFontOfSize:16*ScrenScale];
        balan .text = @"余额";
        
        /* 累计消费*/
        _total = [[UILabel alloc]init];
        _total.textColor = TITLECOLOR;
        _total.font=[UIFont systemFontOfSize:16*ScrenScale];
        
        tot = [[UILabel alloc]init];
        tot.text = @"累计消费:";
        tot.textColor = TITLECOLOR;
        
        /* 分割线*/
        line = [[UIView alloc]init];
        line.backgroundColor = [UIColor lightGrayColor];
        
        
        /* 充值按钮*/
        _rechargeButton = [[UIButton alloc]init];
        [_rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
        [_rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rechargeButton setBackgroundColor:[UIColor orangeColor]];
        
        
        /* 提现按钮*/
        
        _widthDrawButon = [[UIButton alloc]init];
        [_widthDrawButon setTitle:@"提现" forState:UIControlStateNormal];
        [_widthDrawButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_widthDrawButon setBackgroundColor:[UIColor orangeColor]];
        
        
        /* 菜单*/
        
        _menuTableView = [[UITableView alloc]init];
        _menuTableView.bounces = NO;
        _menuTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width_sd, 0.4)];
        _menuTableView.tableFooterView.backgroundColor = [UIColor lightGrayColor];
        
        
        [self sd_addSubviews:@[_balance,balan,line,_total,tot,_rechargeButton,_widthDrawButon,_menuTableView]];
        
        _balance.sd_layout
        .topSpaceToView(self,self.height_sd/6.5)
        .centerXEqualToView(self)
        .autoHeightRatio(0);
        
        [_balance setSingleLineAutoResizeWithMaxWidth:500];
        
        balan.sd_layout
        .rightSpaceToView(_balance,0)
        .centerYEqualToView(_balance)
        .autoHeightRatio(0);
        [balan setSingleLineAutoResizeWithMaxWidth:200];
        
        
        _total.sd_layout
        .rightSpaceToView(self,5)
        .topSpaceToView(_balance,CGRectGetHeight(self.frame)/6.5)
        .autoHeightRatio(0);
        [_total setSingleLineAutoResizeWithMaxWidth:1000];
        
        tot.sd_layout
        .topEqualToView(_total)
        .bottomEqualToView(_total)
        .rightSpaceToView(_total,0);
        [tot setSingleLineAutoResizeWithMaxWidth:1000];
        
        line.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(tot,5)
        .heightIs(0.6);
        
        
        _rechargeButton.sd_layout
        .topSpaceToView(line,5)
        .leftSpaceToView(self,5)
        .heightIs(CGRectGetHeight(self.frame)/6.5/2)
        .widthIs(CGRectGetWidth(self.frame)/2-10);
        
        
        _widthDrawButon.sd_layout
        .topSpaceToView(line,5)
        .rightSpaceToView(self,5)
        .heightIs(CGRectGetHeight(self.frame)/6.5/2)
        .widthIs(CGRectGetWidth(self.frame)/2-10);
        
        _menuTableView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_widthDrawButon,10)
        .bottomEqualToView(self);

        
        
        
        
    }
    return self;
}









@end
