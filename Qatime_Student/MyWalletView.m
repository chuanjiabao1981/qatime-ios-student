//
//  MyWalletView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/6.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MyWalletView.h"

@interface MyWalletView (){

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
        _balance.textColor = NAVIGATIONRED;
        [_balance setFont:[UIFont systemFontOfSize:40*ScrenScale]];
        [self addSubview:_balance];
        
        _balance.sd_layout
        .topSpaceToView(self, 20)
        .leftSpaceToView(self, 20)
        .autoHeightRatio(0);
        [_balance setSingleLineAutoResizeWithMaxWidth:300];
        
        /* 累计消费*/
        _total = [[UILabel alloc]init];
        _total.textColor = TITLECOLOR;
        _total.font=[UIFont systemFontOfSize:16*ScrenScale];
        [self addSubview:_total];
        
        _total.sd_layout
        .leftEqualToView(_balance)
        .topSpaceToView(_balance,20)
        .autoHeightRatio(0);
        [_total setSingleLineAutoResizeWithMaxWidth:1000];
        
        
        //提现按钮
        _widthDrawButon = [[UIButton alloc]init];
        [_widthDrawButon setTitle:@"提现" forState:UIControlStateNormal];
        [_widthDrawButon setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
        [_widthDrawButon setBackgroundColor:[UIColor whiteColor]];
        _widthDrawButon.layer.borderColor = NAVIGATIONRED.CGColor;
        _widthDrawButon.layer.borderWidth = 1;
        [self addSubview:_widthDrawButon];
        
        //隐藏了,砍掉提现功能
        
        _widthDrawButon.sd_layout
        .topSpaceToView(_total,20)
        .rightSpaceToView(self, 10);
        [_widthDrawButon setupAutoSizeWithHorizontalPadding:30*ScrenScale buttonHeight:40*ScrenScale];
        _widthDrawButon.sd_cornerRadius = @1;
        _widthDrawButon.hidden = YES;

        /* 充值按钮*/
        _rechargeButton = [[UIButton alloc]init];
        [_rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
        [_rechargeButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
        [_rechargeButton setBackgroundColor:[UIColor whiteColor]];
        _rechargeButton.layer.borderColor = NAVIGATIONRED.CGColor;
        _rechargeButton.layer.borderWidth = 1;
        [self addSubview:_rechargeButton];
      
        _rechargeButton.sd_layout
        .topSpaceToView(_total,20)
        .rightSpaceToView(self, 10);
        [_rechargeButton setupAutoSizeWithHorizontalPadding:30*ScrenScale buttonHeight:40*ScrenScale];
        _rechargeButton.sd_cornerRadius = @1;

        /* 分割线*/
        line = [[UIView alloc]init];
        line.backgroundColor = [UIColor whiteColor];
        [self addSubview:line];
        
        line.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_rechargeButton,10)
        .heightIs(0.5);
        
        /* 菜单*/
        _menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, line.bottom_sd, self.width_sd, 240) style:UITableViewStyleGrouped];
        _menuTableView.backgroundColor = [UIColor whiteColor];
        [_menuTableView setOpaque:NO];
        _menuTableView.bounces = NO;
        [self addSubview:_menuTableView];
        _menuTableView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(line, 0)
        .heightIs(240*ScrenScale);

        /* 电话提示*/
        _tips = [[UILabel alloc]init];
        _tips.textColor = TITLECOLOR;
        _tips.font = [UIFont systemFontOfSize:16*ScrenScale];
        _tips.text = @"遇到问题请拨打客服电话0532-34003426";
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:_tips.text];
        [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:NSMakeRange(11, 13)];
        _tips.attributedText = attStr;
        [self addSubview:_tips];
        _tips.sd_layout
        .bottomSpaceToView(self,20)
        .centerXEqualToView(self)
        .autoHeightRatio(0);
        [_tips setSingleLineAutoResizeWithMaxWidth:1000];
        
    }
    return self;
}









@end
