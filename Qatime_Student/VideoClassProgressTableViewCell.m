//
//  VideoClassProgressTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassProgressTableViewCell.h"

@implementation VideoClassProgressTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //序号
        _numbers = [[UILabel alloc]init];
        [self.contentView addSubview:_numbers];
        _numbers.textColor = [UIColor blackColor];
        _numbers.font = TITLEFONTSIZE;
        _numbers.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 10)
        .autoHeightRatio(0);
        [_numbers setSingleLineAutoResizeWithMaxWidth:100];
        
        //课程名
        _className = [[UILabel alloc]init];
        _className.textColor = [UIColor blackColor];
        _className.font = TITLEFONTSIZE;
        _className.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_className];
        _className.sd_layout
        .leftSpaceToView(_numbers, 10)
        .topEqualToView(_numbers)
        .bottomEqualToView(_numbers)
        .rightSpaceToView(self.contentView, 15);
        
        //时长
        _duringTime = [[UILabel alloc]init];
        _duringTime.font = TEXT_FONTSIZE;
        _duringTime.textColor = TITLECOLOR;
        [self.contentView addSubview:_duringTime];
        _duringTime.sd_layout
        .topSpaceToView(_className, 10)
        .leftEqualToView(_className)
        .autoHeightRatio(0);
        [_duringTime setSingleLineAutoResizeWithMaxWidth:200];
        
        //观看状态
        _status = [[UILabel alloc]init];
        _status.font = TEXT_FONTSIZE;
        [self.contentView addSubview:_status];
        _status.sd_layout
        .rightSpaceToView(self.contentView, 10)
        .topEqualToView(_duringTime)
        .bottomEqualToView(_duringTime);
        [_status setSingleLineAutoResizeWithMaxWidth:200];
        
        [self setupAutoHeightWithBottomView:_duringTime bottomMargin:10];
        
    }
    return self;
}

-(void)setModel:(VideoClass *)model{
    
    _model = model;
    _className.text = model.name;
    _duringTime.text = [NSString stringWithFormat:@"时长:%@",model.video.format_tmp_duration];
    
    
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
