//
//  RefundTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/17.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "RefundTableViewCell.h"

@implementation RefundTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        /* 充值单号*/
        _number = [[UILabel alloc]init];
        _number.font = [UIFont systemFontOfSize:16*ScrenScale];
        
        
        UILabel *number = [[UILabel alloc]init];
        number .text  = @"订单编号";
        number.textColor = TITLECOLOR;
        number.font = [UIFont systemFontOfSize:16*ScrenScale];
        
        /* 支付方式*/
        _mode = [[UILabel alloc]init];
        _mode.font = [UIFont systemFontOfSize:16*ScrenScale];
        
        UILabel *mod = [[UILabel alloc]init];
        mod .text  = @"退款方式";
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
        .bottomEqualToView(mod);
        [_mode setSingleLineAutoResizeWithMaxWidth:2000];
        
        /* 时间*/
        time.sd_layout
        .topSpaceToView(mod,10)
        .leftSpaceToView(self.contentView,10)
        .autoHeightRatio(0);
        [time setSingleLineAutoResizeWithMaxWidth:200];
        
        _time.sd_layout
        .leftSpaceToView(time,10)
        .topEqualToView(time)
        .bottomEqualToView(time);
        [_time setSingleLineAutoResizeWithMaxWidth:2000];
        
        
        /* 金额*/
        _money.sd_layout
        .centerYEqualToView(mod)
        .rightSpaceToView(self.contentView,10)
        .autoHeightRatio(0);
        [_money setSingleLineAutoResizeWithMaxWidth:2000];
        
        /* 状态*/
        _status.sd_layout
        .topSpaceToView(_money,5)
        .rightEqualToView(_money)
        .autoHeightRatio(0)
        .widthIs(200);
        _status.textAlignment = NSTextAlignmentRight;

        
        [self setupAutoHeightWithBottomView:time bottomMargin:10];
        
        
        
        
    }
    return self;
    
}

-(void)setModel:(Refund *)model{
    
    _model = model;
    
    _number.text = model.transaction_no;
    if ([model.pay_type isEqualToString:@"weixin"]) {
        _mode.text = @"退至微信";
    }else if([model.pay_type isEqualToString:@"alipay"]){
        
        _mode.text = @"退至支付宝";
    }else if (![model.pay_type isEqualToString:@"alipay"]&&![model.pay_type isEqualToString:@"weixin"]){
        _mode.text = @"退至余额";
        
    }

    
    
    //时间戳
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSzz"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:model.created_at];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString =[dateFormatter stringFromDate:dateFormatted];
    
      /* 时间戳*/
    _time.text = dateString;

    
    
    /* 金额*/
    _money.text = [NSString stringWithFormat:@"¥%@",model.refund_amount];
    
    
    /* 状态*/
    if ([model.status isEqualToString:@"refunded"]) {
        
        _status.text =@"退款成功";
        
    }else if ([model.status isEqualToString:@"cancel"]){
        
        _status.text =@"退款中";

    }
    
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