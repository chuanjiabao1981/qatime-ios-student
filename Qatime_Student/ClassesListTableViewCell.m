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
//    /* 状态原点图*/
//    @property(nonatomic,strong) UIImageView *circle ;
//    
//    /* 课程名称*/
//    @property(nonatomic,strong) UILabel *className ;
//    
//    
//    /* 上课时间*/
//    @property(nonatomic,strong) UILabel *classDate;
//    
//    @property(nonatomic,strong) UILabel *classTime ;
//    
//    /* 课程状态*/
//    @property(nonatomic,strong) UILabel *status ;
//    @property(nonatomic,strong) NSString *class_status ;
//    
//    
//    /* 数据model 用来计算高度*/
//    @property(nonatomic,strong) ClassesInfo_Time *model ;
//    
    
    _className.text = _model.name;
    _classDate .text = _model.class_date;
    _classTime .text = _model.live_time;
    _status.text = _model.status;
    
    
    
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
