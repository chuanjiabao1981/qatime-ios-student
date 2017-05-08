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
        
         self.backgroundColor = BACKGROUNDGRAY;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _content = [[UIView alloc]init];
        [self.contentView addSubview:_content];
        _content.backgroundColor = [UIColor whiteColor];
        _content.sd_layout
        .leftSpaceToView(self.contentView,10*ScrenScale)
        .rightSpaceToView(self.contentView,10*ScrenScale)
        .topSpaceToView(self.contentView,10*ScrenScale)
        .bottomSpaceToView(self.contentView,10*ScrenScale);
        
        /* 课程名*/
        _name =[[UILabel alloc]init];
        _name.textColor = [UIColor blackColor];
        [self.contentView addSubview:_name];
        /* 课程名*/
        _name.sd_layout
        .leftSpaceToView(self.contentView,20*ScrenScale)
        .topSpaceToView(self.contentView,20*ScrenScale)
        .rightSpaceToView(self.contentView,20*ScrenScale)
        .autoHeightRatio(0);
        
        /**订单课程详情*/
        _orderInfos = [[UILabel alloc]init];
        _orderInfos.font = TEXT_FONTSIZE;
        _orderInfos.textColor = TITLECOLOR;
        [self.contentView addSubview:_orderInfos];
        /**订单课程详情*/
        _orderInfos.sd_layout
        .leftEqualToView(_name)
        .topSpaceToView(_name,10*ScrenScale)
        .autoHeightRatio(0);
        [_orderInfos setSingleLineAutoResizeWithMaxWidth:1000];
        
    
        /* 支付状态*/
        _status=[[UILabel alloc]init];
        _status.font = TEXT_FONTSIZE_MIN;
        _status.textColor = [UIColor colorWithRed:0.14 green:0.80 blue:0.99 alpha:1.0];
        [self.contentView addSubview:_status];
        /* 状态*/
        _status.sd_layout
        .rightSpaceToView(self.contentView,20*ScrenScale)
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
        .topSpaceToView(_status, 10*ScrenScale)
        .heightIs(1.0);

        
        /* 金额*/
        _price=[[UILabel alloc]init];
        _price.textColor = [UIColor redColor];
        _price.font = TEXT_FONTSIZE;
        [self.contentView addSubview:_price];
        /* 金额*/
        _price.sd_layout
        .leftEqualToView(_name)
        .topSpaceToView(line, 10*ScrenScale)
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
        .rightSpaceToView(self.contentView,20*ScrenScale)
        .topSpaceToView(line, 10*ScrenScale)
        .bottomEqualToView(_price);
        _rightButton.sd_cornerRadius = [NSNumber numberWithInteger:1];
        [_rightButton setupAutoSizeWithHorizontalPadding:15 buttonHeight:30*ScrenScale];
//        [_rightButton updateLayout];
        
        //视频课类型订单,不支持退款的提示字样 -->根据类型判断是否显示
        _unTips = [[UILabel alloc]init];
        [self.contentView addSubview:_unTips];
        _unTips.font = TEXT_FONTSIZE_MIN;
        _unTips.textColor = TITLECOLOR;
        _unTips.text = @"此类型订单不支持退款";
        _unTipsImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"感叹号gray"]];
        [self.contentView addSubview:_unTipsImage];
        
        _unTips.sd_layout
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(line, 10*ScrenScale)
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
    if ([paidModel.product_type isEqualToString:@"LiveStudio::Course"]) {
        
        _name.text = paidModel.product[@"name"];
        
        _orderInfos.text = [NSString stringWithFormat:@"%@/%@%@/共%@课/%@",[self switchClassType:paidModel.product_type],paidModel.product[@"grade"],paidModel.product[@"subject"],paidModel.product[@"preset_lesson_count"],paidModel.product[@"teacher_name"]];
        
    }else if ([paidModel.product_type isEqualToString:@"LiveStudio::VideoCourse"]){
        _name.text = paidModel.product_video_course[@"name"];
        
        _orderInfos.text = [NSString stringWithFormat:@"%@/%@%@/共%@课/%@",[self switchClassType:paidModel.product_type],paidModel.product_video_course[@"grade"],paidModel.product_video_course[@"subject"],paidModel.product_video_course[@"preset_lesson_count"],paidModel.product_video_course[@"teacher_name"]];
        
    }else if ([paidModel.product_type isEqualToString:@"LiveStudio::InteractiveCourse"]){
        _name.text = paidModel.product_interactive_course[@"name"];
        _orderInfos.text = [NSString stringWithFormat:@"%@/%@%@/共%@课/%@",[self switchClassType:paidModel.product_type],paidModel.product_interactive_course[@"grade"],paidModel.product_interactive_course[@"subject"],paidModel.product_interactive_course[@"preset_lesson_count"],paidModel.product_interactive_course[@"teacher_name"]];
    }
    
    _price.text = [NSString stringWithFormat:@"¥%@",paidModel.amount];
    
    if ([paidModel.status isEqualToString:@"unpaid"]) {
        _status.text = @"等待付款";
    }else if ([paidModel.status isEqualToString:@"shipped"]){
       _status.text = @"交易完成";
    }else if ([paidModel.status isEqualToString:@"canceled"]){
        _status.text = @"已取消";
    }else if ([paidModel.status isEqualToString:@"refunding"]){
        _status.text = @"退款中";
    }else if ([paidModel.status isEqualToString:@"completed"]){
        _status.text = @"交易关闭";
    }else if ([paidModel.status isEqualToString:@"refunded"]){
        self.status.text = @"已退款";
    }
    
    if ([paidModel.product_type isEqualToString:@"LiveStudio::Course"]) {
        //直播课类型
        _unTips.hidden = YES;
        _unTipsImage.hidden = YES;
        _rightButton.hidden = NO;
        
    }else if ([paidModel.product_type isEqualToString:@"LiveStudio::InteractiveLesson"]){
        //一对一课类型
        
        _unTips.hidden = NO;
        _unTipsImage.hidden = NO;
        _rightButton.hidden = YES;
        
    }else{
        //暂定 视频课类型 不能退款的
        
        _unTips.hidden = NO;
        _unTipsImage.hidden = NO;
        _rightButton.hidden = YES;
 
    }
    
}

- (NSString *)switchClassType:(NSString *)type {
    NSString *result;
    
    if ([type isEqualToString:@"LiveStudio::Course"]) {
        result = @"直播课";
    }else if ([type isEqualToString:@"LiveStudio::VideoCourse"]){
        result = @"视频课";
    }else if ([type isEqualToString:@"LiveStudio::InteractiveCourse"]){
        result = @"一对一";
    }
    return result;
}

@end
