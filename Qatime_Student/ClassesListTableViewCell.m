//
//  ClassesListTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ClassesListTableViewCell.h"
#import "ClassesInfo_Time.h"



@implementation ClassesListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupViews];
        
       
        
        
        
    }
    
    
    
    return self;
    
    
}



- (void)setupViews{
    
    
    /* 原点布局*/
    _circle = [[UIImageView alloc]init];
    
//    [self.contentView addSubview:_circle];
//    _circle.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.contentView,10).widthIs(20).heightEqualToWidth();
    
    /* 课程名称label 布局*/
    
    _className = [[UILabel alloc]init];
//    [self.contentView addSubview:_className];
//    _className.sd_layout.leftSpaceToView(_circle,10).topSpaceToView(self.contentView,10).hei
    
    
    /* 课程时间*/
    _classDate = [[UILabel alloc]init];
    [_classDate setFont:[UIFont systemFontOfSize:14*ScrenScale]];
    _classDate.textColor = [UIColor lightGrayColor];
    
    _classTime = [[UILabel alloc]init];
     [_classTime setFont:[UIFont systemFontOfSize:14*ScrenScale]];
    _classTime.textColor = [UIColor lightGrayColor];
    
    /* 课程状态*/
    _status = [[UILabel alloc]init];
    _class_status = @"".mutableCopy;
    
    
    
    /* 全部进行布局*/
    [self.contentView sd_addSubviews:@[_circle,_className,_classDate,_classTime,_status]];
    
    _circle.sd_layout
    .widthIs(10)
    .heightIs(10)
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView,10);
    
    _status.sd_layout
    .rightSpaceToView(self.contentView,10)
    .centerYEqualToView(self.contentView)
    .autoHeightRatio(0);
    [_status setSingleLineAutoResizeWithMaxWidth:100];
    
    _className.sd_layout
    .leftSpaceToView(_circle,10)
    .topSpaceToView(self.contentView,10)
    .rightSpaceToView(_status,10)
    .autoHeightRatio(0);
    _className.numberOfLines = 0;
    
    _classDate.sd_layout
    .leftEqualToView(_className)
    .topSpaceToView(_className,5)
    .autoHeightRatio(0);
    [_classDate setSingleLineAutoResizeWithMaxWidth:200];
    
    _classTime.sd_layout
    .leftSpaceToView(_classDate,10)
    .topEqualToView(_classDate)
    .autoHeightRatio(0);
    [_classTime setSingleLineAutoResizeWithMaxWidth:300];
    
    
    
    
    [self setupAutoHeightWithBottomView:_classTime bottomMargin:10];
    
    
}


-(void)setModel:(ClassesInfo_Time *)model{
    
    _model = model;
    
    _className.text = _model.name;
    _classDate .text = _model.class_date;
    _classTime .text = _model.live_time;
//    _status.text = _model.status;
    
    /* 已开课的状态*/
    if ([_model.status isEqualToString:@"teaching"]||[_model.status isEqualToString:@"pause"]||[ _model.status isEqualToString:@"closed"]) {
        
        _status.text =@"已开课";
        _class_status = [NSString stringWithFormat:@"已开课"];
        
    }else if ([_model.status isEqualToString:@"missed"]||[_model.status isEqualToString:@"init"]||[_model.status isEqualToString:@"ready"]){
        _status.text = @"未开课";
        _class_status = [NSString stringWithFormat:@"未开课"];

    }else if ([_model.status isEqualToString:@"finished"]||[_model.status isEqualToString:@"billing"]||[_model.status isEqualToString:@"completed"]){
        
        _status.text = @"已结束";
        
        _class_status = [NSString stringWithFormat:@"已结束"];
        
    }else if ([_model.status isEqualToString:@"public"]){
        
        _status.text = @"招生中";
        _class_status = [NSString stringWithFormat:@"招生中"];
        
    }

    
    
    
}

- (void)setClassModel:(Classes *)classModel{
    
    
    _classModel = classModel;
    
    _className.text = _classModel.name;
    _classDate .text = _classModel.class_date;
    _classTime .text = _classModel.live_time;
    _status.text = _classModel.status;

    
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
