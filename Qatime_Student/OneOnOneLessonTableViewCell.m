//
//  OneOnOneLessonTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/1.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "OneOnOneLessonTableViewCell.h"
#import "NSString+StatusSwitch.h"

@interface OneOnOneLessonTableViewCell  (){
    
    UIImageView *_image;
    
}

@end

@implementation OneOnOneLessonTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView .autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //课程名
        _lessonName = [[UILabel alloc]init];
        _lessonName.font = TEXT_FONTSIZE;
        _lessonName.textColor = [UIColor blackColor];
        [self.contentView addSubview:_lessonName];
        _lessonName.sd_layout
        .leftSpaceToView(self.contentView, 30*ScrenScale)
        .topSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 10)
        .autoHeightRatio(0);
        
        //菱形图
        _image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"播放"]];
        [self.contentView addSubview:_image];
        _image.sd_layout
        .widthIs(15)
        .heightIs(15)
        .centerYEqualToView(self.lessonName)
        .leftSpaceToView(self.contentView,10);
        
        //日期
        _date = [[UILabel alloc]init];
        _date.font = [UIFont systemFontOfSize:14*ScrenScale];
        _date.textColor = TITLECOLOR;
        [self.contentView addSubview:_date];
        _date.sd_layout
        .topSpaceToView(_lessonName, 10)
        .leftSpaceToView(self.contentView, 30)
        .autoHeightRatio(0);
        [_date setSingleLineAutoResizeWithMaxWidth:2000];
        
        //状态
        _status = [[UILabel alloc]init];
        _status.textColor = [UIColor lightGrayColor];
        _status.font = TEXT_FONTSIZE;
        [self.contentView addSubview:_status];
        _status.sd_layout
        .topSpaceToView(_date, 10)
        .leftEqualToView(_lessonName)
        .autoHeightRatio(0);
        [_status setSingleLineAutoResizeWithMaxWidth:100];
        
        [self setupAutoHeightWithBottomView:_status bottomMargin:10];
        
    }
    return self;
}

#pragma mark- SetModel

-(void)setModel:(InteractionLesson *)model{
    
    _model = model;
    
    _lessonName.text = model.name;
    _date.text = [NSString stringWithFormat:@"%@ %@ - %@ | 老师:%@",model.class_date,model.start_time,model.end_time,model.teacher.name];
    _status.text = [NSString statusSwitchWithStatus:model.status];
    //暂时不做一对一回放功能.
//    if ([[NSString statusSwitchWithStatus:model.status] isEqualToString:@"已结束"]) {
//        if (@"replayable") {
//            _status.textColor = BUTTONRED;
//            _status.text = @"观看回放";
//        }else{
//            _status.textColor = TITLECOLOR;
//        }
//    }else{
        self.status.textColor = [UIColor blackColor];
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
