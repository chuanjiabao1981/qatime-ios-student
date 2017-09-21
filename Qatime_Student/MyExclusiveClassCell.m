//
//  MyExclusiveClassCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MyExclusiveClassCell.h"
#import "NSString+TimeStamp.h"

@implementation MyExclusiveClassCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /* contentview的裁边*/
        _content = [[UIView alloc]init];
        _content.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_content];
        _content .sd_layout
        .leftSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,5)
        .bottomSpaceToView(self.contentView,5);
        _content.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        _content.layer.borderWidth = 0.8f;
        
        /* 课程图片*/
        _classImage = [[UIImageView alloc]init];
        [_content addSubview:_classImage];
        _classImage.sd_layout
        .topEqualToView(_content)
        .bottomEqualToView(_content)
        .leftEqualToView(_content)
        .autoWidthRatio(1.0);
        
        /* 课程名称*/
        _className = [[UILabel alloc]init];
        _className.font = TEXT_FONTSIZE;
        [_content addSubview:_className];
        _className.sd_layout
        .leftSpaceToView(_classImage,10*ScrenScale)
        .topSpaceToView(_content, 5*ScrenScale)
        .rightSpaceToView(_content,10*ScrenScale)
        .autoHeightRatio(0);
        
        //其他信息
        _classInfo = [[UILabel alloc]init];
        [_content addSubview:_classInfo];
        _classInfo.font = TEXT_FONTSIZE;
        _classInfo.sd_layout
        .leftEqualToView(_className)
        .centerYEqualToView(_classImage)
        .rightEqualToView(_className)
        .autoHeightRatio(0);
        _classInfo.textAlignment = NSTextAlignmentLeft;
        
        _status = [[UILabel alloc]init];
        [_content addSubview:_status];
        _status.font = TEXT_FONTSIZE;
        _status.sd_layout
        .leftEqualToView(_className)
        .rightEqualToView(_className)
        .bottomSpaceToView(_content, 5*ScrenScale)
        .autoHeightRatio(0);
        _status.textAlignment = NSTextAlignmentLeft;
        
        
    }
    return self;
}

-(void)setClassType:(ClassType)classType{
    
    if (classType == PublisedClass) {
        /* 计算距开课时间*/
        //创建日期格式化对象
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        /* 视频开始时间*/
        NSDate *startDate=[dateFormatter dateFromString:[self changeTimeStampToDateString:_model.customized_group.start_at]];
        /* 当前时间*/
        NSDate *nowDate=[NSDate date];
        //取两个日期对象的时间间隔：
        NSTimeInterval time = [nowDate timeIntervalSinceDate:startDate];
        int days=((int)time)/(3600*24);
        if (days>=1) {
            _status.text = [NSString stringWithFormat:@"距开课%d天",days];
        }else if (days>/* DISABLES CODE */ (0)&&days<1){
            _status.text = @"即将开课";
        }else if (days<0){
            _status.text = @"已经开课";
        }
        
    }else if (classType == TeachingClass){
       
        _status.text = [[[@"进度" stringByAppendingString:_model.customized_group.closed_events_count] stringByAppendingString:@"/"] stringByAppendingString:_model.customized_group.events_count];
        
    }else{
        _status.text = @"全部课程已完成";
        
    }
    
}

- (NSString *)changeTimeStampToDateString:(NSString *)timeString{
    
    NSTimeInterval time=[timeString doubleValue];//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSLog(@"date:%@",[detaildate description]);
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //这句话比较吊
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}


-(void)setModel:(MyExclusiveClass *)model{
    
    _model = model;
    [_classImage sd_setImageWithURL:[NSURL URLWithString:model.customized_group.publicizes_url[@"list"]]];
    _className.text = model.customized_group.name;
    _classInfo.text = [[[model.customized_group.grade stringByAppendingString:model.customized_group.subject]stringByAppendingString:@"/"]stringByAppendingString:model.customized_group.teacher_name];
    
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
