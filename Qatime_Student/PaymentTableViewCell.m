//
//  PaymentTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "PaymentTableViewCell.h"

@implementation PaymentTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        /* 充值单号*/
        _number = [[UILabel alloc]init];
        _number.font = [UIFont systemFontOfSize:16];
        
        
        UILabel *number = [[UILabel alloc]init];
        number .text  = @"消费类型";
        number.textColor = TITLECOLOR;
        number.font = [UIFont systemFontOfSize:16];
        
        /* 支付方式*/
        _mode = [[UILabel alloc]init];
        _mode.font = [UIFont systemFontOfSize:16];
        
        UILabel *mod = [[UILabel alloc]init];
        mod .text  = @"支付方式";
        mod.textColor = TITLECOLOR;
        mod.font = [UIFont systemFontOfSize:16];
        
        /* 时间 */
        
        _time = [[UILabel alloc]init];
        _time.font = [UIFont systemFontOfSize:16];
        
        UILabel *time = [[UILabel alloc]init];
        time.text  = @"时  间";
        time.textColor = TITLECOLOR;
        time.font = [UIFont systemFontOfSize:16];
        
        
        
        /* 金额*/
        _money = [[UILabel alloc]init];
        _money.font = [UIFont systemFontOfSize:16];
        _money.textColor = [UIColor redColor];
        
        /* 状态*/
        
        
        
        [self.contentView sd_addSubviews:@[number,_number,mod,_mode,time,_time,_money]];
        
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
                
        [self setupAutoHeightWithBottomView:_time bottomMargin:10];
        
        
        
        
    }
    return self;
    
}

-(void)setModel:(Payment *)model{
    
    _model = model;
    
    _number.text = model.target_type;
    
    
    if ([model.change_type isEqualToString:@"weixin"]) {
    
        _mode.text = @"微信支付";
    
    
    }
    
    
        /* 时间戳*/
    _time.text = model.created_at;
    
    /* 金额*/
    _money.text = [NSString stringWithFormat:@"%@",model.amount];
    
    
    
    
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
