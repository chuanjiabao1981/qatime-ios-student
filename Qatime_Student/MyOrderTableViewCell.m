//
//  MyOrderTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell


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
        .heightIs(self.height_sd-20);
        
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
        [_rightButton setTitle:@"付款" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _rightButton.titleLabel.font = TEXT_FONTSIZE;
        
        [self.contentView addSubview:_rightButton];
        /* 右按钮*/
        _rightButton.sd_layout
        .rightSpaceToView(self.contentView,20)
        .topSpaceToView(line,10);
        _rightButton.sd_cornerRadius = [NSNumber numberWithInteger:1];
        [_rightButton setupAutoSizeWithHorizontalPadding:15 buttonHeight:30];
        
        /* 左侧button*/
        _leftButton = [[UIButton alloc]init];
        _leftButton.layer.borderColor = [UIColor blackColor].CGColor;
        _leftButton.layer.borderWidth = 0.8;
        [_leftButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _leftButton.titleLabel.font = TEXT_FONTSIZE;
        [self.contentView addSubview:_leftButton];
        /* 左按钮*/
        _leftButton.sd_layout
        .rightSpaceToView(_rightButton,10)
        .topEqualToView(_rightButton)
        .bottomEqualToView(_rightButton);
        _leftButton.sd_cornerRadius = [NSNumber numberWithInteger:1];
         [_leftButton setupAutoSizeWithHorizontalPadding:15 buttonHeight:30];
        
        /* 金额*/
        _price=[[UILabel alloc]init];
        _price.textColor = [UIColor redColor];
        [self.contentView addSubview:_price];
        /* 金额*/
        _price.sd_layout
        .leftEqualToView(_name)
        .rightSpaceToView(_leftButton,10)
        .centerYEqualToView(_leftButton)
        .autoHeightRatio(0);
        
        [_rightButton updateLayout];
        
//        UIView *cont = [[UIView alloc]init];
//        cont.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:cont];
//        cont.sd_resetNewLayout
//        .leftSpaceToView(self.contentView,10)
//        .rightSpaceToView(self.contentView, 10)
//        .topSpaceToView(self.contentView, 10)
//        .heightIs(_rightButton.bottom_sd+10);
//        [cont updateLayout];
//        [self.contentView sendSubviewToBack:cont];
        
        [self setupAutoHeightWithBottomView:_rightButton bottomMargin:20];
        
        
    }
    
    return self;
}

-(void)setUnpaidModel:(Unpaid *)unpaidModel{
    
    _unpaidModel = unpaidModel;
    _name.text = unpaidModel.name;
    
    NSString *infos ;
    
    if (unpaidModel.type ==nil) {
        infos = [NSString stringWithFormat:@"%@%@/共%@课/%@",unpaidModel.subject,unpaidModel.grade,unpaidModel.preset_lesson_count,unpaidModel.teacher_name];
    }else{
        
        infos =[NSString stringWithFormat:@"%@/%@%@/共%@课/%@",unpaidModel.type,unpaidModel.subject,unpaidModel.grade,unpaidModel.preset_lesson_count,unpaidModel.teacher_name];
    }
    
    _orderInfos.text = infos;
    
    _price.text = [NSString stringWithFormat:@"¥%@",unpaidModel.price];

    if ([unpaidModel.status isEqualToString:@"unpaid"]) {
        _status.text = @"待付款";
    }else if ([unpaidModel.status isEqualToString:@"shipped"]){
        _status.text = @"交易完成";
    }else if ([unpaidModel.status isEqualToString:@"canceled"]){
        _status.text = @"已取消";
    }else if ([unpaidModel.status isEqualToString:@"refunding"]){
        _status.text = @"退款中";
    }else if ([unpaidModel.status isEqualToString:@"completed"]){
        _status.text = @"交易完成";
    }else if ([unpaidModel.status isEqualToString:@"refunded"]){
        self.status.text = @"已退款";
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
