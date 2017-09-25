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
        
//        _canReplay = NO;
        
    }
        
    return self;
    
    
}



- (void)setupViews{
    
    
    /* 原点布局*/
    _tips = [[UIImageView alloc]init];
    [_tips setImage:[UIImage imageNamed:@"菱形"]];

    /* 课程名称label 布局*/
    
    _className = [[UILabel alloc]init];
    _className.font = TEXT_FONTSIZE;
    
    
    /* 课程时间*/
    _classDate = [[UILabel alloc]init];
    [_classDate setFont:[UIFont systemFontOfSize:14*ScrenScale]];
    _classDate.textColor = [UIColor lightGrayColor];
    
    _classTime = [[UILabel alloc]init];
     [_classTime setFont:[UIFont systemFontOfSize:14*ScrenScale]];
    _classTime.textColor = [UIColor lightGrayColor];
    
    /* 课程状态*/
    _status = [[UILabel alloc]init];
    _status.textColor = TITLECOLOR;
    _status.font = [UIFont systemFontOfSize:15*ScrenScale];
    
    _class_status = @"".mutableCopy;
    
    
    
    /* 回放次数*/
    _replay = [[UIButton alloc]init];
    [_replay setTitleColor:BUTTONRED forState:UIControlStateNormal];
    [_replay.titleLabel setFont:[UIFont systemFontOfSize:14*ScrenScale]];
    
    
    /* 全部进行布局*/
    [self.contentView sd_addSubviews:@[_className,_tips,_classDate,_classTime,_status,_replay]];
    
    _className.sd_layout
    .leftSpaceToView(self.contentView,30)
    .topSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .autoHeightRatio(0);
    _className.numberOfLines = 0;
    
    _tips.sd_layout
    .widthIs(15)
    .heightIs(15)
    .centerYEqualToView(_className)
    .leftSpaceToView(self.contentView,10);
    
    _classDate.sd_layout
    .leftEqualToView(_className)
    .topSpaceToView(_className,10)
    .autoHeightRatio(0);
    [_classDate setSingleLineAutoResizeWithMaxWidth:200];
    
    _classTime.sd_layout
    .leftSpaceToView(_classDate,10)
    .topEqualToView(_classDate)
    .autoHeightRatio(0);
    [_classTime setSingleLineAutoResizeWithMaxWidth:300];
    
    _status.sd_layout
    .leftEqualToView(_className)
    .topSpaceToView(_classDate,5)
    .autoHeightRatio(0);
    [_status setSingleLineAutoResizeWithMaxWidth:100];
    
    _replay.sd_layout
    .centerYEqualToView(_status)
    .rightEqualToView(_className)
    .leftSpaceToView(_status,0)
    .autoHeightRatio(0);
    _replay.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    
    
    [self setupAutoHeightWithBottomView:_status bottomMargin:10];
    
    
}


-(void)setModel:(ClassesInfo_Time *)model{
    
    _model = model;
    
    _className.text = _model.name;
    _classDate .text = _model.class_date;
    _classTime .text = _model.live_time;
//    _status.text = _model.status;
    
    
    /* 已开课的状态*/

    if ([_model.status isEqualToString:@"init"]) {
        _status.text =@"未开始";
        _class_status = [NSString stringWithFormat:@"未开始"];
    }else if([_model.status isEqualToString:@"ready"]){
        _status.text =@"待上课";
        _class_status = [NSString stringWithFormat:@"待上课"];
    }else if([_model.status isEqualToString:@"teaching"]){
        _status.text =@"直播中";
        _class_status = [NSString stringWithFormat:@"直播中"];
    }else if([_model.status isEqualToString:@"closed"]){
        _status.text =@"已直播";
        _class_status = [NSString stringWithFormat:@"已直播"];
    }else if([_model.status isEqualToString:@"finished"]){
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }else if([_model.status isEqualToString:@"pause"]){
        _status.text =@"暂停中";
        _class_status = [NSString stringWithFormat:@"暂停中"];
    }else if([_model.status isEqualToString:@"missed"]){
        _status.text =@"待补课";
        _class_status = [NSString stringWithFormat:@"待补课"];
    }else if([_model.status isEqualToString:@"billing"]){
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }else if([_model.status isEqualToString:@"completed"]){
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }
    
    
    
    
//    if ([_model.status isEqualToString:@"teaching"]||[_model.status isEqualToString:@"pause"]||[ _model.status isEqualToString:@"closed"]) {
//        
//        _status.text =@"已开课";
//        _class_status = [NSString stringWithFormat:@"已开课"];
//        
//    }else if ([_model.status isEqualToString:@"missed"]||[_model.status isEqualToString:@"init"]||[_model.status isEqualToString:@"ready"]){
//        _status.text = @"未开课";
//        _class_status = [NSString stringWithFormat:@"未开课"];
//
//    }else if ([_model.status isEqualToString:@"finished"]||[_model.status isEqualToString:@"billing"]||[_model.status isEqualToString:@"completed"]){
//        
//        _status.text = @"已结束";
//        
//        _class_status = [NSString stringWithFormat:@"已结束"];
//        
//    }else if ([_model.status isEqualToString:@"public"]){
//        
//        _status.text = @"招生中";
//        _class_status = [NSString stringWithFormat:@"招生中"];
//        
//    }
    
//    if (model.replayable == YES) {
//        
//        _canReplay = YES;
//    }else{
//        _canReplay = NO;
//    }
    
    [_replay setTitle:[NSString stringWithFormat:@"还可回放%@次›",_model.left_replay_times] forState:UIControlStateNormal];
    
}

