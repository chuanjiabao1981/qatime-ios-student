//
//  HomeworkInfoTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "HomeworkInfoTableViewCell.h"

@interface HomeworkInfoTableViewCell (){
    
    UILabel *_myLabel;
    
    UILabel *_teacherLabel;
}

@end

@implementation HomeworkInfoTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _index = [[UILabel alloc]init];
        [self.contentView addSubview:_index];
        _index .font = TEXT_FONTSIZE;
        _index.textColor = [UIColor blackColor];
        _index.sd_layout
        .leftSpaceToView(self.contentView, 12*ScrenScale)
        .topSpaceToView(self.contentView, 10*ScrenScale)
        .autoHeightRatio(0);
        [_index setSingleLineAutoResizeWithMaxWidth:200];
        
        _title =[[UILabel alloc]init];
        [self.contentView addSubview:_title];
        _title .font = TEXT_FONTSIZE;
        _title.textColor = [UIColor blackColor];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.sd_layout
        .leftSpaceToView(_index, 10*ScrenScale)
        .topSpaceToView(self.contentView, 10*ScrenScale)
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .autoHeightRatio(0);
        
        _status = [[UILabel alloc]init];
        [self.contentView addSubview:_status];
        _status .font = TEXT_FONTSIZE;
        _status.textColor = [UIColor blackColor];
        _status.sd_layout
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(_title, 10*ScrenScale)
        .autoHeightRatio(0);
        [_status setSingleLineAutoResizeWithMaxWidth:300];
        
        
        _myLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_myLabel];
        _myLabel.font = TEXT_FONTSIZE;
        _myLabel.textColor = [UIColor blackColor];
        _myLabel.sd_layout
        .leftEqualToView(_index)
        .topSpaceToView(_title, 10*ScrenScale)
        .autoHeightRatio(0);
        [_myLabel setSingleLineAutoResizeWithMaxWidth:300];
        _myLabel.text = @"我的答案:";
        _myLabel.hidden = YES;
        
        _answerTitle =[[UILabel alloc]init];
        [self.contentView addSubview:_answerTitle];
        _answerTitle.font = TEXT_FONTSIZE;
        _answerTitle.textColor = [UIColor blackColor];
        _answerTitle.sd_layout
        .leftEqualToView(_index)
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(_myLabel, 10*ScrenScale)
        .autoHeightRatio(0);
        _answerTitle.hidden = YES;
        
        //老师批改的 头
        _teacherLabel =[[UILabel alloc]init];
        [self.contentView addSubview:_teacherLabel];
        _teacherLabel.font = TEXT_FONTSIZE;
        _teacherLabel.textColor = [UIColor blackColor];
        _teacherLabel.sd_layout
        .leftEqualToView(_index)
        .topSpaceToView(_answerTitle, 10*ScrenScale)
        .autoHeightRatio(0);
        [_teacherLabel setSingleLineAutoResizeWithMaxWidth:300];
        _teacherLabel.text = @"批改结果";
        _teacherLabel.hidden = YES;
        
        //老师批改的内容
        _teacherCheckTitle=[[UILabel alloc]init];
        [self.contentView addSubview:_teacherCheckTitle];
        _teacherCheckTitle.font = TEXT_FONTSIZE;
        _teacherCheckTitle.textColor = [UIColor blackColor];
        _teacherCheckTitle.sd_layout
        .leftEqualToView(_index)
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(_teacherLabel, 10*ScrenScale)
        .autoHeightRatio(0);
        _teacherCheckTitle.hidden = YES;
        
       
    }
    return self;
}

-(void)setModel:(HomeworkInfo *)model{
    
    _model = model;
    
    _title.text = model.body;
    
    if ([model.status isEqualToString:@"pending"]) {
        //未提交过作业
        if (model.edited == YES) {
            //如果已经写过答案了,那就把答案显示出来,别的不显示,可以再次编辑
            _status.hidden = YES;
            _myLabel.hidden = NO;
            _answerTitle.hidden = NO;
            _answerTitle.text = model.myAnswerTitle;
            
            _teacherLabel.hidden = YES;
            _teacherCheckTitle.hidden = YES;
            [self setupAutoHeightWithBottomView:_answerTitle bottomMargin:10*ScrenScale];
            
        }else{
            //如果没写过答案,就让他写答案去
            _status.hidden = NO;
            _myLabel.hidden = YES;
            _answerTitle.hidden = YES;
            _teacherLabel.hidden = YES;
            _teacherCheckTitle.hidden = YES;
            _status.text = @"做作业";
            _status.textColor = [UIColor redColor];
            [self setupAutoHeightWithBottomView:_status bottomMargin:10*ScrenScale];
        }
        
        
    }else if ([model.status isEqualToString:@"submitted"]){
        //如果已经是提交过的作业,而且还没有批改的,只能看
        _status.hidden = YES;
        _myLabel.hidden = NO;
        _answerTitle.hidden = NO;
        
        _teacherLabel.hidden = YES;
        _teacherCheckTitle.hidden = YES;
        
        _answerTitle.text = model.myAnswerTitle; //暂时这么写
        [self setupAutoHeightWithBottomView:_answerTitle bottomMargin:10*ScrenScale];
        
    }else if ([model.status isEqualToString:@"resolved"]){
        //已经批改过的 啥都显示啥都能看
        _status.hidden = YES;
        _myLabel.hidden = NO;
        _answerTitle.hidden = NO;
        _teacherLabel.hidden = NO;
        _teacherCheckTitle.hidden = NO;
        _answerTitle.text = model.myAnswerTitle;
        _teacherCheckTitle.text = model.correction;
        [self setupAutoHeightWithBottomView:_teacherCheckTitle bottomMargin:10*ScrenScale];
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
