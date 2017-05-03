//
//  RechargeTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "RechargeTableViewCell.h"
#import "NSString+TimeStamp.h"

@interface RechargeTableViewCell (){
    
    
}

@end

@implementation RechargeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        /* 充值单号*/
        _number = [[UILabel alloc]init];
        _number.font = [UIFont systemFontOfSize:16*ScrenScale];
        
        
        UILabel *number = [[UILabel alloc]init];
        number .text  = @"编  号";
        number.textColor = TITLECOLOR;
         number.font = [UIFont systemFontOfSize:16*ScrenScale];
        
        /* 支付方式*/
        _mode = [[UILabel alloc]init];
        _mode.font = [UIFont systemFontOfSize:16*ScrenScale];
        
        UILabel *mod = [[UILabel alloc]init];
//        mod .text  = @"支付方式";
        mod.textColor = TITLECOLOR;
        mod.font = [UIFont systemFontOfSize:16*ScrenScale];
        
        /* 时间 */
        
        _time = [[UILabel alloc]init];
        _time.font = [UIFont systemFontOfSize:16*ScrenScale];
        
        UILabel *time = [[UILabel alloc]init];
        time.text  = @"时  间";
        time.textColor = TITLECOLOR;
        time.font = [UIFont systemFontOfSize:16*ScrenScale];

        
        
        /* 金额*/
        _money = [[UILabel alloc]init];
        _money.font = [UIFont systemFontOfSize:16*ScrenScale];
        _money.textColor = [UIColor redColor];
        
        /* 状态*/

        _status = [[UILabel alloc]init];
        _status.font = [UIFont systemFontOfSize:16*ScrenScale];
    
        
        
        [self.contentView sd_addSubviews:@[number,_number,mod,_mode,time,_time,_money,_status]];
        
        /* 布局*/
        
        /* 单号*/
        number.sd_layout
        .topSpaceToView(self.contentView,10)
        .leftSpaceToView(self.contentView,10)
        .autoHeightRatio(0);
        [number setSingleLineAutoResizeWithMaxWidth:200];
        
        _number.sd_layout
        .leftSpaceToView(number,10)
        .topEqualToView(number)
        .bottomEqualToView(number)
        .rightSpaceToView(self.contentView,10);
        
        
        
        /* 支付方式*/
        mod.sd_layout
        .topSpaceToView(number,10)
        .leftSpaceToView(self.contentView,10)
        .autoHeightRatio(0);
        [mod setSingleLineAutoResizeWithMaxWidth:200];
        
        _mode.sd_layout
        .leftSpaceToView(mod,10)
        .topEqualToView(mod)
        .bottomEqualToView(mod)
        .widthIs(500);
        _mode.textAlignment = NSTextAlignmentLeft;
//        [_mode setSingleLineAutoResizeWithMaxWidth:2000];

        /* 时间*/
        time.sd_layout
        .topSpaceToView(mod,10)
        .leftSpaceToView(self.contentView,10)
        .autoHeightRatio(0);
        [time setSingleLineAutoResizeWithMaxWidth:2000];
        
        _time.sd_layout
        .leftSpaceToView(time,10)
        .topEqualToView(time)
        .bottomEqualToView(time);
        [_time setSingleLineAutoResizeWithMaxWidth:2000];

        
        /* 金额*/
        _money.sd_layout
        .centerYEqualToView(mod)
        .rightSpaceToView(self.contentView,10)
        .autoHeightRatio(0)
        .widthIs(500);
        _money.textAlignment = NSTextAlignmentRight;
//        [_money setSingleLineAutoResizeWithMaxWidth:2000];
    
        
        /* 状态*/
        _status.sd_layout
        .topSpaceToView(_money,5)
        .rightEqualToView(_money)
        .autoHeightRatio(0)
        .widthIs(200);
        _status.textAlignment = NSTextAlignmentRight;
//        [_status setSingleLineAutoResizeWithMaxWidth:1000];
        
        
        [self setupAutoHeightWithBottomView:time bottomMargin:10];
        
    }
    return self;
    
}

-(void)setModel:(Recharge *)model{
    
    _model = model;
    
    _number.text = model.idNumber;
    
    
//    if ([model.pay_type isEqualToString:@"weixin"]) {
//        _mode.text = @"微信支付";
//    }else if([model.pay_type isEqualToString:@"alipay"]){
//        
//         _mode.text = @"支付宝支付";
//    }else if (![model.pay_type isEqualToString:@"alipay"]&&![model.pay_type isEqualToString:@"weixin"]){
//        _mode.text = @"余额支付";
//
//    }
    
        /* 时间戳*/
    _time.text = [model.created_at timeStampToDate];
    
    /* 金额*/
    _money.text = [NSString stringWithFormat:@"+ ¥%@",model.amount];
    
    if ([model.status isEqualToString:@"received"]) {
        _status.text = @"充值成功";
    }else if([model.status isEqualToString:@"unpaid"]){
        _status.text = @"未支付";
        
    }
    /* 预留充值状态接口*/
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
