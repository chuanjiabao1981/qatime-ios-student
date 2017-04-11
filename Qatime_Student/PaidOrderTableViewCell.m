//
//  PaidOrderTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "PaidOrderTableViewCell.h"

@implementation PaidOrderTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /* 课程名*/
        _name =[[UILabel alloc]init];
        _name.textColor = [UIColor blackColor];
        [self.contentView addSubview:_name];
        /* 课程名*/
        _name.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
        .autoHeightRatio(0);
        
        /**订单课程详情*/
        _orderInfos = [[UILabel alloc]init];
        _orderInfos.font = TEXT_FONTSIZE;
        _orderInfos.textColor = TITLECOLOR;
        [self.contentView addSubview:_orderInfos];
        /**订单课程详情*/
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
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .topSpaceToView(_status, 10)
        .heightIs(1.0);

        
        /* 金额*/
        _price=[[UILabel alloc]init];
        _price.textColor = [UIColor redColor];
        _price.font = TITLEFONTSIZE;
        [self.contentView addSubview:_price];
        /* 金额*/
        _price.sd_layout
        .leftEqualToView(_name)
        .topSpaceToView(line, 15)
        .autoHeightRatio(0);
        [_price setSingleLineAutoResizeWithMaxWidth:200];
        

        /* 右侧button*/
        _rightButton = [[UIButton alloc]init];
        _rightButton.layer.borderColor = [UIColor redColor].CGColor;
        _rightButton.layer.borderWidth = 0.8;
        [_rightButton setTitle:@"申请退款" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_rightButton];
        /* 右按钮*/
        _rightButton.sd_layout
        .rightSpaceToView(self.contentView,20)
        .topEqualToView(_price)
        .bottomEqualToView(_price);
        _rightButton.sd_cornerRadius = [NSNumber numberWithInteger:1];
        [_rightButton setupAutoSizeWithHorizontalPadding:15 buttonHeight:30];
        [_rightButton updateLayout];
        
        //视频课类型订单,不支持退款的提示字样 -->根据类型判断是否显示
        _unTips = [[UILabel alloc]init];
        [self.contentView addSubview:_unTips];
        _unTips.font = TEXT_FONTSIZE;
        _unTips.textColor = TITLECOLOR;
        _unTips.text = @"此类型订单不支持退款";
        _unTipsImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"感叹号gray"]];
        [self.contentView addSubview:_unTipsImage];
        
        _unTips.sd_layout
        .rightSpaceToView(self.contentView, 10)
        .topSpaceToView(line, 10)
        .autoHeightRatio(0);
        [_unTips setSingleLineAutoResizeWithMaxWidth:300];
        
        _unTipsImage.sd_layout
        .rightSpaceToView(_unTips, 0)
        .topEqualToView(_unTips)
        .bottomEqualToView(_unTips)
        .widthEqualToHeight();
    
         [self setupAutoHeightWithBottomView:_price bottomMargin:15];
        
        
    }
    
    return self;
}


-(void)setPaidModel:(Paid *)paidModel{
    
    _paidModel = paidModel;
    _name.text = paidModel.name;
    
    NSString *infos ;
    
    if (paidModel.type ==nil) {
        infos = [NSString stringWithFormat:@"%@%@/共%@课/%@",paidModel.subject,paidModel.grade,paidModel.preset_lesson_count,paidModel.teacher_name];
    }else{
        
        infos =[NSString stringWithFormat:@"%@/%@%@/共%@课/%@",paidModel.type,paidModel.subject,paidModel.grade,paidModel.preset_lesson_count,paidModel.teacher_name];
    }
    
    _orderInfos.text = infos;
    
    _price.text = [NSString stringWithFormat:@"¥%@",paidModel.price];
    
    if ([paidModel.status isEqualToString:@"unpaid"]) {
        _status.text = @"待付款";
    }else if ([paidModel.status isEqualToString:@"shipped"]){
       _status.text = @"交易完成";
    }else if ([paidModel.status isEqualToString:@"canceled"]){
        _status.text = @"已取消";
    }else if ([paidModel.status isEqualToString:@"refunding"]){
        _status.text = @"退款中";
    }else if ([paidModel.status isEqualToString:@"completed"]){
        _status.text = @"交易完成";
    }else if ([paidModel.status isEqualToString:@"refunded"]){
        self.status.text = @"已退款";
    }
    
    if ([paidModel.pay_type isEqualToString:@"LiveStudio::Course"]) {
        //直播课类型
        _unTips.hidden = YES;
        _unTipsImage.hidden = YES;
        _rightButton.hidden = NO;
        
    }else if ([paidModel.pay_type isEqualToString:@"LiveStudio::InteractiveLesson"]){
        //一对一课类型
        
        _unTips.hidden = NO;
        _unTipsImage.hidden = NO;
        _rightButton.hidden = YES;
        
    }else{
        //暂定 视频课类型
        _unTips.hidden = YES;
        _unTipsImage.hidden = YES;
        _rightButton.hidden = NO;
 
    }
    
    
}

@end
