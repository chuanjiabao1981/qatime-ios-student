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
        _content.backgroundColor = [UIColor whiteColor];
        _content.sd_layout
        .leftSpaceToView(self.contentView,10*ScrenScale)
        .rightSpaceToView(self.contentView,10*ScrenScale)
        .topSpaceToView(self.contentView,10*ScrenScale)
        .bottomSpaceToView(self.contentView, 10*ScrenScale);
        
        /* 课程名*/
        _name =[[UILabel alloc]init];
        _name.textColor = [UIColor blackColor];
        _name.font = TITLEFONTSIZE;
        [self.contentView addSubview:_name];
        /* 课程名*/
        _name.sd_layout
        .leftSpaceToView(self.contentView,20*ScrenScale)
        .topSpaceToView(self.contentView,20*ScrenScale)
        .rightSpaceToView(self.contentView,20*ScrenScale)
        .autoHeightRatio(0);

        /**订单课程信息*/
        _orderInfos = [[UILabel alloc]init];
        _orderInfos.textColor = TITLECOLOR;
        _orderInfos.font = TEXT_FONTSIZE;
        [self.contentView addSubview:_orderInfos];
        
        /**订单课程信息*/
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
        .rightSpaceToView(self.contentView,20*ScrenScale)
        .topSpaceToView(line,10*ScrenScale);
        _rightButton.sd_cornerRadius = [NSNumber numberWithInteger:1];
        [_rightButton setupAutoSizeWithHorizontalPadding:15 buttonHeight:30*ScrenScale];
        
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
        .rightSpaceToView(_rightButton,10*ScrenScale)
        .topEqualToView(_rightButton)
        .bottomEqualToView(_rightButton);
        _leftButton.sd_cornerRadius = [NSNumber numberWithInteger:1];
         [_leftButton setupAutoSizeWithHorizontalPadding:15 buttonHeight:30*ScrenScale];
        
        /* 金额*/
        _price=[[UILabel alloc]init];
        _price.font = TEXT_FONTSIZE;
        _price.textColor = [UIColor redColor];
        [self.contentView addSubview:_price];
        /* 金额*/
        _price.sd_layout
        .leftEqualToView(_name)
        .rightSpaceToView(_leftButton,10)
        .centerYEqualToView(_leftButton)
        .autoHeightRatio(0);
        
        [_rightButton updateLayout];
        
        [self setupAutoHeightWithBottomView:_rightButton bottomMargin:20];
        
        
    }
    
    return self;
}

-(void)setUnpaidModel:(Unpaid *)unpaidModel{
    
    _unpaidModel = unpaidModel;
    
    if ([unpaidModel.product_type isEqualToString:@"LiveStudio::Course"]) {
        
        _name.text = unpaidModel.product[@"name"];
        
        _orderInfos.text = [NSString stringWithFormat:@"%@/%@%@/共%@课/%@",[self switchClassType:unpaidModel.product_type],unpaidModel.product[@"grade"],unpaidModel.product[@"subject"],unpaidModel.product[@"preset_lesson_count"],unpaidModel.product[@"teacher_name"]];
        
    }else if ([unpaidModel.product_type isEqualToString:@"LiveStudio::VideoCourse"]){
        _name.text = unpaidModel.product_video_course[@"name"];
        
        _orderInfos.text = [NSString stringWithFormat:@"%@/%@%@/共%@课/%@",[self switchClassType:unpaidModel.product_type],unpaidModel.product_video_course[@"grade"],unpaidModel.product_video_course[@"subject"],unpaidModel.product_video_course[@"preset_lesson_count"],unpaidModel.product_video_course[@"teacher_name"]];
        
    }else if ([unpaidModel.product_type isEqualToString:@"LiveStudio::InteractiveCourse"]){
        _name.text = unpaidModel.product_interactive_course[@"name"];
        
        _orderInfos.text = [NSString stringWithFormat:@"%@/%@%@/共%@课/%@",[self switchClassType:unpaidModel.product_type],unpaidModel.product_interactive_course[@"grade"],unpaidModel.product_interactive_course[@"subject"],unpaidModel.product_interactive_course[@"preset_lesson_count"],unpaidModel.product_interactive_course[@"teacher_name"]];
    }else{
        _name.text = unpaidModel.product_customized_group[@"name"];
        _orderInfos.text = [NSString stringWithFormat:@"%@/%@%@/共%@课/%@",[self switchClassType:unpaidModel.product_type],unpaidModel.product_customized_group[@"grade"],unpaidModel.product_customized_group[@"subject"],unpaidModel.product_customized_group[@"events_count"],unpaidModel.teacher_name];
    }


    _price.text = [NSString stringWithFormat:@"¥%@",unpaidModel.amount];

    if ([unpaidModel.status isEqualToString:@"unpaid"]) {
        _status.text = @"等待付款";
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

- (NSString *)switchClassType:(NSString *)type {
    NSString *result;
    
    if ([type isEqualToString:@"LiveStudio::Course"]) {
        result = @"直播课";
    }else if ([type isEqualToString:@"LiveStudio::VideoCourse"]){
        result = @"视频课";
    }else if ([type isEqualToString:@"LiveStudio::InteractiveCourse"]){
        result = @"一对一";
    }else{
        result = @"专属课";
    }
    return result;
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