- (void)setClassModel:(Classes *)classModel{
    
    _classModel = classModel;
    _className.text = classModel.name;
    _classDate .text = classModel.class_date;
    _classTime .text = classModel.live_time;
    /* 已开课的状态*/
    
    if ([classModel.status isEqualToString:@"init"]) {
        _status.text =@"未开始";
        _class_status = [NSString stringWithFormat:@"未开始"];
    }else if([classModel.status isEqualToString:@"ready"]){
        _status.text =@"待上课";
        _class_status = [NSString stringWithFormat:@"待上课"];
    }else if([classModel.status isEqualToString:@"teaching"]){
        _status.text =@"直播中";
        _class_status = [NSString stringWithFormat:@"直播中"];
    }else if([classModel.status isEqualToString:@"closed"]){
        _status.text =@"已直播";
        _class_status = [NSString stringWithFormat:@"已直播"];
    }else if([classModel.status isEqualToString:@"finished"]){
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }else if([classModel.status isEqualToString:@"pause"]){
        _status.text =@"暂停中";
        _class_status = [NSString stringWithFormat:@"暂停中"];
    }else if([classModel.status isEqualToString:@"missed"]){
        _status.text =@"待补课";
        _class_status = [NSString stringWithFormat:@"待补课"];
    }else if([classModel.status isEqualToString:@"billing"]){
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }else if([classModel.status isEqualToString:@"completed"]){
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }
    
    
//    if ([classModel.status isEqualToString:@"teaching"]||[classModel.status isEqualToString:@"pause"]) {
//        _status.text =@"已开课";
//        _class_status = [NSString stringWithFormat:@"已开课"];
//    }else if ([classModel.status isEqualToString:@"closed"]){
//        _status.text = @"已直播";
//        _class_status = [NSString stringWithFormat:@"已直播"];
//    }else if ([classModel.status isEqualToString:@"missed"]){
//        _status.text = @"待补课";
//        _class_status = [NSString stringWithFormat:@"待补课"];
//    }else if ([classModel.status isEqualToString:@"finished"]||[classModel.status isEqualToString:@"billing"]||[_classModel.status isEqualToString:@"completed"]){
//        _status.text = @"已结束";
//        
//        _class_status = [NSString stringWithFormat:@"已结束"];
//    }else if ([classModel.status isEqualToString:@"public"]){
//        _status.text = @"招生中";
//        _class_status = [NSString stringWithFormat:@"招生中"];
//    }else if ([classModel.status isEqualToString:@"teaching"]||[classModel.status isEqualToString:@"paused"]){
//        _status.text = @"直播中";
//        _class_status = [NSString stringWithFormat:@"直播中"];
//
//    }
    
//    if (classModel.replayable == YES) {
//        
//        _canReplay = YES;
//    }else{
//        _canReplay = NO;
//    }
    
    
    [_replay setTitle:[NSString stringWithFormat:@"还可回放%@次›",classModel.left_replay_times] forState:UIControlStateNormal];
    
    
}

-(void)setInteractionModel:(OneOnOneClass *)interactionModel{
    
    _interactionModel = interactionModel;
    _className.text = _interactionModel.name;
    _classDate .text = _interactionModel.class_date;
    _classTime .text = [NSString stringWithFormat:@"%@ - %@",_interactionModel.start_time,_interactionModel.end_time];
    /* 已开课的状态*/
    
    if ([_interactionModel.status isEqualToString:@"init"]) {
        _status.text =@"未开始";
        _class_status = [NSString stringWithFormat:@"未开始"];
    }else if([_interactionModel.status isEqualToString:@"ready"]){
        _status.text =@"待上课";
        _class_status = [NSString stringWithFormat:@"待上课"];
    }else if([_interactionModel.status isEqualToString:@"teaching"]){
        _status.text =@"直播中";
        _class_status = [NSString stringWithFormat:@"直播中"];
    }else if([_interactionModel.status isEqualToString:@"closed"]){
        _status.text =@"已直播";
        _class_status = [NSString stringWithFormat:@"已直播"];
    }else if([_interactionModel.status isEqualToString:@"finished"]){
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }else if([_interactionModel.status isEqualToString:@"pause"]){
        _status.text =@"暂停中";
        _class_status = [NSString stringWithFormat:@"暂停中"];
    }else if([_interactionModel.status isEqualToString:@"missed"]){
        _status.text =@"待补课";
        _class_status = [NSString stringWithFormat:@"待补课"];
    }else if([_interactionModel.status isEqualToString:@"billing"]){
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }else if([_interactionModel.status isEqualToString:@"completed"]){
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }

}

