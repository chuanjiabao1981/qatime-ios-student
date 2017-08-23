//
//  InteractionReplayLessonsTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/23.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "InteractionReplayLessonsTableViewCell.h"

@implementation InteractionReplayLessonsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _name = [[UILabel alloc]init];
        [self.contentView addSubview:_name];
        _name.font = TEXT_FONTSIZE;
        _name.textColor = [UIColor whiteColor];
        _name.textAlignment = NSTextAlignmentLeft;
        _name.sd_layout
        .leftSpaceToView(self.contentView, 12)
        .topSpaceToView(self.contentView, 10)
        .autoHeightRatio(0)
        .rightSpaceToView(self.contentView, 12);
        
        [self setupAutoHeightWithBottomView:_name bottomMargin:10];
        
    }
    return self;
}

-(void)setModel:(InteractionReplayLesson *)model{
    _model = model;
    
    _name.text = model.name;
    
    if (model.isSelected) {
        _name.textColor = BUTTONRED;
    }else{
        _name.textColor = [UIColor whiteColor];
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
