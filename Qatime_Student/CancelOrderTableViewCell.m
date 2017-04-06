//
//  CancelOrderTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "CancelOrderTableViewCell.h"

@implementation CancelOrderTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = BACKGROUNDGRAY;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _content = [[UIView alloc]init];
        [self.contentView addSubview:_content];
        _content.backgroundColor = BACKGROUNDGRAY;
        _content.sd_layout
        .leftSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10);
        
        /* 课程名*/
        _name =[[UILabel alloc]init];
        _name.textColor = [UIColor blackColor];
        _name.font = TITLEFONTSIZE;
        [self.contentView addSubview:_name];
        /* 课程名*/
        _name.sd_layout
        .leftSpaceToView(self.contentView,20*ScrenScale)
        .topSpaceToView(self.contentView,20)
        .rightSpaceToView(self.contentView,20)
        .autoHeightRatio(0);
        
        /**订单课程信息*/
        _orderInfos = [[UILabel alloc]init];
        _orderInfos.textColor = TITLECOLOR;
        _orderInfos.font = TEXT_FONTSIZE;
        [self.contentView addSubview:_orderInfos];
        /**订单课程信息*/
        _orderInfos.sd_layout
        .leftEqualToView(_name)
        .topSpaceToView(_name,10)
        .autoHeightRatio(0);
        [_orderInfos setSingleLineAutoResizeWithMaxWidth:1000];
        
        
        /* 支付状态*/
        _status=[[UILabel alloc]init];
        _status.textColor = [UIColor colorWithRed:0.14 green:0.80 blue:0.99 alpha:1.0];
        [self.contentView addSubview:_status];
        /* 状态*/
        _status.sd_layout
        .rightSpaceToView(self.contentView,20)
        .topEqualToView(_orderInfos)
        .bottomEqualToView(_orderInfos);
        [_status setSingleLineAutoResizeWithMaxWidth:1000];
        _status.textAlignment = NSTextAlignmentRight;
        
        UIView *line = [[UIView alloc]init];
        [self.contentView addSubview:line];
        line.backgroundColor = SEPERATELINECOLOR_2;
        line.sd_layout
        .leftEqualToView(_content)
        .rightEqualToView(_content)
        .topSpaceToView(_status, 10)
        .heightIs(1.0);
        
        
        /* 右侧button*/
        _rightButton = [[UIButton alloc]init];
        _rightButton.layer.borderColor = [UIColor redColor].CGColor;
        _rightButton.layer.borderWidth = 0.8;
        [_rightButton setTitle:@"重新下单" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _rightButton.titleLabel.font = TEXT_FONTSIZE;
        
        [self.contentView addSubview:_rightButton];
        /* 右按钮*/
        _rightButton.sd_layout
        .rightSpaceToView(self.contentView,20)
        .topSpaceToView(line,10);
        _rightButton.sd_cornerRadius = [NSNumber numberWithInteger:1];
        [_rightButton setupAutoSizeWithHorizontalPadding:15 buttonHeight:30];
        
        
        /* 金额*/
        _price=[[UILabel alloc]init];
        _price.textColor = [UIColor redColor];
        [self.contentView addSubview:_price];
        /* 金额*/
        _price.sd_layout
        .leftEqualToView(_name)
        .rightSpaceToView(_rightButton,10)
        .centerYEqualToView(_rightButton)
        .autoHeightRatio(0);
        
        [_rightButton updateLayout];
        [self setupAutoHeightWithBottomView:_rightButton bottomMargin:20];
        
    }
    
    return self;

}



-(void)setCanceldModel:(Canceld *)canceldModel{
    
    _canceldModel = canceldModel;
    self.name.text = canceldModel.name;
    
    NSString *infos;
    if (canceldModel.type ==nil) {
        infos = [NSString stringWithFormat:@"%@%@/共%@课/%@",canceldModel.subject,canceldModel.grade,canceldModel.preset_lesson_count,canceldModel.teacher_name];
    }else{
        
        infos =[NSString stringWithFormat:@"%@/%@%@/共%@课/%@",canceldModel.type,canceldModel.subject,canceldModel.grade,canceldModel.preset_lesson_count,canceldModel.teacher_name];
    }

    self.orderInfos.text = infos;
    
    if ([canceldModel.status isEqualToString:@"unpaid"]) {
        self.status.text = @"待付款";
    }else if ([canceldModel.status isEqualToString:@"shipped"]){
        self.status.text = @"交易完成";
    }else if ([canceldModel.status isEqualToString:@"canceled"]){
        self.status.text = @"已取消";
    }else if ([canceldModel.status isEqualToString:@"refunding"]){
        self.status.text = @"退款中";
    }else if ([canceldModel.status isEqualToString:@"completed"]){
        self.status.text = @"交易完成";
    }else if ([canceldModel.status isEqualToString:@"refunded"]){
        self.status.text = @"已退款";
    }

    
}

@end