-(void)setInteractiveModel:(InteractionLesson *)interactiveModel{
    
    _interactiveModel = interactiveModel;
    
    _className.text = interactiveModel.name;
    _classDate .text = interactiveModel.class_date;
    _classTime .text = [NSString stringWithFormat:@"%@ - %@",interactiveModel.start_time,interactiveModel.end_time];
    /* 已开课的状态*/
    
    if ([interactiveModel.status isEqualToString:@"init"]) {
        _status.text =@"未开始";
        _class_status = [NSString stringWithFormat:@"未开始"];
    }else if([interactiveModel.status isEqualToString:@"ready"]){
        _status.text =@"待上课";
        _class_status = [NSString stringWithFormat:@"待上课"];
    }else if([interactiveModel.status isEqualToString:@"teaching"]){
        _status.text =@"直播中";
        _class_status = [NSString stringWithFormat:@"直播中"];
    }else if([interactiveModel.status isEqualToString:@"closed"]){
        _status.text =@"已直播";
        _class_status = [NSString stringWithFormat:@"已直播"];
    }else if([interactiveModel.status isEqualToString:@"finished"]){
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }else if([interactiveModel.status isEqualToString:@"pause"]){
        _status.text =@"暂停中";
        _class_status = [NSString stringWithFormat:@"暂停中"];
    }else if([interactiveModel.status isEqualToString:@"missed"]){
        _status.text =@"待补课";
        _class_status = [NSString stringWithFormat:@"待补课"];
    }else if([interactiveModel.status isEqualToString:@"billing"]){
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }else if([interactiveModel.status isEqualToString:@"completed"]){
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }

    
}


-(void)setExclusiveModel:(ExclusiveLesson *)exclusiveModel{
    
    _exclusiveModel = exclusiveModel;
    
    _className.text = exclusiveModel.name;
    _classDate .text = exclusiveModel.class_date;
    _classTime .text = [NSString stringWithFormat:@"%@",exclusiveModel.start_time];
    
    /* 已开课的状态*/
    if ([exclusiveModel.status isEqualToString:@"init"]) {
        _status.text =@"未开始";
        _class_status = [NSString stringWithFormat:@"未开始"];
    }else if([exclusiveModel.status isEqualToString:@"ready"]){
        _status.text =@"待上课";
        _class_status = [NSString stringWithFormat:@"待上课"];
    }else if([exclusiveModel.status isEqualToString:@"teaching"]){
        _status.text =@"直播中";
        _class_status = [NSString stringWithFormat:@"直播中"];
    }else if([exclusiveModel.status isEqualToString:@"closed"]){
        _status.text =@"已直播";
        _class_status = [NSString stringWithFormat:@"已直播"];
    }else if([exclusiveModel.status isEqualToString:@"finished"]){
        _status.textColor = TITLECOLOR;
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }else if([exclusiveModel.status isEqualToString:@"pause"]){
        _status.text =@"暂停中";
        _class_status = [NSString stringWithFormat:@"暂停中"];
    }else if([exclusiveModel.status isEqualToString:@"missed"]){
        _status.text =@"待补课";
        _class_status = [NSString stringWithFormat:@"待补课"];
    }else if([exclusiveModel.status isEqualToString:@"billing"]){
        _status.textColor = TITLECOLOR;
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }else if([exclusiveModel.status isEqualToString:@"completed"]){
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }
}


- (void)switchStatus:(ExclusiveLesson *)exclusiveModel{
    
    /* 已开课的状态*/
    if ([exclusiveModel.status isEqualToString:@"init"]) {
        _status.text =@"未开始";
        _class_status = [NSString stringWithFormat:@"未开始"];
    }else if([exclusiveModel.status isEqualToString:@"ready"]){
        _status.text =@"待上课";
        _class_status = [NSString stringWithFormat:@"待上课"];
    }else if([exclusiveModel.status isEqualToString:@"teaching"]){
        _status.text =@"直播中";
        _class_status = [NSString stringWithFormat:@"直播中"];
    }else if([exclusiveModel.status isEqualToString:@"closed"]){
        _status.text =@"已直播";
        _class_status = [NSString stringWithFormat:@"已直播"];
    }else if([exclusiveModel.status isEqualToString:@"finished"]){
        _status.textColor = TITLECOLOR;
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }else if([exclusiveModel.status isEqualToString:@"pause"]){
        _status.text =@"暂停中";
        _class_status = [NSString stringWithFormat:@"暂停中"];
    }else if([exclusiveModel.status isEqualToString:@"missed"]){
        _status.text =@"待补课";
        _class_status = [NSString stringWithFormat:@"待补课"];
    }else if([exclusiveModel.status isEqualToString:@"billing"]){
        _status.textColor = TITLECOLOR;
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }else if([exclusiveModel.status isEqualToString:@"completed"]){
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }

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
