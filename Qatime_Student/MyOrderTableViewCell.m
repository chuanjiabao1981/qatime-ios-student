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
        
        /* 课程名*/
        _name =[[UILabel alloc]init];
        _name.textColor = [UIColor blackColor];
        
        /* 科目*/
        _subject=[[UILabel alloc]init];
        _subject.textColor = [UIColor lightGrayColor];
        
        /* 年级*/
        _grade=[[UILabel alloc]init];
        _grade.textColor = [UIColor lightGrayColor];
        
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
        [_rightButton setTitle:@"申请退款" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

        
        /* 布局*/
        [self.contentView sd_addSubviews:@[_name,_subject,_grade,_classTime,_teacherName,_status,_price,_leftButton,_rightButton]];
        
        /* 课程名*/
        
        _name.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
        .autoHeightRatio(0);
        
        
        
        

        
        
        
        
        
        
        
    }
    
    return self;
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
