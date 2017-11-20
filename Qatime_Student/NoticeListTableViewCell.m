//
//  NoticeListTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/17.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "NoticeListTableViewCell.h"

@implementation NoticeListTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _time = ({
            UILabel *_=[[UILabel alloc]init];
            
            _.font = [UIFont systemFontOfSize:13*ScrenScale];
            _.textColor = TITLECOLOR;
            
            [self.contentView addSubview:_];
            
            _;
        });
        
        _content = ({UILabel *_=[[UILabel alloc]init];
            
            _.font = [UIFont systemFontOfSize:16*ScrenScale];
            _.numberOfLines = 0;
            
            [self.contentView addSubview:_];
          
            _;
        });
        
        _type = ({
            UILabel *_ = [[UILabel alloc]init];
            
            _.layer.borderWidth = 0.8;
            _;
        
        });
        
        
        [self.contentView sd_addSubviews:@[_time,_content]];
        [_content addSubview:_type];
        
        
        _time.sd_layout
        .leftSpaceToView(self.contentView,20)
        .rightSpaceToView(self.contentView,20)
        .topSpaceToView(self.contentView,10)
        .autoHeightRatio(0);
        
        _content.sd_layout
        .leftSpaceToView(self.contentView,20)
        .rightSpaceToView(self.contentView,20)
        .topSpaceToView(_time,10)
        .autoHeightRatio(0);
        
        _type.sd_layout
        .leftEqualToView(_content)
        .topEqualToView(_content)
        .autoHeightRatio(0);
        [_type setSingleLineAutoResizeWithMaxWidth:100];
        
        
        [self setupAutoHeightWithBottomView:_content bottomMargin:10.0];
        
        
    }
    return self;

}

-(void)setModel:(SystemNotice *)model{
    _model = model;
    _time.text = model.created_at;
    _content.text = model.notice_content;

//    //消息类型区别
//    if ([model.action_name isEqualToString:@"start_for_student"]) {
//        //上课
//        _type.text = @" 上课 ";
//        _type.font = [UIFont systemFontOfSize:14*ScrenScale];
//        _type.layer.borderColor = [UIColor colorWithRed:0.41 green:0.6 blue:0.41 alpha:1.0].CGColor;
//        _type.textColor =[UIColor colorWithRed:0.41 green:0.6 blue:0.41 alpha:1.0];
//        
//    }else if ([model.action_name isEqualToString:@"start"]){
//        //开课
//        _type.text = @" 开课 ";
//        _type.font = [UIFont systemFontOfSize:14*ScrenScale];
//        _type.layer.borderColor = [UIColor colorWithRed:0.10 green:0.63 blue:0.90 alpha:1.0].CGColor;
//        _type.textColor =[UIColor colorWithRed:0.10 green:0.63 blue:0.90 alpha:1.0];
//        
//    }else if ([model.action_name isEqualToString:@"change_time"]){
//        //调课
//        _type.text = @" 调课 ";
//        _type.font = [UIFont systemFontOfSize:14*ScrenScale];
//        _type.layer.borderColor = [UIColor colorWithRed:0.99 green:0.60 blue:0.15 alpha:1.0].CGColor;
//        _type.textColor =[UIColor colorWithRed:0.99 green:0.60 blue:0.15 alpha:1.0];
//        
//    }else if ([model.action_name isEqualToString:@"notice_create"]||[model.action_name isEqualToString:@"notice_update"]){
//        //公告
//        _type.text = @" 公告 ";
//        _type.font = [UIFont systemFontOfSize:14*ScrenScale];
//        _type.layer.borderColor = [UIColor colorWithRed:1.00 green:0.69 blue:0.69 alpha:1.0].CGColor;
//        _type.textColor =[UIColor colorWithRed:1.00 green:0.69 blue:0.69 alpha:1.0];
//        
//    }else if ([model.action_name isEqualToString:@"refund_success"]||[model.action_name isEqualToString:@"refund_fail"]){
//        //退款
//        _type.text = @" 退款 ";
//        _type.font = [UIFont systemFontOfSize:14*ScrenScale];
//        _type.layer.borderColor = [UIColor colorWithRed:0.42 green:0.80 blue:0.80 alpha:1.0].CGColor;
//        _type.textColor =[UIColor colorWithRed:0.42 green:0.80 blue:0.80 alpha:1.0];
//        
//    }else if ([model.notificationable_type isEqualToString:@"action_record"]){
//        //小班课程
//        _type.text = @" 小班课程 ";
//        _type.font = [UIFont systemFontOfSize:14*ScrenScale];
//        _type.layer.borderColor = [UIColor colorWithRed:0.47 green:0.05 blue:0.46 alpha:1.0].CGColor;
//        _type.textColor =[UIColor colorWithRed:0.47 green:0.05 blue:0.46 alpha:1.0];
//    }else {
//        //系统
//        _type.text = @" 系统 ";
//        _type.font = [UIFont systemFontOfSize:14*ScrenScale];
//        _type.layer.borderColor = BUTTONRED.CGColor;
//        _type.textColor =BUTTONRED;
//    }
    
    
    
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
