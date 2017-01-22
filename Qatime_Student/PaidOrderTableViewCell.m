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
        
        /* 科目*/
        _subject=[[UILabel alloc]init];
        _subject.textColor = [UIColor lightGrayColor];
        
        /* 年级*/
        _grade=[[UILabel alloc]init];
        _grade.textColor = [UIColor lightGrayColor];
        
        UILabel *totl = [[UILabel alloc]init];
        totl.text = @"/共";
        totl.textColor = [UIColor lightGrayColor];
        
        
        
        UILabel *tot = [[UILabel alloc]init];
        tot.text = @"课/";
        tot.textColor = [UIColor lightGrayColor];
        //
        
        /* 课时*/
        _classTime=[[UILabel alloc]init];
        _classTime.textColor = [UIColor lightGrayColor];
        
        /* 教师姓名*/
        _teacherName=[[UILabel alloc]init];
        _teacherName.textColor = [UIColor lightGrayColor];
        
        /* 支付状态*/
        _status=[[UILabel alloc]init];
        _status.textColor = [UIColor blueColor];
        
        /* 金额*/
        _price=[[UILabel alloc]init];
        _price.textColor = [UIColor redColor];
        
        
        /* 左侧button*/
        _leftButton = [[UIButton alloc]init];
        _leftButton.layer.borderColor = [UIColor blackColor].CGColor;
        _leftButton.layer.borderWidth = 0.8;
        [_leftButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        /* 右侧button*/
        _rightButton = [[UIButton alloc]init];
        _rightButton.layer.borderColor = [UIColor redColor].CGColor;
        _rightButton.layer.borderWidth = 0.8;
        [_rightButton setTitle:@"付款" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        
        /* 布局*/
        [self.contentView sd_addSubviews:@[_name,_subject,_grade,_classTime,totl,tot,_teacherName,_status,_price,_leftButton,_rightButton]];
        
        /* 课程名*/
        
        _name.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
        .autoHeightRatio(0);
        
        /*科目*/
        _subject.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(_name,10)
        .autoHeightRatio(0);
        [_subject setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 年级*/
        _grade.sd_layout
        .leftSpaceToView(_subject,0)
        .topEqualToView(_subject)
        .bottomEqualToView(_subject);
        [_grade setSingleLineAutoResizeWithMaxWidth:100];
        
        
        
        /* 课时*/
        
        totl.sd_layout
        .leftSpaceToView(_grade,0)
        .topEqualToView(_grade)
        .bottomEqualToView(_grade);
        [totl setSingleLineAutoResizeWithMaxWidth:100.0];
        
        [_classTime clearAutoHeigtSettings];
        
        _classTime.sd_resetLayout
        .leftSpaceToView(totl,0)
        .topEqualToView(_grade)
        .autoHeightRatio(0);
        [_classTime setSingleLineAutoResizeWithMaxWidth:80.0];
        _classTime .textAlignment = NSTextAlignmentLeft;
        
        
        tot.sd_layout
        .leftSpaceToView(_classTime,1)
        .topEqualToView(_grade)
        .bottomEqualToView(_grade);
        [tot setSingleLineAutoResizeWithMaxWidth:100.0];
        
        
        /* 老师姓名*/
        _teacherName.sd_layout
        .leftSpaceToView(tot,0)
        .topEqualToView(_classTime)
        .bottomEqualToView(_classTime)
        .widthRatioToView(self.contentView,0.3);
        _teacherName.textAlignment = NSTextAlignmentLeft;
        
        
        
        /* 状态*/
        
        _status.sd_layout
        
        .rightSpaceToView(self.contentView,10)
        .topEqualToView(_teacherName)
        .leftSpaceToView(_teacherName,20)
        .bottomEqualToView(_teacherName);
//        [_status setSingleLineAutoResizeWithMaxWidth:1000];
        _status.textAlignment = NSTextAlignmentRight;
        
        
        /* 右按钮*/
        _rightButton.sd_layout
        .rightSpaceToView(self.contentView,10)
        .topSpaceToView(_status,10)
        .widthRatioToView(self.contentView,1/5.0)
        .autoHeightRatio(1/3.0);
        
        
        /* 左按钮*/
        _leftButton.sd_layout
        .rightSpaceToView(_rightButton,10)
        .topEqualToView(_rightButton)
        .bottomEqualToView(_rightButton)
        .heightRatioToView(_rightButton,1.0)
        .widthRatioToView(_rightButton,1.0);
        
        
        /* 金额*/
        _price.sd_layout
        .leftSpaceToView(self.contentView,10)
        .rightSpaceToView(_leftButton,10)
        .centerYEqualToView(_leftButton)
        .autoHeightRatio(0);
        
        [self setupAutoHeightWithBottomView:_leftButton bottomMargin:10];
        
        
    }
    
    return self;
}


-(void)setPaidModel:(Paid *)paidModel{
    
    _paidModel = paidModel;
    _classTime .text = paidModel.preset_lesson_count ;
    _name.text = paidModel.name;
    _subject.text = paidModel.subject;
    _grade.text = paidModel.grade;
    _teacherName.text = paidModel.teacher_name;
    
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
    
}

@end
