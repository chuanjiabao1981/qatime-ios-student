//
//  VideoClassFullScreenListTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/18.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassFullScreenListTableViewCell.h"

@implementation VideoClassFullScreenListTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;;
        self.backgroundColor = [UIColor clearColor];
        
        //序号
        _numbers = [[UILabel alloc]init];
        [self.contentView addSubview:_numbers];
        _numbers.textColor = [UIColor whiteColor];
        _numbers.font = [UIFont systemFontOfSize:14];
        _numbers.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 10)
        .autoHeightRatio(0);
        [_numbers setSingleLineAutoResizeWithMaxWidth:100];
        
        //课程名
        _className = [[UILabel alloc]init];
        _className.textColor = [UIColor whiteColor];
        _className.font = [UIFont systemFontOfSize:14];
        _className.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_className];
        _className.sd_layout
        .leftSpaceToView(_numbers, 10)
        .topEqualToView(_numbers)
        .bottomEqualToView(_numbers)
        .rightSpaceToView(self.contentView, 15);
        
        [self setupAutoHeightWithBottomView:_className bottomMargin:10];
        
    }
    return self;
}

-(void)setModel:(VideoClass *)model{
    
    _model = model;
    _className.text = model.name;
    
    
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
